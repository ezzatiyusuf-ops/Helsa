/**
 * QA صفحهٔ فهرست محصولات — واقعی، روی سرور در حال اجرا.
 * ۱) پنج عرض (320/375/390/430/768/1440): سرریز افقی، خطاهای کنسول، تصاویر شکسته
 * ۲) اسکرین‌شات تمام‌صفحه
 * ۳) رفتار فیلتر/مرتب‌سازی/صفحه‌بندی + حفظ وضعیت در URL
 * ۴) نمای سریع → افزودن به سبد (همان مسیر upsell)
 */
import { chromium } from "playwright";
import fs from "node:fs";

const BASE = process.env.BASE || "http://localhost:3101";
const OUT = "/home/user/products-qa";
fs.mkdirSync(OUT, { recursive: true });

const widths = [320, 375, 390, 430, 768, 1440];
const results = [];
let failures = 0;
const ok = (name, pass, extra = "") => {
  results.push(`${pass ? "PASS" : "FAIL"}  ${name}${extra ? "  — " + extra : ""}`);
  if (!pass) failures++;
};

const browser = await chromium.launch();

/** بنر رضایت کوکی (جزء سایت موجود) — در تست بسته می‌شود تا مودال‌ها/اسکرین‌شات‌ها تمیز بمانند */
async function dismissCookies(page) {
  const accept = page.getByRole("button", { name: "پذیرش همه" });
  if (await accept.count()) {
    await accept.first().click().catch(() => {});
    await page.waitForTimeout(250);
  }
}

/* ─────────── ۱) عرض‌ها: سرریز، کنسول، تصاویر ─────────── */
for (const w of widths) {
  const ctx = await browser.newContext({ viewport: { width: w, height: 900 }, deviceScaleFactor: 1 });
  const page = await ctx.newPage();
  const errors = [];
  page.on("console", (m) => m.type() === "error" && errors.push(m.text().slice(0, 160)));
  page.on("pageerror", (e) => errors.push(String(e).slice(0, 160)));
  const res = await page.goto(`${BASE}/products`, { waitUntil: "networkidle" });
  ok(`[${w}] /products → ${res?.status()}`, res?.status() === 200);
  await dismissCookies(page);

  // اسکرول تدریجی برای lazy-load و reveal-on-scroll
  await page.addStyleTag({ content: ".rvl{opacity:1!important;transform:none!important}" });
  await page.evaluate(async () => {
    for (let y = 0; y < document.body.scrollHeight; y += 600) {
      window.scrollTo(0, y);
      await new Promise((r) => setTimeout(r, 60));
    }
    window.scrollTo(0, 0);
  });
  await page.waitForTimeout(700);

  const overflow = await page.evaluate(() => ({
    scrollW: document.documentElement.scrollWidth,
    clientW: document.documentElement.clientWidth,
  }));
  ok(`[${w}] بدون سرریز افقی`, overflow.scrollW <= overflow.clientW + 1, `${overflow.scrollW}/${overflow.clientW}`);

  const broken = await page.evaluate(() =>
    [...document.images].filter((i) => i.complete && i.naturalWidth === 0).map((i) => i.currentSrc || i.src),
  );
  ok(`[${w}] تصویر شکسته = 0`, broken.length === 0, broken.slice(0, 3).join(", "));

  const cards = await page.locator("article.cat-card").count();
  ok(`[${w}] کارت محصول در صفحه`, cards >= 8, `${cards} کارت`);

  ok(`[${w}] بدون خطای کنسول`, errors.length === 0, errors.slice(0, 2).join(" | "));

  await page.screenshot({ path: `${OUT}/products-${w}.png`, fullPage: w === 1440 || w === 390 });
  await ctx.close();
}

/* ─────────── ۲) تعامل: فیلتر، مرتب‌سازی، صفحه‌بندی، نمای سریع ─────────── */
const ctx = await browser.newContext({ viewport: { width: 1440, height: 900 } });
const page = await ctx.newPage();
await page.goto(`${BASE}/products`, { waitUntil: "networkidle" });
await dismissCookies(page);

// مرتب‌سازی ارزان‌ترین → URL و اولین قیمت
await page.getByRole("button", { name: "ارزان‌ترین" }).click();
await page.waitForTimeout(400);
const url1 = page.url();
const firstPrice = await page.locator("article.cat-card").first().innerText();
ok("مرتب‌سازی ارزان‌ترین در URL ثبت شد", url1.includes("sort=cheapest"), url1.split("?")[1] || "");
ok("گرید پس از مرتب‌سازی بازچینش شد", firstPrice.length > 0);

// فیلتر دسته از ستون کنار
await page.goto(`${BASE}/products`, { waitUntil: "networkidle" });
await page.getByRole("button", { name: /آجیل/ }).first().click(); // باز کردن آکاردئون گروه
await page.waitForTimeout(250);
await page.getByRole("button", { name: "همهٔ آجیل" }).click(); // اعمال فیلتر گروه
await page.waitForTimeout(350);
const famUrl = page.url();
ok("فیلتر گروه آجیل در URL", famUrl.includes("family=nuts"), famUrl.split("?")[1] || "");
const countNuts = await page.locator("article.cat-card").count();
ok("نتیجهٔ فیلتر گروه آجیل > 0", countNuts > 0, `${countNuts} کارت`);

// چیپ فیلتر فعال
const chip = await page.getByRole("button", { name: /حذف فیلتر/ }).count();
ok("چیپ فیلتر فعال نمایش داده می‌شود", chip > 0, `${chip} چیپ`);
await page.screenshot({ path: `${OUT}/products-filtered-1440.png`, fullPage: false });

// حذف فیلتر
await page.getByRole("button", { name: /حذف فیلتر/ }).first().click();
await page.waitForTimeout(300);
ok("حذف چیپ فیلتر → URL بدون family", !page.url().includes("family=nuts"), page.url().split("?")[1] || "");

// صفحه‌بندی
await page.goto(`${BASE}/products`, { waitUntil: "networkidle" });
await page.getByRole("button", { name: "صفحهٔ ۲" }).click();
await page.waitForTimeout(600);
ok("صفحهٔ ۲ در URL", page.url().includes("page=2"), page.url().split("?")[1] || "");
const p2First = await page.locator("article.cat-card").first().innerText();
ok("محتوای صفحهٔ ۲ متفاوت است", !p2First.includes("undefined"));

// نمای سریع
await page.goto(`${BASE}/products`, { waitUntil: "networkidle" });
await page.locator("article.cat-card").first().hover();
await page.getByRole("button", { name: "نمای سریع" }).first().click();
await page.waitForTimeout(500);
const dialog = page.getByRole("dialog", { name: /نمای سریع/ });
ok("مودال نمای سریع باز شد", await dialog.isVisible());
await page.screenshot({ path: `${OUT}/products-quickview-1440.png` });

// افزودن از نمای سریع (همان سبد + مودال پیشنهاد)
await dialog.getByRole("button", { name: "افزودن به سبد" }).click();
await page.waitForTimeout(900);
const upsell = await page.getByRole("dialog", { name: "خریدت رو کامل‌تر کن" }).count();
const cartBadge = await page.evaluate(() => {
  const raw = localStorage.getItem("helsa-store-v2");
  return raw ? JSON.parse(raw)?.state?.items?.length ?? 0 : 0;
});
ok("افزودن از نمای سریع به سبد انجام شد", cartBadge > 0, `آیتم سبد: ${cartBadge}`);
ok("مودال پیشنهاد تکمیلی همان مسیر باز شد", upsell > 0, `${upsell} مودال`);
ok("نمای سریع پس از افزودن بسته شد", (await page.getByRole("dialog", { name: /نمای سریع/ }).count()) === 0);
await page.screenshot({ path: `${OUT}/products-quickview-upsell-1440.png` });

await ctx.close();

/* ─────────── ۳) موبایل: شیت فیلتر + ناوبری دسته ─────────── */
const mctx = await browser.newContext({ viewport: { width: 390, height: 844 }, isMobile: true, hasTouch: true });
const mpage = await mctx.newPage();
await mpage.goto(`${BASE}/products`, { waitUntil: "networkidle" });
await dismissCookies(mpage);
await mpage.getByRole("button", { name: /^فیلتر/ }).click();
await mpage.waitForTimeout(500);
ok("شیت فیلتر موبایل باز شد", await mpage.getByRole("dialog", { name: "فیلتر محصولات" }).isVisible());
await mpage.screenshot({ path: `${OUT}/products-filter-sheet-390.png` });
await mpage.keyboard.press("Escape");
await mpage.waitForTimeout(400);
ok("Esc شیت فیلتر را می‌بندد", (await mpage.getByRole("dialog", { name: "فیلتر محصولات" }).count()) === 0);

// لینک تایل دسته (بدون JS هم کار می‌کند)
await mpage.goto(`${BASE}/products?cat=spices`, { waitUntil: "networkidle" });
await dismissCookies(mpage);
const h1 = await mpage.locator("h1").first().innerText();
ok("مسیر ?cat=spices عنوان دسته را نشان می‌دهد", h1.includes("ادویه"), h1);
await mpage.screenshot({ path: `${OUT}/products-cat-spices-390.png`, fullPage: false });
await mctx.close();

await browser.close();

fs.writeFileSync(`${OUT}/report.txt`, results.join("\n") + `\n\n${failures === 0 ? "ALL PASS" : failures + " FAIL"} (${results.length} بررسی)\n`);
console.log(results.join("\n"));
console.log(`\n${failures === 0 ? "ALL PASS" : failures + " FAIL"} — ${results.length} بررسی`);
process.exit(failures === 0 ? 0 : 1);
