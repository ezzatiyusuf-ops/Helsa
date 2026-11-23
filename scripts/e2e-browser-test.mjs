// HELSA — real-browser QA (Playwright chromium headless). Desktop + mobile.
import { chromium } from "playwright";
import { mkdirSync } from "node:fs";

const BASE = "http://127.0.0.1:3101";
const SHOTS = "/home/user/qa-screenshots";
mkdirSync(SHOTS, { recursive: true });

const browser = await chromium.launch();
const results = [];
const consoleErrors = new Set();

async function newPage(viewport) {
  const ctx = await browser.newContext({ viewport, locale: "fa-IR" });
  const page = await ctx.newPage();
  page.on("console", (m) => { if (m.type() === "error") consoleErrors.add(`${m.location()?.url?.split("/").pop()}: ${m.text().slice(0, 140)}`); });
  page.on("pageerror", (e) => consoleErrors.add(`PAGEERROR: ${String(e).slice(0, 140)}`));
  return { ctx, page };
}
const step = (name, pass, note = "") => { results.push(pass); console.log(`${pass ? "✅" : "❌"} ${name}${note ? " — " + note : ""}`); };

// ── Desktop: homepage ──
{
  const { ctx, page } = await newPage({ width: 1366, height: 900 });
  await page.goto(BASE + "/", { waitUntil: "networkidle", timeout: 60000 });
  const cards = await page.locator("a[href^='/products/']").count();
  step("صفحهٔ اصلی: کارت محصول رندر شد", cards > 5, `${cards} لینک محصول`);
  await page.screenshot({ path: `${SHOTS}/01-home-desktop.png`, fullPage: false });
  await ctx.close();
}

// ── Desktop: products list + filter ──
{
  const { ctx, page } = await newPage({ width: 1366, height: 900 });
  await page.goto(BASE + "/products", { waitUntil: "networkidle", timeout: 60000 });
  const cards = await page.locator("a[href^='/products/']").count();
  step("لیست محصولات: کارت‌ها", cards >= 50, `${cards} کارت`);
  await page.screenshot({ path: `${SHOTS}/02-products.png` });
  await ctx.close();
}

// ── Desktop: product detail → add to cart ──
{
  const { ctx, page } = await newPage({ width: 1366, height: 900 });
  await page.goto(BASE + "/products/qeysi-dried-apricot", { waitUntil: "networkidle", timeout: 60000 });
  const h1 = await page.locator("h1").first().textContent();
  step("صفحهٔ محصول قیسی: عنوان", h1?.includes("قیسی"), h1?.trim());
  const priceVisible = await page.getByText(/۶۰۰٬۰۰۰|600,000/).first().isVisible().catch(() => false);
  step("قیمت ۶۰۰٬۰۰۰ نمایش داده می‌شود", priceVisible);
  await page.screenshot({ path: `${SHOTS}/03-product-qeysi.png` });

  const btn = page.getByRole("button", { name: /افزودن به سبد|افزودن|خرید/ }).first();
  const clicked = await btn.isVisible().catch(() => false);
  if (clicked) {
    await btn.click();
    await page.waitForTimeout(1500);
    const cartRes = await page.goto(BASE + "/cart", { waitUntil: "networkidle", timeout: 60000 });
    const hasQeysi = await page.getByText(/قیسی/).first().isVisible().catch(() => false);
    step("افزودن به سبد → سبد شامل قیسی", hasQeysi, `cart status=${cartRes?.status()}`);
    await page.screenshot({ path: `${SHOTS}/04-cart.png` });
    const totalOk = await page.getByText(/۶۰۰٬۰۰۰|600,000/).first().isVisible().catch(() => false);
    step("سبد: مبلغ قیسی دیده می‌شود", totalOk);
  } else step("افزودن به سبد: دکمه پیدا شد", false, "دکمه یافت نشد");
  await ctx.close();
}

// ── Desktop: checkout renders with shipping options ──
{
  const { ctx, page } = await newPage({ width: 1366, height: 900 });
  await page.goto(BASE + "/checkout", { waitUntil: "networkidle", timeout: 60000 });
  const ship = await page.getByText(/ارسال عادی/).first().isVisible().catch(() => false);
  const nid = await page.getByText(/کد ملی/).first().isVisible().catch(() => false);
  step("چک‌اوت: گزینه‌های ارسال رندر شد", ship);
  step("چک‌اوت: بخش احراز هویت (کد ملی) هست", nid);
  await page.screenshot({ path: `${SHOTS}/05-checkout.png` });
  await ctx.close();
}

// ── Desktop: search ──
{
  const { ctx, page } = await newPage({ width: 1366, height: 900 });
  await page.goto(BASE + "/search?q=" + encodeURIComponent("قیسی"), { waitUntil: "networkidle", timeout: 60000 });
  const found = await page.getByText(/قیسی/).first().isVisible().catch(() => false);
  step("جستجو: «قیسی» پیدا می‌شود", found);
  await ctx.close();
}

// ── Mobile: homepage + menu ──
{
  const { ctx, page } = await newPage({ width: 390, height: 844 });
  await page.goto(BASE + "/", { waitUntil: "networkidle", timeout: 60000 });
  await page.screenshot({ path: `${SHOTS}/06-home-mobile.png` });
  const overflow = await page.evaluate(() => document.documentElement.scrollWidth > document.documentElement.clientWidth + 2);
  step("موبایل: بدون اسکرول افقی", !overflow);
  await ctx.close();
}

// ── Track page ──
{
  const { ctx, page } = await newPage({ width: 1366, height: 900 });
  await page.goto(BASE + "/track", { waitUntil: "networkidle", timeout: 60000 });
  const form = await page.getByText(/کد سفارش|پیگیری/).first().isVisible().catch(() => false);
  step("صفحهٔ پیگیری سفارش رندر شد", form);
  await ctx.close();
}

await browser.close();
console.log(`\nconsole/page errors captured: ${consoleErrors.size}`);
for (const e of [...consoleErrors].slice(0, 10)) console.log("  ⚠", e);
console.log(`\n=== BROWSER QA: ${results.filter(Boolean).length}/${results.length} passed ===`);
process.exit(results.every(Boolean) ? 0 : 1);
