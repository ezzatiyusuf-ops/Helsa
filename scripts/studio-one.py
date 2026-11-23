#!/usr/bin/env python3
"""
HELSA — پردازش تک‌تصویری با موتور استودیو (برای تصاویری که جا افتاده‌اند).

اجرا:
    python3 scripts/studio-one.py handmade-date-chocolate-2 medjool-dates-3 …
"""
from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

ENGINE = Path(__file__).with_name("studio-engine.py")


def load_engine():
    spec = importlib.util.spec_from_file_location("helsa_engine", ENGINE)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def main() -> int:
    if len(sys.argv) < 2:
        print("نام تصویر(ها) را بدهید.")
        return 2

    from rembg import new_session
    se = load_engine()
    session = new_session("u2net")

    src_dir = Path("/home/user/helsa/public/images/opt")
    dst_dir = Path("/home/user/helsa-studio")
    report_path = dst_dir / "report.json"
    report = json.loads(report_path.read_text(encoding="utf-8")) if report_path.exists() else []
    known = {Path(r["src"]).stem for r in report}

    ok = 0
    for stem in sys.argv[1:]:
        src = src_dir / f"{stem}.jpg"
        if not src.exists():
            print(f"  ✗ {stem}: فایل نیست")
            continue
        rec = se.process(src, dst_dir, session)
        report = [r for r in report if Path(r["src"]).stem != stem]
        report.append(rec)
        known.add(stem)
        if rec["ok"]:
            ok += 1
            print(f"  ✓ {stem}  پوشش {rec.get('coverage', 0)*100:.0f}%")
        else:
            print(f"  ✗ {stem}  {rec['reason']}")

    report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"\n▸ {ok}/{len(sys.argv)-1} موفق · گزارش به‌روزرسانی شد")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
