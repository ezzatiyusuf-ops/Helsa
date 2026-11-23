import { chromium } from "playwright";

const b = await chromium.launch();
const p = await b.newPage({ viewport: { width: 1440, height: 1400 } });
await p.goto("http://localhost:3101/products", { waitUntil: "networkidle" });
await p.waitForTimeout(2500);

const cards = await p.$$eval("article, [data-testid='product-card'], .cat-card", els =>
  els.slice(0, 12).map(e => {
    const img = e.querySelector("img");
    return { alt: img?.alt || "", src: img?.currentSrc || img?.src || "" };
  })
);
for (const c of cards) {
  const name = c.src.split("/").pop()?.split(".")[0] || "?";
  console.log(`${name.padEnd(28)} ${c.alt.slice(0, 34)}`);
}
await b.close();
