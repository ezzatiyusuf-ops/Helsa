# عکس‌های واقعی «درباره ما» و «تماس با ما»

منبع همهٔ تصاویر: **عکس‌های ادیت‌شدهٔ خود مالک** در `/home/user/helsa-photo-edits/`
(`final-v2/` و `hero-banner-v1/`). هیچ تصویر تولیدی/AI و هیچ عکس استوک اضافه نشده است.
فایل‌ها بدون تغییر محتوا (بدون کراپ/بدون بازتولید) به `public/images/editorial/` کپی شده‌اند.

| فایل در سایت | فصل صفحهٔ درباره ما | منبع اصلی | اندازه |
|---|---|---|---|
| `about-origin.jpg` | اصالت | `hero-banner-v1/hero-mazafati.jpg` | ۲۰۳ KB |
| `about-nature.jpg` | طبیعت | `final-v2/07-2.jpg` | ۳۶۲ KB |
| `about-sourcing.jpg` | انتخاب مواد اولیه | `final-v2/06-1.jpg` | ۳۱۸ KB |
| `about-quality.jpg` | کیفیت | `final-v2/09-4.jpg` | ۵۲۲ KB |
| `about-packaging.jpg` | هنر بسته‌بندی | `final-v2/10-7.jpg` | ۳۴۴ KB |
| `about-hospitality.jpg` | مهمان‌نوازی ایرانی | `final-v2/14-tg2.jpg` | ۳۵۲ KB |
| `contact-welcome.jpg` | نوار بالای صفحهٔ تماس با ما | `hero-banner-v1/hero-mazeh-tray.jpg` | ۱۱۸ KB |

## چه چیزی جایگزین شد
- صفحهٔ «درباره ما» قبلاً از تصاویر عمومی/غیرواقعی استفاده می‌کرد: `story-grove.jpg`،
  `opt/piaram-dates.jpg`، `opt/sourcing-groves.jpg`، `opt/mazafati-dates.jpg`،
  `chocolate-craft.jpg`، `mazeh-board.jpg` (همه ۱۵۳۶×۱۰۲۴ یا ۱۲۰۰×۸۰۰ بدون EXIF دوربین).
  هر شش مورد با عکس واقعی جایگزین شد و `alt` توصیفی فارسی گرفت.
- صفحهٔ «تماس با ما» هیچ عکسی نداشت؛ یک نوار واقعی + caption اضافه شد.

## نکتهٔ فنی
`SmartImage` برای مسیرهای بدون variants در manifest به `<img>` ساده برمی‌گردد،
پس این ۷ فایل بدون تولید نسخه‌های AVIF/WebP هم درست نمایش داده می‌شوند (بدون 404).

## تأیید اجرا
- `npx next build` ✅ (`○ /about`, `○ /contact`)
- همهٔ ۷ فایل با HTTP **200** سرو می‌شوند و HTML هر دو صفحه فقط به همین مسیرها ارجاع می‌دهد.
- `npm test` بعد از تغییر ✅ (unit 42/42، upsell 12/12)
- اسکرین‌شات: `/home/user/about-real-photos.png` · `/home/user/about-real-photos-mobile.png` · `/home/user/contact-real-photos.png`

> اگر عکس اختصاصی «باغ/نخلستان» یا «تیم هلسا» دارید، بفرستید تا فصل‌های «اصالت» و
> «انتخاب مواد اولیه» با آن جایگزین شود؛ در حال حاضر نزدیک‌ترین عکس واقعی موجود استفاده شده است.
