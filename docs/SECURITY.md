# امنیت هلسا — SECURITY.md

> وضعیت: هاردنینگ فاز ۴ + استرس‌تست فاز ۵ (۱۴/۱۴ PASS با `scripts/stress-test-auth.py`).

## ۱. مدل احراز هویت

| لایه | مکانیزم |
| --- | --- |
| نشست | JWT `jose` HS256 در کوکی `helsa_session` — `HttpOnly` + `SameSite=Lax` + `Secure` در production، عمر ۷ روز |
| ساختار توکن | `SessionPayload { sub: "customer:{id}", name, email, phone?, provider, role }` — **همیشه** `customerIdFromSession(session)` برای استخراج id |
| رمز عبور | `scryptSync` داخلی با فرمت `scrypt$salt$hex` (src/lib/auth-service.ts، server-only) |
| OTP | شماره تلفن + کد یک‌بارمصرف؛ در dev با `ALLOW_DEV_OTP_HINT=1` کد در پاسخ برمی‌گردد |
| ادمین | `requireAdminApi()` + `adminErrorResponse()` (src/lib/admin.ts) — نقش `role` داخل توکن امضاشده؛ توکن جعلی/دستکاری‌شده رد می‌شود |

**اصل طلایی:** هرگز به `sub` خام اعتماد نکن؛ نقش و id فقط از توکن verify شده.

## ۲. دفاع‌های پیاده‌سازی‌شده (src/lib/security.ts)

- `assertSameOrigin` / `csrfRejectedResponse` — بررسی Origin برای متدهای تغییردهنده
- `clientKey` — کلید نرخ‌محور بر پایه IP + مسیر
- `rateLimit` / `rateLimitedResponse` — پنجره لغزان در حافظه (لاگین، OTP، ثبت‌نام)
- `genericAuthMessage` — پیام‌های عمومی («امکان ایجاد حساب با این اطلاعات وجود ندارد») بدون افشای وجود/عدم وجود حساب

## ۳. هدرهای امنیتی (next.config.ts)

- `X-Frame-Options: SAMEORIGIN`، `X-Content-Type-Options: nosniff`، `Referrer-Policy`
- CSP (پیش‌فرض سخت‌گیرانه؛ `'unsafe-eval'` فقط در dev)
- `Permissions-Policy` محدود

## ۴. اصل قیمت سرور-محور

کلاینت هیچ‌گاه قیمت نهایی را تعیین نمی‌کند:

- سفارش عادی: کلیدهای سبد `p-{id}` / `t-{id}` / `gift-quote-{id}` / `custom-quote-{id}` — سرور قیمت/موجودی/کوپن/ارسال را از DB محاسبه می‌کند
- سفارش عمده: فقط `{ productId, quantity }` — قیمت عمده، تخفیف پلکانی، MOQ و حداقل مبلغ همه سمت سرور

## ۵. نتیجه استرس‌تست (فاز ۵)

`python3 scripts/stress-test-auth.py` (سرور باید تازه restart شده باشد):

| چک | نتیجه |
| --- | --- |
| ۶۰ ثبت‌نام موازی | بدون 5xx، بدون duplicate |
| تلفن/ایمیل تکراری | 409 با پیام عمومی |
| بروت‌فورس (۳۰ پسورد غلط) | ۲۱×429 + ۹×401، بدون leak اطلاعات |
| OTP flood | 400/429 بدون کرش |
| JWT جعلی / دستکاری‌شده / ادمین‌سازی دستی | همه unauthenticated |
| توکن ادمین جعلی روی /api/admin/wholesale | 401 |
| سلامت سرویس بعد از حمله | 200 |

## ۶. مسیرهای خصوصی

`/admin`، `/account`، `/wholesale/dashboard`، `/checkout`، `/payment` — همگی گارد سشنی/نقشی دارند و در `robots.txt` بلاک هستند.

## ۷. برای استقرار production

1. `NEXT_PUBLIC_SITE_URL` واقعی را تنظیم کنید (برای canonical/sitemap/CSP)
2. `SESSION_SECRET` قوی و یکتا از environment
3. `ALLOW_DEV_OTP_HINT` را حذف کنید
4. rate-limit در حافظه است — برای چند نمونه، Redis یا درگاه LB را جایگزین کنید
5. TLS termination + HSTS در reverse proxy
6. لاگ‌های `/api/health` و خطاهای 5xx را مانیتور کنید
