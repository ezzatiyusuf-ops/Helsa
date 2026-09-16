import { drizzle } from "drizzle-orm/node-postgres";
import { Pool } from "pg";

/**
 * HELSA database client — Netlify/hosted-PostgreSQL safe.
 *
 * قواعد استقرار (فاز Netlify):
 *  1) هیچ‌وقت به localhost وابسته نیستیم: اگر DATABASE_URL غایب باشد، Pool واقعی
 *     ساخته نمی‌شود (pg به‌طور پیش‌فرض به 127.0.0.1:5432 می‌رفت — عامل ECONNREFUSED
 *     در بیلد Netlify). یک stub بدون شبکه برمی‌گردانیم که هر کوئری را با پیام روشن
 *     reject می‌کند تا لایهٔ سرویس fallback بزند.
 *  2) در محیط میزبانی‌شده (NETLIFY و…) اتصال به localhost رد می‌شود (خطای روشن).
 *  3) PostgreSQL میزبانی‌شده (Supabase / Neon / Railway) به‌طور پیش‌فرض SSL می‌گیرد؛
 *     DATABASE_SSL=disable برای خاموش‌کردن، DATABASE_SSL=verify برای تأیید سختگیرانهٔ cert.
 *
 * DATABASE_URL برای هر فچر دیتا-محور الزامی است:
 *   DATABASE_URL=postgresql://USER:PASSWORD@HOST:5432/DATABASE
 */
const databaseUrl = (process.env.DATABASE_URL ?? "").trim();

export const isDatabaseConfigured = Boolean(databaseUrl);

export const DATABASE_SETUP_MESSAGE =
  "[HELSA] DATABASE_URL تنظیم نشده است. مقدار آن را در محیط (Netlify Env Vars یا فایل .env) قرار دهید " +
  "(نمونه: postgresql://USER:PASSWORD@HOST:5432/DATABASE) و سپس `npx drizzle-kit push` را اجرا کنید.";

const LOCAL_DB_HOSTS = new Set(["localhost", "127.0.0.1", "::1", ""]);
const ON_HOSTED_PLATFORM = Boolean(process.env.NETLIFY || process.env.VERCEL || process.env.RENDER);

function dbHost(url: string): string {
  try {
    return new URL(url).hostname.toLowerCase();
  } catch {
    return "";
  }
}

/** رد خودکار localhost در محیط میزبانی‌شده — «production must use hosted PostgreSQL only» */
const localDbRejected = Boolean(databaseUrl) && LOCAL_DB_HOSTS.has(dbHost(databaseUrl)) && ON_HOSTED_PLATFORM;
if (localDbRejected) {
  console.error(
    "[HELSA] DATABASE_URL به localhost/127.0.0.1 اشاره می‌کند که در محیط میزبانی (Netlify) معتبر نیست. " +
      "یک PostgreSQL میزبانی‌شده (Supabase/Neon/Railway) تنظیم کنید.",
  );
}

/** وضعیت نهایی: دیتابیس فقط وقتی «پیکربندی‌شده» است که آدرس قابل‌استفاده داشته باشد */
export const isDatabaseUsable = isDatabaseConfigured && !localDbRejected;

if (!isDatabaseUsable && process.env.NODE_ENV !== "production" && !ON_HOSTED_PLATFORM) {
  // developer-facing only; never rendered to customers
  console.warn(localDbRejected ? "[HELSA] local DATABASE_URL rejected on hosted platform." : DATABASE_SETUP_MESSAGE);
}

/** SSL خودکار برای هاست‌های غیرمحلی (Supabase/Neon/Railway) */
function sslOptions(url: string): { rejectUnauthorized: boolean } | undefined {
  if (!url || LOCAL_DB_HOSTS.has(dbHost(url))) return undefined;
  if (process.env.DATABASE_SSL === "disable") return undefined;
  return { rejectUnauthorized: process.env.DATABASE_SSL === "verify" };
}

const globalForDb = globalThis as typeof globalThis & {
  __arenaNextJsPostgresqlPool?: Pool;
};

/**
 * Stub بدون شبکه برای حالت «پیکربندی‌نشده»: هیچ اتصالی (حتی به localhost) برقرار
 * نمی‌شود؛ کوئری‌ها فوراً reject می‌شوند و سرویس‌ها fallback/empty برمی‌گردانند.
 */
class UnconfiguredPool {
  on() {
    return this;
  }
  async connect(): Promise<never> {
    throw new Error(DATABASE_SETUP_MESSAGE);
  }
  async query(): Promise<never> {
    throw new Error(DATABASE_SETUP_MESSAGE);
  }
  end(): Promise<void> {
    return Promise.resolve();
  }
}

export const pool: Pool = isDatabaseUsable
  ? ((globalForDb.__arenaNextJsPostgresqlPool ??= new Pool({
      connectionString: databaseUrl,
      ssl: sslOptions(databaseUrl),
    })) as Pool)
  : (new UnconfiguredPool() as unknown as Pool);

// avoid unhandled 'error' events from idle clients taking the process down
pool.on("error", () => undefined);

if (process.env.NODE_ENV !== "production") {
  globalForDb.__arenaNextJsPostgresqlPool = pool as Pool;
}

export const db = drizzle(pool);

/** Lightweight health probe used by /api/health */
export async function checkDatabase(): Promise<{ ok: boolean; message: string }> {
  if (localDbRejected) {
    return {
      ok: false,
      message: "DATABASE_URL به localhost اشاره می‌کند؛ در محیط میزبانی باید PostgreSQL میزبانی‌شده تنظیم شود.",
    };
  }
  if (!isDatabaseConfigured) return { ok: false, message: DATABASE_SETUP_MESSAGE };
  try {
    await pool.query("SELECT 1");
    return { ok: true, message: "اتصال پایگاه داده برقرار است." };
  } catch (error) {
    return { ok: false, message: `اتصال پایگاه داده برقرار نشد: ${(error as Error).message}` };
  }
}
