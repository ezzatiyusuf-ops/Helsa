// HELSA — full data audit: Supabase products vs local source (src/data/products.ts).
// READ-ONLY. Writes a Persian Markdown report to /home/user/helsa-data-audit-report.md.
import pg from "pg";
import { readFileSync, writeFileSync, existsSync } from "node:fs";

const root = new URL("../", import.meta.url);
const env = readFileSync(new URL(".env", root), "utf8");
const url = env.match(/^DATABASE_URL=(.*)$/m)[1].trim().replace(/^["']|["']$/g, "");
const pool = new pg.Pool({ connectionString: url, max: 1, connectionTimeoutMillis: 20000 });

// ── 1) local source ────────────────────────────────────────────────
const ts = readFileSync(new URL("src/data/products.ts", root), "utf8");
const start = ts.indexOf("= [") + 2;
const end = ts.lastIndexOf("];") + 1;
const LOCAL = JSON.parse(ts.slice(start, end));

// ── 2) DB ──────────────────────────────────────────────────────────
const { rows: DB } = await pool.query("SELECT * FROM public.products ORDER BY id");
const dbBySlug = new Map(DB.map((r) => [r.slug, r]));
const localBySlug = new Map(LOCAL.map((p) => [p.slug, p]));

const onlyDb = DB.filter((r) => !localBySlug.has(r.slug)).map((r) => r.slug);
const onlyLocal = LOCAL.filter((p) => !dbBySlug.has(p.slug)).map((p) => p.slug);

// ── 3) field-by-field diff ─────────────────────────────────────────
const FIELDS = [
  ["id", "id", "info"], ["name", "name"], ["category", "category"], ["categoryId", "category_id"],
  ["sku", "sku"], ["brand", "brand"], ["shortDescription", "short_description"], ["description", "description"],
  ["price", "price"], ["oldPrice", "old_price"], ["discount", "discount"], ["discountStartsAt", "discount_starts_at", "date"],
  ["weight", "weight"], ["unit", "unit"], ["stock", "stock"], ["stockStatus", "stock_status"],
  ["lowStockThreshold", "low_stock_threshold"], ["minOrderQty", "min_order_qty"], ["maxOrderQty", "max_order_qty"],
  ["image", "image"], ["imageAlt", "image_alt"], ["gallery", "gallery", "json"],
  ["badge", "badge"], ["tags", "tags", "json"], ["features", "features", "json"], ["nutrition", "nutrition", "json"],
  ["allergens", "allergens", "json"], ["packaging", "packaging"], ["ingredients", "ingredients"], ["origin", "origin"],
  ["storage", "storage"], ["isActive", "is_active"], ["isFeatured", "is_featured"], ["isVisible", "is_visible"],
  ["seoTitle", "seo_title"], ["seoDescription", "seo_description"], ["rating", "rating"], ["reviews", "reviews"],
  ["createdAt", "created_at", "info"],
];
const DEFAULTS = { brand: "هلسا ایرانیان", unit: "بسته", stockStatus: "in_stock", lowStockThreshold: 5, minOrderQty: 1, discount: 0, isActive: true, isVisible: true, isFeatured: false, rating: 0, reviews: 0, imageAlt: "", gallery: [], tags: [], features: [], nutrition: [], allergens: [], packaging: "", ingredients: "", origin: "", storage: "", shortDescription: "", description: "", oldPrice: null, maxOrderQty: null, badge: null, seoTitle: null, seoDescription: null, discountStartsAt: null, categoryId: null, id: undefined, createdAt: undefined };

const norm = (v, kind, lk) => {
  if (v === undefined) v = DEFAULTS[lk];
  if (v === undefined) return undefined;
  if (kind === "date") return v ? new Date(v).toISOString() : null;
  if (v instanceof Date) return v.toISOString();
  return v;
};
const eq = (a, b) => JSON.stringify(a) === JSON.stringify(b);

const fieldStats = new Map(); // field → {count, examples[]}
for (const lp of LOCAL) {
  const dr = dbBySlug.get(lp.slug);
  if (!dr) continue;
  for (const [lk, dk, kind] of FIELDS) {
    const lv = norm(lp[lk], kind, lk);
    const dv = norm(dr[dk], kind, lk);
    if (lv === undefined || dv === undefined) continue;
    if (!eq(lv, dv)) {
      const s = fieldStats.get(lk) ?? { count: 0, examples: [] };
      s.count++;
      if (s.examples.length < 6) s.examples.push({ slug: lp.slug, local: JSON.stringify(lv)?.slice(0, 120), db: JSON.stringify(dv)?.slice(0, 120) });
      fieldStats.set(lk, s);
    }
  }
}

// ── 4) claims scan (standing rule: no organic/medical/no-additive/cert claims without backing) ──
const CLAIM_RE = /(ارگانیک|organic|بدون افزودنی|بدون مواد افزودنی|بدون نگهدارنده|بدون مواد نگهدارنده|درمانی|درمان|معجزه|گواهی|certified|صد در صد طبیعی|صددرصد طبیعی|کاملاً طبیعی|تضمینی)/i;
const TEXTF = [["name", "name"], ["shortDescription", "short_description"], ["description", "description"], ["badge", "badge"], ["seoTitle", "seo_title"], ["seoDescription", "seo_description"]];
const claims = [];
for (const dr of DB) {
  const lp = localBySlug.get(dr.slug);
  for (const [lk, dk] of TEXTF) {
    const dv = dr[dk];
    if (typeof dv === "string" && CLAIM_RE.test(dv)) {
      const inLocal = lp && typeof lp[lk] === "string" && CLAIM_RE.test(lp[lk]);
      claims.push({ slug: dr.slug, field: lk, snippet: dv.slice(0, 90), origin: inLocal ? "هر دو (از منبع محلی)" : "فقط در دیتابیس ⚠️" });
    }
  }
  for (const f of dr.features ?? []) {
    if (f?.value && CLAIM_RE.test(f.value)) claims.push({ slug: dr.slug, field: `features.${f.label}`, snippet: String(f.value).slice(0, 90), origin: "دیتابیس" });
  }
}

// ── 5) badges / discounts / stock ──────────────────────────────────
const badges = new Map();
for (const dr of DB) if (dr.badge) badges.set(dr.badge, (badges.get(dr.badge) ?? 0) + 1);
const discounts = DB.filter((r) => (r.old_price && r.old_price > r.price) || r.discount > 0)
  .map((r) => ({ slug: r.slug, price: r.price, old: r.old_price, discount: r.discount, starts: r.discount_starts_at ? new Date(r.discount_starts_at).toISOString().slice(0, 10) : null, inLocal: localBySlug.has(r.slug) && (localBySlug.get(r.slug).oldPrice ?? null) === r.old_price }));
const stockIssues = DB.filter((r) => r.stock < 0 || (r.stock === 0 && r.stock_status === "in_stock"))
  .map((r) => ({ slug: r.slug, stock: r.stock, status: r.stock_status }));
const ratingSeeded = DB.filter((r) => r.rating > 0 || r.reviews > 0).map((r) => ({ slug: r.slug, rating: r.rating, reviews: r.reviews }));

// ── 6) images exist on disk? ───────────────────────────────────────
const pub = new URL("public/", root).pathname;
const missingImages = [];
for (const dr of DB) {
  for (const p of [dr.image, ...(dr.gallery ?? [])]) {
    if (p && p.startsWith("/") && !existsSync(pub + p)) missingImages.push({ slug: dr.slug, path: p });
  }
}

// ── 7) categories ──────────────────────────────────────────────────
const NAV5 = ["dates", "date-products", "nuts", "dried-fruits", "natural"];
const catCount = new Map();
for (const dr of DB) catCount.set(dr.category, (catCount.get(dr.category) ?? 0) + 1);
const outsideNav = [...catCount.entries()].filter(([c]) => !NAV5.includes(c));
const outsideNavProducts = outsideNav.reduce((a, [, n]) => a + n, 0);
const nullCatId = DB.filter((r) => r.category_id === null).length;

// ── 8) qeysi dossier ───────────────────────────────────────────────
const q = dbBySlug.get("qeysi-dried-apricot");

// ── report ─────────────────────────────────────────────────────────
const fmtN = (n) => Number(n).toLocaleString("en-US");
let md = `# گزارش ممیزی کامل دادهٔ کاتالوگ — هلسا
تاریخ: ${new Date().toISOString().slice(0, 19)}Z — منبع محلی: \`src/data/products.ts\` (${LOCAL.length} محصول) — دیتابیس: Supabase (${DB.length} محصول)
این ممیزی فقط خواندنی بود؛ هیچ داده‌ای تغییر نکرده است.

## خلاصهٔ اجرایی
| شاخص | مقدار |
|---|---|
| محصولات محلی | ${LOCAL.length} |
| محصولات دیتابیس | ${DB.length} |
| تطبیق بر اساس slug | ${LOCAL.length - onlyLocal.length} |
| فقط در دیتابیس | ${onlyDb.length ? onlyDb.join(", ") : "—" } |
| فقط در منبع محلی | ${onlyLocal.length ? onlyLocal.join(", ") : "—"} |
| فیلدهای ناسازگار (بیش از صفر) | ${[...fieldStats.entries()].filter(([k, s]) => k !== "id" && k !== "createdAt" && s.count > 0).length} |
| ادعای نیازمند سند | ${claims.length} |
| محصول با بج | ${badges.size ? [...badges.values()].reduce((a, b) => a + b) : 0} |
| محصول با قیمت قدیمی/تخفیف | ${discounts.length} |
| ناسازگاری موجودی | ${stockIssues.length} |
| ریتینگ/نظر seed‌شده (باید صفر باشد) | ${ratingSeeded.length} |
| تصویر گمشده روی دیسک | ${missingImages.length} |
| محصول خارج از ۵ دستهٔ ناوبری | ${outsideNavProducts} |
| category_id خالی | ${nullCatId} |

## ۱) ناسازگاری فیلدها (محلی ↔ دیتابیس)
| فیلد | تعداد | نمونه‌ها (slug → محلی ‖ دیتابیس) |
|---|---|---|
`;
for (const [k, s] of [...fieldStats.entries()].sort((a, b) => b[1].count - a[1].count)) {
  if (k === "id" || k === "createdAt") continue;
  md += `| \`${k}\` | ${s.count} | ${s.examples.slice(0, 3).map((e) => `\`${e.slug}\`: ${e.local} ‖ ${e.db}`).join("<br>")} |\n`;
}
md += `\n> ستون‌های \`id\` (محلی↔دیتابیس: ${fieldStats.get("id")?.count ?? 0} متفاوت) و \`createdAt\` (${fieldStats.get("createdAt")?.count ?? 0}) در انتقال بازنشانی شده‌اند؛ سایت با slug/sku کار می‌کند پس اثر عملیاتی ندارد ولی در گزارش ثبت شد.\n`;

md += `\n## ۲) ادعاهای نیازمند سند (قانون دائمی: ارگانیک/درمانی/بدون‌افزودنی/گواهی بدون سند ممنوع)
| محصول | فیلد | متن | منشأ |
|---|---|---|---|
`;
for (const c of claims.slice(0, 40)) md += `| \`${c.slug}\` | ${c.field} | ${c.snippet.replaceAll("|", "／")} | ${c.origin} |\n`;
if (!claims.length) md += `| — | — | موردی یافت نشد | — |\n`;

md += `\n## ۳) بج‌ها\n| بج | تعداد |\n|---|---|\n`;
for (const [b, n] of badges) md += `| ${b} | ${n} |\n`;
if (!badges.size) md += `| — | ۰ |\n`;

md += `\n## ۴) تخفیف‌ها / قیمت قدیمی (${discounts.length} محصول)\n| محصول | قیمت | قیمت قدیمی | ٪ | شروع تخفیف | مطابق منبع محلی؟ |\n|---|---|---|---|---|---|\n`;
for (const d of discounts.slice(0, 30)) md += `| \`${d.slug}\` | ${fmtN(d.price)} | ${d.old ? fmtN(d.old) : "—"} | ${d.discount} | ${d.starts ?? "—"} | ${d.inLocal ? "بله" : "خیر ⚠️"} |\n`;

md += `\n## ۵) موجودی\n`;
md += stockIssues.length ? stockIssues.map((s) => `- \`${s.slug}\`: stock=${s.stock} status=${s.status}`).join("\n") : "- ناسازگاری‌ای یافت نشد (هیچ منفی یا صفرِ «موجود» نیست).";
md += `\n\n## ۶) ریتینگ/نظر ستون‌خوری (باید صفر باشد — ریت واقعی فقط از جدول reviews)\n`;
md += ratingSeeded.length ? ratingSeeded.map((r) => `- \`${r.slug}\`: rating=${r.rating} reviews=${r.reviews}`).join("\n") : "- همه صفر ✅";

md += `\n\n## ۷) تصاویر گمشده روی دیسک (${missingImages.length})\n`;
md += missingImages.length ? missingImages.map((m) => `- \`${m.slug}\` → \`${m.path}\``).join("\n") : "- همهٔ مسیرهای image/gallery روی دیسک موجودند ✅";

md += `\n\n## ۸) دسته‌بندی و ناوبری\n- پنج دستهٔ ناوبری: ${NAV5.map((c) => `\`${c}\``).join("، ")}\n- ${outsideNavProducts} محصول در ${outsideNav.length} اسلاگ دیگر دسته‌بندی شده‌اند که در ناوبری اصلی دسته ندارند (فقط در «همه» دیده می‌شوند): ${outsideNav.sort((a, b) => b[1] - a[1]).map(([c, n]) => `\`${c}\`(${n})`).join("، ")}\n- \`category_id\` در ${nullCatId} محصول NULL است (اتصال FK به جدول categories انجام نشده؛ سایت با رشتهٔ \`category\` کار می‌کند پس خرابی ندارد، ولی برای مدیریت از پنل بهتر است لینک شود).\n`;

md += `\n## ۹) پروندهٔ ویژهٔ قیسی (فقط در دیتابیس — بدون منبع محلی برای راستی‌آزمایی)\n`;
if (q) md += `| فیلد | مقدار |\n|---|---|\n` + Object.entries(q).map(([k, v]) => `| ${k} | ${JSON.stringify(v)?.slice(0, 140)?.replaceAll("|", "／")} |`).join("\n");
md += `\n\n⚠️ همهٔ فیلدهای قیسی «تأییدنشده»‌اند چون در منبع محلی وجود ندارد؛ متن «بدون افزودنی» در توضیح آن با قانون دائمی (ممنوعیت ادعای بی‌سند) ناسازگار است.\n`;

md += `\n## ۱۰) نقشهٔ تعمیر غیرمخرب پیشنهادی (نیازمند تأیید شما قبل از هر نوشتن)\n1. بازنویسی فیلدهای خالی/متفاوت از منبع محلی (مثل \`shortDescription\`) — UPDATE صرف، بدون حذف رکورد.\n2. لینک \`category_id\` برای ۵ دستهٔ ناوبری بر اساس تطابق slug.\n3. تصمیم شما برای ادعاهای پرچم‌دار بخش ۲ و ۹: حذف عبارت یا ارائهٔ سند.\n4. تصمیم برای ${outsideNav.length} اسلاگ دستهٔ خارج از ناوبری: افزودن دسته/زیردسته یا بازنگری دستهٔ محصول.\n5. بازتولید \`src/data/products.ts\` از دیتابیس پس از تعمیر (npm run catalog:export) تا fallback با DB یکی شود.\n`;

writeFileSync("/home/user/helsa-data-audit-report.md", md, "utf8");

console.log("=== SUMMARY ===");
console.log(JSON.stringify({
  local: LOCAL.length, db: DB.length, onlyDb, onlyLocal,
  mismatchedFields: [...fieldStats.entries()].filter(([k]) => k !== "id" && k !== "createdAt").map(([k, s]) => `${k}:${s.count}`),
  claims: claims.length, badges: Object.fromEntries(badges), discounts: discounts.length,
  stockIssues: stockIssues.length, ratingSeeded: ratingSeeded.length, missingImages: missingImages.length,
  outsideNavProducts, outsideNavSlugs: outsideNav.length, nullCatId,
}, null, 1));
console.log("report → /home/user/helsa-data-audit-report.md");
await pool.end();
