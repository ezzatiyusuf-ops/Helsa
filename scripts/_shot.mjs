import { chromium } from "playwright";
const b = await chromium.launch();
const shot = async (w, h, path, isMobile = false, scrollTo = 0) => {
  const c = await b.newContext({ viewport: { width: w, height: h }, isMobile, hasTouch: isMobile });
  const p = await c.newPage();
  await p.goto("http://localhost:3101/products", { waitUntil: "networkidle" });
  const acc = p.getByRole("button", { name: "پذیرش همه" });
  if (await acc.count()) await acc.first().click();
  await p.addStyleTag({ content: ".rvl{opacity:1!important;transform:none!important}" });
  await p.waitForTimeout(500);
  if (scrollTo) { await p.evaluate((y) => window.scrollTo(0, y), scrollTo); await p.waitForTimeout(400); }
  await p.screenshot({ path });
  await c.close();
};
await shot(1440, 950, "/home/user/products-qa/prod-fold-1440.png");
await shot(1440, 950, "/home/user/products-qa/prod-grid-1440.png", false, 900);
await shot(390, 844, "/home/user/products-qa/prod-fold-390.png", true);
await shot(390, 844, "/home/user/products-qa/prod-grid-390.png", true, 760);
await b.close();
console.log("ok");
