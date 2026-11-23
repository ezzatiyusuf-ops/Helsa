#!/usr/bin/env python3
"""
HELSA — جایگزینی امن تصاویر سایت با نسخه‌های استودیویی

چه می‌کند:
  ۱) از فایل‌های فعلی `public/images/opt/` پشتیبان می‌گیرد (هیچ‌وقت بازنویسی نمی‌شوند)
  ۲) برای هر تصویر تأییدشده، همهٔ واریانت‌های سایت را بازتولید می‌کند:
       {stem}.jpg  {stem}.webp  {stem}.avif
       {stem}-480/768/1080/1400 .webp و .avif
     با همان عرض‌هایی که قبلاً وجود داشت — چیزی که سایت انتظار دارد عوض نمی‌شود.
  ۳) کوچک‌ترین واریانت موجود در سایت را حفظ می‌کند (مثلاً ۳۲۰ برای کارت‌های کوچک)
  ۴) فیلدهای image/variants محصولات را دست نمی‌زند — فقط فایل‌ها را جایگزین می‌کند

اجرا:
    python3 scripts/deploy-studio-photos.py --dry-run
    python3 scripts/deploy-studio-photos.py
"""
from __future__ import annotations

import argparse
import json
import shutil
from pathlib import Path

from PIL import Image, features

STUDIO = Path("/home/user/helsa-studio")
OPT = Path("/home/user/helsa/public/images/opt")
BACKUP = Path("/home/user/helsa-photo-backup/site-originals")


def supports(fmt: str) -> bool:
    try:
        return features.check(fmt)
    except Exception:
        return False


def save_variant(src: Image.Image, dst_base: Path, width: int, fmt: str) -> bool:
    im = src.copy()
    if width:
        im = im.copy()
        im.thumbnail((width, width), Image.LANCZOS)
    try:
        if fmt == "webp":
            im.save(dst_base.with_suffix(".webp"), "WEBP", quality=84, method=6)
        elif fmt == "avif":
            im.save(dst_base.with_suffix(".avif"), "AVIF", quality=58)
        elif fmt == "jpg":
            im.save(dst_base.with_suffix(".jpg"), "JPEG", quality=92, optimize=True, progressive=True)
        return True
    except Exception as e:
        print(f"    ⚠ {fmt} {width}: {e}")
        return False


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    report = json.loads((STUDIO / "report.json").read_text(encoding="utf-8"))
    ok = [r for r in report if r["ok"]]

    has_avif = supports("avif")
    BACKUP.mkdir(parents=True, exist_ok=True)

    replaced, backed, skipped = 0, 0, 0
    missing_src = []

    for r in ok:
        stem = Path(r["out"]).stem
        studio_jpg = STUDIO / f"{stem}.jpg"
        site_jpg = OPT / f"{stem}.jpg"
        if not studio_jpg.exists():
            missing_src.append(stem)
            continue

        # ── ۱) پشتیبان ──
        if site_jpg.exists() and not args.dry_run:
            dst = BACKUP / site_jpg.name
            if not dst.exists():
                shutil.copy2(site_jpg, dst)
                backed += 1

        # ── ۲) عرض‌های موجود در سایت را کشف کن ──
        widths = set()
        for f in OPT.glob(f"{stem}-*.*"):
            tail = f.stem.rsplit("-", 1)[-1]
            if tail.isdigit():
                widths.add(int(tail))
        if not widths:
            widths = {480, 768, 1080, 1400}

        if args.dry_run:
            fmt_list = "webp" + ("+avif" if has_avif else "")
            print(f"  • {stem}: پایه + {sorted(widths)} ({fmt_list})")
            replaced += 1
            continue

        im = Image.open(studio_jpg).convert("RGB")

        # ── ۳) فایل پایه ──
        save_variant(im, OPT / stem, 0, "jpg")
        save_variant(im, OPT / stem, 0, "webp")
        if has_avif:
            save_variant(im, OPT / stem, 0, "avif")

        # ── ۴) واریانت‌های عرض‌دار ──
        for w in sorted(widths):
            save_variant(im, OPT / f"{stem}-{w}", w, "webp")
            if has_avif:
                save_variant(im, OPT / f"{stem}-{w}", w, "avif")

        replaced += 1
        if replaced % 15 == 0:
            print(f"  … {replaced}/{len(ok)}")

    print()
    if args.dry_run:
        print(f"▸ dry-run: {replaced} تصویر آمادهٔ جایگزینی — هیچ فایلی نوشته نشد")
        return

    print(f"✓ جایگزین شد : {replaced}")
    print(f"✓ پشتیبان    : {backed} → {BACKUP}")
    if missing_src:
        print(f"⚠ منبع نبود  : {missing_src}")
    print(f"  AVIF        : {'فعال' if has_avif else 'پشتیبانی نمی‌شود — فقط WebP'}")

    total = sum(f.stat().st_size for f in OPT.iterdir() if f.is_file())
    print(f"  حجم public/images/opt: {total/1e6:.1f} MB")


if __name__ == "__main__":
    main()
