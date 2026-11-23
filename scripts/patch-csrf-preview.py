#!/usr/bin/env python3
"""
پچ CSRF پیش‌نمایش برای src/lib/security.ts  (idempotent)

مسئله: پراکسی پیش‌نمایش (https://{port}-{id}.e2b.app) هدرهای X-Forwarded-Host/Proto را
همیشه ست نمی‌کند. نتیجه: Origin مرورگر (https) با Origin مجاز سرور (http://host) برابر
نبود و همهٔ POSTها ۴۰۳ می‌گرفتند — پنل «خریدت رو کامل‌تر کن» پیام «اتصال برقرار نشد»
نشان می‌داد (همچنین /api/cart/check و /api/products/cross-sell).

راه‌حل: ۱) همان میزبان با هر دو طرح‌واره مجاز شود ۲) خارج از production، Originهای
پیش‌نمایش/محلی مجاز شوند. محافظت CSRF برای دامنهٔ بیگانه دست‌نخورده می‌ماند.

اجرا:  python3 scripts/patch-csrf-preview.py
"""
import os
import sys

P = "src/lib/security.ts"

HELPER = '''
const DEV_PREVIEW_HOST = /^(localhost|127\\.0\\.0\\.1|\\[::1\\]|0\\.0\\.0\\.0)$|^[a-z0-9-]+(\\.[a-z0-9-]+)*\\.e2b\\.app$/i;

function isDevPreviewOrigin(origin: string): boolean {
  if (isProduction()) return false;
  try {
    const u = new URL(origin);
    if (u.protocol !== "http:" && u.protocol !== "https:") return false;
    return DEV_PREVIEW_HOST.test(u.hostname);
  } catch {
    return false;
  }
}
'''

ANCHOR_HOST = '  if (host && !host.startsWith("0.0.0.0")) set.add(`${proto}://${host}`);'
HOST_NEW = '''  if (host && !host.startsWith("0.0.0.0")) {
    set.add(`${proto}://${host}`);
    set.add(`${proto === "https" ? "http" : "https"}://${host}`);
  }'''

ANCHOR_PROD = "\nexport function isProduction(): boolean {"
ANCHOR_CHECK = '  if (headerOrigin) return allowed.has(headerOrigin);'
CHECK_NEW = '  if (headerOrigin) return allowed.has(headerOrigin) || isDevPreviewOrigin(headerOrigin);'


def main() -> int:
    if not os.path.exists(P):
        print(f"✗ {P} پیدا نشد")
        return 1
    s = open(P, encoding="utf-8").read()
    if "isDevPreviewOrigin" in s:
        print("✓ از قبل پچ شده است (بدون تغییر)")
        return 0

    for anchor, label in ((ANCHOR_HOST, "host"), (ANCHOR_PROD, "prod"), (ANCHOR_CHECK, "check")):
        if anchor not in s:
            print(f"✗ لنگر «{label}» پیدا نشد — security.ts دستی بررسی شود")
            return 1

    s = s.replace(ANCHOR_HOST, HOST_NEW, 1)
    s = s.replace(ANCHOR_PROD, HELPER + ANCHOR_PROD, 1)
    s = s.replace(ANCHOR_CHECK, CHECK_NEW, 1)
    open(P, "w", encoding="utf-8").write(s)
    print("✓ security.ts پچ شد (CSRF پیش‌نمایش)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
