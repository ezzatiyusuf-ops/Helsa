import { chromium } from "playwright";

const b = await chromium.launch();
const p = await b.newPage({ viewport: { width: 1440, height: 1250 } });
await p.goto("http://localhost:3101/products", { waitUntil: "networkidle" });
await p.waitForTimeout(2500);
await p.screenshot({ path: "/home/user/preview-products.png" });
await b.close();
console.log("shot ok");
