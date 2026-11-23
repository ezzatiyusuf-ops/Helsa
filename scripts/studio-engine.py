#!/usr/bin/env python3
"""
HELSA — موتور استودیوی یکپارچه (Studio Engine)

یک استودیوی روشن، کرم/عاجی، با همان پروفایل مرجع تأییدشدهٔ مالک
(helsa-photo-edits/final-v2) برای همهٔ محصولات می‌سازد.

قاعدهٔ مطلق: خودِ محصول دست نمی‌خورد. فقط پس‌زمینه، سایه، نور اطراف،
کادر و تُن کل تصویر عوض می‌شود — هرگز محتوای محصول بازتولید نمی‌شود.

مراحل هر تصویر:
  ۱) جداسازی سوژه با rembg (u2net)
  ۲) پاک‌سازی ماسک: حذف جزیره‌های سرگردان، نرم‌کردن لبه، رفع هاله
  ۳) ساخت پس‌زمینهٔ استودیو با پروفایل مرجع (گرادیان + هات‌اسپات نرم)
  ۴) سایهٔ تماس واقع‌گرایانه زیر محصول (جهت نور: بالا-چپ)
  ۵) تصحیح نور/رنگ محصول با محدودهٔ محافظه‌کارانه
  ۶) کادربندی یکسان: مربع، حاشیهٔ ۸٪، سوژه در مرکز با پایه در ۸۲٪

اجرا:
    python3 scripts/studio-engine.py --test        # نمونهٔ ۶ دسته
    python3 scripts/studio-engine.py --all         # کل کاتالوگ
"""
from __future__ import annotations

import argparse
import gc
import json
import os
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFilter

# ── پروفایل استودیو، اندازه‌گیری‌شده از مرجع تأییدشدهٔ مالک ───────────────────
# helsa-photo-edits/final-v2/01-IMG_3596.jpg (۲۰۰۰×۲۰۰۰)
STUDIO = {
    "top":      (227, 211, 185),   # y=0.02
    "horizon":  (240, 226, 202),   # y=0.40 — روشن‌ترین نوار، محل خم شدن کوو
    "floor":    (220, 204, 181),   # y=0.98
    "horizon_y": 0.42,             # محل گذار دیوار به سطح
    "hotspot":  (0.50, 0.22),      # مرکز هات‌اسپات نور
    "hotspot_radius": 0.62,
    "hotspot_gain": 1.045,
}

SIZE = 1800
WORK_MAX = 1400      # ابعاد کاری rembg — حافظه را کنترل می‌کند
MARGIN = 0.08          # حاشیهٔ یکسان دور سوژه
BASE_Y = 0.82          # خط زمین (پایین سوژه)


# ── پس‌زمینه ────────────────────────────────────────────────────────────────
_BG_CACHE: dict[int, Image.Image] = {}


def _load_marble_module():
    """ماژول مرمر را از مسیر اسکریپت‌ها بارگذاری می‌کند."""
    import importlib.util
    from pathlib import Path
    path = Path(__file__).with_name("marble-bg.py")
    spec = importlib.util.spec_from_file_location("helsa_marble", path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def build_studio_background(size: int = SIZE) -> Image.Image:
    """پس‌زمینهٔ مرمری ساخته‌شده و کش‌شده.

    کش برای دو دلیل: سرعت، و تضمین اینکه *همهٔ* تصاویر کاتالوگ دقیقاً
    پیکسل‌به‌پیکسل یک پس‌زمینهٔ یکسان داشته باشند.
    """
    if size in _BG_CACHE:
        return _BG_CACHE[size].copy()
    marble = _load_marble_module()
    _BG_CACHE[size] = marble.build_studio(size)
    return _BG_CACHE[size].copy()


def _build_studio_background(size: int = SIZE) -> Image.Image:
    """پس‌زمینهٔ استودیو: گرادیان عمودی + هات‌اسپات نرم، بدون هیچ بافتی."""
    y = np.linspace(0.0, 1.0, size, dtype=np.float32)[:, None]

    top = np.array(STUDIO["top"], dtype=np.float32)
    hor = np.array(STUDIO["horizon"], dtype=np.float32)
    flo = np.array(STUDIO["floor"], dtype=np.float32)

    hy = STUDIO["horizon_y"]
    # بالا → افق (روشن‌تر)، سپس افق → کف (تیره‌تر).
    # گذار با smoothstep نرم می‌شود تا لبهٔ تیز افق دیده نشود.
    up = np.clip(y / hy, 0, 1)
    t1 = up * up * (3 - 2 * up) ** 0.5
    dn = np.clip((y - hy) / (1 - hy), 0, 1)
    t2 = dn ** 0.30
    grad = np.where(y <= hy,
                    top + (hor - top) * t1,
                    hor + (flo - hor) * t2)

    bg = np.repeat(grad[:, None, :], size, axis=1)

    # هات‌اسپات نور: بیضی نرم در بالای کادر
    yy, xx = np.mgrid[0:size, 0:size].astype(np.float32) / size
    cx, cy = STUDIO["hotspot"]
    r = np.sqrt(((xx - cx) / STUDIO["hotspot_radius"]) ** 2 +
                ((yy - cy) / (STUDIO["hotspot_radius"] * 0.9)) ** 2)
    spot = 1.0 + (STUDIO["hotspot_gain"] - 1.0) * np.clip(1.0 - r, 0, 1) ** 2
    bg = bg * spot[:, :, None]

    return Image.fromarray(np.clip(bg, 0, 255).astype(np.uint8))


# ── ماسک ────────────────────────────────────────────────────────────────────
def clean_mask(alpha: Image.Image, min_island_ratio: float = 0.0008) -> Image.Image:
    """پاک‌سازی ماسک: حذف جزیره‌های کوچک و نرم‌کردن لبه."""
    a = np.asarray(alpha, dtype=np.uint8).copy()
    h, w = a.shape
    total = h * w

    # برچسب‌گذاری سبک بدون scipy: flood-fill روی مؤلفه‌های بزرگ‌تر از آستانه
    try:
        from scipy import ndimage  # type: ignore
        lab, n = ndimage.label(a > 40)
        if n > 1:
            sizes = ndimage.sum(a > 40, lab, range(1, n + 1))
            keep = np.zeros(n + 1, dtype=bool)
            keep[1:] = sizes >= total * min_island_ratio
            a = np.where(keep[lab], a, 0).astype(np.uint8)
    except Exception:
        pass  # اگر scipy نبود، فقط عملیات پایه

    mask = Image.fromarray(a, "L")
    # کوچک‌کردن ۱px سپس بزرگ‌کردن: حذف هالهٔ باقی‌مانده از پس‌زمینهٔ قبلی
    mask = mask.filter(ImageFilter.MinFilter(3)).filter(ImageFilter.MaxFilter(3))
    mask = mask.filter(ImageFilter.GaussianBlur(1.2))
    return mask


def has_alpha_problem(alpha: Image.Image) -> tuple[bool, str]:
    """تشخیص خروجی مشکوک — به‌جای تحویل تصویر خراب، پرچم می‌زنیم."""
    a = np.asarray(alpha, dtype=np.uint8)
    cov = float((a > 40).mean())
    if cov < 0.04:
        return True, f"پوشش بسیار کم ({cov*100:.1f}%) — سوژه پیدا نشد"
    if cov > 0.92:
        return True, f"پوشش بسیار زیاد ({cov*100:.1f}%) — پس‌زمینه جدا نشد"
    h, w = a.shape
    # ماسک پرکنندهٔ مستطیل = جداسازی شکست خورده
    edges = np.concatenate([a[2, :], a[-3, :], a[:, 2], a[:, -3]])
    if (edges > 128).mean() > 0.55:
        return True, "لبه‌های کادر پوشیده‌اند — جداسازی شکست خورد"
    return False, ""


# ── سایه ────────────────────────────────────────────────────────────────────
def contact_shadow(size: int, w: int, h: int, opacity: float = 0.38,
                   blur: int = 20) -> Image.Image:
    """سایهٔ تماس، دقیقاً زیر پایهٔ سوژه (نه شناور).

    جهت نور: بالا-چپ ⇒ سایه کمی به راست و پایین جابه‌جا می‌شود، ولی
    فاصله‌اش کم است تا محصول «نشسته» به‌نظر برسد نه معلق.
    """
    sw = int(w * 0.86)
    sh_h = max(8, int(h * 0.055))
    canvas = Image.new("L", (size, size), 0)
    ellipse = Image.new("L", (sw, sh_h), 0)
    ImageDraw.Draw(ellipse).ellipse((0, 0, sw - 1, sh_h - 1), fill=255)
    canvas.paste(ellipse, ((size - sw) // 2 + int(w * 0.02), 0))
    return canvas.filter(ImageFilter.GaussianBlur(blur))


# ── نور و رنگ ───────────────────────────────────────────────────────────────
def grade_product(img: Image.Image) -> Image.Image:
    """تصحیح محافظه‌کارانهٔ نور/رنگ محصول — بدون تغییر ماهیت رنگ."""
    a = np.asarray(img, dtype=np.float32)
    lum = a.mean(axis=2)
    if lum.size == 0:
        return img

    med = float(np.median(lum[lum > 0])) if (lum > 0).any() else 128.0
    # هدف: روشن‌تر و تمیزتر، اما هرگز کلیپ
    target = 168.0
    gain = np.clip(target / max(med, 1.0), 0.95, 1.11)
    a = a * gain

    # سفیدی/تعادل رنگ ملایم: کاهش کست آبی-سبز
    means = a.reshape(-1, 3).mean(axis=0)
    gray = means.mean()
    a = a * np.clip(gray / np.maximum(means, 1.0), 0.97, 1.05)

    # کنتراست ملایم حول میانه
    a = (a - a.mean()) * 1.025 + a.mean()
    return Image.fromarray(np.clip(a, 0, 252).astype(np.uint8))


# ── ترکیب ───────────────────────────────────────────────────────────────────
def place_on_studio(cutout: Image.Image, mask: Image.Image, size: int = SIZE) -> Image.Image:
    """جاگذاری: برش به کادر واقعی سوژه، سپس نشستن دقیق روی خط زمین."""
    bbox = mask.getbbox()
    if bbox is None:
        raise ValueError("ماسک خالی است")
    cut = cutout.crop(bbox)
    msk = mask.crop(bbox)

    bg = build_studio_background(size)

    inner = int(size * (1 - 2 * MARGIN))
    scale = min(inner / cut.width, inner / cut.height)
    nw, nh = max(1, int(cut.width * scale)), max(1, int(cut.height * scale))
    cut = cut.resize((nw, nh), Image.LANCZOS)
    msk = msk.resize((nw, nh), Image.LANCZOS)

    x = (size - nw) // 2
    base = int(BASE_Y * size)
    y = base - nh                        # پایهٔ واقعی سوژه روی خط زمین
    sh_half = max(4, int(nh * 0.055)) // 2

    # مرکز بیضی سایه روی خط زمین می‌نشیند تا محصول «شناور» دیده نشود
    sh = contact_shadow(size, nw, nh)
    sh_layer = Image.new("RGB", (size, size), (110, 88, 62))
    bg.paste(sh_layer, (0, y + nh - sh_half), sh)

    bg.paste(cut, (x, y), msk)
    return bg


def touches_source_edge(mask: Image.Image, pad: int = 3) -> list[str]:
    """آیا سوژه به لبهٔ عکس اصلی چسبیده؟ یعنی عکس اصلی از قبل بریده است."""
    a = np.asarray(mask, dtype=np.uint8)
    hits = []
    if (a[:pad, :] > 40).mean() > 0.02: hits.append("بالا")
    if (a[-pad:, :] > 40).mean() > 0.02: hits.append("پایین")
    if (a[:, :pad] > 40).mean() > 0.02: hits.append("چپ")
    if (a[:, -pad:] > 40).mean() > 0.02: hits.append("راست")
    return hits


# ── پردازش یک فایل ──────────────────────────────────────────────────────────
def process(src: Path, dst_dir: Path, session, size: int = SIZE) -> dict:
    from rembg import remove

    rec = {"src": str(src), "ok": False, "reason": ""}
    try:
        im = Image.open(src).convert("RGB")
    except Exception as e:
        rec["reason"] = f"باز نشد: {e}"
        return rec

    # rembg روی حداکثر ۱۶۰۰px برای سرعت و کیفیت کافی ماسک
    probe = im.copy()
    probe.thumbnail((WORK_MAX, WORK_MAX), Image.LANCZOS)
    try:
        cut_probe = remove(probe, session=session, post_process_mask=True)
    except Exception as e:
        rec["reason"] = f"جداسازی شکست خورد: {e}"
        return rec

    alpha_probe = cut_probe.split()[-1]
    bad, why = has_alpha_problem(alpha_probe)
    if bad:
        rec["reason"] = why
        return rec

    # ماسک با کیفیت کامل
    mask_full = alpha_probe.resize(im.size, Image.LANCZOS)
    mask_full = clean_mask(mask_full)

    bad2, why2 = has_alpha_problem(mask_full)
    if bad2:
        rec["reason"] = why2
        return rec

    # اگر سوژه به لبهٔ عکس اصلی چسبیده، عکس از قبل بریده است — نمی‌توانیم
    # پیکسل‌های نداشته را بسازیم (و نباید بسازیم). به‌جای تحویل تصویر ناقص، پرچم می‌زنیم.
    clipped = touches_source_edge(mask_full)
    if clipped:
        rec["reason"] = f"عکس اصلی از قبل بریده است (لبه: {'، '.join(clipped)}) — نیاز به عکس تازه"
        return rec

    cutout = grade_product(im)
    final = place_on_studio(cutout, mask_full, size)

    dst_dir.mkdir(parents=True, exist_ok=True)
    out_jpg = dst_dir / f"{src.stem}.jpg"
    final.save(out_jpg, "JPEG", quality=92, optimize=True, progressive=True)

    # نسخه‌های وب
    for w, q in ((600, 84), (1200, 86)):
        v = final.copy()
        v.thumbnail((w, w), Image.LANCZOS)
        v.save(dst_dir / f"{src.stem}-{w}.webp", "WEBP", quality=q, method=6)

    rec.update(ok=True, out=str(out_jpg),
               coverage=round(float((np.asarray(mask_full) > 40).mean()), 3))
    return rec


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--test", action="store_true", help="نمونهٔ کوچک از دسته‌های مختلف")
    ap.add_argument("--all", action="store_true", help="کل کاتالوگ")
    ap.add_argument("--src", default="helsa/public/images/opt")
    ap.add_argument("--dst", default="helsa-studio")
    ap.add_argument("--limit", type=int, default=0)
    args = ap.parse_args()

    from rembg import new_session
    session = new_session("u2net")

    src_dir = Path(args.src)
    dst_dir = Path(args.dst)

    all_files = sorted(src_dir.glob("*.jpg"))
    # حذف واریانت‌ها: فایلی واریانت است اگر نام پایه‌اش (بدون -N) هم به‌عنوان
    # .jpg وجود داشته باشد. نام‌هایی مثل «date-bar-2» محصول مستقل‌اند و باید بمانند.
    SIZES_VARIANT = {"320", "400", "480", "600", "768", "1080", "1200", "1400", "1800", "2000"}
    all_files = [
        f for f in all_files
        if not (f.stem.rsplit("-", 1)[-1] in SIZES_VARIANT
                and (src_dir / f"{f.stem.rsplit('-', 1)[0]}.jpg").exists())
    ]

    if args.test:
        wanted = [
            "dates-mazafati", "akbari-pistachios", "saffron", "chickpeas",
            "barberry", "date-chocolate", "corporate-gift-box", "dried-figs",
        ]
        files = [f for f in all_files if f.stem in wanted][:8]
        if not files:
            files = all_files[:8]
    else:
        files = all_files

    if args.limit:
        files = files[: args.limit]

    print(f"▸ {len(files)} تصویر · استودیو {SIZE}×{SIZE} · حاشیه {int(MARGIN*100)}%")
    records = []
    for i, f in enumerate(files, 1):
        rec = process(f, dst_dir, session)
        records.append(rec)
        mark = "✓" if rec["ok"] else "✗"
        extra = f"  پوشش {rec.get('coverage', 0)*100:.0f}%" if rec["ok"] else f"  {rec['reason']}"
        print(f"  {mark} [{i:3d}/{len(files)}] {f.stem}{extra}", flush=True)
        gc.collect()

    ok = sum(1 for r in records if r["ok"])
    print(f"\n▸ نتیجه: {ok}/{len(files)} موفق")
    dst_dir.mkdir(parents=True, exist_ok=True)
    (dst_dir / "report.json").write_text(
        json.dumps(records, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
