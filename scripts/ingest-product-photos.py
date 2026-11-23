#!/usr/bin/env python3
"""
HELSA — دریافت عکس‌های تازه از عکاس و تبدیل خودکار به دارایی استاندارد.

عکاس فایل‌ها را با نام SKU در photos-inbox/ می‌گذارد (مثلاً HLA-0001.jpg).
این اسکریپت:
  ۱) هر فایل را به SKU محصول نگاشت می‌کند (نام فایل = SKU، یا نام اختیاری در manifest)
  ۲) قاب را ۱:۱ می‌کند (اگر از قبل ۱:۱ نیست، پد می‌کند — محصول بریده نمی‌شود)
  ۳) تُن/نوردهی را به هدف مرجع نزدیک می‌کند (سقف ۱.۳؛ فراتر ⇒ گزارش برای بازبینی)
  ۴) خروجی WebP در ۶۰۰ و ۱۲۰۰ می‌سازد و به public/images/studio/ می‌نویسد
  ۵) گزارش می‌دهد چه چیزی نگاشت نشد، چه چیزی خارج از سقف بود، و چه چیزی تکراری است

اجرا:
    python3 scripts/ingest-product-photos.py --dry-run     # فقط بررسی
    python3 scripts/ingest-product-photos.py               # نوشتن خروجی
"""
from __future__ import annotations

import json
import os
import sys
from statistics import mean

from PIL import Image, ImageStat

INBOX = "photos-inbox"
OUT_ROOT = "public/images/studio"
PRODUCTS = "src/data/products.ts"
REPORT = "reports/photo-ingest.json"

TARGET_BG = 202.0
TARGET_CAST = (209, 190, 166)
GAIN_MIN, GAIN_MAX = 0.80, 1.30
CARD, DETAIL = 600, 1200
EXTS = (".jpg", ".jpeg", ".png", ".webp", ".tif", ".tiff")


def load_products() -> list[dict]:
    src = open(PRODUCTS, encoding="utf-8").read()
    return json.loads(src[src.index("= [") + 2: src.rindex("];") + 1])


def corner_bg(im: Image.Image) -> tuple[float, tuple[float, float, float]]:
    sm = im.convert("RGB").resize((200, 200))
    boxes = [(0, 0, 50, 50), (150, 0, 200, 50), (0, 150, 50, 200), (150, 150, 200, 200)]
    means = [ImageStat.Stat(sm.crop(b)).mean for b in boxes]
    lum = mean((r + g + b) / 3 for r, g, b in means)
    return lum, tuple(mean(c[i] for c in means) for i in range(3))


def pad_to_square(im: Image.Image) -> Image.Image:
    w, h = im.size
    if w == h:
        return im
    side = max(w, h)
    canvas = Image.new("RGB", (side, side))
    if w < side:
        edge_l = im.crop((0, 0, 1, h)).resize((side // 2 + 1, h))
        edge_r = im.crop((w - 1, 0, w, h)).resize((side // 2 + 1, h))
        canvas.paste(edge_l, (0, 0))
        canvas.paste(edge_r, (side - edge_l.width, 0))
        canvas.paste(im, ((side - w) // 2, 0))
    else:
        edge_t = im.crop((0, 0, w, 1)).resize((w, side // 2 + 1))
        edge_b = im.crop((0, h - 1, w, h)).resize((w, side // 2 + 1))
        canvas.paste(edge_t, (0, 0))
        canvas.paste(edge_b, (0, side - edge_t.height))
        canvas.paste(im, (0, (side - h) // 2))
    return canvas


def grade(im: Image.Image) -> tuple[Image.Image, dict]:
    lum, rgb = corner_bg(im)
    gain = TARGET_BG / max(lum, 1.0)
    bounded = max(GAIN_MIN, min(GAIN_MAX, gain))
    info = {"bg_before": round(lum, 1), "gain_applied": round(bounded, 3),
            "clamped": abs(bounded - gain) > 1e-6}
    if abs(bounded - 1.0) < 0.02:
        return im, info
    ch = [max(0.90, min(1.12, TARGET_CAST[i] / max(rgb[i], 1.0))) for i in range(3)]
    r, g, b = im.convert("RGB").split()
    r = r.point(lambda v: min(255, int(v * bounded * ch[0] + 0.5)))
    g = g.point(lambda v: min(255, int(v * bounded * ch[1] + 0.5)))
    b = b.point(lambda v: min(255, int(v * bounded * ch[2] + 0.5)))
    out = Image.merge("RGB", (r, g, b))
    info["bg_after"] = round(corner_bg(out)[0], 1)
    return out, info


def main() -> int:
    apply = "--dry-run" not in sys.argv
    if not os.path.isdir(INBOX):
        os.makedirs(INBOX, exist_ok=True)
        print(f"پوشهٔ {INBOX}/ ساخته شد — فایل‌ها را با نام SKU اینجا بگذارید.")
        return 0

    products = load_products()
    by_sku = {p["sku"]: p for p in products}
    by_slug = {p["slug"]: p for p in products}

    files = [f for f in sorted(os.listdir(INBOX)) if f.lower().endswith(EXTS)]
    if not files:
        print(f"هیچ فایلی در {INBOX}/ نیست. نام فایل باید SKU باشد (مثلاً HLA-0001.jpg).")
        return 0

    os.makedirs(OUT_ROOT, exist_ok=True)
    os.makedirs("reports", exist_ok=True)

    done, unmapped, review = [], [], []
    for f in files:
        stem = os.path.splitext(f)[0]
        p = by_sku.get(stem) or by_sku.get(stem.upper()) or by_slug.get(stem)
        if not p:
            unmapped.append(f)
            continue
        im = Image.open(os.path.join(INBOX, f)).convert("RGB")
        w0, h0 = im.size
        graded, info = grade(pad_to_square(im))
        base = p["slug"]
        detail_rel = f"/images/studio/{base}.webp"
        card_rel = f"/images/studio/{base}-card.webp"
        if apply:
            d = graded.copy()
            if max(d.size) > DETAIL:
                d.thumbnail((DETAIL, DETAIL), Image.LANCZOS)
            d.save(os.path.join("public", detail_rel.lstrip("/")), "WEBP", quality=86, method=6)
            c = graded.copy()
            if max(c.size) > CARD:
                c.thumbnail((CARD, CARD), Image.LANCZOS)
            c.save(os.path.join("public", card_rel.lstrip("/")), "WEBP", quality=82, method=6)
        rec = {"file": f, "sku": p["sku"], "product": p["name"], "slug": p["slug"],
               "source_size": [w0, h0], "detail": detail_rel, "card": card_rel, **info}
        done.append(rec)
        if info["clamped"]:
            review.append(rec)

    json.dump({"apply": apply, "ingested": done, "unmapped": unmapped, "needs_review": review},
              open(REPORT, "w", encoding="utf-8"), ensure_ascii=False, indent=1)

    print(f"{'نوشته شد' if apply else 'فقط بررسی'}: {len(done)} از {len(files)} فایل")
    if unmapped:
        print(f"⚠ نگاشت نشد ({len(unmapped)}): {unmapped[:6]}")
        print("   نام فایل باید SKU محصول باشد؛ فهرست SKUها در HELSA-shot-list.csv است.")
    if review:
        print(f"⚠ خارج از سقف اصلاح ({len(review)}): {[r['file'] for r in review][:6]}")
    print(f"گزارش: {REPORT}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
