# ۲۱ — دروازهٔ انتشار یک‌فرمانی

**تاریخ:** ۲۰۲۶-۱۰-۲۳ · **وضعیت:** ساخته و آزموده شد

## چه ساخته شد

| فایل | نقش |
| --- | --- |
| `scripts/preflight-env.mjs` | گارد محیط **قبل از بیلد**؛ نبودِ `ALLOW_INDEXING=1` بیلد را متوقف می‌کند |
| `scripts/deploy-check.sh` | دروازهٔ **پس از استقرار**؛ ۲۹ بررسی روی دامنهٔ واقعی، خروجی GO/NO-GO |
| `render.yaml` | `buildCommand` با پیش‌پرواز + کلیدهای تازه (اندروید، نشان اعتماد، درگاه) |
| `package.json` | `preflight` · `preflight:prod` · `deploy:check` · `deploy:check:full` · `build:prod` |

## شاهد آزمون

**پیش‌پرواز، حالت سخت‌گیرانه، بدون env:**
```
✗ NEXT_PUBLIC_SITE_URL تنظیم نشده … ✗ AUTH_SECRET … ✗ CARD_TRANSFER_NUMBER …
نتیجه: 7 بلوکر · 9 هشدار ⇒ ⛔ NO-GO      (exit 1)
```

**پیش‌پرواز با env کامل:** `7 تأیید · 8 هشدار · 0 بلوکر ⇒ 🟢 GO` (exit 0)
هشدارها همان چیزهایی است که واقعاً خالی است: SMS، ایمیل، درگاه، نماد اعتماد، اثر انگشت اندروید.

**دروازهٔ انتشار روی سرور محلی:**
```
PASS=27 · WARN=1 · FAIL=0 ⇒ 🟢 GO
(assetlinks.json → ۴۰۴ صادقانه: ANDROID_APP_SHA256 تنظیم نشده)
```
**با `--full`:** `PASS=29 · WARN=1 · FAIL=0` — شامل `axe: 0 نقض در ۱۳ صفحه` و `PWA 11/0/0`.

**تست منفی که یک باگ واقعی نشان داد:** نسخهٔ اول `/api/health` را با grep ساده می‌خواند
و پاسخ تودرتوی `{"ok":true,"status":"healthy","database":{"configured":true,"reachable":true}}`
را «دیتابیس قطع» تفسیر می‌کرد ⇒ NO-GO کاذب. با تجزیهٔ JSON واقعی رفع شد
(`configured is True and reachable is True`). درس: دروازهٔ کاذب بدتر از نبودِ دروازه است.

## خط لولهٔ پیشنهادی CI

```yaml
- run: npm ci
- run: npm run preflight:prod      # متوقف‌شدن بیلد اگر ALLOW_INDEXING/دامنه/کارت نباشد
- run: npm run lint && npx tsc --noEmit && npm run test:unit
- run: npm run build
- run: npm run deploy:check:full   # بعد از deploy، روی دامنهٔ مقصد
```

## محدودیت‌ها

- `deploy:check` خودش بررسی نمی‌کند که *محتوای* دیتابیس درست است؛ برای آن
  `scripts/data-integrity.sql` روی دیتابیس مقصد لازم است (نیازمند دسترسی مستقیم).
- `--full` نیاز به Playwright و مرورگر نصب‌شده دارد؛ روی CI با
  `npx playwright install --with-deps chromium`.
- هویت حقوقی فروشنده و `ANDROID_APP_SHA256` دادهٔ مالک است؛ دروازه فقط نبودشان را
  هشدار می‌دهد و هرگز مقدار ساختگی جایگزین نمی‌کند.
