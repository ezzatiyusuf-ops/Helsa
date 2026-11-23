#!/usr/bin/env python3
"""
HELSA — ساخت پس‌زمینهٔ استودیوی مرمری

استودیوی ثابت HELSA:
  • دیوار: بک‌دراپ عاجی گرم، بدون بافت محسوس
  • سطح: مرمر عاجی با رگه‌های بلند و نرم، عمق میدان ملایم، پرسپکتیو واقعی
  • گذار سیکلوراما (بدون خط تیز)
  • نور یک‌جهته از بالا-چپ

اجرا:
    python3 scripts/marble-bg.py
    python3 scripts/marble-bg.py --compare
"""
from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter

SIZE = 1800

# ── پالت HELSA: عاجی گرم با رگهٔ خرمایی بسیار ملایم ─────────────────────────
BACKDROP_TOP = (234, 221, 202)
BACKDROP_BOT = (243, 233, 216)
MARBLE_BASE = (240, 231, 216)
MARBLE_VEIN = (206, 191, 170)     # رگه — فقط ۳۵٪ آمیخته می‌شود
MARBLE_CLOUD = (230, 218, 200)    # ابرهای نرم سطح

HORIZON_Y = 0.46
_BLEND = 0.10                      # پهنای گذار سیکلوراما (نسبت به ارتفاع)


def _smooth_noise(h: int, w: int, cells: int, seed: int) -> np.ndarray:
    """نویز نرم چنداکتاوی.

    بزرگ‌کردن یک شبکهٔ کوچک با BICUBIC آرتیفکت مستطیلی می‌سازد؛ به‌جایش
    چند مقیاس را روی هم جمع می‌کنیم تا بافت یکنواخت و بدون شبکه باشد.
    """
    rng = np.random.default_rng(seed)
    out = np.zeros((h, w), dtype=np.float32)
    amp, total = 1.0, 0.0
    c = cells
    for _ in range(5):
        ch = max(2, int(c))
        cw = max(2, int(c * w / max(h, 1)))
        base = (rng.random((ch, cw)) * 255).astype(np.uint8)
        layer = Image.fromarray(base, "L").resize((w, h), Image.LANCZOS)
        out += (np.asarray(layer, dtype=np.float32) / 255.0) * amp
        total += amp
        amp *= 0.55
        c *= 2.1
    out /= total
    lo, hi = float(out.min()), float(out.max())
    return (out - lo) / max(hi - lo, 1e-6)


def marble_surface(w: int, h: int, seed: int = 11) -> np.ndarray:
    """مرمر عاجی: رگه‌های بلندِ پیچیده با domain-warping، کنتراست پایین."""
    yy, xx = np.mgrid[0:h, 0:w].astype(np.float32)
    u = xx / w
    v = yy / h

    # پیچش مختصات — همان چیزی که رگه‌های مارپیچ طبیعی می‌سازد
    warp = _smooth_noise(h, w, 5, seed) - 0.5
    warp2 = _smooth_noise(h, w, 9, seed + 41) - 0.5
    uu = u + warp * 0.22 + warp2 * 0.06
    vv = v + warp2 * 0.16

    # رگهٔ اصلی: چند نوار بلند و کم‌شیب
    phase = (uu * 1.15 + vv * 1.9) * np.pi * 2.0
    band = np.abs(np.sin(phase))
    vein_a = np.clip((0.10 - band) / 0.10, 0, 1) ** 1.4

    # رگهٔ فرعی: نازک‌تر و رشته‌ای
    phase2 = (uu * 2.3 - vv * 1.2) * np.pi * 2.0 + warp * 5.0
    vein_b = np.clip((0.045 - np.abs(np.sin(phase2))) / 0.045, 0, 1) ** 2.0

    # ابرهای نرم سطح (بزرگ‌مقیاس)
    cloud = np.clip((_smooth_noise(h, w, 3, seed + 77) - 0.5) * 1.6, 0, 1)

    base = np.array(MARBLE_BASE, np.float32)
    vein_c = np.array(MARBLE_VEIN, np.float32)
    cloud_c = np.array(MARBLE_CLOUD, np.float32)

    img = np.zeros((h, w, 3), np.float32) + base
    img = img + (cloud_c - base) * (cloud * 0.45)[:, :, None]
    total_vein = np.clip(vein_a * 0.62 + vein_b * 0.38, 0, 1) * 0.35
    img = img + (vein_c - img) * total_vein[:, :, None]

    # نرم‌کردن: مرمر صیقلی، رگه‌ها تیز نیستند
    for c in range(3):
        ch = Image.fromarray(np.clip(img[:, :, c], 0, 255).astype(np.uint8), "L")
        img[:, :, c] = np.asarray(ch.filter(ImageFilter.GaussianBlur(3.5)), np.float32)
    return img


def build_studio(size: int = SIZE, seed: int = 11) -> Image.Image:
    hy = int(HORIZON_Y * size)
    floor_h = size - hy

    # ── دیوار ──
    t = np.linspace(0, 1, hy, dtype=np.float32)[:, None]
    wall = np.array(BACKDROP_TOP, np.float32) + (
        np.array(BACKDROP_BOT, np.float32) - np.array(BACKDROP_TOP, np.float32)
    ) * (t ** 0.85)
    wall = np.repeat(wall[:, None, :], size, axis=1)

    # ── سطح مرمر با پرسپکتیو ──
    src_h = int(floor_h * 3.2)
    flat = marble_surface(size, src_h, seed)

    frac = np.linspace(0, 1, floor_h, dtype=np.float32)
    src_rows = (frac ** 1.9) * (src_h - 1)
    idx = np.clip(src_rows.astype(np.int32), 0, src_h - 1)
    floor = np.take(flat, idx, axis=0)

    # نور روی سطح: روشن‌تر نزدیک افق
    floor = floor * (0.952 + 0.080 * (1 - frac) ** 1.1)[:, None, None]
    # سایهٔ تماس سیکلوراما
    contact = np.exp(-((frac / 0.13) ** 2))[:, None, None]
    floor = floor * (1 - contact * 0.050)

    # ── دیوار روی کل ارتفاع (تا زیر افق هم ادامه دارد) ──
    tfull = np.linspace(0, 1, size, dtype=np.float32)[:, None]
    wall_full = np.array(BACKDROP_TOP, np.float32) + (
        np.array(BACKDROP_BOT, np.float32) - np.array(BACKDROP_TOP, np.float32)
    ) * np.clip(tfull / HORIZON_Y, 0, 1) ** 0.85
    wall_full = np.repeat(wall_full[:, None, :], size, axis=1)

    # ── ترکیب: ماسک smoothstep روی کل ارتفاع ──
    canvas = np.zeros((size, size, 3), np.float32)
    canvas[:hy] = wall
    canvas[hy:] = floor

    blend_h = int(size * _BLEND)
    y0 = hy - blend_h // 2
    ys = np.arange(size, dtype=np.float32)
    m = np.clip((ys - y0) / max(blend_h, 1), 0, 1)
    m = m * m * (3 - 2 * m)                     # smoothstep
    m = m[:, None, None]

    # floor_ext: سطح تا بالای گذار کشیده می‌شود تا هیچ شکافی نماند
    floor_ext = np.zeros((size, size, 3), np.float32)
    floor_ext[hy:] = floor
    floor_ext[:hy] = floor[0]
    canvas = wall_full * (1 - m) + floor_ext * m

    # ── نور محیط از بالا-چپ ──
    yy, xx = np.mgrid[0:size, 0:size].astype(np.float32) / size
    r = np.sqrt((xx - 0.40) ** 2 + (yy - 0.16) ** 2)
    canvas = canvas * (1.0 + 0.028 * np.clip(1.0 - r / 0.90, 0, 1) ** 2)[:, :, None]

    return Image.fromarray(np.clip(canvas, 0, 255).astype(np.uint8))


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--compare", action="store_true")
    ap.add_argument("--size", type=int, default=SIZE)
    args = ap.parse_args()

    out = Path("helsa-studio")
    out.mkdir(exist_ok=True)
    bg = build_studio(args.size)
    p = out / "_marble-background.jpg"
    bg.save(p, "JPEG", quality=95, optimize=True)
    print(f"✓ {p} — {args.size}×{args.size}")

    if args.compare:
        a = np.asarray(bg, dtype=float)
        s = args.size
        print("\nنقاط کلیدی:")
        for label, fy, fx in [
            ("دیوار بالا", 0.05, 0.10), ("دیوار میانه", 0.30, 0.10),
            ("نزدیک افق", 0.45, 0.10), ("مرمر نزدیک", 0.56, 0.10),
            ("مرمر میانه", 0.75, 0.10), ("مرمر پایین", 0.95, 0.10),
            ("مرکز سطح", 0.75, 0.50), ("راست سطح", 0.75, 0.85),
        ]:
            y, x = int(fy * s), int(fx * s)
            patch = a[max(0, y - 20):y + 20, max(0, x - 20):x + 20]
            m = patch.reshape(-1, 3).mean(axis=0)
            print(f"  {label:12s} ({m[0]:.0f},{m[1]:.0f},{m[2]:.0f})  نوسان={patch.mean(axis=2).std():.1f}")

        # آیا خط افق دیده می‌شود؟ بیشترین پرش سطر-به-سطر
        rows = a.mean(axis=(1, 2))
        jump = np.abs(np.diff(rows))
        print(f"\nبیشترین پرش روشنایی بین دو سطر: {jump.max():.2f} در y={int(jump.argmax()/s*100)}%")


if __name__ == "__main__":
    main()
