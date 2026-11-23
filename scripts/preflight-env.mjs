#!/usr/bin/env node
/**
 * preflight-env.mjs — دروازهٔ محیط پیش از بیلد/استقرار
 * ─────────────────────────────────────────────────────────────────────────────
 * چرا این فایل وجود دارد:
 * متادیتای `robots` در Next **در زمان بیلد** پخته می‌شود. اگر بیلد بدون
 * `ALLOW_INDEXING=1` گرفته شود، کل سایت — از جمله صفحات محصول — با
 * `noindex` منتشر می‌شود و ست‌کردن متغیر در زمان اجرا هیچ چیزی را نجات نمی‌دهد.
 * این تله دو بار در همین پروژه رخ داد؛ این اسکریپت آن را به **خطای بیلد** تبدیل می‌کند
 * تا امکان انتشار خاموشِ سایتِ ایندکس‌نشدنی وجود نداشته باشد.
 *
 * استفاده:
 *   node scripts/preflight-env.mjs                 # بررسی محیط فعلی
 *   node scripts/preflight-env.mjs --production    # سخت‌گیرانه (پیش‌فرض روی CI/Render)
 *   node scripts/preflight-env.mjs --allow-missing # فقط هشدار برای کلیدهای غیربحرانی
 *
 * کد خروج: 0 = آماده · 1 = بلوکر
 */
import { existsSync, readFileSync } from "node:fs";

const args = new Set(process.argv.slice(2));
const isCI = !!(process.env.CI || process.env.RENDER || process.env.VERCEL);
const PRODUCTION = args.has("--production") || isCI;

// .env محلی را فقط برای اجرای دستی می‌خوانیم (هرگز روی CI؛ آنجا env واقعی است)
if (!PRODUCTION && !process.env.__PREFLIGHT_LOADED && existsSync(".env")) {
  process.env.__PREFLIGHT_LOADED = "1";
  for (const line of readFileSync(".env", "utf-8").split("\n")) {
    const m = /^\s*([A-Z0-9_]+)\s*=\s*(.*)\s*$/.exec(line);
    if (m && !line.trim().startsWith("#") && !process.env[m[1]]) {
      process.env[m[1]] = m[2].replace(/^["']|["']$/g, "");
    }
  }
}

const env = (k) => (process.env[k] ?? "").trim();
const blockers = [];
const warnings = [];
const oks = [];

/** الزامی — نبودشان یعنی استقرار نباید انجام شود */
function required(key, validate, hint) {
  const v = env(key);
  if (!v) {
    blockers.push(`${key} تنظیم نشده — ${hint}`);
    return "";
  }
  if (validate) {
    const err = validate(v);
    if (err) {
      blockers.push(`${key} نامعتبر است: ${err}`);
      return v;
    }
  }
  oks.push(`${key} ✓`);
  return v;
}

/** اختیاری — نبودش قابلیت را خاموش می‌کند، نه سایت را */
function optional(key, note, validate) {
  const v = env(key);
  if (!v) {
    warnings.push(`${key} خالی — ${note}`);
    return "";
  }
  if (validate) {
    const err = validate(v);
    if (err) {
      warnings.push(`${key} نامعتبر: ${err}`);
      return v;
    }
  }
  oks.push(`${key} ✓`);
  return v;
}

const isUrl = (v) => {
  try {
    const u = new URL(v);
    if (!/^https?:$/.test(u.protocol)) return "پروتکل باید http/https باشد";
    return null;
  } catch {
    return "URL قابل تجزیه نیست";
  }
};

// ── ۱) تلهٔ noindex — بحرانی‌ترین بررسی ──────────────────────────────────────
const allow = env("ALLOW_INDEXING");
if (allow === "1") {
  oks.push("ALLOW_INDEXING=1 ✓ (بیلد ایندکس‌پذیر)");
} else if (PRODUCTION) {
  blockers.push(
    "ALLOW_INDEXING باید در **بیلد** برابر ۱ باشد؛ در غیر این صورت robots روی همهٔ صفحات " +
      "(حتی PDP) با noindex پخته می‌شود و مقادیر زمان اجرا نجاتش نمی‌دهد.",
  );
} else {
  warnings.push("ALLOW_INDEXING=1 نیست — بیلد محلی noindex خواهد بود (فقط برای پیش‌نمایش خصوصی)");
}

const site = required(
  "NEXT_PUBLIC_SITE_URL",
  (v) => {
    const e = isUrl(v);
    if (e) return e;
    if (PRODUCTION && !v.startsWith("https://")) return "در تولید باید https باشد (canonical/OG/sitemap)";
    if (/localhost|127\.0\.0\.1/.test(v)) return "دامنهٔ واقعی نیست (canonical و sitemap غلط می‌شوند)";
    return null;
  },
  "دامنهٔ عمومی سایت؛ canonical، og:url و sitemap از آن ساخته می‌شوند",
);

// ── ۲) پایه ──────────────────────────────────────────────────────────────────
required("DATABASE_URL", (v) => (/^postgres(ql)?:\/\//.test(v) ? null : "باید postgres:// یا postgresql:// باشد"), "اتصال PostgreSQL");
required("AUTH_SECRET", (v) => (v.length >= 32 ? null : `طول ${v.length} — حداقل ۳۲ نویسه`), "امضای نشست/توکن — openssl rand -base64 48");

if (PRODUCTION && env("NODE_ENV") && env("NODE_ENV") !== "production") {
  blockers.push(`NODE_ENV=${env("NODE_ENV")} — در استقرار باید production باشد`);
}

// ── ۳) مسیر پرداخت کارت‌به‌کارت ──────────────────────────────────────────────
const cardEnabled = env("CARD_TRANSFER_ENABLED") !== "0";
if (cardEnabled) {
  for (const [k, hint] of [
    ["CARD_TRANSFER_NUMBER", "شمارهٔ کارت ۱۶ رقمی"],
    ["CARD_TRANSFER_HOLDER", "نام صاحب حساب (باید با نام واقعی حساب یکی باشد)"],
    ["CARD_TRANSFER_BANK", "نام بانک"],
  ]) {
    required(k, k === "CARD_TRANSFER_NUMBER" ? (v) => (v.replace(/\D/g, "").length === 16 ? null : "باید ۱۶ رقم باشد") : null, hint);
  }
} else {
  warnings.push("CARD_TRANSFER_ENABLED=0 — مسیر پرداخت کارت‌به‌کارت خاموش است");
}

// ── ۴) اختیاری‌ها (نبودشان = قابلیت خاموش، نه خطا) ───────────────────────────
optional("ADMIN_EMAILS", "هیچ ایمیلی دسترسی ادمین ندارد");
optional("SMS_PROVIDER", "OTP از طریق پیامک ارسال نمی‌شود");
optional("RESEND_API_KEY", "ایمیل تراکنشی ارسال نمی‌شود");
optional("GATEWAY_PROVIDER", "درگاه بانکی خاموش (فقط کارت‌به‌کارت)");
optional("ENAMAD_ID", "نشان نماد اعتماد در فوتر رندر نمی‌شود (کد رسمی را از enamad.ir بگیرید)");
optional("SAMANDEHI_ID", "نشان ساماندهی رندر نمی‌شود");
optional("NEXT_PUBLIC_GTM_ID", "بدون تحلیل ترافیک");
optional("ANDROID_APP_SHA256", "App Links اندروید فعال نمی‌شود (assetlinks.json → ۴۰۴)", (v) =>
  /^([0-9A-Fa-f]{2}:){31}[0-9A-Fa-f]{2}$/.test(v.split(",")[0].trim()) ? null : "قالب باید AA:BB:… ۳۲ بایت هگز باشد");

// ── ۵) هشدارهای امنیتی/عملیاتی ───────────────────────────────────────────────
if (env("PAYMENTS_SANDBOX") === "1" && PRODUCTION && env("GATEWAY_PROVIDER")) {
  warnings.push("PAYMENTS_SANDBOX=1 روی محیط عمومی — پرداخت واقعی انجام نمی‌شود");
}
if (!env("FORCE_SECURE_COOKIES") && PRODUCTION) {
  warnings.push("FORCE_SECURE_COOKIES تنظیم نشده — بررسی کنید کوکی نشست Secure باشد");
}

// ── گزارش ────────────────────────────────────────────────────────────────────
const mode = PRODUCTION ? "تولیدی (سخت‌گیرانه)" : "محلی";
console.log(`\n── پیش‌پرواز محیط · حالت ${mode} ──`);
if (site) console.log(`   دامنه: ${site}`);
for (const o of oks) console.log("  ✓", o);
if (warnings.length) {
  console.log("\n── هشدار (جلوگیری از استقرار نمی‌کند) ──");
  for (const w of warnings) console.log("  ▲", w);
}
if (blockers.length) {
  console.log("\n── بلوکر (استقرار متوقف می‌شود) ──");
  for (const b of blockers) console.log("  ✗", b);
  console.log(`\nنتیجه: ${blockers.length} بلوکر · ${warnings.length} هشدار ⇒ ⛔ NO-GO`);
  process.exit(1);
}
console.log(`\nنتیجه: ${oks.length} تأیید · ${warnings.length} هشدار · 0 بلوکر ⇒ 🟢 GO`);
