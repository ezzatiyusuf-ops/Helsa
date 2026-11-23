#!/usr/bin/env python3
"""
HELSA — استایل‌دهی عکس‌های مالک به «استایل کاتالوگ» (کشمش سبز).

منبع: عکس‌های اصلی مالک در uploads/ (هیچ‌وقت دست نمی‌خورند)
خروجی: helsa-qeysi/final-a/  (۳ کراپ × detail/card برای jpg و webp)

اصل کار: تطبیق پروفایل تُن عکس با پروفایل اندازه‌گیری‌شدهٔ مرجع کاتالوگ
(public/images/opt/golden-raisins.jpg). هیچ چیزی به محصول اضافه یا از آن حذف
نمی‌شود؛ فقط نوردهی/کنتراست/اشباع/تعادل رنگ تنظیم می‌شود.

اجرا:
    python3 scripts/qeysi-style.py            # ساخت همه
    python3 scripts/qeysi-style.py --report   # فقط اندازه‌گیری
"""
from __future__ import annotations

import argparse
import os
import sys

import numpy as np
from PIL import Image, ImageEnhance, ImageFilter

SRC_DIR = "uploads"
OUT_DIR = "helsa-qeysi/final-a"

# پروفایل مرجع: public/images/opt/golden-raisins.jpg، اندازه‌گیری‌شده با PIL
# (روشنایی، کنتراست p95-p5، اشباع میانگین HSV، رنگ میانگین RGB)
REFERENCE = {
    "lum": 153.3,
    "contrast": 146.0,
    "sat": 0.255,
    "rgb": np.array([169.5, 148.9, 141.4]),
}

# کراپ مربعی (x1, y1, x2, y2) پس از بازبینی چشمی برای بهترین کادربندی
JOBS = {
    "qeysi-1": ("IMG_3876", (430, 720, 2624, 3024)),
    "qeysi-2": ("IMG_3877", (900, 1300, 2160, 2560)),
    "qeysi-3": ("IMG_3878", (840, 1340, 2100, 2600)),
}

DETAIL_MAX = 2000
CARD_MAX = 600


def measure(im: Image.Image) -> dict:
    """سنجش روشنایی/کنتراست/اشباع/رنگ میانگین یک تصویر."""
    a = np.asarray(im, dtype=float)
    lum = a.mean(axis=2)
    mx, mn = a.max(axis=2), a.min(axis=2)
    sat = np.where(mx > 0, (mx - mn) / np.maximum(mx, 1), 0)
    return {
        "lum": float(lum.mean()),
        "contrast": float(np.percentile(lum, 95) - np.percentile(lum, 5)),
        "sat": float(sat.mean()),
        "rgb": a.reshape(-1, 3).mean(axis=0),
    }


def square_crop(im: Image.Image, box: tuple[int, int, int, int]) -> Image.Image:
    """کراپ مربعی با محدودکردن کادر به مرزهای تصویر."""
    x1, y1, x2, y2 = box
    edge = min(x2 - x1, y2 - y1, im.width - x1, im.height - y1)
    return im.crop((x1, y1, x1 + edge, y1 + edge))


def to_catalog_style(im: Image.Image) -> Image.Image:
    """تطبیق تُن با مرجع کاتالوگ، بدون تغییر محتوای تصویر."""
    s = measure(im)
    a = np.asarray(im, dtype=float)

    # ۱) نوردهی کلی
    a = a * (REFERENCE["lum"] / max(s["lum"], 1.0))
    # ۲) کنتراست حول میانگین
    a = (a - a.mean()) * (REFERENCE["contrast"] / max(s["contrast"], 1.0)) + a.mean()
    a = np.clip(a, 0, 252)

    out = Image.fromarray(a.astype(np.uint8))
    # ۳) اشباع، محدود تا رنگ واقعی میوه از بین نرود
    out = ImageEnhance.Color(out).enhance(
        max(0.55, min(1.6, REFERENCE["sat"] / max(s["sat"], 1e-6)))
    )
    # ۴) تعادل رنگ، محافظه‌کارانه (±۱۲٪)
    mean_rgb = np.asarray(out, dtype=float).reshape(-1, 3).mean(axis=0)
    gain = np.clip(REFERENCE["rgb"] / np.maximum(mean_rgb, 1.0), 0.92, 1.12)
    out = Image.fromarray(np.clip(np.asarray(out, dtype=float) * gain, 0, 252).astype(np.uint8))

    # ۵) شارپ ملایم برای حس کاتالوگ (بدون هاله)
    return out.filter(ImageFilter.UnsharpMask(radius=1.2, percent=55, threshold=3))


def save_variants(im: Image.Image, stem: str, out_dir: str) -> list[str]:
    written = []
    detail = im.copy()
    detail.thumbnail((DETAIL_MAX, DETAIL_MAX), Image.LANCZOS)
    card = im.copy()
    card.thumbnail((CARD_MAX, CARD_MAX), Image.LANCZOS)

    for img, suffix, jq, wq in (
        (detail, "", 93, 86),
        (card, "-card", 89, 82),
    ):
        jpg = os.path.join(out_dir, f"{stem}{suffix}.jpg")
        webp = os.path.join(out_dir, f"{stem}{suffix}.webp")
        img.save(jpg, "JPEG", quality=jq, optimize=True)
        img.save(webp, "WEBP", quality=wq, method=6)
        written += [jpg, webp]
    return written


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--report", action="store_true", help="فقط اندازه‌گیری، بدون نوشتن فایل")
    args = ap.parse_args()

    if not args.report:
        os.makedirs(OUT_DIR, exist_ok=True)

    for stem, (src, box) in JOBS.items():
        path = os.path.join(SRC_DIR, f"{src}.jpeg")
        if not os.path.exists(path):
            print(f"✗ پیدا نشد: {path}", file=sys.stderr)
            return 1

        base = square_crop(Image.open(path).convert("RGB"), box)
        styled = to_catalog_style(base)
        before, after = measure(base), measure(styled)

        print(
            f"{stem}: روشنایی {before['lum']:.1f} → {after['lum']:.1f} · "
            f"کنتراست {before['contrast']:.1f} → {after['contrast']:.1f} · "
            f"اشباع {before['sat']:.3f} → {after['sat']:.3f}"
        )
        if not args.report:
            for f in save_variants(styled, stem, OUT_DIR):
                print(f"  ✓ {f}")

    print(f"مرجع: روشنایی {REFERENCE['lum']} · کنتراست {REFERENCE['contrast']} · اشباع {REFERENCE['sat']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
