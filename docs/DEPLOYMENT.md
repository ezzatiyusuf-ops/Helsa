# راهنمای استقرار (DEPLOYMENT)

> مسیر رسمی: **Cloudflare Workers + OpenNext**. جزئیات کامل معماری CF: `docs/CLOUDFLARE.md` · متغیرها: `docs/ENVIRONMENT.md` · تست: `docs/TESTING.md`.

## ۱) پیش‌نیازها

- Node.js ≥ 20 (برای wrangler ≥ 22) — محلی این پروژه با Node 22 تست شده
- PostgreSQL میزبانی‌شده (Supabase / Neon / Railway / …) با TLS
- اکانت Cloudflare + wrangler لاگین (`npx wrangler login`)

## ۲) پیکربندی

```bash
cp .env.production.example .env     # مقادیر واقعی را بگذارید
npx wrangler secret put DATABASE_URL
npx wrangler secret put AUTH_SECRET
# و بقیهٔ متغیرها طبق docs/ENVIRONMENT.md (Dashboard → Workers → Settings → Variables)
```

## ۳) مایگریشن دیتابیس (از CI/محلی، نه از Worker)

```bash
npm run db:migrate       # drizzle-kit migrate — اتصال مستقیم
npm run db:backup        # بکاپ پیش از هر تغییر (pg_dump)
```

## ۴) بیلد و راستی‌آزمایی

```bash
npm test                          # typecheck + lint + unit — باید سبز باشد
npm run cf:build:local            # روی باکس کم‌حافظه (بیلد جدا + skipNextBuild)
npx wrangler deploy --dry-run     # بررسی باندل بدون انتشار
```

نتیجهٔ مرجع آخرین اجرا: بیلد ۱۸۴ پیش‌رندر محصول · باندل 14579.70 KiB / gzip 2980.31 KiB.

## ۵) انتشار

```bash
npm run deploy        # = cf:build + opennextjs-cloudflare deploy
```

## ۶) پس از انتشار (Smoke test)

1. `GET /api/health` → سالم
2. چند صفحهٔ کلیدی: `/`، `/products`، یک صفحه محصول، `/cart`، `/login`
3. `npx wrangler tail` — پایش لاگ زنده برای خطا
4. سفارش آزمایشی COD یا پیش‌پرداخت در حالت sandbox

## استقرار محلی (توسعه)

```bash
npm run dev                            # توسعه
NODE_OPTIONS=--max-old-space-size=1100 npm run build   # بیلد محلی (بدون standalone)
npm run start                          # next start — با standalone ناسازگار است
```

## بازیابی

- بکاپ دیتابیس: `scripts/backup-db.sh` / بازیابی: `scripts/restore-db.sh` (فهرست بکاپ‌ها و رویه در `docs/backup-restore.md`)
- بازیابی env: `npm run env:recovery`
- Rollback: نسخهٔ قبلی Worker از Dashboard → Deployments → Rollback (یا deploy مجدد کامیت قبلی)

## موارد باز (نیازمند مقادیر واقعی از مشتری)

زرین‌پال (کلید API) · کاوه‌نگار (SMS) · کدهای Enamad/Samandehi/درگاه · تأیید نهایی هزینهٔ ارسال ۸۵٬۰۰۰ تومانی · دامنهٔ نهایی DNS.

---

# دروازهٔ انتشار — یک فرمان (نسخهٔ ۲۰۲۶-۱۰-۲۳)

از این نسخه دو چیز جدید اضافه شده تا خطای انسانی در استقرار حذف شود:

## ۱) `scripts/preflight-env.mjs` — گارد محیط (قبل از بیلد)

```bash
npm run preflight        # محیط محلی (نرم؛ از .env می‌خواند)
npm run preflight:prod   # سخت‌گیرانه؛ روی CI/Render خودکار همین اجرا می‌شود
```

اگر `ALLOW_INDEXING=1` نباشد، **بیلد متوقف می‌شود**. دلیل: متادیتای `robots` در Next
در زمان بیلد پخته می‌شود؛ بیلد بدون این متغیر کل سایت — از جمله صفحات محصول — را
با `noindex` منتشر می‌کند و ست‌کردن متغیر در زمان اجرا هیچ کمکی نمی‌کند.
همین بررسی برای `NEXT_PUBLIC_SITE_URL` (https و غیر‌محلی)، `DATABASE_URL`،
`AUTH_SECRET` (≥۳۲ نویسه) و سه کلید کارت‌به‌کارت هم انجام می‌شود.
کلیدهای اختیاری (SMS، ایمیل، نماد اعتماد، اثر انگشت اندروید…) فقط **هشدار** می‌دهند،
چون نبودشان قابلیت را خاموش می‌کند نه سایت را.

## ۲) `scripts/deploy-check.sh` — دروازهٔ پس از استقرار

```bash
npm run deploy:check                       # دامنهٔ پیش‌فرض helsairanian.ir
npm run deploy:check:full                  # + axe-core و PWA (نیازمند Playwright)
bash scripts/deploy-check.sh https://staging.example.com
bash scripts/deploy-check.sh http://127.0.0.1:3000 --local
```

۲۹ بررسی در ۷ گروه، روی همان دامنه‌ای که کاربر می‌بیند:

| گروه | نمونهٔ بررسی |
| --- | --- |
| سرویس/دیتابیس | `/` = ۲۰۰ · `/api/health` با `database.configured/reachable` |
| ایندکس‌پذیری | `robots` روی خانه، `/products` و یک PDP **باید** `index` باشد (تلهٔ noindex) |
| robots/sitemap | دامنهٔ واقعی در `Sitemap:` · تعداد آدرس‌ها با احتساب نقشه‌های فرزند |
| امنیت | HSTS · nosniff · ضد iframe · referrer · CSP · Permissions-Policy |
| صفحات ضروری | `/terms` `/privacy` `/refund` `/shipping` `/contact` `/faq` `/products` `/cart` |
| App Links | `/.well-known/assetlinks.json` = ۲۰۰ با اثر انگشت یا ۴۰۴ صادقانه |
| ممیزی | SEO · UI · کنتراست · حقوقی · (در `--full`: axe و PWA) |

کد خروج `0` = GO و `1` = NO-GO، و گزارش در `helsa-audit/deploy-check-<UTC>.txt` ذخیره می‌شود.
این اسکریپت را در CI بعد از مرحلهٔ deploy بگذارید تا استقرار خراب، سبز اعلام نشود.

## ۳) `render.yaml`

`buildCommand` حالا این است:

```
npm ci && node scripts/preflight-env.mjs --production && npm run build
```

و `ALLOW_INDEXING`/`NEXT_PUBLIC_SITE_URL`/`NODE_OPTIONS`/`FORCE_SECURE_COOKIES` صریحاً
در بخش `envVars` آمده‌اند، به‌همراه `ANDROID_APP_SHA256`، `ENAMAD_ID`/`SAMANDEHI_ID`
و کلیدهای درگاه بانکی با `sync: false` (دستی در داشبورد).
