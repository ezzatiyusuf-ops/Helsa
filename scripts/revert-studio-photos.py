#!/usr/bin/env python3
"""
HELSA — بازگرداندن تصاویر سایت به نسخهٔ قبل از استودیو

از پشتیبان `helsa-photo-backup/site-originals/` فایل‌ها را برمی‌گرداند و
واریانت‌هایی را که ما اضافه کرده بودیم حذف می‌کند.

اجرا:
    python3 scripts/revert-studio-photos.py --dry-run
    python3 scripts/revert-studio-photos.py
"""
from __future__ import annotations

import argparse
import shutil
from pathlib import Path

OPT = Path("/home/user/helsa/public/images/opt")
BACKUP = Path("/home/user/helsa-photo-backup/site-originals")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    if not BACKUP.exists():
        print(f"✗ پشتیبانی وجود ندارد: {BACKUP}")
        return

    files = sorted(BACKUP.glob("*.jpg"))
    print(f"▸ {len(files)} فایل پشتیبان")

    restored = 0
    for src in files:
        dst = OPT / src.name
        stem = src.stem
        # واریانت‌هایی که ما ساخته بودیم حذف شوند تا با ابعاد جدید نمانند
        extra = [f for f in OPT.glob(f"{stem}-*.*") if f.suffix in (".webp", ".avif")]
        if args.dry_run:
            print(f"  • {src.name}  (حذف {len(extra)} واریانت)")
            restored += 1
            continue
        shutil.copy2(src, dst)
        for f in extra:
            f.unlink(missing_ok=True)
        for suf in (".webp", ".avif"):
            (OPT / f"{stem}{suf}").unlink(missing_ok=True)
        restored += 1

    print()
    if args.dry_run:
        print(f"▸ dry-run: {restored} فایل بازگردانده می‌شود — چیزی نوشته نشد")
    else:
        print(f"✓ بازگردانی شد: {restored} تصویر به نسخهٔ اصلی")


if __name__ == "__main__":
    main()
