import { and, asc, eq } from "drizzle-orm";
import { db } from "@/db";
import { products, productVariants, categories, mazehTrays, coupons, campaigns } from "@/db/schema";
import { PRODUCTS } from "@/data/products";
import { CATEGORIES } from "@/data/categories";
import { TRAYS } from "@/data/trays";
import { COUPONS, CAMPAIGNS } from "@/data/content";
import type { Campaign, Category, Coupon, MazehTray, Product } from "@/types";

/** PostgreSQL → service → UI. Seed arrays are development-only resilience fallback. */
function toDate(v: Date | string): string { return v instanceof Date ? v.toISOString() : v; }

export async function getCategories(): Promise<Category[]> {
  try {
    const rows = await db.select().from(categories).where(eq(categories.isActive, true)).orderBy(asc(categories.sortOrder));
    if (rows.length) return rows.map((r) => ({
      id: r.id, name: r.name, slug: r.slug, description: r.description, shortDescription: r.shortDescription,
      image: r.image, imageAlt: r.imageAlt, icon: r.icon, subs: r.subs, sortOrder: r.sortOrder,
      isActive: r.isActive, seoTitle: r.seoTitle, seoDescription: r.seoDescription,
    }));
  } catch { /* development fallback */ }
  return CATEGORIES;
}

export async function getProducts(): Promise<Product[]> {
  try {
    const [rows, variantRows] = await Promise.all([
      db.select().from(products).where(and(eq(products.isActive, true), eq(products.isVisible, true))),
      db.select().from(productVariants).where(eq(productVariants.isActive, true)).orderBy(asc(productVariants.sortOrder)),
    ]);
    const variantsByProduct = new Map<number, typeof variantRows>();
    for (const variant of variantRows) variantsByProduct.set(variant.productId, [...(variantsByProduct.get(variant.productId) ?? []), variant]);
    if (rows.length) return rows.map((r) => ({
      id: r.id, name: r.name, slug: r.slug, category: r.category, categoryId: r.categoryId, sku: r.sku,
      brand: r.brand, shortDescription: r.shortDescription, price: r.price, oldPrice: r.oldPrice, discount: r.discount,
      weight: r.weight, image: r.image, gallery: r.gallery, description: r.description, rating: r.rating, reviews: r.reviews,
      stock: r.stock, stockStatus: r.stockStatus, lowStockThreshold: r.lowStockThreshold, minOrderQty: r.minOrderQty,
      maxOrderQty: r.maxOrderQty, isActive: r.isActive, isFeatured: r.isFeatured, isVisible: r.isVisible,
      badge: r.badge, tags: r.tags,
      variants: (variantsByProduct.get(r.id) ?? []).map((v) => ({ id: v.id, name: v.name, sku: v.sku, price: v.price, compareAtPrice: v.compareAtPrice, stock: v.stock, weight: v.weight, unit: v.unit, flavor: v.flavor, isActive: v.isActive, sortOrder: v.sortOrder })),
      features: [
        ...r.features.filter((f) => !["نوع بسته‌بندی", "مواد اولیه", "محل تولید"].includes(f.label)),
        ...(r.packaging ? [{ label: "نوع بسته‌بندی", value: r.packaging }] : []),
        ...(r.ingredients ? [{ label: "مواد اولیه", value: r.ingredients }] : []),
        ...(r.origin ? [{ label: "محل تولید", value: r.origin }] : []),
      ],
      nutrition: r.nutrition, storage: r.storage, packaging: r.packaging, ingredients: r.ingredients, origin: r.origin,
      unit: r.unit, imageAlt: r.imageAlt, seoTitle: r.seoTitle, seoDescription: r.seoDescription,
      allergens: r.allergens, createdAt: toDate(r.createdAt),
    }));
  } catch { /* development fallback */ }
  return PRODUCTS;
}

export async function getProductBySlug(slug: string): Promise<Product | undefined> {
  return (await getProducts()).find((p) => p.slug === slug);
}

export async function getTrays(): Promise<MazehTray[]> {
  try {
    const rows = await db.select().from(mazehTrays).where(eq(mazehTrays.active, true));
    if (rows.length) return rows.map((r) => ({
      id: r.id, name: r.name, slug: r.slug, shortDescription: r.shortDescription, description: r.description,
      image: r.image, basePrice: r.basePrice, oldPrice: r.oldPrice, size: r.size, servesMin: r.servesMin,
      servesMax: r.servesMax, featured: r.featured, active: r.active, sku: r.sku, stock: r.stock,
      lowStockThreshold: r.lowStockThreshold, weight: r.weight, imageAlt: r.imageAlt,
      seoTitle: r.seoTitle, seoDescription: r.seoDescription, allergens: r.allergens,
      pairings: r.pairings, occasions: r.occasions,
      contents: r.contents.map((c) => ({ title: c.title, section: c.section as MazehTray["contents"][number]["section"], qty: c.qty, productId: c.productId })),
      storage: r.storage, freshness: r.freshness, createdAt: toDate(r.createdAt),
    }));
  } catch { /* development fallback */ }
  return TRAYS;
}

export async function getTrayBySlug(slug: string): Promise<MazehTray | undefined> {
  return (await getTrays()).find((t) => t.slug === slug);
}

export async function getCoupons(): Promise<Coupon[]> {
  try {
    const rows = await db.select().from(coupons);
    if (rows.length) return rows.map((r) => ({
      code: r.code, type: r.type as Coupon["type"], value: r.value, minimumPurchase: r.minimumPurchase,
      maximumDiscount: r.maximumDiscount, startDate: r.startDate, endDate: r.endDate,
      usageLimit: r.usageLimit, active: r.active, label: r.label,
    }));
  } catch { /* development fallback */ }
  return COUPONS;
}

export async function getCampaigns(): Promise<Campaign[]> {
  try {
    const rows = await db.select().from(campaigns);
    if (rows.length) return rows.map((r) => ({
      id: r.id, title: r.title, slug: r.slug, banner: r.banner, description: r.description,
      startDate: r.startDate, endDate: r.endDate, discount: r.discount, category: r.category, active: r.active,
    }));
  } catch { /* development fallback */ }
  return CAMPAIGNS;
}
