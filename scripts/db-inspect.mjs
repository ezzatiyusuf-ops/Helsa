// Read-only DB inspection — never prints secrets.
import pg from "pg";
import { readFileSync } from "node:fs";

const env = readFileSync(new URL("../.env", import.meta.url), "utf8");
const m = env.match(/^DATABASE_URL=(.*)$/m);
if (!m) { console.error("DATABASE_URL missing"); process.exit(1); }
const url = m[1].trim().replace(/^["']|["']$/g, "");

const pool = new pg.Pool({ connectionString: url, max: 1, connectionTimeoutMillis: 15000 });
const q = (label, sql) => pool.query(sql).then((r) => {
  console.log(`\n=== ${label} ===`);
  console.log(JSON.stringify(r.rows, null, 1));
}).catch((e) => console.log(`\n=== ${label} === ERROR: ${e.message}`));

await q("tables", "SELECT tablename FROM pg_tables WHERE schemaname='public' ORDER BY 1");
await q("category-values", "SELECT category, count(*) AS n FROM products GROUP BY 1 ORDER BY 2 DESC");
await q("sample-rows", `SELECT slug, sku, price, stock, category, weight, unit, brand, is_active, is_visible,
        jsonb_array_length(features) AS n_features, jsonb_array_length(tags) AS n_tags,
        left(coalesce(short_description,''),60) AS short_desc
 FROM products WHERE slug IN ('qeysi-dried-apricot','piaram-dates','mazafati-dates') ORDER BY slug`);
await q("rls", "SELECT relname, relrowsecurity FROM pg_class WHERE relname IN ('products','categories') AND relnamespace='public'::regnamespace");
await q("grants", "SELECT grantee, table_name, privilege_type FROM information_schema.role_table_grants WHERE table_name IN ('products','categories') AND grantee IN ('anon','authenticated') ORDER BY 2,1,3");
await q("constraints", "SELECT conname, contype FROM pg_constraint WHERE conrelid='public.products'::regclass");
await pool.end();
