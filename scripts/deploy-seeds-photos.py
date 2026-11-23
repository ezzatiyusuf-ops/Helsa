#!/usr/bin/env python3
"""Create opt variant sets for japanese-seeds / mixed-seeds from owned source photos.
No background replacement (full-frame macro shots) — resize/format only."""
from pathlib import Path
from PIL import Image, features

JOBS = [("public/images/src-japanese.jpg", "japanese-seeds"), ("public/images/src-mixed.jpg", "mixed-seeds")]
OPT = Path("public/images/opt")
WIDTHS = (480, 768, 1080)

def save(im, dst, fmt, q):
    if fmt == "webp": im.save(dst, "WEBP", quality=q, method=6)
    elif fmt == "avif": im.save(dst, "AVIF", quality=q)
    else: im.save(dst, "JPEG", quality=92, optimize=True, progressive=True)

has_avif = features.check("avif")
for src_name, stem in JOBS:
    src = Image.open(src_name).convert("RGB")
    print(f"{stem}: source {src_name} {src.size}")
    save(src, OPT / f"{stem}.jpg", "jpg", 92)
    save(src, OPT / f"{stem}.webp", "webp", 84)
    if has_avif: save(src, OPT / f"{stem}.avif", "avif", 58)
    for w in WIDTHS:
        im = src.copy(); im.thumbnail((w, w), Image.LANCZOS)
        save(im, OPT / f"{stem}-{w}.webp", "webp", 84)
        if has_avif: save(im, OPT / f"{stem}-{w}.avif", "avif", 58)
    print(f"  ✓ {stem} variants done (avif={'yes' if has_avif else 'no'})")
print("done")
