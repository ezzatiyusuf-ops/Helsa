#!/usr/bin/env python3
"""
انتشار مستقیم «خریدت رو کامل‌تر کن» روی برنچ main — بدون clone سنگین.

روش: GitHub Git Data API (blob/tree/commit/ref). فقط فایل‌هایی آپلود می‌شوند که
محتوایشان با main تفاوت دارد؛ همهٔ محاسبات و مقایسه‌ها با sha1 گیت انجام می‌شود.

اجرا:
    GH_TOKEN=ghp_xxx python3 /home/user/helsa/scripts/publish-upsell.py            # خشک (فقط گزارش)
    GH_TOKEN=ghp_xxx python3 /home/user/helsa/scripts/publish-upsell.py --apply    # واقعی

توکن: Fine-grained یا classic با دسترسی «Contents: Read and write» روی همین ریپو.
هیچ توکنی داخل فایل نوشته نمی‌شود؛ فقط از env خوانده می‌شود.
"""
from __future__ import annotations

import base64
import hashlib
import json
import os
import sys
import urllib.error
import urllib.request

REPO = "ezzatiyusuf-ops/Helsa-web"
BRANCH = "main"
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
API = "https://api.github.com"

# فایل‌های قابلیت (نسبت به ریشهٔ ریپو)
FILES = [
    "CART-UPSELL-PLAN.md",
    "UPSELL-REPORT.md",
    "src/lib/upsell.ts",
    "src/lib/upsell-store.ts",
    "src/data/product-relations.ts",
    "src/app/api/products/upsell/route.ts",
    "src/components/cart/useAddWithUpsell.ts",
    "src/components/cart/CartUpsellDrawer.tsx",
    "src/components/layout/Shell.tsx",
    "src/components/product/ProductCard.tsx",
    "src/components/product/ProductDetailClient.tsx",
    "tests/upsell.test.ts",
    "scripts/qa-upsell-e2e.mjs",
    "scripts/fix-catalog-consistency.sql",
    "src/lib/security.ts",
    "scripts/patch-csrf-preview.py",
    "scripts/qa-csrf-preview.mjs",
    "src/data/products.ts",
    "package.json",
    "src/app/about/page.tsx",
    "src/app/contact/ContactClient.tsx",
    "public/images/editorial/about-origin.jpg",
    "public/images/editorial/about-nature.jpg",
    "public/images/editorial/about-sourcing.jpg",
    "public/images/editorial/about-quality.jpg",
    "public/images/editorial/about-packaging.jpg",
    "public/images/editorial/about-hospitality.jpg",
    "public/images/editorial/contact-welcome.jpg",
    "EDITORIAL-PHOTOS.md",
]

COMMIT_MESSAGE = (
    "قابلیت: خریدت رو کامل‌تر کن (پیشنهاد مکمل/مشابه پس از افزودن به سبد)\n\n"
    "- موتور پیشنهاد خالص و قطعی: رابطهٔ صریح ← قاعدهٔ مکمل دسته‌ای ← هم‌دستهٔ نزدیک‌ترین قیمت ← fallback\n"
    "- API تازه: POST /api/products/upsell (zod + same-origin + rate-limit)، قیمت/موجودی فقط سمت سرور\n"
    "- پنل/کشو RTL با دو بخش مکمل و مشابه؛ موبایل شیت پایین‌چسب؛ Esc/فوکوس‌ترپ/reduced-motion\n"
    "- افزودن پیشنهاد با همان addItem موجود سبد (کلید variant-scoped، بدون سبد موازی)\n"
    "- کش تنبل + یکی‌سازی درخواست‌ها؛ بدون migration و بدون تغییر در cross-sell/Modal مشترک\n"
    "- تست: ۱۲ تست موتور + ۲۰ بررسی مرورگری (dev و build تولیدی) + tsc/eslint/next build پاک"
)

TOKEN = os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN") or ""
APPLY = "--apply" in sys.argv


def blob_sha(data: bytes) -> str:
    """sha1 همان چیزی که گیت برای blob محاسبه می‌کند."""
    return hashlib.sha1(b"blob %d\0" % len(data) + data).hexdigest()


def api(path: str, method: str = "GET", body: dict | None = None, token: str | None = None):
    url = path if path.startswith("http") else f"{API}{path}"
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(url, data=data, method=method)
    req.add_header("Accept", "application/vnd.github+json")
    req.add_header("X-GitHub-Api-Version", "2022-11-28")
    req.add_header("User-Agent", "helsa-upsell-publisher")
    if data is not None:
        req.add_header("Content-Type", "application/json")
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    try:
        with urllib.request.urlopen(req, timeout=60) as r:
            return json.loads(r.read() or b"{}")
    except urllib.error.HTTPError as e:
        detail = e.read().decode(errors="replace")[:400]
        raise SystemExit(f"✗ GitHub API {e.code} روی {path}\n  {detail}") from None


def main() -> None:
    print(f"▸ ریپو: {REPO} · برنچ: {BRANCH} · حالت: {'APPLY' if APPLY else 'DRY-RUN'}")

    ref = api(f"/repos/{REPO}/git/ref/heads/{BRANCH}", token=TOKEN or None)
    base_commit = ref["object"]["sha"]
    commit = api(f"/repos/{REPO}/git/commits/{base_commit}", token=TOKEN or None)
    base_tree = commit["tree"]["sha"]
    print(f"▸ HEAD فعلی: {base_commit[:10]} — {commit['message'].splitlines()[0][:60]}")

    tree = api(f"/repos/{REPO}/git/trees/{base_tree}?recursive=1", token=TOKEN or None)
    remote = {e["path"]: e["sha"] for e in tree["tree"] if e["type"] == "blob"}

    changed, added, unchanged, missing = [], [], [], []
    payload: dict[str, bytes] = {}
    for rel in FILES:
        local_path = os.path.join(ROOT, rel)
        if not os.path.exists(local_path):
            missing.append(rel)
            continue
        data = open(local_path, "rb").read()
        payload[rel] = data
        sha = blob_sha(data)
        remote_sha = remote.get(rel)
        if remote_sha is None:
            added.append(rel)
        elif remote_sha != sha:
            changed.append(rel)
        else:
            unchanged.append(rel)

    print(f"\n▸ فایل‌های قابلیت: {len(FILES)}  →  تازه {len(added)} · تغییرکرده {len(changed)} · بدون تغییر {len(unchanged)}")
    for rel in added:
        print(f"   + {rel}")
    for rel in changed:
        print(f"   ~ {rel}")
    if unchanged:
        print("   = " + " · ".join(unchanged))
    if missing:
        print("✗ فایل‌های ناموجود در کپی کاری: " + " · ".join(missing))
        raise SystemExit(1)

    todo = added + changed
    if not todo:
        print("\n✓ main همین حالا با کپی کاری یکسان است؛ چیزی برای انتشار نیست.")
        return

    if not APPLY:
        print("\n(خشک) برای انتشار واقعی: --apply و توکن لازم است.")
        return
    if not TOKEN:
        raise SystemExit("✗ توکن نیست: GH_TOKEN=… را ست کن.")

    print("\n▸ آپلود blobها…")
    entries = []
    for rel in todo:
        blob = api(f"/repos/{REPO}/git/blobs", "POST",
                   {"content": base64.b64encode(payload[rel]).decode(), "encoding": "base64"}, TOKEN)
        entries.append({"path": rel, "mode": "100644", "type": "blob", "sha": blob["sha"]})
        print(f"   ✓ {rel}")

    print("▸ ساخت tree و commit…")
    new_tree = api(f"/repos/{REPO}/git/trees", "POST", {"base_tree": base_tree, "tree": entries}, TOKEN)
    new_commit = api(f"/repos/{REPO}/git/commits", "POST",
                     {"message": COMMIT_MESSAGE, "tree": new_tree["sha"], "parents": [base_commit]}, TOKEN)
    api(f"/repos/{REPO}/git/refs/heads/{BRANCH}", "PATCH",
        {"sha": new_commit["sha"], "force": False}, TOKEN)
    print(f"✓ پوش انجام شد: {new_commit['sha']}")
    print(f"  https://github.com/{REPO}/commit/{new_commit['sha']}")

    # راستی‌آزمایی واقعی: محتوای فایل کلیدی از main خوانده و مقایسه می‌شود
    check = "src/components/cart/CartUpsellDrawer.tsx"
    remote_file = api(f"/repos/{REPO}/contents/{check}?ref={BRANCH}", token=TOKEN)
    ok = remote_file.get("sha") == blob_sha(payload[check])
    print(("✓ راستی‌آزمایی: " if ok else "✗ راستی‌آزمایی ناموفق: ") + check)
    with open("/home/user/PUSH-SUCCESS.txt", "w", encoding="utf-8") as f:
        f.write(f"{new_commit['sha']}\nhttps://github.com/{REPO}/commit/{new_commit['sha']}\n")
    raise SystemExit(0 if ok else 1)


if __name__ == "__main__":
    main()
