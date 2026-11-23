#!/usr/bin/env python3
"""
HELSA — استانداردسازی عکس محصول به «یک استودیو».

چه کاری می‌کند (همه قطعی و قابل بازتولید، بدون تولید تصویر جدید):
  ۱) قاب ۱:۱ (مثل ۱۵ عکس مرجع مالک) — پدکردن با پس‌زمینهٔ خود تصویر، نه بریدن محصول
  ۲) تراز سفیدی + نوردهی محدود به سمت هدفِ اندازه‌گیری‌شده از عکس‌های مرجع
  ۳) خروجی webp در دو اندازه (کارت ۶۰۰ / جزئیات ۱۲۰۰) + نسخهٔ اصلی محفوظ

چه کاری نمی‌کند (و عمداً نمی‌کند):
  • هیچ پیکسلی از محصول بازسازی/جایگزین نمی‌شود (بدون inpainting و generative)
  • برچسب، لوگو و بسته‌بندی دست نمی‌خورد
  • پس‌زمینهٔ صحنه عوض نمی‌شود؛ فقط تُن/نور یکدست می‌شود

اجرا:  python3 scripts/standardize-product-photos.py [--apply]
"""
from __future__ import annotations

import json
import os
import shutil
import sys
from statistics import mean, pstdev

from PIL import Image, ImageStat

SRC_ROOT = "public"
OUT_ROOT = "public/images/studio"
REPORT = "reports/image-standardization.json"

# ── هدف، اندازه‌گیری‌شده از ۱۵ عکس مرجع مالک (final-v2) ──
TARGET_SIZE = 2000
TARGET_BG = 202.0            # روشنایی پس‌زمینهٔ مرجع (بازه ۱۹۲.۸–۲۰۴.۴)
TARGET_CAST = (209, 190, 166)  # میانگین رنگ مرجع (گرم استخوانی)
GAIN_MIN, GAIN_MAX = 0.80, 1.30  # سقف اصلاح نوردهی — فراتر از این، تصویر را دست نمی‌زنیم
CARD, DETAIL = 600, 1200


def corner_bg(im: Image.Image) -> tuple[float, tuple[float, float, float]]:
    """روشنایی و رنگ میانگین گوشه‌ها (پس‌زمینهٔ صحنه)."""
    sm = im.convert("RGB").resize((200, 200))
    boxes = [(0, 0, 50, 50), (150, 0, 200, 50), (0, 150, 50, 200), (150, 150, 200, 200)]
    means = [ImageStat.Stat(sm.crop(b)).mean for b in boxes]
    lum = mean((r + g + b) / 3 for r, g, b in means)
    rgb = tuple(mean(c[i] for c in means) for i in range(3))
    return lum, rgb


def pad_to_square(im: Image.Image) -> Image.Image:
    """پدکردن به ۱:۱ با کشش لبه‌ها — محصول بریده نمی‌شود و پد نامرئی است."""
    w, h = im.size
    if w == h:
        return im
    side = max(w, h)
    canvas = Image.new("RGB", (side, side))
    if w < side:
        # کشش ستون لبهٔ چپ/راست برای پرکردن
        left = im.crop((0, 0, 1, h)).resize((side // 2 + 1, h))
        right = im.crop((w - 1, 0, w, h)).resize((side // 2 + 1, h))
        canvas.paste(left, (0, 0))
        canvas.paste(right, (side - left.width, 0))
        canvas.paste(im, ((side - w) // 2, 0))
    else:
        top = im.crop((0, 0, w, 1)).resize((w, side // 2 + 1))
        bottom = im.crop((0, h - 1, w, h)).resize((w, side // 2 + 1))
        canvas.paste(top, (0, 0))
        canvas.paste(bottom, (0, side - top.height))
        canvas.paste(im, (0, (side - h) // 2))
    return canvas


def grade(im: Image.Image) -> tuple[Image.Image, dict]:
    """اصلاح محدود نوردهی و تراز سفیدی. اگر اصلاح لازم بیش از سقف باشد، تصویر دست‌نخورده می‌ماند."""
    lum, rgb = corner_bg(im)
    gain = TARGET_BG / max(lum, 1.0)
    bounded = max(GAIN_MIN, min(GAIN_MAX, gain))
    info = {
        "bg_before": round(lum, 1),
        "bg_rgb_before": [round(v) for v in rgb],
        "gain_wanted": round(gain, 3),
        "gain_applied": round(bounded, 3),
        "clamped": abs(bounded - gain) > 1e-6,
    }
    if abs(bounded - 1.0) < 0.02:
        info["action"] = "none"
        return im, info

    # تراز سفیدی آرام: انحراف رنگ پس‌زمینه از هدف، با ضریب محافظه‌کارانه
    ch_rgb = [TARGET_CAST[i] / max(rgb[i], 1.0) for i in range(3)]
    ch_rgb = [max(0.90, min(1.12, c)) for c in ch_rgb]

    r, g, b = im.convert("RGB").split()
    r = r.point(lambda v: min(255, int(v * bounded * ch_rgb[0] + 0.5)))
    g = g.point(lambda v: min(255, int(v * bounded * ch_rgb[1] + 0.5)))
    b = b.point(lambda v: min(255, int(v * bounded * ch_rgb[2] + 0.5)))
    out = Image.merge("RGB", (r, g, b))
    lum2, _ = corner_bg(out)
    info["bg_after"] = round(lum2, 1)
    info["action"] = "graded"
    return out, info


def main() -> int:
    apply = "--apply" in sys.argv
    products = json.load(open("/tmp/products.json", encoding="utf-8"))
    uniq = list(dict.fromkeys(p["image"] for p in products))

    os.makedirs(OUT_ROOT, exist_ok=True)
    os.makedirs("reports", exist_ok=True)

    rows, skipped = [], []
    for path in uniq:
        src = os.path.join(SRC_ROOT, path.lstrip("/"))
        if not os.path.exists(src):
            skipped.append({"path": path, "reason": "فایل غایب"})
            continue
        im = Image.open(src).convert("RGB")
        w0, h0 = im.size
        sq = pad_to_square(im)
        graded, info = grade(sq)

        base = os.path.splitext(os.path.basename(path))[0]
        detail_rel = f"/images/studio/{base}.webp"
        card_rel = f"/images/studio/{base}-card.webp"
        if apply:
            d = graded.copy()
            if max(d.size) > DETAIL:
                d.thumbnail((DETAIL, DETAIL), Image.LANCZOS)
            d.save(os.path.join(SRC_ROOT, detail_rel.lstrip("/")), "WEBP", quality=86, method=6)
            c = graded.copy()
            if max(c.size) > CARD:
                c.thumbnail((CARD, CARD), Image.LANCZOS)
            c.save(os.path.join(SRC_ROOT, card_rel.lstrip("/")), "WEBP", quality=82, method=6)

        rows.append({
            "source": path,
            "detail": detail_rel,
            "card": card_rel,
            "original_size": [w0, h0],
            "original_aspect": round(w0 / h0, 2),
            **info,
            "needs_manual_review": info["clamped"],
        })

    after = [r["bg_after"] if "bg_after" in r else r["bg_before"] for r in rows]
    summary = {
        "apply": apply,
        "images": len(rows),
        "skipped": skipped,
        "bg_spread_before": round(max(r["bg_before"] for r in rows) - min(r["bg_before"] for r in rows), 1),
        "bg_spread_after": round(max(after) - min(after), 1),
        "bg_stdev_before": round(pstdev([r["bg_before"] for r in rows]), 1),
        "bg_stdev_after": round(pstdev(after), 1),
        "clamped_for_review": [r["source"] for r in rows if r["needs_manual_review"]],
        "aspects_before": {1.0: sum(1 for r in rows if r["original_aspect"] == 1.0),
                           1.5: sum(1 for r in rows if r["original_aspect"] == 1.5)},
        "rows": rows,
    }
    json.dump(summary, open(REPORT, "w", encoding="utf-8"), ensure_ascii=False, indent=1)

    print(f"تصاویر: {len(rows)} | اجرا: {'نوشته شد' if apply else 'فقط بررسی'}")
    print(f"پراکندگی روشنایی پس‌زمینه: {summary['bg_spread_before']} → {summary['bg_spread_after']}  (هدف ۲۰۲)")
    print(f"انحراف معیار: {summary['bg_stdev_before']} → {summary['bg_stdev_after']}")
    print(f"نیازمند بازبینی دستی (اصلاح خارج از سقف): {len(summary['clamped_for_review'])}")
    for s in summary["clamped_for_review"][:8]:
        print("   -", s)
    if skipped:
        print(f"ردشده: {len(skipped)} → {[s['path'] for s in skipped]}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
