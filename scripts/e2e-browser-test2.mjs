// Final browser QA: checkout with filled cart + re-verify fixes.
import { chromium } from "playwright";
import { mkdirSync } from "node:fs";
const BASE = "http://127.0.0.1:3101";
const SHOTS = "/home/user/qa-screenshots";
mkdirSync(SHOTS, { recursive: true });
const browser = await chromium.launch();
const results = [];
const consoleErrors = new Set();
const step = (name, pass, note = "") => { results.push(pass); console.log(`${pass ? "✅" : "❌"} ${name}${note ? " — " + note : ""}`); };

const ctx = await browser.newContext({ viewport: { width: 1366, height: 900 }, locale: "fa-IR" });
const page = await ctx.newPage();
page.on("console", (m) => { if (m.type() === "error") consoleErrors.add(m.text().slice(0, 120)); });
page.on("pageerror", (e) => consoleErrors.add(`PAGEERROR: ${String(e).slice(0, 120)}`));

// 1) add to cart → checkout full flow (UI)
await page.goto(BASE + "/products/qeysi-dried-apricot", { waitUntil: "networkidle", timeout: 60000 });
await page.getByRole("button", { name: "افزودن به سبد خرید", exact: true }).click();
await page.waitForTimeout(1500);
await page.goto(BASE + "/checkout", { waitUntil: "networkidle", timeout: 60000 });
const ship = await page.getByText(/ارسال عادی/).first().isVisible().catch(() => false);
step("چک‌اوت (سبد پر): گزینه‌های ارسال رندر شد", ship);
const nid = await page.getByText(/کد ملی/).first().isVisible().catch(() => false);
step("چک‌اوت: فرم احراز هویت (کد ملی)", nid);
const price = await page.getByText(/۶۰۰٬۰۰۰/).first().isVisible().catch(() => false);
step("چک‌اوت: مبلغ قیسی دیده می‌شود", price);
await page.screenshot({ path: `${SHOTS}/05-checkout-filled.png`, fullPage: true });

// 2) homepage re-check: zero image 404s
const errorsBefore = consoleErrors.size;
await page.goto(BASE + "/", { waitUntil: "networkidle", timeout: 60000 });
await page.waitForTimeout(4000); // let hero slider rotate
const img404s = [...consoleErrors].filter((e) => e.includes("404")).length;
step("صفحهٔ اصلی: بدون 404 تصویر", img404s === 0, `${img404s} خطای 404`);
await page.screenshot({ path: `${SHOTS}/01-home-desktop-v2.png` });

// 3) mobile overflow re-check on products page
const mctx = await browser.newContext({ viewport: { width: 390, height: 844 }, locale: "fa-IR" });
const mpage = await mctx.newPage();
await mpage.goto(BASE + "/products", { waitUntil: "networkidle", timeout: 60000 });
const overflow = await mpage.evaluate(() => document.documentElement.scrollWidth > document.documentElement.clientWidth + 2);
step("موبایل /products: بدون اسکرول افقی", !overflow);
await mpage.screenshot({ path: `${SHOTS}/07-products-mobile.png` });

// 4) /products card count + pagination presence
const cards = await mpage.locator("a[href^='/products/']").count();
const pag = await mpage.getByText(/صفحه/).count();
step("لیست محصولات: کارت + صفحه‌بندی", cards >= 20 && pag >= 2, `${cards} کارت، ${pag} المان صفحه‌بندی`);

await browser.close();
console.log(`\n=== FINAL BROWSER QA: ${results.filter(Boolean).length}/${results.length} passed ===`);
if (consoleErrors.size) { console.log("console errors:"); [...consoleErrors].slice(0, 8).forEach((e) => console.log("  ⚠", e)); }
process.exit(results.every(Boolean) ? 0 : 1);
