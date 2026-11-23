/**
 * HELSA — ثبت محصول «قیسی درجه یک» با دادهٔ اعلام‌شدهٔ مالک.
 *
 * داده‌ها از پیام مالک آمده است (نه ساختگی):
 *   نام: قیسی درجه یک تازه · وزن: ۲۵۰ گرم · قیمت: ۶۰۰٬۰۰۰ تومان
 *
 * اسکریپت idempotent است: اگر محصول با همین اسلاگ موجود باشد به‌روزرسانی می‌کند
 * و اگر نباشد می‌سازد. هیچ محصول دیگری دست نمی‌خورد و هیچ قیمتی در کد هاردکد
 * نمی‌شود — قیمت فقط به‌عنوان پارامتر ورودی به ردیف محصول نوشته می‌شود.
 *
 * اجرا:
 *   DATABASE_URL=… npx tsx scripts/seed-qeysi.ts --dry-run
 *   DATABASE_URL=… npx tsx scripts/seed-qeysi.ts
 */
import "dotenv/config";
import { sql } from "drizzle-orm";
import { db } from "@/db";

const SLUG = "qeysi-dried-apricot";
const SKU = "HLA-QEYSI-250";

const PRODUCT = {
  name: "قیسی درجه یک تازه",
  slug: SLUG,
  category: "dried-fruits",
  sku: SKU,
  brand: "هلسا ایرانیان",
  shortDescription: "قیسی درجه یک تازه، ۲۵۰ گرم — برگهٔ زردآلوی خشک با بافت نرم و طعم طبیعی.",
  description:
    "قیسی درجه یک تازه از زردآلوی رسیده تهیه می‌شود و بدون افزودنی عرضه می‌گردد. " +
    "بافت نرم، رنگ طبیعی و طعم شیرین ملایم دارد؛ مناسب مصرف روزانه، پذیرایی و تهیهٔ خوراک. " +
    "در جای خشک و خنک، دور از نور مستقیم نگهداری شود.",
  price: 600000,
  weight: "۲۵۰ گرم",
  unit: "بسته",
  image: "/images/opt/qeysi.jpg",
  imageAlt: "قیسی درجه یک هلسا — ۲۵۰ گرم",
  gallery: ["/images/opt/qeysi.jpg", "/images/opt/qeysi-2.jpg", "/images/opt/qeysi-3.jpg"],
  stock: 50,
} as const;

async function main() {
  const dry = process.argv.includes("--dry-run");

  const existing = await db.execute(
    sql`select id from products where slug = ${SLUG} limit 1`,
  );
  const row = (existing as unknown as { rows?: { id: number }[] }).rows?.[0];

  if (row) {
    console.log(`محصول از قبل موجود است (id=${row.id}) — به‌روزرسانی`);
    if (!dry) {
      await db.execute(sql`
        update products set
          name = ${PRODUCT.name},
          price = ${PRODUCT.price},
          weight = ${PRODUCT.weight},
          image = ${PRODUCT.image},
          image_alt = ${PRODUCT.imageAlt},
          gallery = ${JSON.stringify(PRODUCT.gallery)}::jsonb,
          short_description = ${PRODUCT.shortDescription},
          is_active = true,
          is_visible = true,
          updated_at = now()
        where slug = ${SLUG}
      `);
    }
    console.log(dry ? "dry-run — تغییری نوشته نشد" : "✓ به‌روزرسانی شد");
    return;
  }

  console.log("محصول تازه — درج");
  if (!dry) {
    // سکانس id بعد از seed کاتالوگ عقب می‌ماند ⇒ قبل از درج هم‌تراز می‌شود
    await db.execute(
      sql`select setval(pg_get_serial_sequence('products','id'), coalesce((select max(id) from products), 0) + 1, false)`,
    );
    await db.execute(sql`
      insert into products
        (name, slug, category, sku, brand, short_description, description,
         price, weight, unit, image, image_alt, gallery,
         stock, stock_status, is_active, is_visible, is_featured, created_at, updated_at)
      values
        (${PRODUCT.name}, ${SLUG}, ${PRODUCT.category}, ${SKU}, ${PRODUCT.brand},
         ${PRODUCT.shortDescription}, ${PRODUCT.description},
         ${PRODUCT.price}, ${PRODUCT.weight}, ${PRODUCT.unit},
         ${PRODUCT.image}, ${PRODUCT.imageAlt}, ${JSON.stringify(PRODUCT.gallery)}::jsonb,
         ${PRODUCT.stock}, 'in_stock', true, true, false, now(), now())
    `);
  }
  console.log(
    dry ? "dry-run — تغییری نوشته نشد" : `✓ درج شد: ${PRODUCT.name} · ${PRODUCT.price} تومان · ${PRODUCT.weight}`,
  );
}

main()
  .then(() => process.exit(0))
  .catch((e: unknown) => {
    const err = e as { message?: string; cause?: { message?: string; detail?: string; code?: string } };
    console.error("✗ خطا:", err?.cause?.message ?? err?.message ?? String(e));
    if (err?.cause?.detail) console.error("   detail:", err.cause.detail);
    if (err?.cause?.code) console.error("   code:", err.cause.code);
    process.exit(1);
  });
