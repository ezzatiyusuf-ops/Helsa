// HELSA — E2E customer-flow test against the live preview (localhost:3101).
// Creates clearly-marked test records, verifies behavior, then CLEANS them up.
const BASE = "http://127.0.0.1:3101";
const ORIGIN = { Origin: BASE, "Content-Type": "application/json" };
const PHONE = "09123456789";
let orderCode = null, orderId = null, orderDbId = null;

import pg from "pg";
import { readFileSync } from "node:fs";
const url = readFileSync(new URL("../.env", import.meta.url), "utf8").match(/^DATABASE_URL=(.*)$/m)[1].trim().replace(/^["']|["']$/g, "");
const pool = new pg.Pool({ connectionString: url, max: 1 });

const results = [];
async function step(name, fn) {
  try { const r = await fn(); results.push({ name, ...r }); console.log(`${r.pass ? "✅" : "❌"} ${name}${r.note ? " — " + r.note : ""}`); }
  catch (e) { results.push({ name, pass: false, note: e.message }); console.log(`❌ ${name} — EXC ${e.message}`); }
}
const post = async (path, body) => {
  const res = await fetch(BASE + path, { method: "POST", headers: ORIGIN, body: JSON.stringify(body) });
  let json = null; try { json = await res.json(); } catch { /* empty */ }
  return { status: res.status, json };
};

// ── 1) cart/check — server must re-price (client sends fake price 1000) ──
await step("cart/check: قیمت سمت سرور", async () => {
  const { status, json } = await post("/api/cart/check", { items: [{ key: "p-1", kind: "product", id: 1, qty: 2, price: 1000 }] });
  const items = json?.items ?? json?.resolved ?? [];
  const serverPrice = items[0]?.unitPrice ?? items[0]?.price ?? json?.unitPrice;
  const ok = status === 200 && serverPrice === 485000;
  return { pass: ok, note: `status=${status} serverPrice=${serverPrice} (client sent 1000)` };
});

// ── 2) coupon valid/invalid ──
await step("coupons/validate: HELSA10 معتبر", async () => {
  const { status, json } = await post("/api/coupons/validate", { code: "HELSA10", subtotal: 970000 });
  return { pass: status === 200 && json?.ok === true, note: JSON.stringify(json).slice(0, 120) };
});
await step("coupons/validate: کد نامعتبر رد شود", async () => {
  const { status, json } = await post("/api/coupons/validate", { code: "NOSUCHCODE", subtotal: 970000 });
  return { pass: status === 200 && json?.ok === false, note: JSON.stringify(json).slice(0, 120) };
});

// ── 3) OTP request ──
await step("otp/request: موبایل معتبر", async () => {
  const { status, json } = await post("/api/auth/otp/request", { phone: PHONE });
  return { pass: status === 200 && json?.ok === true, note: `demo=${json?.demo} devCodeLeaked=${"devCode" in (json ?? {})} (باید false در production)` };
});
await step("otp/request: موبایل نامعتبر رد شود", async () => {
  const { status } = await post("/api/auth/otp/request", { phone: "123" });
  return { pass: status === 400, note: `status=${status}` };
});
await step("otp/verify: کد اشتباه رد شود", async () => {
  const { status, json } = await post("/api/auth/otp/verify", { phone: PHONE, code: "000000" });
  return { pass: status === 401 && json?.ok === false, note: `status=${status}` };
});

// ── 4) payment methods ──
await step("payments/methods: فهرست روش‌ها", async () => {
  const res = await fetch(`${BASE}/api/payments/methods?total=500000&province=تهران`);
  const json = await res.json();
  return { pass: res.status === 200 && Array.isArray(json?.methods) && json.methods.length > 0, note: `methods=${json?.methods?.length} sandbox=${json?.sandbox}` };
});

// ── 5) guest order (cod) — the critical path ──
const IDEMPOTENCY = crypto.randomUUID();
await step("orders POST: ثبت سفارش مهمان (پرداخت کارت‌به‌کارت)", async () => {
  const { status, json } = await post("/api/orders", {
    customer: { firstName: "تست", lastName: "خودکار", mobile: PHONE, email: "" },
    address: { province: "تهران", city: "تهران", full: "خیابان آزادی، پلاک ۱ (تست خودکار QA)", postal: "1234567890", recipient: "تست خودکار", phone: PHONE, label: "تست", default: false },
    items: [{ key: "p-1", qty: 1 }],
    shippingMethod: "standard", paymentMethod: "cod", idempotencyKey: IDEMPOTENCY,
  });
  orderCode = json?.code ?? null; orderId = json?.orderId ?? null;
  return { pass: status === 200 && Boolean(orderCode), note: `status=${status} code=${orderCode} total=${json?.total} (انتظار 570000)` };
});

// ── 6) idempotency: same key again → same order, no duplicate ──
await step("orders POST: idempotency (تکراری = همان سفارش)", async () => {
  if (!orderCode) return { pass: false, note: "skipped — no order" };
  const { json } = await post("/api/orders", {
    customer: { firstName: "تست", lastName: "خودکار", mobile: PHONE, email: "" },
    address: { province: "تهران", city: "تهران", full: "خیابان آزادی، پلاک ۱ (تست خودکار QA)", postal: "1234567890", recipient: "تست خودکار", phone: PHONE, label: "تست", default: false },
    items: [{ key: "p-1", qty: 1 }],
    shippingMethod: "standard", paymentMethod: "cod", idempotencyKey: IDEMPOTENCY,
  });
  return { pass: json?.code === orderCode, note: `code=${json?.code}` };
});

// ── 7) order tracking ──
await step("orders/track: پیگیری با کد+موبایل", async () => {
  if (!orderCode) return { pass: false, note: "skipped" };
  const { status, json } = await post("/api/orders/track", { code: orderCode, mobile: PHONE });
  return { pass: status === 200 && json?.ok === true, note: `status=${status}` };
});
await step("orders/track: موبایل اشتباه رد شود", async () => {
  if (!orderCode) return { pass: false, note: "skipped" };
  const { json } = await post("/api/orders/track", { code: orderCode, mobile: "09120000000" });
  return { pass: json?.ok === false, note: JSON.stringify(json).slice(0, 100) };
});

// ── 8) session & protected APIs without login ──
await step("auth/session بدون کوکی", async () => {
  const res = await fetch(`${BASE}/api/auth/session`);
  const json = await res.json().catch(() => null);
  return { pass: res.status === 401 || json?.ok === false || json?.authenticated === false, note: `status=${res.status}` };
});
await step("orders/[id] بدون نشست → 401/404", async () => {
  if (!orderId && !orderDbId) return { pass: false, note: "skipped" };
  const res = await fetch(`${BASE}/api/orders/${orderId ?? orderDbId}`);
  return { pass: [401, 404].includes(res.status), note: `status=${res.status}` };
});

// ── 9) misc APIs ──
await step("instagram/feed: پاسخ سالم", async () => {
  const res = await fetch(`${BASE}/api/instagram/feed`);
  const json = await res.json();
  return { pass: res.status === 200 && json && "posts" in json, note: `posts=${json?.posts?.length ?? "?"} source=${json?.source}` };
});
await step("cross-sell: پاسخ سالم", async () => {
  const { status, json } = await post("/api/products/cross-sell", { items: [{ key: "p-1", kind: "product", id: 1 }] });
  return { pass: status === 200 && json?.ok !== false, note: `status=${status}` };
});
await step("newsletter: ثبت ایمیل", async () => {
  const { status, json } = await post("/api/newsletter", { email: "qa-test@example.com" });
  return { pass: status === 200 && json?.ok === true, note: `status=${status}` };
});
await step("contact: ارسال پیام", async () => {
  const { status, json } = await post("/api/contact", { name: "تست خودکار", mobile: PHONE, email: "", subject: "تست QA", message: "این یک پیام تست خودکار برای سنجش سلامت فرم تماس است." });
  return { pass: status === 200 && json?.ok === true, note: `status=${status}` };
});

// ── 10) DB-side verification ──
await step("DB: سفارش ثبت شده + موجودی کم شده + گردش انبار", async () => {
  if (!orderCode) return { pass: false, note: "skipped" };
  const o = (await pool.query("SELECT id, total, status, payment_status FROM orders WHERE code=$1", [orderCode])).rows[0];
  if (!o) return { pass: false, note: "order not in DB" };
  orderDbId = o.id;
  const p = (await pool.query("SELECT stock FROM products WHERE id=1")).rows[0];
  const mv = (await pool.query("SELECT quantity_change, reason FROM inventory_movements WHERE reference_id=$1", [orderCode])).rows;
  const ok = p.stock === 29 && mv.length > 0 && Number(mv[0].quantity_change) === -1;
  return { pass: ok, note: `stock=${p.stock} (باید 29)، movements=${mv.length}، total=${o.total}` };
});

// ── CLEANUP ──
console.log("\n— پاک‌سازی رکوردهای تست…");
try {
  if (orderDbId) {
    await pool.query("DELETE FROM payment_logs WHERE order_id=$1", [orderDbId]);
    await pool.query("DELETE FROM payments WHERE order_id=$1", [orderDbId]);
    await pool.query("DELETE FROM order_items WHERE order_id=$1", [orderDbId]);
    await pool.query("DELETE FROM inventory_movements WHERE reference_id=$1", [orderCode]);
    await pool.query("DELETE FROM invoices WHERE order_id=$1", [orderDbId]);
    await pool.query("DELETE FROM orders WHERE id=$1", [orderDbId]);
    await pool.query("UPDATE products SET stock = stock + 1 WHERE id=1");
  }
  await pool.query("DELETE FROM auth_challenges WHERE identifier=$1", [PHONE]);
  await pool.query("DELETE FROM contact_messages WHERE mobile=$1 AND subject='تست QA'", [PHONE]);
  await pool.query("DELETE FROM customers WHERE phone=$1 AND name LIKE 'تست%'", [PHONE]);
  const chk = await pool.query("SELECT (SELECT count(*) FROM orders WHERE code=$1) AS ord, (SELECT stock FROM products WHERE id=1) AS stock", [orderCode ?? "-"]);
  console.log("cleanup verify:", JSON.stringify(chk.rows[0]));
} catch (e) { console.log("CLEANUP ERROR:", e.message); }

const failed = results.filter((r) => !r.pass);
console.log(`\n=== RESULT: ${results.length - failed.length}/${results.length} passed ===`);
await pool.end();
process.exit(failed.length ? 1 : 0);
