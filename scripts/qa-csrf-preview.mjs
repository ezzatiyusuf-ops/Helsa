/**
 * نگهبان رگرسیون CSRF برای محیط پیش‌نمایش
 * اجرا: node scripts/qa-csrf-preview.mjs        (سرور باید روی BASE بالا باشد)
 *
 * چرا: پراکسی پیش‌نمایش (https://{port}-{id}.e2b.app) هدر X-Forwarded-Proto/Host را
 * همیشه ست نمی‌کند؛ در نتیجه Origin مرورگر با Origin مجاز سرور فرق می‌کرد و همهٔ POSTها
 * ۴۰۳ می‌گرفتند («ارتباط برقرار نشد» در پنل پیشنهاد سبد).
 */
const BASE = process.env.BASE ?? "http://localhost:3101";
const PREVIEW = process.env.PREVIEW_ORIGIN ?? "https://3101-abc123.e2b.app";
const body = JSON.stringify({ slug: "piaram-dates" });

const post = (label, headers) =>
  fetch(`${BASE}/api/products/upsell`, {
    method: "POST",
    headers: { "Content-Type": "application/json", ...headers },
    body,
  }).then((r) => ({ label, status: r.status }));

const results = [];
const want = (label, status, expected) => results.push({ label, status, ok: status === expected });

// ۱) Origin پیش‌نمایش (همان چیزی که مرورگر کاربر می‌فرستد)
{ const r = await post("origin=preview", { Origin: PREVIEW }); want(`Origin پیش‌نمایش (${PREVIEW})`, r.status, 200); }
// ۲) Origin محلی
{ const r = await post("origin=local", { Origin: "http://localhost:3101" }); want("Origin محلی", r.status, 200); }
// ۳) بدون Origin (کلاینت غیرمرورگری)
{ const r = await post("no-origin", {}); want("بدون Origin", r.status, 200); }
// ۴) Origin بیگانه باید رد شود (محافظت CSRF حفظ شده)
{ const r = await post("origin=evil", { Origin: "https://evil.example" }); want("Origin بیگانه (باید ۴۰۳)", r.status, 403); }

for (const r of results) console.log(`${r.ok ? "✅" : "❌"} ${r.label} → ${r.status}`);
const failed = results.filter((r) => !r.ok).length;
console.log(`\n${results.length - failed}/${results.length} بررسی موفق`);
process.exit(failed ? 1 : 0);
