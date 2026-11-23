#!/usr/bin/env python3
"""
HELSA — خروجی نسخه‌های وب از تصاویر استودیویی + پشتیبان اصل‌ها.

برای هر تصویر تأییدشده:
  - detail : 1800×1800  JPG (q92)  — صفحهٔ محصول
  - 1200   : 1200×1200  WebP (q86) — دسکتاپ
  - 600    : 600×600    WebP (q84) — کارت محصول
  - 400    : 400×400    WebP (q82) — موبایل
  - AVIF   : 1200 و 600 اگر کتابخانه پشتیبانی کند

اصل‌ها در پوشهٔ جداگانهٔ پشتیبان کپی می‌شوند و هرگز بازنویسی نمی‌گردند.
"""
from __future__ import annotations

import json
import shutil
from pathlib import Path

from PIL import Image, features

SRC_DIR = Path("helsa-studio")
ORIG_DIR = Path("helsa/public/images/opt")
BACKUP = Path("helsa-photo-backup/originals")
OUT = Path("helsa-studio/web")

SIZES = [(1200, "webp", 86), (600, "webp", 84), (400, "webp", 82)]
AVIF_SIZES = [1200, 600]


def main() -> None:
    report = json.loads((SRC_DIR / "report.json").read_text(encoding="utf-8"))
    ok = [r for r in report if r["ok"]]

    BACKUP.mkdir(parents=True, exist_ok=True)
    OUT.mkdir(parents=True, exist_ok=True)

    has_avif = features.check("avif") if hasattr(features, "check") else False
    counts = {"jpg": 0, "webp": 0, "avif": 0, "backup": 0}

    for r in ok:
        stem = Path(r["out"]).stem
        im = Image.open(r["out"]).convert("RGB")

        # detail
        im.save(OUT / f"{stem}.jpg", "JPEG", quality=92, optimize=True, progressive=True)
        counts["jpg"] += 1

        for w, fmt, q in SIZES:
            v = im.copy()
            v.thumbnail((w, w), Image.LANCZOS)
            v.save(OUT / f"{stem}-{w}.{fmt}", fmt.upper(), quality=q, method=6)
            counts["webp"] += 1

        if has_avif:
            for w in AVIF_SIZES:
                v = im.copy()
                v.thumbnail((w, w), Image.LANCZOS)
                try:
                    v.save(OUT / f"{stem}-{w}.avif", "AVIF", quality=60)
                    counts["avif"] += 1
                except Exception:
                    pass

        # پشتیبان اصل
        src = Path(r["src"])
        dst = BACKUP / src.name
        if not dst.exists():
            shutil.copy2(src, dst)
            counts["backup"] += 1

    print(f"✓ detail JPG : {counts['jpg']}")
    print(f"✓ WebP       : {counts['webp']}  (1200/600/400)")
    print(f"✓ AVIF       : {counts['avif']}" + ("" if has_avif else "  — کتابخانه پشتیبانی نمی‌کند"))
    print(f"✓ پشتیبان اصل: {counts['backup']}  → {BACKUP}")
    total = sum(f.stat().st_size for f in OUT.iterdir())
    print(f"  حجم کل نسخه‌های وب: {total/1e6:.1f} MB")


if __name__ == "__main__":
    main()
