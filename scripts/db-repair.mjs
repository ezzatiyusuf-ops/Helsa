// HELSA — approved data repair (audit follow-up). Single transaction, rollback on error.
// 1) Restore fields lost in migration from local source: short_description, image_alt,
//    seo_title, seo_description, old_price, stock_status.
// 2) Remove unsubstantiated claims from 3 descriptions (qeysi/date-powder/dried-apricots).
// 3) Remove unsupported badges («محدود» scarcity, «تخفیف» without active discount window).
// 4) Link category_id for the 5 nav categories by slug.
// 5) Fix galleries: drop refs to files missing on disk; seeds products point to their own photo.
import pg from "pg";
import { readFileSync, existsSync } from "node:fs";

const root = new URL("../", import.meta.url);
const env = readFileSync(new URL(".env", root), "utf8");
const url = env.match(/^DATABASE_URL=(.*)$/m)[1].trim().replace(/^["']|["']$/g, "");
const pool = new pg.Pool({ connectionString: url, max: 1, connectionTimeoutMillis: 20000 });
const pub = new URL("public/", root).pathname;

const ts = readFileSync(new URL("src/data/products.ts", root), "utf8");
const LOCAL = JSON.parse(ts.slice(ts.indexOf("= [") + 2, ts.lastIndexOf("];") + 1));
const localBySlug = new Map(LOCAL.map((p) => [p.slug, p]));

const RESTORE = [["shortDescription", "short_description"], ["imageAlt", "image_alt"], ["seoTitle", "seo_title"], ["seoDescription", "seo_description"], ["oldPrice", "old_price"], ["stockStatus", "stock_status"]];
const norm = (v) => (v === undefined ? null : v);

const client = await pool.connect();
const log = { restored: {}, claimsFixed: [], badgesRemoved: [], linked: 0, galleriesFixed: [] };
try {
  await client.query("BEGIN");
  const { rows: DB } = await client.query("SELECT * FROM public.products ORDER BY id");

  // ── 1) field restore ──
  for (const r of DB) {
    const lp = localBySlug.get(r.slug);
    if (!lp) continue;
    const sets = [], vals = [];
    for (const [lk, dk] of RESTORE) {
      const lv = norm(lp[lk]);
      if (JSON.stringify(lv) !== JSON.stringify(r[dk])) { sets.push(`${dk} = $${vals.length + 1}`); vals.push(lv); }
    }
    if (sets.length) {
      vals.push(r.id);
      await client.query(`UPDATE public.products SET ${sets.join(", ")}, updated_at = now() WHERE id = $${vals.length}`, vals);
      for (const s of sets) { const f = s.split(" ")[0]; log.restored[f] = (log.restored[f] ?? 0) + 1; }
    }
  }

  // ── 2) claims cleanup (exact, surgical) ──
  const CLAIM_FIXES = [
    ["qeysi-dried-apricot", "description", " و بدون افزودنی عرضه می‌گردد.", "."],
    ["date-powder", "description", " بدون افزودنی.", "."],
    ["dried-apricots", "description", " بدون مواد نگهدارنده؛", "؛"],
  ];
  for (const [slug, field, from, to] of CLAIM_FIXES) {
    const { rows } = await client.query(`SELECT ${field} AS v FROM public.products WHERE slug = $1`, [slug]);
    const cur = rows[0]?.v ?? "";
    if (cur.includes(from)) {
      await client.query(`UPDATE public.products SET ${field} = $1, updated_at = now() WHERE slug = $2`, [cur.replace(from, to), slug]);
      log.claimsFixed.push(`${slug}.${field}`);
    } else log.claimsFixed.push(`${slug}.${field}: الگو یافت نشد — دست نخورده`);
  }
  // any remaining claim phrases anywhere in qeysi text fields → report only
  const { rows: qr } = await client.query("SELECT short_description, seo_title, seo_description FROM public.products WHERE slug='qeysi-dried-apricot'");
  console.log("qeysi text fields now:", JSON.stringify(qr[0]));

  // ── 3) badges ──
  const { rows: br } = await client.query("UPDATE public.products SET badge = NULL, updated_at = now() WHERE badge IN ('محدود','تخفیف') RETURNING slug, badge");
  log.badgesRemoved = br.map((b) => `${b.slug} (${b.badge})`);

  // ── 4) category_id link by slug ──
  const { rows: lr } = await client.query(`UPDATE public.products p SET category_id = c.id, updated_at = now()
    FROM public.categories c WHERE p.category = c.slug AND p.category_id IS NULL RETURNING p.slug`);
  log.linked = lr.length;

  // ── 5) galleries: drop missing-file refs, own-photo overrides for seeds ──
  const OWN = { "japanese-seeds": "/images/opt/japanese-seeds.jpg", "salted-seeds": "/images/opt/mixed-seeds.jpg", "roasted-seeds": "/images/opt/mixed-seeds.jpg", "helsa-flavored-seeds": "/images/opt/mixed-seeds.jpg" };
  for (const r of DB) {
    let gal = Array.isArray(r.gallery) ? [...r.gallery] : [];
    if (OWN[r.slug]) gal = [OWN[r.slug]];
    else {
      const keep = gal.filter((p) => typeof p === "string" && p.startsWith("/") && existsSync(pub + p));
      gal = [...new Set([r.image, ...keep].filter(Boolean))];
    }
    if (JSON.stringify(gal) !== JSON.stringify(r.gallery)) {
      await client.query("UPDATE public.products SET gallery = $1::jsonb, updated_at = now() WHERE id = $2", [JSON.stringify(gal), r.id]);
      log.galleriesFixed.push(r.slug);
    }
  }

  await client.query("COMMIT");
} catch (e) {
  await client.query("ROLLBACK");
  console.error("ROLLED BACK:", e.message);
  process.exitCode = 1;
} finally {
  client.release();
}
console.log(JSON.stringify(log, null, 1));
await pool.end();
