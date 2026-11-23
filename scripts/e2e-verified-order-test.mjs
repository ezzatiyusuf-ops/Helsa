// HELSA — verified-checkout E2E: identity(NID+OTP) → order → idempotency → track → cleanup.
// OTP simulation uses direct DB hash injection (sha256) — only possible with DB access; no production bypass exists.
const BASE = "http://127.0.0.1:3101";
const ORIGIN = { Origin: BASE, "Content-Type": "application/json" };
const PHONE = "09123456789";
const NID = "1234567891"; // valid check-digit, test-only
const TEST_CODE = "123456";

import pg from "pg";
import { createHash } from "node:crypto";
import { readFileSync } from "node:fs";
const url = readFileSync(new URL("../.env", import.meta.url), "utf8").match(/^DATABASE_URL=(.*)$/m)[1].trim().replace(/^["']|["']$/g, "");
const pool = new pg.Pool({ connectionString: url, max: 1 });
const post = async (path, body) => {
  const res = await fetch(BASE + path, { method: "POST", headers: ORIGIN, body: JSON.stringify(body) });
  let json = null; try { json = await res.json(); } catch { }
  return { status: res.status, json };
};
const results = [];
const step = async (name, fn) => {
  try { const r = await fn(); results.push(r.pass); console.log(`${r.pass ? "✅" : "❌"} ${name}${r.note ? " — " + r.note : ""}`); }
  catch (e) { results.push(false); console.log(`❌ ${name} — EXC ${e.message}`); }
};

let identityToken = null, orderCode = null, orderDbId = null;
const IDEMPOTENCY = crypto.randomUUID();
const ORDER_BODY = () => ({
  customer: { firstName: "تست", lastName: "خودکار", mobile: PHONE, email: "" },
  address: { province: "تهران", city: "تهران", full: "خیابان آزادی، پلاک ۱ (تست خودکار QA)", postal: "1234567890", recipient: "تست خودکار", phone: PHONE, label: "تست", default: false },
  items: [{ key: "p-1", qty: 1 }],
  shippingMethod: "standard", paymentMethod: "cod", idempotencyKey: IDEMPOTENCY, identityToken,
});

await step("identity مرحلهٔ ۱: درخواست OTP (از مسیر otp/request)", async () => {
  const r1 = await post("/api/identity/verify", { nid: NID, mobile: PHONE });
  const needOtp = r1.json?.needOtp === true; // انتظار: «کد لازم است» بدون ساخت چالش
  const r2 = await post("/api/auth/otp/request", { phone: PHONE }); // ساخت چالش واقعی
  return { pass: needOtp && r2.status === 200 && r2.json?.ok === true, note: `needOtp=${needOtp} otpRequest=${r2.status}` };
});

await step("identity: تزریق هش کد تست در چالش (شبیه‌سازی SMS)", async () => {
  const hash = createHash("sha256").update(TEST_CODE).digest("hex");
  const r = await pool.query(
    "UPDATE auth_challenges SET code_hash=$1 WHERE identifier=$2 AND purpose='otp_login' AND consumed_at IS NULL",
    [hash, PHONE]);
  return { pass: r.rowCount > 0, note: `challenges updated=${r.rowCount}` };
});

await step("identity مرحلهٔ ۲: تأیید و دریافت توکن", async () => {
  const { status, json } = await post("/api/identity/verify", { nid: NID, mobile: PHONE, otpCode: TEST_CODE });
  identityToken = json?.identityToken ?? null;
  return { pass: status === 200 && Boolean(identityToken), note: `status=${status} nidMasked=${json?.nidMasked} provider=${json?.provider}` };
});

await step("orders: ثبت سفارش با احراز هویت", async () => {
  if (!identityToken) return { pass: false, note: "skipped" };
  const { status, json } = await post("/api/orders", ORDER_BODY());
  orderCode = json?.code ?? null;
  const ok = status === 200 && Boolean(orderCode) && json?.total === 570000;
  return { pass: ok, note: `status=${status} code=${orderCode} total=${json?.total} (باید 570000 = 485000+85000)` };
});

await step("orders: idempotency — ارسال دوباره = همان سفارش", async () => {
  if (!orderCode) return { pass: false, note: "skipped" };
  const { json } = await post("/api/orders", ORDER_BODY());
  return { pass: json?.code === orderCode && json?.duplicate === true, note: `code=${json?.code} duplicate=${json?.duplicate}` };
});

await step("orders/track با موبایل درست", async () => {
  if (!orderCode) return { pass: false, note: "skipped" };
  const { status, json } = await post("/api/orders/track", { code: orderCode, mobile: PHONE });
  return { pass: status === 200 && json?.ok === true, note: `status=${status}` };
});

await step("orders/track با موبایل اشتباه → رد", async () => {
  if (!orderCode) return { pass: false, note: "skipped" };
  const { json } = await post("/api/orders/track", { code: orderCode, mobile: "09120000000" });
  return { pass: json?.ok === false, note: JSON.stringify(json).slice(0, 90) };
});

await step("DB: سفارش + کاهش موجودی + گردش انبار + عدم ذخیرهٔ NID خام در لاگ", async () => {
  if (!orderCode) return { pass: false, note: "skipped" };
  const o = (await pool.query("SELECT id, total, status, payment_status FROM orders WHERE code=$1", [orderCode])).rows[0];
  if (!o) return { pass: false, note: "order missing" };
  orderDbId = o.id;
  const p = (await pool.query("SELECT stock FROM products WHERE id=1")).rows[0];
  const mv = (await pool.query("SELECT quantity_change FROM inventory_movements WHERE reference_id=$1", [orderCode])).rows;
  const pl = (await pool.query("SELECT count(*) AS n FROM payment_logs WHERE order_id=$1 AND detail::text LIKE '%1234567891%'", [o.id])).rows[0];
  const ok = o.total === 570000 && p.stock === 29 && mv.length > 0 && Number(pl.n) === 0;
  return { pass: ok, note: `total=${o.total} stock=${p.stock} movements=${mv.length} nid-in-logs=${pl.n} (باید 0)` };
});

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
  await pool.query("DELETE FROM customers WHERE phone=$1 AND name LIKE 'تست%'", [PHONE]);
  const chk = await pool.query("SELECT (SELECT count(*) FROM orders WHERE code=$1) AS ord, (SELECT stock FROM products WHERE id=1) AS stock, (SELECT count(*) FROM customers WHERE phone=$2) AS cust", [orderCode ?? "-", PHONE]);
  console.log("cleanup verify:", JSON.stringify(chk.rows[0]), "(همه باید 0/30 باشد)");
} catch (e) { console.log("CLEANUP ERROR:", e.message); }

console.log(`\n=== RESULT: ${results.filter(Boolean).length}/${results.length} passed ===`);
await pool.end();
process.exit(results.every(Boolean) ? 0 : 1);
