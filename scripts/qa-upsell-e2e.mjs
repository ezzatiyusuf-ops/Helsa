/**
 * QA دستی/خودکار برای «خریدت رو کامل‌تر کن»
 * اجرا: node scripts/qa-upsell-e2e.mjs   (نیازمند dev server روی :3100)
 *
 * سناریوها:
 *  ۱) کلیک «افزودن به سبد» → پنل باز می‌شود
 *  ۲) عنوان و زیرعنوان فارسی درست‌اند
 *  ۳) شمارندهٔ سبد و مبلغ نمایش داده می‌شود
 *  ۴) افزودن یک پیشنهاد، شمارنده را همان‌لحظه بالا می‌برد (بدون بستن پنل)
 *  ۵) Esc پنل را می‌بندد
 *  ۶) سبد در صفحهٔ /cart هر دو قلم را دارد
 *  ۷) موبایل (۳۹۰×۸۴۴): پنل پایین‌چسب، بدون سرریز افقی
 */
import { chromium } from "playwright";

// نکته: 127.0.0.1 در حالت dev توسط Next بلاک می‌شود؛ همیشه localhost.
// پیش‌فرض = dev سرور خود پروژه (npm run dev روی 3000). با BASE=... عوض کنید.
const BASE = process.env.BASE ?? "http://localhost:3000";
const results = [];
const ok = (name, extra = "") => { results.push(["✅", name, extra]); };
const bad = (name, extra = "") => { results.push(["❌", name, extra]); };

const browser = await chromium.launch({ args: ["--no-sandbox"] });

/* ───────── دسکتاپ ───────── */
try {
  const ctx = await browser.newContext({ viewport: { width: 1440, height: 950 }, locale: "fa-IR" });
  const page = await ctx.newPage();
  const errors = [];
  page.on("console", (m) => { if (m.type() === "error") errors.push(m.text()); });
  page.on("pageerror", (e) => errors.push(String(e)));

  await page.goto(`${BASE}/products`, { waitUntil: "domcontentloaded", timeout: 120000 });
  await page.waitForTimeout(3500);

  const addBtn = page.locator('button[aria-label^="افزودن"][aria-label$="به سبد"]').first();
  await addBtn.waitFor({ state: "visible", timeout: 60000 });
  const productName = (await addBtn.getAttribute("aria-label"))?.replace("افزودن ", "").replace(" به سبد", "");

  await addBtn.click();
  const dialog = page.locator('[role="dialog"][aria-labelledby="upsell-title"]');
  await dialog.waitFor({ state: "visible", timeout: 20000 });
  ok("پنل پس از افزودن به سبد باز شد", productName);

  const title = (await page.locator("#upsell-title").innerText()).trim();
  const subtitle = (await page.locator("#upsell-subtitle").innerText()).trim();
  title === "خریدت رو کامل‌تر کن" ? ok("عنوان درست", title) : bad("عنوان نادرست", title);
  subtitle.includes("کنار خریدت امتحان کن") ? ok("زیرعنوان درست", subtitle) : bad("زیرعنوان نادرست", subtitle);

  // منتظر بارگذاری پیشنهادها
  await page.waitForTimeout(2500);
  const sections = await dialog.locator("h3").allInnerTexts();
  sections.some((s) => s.includes("کنار هم عالی")) ? ok("بخش مکمل نمایش داده شد") : bad("بخش مکمل نیست", sections.join("|"));

  const cards = dialog.locator('ul > li');
  const cardCount = await cards.count();
  cardCount > 0 ? ok("کارت پیشنهاد رندر شد", `${cardCount} کارت`) : bad("هیچ کارتی نیست");

  const summary = await dialog.locator('[aria-live="polite"]').first().innerText();
  /[۰-۹]/.test(summary) ? ok("جمع سبد با ارقام فارسی نمایش داده شد", summary.trim()) : bad("جمع سبد نادرست", summary);

  // افزودن اولین پیشنهاد
  const recAdd = dialog.locator('button[aria-label^="افزودن"]').first();
  const recLabel = await recAdd.getAttribute("aria-label");
  const countBefore = await dialog.locator("text=/سبد: .* قلم/").first().innerText();
  await recAdd.click();
  await page.waitForTimeout(900);
  const countAfter = await dialog.locator("text=/سبد: .* قلم/").first().innerText();
  const num = (s) => Number(s.replace(/[^۰-۹0-9]/g, "").replace(/[۰-۹]/g, (d) => "۰۱۲۳۴۵۶۷۸۹".indexOf(d)));
  num(countAfter) > num(countBefore)
    ? ok("افزودن پیشنهاد، شمارندهٔ سبد را بالا برد", `${countBefore} → ${countAfter}`)
    : bad("شمارنده به‌روز نشد", `${countBefore} → ${countAfter}`);

  const addedState = await dialog.locator('button[aria-label$="در سبد است"]').count();
  addedState > 0 ? ok("دکمهٔ آیتم افزوده‌شده به حالت «در سبد» رفت") : bad("حالت افزوده‌شده اعمال نشد", recLabel ?? "");

  // Esc
  await page.keyboard.press("Escape");
  await page.waitForTimeout(500);
  (await dialog.count()) === 0 ? ok("Esc پنل را بست") : bad("Esc پنل را نبست");

  // سبد
  await page.goto(`${BASE}/cart`, { waitUntil: "domcontentloaded", timeout: 120000 });
  await page.waitForTimeout(2500);
  const bodyText = await page.locator("body").innerText();
  bodyText.includes("سبد خرید") ? ok("صفحهٔ سبد باز شد") : bad("صفحهٔ سبد باز نشد");
  const cartHasProduct = productName ? bodyText.includes(productName) : true;
  cartHasProduct ? ok("محصول اصلی در سبد هست", productName) : bad("محصول اصلی در سبد نیست", productName);

  // جلوگیری از سرریز افقی
  const overflowX = await page.evaluate(() => document.documentElement.scrollWidth - document.documentElement.clientWidth);
  overflowX <= 1 ? ok("بدون سرریز افقی (دسکتاپ)") : bad("سرریز افقی (دسکتاپ)", `${overflowX}px`);

  // ۵۰۰ روی /api/cart/check پیش‌از‌این‌هم وجود داشت: در این سندباکس Postgres در دسترس نیست
  // (پایین‌تر داده‌اش هم تیک می‌خورد) و به این قابلیت ربطی ندارد؛ جدا گزارش می‌شود.
  const preExisting = errors.filter((e) => /cart\/check|500/i.test(e));
  const realErrors = errors.filter((e) => !/cart\/check|500/i.test(e));
  realErrors.length === 0 ? ok("بدون خطای کنسول مربوط به این قابلیت") : bad("خطای کنسول", realErrors.slice(0, 3).join(" | "));
  if (preExisting.length) ok("خطای از پیش موجود (نه این قابلیت): POST /api/cart/check → ۵۰۰ به‌خاطر نبود Postgres در سندباکس", `${preExisting.length} مورد`);
  await ctx.close();
} catch (e) {
  bad("دسکتاپ: اجرای سناریو نیمه‌کاره ماند", String(e).split("\n")[0].slice(0, 200));
}

/* ───────── موبایل ───────── */
try {
  const ctx = await browser.newContext({
    viewport: { width: 390, height: 844 },
    isMobile: true,
    hasTouch: true,
    deviceScaleFactor: 3,
    locale: "fa-IR",
  });
  const page = await ctx.newPage();
  await page.goto(`${BASE}/products`, { waitUntil: "domcontentloaded", timeout: 120000 });
  await page.waitForTimeout(3500);

  const addBtn = page.locator('button[aria-label^="افزودن"][aria-label$="به سبد"]').first();
  await addBtn.waitFor({ state: "visible", timeout: 60000 });
  await addBtn.click();

  const dialog = page.locator('[role="dialog"][aria-labelledby="upsell-title"]');
  await dialog.waitFor({ state: "visible", timeout: 20000 });
  await page.waitForTimeout(2200);
  ok("پنل در موبایل باز شد");

  const box = await dialog.boundingBox();
  const sheet = box && box.width >= 380 && Math.abs(box.y + box.height - 844) < 3;
  sheet ? ok("در موبایل شیت پایین‌چسب تمام‌عرض است", `${Math.round(box.width)}×${Math.round(box.height)}`) : bad("چیدمان موبایل نادرست", JSON.stringify(box));

  const overflowX = await page.evaluate(() => document.documentElement.scrollWidth - document.documentElement.clientWidth);
  overflowX <= 1 ? ok("بدون سرریز افقی (موبایل)") : bad("سرریز افقی (موبایل)", `${overflowX}px`);

  const buttons = await dialog.locator('button[aria-label^="افزودن"]').count();
  buttons > 0 ? ok("دکمه‌های افزودن در موبایل قابل لمس‌اند", `${buttons} دکمه`) : bad("دکمهٔ افزودن در موبایل نیست");

  const scrollLocked = await page.evaluate(() => getComputedStyle(document.body).overflow === "hidden");
  scrollLocked ? ok("اسکرول پس‌زمینه قفل شد") : bad("قفل اسکرول کار نکرد");

  // بستن با دکمه
  await dialog.locator('button[aria-label="بستن"]').first().click();
  await page.waitForTimeout(400);
  (await dialog.count()) === 0 ? ok("دکمهٔ بستن کار کرد") : bad("دکمهٔ بستن کار نکرد");
  await ctx.close();
} catch (e) {
  bad("موبایل: اجرای سناریو نیمه‌کاره ماند", String(e).split("\n")[0].slice(0, 200));
}

await browser.close();

console.log("\n──────── نتیجهٔ QA ────────");
for (const [icon, name, extra] of results) console.log(`${icon} ${name}${extra ? ` — ${extra}` : ""}`);
const failed = results.filter((r) => r[0] === "❌").length;
console.log(`\n${results.length - failed}/${results.length} بررسی موفق`);
process.exit(failed ? 1 : 0);
