#!/usr/bin/env python3
"""
catalog-reconcile.py — اصلاح برگشت‌پذیر ناسازگاری‌های کاتالوگ
─────────────────────────────────────────────────────────────────────────────
اصل «اول ممیزی، بعد تغییر برگشت‌پذیر، آخر تأیید»:
  · پیش‌فرض = dry-run (هیچ نوشتنی انجام نمی‌شود)
  · هر تغییر با همان مقدارِ قبلی در یک فایل restore ثبت می‌شود
  · هیچ داده‌ای حذف نمی‌شود («آرشیو» = is_active=false + is_visible=false + archived_at)
  · هیچ نام/قیمت/وزن/عکسی ساخته نمی‌شود؛ فقط مسیر عکس‌ها به فایلی که خودش روی دیسک هست
    اصلاح می‌شود، و برای محصولی که عکس تأییدشده ندارد، تصویر خنثی گذاشته می‌شود.

    python3 scripts/catalog-reconcile.py            # نمایش اقدامات
    python3 scripts/catalog-reconcile.py --apply    # اجرا + ساخت فایل بازگردانی

دسته‌های اقدام (همه idempotent):
  A. آرشیو محصولات خارج از کاتالوگ مبنا        (HOLD-*)
  B. آرشیو رکورد تکراری (ادغام در رکورد اصلی)  (DUP-*)
  C. اصلاح مسیر عکس به عکس واقعی خودِ محصول     (IMG-FIX)
  D. تصویر خنثی برای محصولی که عکسِ محصول دیگر را نشان می‌دهد (IMG-PLACEHOLDER)
  E. یکسان‌سازی وزنِ نسخهٔ «features» با وزن محصول (WEIGHT-FEATURES)
"""
from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DSN = os.environ.get("DATABASE_URL", "postgresql://helsa:helsa_dev_pw@127.0.0.1:5432/helsa_db")
AUDIT = ROOT / "helsa-audit" / "catalog-audit.json"
PLACEHOLDER = "/images/placeholder.svg"

# رکوردهایی که بیرون از کاتالوگ ۱۸۴تاییِ مستندشده اضافه شده‌اند (بر پایهٔ شاهد: created_at و اسکریپت افزودن)
HOLD = {
    "moiz-uzbek": "افزوده‌شده پس از مبنای ۱۸۴ (HLA-0036 · scripts/add-moiz-uzbek.sql · داده و عکس اعلامی مالک) — در انتظار تأیید مالک",
    "date-coconut-sugar": "افزوده‌شده پس از مبنای ۱۸۴ (HLA-0037 · scripts/add-date-coconut-sugar.sql · داده و عکس اعلامی مالک) — در انتظار تأیید مالک",
}
# رکورد تکراری: «آجیل چهارمغز» دو بار (HLA-0014 نگه داشته می‌شود)
DUPLICATE = {
    "four-kernel-nuts": "تکرار «آجیل چهارمغز»؛ رکورد اصلی: four-nut-mix (HLA-0014)",
}


def psql(sql: str, tuples: bool = True) -> str:
    cmd = ["psql", DSN, "-v", "ON_ERROR_STOP=1", "-A", "-F", "\x1f"]
    if tuples:
        cmd.append("-t")
    cmd += ["-c", sql]
    p = subprocess.run(cmd, capture_output=True, text=True)
    if p.returncode != 0:
        print("خطای psql:", p.stderr.strip(), file=sys.stderr)
        sys.exit(2)
    return p.stdout


def sql_lit(s: str) -> str:
    return "'" + s.replace("'", "''") + "'"


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--apply", action="store_true", help="اجرای واقعی تغییرات")
    args = ap.parse_args()
    if not AUDIT.exists():
        print("ابتدا `python3 scripts/catalog-audit.py` را اجرا کنید.", file=sys.stderr)
        return 2
    audit = json.loads(AUDIT.read_text(encoding="utf-8"))

    rows = psql("""
        select id, slug, image, image_status, gallery::text, features::text, weight,
               is_active, is_visible, archived_at is not null
        from products order by id
    """).strip().split("\n")
    db = {}
    for r in rows:
        f = r.split("\x1f")
        db[f[1]] = {"id": int(f[0]), "image": f[2], "image_status": f[3],
                    "gallery": f[4], "features": f[5], "weight": f[6],
                    "is_active": f[7] == "t", "is_visible": f[8] == "t",
                    "archived": f[9] == "t"}

    stmts: list[str] = []
    undo: list[str] = []
    plan: list[dict] = []

    # ── A) خارج از کاتالوگ مبنا ────────────────────────────────────────────
    for slug, why in HOLD.items():
        p = db.get(slug)
        if not p:
            continue
        if p["archived"] and not p["is_active"]:
            plan.append({"action": "HOLD", "slug": slug, "state": "از قبل آرشیو"})
            continue
        stmts.append(f"update products set is_active=false, is_visible=false, archived_at=now(), updated_at=now() where slug={sql_lit(slug)};")
        undo.append(f"update products set is_active={str(p['is_active']).lower()}, is_visible={str(p['is_visible']).lower()}, archived_at=null, updated_at=now() where slug={sql_lit(slug)};")
        plan.append({"action": "HOLD", "slug": slug, "why": why})

    # ── B) رکورد تکراری ────────────────────────────────────────────────────
    for slug, why in DUPLICATE.items():
        p = db.get(slug)
        if not p or (p["archived"] and not p["is_active"]):
            continue
        stmts.append(f"update products set is_active=false, is_visible=false, archived_at=now(), updated_at=now() where slug={sql_lit(slug)};")
        undo.append(f"update products set is_active={str(p['is_active']).lower()}, is_visible={str(p['is_visible']).lower()}, archived_at=null, updated_at=now() where slug={sql_lit(slug)};")
        plan.append({"action": "DUP", "slug": slug, "why": why})

    # ── C) مسیر عکس اشتباه، ولی عکس خودِ محصول موجود است ───────────────────
    fixes = audit["images"]["own_in_gallery"] + audit["images"]["own_file_exists"]
    for f in fixes:
        p = db.get(f["slug"])
        if not p or p["archived"]:
            continue
        if p["image"] == f["own"]:
            continue
        gal = json.loads(p["gallery"]) if p["gallery"] else []
        new_gal = [f["own"]] + [g for g in gal if g != f["own"]]
        stmts.append(
            f"update products set image={sql_lit(f['own'])}, gallery={sql_lit(json.dumps(new_gal, ensure_ascii=False))}::jsonb, "
            f"image_status='owner_photo', updated_at=now() where slug={sql_lit(f['slug'])};"
        )
        undo.append(
            f"update products set image={sql_lit(p['image'])}, gallery={sql_lit(p['gallery'] or '[]')}::jsonb, "
            f"image_status={sql_lit(p['image_status'])}, updated_at=now() where slug={sql_lit(f['slug'])};"
        )
        plan.append({"action": "IMG-FIX", "slug": f["slug"], "from": p["image"], "to": f["own"]})

    # ── D) عکسِ محصول دیگر → تصویر خنثی (بدون جعل عکس جایگزین) ────────────
    for b in audit["images"]["borrowed"]:
        p = db.get(b["slug"])
        if not p or p["archived"] or p["image"] == PLACEHOLDER:
            continue
        stmts.append(
            f"update products set image={sql_lit(PLACEHOLDER)}, gallery='[]'::jsonb, "
            f"image_status='awaiting_owner_photo', updated_at=now() where slug={sql_lit(b['slug'])};"
        )
        undo.append(
            f"update products set image={sql_lit(p['image'])}, gallery={sql_lit(p['gallery'] or '[]')}::jsonb, "
            f"image_status={sql_lit(p['image_status'])}, updated_at=now() where slug={sql_lit(b['slug'])};"
        )
        plan.append({"action": "IMG-PLACEHOLDER", "slug": b["slug"], "was": b["image"], "showed": b["shows"]})

    # ── E) weight در features ──────────────────────────────────────────────
    for item in audit["variants"]["features_weight_vs_product_weight"]:
        p = db.get(item["slug"])
        if not p or p["archived"]:
            continue
        feats = json.loads(p["features"]) if p["features"] else []
        new_feats = [({**f, "value": item["product_weight"]} if f.get("label") == "وزن" else f) for f in feats]
        if feats == new_feats:
            continue
        stmts.append(
            f"update products set features={sql_lit(json.dumps(new_feats, ensure_ascii=False))}::jsonb, "
            f"updated_at=now() where slug={sql_lit(item['slug'])};"
        )
        undo.append(
            f"update products set features={sql_lit(p['features'] or '[]')}::jsonb, updated_at=now() where slug={sql_lit(item['slug'])};"
        )
        plan.append({"action": "WEIGHT-FEATURES", "slug": item["slug"],
                     "from": item["features_weight"], "to": item["product_weight"]})

    # ── F) گالری: عکس‌های محصولات دیگر را نگه ندار ────────────────────────
    live_rows = psql("select slug, image, gallery::text from products where is_active and is_visible order by slug")
    for line in live_rows.strip().split("\n"):
        if not line.strip():
            continue
        slug, image, gal_txt = line.split("\x1f")
        p = db.get(slug)
        if not p:
            continue
        try:
            gal = json.loads(gal_txt) if gal_txt else []
        except Exception:
            gal = []
        own = [g for g in gal if os.path.basename(g).rsplit(".", 1)[0].startswith(slug)]
        if image and image not in own and os.path.basename(image).rsplit(".", 1)[0].startswith(slug):
            own = [image] + own
        if len(own) == len(gal) and own == gal:
            continue
        stmts.append(
            f"update products set gallery={sql_lit(json.dumps(own, ensure_ascii=False))}::jsonb, updated_at=now() "
            f"where slug={sql_lit(slug)};"
        )
        undo.append(
            f"update products set gallery={sql_lit(p['gallery'] or '[]')}::jsonb, updated_at=now() where slug={sql_lit(slug)};"
        )
        plan.append({"action": "IMG-GALLERY", "slug": slug, "removed": len(gal) - len(own), "kept": len(own)})

    # ── G) وزن پایه‌ای که با قیمت پایه نمی‌خواند ────────────────────────────
    # اگر قیمت سطح محصول **دقیقاً** با یک واریانت برابر باشد، همان بسته، بستهٔ پایه است؛
    # وزنِ ثبت‌شده در ردیف محصول باید همان باشد (نه یک عدد دلخواه دیگر).
    mism = audit["variants"]["base_weight_not_matching_any_variant"]
    if mism:
        vrows = psql("""
            select p.slug, p.price, p.weight, v.name, v.price
            from products p join product_variants v on v.product_id = p.id and v.is_active
            where p.is_active and p.is_visible
        """).strip().split("\n")
        by_slug: dict[str, list[tuple[str, int]]] = {}
        base: dict[str, tuple[int, str]] = {}
        for line in vrows:
            slug, price, weight, vname, vprice = line.split("\x1f")
            by_slug.setdefault(slug, []).append((vname, int(vprice)))
            base[slug] = (int(price), weight)
        for item in mism:
            slug = item["slug"]
            if slug not in base:
                continue
            bprice, bweight = base[slug]
            matches = [n for n, pr in by_slug.get(slug, []) if pr == bprice]
            if len(matches) != 1:
                continue  # مبهم است ⇒ دست نمی‌زنیم، فقط در گزارش ممیزی می‌ماند
            p = db.get(slug)
            if not p:
                continue
            stmts.append(
                f"update products set weight={sql_lit(matches[0])}, updated_at=now() where slug={sql_lit(slug)};"
            )
            undo.append(
                f"update products set weight={sql_lit(bweight)}, updated_at=now() where slug={sql_lit(slug)};"
            )
            plan.append({"action": "BASE-WEIGHT", "slug": slug, "from": bweight, "to": matches[0]})

    # ── گزارش برنامه ───────────────────────────────────────────────────────
    by_action: dict[str, int] = {}
    for a in plan:
        by_action[a["action"]] = by_action.get(a["action"], 0) + 1
    print("── برنامهٔ اصلاح ──")
    for k, v in sorted(by_action.items()):
        print(f"  {k}: {v}")
    for a in plan:
        extra = a.get("why") or a.get("to") or ""
        print(f"    · {a['action']:<16} {a['slug']:<26} {extra[:70]}")

    if not args.apply:
        print("\nحالت dry-run — هیچ تغییری اعمال نشد. اجرای واقعی: --apply")
        return 0
    if not stmts:
        print("\nچیزی برای تغییر نیست (idempotent).")
        return 0

    stamp = dt.datetime.now(dt.timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    backup = ROOT / "helsa-audit" / f"backup-catalog-{stamp}.sql"
    dump = subprocess.run(["pg_dump", DSN, "--data-only", "-t", "products", "-t", "product_variants"],
                          capture_output=True, text=True)
    if dump.returncode == 0:
        backup.write_text(dump.stdout, encoding="utf-8")
        print(f"\nپشتیبان: {backup.relative_to(ROOT)} ({len(dump.stdout)//1024}KB)")

    # گالری در D خالی می‌شود ولی در undo از مقدار قبلی پر می‌شود — فایل بازگردانی خودکار:
    restore = ROOT / "helsa-audit" / f"catalog-restore-{stamp}.sql"
    restore.write_text(
        "-- بازگردانی کامل تغییرات catalog-reconcile (همهٔ مقادیر قبلی)\n"
        f"-- ساخته‌شده: {stamp}\nBEGIN;\n" + "\n".join(undo) + "\nCOMMIT;\n", encoding="utf-8")

    psql("BEGIN;\n" + "\n".join(stmts) + "\nCOMMIT;")
    print(f"اعمال شد: {len(stmts)} دستور")
    print(f"فایل بازگردانی: {restore.relative_to(ROOT)}")
    (ROOT / "helsa-audit" / f"catalog-reconcile-plan-{stamp}.json").write_text(
        json.dumps({"plan": plan, "restore": str(restore.name)}, ensure_ascii=False, indent=1), encoding="utf-8")
    return 0


if __name__ == "__main__":
    sys.exit(main())
