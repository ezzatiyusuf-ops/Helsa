// HELSA — non-destructive Supabase structure sync + security hardening.
// 1) Applies drizzle/*.sql (CREATE/ALTER only), skipping objects that already exist.
// 2) Enables RLS on ALL public tables; revokes write grants from anon/authenticated.
// 3) Adds read-only policies ONLY for public catalog tables (products/categories/variants/approved-reviews).
// 4) Seeds the 5 real storefront categories (from src/data/categories.ts), ON CONFLICT DO NOTHING.
// 5) Fixes qeysi gallery (removes non-existent 3rd image reference).
// Never prints secrets. Aborts on unexpected errors.
import pg from "pg";
import { readFileSync, readdirSync } from "node:fs";

const root = new URL("../", import.meta.url);
const env = readFileSync(new URL(".env", root), "utf8");
const url = env.match(/^DATABASE_URL=(.*)$/m)[1].trim().replace(/^["']|["']$/g, "");
const pool = new pg.Pool({ connectionString: url, max: 1, connectionTimeoutMillis: 20000 });

const SKIP_CODES = new Set(["42P07", "42710", "42701"]); // duplicate table/index, duplicate object, duplicate column
const stats = { applied: 0, skipped: 0, errors: [] };

async function applyMigrations() {
  const files = readdirSync(new URL("drizzle/", root)).filter((f) => f.endsWith(".sql")).sort();
  for (const file of files) {
    const raw = readFileSync(new URL(`drizzle/${file}`, root), "utf8");
    const stmts = raw.split("--> statement-breakpoint")
      .map((s) => s.replace(/^(--[^\n]*\n)+/, "").trim()) // strip leading comment lines
      .filter((s) => s && !s.startsWith("--"));
    for (const stmt of stmts) {
      try {
        await pool.query(stmt);
        stats.applied++;
      } catch (e) {
        if (SKIP_CODES.has(e.code)) { stats.skipped++; continue; }
        stats.errors.push({ file, code: e.code, msg: e.message, stmt: stmt.slice(0, 120) });
      }
    }
  }
}

async function hardenSecurity() {
  // RLS on every public table (owner/postgres bypasses it — the app keeps working).
  await pool.query(`DO $$ DECLARE t text; BEGIN
    FOREACH t IN ARRAY (SELECT array_agg(tablename) FROM pg_tables WHERE schemaname='public') LOOP
      EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', t);
      EXECUTE format('REVOKE INSERT, UPDATE, DELETE, TRUNCATE, TRIGGER ON public.%I FROM anon, authenticated', t);
    END LOOP; END $$;`);
  // Read-only API policies only where public read makes sense.
  const policies = [
    ["products", "products_public_read", "is_active = true AND is_visible = true"],
    ["categories", "categories_public_read", "is_active = true"],
    ["product_variants", "product_variants_public_read", "is_active = true"],
    ["reviews", "reviews_public_read", "is_approved = true"],
  ];
  for (const [table, name, using] of policies) {
    await pool.query(`DROP POLICY IF EXISTS ${name} ON public.${table}`);
    await pool.query(`CREATE POLICY ${name} ON public.${table} FOR SELECT TO anon, authenticated USING (${using})`);
  }
}

const CATEGORIES = [
  { id: 1, name: "خرما", slug: "dates", description: "خرمای اصیل جنوب ایران؛ پیارم، مضافتی، کبکاب، زاهدی، خاصویی و مجول", image: "/images/opt/medjool-dates.jpg", icon: "palm", subs: ["خرما پیارم", "خرما مضافتی", "خرما کبکاب", "خرما زاهدی", "خرما خاصویی", "خرما مجول"], sort_order: 1 },
  { id: 2, name: "فرآورده‌های خرما", slug: "date-products", description: "شکلات دست‌ساز خرما، قند خرما، شیره و پودر خرما با دستور انحصاری هلسا", image: "/images/opt/handmade-date-chocolate.jpg", icon: "chocolate", subs: ["شکلات خرمایی", "شکلات دست‌ساز خرما", "قند خرما", "شیره خرما", "پودر خرما"], sort_order: 2 },
  { id: 3, name: "آجیل", slug: "nuts", description: "آجیل ممتاز، چهارمغز، پذیرایی و تک‌مغزهای تازه از باغ‌های ایران", image: "/images/opt/premium-mixed-nuts.jpg", icon: "nut", subs: ["آجیل ممتاز", "آجیل چهارمغز", "آجیل پذیرایی", "آجیل اقتصادی", "آجیل ویژه"], sort_order: 3 },
  { id: 4, name: "خشکبار", slug: "dried-fruits", description: "کشمش، انجیر خشک، توت خشک، برگه زردآلو و میوه خشک با خشک‌کردن طبیعی", image: "/images/opt/dried-figs.jpg", icon: "fig", subs: ["کشمش", "انجیر خشک", "توت خشک", "برگه زردآلو", "آلو خشک", "میوه خشک"], sort_order: 4 },
  { id: 5, name: "محصولات طبیعی", slug: "natural", description: "عسل، زعفران، ارده، شیره‌ها، چای، دمنوش، عرقیات و ادویه‌های اصیل", image: "/images/opt/natural-gon-honey.jpg", icon: "honey", subs: ["عسل", "زعفران", "ارده", "شیره‌ها", "چای", "دمنوش", "عرقیات", "ادویه"], sort_order: 5 },
];

async function seedCategories() {
  for (const c of CATEGORIES) {
    await pool.query(
      `INSERT INTO public.categories (id, name, slug, description, image, icon, subs, sort_order)
       VALUES ($1,$2,$3,$4,$5,$6,$7::jsonb,$8) ON CONFLICT (id) DO NOTHING`,
      [c.id, c.name, c.slug, c.description, c.image, c.icon, JSON.stringify(c.subs), c.sort_order],
    );
  }
  await pool.query(`SELECT setval('public.categories_id_seq', (SELECT max(id) FROM public.categories))`);
}

async function fixQeysiGallery() {
  const r = await pool.query(
    `UPDATE public.products SET gallery = $1::jsonb, updated_at = now()
     WHERE slug = 'qeysi-dried-apricot' RETURNING gallery`,
    [JSON.stringify(["/images/opt/qeysi.jpg", "/images/opt/qeysi-2.jpg"])],
  );
  console.log("qeysi gallery →", JSON.stringify(r.rows[0]?.gallery));
}

async function verify() {
  const t = await pool.query("SELECT count(*) AS n FROM pg_tables WHERE schemaname='public'");
  const counts = await pool.query(`SELECT
      (SELECT count(*) FROM products) AS products,
      (SELECT count(*) FROM categories) AS categories,
      (SELECT count(*) FROM product_variants) AS variants,
      (SELECT count(*) FROM reviews) AS reviews`);
  const rls = await pool.query(`SELECT count(*) AS without_rls FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
      WHERE n.nspname='public' AND c.relkind='r' AND NOT c.relrowsecurity`);
  const anonWrite = await pool.query(`SELECT count(*) AS anon_write_grants FROM information_schema.role_table_grants
      WHERE table_schema='public' AND grantee IN ('anon','authenticated') AND privilege_type IN ('INSERT','UPDATE','DELETE','TRUNCATE')`);
  console.log("\n=== VERIFY ===");
  console.log("public tables:", t.rows[0].n);
  console.log("counts:", JSON.stringify(counts.rows[0]));
  console.log("tables without RLS:", rls.rows[0].without_rls);
  console.log("anon/authenticated write grants left:", anonWrite.rows[0].anon_write_grants);
}

console.log("— applying drizzle migrations (skip duplicates)…");
await applyMigrations();
console.log(`applied=${stats.applied} skipped=${stats.skipped} errors=${stats.errors.length}`);
if (stats.errors.length) {
  console.log(JSON.stringify(stats.errors, null, 1));
  console.log("ABORTING before security/seed steps due to unexpected errors.");
  process.exitCode = 1;
} else {
  console.log("— hardening security (RLS + revoke writes + read-only catalog policies)…");
  await hardenSecurity();
  console.log("— seeding 5 storefront categories…");
  await seedCategories();
  console.log("— fixing qeysi gallery…");
  await fixQeysiGallery();
  await verify();
}
await pool.end();
