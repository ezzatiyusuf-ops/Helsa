#!/usr/bin/env python3
"""
catalog-audit.py — ممیزی یکپارچگی کاتالوگ (فاز بازبینی کاتالوگ)
─────────────────────────────────────────────────────────────────────────────
فقط می‌خواند و گزارش می‌دهد؛ هیچ چیزی را تغییر نمی‌دهد.
منبع داده: PostgreSQL واقعی (DATABASE_URL یا پیش‌فرض محلی).

    python3 scripts/catalog-audit.py                 # گزارش انسانی
    python3 scripts/catalog-audit.py --json out.json # + خروجی JSON برای ماشین/CI

چه چیزهایی سنجیده می‌شود:
  ۱) شمارش کاتالوگ (کل / فعال و قابل‌نمایش) و شکاف نسبت به عدد مبنا
  ۲) تکراری‌ها: slug · sku · نام · نامِ نرمال‌شده
  ۳) واریانت‌ها: تطبیق قیمت پایه با واریانت‌ها · وزن پایه · وزن نسخهٔ ویژگی‌ها (features)
  ۴) تصاویر: عکسِ خود محصول · عکسِ محصول دیگر · تصویر عمومی · placeholder
  ۵) تخفیف‌های بی‌پشتوانه (old_price ≤ price یا discount بدون old_price)
  ۶) دستهٔ نامعتبر · نبود واریانت فعال · موجودی صفر ولی «موجود»
  ۷) ناهنجاری قیمت بر ۱۰۰ گرم (فقط علامت‌گذاری، نه اصلاح)
  ۸) متن: الگوهای خراب/تکراری و حفظ شعار برند
"""
from __future__ import annotations

import json
import os
import re
import subprocess
import sys
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DSN = os.environ.get("DATABASE_URL", "postgresql://helsa:helsa_dev_pw@127.0.0.1:5432/helsa_db")
OUT = ROOT / "helsa-audit" / "catalog-audit.json"

# عدد مبنای مستندشده در پروژه (HELSA-CONSISTENCY-REPORT.md، ۲۰۲۶-۰۹-۱۷: ۱۸۴ محصول active∧visible)
BASELINE = 184
SLOGAN = "چون شما لایق بهترین‌ها هستید"

BAD_COPY = [
    (r"بوبوید", "فعل ساختگی/خراب"),
    (r"؟\s*نه\s*—", "جملهٔ نیمه‌کاره"),
    (r"\bلایق\s+بهترین\s+ها\b", None),  # نگهبان شعار — جدا بررسی می‌شود
    (r"(.)\1{4,}", "تکرار حرف"),
    (r"\s{3,}", "فاصلهٔ تکراری"),
]


_FA = str.maketrans("۰۱۲۳۴۵۶۷۸۹٫", "0123456789.")


def _grams(text: str) -> float | None:
    """وزن را به گرم تبدیل می‌کند («۲۵۰ گرم» → 250 · «۱ کیلوگرم» → 1000)."""
    m = re.search(r"([۰-۹0-9][۰-۹0-9٫.,]*)\s*(کیلوگرم|کیلو|گرم)", text or "")
    if not m:
        return None
    num = m.group(1).translate(_FA).replace(",", "").replace("٫", ".")
    try:
        val = float(num)
    except ValueError:
        return None
    return val * (1000 if "کیلو" in m.group(2) else 1)


def q(sql: str) -> list[list[str]]:
    p = subprocess.run(
        ["psql", DSN, "-A", "-F", "\x1f", "-t", "-c", sql],
        capture_output=True, text=True,
    )
    if p.returncode != 0:
        print("خطای psql:", p.stderr.strip(), file=sys.stderr)
        sys.exit(2)
    return [line.split("\x1f") for line in p.stdout.strip().split("\n") if line]


def main() -> int:
    rows = q("""
        select p.id, p.slug, p.name, p.sku, p.category, p.price, p.weight, p.unit,
               p.stock, p.stock_status, p.discount, coalesce(p.old_price,0),
               p.image, p.gallery::text, p.features::text, p.description,
               p.is_active, p.is_visible, p.created_at::date::text, p.image_status
        from products p order by p.id
    """)
    cols = ["id", "slug", "name", "sku", "category", "price", "weight", "unit", "stock",
            "stock_status", "discount", "old_price", "image", "gallery", "features",
            "description", "is_active", "is_visible", "created", "image_status"]
    products = []
    for r in rows:
        d = dict(zip(cols, r))
        for k in ("id", "price", "stock", "discount", "old_price"):
            d[k] = int(d[k])
        d["is_active"] = d["is_active"] == "t"
        d["is_visible"] = d["is_visible"] == "t"
        try:
            d["gallery"] = json.loads(d["gallery"]) or []
        except Exception:
            d["gallery"] = []
        try:
            d["features"] = json.loads(d["features"]) or []
        except Exception:
            d["features"] = []
        products.append(d)

    variants = defaultdict(list)
    for vid, pid, name, price, stock, active, order in q("""
        select id, product_id, name, price, stock, is_active, sort_order
        from product_variants order by product_id, sort_order, id
    """):
        variants[int(pid)].append({
            "id": int(vid), "name": name, "price": int(price),
            "stock": int(stock), "active": active == "t", "order": int(order),
        })

    categories = {r[0] for r in q("select slug from categories")}
    live = [p for p in products if p["is_active"] and p["is_visible"]]

    # ── فایل‌های تصویر موجود ────────────────────────────────────────────────
    opt_dir = ROOT / "public" / "images" / "opt"
    gen_dir = ROOT / "public" / "images" / "gen"
    files = set()
    for d in (opt_dir, gen_dir):
        if d.is_dir():
            files |= {f.name for f in d.iterdir()}
    public = ROOT / "public"

    def exists(path: str) -> bool:
        if not path:
            return False
        return os.path.basename(path) in files or (public / path.lstrip("/")).exists()

    def is_own(p: dict) -> bool:
        base = os.path.basename(p["image"]).rsplit(".", 1)[0]
        return base == p["slug"] or base.startswith(p["slug"] + "-")

    live_ids = {p["id"] for p in live}
    all_slugs = {p["slug"] for p in products}

    report: dict = {
        "generated_from": "PostgreSQL/products",
        "counts": {
            "rows_total": len(products),
            "live_active_visible": len(live),
            "archived_or_hidden": len(products) - len(live),
            "documented_baseline": BASELINE,
            "delta_vs_baseline": len(live) - BASELINE,
        },
        "duplicates": {}, "variants": {}, "images": {}, "discounts": {},
        "content": {}, "anomalies": {}, "flags": [],
    }

    # ── ۱) تکراری‌ها ────────────────────────────────────────────────────────
    for key in ("slug", "sku"):
        c = Counter(p[key] for p in products)
        report["duplicates"][key] = {k: v for k, v in c.items() if v > 1}
    c_name = Counter(p["name"] for p in live)
    report["duplicates"]["name"] = {k: [p["slug"] for p in live if p["name"] == k] for k, v in c_name.items() if v > 1}
    norm = lambda s: re.sub(r"[\s‌]+", " ", s).strip()
    c_norm = Counter(norm(p["name"]) for p in live)
    report["duplicates"]["name_normalized"] = {k: [p["slug"] for p in live if norm(p["name"]) == k] for k, v in c_norm.items() if v > 1}

    # ── ۲) واریانت‌ها: قیمت و وزن ───────────────────────────────────────────
    no_base_price_match, first_not_cheapest, missing_base_weight = [], [], []
    feature_weight_mismatch, no_active_variant = [], []
    for p in live:
        vs = [v for v in variants.get(p["id"], []) if v["active"]]
        if variants.get(p["id"]) and not vs:
            no_active_variant.append(p["slug"])
        fw = next((f.get("value") for f in p["features"] if f.get("label") == "وزن"), None)
        if fw and fw != p["weight"]:
            feature_weight_mismatch.append({"slug": p["slug"], "product_weight": p["weight"], "features_weight": fw})
        if not vs:
            continue
        if p["price"] not in [v["price"] for v in vs]:
            no_base_price_match.append({"slug": p["slug"], "base_price": p["price"],
                                        "variants": [v["price"] for v in vs]})
        # نام واریانت ممکن است وزن را در خود داشته باشد («نمکی - ۵۰۰ گرم») — تطبیق عددی وزن
        # (تطبیق رشته‌ای خطرناک است: «۵۰ گرم» زیررشتهٔ «۲۵۰ گرم» هم هست)
        if not any(_grams(p["weight"]) == _grams(v["name"]) for v in vs):
            missing_base_weight.append({"slug": p["slug"], "base_weight": p["weight"],
                                        "variants": [v["name"] for v in vs]})
        cheapest = min(vs, key=lambda v: v["price"])
        if vs[0]["price"] != cheapest["price"]:
            first_not_cheapest.append({"slug": p["slug"], "first": vs[0]["name"],
                                       "cheapest": cheapest["name"]})
    report["variants"] = {
        "products_with_variants": sum(1 for p in live if variants.get(p["id"])),
        "base_price_not_matching_any_variant": no_base_price_match,
        "base_weight_not_matching_any_variant": missing_base_weight,
        "first_variant_is_not_cheapest": first_not_cheapest,
        "features_weight_vs_product_weight": feature_weight_mismatch,
        "variant_sets_without_active_rows": no_active_variant,
    }

    # ── ۳) تصاویر ───────────────────────────────────────────────────────────
    img = {"own": [], "own_in_gallery": [], "own_file_exists": [], "borrowed": [],
           "generic": [], "placeholder": [], "file_missing": []}
    for p in live:
        base = os.path.basename(p["image"]).rsplit(".", 1)[0]
        if not exists(p["image"]):
            img["file_missing"].append({"slug": p["slug"], "image": p["image"]})
        if "placeholder" in p["image"]:
            img["placeholder"].append(p["slug"])
        elif is_own(p):
            img["own"].append(p["slug"])
        elif any(os.path.basename(g).rsplit(".", 1)[0].startswith(p["slug"]) and exists(g) for g in p["gallery"]):
            own = next(g for g in p["gallery"] if os.path.basename(g).rsplit(".", 1)[0].startswith(p["slug"]) and exists(g))
            img["own_in_gallery"].append({"slug": p["slug"], "current": p["image"], "own": own})
        elif any(f.startswith(p["slug"]) and f.endswith(".jpg") for f in files):
            own = next(f for f in sorted(files) if f.startswith(p["slug"]) and f.endswith(".jpg"))
            img["own_file_exists"].append({"slug": p["slug"], "current": p["image"], "own": f"/images/opt/{own}"})
        elif base in all_slugs:
            img["borrowed"].append({"slug": p["slug"], "shows": base, "image": p["image"]})
        else:
            img["generic"].append(p["slug"])
    # گالری ممکن است عکس محصولات دیگر را نگه دارد (نمایش نادرست در صفحهٔ محصول)
    foreign_gallery = []
    for p in live:
        for g in p["gallery"]:
            base = os.path.basename(g).rsplit(".", 1)[0]
            if not (base == p["slug"] or base.startswith(p["slug"] + "-")) and base in all_slugs:
                foreign_gallery.append({"slug": p["slug"], "gallery_item": g, "belongs_to": base})
                break
    img["foreign_gallery"] = foreign_gallery
    report["images"] = {k: (v if not isinstance(v, list) else v) for k, v in img.items()}
    report["images"]["counts"] = {k: len(v) for k, v in img.items()}

    # ── ۴) تخفیف‌ها و موجودی ────────────────────────────────────────────────
    bad_old = [{"slug": p["slug"], "price": p["price"], "old_price": p["old_price"]}
               for p in live if p["old_price"] and p["old_price"] <= p["price"]]
    discount_no_old = [p["slug"] for p in live if p["discount"] and not p["old_price"]]
    out_of_stock_visible = [p["slug"] for p in live if p["stock"] <= 0 and p["stock_status"] == "in_stock"]
    report["discounts"] = {"old_price_not_greater_than_price": bad_old,
                           "discount_without_old_price": discount_no_old,
                           "in_stock_status_with_zero_stock": out_of_stock_visible}

    # ── ۵) دسته و متن ───────────────────────────────────────────────────────
    bad_cat = [p["slug"] for p in live if p["category"] not in categories]
    copy_hits = []
    for p in live:
        text = " ".join([p["name"], p["description"] or "",
                         " ".join(str(f.get("value", "")) for f in p["features"])])
        for pattern, label in BAD_COPY:
            if label and re.search(pattern, text):
                copy_hits.append({"slug": p["slug"], "pattern": pattern, "label": label})
    descriptions = Counter((p["description"] or "").strip() for p in live if (p["description"] or "").strip())
    report["content"] = {
        "invalid_category": bad_cat,
        "suspicious_copy": copy_hits,
        "identical_descriptions": {k[:60]: v for k, v in descriptions.items() if v > 1},
        "slogan_present_in_db_text": any(SLOGAN in (p["description"] or "") for p in products),
    }

    # ── ۶) ناهنجاری قیمت بر ۱۰۰ گرم ────────────────────────────────────────
    per100 = []
    for p in live:
        m = re.search(r"([۰-۹0-9٫.,]+)\s*(گرم|کیلوگرم|کیلو)", p["weight"] or "")
        if not m:
            continue
        num = m.group(1).translate(str.maketrans("۰۱۲۳۴۵۶۷۸۹٫", "0123456789.")).replace(",", "")
        try:
            grams = float(num) * (1000 if "کیلو" in m.group(2) else 1)
        except ValueError:
            continue
        if grams <= 0:
            continue
        per100.append({"slug": p["slug"], "weight": p["weight"], "price": p["price"],
                       "per_100g": round(p["price"] / grams * 100)})
    vals = sorted(x["per_100g"] for x in per100)
    if vals:
        median = vals[len(vals) // 2]
        outliers = [x for x in per100 if x["per_100g"] > median * 4 or x["per_100g"] < median / 4]
        report["anomalies"] = {"median_per_100g": median,
                               "outliers": sorted(outliers, key=lambda x: -x["per_100g"])[:20]}
    else:
        report["anomalies"] = {"median_per_100g": None, "outliers": []}

    # ── پرچم‌ها ─────────────────────────────────────────────────────────────
    flags = report["flags"]
    if report["counts"]["delta_vs_baseline"]:
        flags.append(f"شمار کاتالوگ {report['counts']['live_active_visible']} در برابر مبنای {BASELINE} "
                     f"(اختلاف {report['counts']['delta_vs_baseline']:+d})")
    if report["duplicates"]["name"]:
        flags.append(f"{len(report['duplicates']['name'])} نام تکراری در کاتالوگ زنده")
    if img["borrowed"]:
        flags.append(f"{len(img['borrowed'])} محصول عکس محصول دیگر را نشان می‌دهد")
    if feature_weight_mismatch:
        flags.append(f"{len(feature_weight_mismatch)} محصول وزنِ متناقض در features دارد")
    if foreign_gallery:
        flags.append(f"{len(foreign_gallery)} گالری عکس محصول دیگر را نشان می‌دهد")
    if img["file_missing"]:
        flags.append(f"{len(img['file_missing'])} مسیر تصویر روی دیسک نیست")

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(report, ensure_ascii=False, indent=1), encoding="utf-8")
    if "--json" in sys.argv:
        extra = sys.argv[sys.argv.index("--json") + 1]
        Path(extra).write_text(json.dumps(report, ensure_ascii=False, indent=1), encoding="utf-8")

    # ── گزارش انسانی ────────────────────────────────────────────────────────
    c = report["counts"]
    print("── ۱) شمارش ──")
    print(f"  کل رکورد: {c['rows_total']} · فعال و قابل‌نمایش: {c['live_active_visible']} · "
          f"مخفی/آرشیو: {c['archived_or_hidden']} · مبنا: {c['documented_baseline']} "
          f"({c['delta_vs_baseline']:+d})")
    print("\n── ۲) تکراری‌ها ──")
    dup = report["duplicates"]
    print(f"  slug تکراری: {len(dup['slug'])} · sku تکراری: {len(dup['sku'])} · نام تکراری: {len(dup['name'])}")
    for name, slugs in dup["name"].items():
        print(f"    • «{name}» → {', '.join(slugs)}")
    print("\n── ۳) واریانت/قیمت/وزن ──")
    v = report["variants"]
    print(f"  محصول با واریانت: {v['products_with_variants']}")
    print(f"  قیمت پایه بی‌هم‌خوان با واریانت‌ها: {len(v['base_price_not_matching_any_variant'])}")
    print(f"  وزن پایه بی‌هم‌خوان: {len(v['base_weight_not_matching_any_variant'])}")
    print(f"  ویژگی «وزن» متناقض با وزن محصول: {len(v['features_weight_vs_product_weight'])}")
    print(f"  واریانت اول ≠ ارزان‌ترین: {len(v['first_variant_is_not_cheapest'])}")
    print("\n── ۴) تصاویر ──")
    for k, n in report["images"]["counts"].items():
        print(f"  {k}: {n}")
    print("\n── ۵) تخفیف/موجودی ──")
    d = report["discounts"]
    print(f"  old_price ≤ price: {len(d['old_price_not_greater_than_price'])} · "
          f"تخفیف بدون old_price: {len(d['discount_without_old_price'])} · "
          f"موجودی صفر با وضعیت «موجود»: {len(d['in_stock_status_with_zero_stock'])}")
    print("\n── ۶) محتوا ──")
    print(f"  دستهٔ نامعتبر: {len(report['content']['invalid_category'])} · "
          f"متن مشکوک: {len(report['content']['suspicious_copy'])} · "
          f"توضیح یکسان تکراری: {len(report['content']['identical_descriptions'])}")
    print("\n── ۷) ناهنجاری قیمت ──")
    a = report["anomalies"]
    print(f"  میانهٔ قیمت بر ۱۰۰ گرم: {a['median_per_100g']} تومان · ناهنجار: {len(a['outliers'])}")
    for o in a["outliers"][:5]:
        print(f"    • {o['slug']}: {o['price']:,} برای {o['weight']} → {o['per_100g']:,}/۱۰۰گ")
    print("\n── پرچم‌ها ──")
    for f in flags:
        print("  ▲", f)
    print(f"\nگزارش JSON: {OUT.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
