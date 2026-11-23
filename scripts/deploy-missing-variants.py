#!/usr/bin/env python3
"""Fill missing image variants referenced by the homepage (hero slides, gift box, 1400-width gaps).
Hero masters come ONLY from the approved folder helsa-photo-edits/hero-banner-v1."""
from pathlib import Path
from PIL import Image, features

OPT = Path("/home/user/helsa/public/images/opt")
HERO_SRC = Path("/home/user/helsa-photo-edits/hero-banner-v1")
has_avif = features.check("avif")

def save(im, dst, fmt):
    dst = Path(dst)
    if fmt == "webp": im.save(dst, "WEBP", quality=84, method=6)
    elif fmt == "avif": im.save(dst, "AVIF", quality=58)
    else: im.save(dst, "JPEG", quality=92, optimize=True, progressive=True)

def variants(master: Image.Image, stem: str, widths):
    save(master, OPT / f"{stem}.jpg", "jpg")
    save(master, OPT / f"{stem}.webp", "webp")
    if has_avif: save(master, OPT / f"{stem}.avif", "avif")
    for w in widths:
        im = master.copy()
        im.thumbnail((w, w), Image.LANCZOS)
        save(im, OPT / f"{stem}-{w}.webp", "webp")
        if has_avif: save(im, OPT / f"{stem}-{w}.avif", "avif")

# 1) hero slides: full sets (480/768/1080/1400 referenced in srcSet)
for stem in ["hero-piarom", "hero-mazafati", "hero-date-chocolate", "hero-nuts-dried-fruits", "hero-mazeh-tray"]:
    src = Image.open(HERO_SRC / f"{stem}.jpg").convert("RGB")
    print(f"{stem}: master {src.size}")
    variants(src, stem, (480, 768, 1080, 1400))
    print(f"  ✓ full set")

# 2) gift-classic-box: master exists as jpg — add webp/avif master + 480/768/1080
src = Image.open(OPT / "gift-classic-box.jpg").convert("RGB")
print(f"gift-classic-box: master {src.size} (existing)")
save(src, OPT / "gift-classic-box.webp", "webp")
if has_avif: save(src, OPT / "gift-classic-box.avif", "avif")
for w in (480, 768, 1080):
    im = src.copy(); im.thumbnail((w, w), Image.LANCZOS)
    save(im, OPT / f"gift-classic-box-{w}.webp", "webp")
    if has_avif: save(im, OPT / f"gift-classic-box-{w}.avif", "avif")
print("  ✓ gift variants")

# 3) 1400-width gaps for existing product masters
for stem in ["handmade-date-chocolate", "dried-figs"]:
    src = Image.open(OPT / f"{stem}.jpg").convert("RGB")
    im = src.copy(); im.thumbnail((1400, 1400), Image.LANCZOS)
    save(im, OPT / f"{stem}-1400.webp", "webp")
    if has_avif: save(im, OPT / f"{stem}-1400.avif", "avif")
    print(f"  ✓ {stem}-1400")
print("done")
