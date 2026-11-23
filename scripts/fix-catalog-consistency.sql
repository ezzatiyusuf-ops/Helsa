-- ═══════════════════════════════════════════════════════════════════════════
-- HELSA — یکسان‌سازی دادهٔ کاتالوگ (تخفیف/گالری)
-- هدف: رفع دو تست قرمز کاتالوگ که از قبل وجود داشتند:
--   • «هیچ محصولی تخفیف جعلی ندارد (oldPrice > price و درصد هم‌خوان)»
--   • «تصویر اصلی هر محصول در گالری هست و کلید یکتاست»
--
-- ⚠️ اجرای این فایل روی دیتابیس واقعی است و تا تأیید صریح مالک اجرا نمی‌شود.
-- ⚠️ هیچ قیمتی ساخته/تغییر داده نمی‌شود؛ فقط نشان تخفیف با اعداد موجود هم‌خوان
--    می‌شود یا ادعای تخفیف ناسازگار حذف می‌گردد.
-- ⚠️ بعد از اجرا: npm run catalog:export  (تا fallback یعنی src/data/products.ts
--    دوباره از DB بازتولید شود؛ آن فایل AUTO-GENERATED است و نباید دستی منبع باشد.)
--
-- اجرا:  psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f scripts/fix-catalog-consistency.sql
-- ═══════════════════════════════════════════════════════════════════════════

BEGIN;

-- ── ۰) پیش از تغییر: وضعیت فعلی ────────────────────────────────────────────
SELECT 'قبل: تخفیف جعلی (قیمت قبل ≤ قیمت فعلی)' AS check, count(*) AS rows
FROM products WHERE old_price IS NOT NULL AND old_price <= price;

SELECT 'قبل: نشان تخفیف ناسازگار با درصد واقعی' AS check, count(*) AS rows
FROM products
WHERE old_price IS NOT NULL AND old_price > price
  AND discount <> ROUND(((old_price - price) * 100.0) / old_price);

SELECT 'قبل: تصویر اصلی بیرون از گالری' AS check, count(*) AS rows
FROM products
WHERE image IS NOT NULL AND image <> ''
  AND jsonb_typeof(gallery) = 'array' AND jsonb_array_length(gallery) > 0
  AND NOT gallery @> to_jsonb(ARRAY[image]);


-- ── ۱) تخفیف جعلی: «قیمت قبل» کمتر یا مساوی قیمت فعلی است ──────────────────
-- ادعای تخفیف کامل حذف می‌شود (به‌جای ساختن عدد تازه برای قیمت قبل).
UPDATE products
SET old_price = NULL,
    discount  = 0
WHERE old_price IS NOT NULL
  AND old_price <= price;


-- ── ۲) نشان تخفیف با درصد واقعی هم‌خوان شود ────────────────────────────────
-- مثال واقعی: walnut-kernels با قیمت ۴۹۵٬۰۰۰ و قیمت قبل ۶۹۰٬۰۰۰ ⇒ نشان باید ۲۸٪ باشد، نه ۱۰٪.
UPDATE products
SET discount = ROUND(((old_price - price) * 100.0) / old_price)
WHERE old_price IS NOT NULL
  AND old_price > price
  AND discount <> ROUND(((old_price - price) * 100.0) / old_price);


-- ── ۳) تصویر اصلی داخل گالری (بدون تکرار) ─────────────────────────────────
-- فقط از فایل موجود خودِ محصول استفاده می‌شود؛ هیچ عکس تازه‌ای ساخته نمی‌شود.
UPDATE products
SET gallery = jsonb_build_array(to_jsonb(image)) || gallery
WHERE image IS NOT NULL
  AND image <> ''
  AND jsonb_typeof(gallery) = 'array'
  AND jsonb_array_length(gallery) > 0
  AND NOT gallery @> to_jsonb(ARRAY[image]);


-- ── ۴) تصویر اصلی آشکارا اشتباه (نگاشت عکس عسل/مدجول روی محصول دیگر) ───────
-- این‌ها استنباط خودکار نیست؛ تصمیم محتوایی است و نیاز به تأیید مالک دارد.
-- در fallback همین الان با فایل موجود خودِ محصول اصلاح شده است.
UPDATE products SET image = '/images/opt/date-syrup.jpg'      WHERE slug = 'date-syrup';
UPDATE products SET image = '/images/opt/grape-syrup.jpg'     WHERE slug = 'grape-syrup';
UPDATE products SET image = '/images/opt/dates-khasoei.jpg'   WHERE slug = 'khasoei-dates';


-- ── ۵) راستی‌آزمایی: هر سه شمارنده باید صفر باشند ──────────────────────────
SELECT 'بعد: تخفیف جعلی' AS check, count(*) AS rows
FROM products WHERE old_price IS NOT NULL AND old_price <= price;

SELECT 'بعد: نشان تخفیف ناسازگار' AS check, count(*) AS rows
FROM products
WHERE old_price IS NOT NULL AND old_price > price
  AND discount <> ROUND(((old_price - price) * 100.0) / old_price);

SELECT 'بعد: تصویر اصلی بیرون از گالری' AS check, count(*) AS rows
FROM products
WHERE image IS NOT NULL AND image <> ''
  AND jsonb_typeof(gallery) = 'array' AND jsonb_array_length(gallery) > 0
  AND NOT gallery @> to_jsonb(ARRAY[image]);

COMMIT;
