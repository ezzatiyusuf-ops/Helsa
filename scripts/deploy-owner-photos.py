#!/usr/bin/env python3
"""Deploy owner's edited photos (final-v2, approved edits) to product image slots.
Keeps existing stems (no broken refs); adds gallery -2/-3 variants."""
from pathlib import Path
from PIL import Image, features

SRC = Path("/home/user/helsa-photo-edits/final-v2")
OPT = Path("/home/user/helsa/public/images/opt")
has_avif = features.check("avif")
SIZES = (480, 768, 1080, 1400)

# slug → (main master, [gallery masters in order → -2, -3])
MAPPING = {
    "handmade-date-chocolate": ("01-IMG_3596.jpg", ["02-IMG_3598.jpg"]),
    "date-chocolate-walnut":   ("04-IMG_3601.jpg", ["05-IMG_3602.jpg"]),
    "chocolate-coated-dates":  ("03-IMG_3599.jpg", []),
    "dried-figs":              ("06-1.jpg",        ["07-2.jpg"]),
    "walnut-kernels":          ("08-3.jpg",        ["09-4.jpg"]),
    "golden-raisins":          ("10-7.jpg",        ["11-8.jpg"]),
    "lahijan-black-tea":       ("12-IMG_3467.jpg", ["15-tg3.jpg", "13-tg1.jpg"]),
}

def save(im, dst, fmt):
    if fmt == "webp": im.save(dst, "WEBP", quality=84, method=6)
    elif fmt == "avif": im.save(dst, "AVIF", quality=58)
    else: im.save(dst, "JPEG", quality=90, optimize=True, progressive=True)

def emit(master: Image.Image, stem: str):
    save(master, OPT / f"{stem}.jpg", "jpg")
    save(master, OPT / f"{stem}.webp", "webp")
    if has_avif: save(master, OPT / f"{stem}.avif", "avif")
    for w in SIZES:
        im = master.copy(); im.thumbnail((w, w), Image.LANCZOS)
        save(im, OPT / f"{stem}-{w}.webp", "webp")
        if has_avif: save(im, OPT / f"{stem}-{w}.avif", "avif")

count = 0
for slug, (main, extras) in MAPPING.items():
    im = Image.open(SRC / main).convert("RGB")
    emit(im, slug); count += 1
    print(f"✓ {slug} ← {main} ({im.size[0]}x{im.size[1]})")
    for i, g in enumerate(extras, start=2):
        gm = Image.open(SRC / g).convert("RGB")
        emit(gm, f"{slug}-{i}"); count += 1
        print(f"  gallery -{i} ← {g}")
print(f"done: {count} stems × 11 files = {count*11}")
