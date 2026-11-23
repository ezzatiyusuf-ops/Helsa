# «خریدت رو کامل‌تر کن» — گزارش اجرا (Smart Cart Upsell)

تاریخ اجرا: ۱۴۰۵/۰۸/۰۶ · مخزن: `/home/user/helsa` · برنچ هدف: `main` (origin: `ezzatiyusuf-ops/Helsa-web` @ `95f2626`)

---

## ۱) فایل‌های ساخته‌شده و تغییرکرده (مسیر دقیق)

### فایل‌های تازه (کد قابلیت)

| مسیر | خطوط | نقش |
|---|---|---|
| `helsa/src/lib/upsell.ts` | ۲۶۴ | موتور پیشنهاد — تابع خالص `pickUpsell()` + `isAvailable` + `cartKeyFor` |
| `helsa/src/data/product-relations.ts` | ۴۹ | روابط صریح دستی: ۲۰ اسلاگ مبنا × ۳ پیشنهاد |
| `helsa/src/lib/upsell-store.ts` | ۳۴ | استور zustand **بدون persist** برای باز/بستهٔ پنل (`open`, `seed`, `show`, `close`) |
| `helsa/src/app/api/products/upsell/route.ts` | ۶۵ | `POST /api/products/upsell` — zod + same-origin + rate-limit ۶۰/۶۰s |
| `helsa/src/components/cart/useAddWithUpsell.ts` | ۵۹ | هوک واحد «افزودن به سبد + باز کردن پنل» برای همهٔ نقاط افزودن |
| `helsa/src/components/cart/CartUpsellDrawer.tsx` | ۴۸۱ | پنل/کشو (portal): دو بخش، افزودن تک‌ضربه، skeleton/خطا/خالی، a11y |
| `helsa/tests/upsell.test.ts` | ۱۳۴ | ۱۲ تست روی کاتالوگ واقعی |
| `helsa/scripts/qa-upsell-e2e.mjs` | ۱۵۳ | QA واقعی مرورگر (Playwright) — ۲۰ بررسی دسکتاپ + موبایل |
| `helsa/CART-UPSELL-PLAN.md` | — | سند طراحی/تصمیم‌ها پیش از کدنویسی |

### فایل‌های موجود که تغییر کردند (پچ حداقلی)

| مسیر | تغییر |
|---|---|
| `helsa/src/components/layout/Shell.tsx` | یک import + `<CartUpsellDrawer />` یک‌بار در کل اپ |
| `helsa/src/components/product/ProductCard.tsx` | `addItem` → `useAddWithUpsell()`؛ حذف توست تکراری |
| `helsa/src/components/product/ProductDetailClient.tsx` | همان هوک؛ «خرید سریع» (goCheckout) پنل را باز نمی‌کند |
| `helsa/package.json` | `test:upsell`، `qa:upsell`؛ `test` = typecheck + lint + test:unit + test:upsell |

**دست‌نخورده (عمداً):** `src/app/api/products/cross-sell/route.ts`، `src/components/cart/CartUpsell.tsx`، `src/components/ui/controls.tsx` (Modal مشترک)، `src/lib/store.ts` (سبد persist‌شده)، `src/db/schema.ts` (بدون migration)، `src/data/products.ts`.

### فایل‌های بازیابی‌شده از origin/main (هیچ محتوای تازه‌ای اضافه نکردم)

کپی کاری محلی این ۱۰ فایل را نداشت و در نتیجه `npm run test:unit` با `Cannot find module` می‌شکست. همه **بایت‌به‌بایت** با `origin/main` یکسان‌اند (با sha256 تأیید شد):

`src/lib/order-dto.ts` · `order-access.ts` · `card.ts` · `receipt-file.ts` · `health-sanitize.ts` · `card-payment.ts` · `metadata.ts` · `producer.ts` · `src/config/card-transfer.ts` · `src/config/support.ts`

همچنین ۲۳۰ فایل تصویری `public/images/opt/*` که در این سندباکس نبودند (و در origin/main موجودند) برگردانده شد تا تست manifest تصاویر بتواند اجرا شود.

---

## ۲) منطق موتور پیشنهاد (`src/lib/upsell.ts`)

تابع خالص و قطعی: `pickUpsell(seed, catalog, opts) → { complementary, similar }` — بدون I/O، بدون تصادف.

**اولویت (به‌ترتیب):**

1. **روابط صریح** — `EXPLICIT_RELATIONS[seed.slug]` (۲۰ مبنا × ۳ اسلاگ) — بالاترین اعتبار.
2. **قواعد مکمل دسته‌ای** — `COMPLEMENT_RULES` / `complementaryCategories()`: خرما↔آجیل/شکلات خرمایی/چای، چای↔نبات/عسل، حبوبات↔ادویه/روغن/ترشی، پنیر↔گردو/نان، پک↔هردو … با fallback قطعی برای دستهٔ ناشناخته.
3. **هم‌دسته‌های مشابه** — نزدیک‌ترین قیمت به محصول مبنا (فاصلهٔ مطلق قیمت، سپس slug برای قطعیت).
4. **fallback قطعی** — اگر هیچ‌کدام کافی نبود، از بقیهٔ کاتالوگ با ترتیب پایدار.

**فیلترها (همه اجباری):** خودِ محصول نباشد · `isActive` · `isVisible` · موجود (`stock > 0` یا حداقل یک واریانت موجود) · `price > 0` · از قبل در سبد نباشد · شناسهٔ تکراری بین دو بخش نباشد.

**واریانت‌آگاه:** `toUpsell()` از `cheapestAvailableVariant()` استفاده می‌کند (همان منبع قیمت کارت محصول) و `variantId` را برمی‌گرداند؛ `cartKeyFor()` همان قاعدهٔ سبد را می‌سازد — `p-{id}-v-{vid}` یا `p-{id}` — تا آیتم پیشنهادی با آیتم کارت محصول در سبد ادغام شود و ردیف تکراری نسازد.

**قرارداد API:** `POST /api/products/upsell` با بدنهٔ `{slug, cartSlugs≤100, cartIds≤100, complementaryLimit 0–8, similarLimit 0–8}` →
`{ok:true, complementary: UpsellProduct[], similar: UpsellProduct[]}` ·
`UpsellProduct = {id, slug, name, price, oldPrice, weight, image, stock, category, rating, reviews, variantId}`.
خطاها: ۴۰۰ دادهٔ نامعتبر · ۴۰۴ اسلاگ ناشناس · ۴۲۹ rate-limit · ۴۰۳ cross-origin. همهٔ پیام‌ها فارسی.

**قیمت/موجودی سمت سرور:** API فقط از کاتالوگ سمت سرور می‌خواند؛ کلاینت هیچ قیمتی نمی‌سازد و هنگام افزودن هم همان `addItem` موجود سبد استفاده می‌شود (بدون سبد موازی، بدون تغییر استور persist‌شده).

---

## ۳) نقاط اتصال

- **بعد از افزودن موفق:** `useAddWithUpsell()` اول `addItem` را صدا می‌زند؛ فقط اگر آیتم معتبر و افزودن موفق بود `useUpsellStore.show(seed)` اجرا می‌شود. اگر قیمت/اسلاگ نامعتبر باشد: توست فارسی، بدون باز شدن پنل.
- **یک‌بار mount:** `Shell.tsx` → `<CartUpsellDrawer />` کنار `<PwaManager />`؛ portal روی `document.body`، پس هیچ layout shift ایجاد نمی‌کند.
- **سبد:** شمارنده و جمع سبد داخل پنل از همان `useStore` خوانده می‌شود؛ افزودن پیشنهاد، همان‌لحظه `سبد: ۱ قلم → ۲ قلم` می‌شود (تأیید واقعی، پایین).
- **درخواست تکراری نمی‌شود:** کش ۵ دقیقه‌ای + یکی‌سازی درخواست‌های هم‌زمان (`inflight` Map) در `CartUpsellDrawer.tsx`؛ اندازه‌گیری واقعی: باز شدن اول = ۱ درخواست، بستن و باز کردن دوباره = همان ۱ درخواست (۰ درخواست تازه). کلیک مکرر روی «افزودن» با `pendingId` قفل می‌شود.
- **دسترس‌پذیری:** `role="dialog"` + `aria-modal` + `aria-labelledby/describedby`، Esc (listener سطح `document` با capture تا حتی وقتی فوکوس روی دکمهٔ غیرفعال رفته هم کار کند)، تلهٔ فوکوس Tab/Shift+Tab، بازگشت فوکوس به عنصر قبلی، `aria-label` فارسی روی همهٔ دکمه‌ها، `aria-live` برای تغییر شمارنده، قفل اسکرول پس‌زمینه، `prefers-reduced-motion` با `animation:none`.
- **موبایل:** زیر ۶۴۰px شیت پایین‌چسب تمام‌عرض (`max-h-92dvh`)، دسکتاپ کشوی کنارِ end (RTL: سمت راست).
- **تحلیل:** `trackEvent` برای `upsell_open` / `upsell_add` / `upsell_dismiss` (reasons: close, backdrop, continue, cart, escape) / `add_to_cart_confirmed` — با توابع موجود `src/lib/analytics.ts`.

---

## ۴) تست‌هایی که واقعاً اجرا شدند (خروجی خام)

| # | دستور | نتیجه |
|---|---|---|
| ۱ | `npx tsc --noEmit` (کل پروژه) | ✅ پاک، exit 0 |
| ۲ | `npm run lint` (`eslint .`) | ✅ پاک، بدون خطا/هشدار |
| ۳ | `npm run test:upsell` | ✅ **۱۲/۱۲ pass** (۰ fail) |
| ۴ | `npm run test:unit` | ✅ **۴۲/۴۲ pass** (پس از اصلاح دادهٔ کاتالوگ — بند ۶) |
| ۵ | `npx next build` | ✅ `✓ Compiled successfully in 3.7s` و `ƒ /api/products/upsell` در جدول روت‌ها |
| ۶ | `npm run qa:upsell` روی dev (`:3100`) | ✅ **۲۰/۲۰** |
| ۷ | `npm run qa:upsell` روی build تولیدی (`next start :3101`) | ✅ **۲۰/۲۰** |
| ۸ | smoke واقعی API (تولیدی) | ✅ `ok:true` · مکمل: `lahijan-black-tea, helsa-gift-pack, natural-honey, rose-herbal-tea` · مشابه: `natural-gon-honey, herbal-tea-borage, sumac-flakes` |
| ۹ | شمارش درخواست تکراری (Playwright + شمارندهٔ request) | ✅ باز شدن اول: ۱ · باز شدن دوم: ۱ (۰ درخواست تازه) |
| ۱۰ | `npm test` (کل زنجیره: typecheck + lint + unit + upsell) | ✅ سبز، exit 0 — unit ۴۲/۴۲ · upsell ۱۲/۱۲ |
| ۱۱ | صفحه‌های متأثر از دادهٔ کاتالوگ (`/`, `/products`, `/offers`, `/products/date-syrup`, `/products/walnut-kernels`) | ✅ همه ۲۰۰ |

**۱۲ تست موتور:** همه واقعی/موجود و بدون خود · سقف بخش‌ها · قطعیت (اجرای دوباره = همان خروجی) · اولویت رابطهٔ صریح (`saffron-negin → saffron-rock-candy` اول) · حذف ناموجود · حذف اقلام سبد · کاتالوگ خالی ⇒ دو آرایهٔ خالی · مشابه هم‌دسته (`piaram-dates → dates`) · قواعد مکمل (خرما/چای/حبوبات + دستهٔ ناشناخته) · `cartKeyFor` = `p-{id}` / `p-{id}-v-{vid}` · حذف غیرفعال/نامرئی · موجودی صفر با واریانت موجود = موجود.

**۲۰ بررسی E2E (روی build تولیدی، عیناً):**
باز شدن پنل پس از افزودن · عنوان «خریدت رو کامل‌تر کن» · زیرعنوان «این محصولات رو هم کنار خریدت امتحان کن» · بخش مکمل رندر شد · ۷ کارت پیشنهاد · جمع سبد با ارقام فارسی (`۲۶۷٬۰۰۰ تومان`) · افزودن پیشنهاد شمارنده را بالا برد (`۱ → ۲ قلم`) · دکمه به حالت «در سبد است» رفت · Esc بست · صفحهٔ سبد باز شد · محصول اصلی در سبد · بدون سرریز افقی دسکتاپ · بدون خطای کنسول مربوط به قابلیت · شیت موبایل `390×776` تمام‌عرض · بدون سرریز افقی موبایل · دکمه‌های افزودن قابل لمس · قفل اسکرول پس‌زمینه · دکمهٔ بستن کار کرد.

اسکرین‌شات‌های واقعی: `/home/user/upsell-desktop.png` و `/home/user/upsell-mobile.png`.

---

## ۵) آنچه انجام نشد / محدودیت‌ها (صادقانه)

1. **push به `main` انجام نشد.** تغییرات روی کپی کاری `/home/user/helsa` است. `helsa/.git` خراب است (`gitdir: /tmp/helsa-push`) و توکن (PAT با scope `repo`) هنوز نرسیده. با رسیدن توکن، انتشار همان مسیر قبلی است.
2. **۲ تست unit قرمز بود → اصلاح شد (بند ۶).** جزئیات و SQL رسمی همان‌جا آمده است.
3. **بدون دیتابیس:** در این سندباکس Postgres در دسترس نیست؛ در نتیجه `POST /api/cart/check` از پیش `۵۰۰` می‌دهد. این خرابی **قبل از این کار** هم بود و به این قابلیت ربطی ندارد (قابلیت پیشنهاد هیچ کوئری DB ندارد و کاتالوگ را از همان منبع صفحهٔ محصول می‌خواند). در اسکریپت QA جداگانه گزارش می‌شود تا خطای واقعی گم نشود.
4. **بدون migration:** طبق تصمیم طراحی، روابط در `src/data/product-relations.ts` به‌صورت تایپ‌شده است. اگر بعداً مدیریت از پنل ادمین لازم شد، ستون/جدول جدا لازم است.
5. **بدون تخفیف/تایمر/قیمت خط‌خورده:** هیچ UI تخفیفی اضافه نشد (طبق اسپک). اگر `oldPrice` واقعی در کاتالوگ باشد فقط نمایش داده می‌شود.
6. **آزمون واقعی SMS/پرداخت انجام نشد** چون در این قابلیت دخیل نیست. هیچ ادعای «کامل و بی‌نقص» ندارم؛ فقط چیزهایی که بالا تست شده‌اند سبزند.

### اجرای سریع برای شما

```bash
cd /home/user/helsa
npm ci                 # اگر node_modules نبود
npm run test:upsell    # ۱۲ تست موتور
npm run qa:upsell      # ۲۰ بررسی مرورگری (نیاز به dev/prod روی :3100 یا BASE=…)
```


---

## ۶) اصلاح یکسان‌سازی دادهٔ کاتالوگ (کار درخواستی «در main هم درستش کن»)

**ریشهٔ ماجرا:** `src/data/products.ts` در بالای خودش نوشته **AUTO-GENERATED** و منبعش دیتابیس است (`npm run catalog:export`). یعنی اصلاح واقعی باید در DB انجام شود، نه در فایل تولیدشده. دیتابیس در این سندباکس در دسترس نیست (Postgres نبود ⇒ `cart/check` هم ۵۰۰ می‌داد).

**کاری که شد:**

1. `helsa/scripts/fix-catalog-consistency.sql` — اسکریپت **رسمی و idempotent** برای DB، با BEGIN/COMMIT و راستی‌آزمایی قبل/بعد:
   - `old_price ≤ price` ⇒ `old_price = NULL, discount = 0` (حذف ادعای تخفیف جعلی، بدون ساختن عدد تازه)
   - `discount ≠ درصد واقعی` ⇒ `discount = ROUND((old_price-price)*100/old_price)` (نشان با اعداد موجود هم‌خوان می‌شود)
   - `image ∉ gallery` ⇒ `gallery = [image] || gallery` (فقط فایل موجود خودِ محصول، بدون تکرار)
   - ۳ تصویر اصلی آشکارا اشتباه (عکس عسل روی شیرهٔ خرما/انگور، عکس مدجول روی خرمای خصویی) با فایل واقعی خودِ محصول — این سه مورد «تصمیم محتوایی» است و در SQL با کامنت مشخص شده.
   - **هیچ قیمتی ساخته یا تغییر داده نشد.**

2. همان اصلاحات روی fallback (`src/data/products.ts`) اعمال شد تا همین حالا تست‌ها و بیلد سبز باشند:
   - `walnut-kernels`: نشان ۱۰٪ → **۲۸٪** (۴۹۵٬۰۰۰ از ۶۹۰٬۰۰۰ = ۲۸٫۲۶٪) — قیمت‌ها دست‌نخورده.
   - `dried-figs`: `oldPrice: 495000` (کمتر از قیمت فعلی!) → `null` و `discount: 0`.
   - **۹۴ محصول** تصویر اصلی‌شان به ابتدای گالری اضافه شد (بدون تکرار، فقط فایل موجود).
   - `date-syrup` → `/images/opt/date-syrup.jpg` · `grape-syrup` → `/images/opt/grape-syrup.jpg` · `khasoei-dates` → `/images/opt/dates-khasoei.jpg` (قبلاً عکس عسل/مدجول بود).

**اثبات (اجرای واقعی):**

| بررسی | قبل | بعد |
|---|---|---|
| `test:unit` | ۴۰/۴۲ | ✅ **۴۲/۴۲** |
| تصویر اصلی بیرون از گالری | ۹۴ محصول | **۰** |
| نشان تخفیف ناسازگار | ۱ (`walnut-kernels`) | **۰** |
| تخفیف جعلی (`old_price ≤ price`) | ۱ (`dried-figs`) | **۰** |
| `npm test` کامل | قرمز | ✅ سبز، exit 0 |
| `next build` | — | ✅ ۱۱۲/۱۱۲ صفحهٔ استاتیک |

**قدم بعدی شما:** اجرای `psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f scripts/fix-catalog-consistency.sql` و بعد `npm run catalog:export`. تا آن زمان، fallback اصلاح‌شده همان رفتار را در سایت نشان می‌دهد؛ اما منبع حقیقت DB است و تا DB اصلاح نشود، هر export دوباره نسخهٔ قدیم را می‌آورد.

**انتشار روی main:** آماده است — `scripts/publish-upsell.py` (Git Data API، بدون clone) خشک‌اجرا شد: روی `main@95f2626` دقیقاً **۱۶ فایل** (۱۱ تازه، ۵ تغییرکرده) خواهد نوشت. برای اجرای واقعی فقط `GH_TOKEN=… python3 scripts/publish-upsell.py --apply` لازم است. همچنین `helsa-upsell-to-main.patch` ساخته و تست شد (روی محتوای دست‌نخوردهٔ main اعمال و بایت‌به‌بایت با کپی کاری مقایسه شد: همهٔ فایل‌ها یکسان).
