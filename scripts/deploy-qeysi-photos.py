#!/usr/bin/env python3
"""Deploy qeysi (style-A) finals into public/images/opt with the same variant set
as the other studio shots: {stem}.jpg/.webp/.avif + 480/768/1080 webp/avif."""
from pathlib import Path
from PIL import Image, features

SRC = Path("/home/user/helsa-qeysi/final-a")
OPT = Path("/home/user/helsa/public/images/opt")
JOBS = [("qeysi-1.webp", "qeysi"), ("qeysi-2.jpg", "qeysi-2")]
WIDTHS = (480, 768, 1080)

def save(im: Image.Image, dst: Path, fmt: str, q: int) -> None:
    if fmt == "webp":
        im.save(dst, "WEBP", quality=q, method=6)
    elif fmt == "avif":
        im.save(dst, "AVIF", quality=q)
    else:
        im.save(dst, "JPEG", quality=92, optimize=True, progressive=True)

has_avif = features.check("avif")
for src_name, stem in JOBS:
    src = Image.open(SRC / src_name).convert("RGB")
    print(f"{stem}: source {src_name} {src.size}")
    save(src, OPT / f"{stem}.jpg", "jpg", 92)
    save(src, OPT / f"{stem}.webp", "webp", 84)
    if has_avif:
        save(src, OPT / f"{stem}.avif", "avif", 58)
    for w in WIDTHS:
        im = src.copy()
        im.thumbnail((w, w), Image.LANCZOS)
        save(im, OPT / f"{stem}-{w}.webp", "webp", 84)
        if has_avif:
            save(im, OPT / f"{stem}-{w}.avif", "avif", 58)
    print(f"  ✓ variants written for {stem} (avif={'yes' if has_avif else 'no'})")
print("done")
