# استقرار هلسا (DEPLOYMENT)

> فاز ۲۱ چک‌لیست کامل پایین همین سند است. برای امنیت تولید `docs/SECURITY.md` §۷ را هم بخوانید.

## پیش‌نیاز

- Node.js ۲۰+
- PostgreSQL در دسترس از سرور تولید (ترجیحاً با SSL)
- دامنه با HTTPS

## گام ۱ — متغیرهای محیطی تولید

حداقل موارد زیر را روی سرویس میزبان تنظیم کنید:

```
DATABASE_URL=postgresql://user:pass@host:5432/db?sslmode=require
NEXT_PUBLIC_SITE_URL=https://helsairanian.ir
AUTH_SECRET=<openssl rand -base64 48>
```

و در صورت نیاز:

```
GOOGLE_CLIENT_ID= / GOOGLE_CLIENT_SECRET=
APPLE_CLIENT_ID= / APPLE_TEAM_ID= / APPLE_KEY_ID= / APPLE_PRIVATE_KEY=
GATEWAY_PROVIDER= / GATEWAY_API_KEY=
SMS_PROVIDER= / SMS_API_KEY=
```

> هرگز `.env` واقعی را در مخزن قرار ندهید؛ تنها `.env.example` نگهداری می‌شود.

## گام ۲ — آماده‌سازی دیتابیس

```bash
npx drizzle-kit push
```

برای اولین راه‌اندازی (فقط یک‌بار و اگر دیتابیس خالی است):

```bash
npx tsx --env-file=.env scripts/seed.ts
```

> روی دیتابیس تولیدی که داده واقعی دارد **seed را اجرا نکنید**.

## گام ۳ — ساخت و اجرا

```bash
npm ci
npm run build
npm start
```

سرور روی پورت `3000` بالا می‌آید (با `PORT` قابل تغییر است).

## گام ۴ — بررسی پس از استقرار

```bash
curl https://YOUR-DOMAIN/api/health
curl https://YOUR-DOMAIN/robots.txt
curl https://YOUR-DOMAIN/sitemap.xml
```

## بازگشت‌پذیری (Rollback)

- نسخه قبلی build را نگه دارید.
- پیش از هر `drizzle-kit push` از دیتابیس snapshot بگیرید.

## چک‌لیست تولید

- [ ] `DATABASE_URL` تنظیم شده
- [ ] `AUTH_SECRET` تنظیم شده
- [ ] `NEXT_PUBLIC_SITE_URL` روی دامنه واقعی
- [ ] Google OAuth (در صورت استفاده)
- [ ] Apple OAuth (در صورت استفاده)
- [ ] درگاه پرداخت پیکربندی و تست شده
- [ ] HTTPS فعال
- [ ] `/robots.txt` و `/sitemap.xml` بررسی شده
- [ ] داده ساختاریافته با Rich Results Test تست شده
- [ ] قیمت‌ها و موجودی بررسی شده
- [ ] روش‌های ارسال پیکربندی شده
- [ ] پیامک/ایمیل (در صورت استفاده) پیکربندی شده
- [ ] پایش خطا (error monitoring) فعال
- [ ] `npm run build` موفق

## چک‌لیست کامل استقرار — فاز ۲۱

### زیرساخت
- [ ] Node.js 20+ / PostgreSQL 15+ (sslmode=require) / HTTPS + HSTS در reverse proxy
- [ ] `NODE_OPTIONS=--max-old-space-size=...` برای هاست‌های کم‌حافظه

### متغیرهای محیطی
- [ ] `DATABASE_URL` (با SSL)
- [ ] `AUTH_SECRET` / `SESSION_SECRET` — یکتا و قوی (`openssl rand -base64 48`)
- [ ] `NEXT_PUBLIC_SITE_URL=https://دامنه‌واقعی` — روی canonical/sitemap/CSP اثر دارد
- [ ] `ALLOW_DEV_OTP_HINT` **حذف شده**
- [ ] OAuth/درگاه/پیامک در صورت استفاده

### دیتابیس
- [ ] `drizzle-kit push` روی دیتابیس production + snapshot قبل از آن
- [ ] seed های دمو (پرچم‌دار) حذف یا غیرفعال شده‌اند — به‌ویژه حساب دمو عمده `09121112233`
- [ ] کاربر ادمین production با پسورد قوی ساخته شده

### امنیت
- [ ] `python3 scripts/stress-test-auth.py` روی استیجینگ → 14/14 PASS
- [ ] CSP بدون `'unsafe-eval'` (production خودکار)
- [ ] rate-limit: برای استقرار چند-نمونه، Redis اضافه شده یا rate-limit در LB

### سئو
- [ ] هر ۵ sitemap در GSC ثبت و submit شده (`/sitemap.xml`, `/products/...`, `/mazeh-trays/...`, `/gifts/...`, `/blog/...`)
- [ ] robots.txt با دامنه واقعی چک شده
- [ ] Rich Results Test روی صفحه محصول + مقاله + صفحه اصلی بدون خطا
- [ ] GA4/GTM فقط با گیت consent (فاز ۶) فعال شود

### پس از استقرار
- [ ] `curl https://DOMAIN/api/health` → 200
- [ ] ثبت‌نام → OTP → ورود → سفارش آزمایشی (روی درگاه sandbox)
- [ ] ثبت‌نام کسب‌وکار → تأیید ادمین → سفارش عمده → تکرار سفارش
- [ ] بنر consent بعد از اولین بازدید ظاهر می‌شود و `helsa-consent-v2` ذخیره می‌شود
- [ ] پایش خطا/آپتایم فعال، بکاپ شبانه دیتابیس
