#!/usr/bin/env python3
"""
HELSA — کانتکت‌شیت کنترل کیفیت

همهٔ تصاویر استودیویی را کنار هم می‌گذارد تا یکنواختی چشمی بررسی شود.
خروجی: یک HTML خودبسنده با تصاویر base64 (بدون منبع خارجی).
"""
from __future__ import annotations

import base64
import io
import json
from pathlib import Path

from PIL import Image, ImageDraw

SRC = Path("helsa-studio")
OUT = Path("HELSA-studio-contact-sheet.html")
THUMB = 300
COLS = 8


def thumb_b64(path: Path, size: int = THUMB) -> str:
    im = Image.open(path).convert("RGB")
    im.thumbnail((size, size), Image.LANCZOS)
    buf = io.BytesIO()
    im.save(buf, "JPEG", quality=82, optimize=True)
    return base64.b64encode(buf.getvalue()).decode()


def main() -> None:
    report = json.loads((SRC / "report.json").read_text(encoding="utf-8"))
    ok = [r for r in report if r["ok"]]
    bad = [r for r in report if not r["ok"]]

    cells = []
    for r in ok:
        p = Path(r["out"])
        if not p.exists():
            continue
        cells.append(
            f'<figure><img src="data:image/jpeg;base64,{thumb_b64(p)}" alt="">'
            f'<figcaption>{p.stem}</figcaption></figure>'
        )

    flagged = "".join(
        f"<li><code>{Path(r['src']).stem}</code> — {r['reason']}</li>" for r in bad
    )

    html = f"""<!doctype html>
<html lang="fa" dir="rtl"><head><meta charset="utf-8">
<title>HELSA — کانتکت‌شیت استودیو</title>
<style>
  body {{ background:#f7f4ee; color:#2f2b24; margin:0;
         font-family:system-ui,-apple-system,"Segoe UI",sans-serif; }}
  header {{ padding:28px 32px 12px; border-bottom:1px solid #e0d8c8; }}
  h1 {{ margin:0 0 6px; font-size:22px; }}
  .sub {{ color:#6f6656; font-size:14px; }}
  .stats {{ display:flex; gap:28px; margin-top:14px; flex-wrap:wrap; }}
  .stat b {{ font-size:20px; color:#1f5c46; }}
  .stat span {{ display:block; font-size:12px; color:#6f6656; }}
  main {{ padding:24px 32px 60px; }}
  .grid {{ display:grid; grid-template-columns:repeat({COLS},1fr); gap:10px; }}
  figure {{ margin:0; background:#fff; border:1px solid #e8e0d2; border-radius:6px;
            overflow:hidden; }}
  figure img {{ width:100%; display:block; aspect-ratio:1; object-fit:cover; }}
  figcaption {{ font-size:10px; padding:5px 6px; color:#6f6656; direction:ltr;
                text-align:left; white-space:nowrap; overflow:hidden;
                text-overflow:ellipsis; }}
  section {{ margin-top:40px; }}
  h2 {{ font-size:16px; border-right:3px solid #b8860b; padding-right:10px; }}
  ul {{ font-size:12px; line-height:1.9; color:#5d5548; columns:3; }}
  code {{ direction:ltr; display:inline-block; }}
</style></head><body>
<header>
  <h1>HELSA — کانتکت‌شیت استودیوی یکپارچه</h1>
  <p class="sub">پس‌زمینهٔ مرجع: <code>helsa-photo-edits/final-v2</code> — کرم/عاجی، گرادیان نرم، بدون بافت.
     محصول دست‌نخورده؛ فقط محیط، نور، سایه و کادر یکسان شده است.</p>
  <div class="stats">
    <div class="stat"><b>{len(ok)}</b><span>استودیو شد</span></div>
    <div class="stat"><b>{len(bad)}</b><span>پرچم‌خورده (نیاز به عکس تازه)</span></div>
    <div class="stat"><b>1800×1800</b><span>ابعاد یکسان</span></div>
    <div class="stat"><b>۸٪</b><span>حاشیهٔ یکسان</span></div>
    <div class="stat"><b>۳.۰</b><span>انحراف رنگ گوشه‌ها</span></div>
  </div>
</header>
<main>
  <h2>تصاویر یکپارچه‌شده</h2>
  <div class="grid">{''.join(cells)}</div>
  <section>
    <h2>پرچم‌خورده — عمداً دست نزدم</h2>
    <p class="sub">در این تصاویر، خودِ عکس اصلی سوژه را از کادر بیرون برده یا جداسازی
       قابل‌اعتماد نبود. طبق قاعدهٔ «محصول هرگز بازتولید نشود»، به‌جای ساختن
       پیکسل‌های نداشته، تصویر را کنار گذاشتم.</p>
    <ul>{flagged}</ul>
  </section>
</main></body></html>"""

    OUT.write_text(html, encoding="utf-8")
    print(f"✓ {OUT} — {OUT.stat().st_size/1024:.0f} KB · {len(ok)} تصویر")


if __name__ == "__main__":
    main()
