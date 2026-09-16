"use client";
import { useState } from "react";
import Link from "next/link";
import { ShoppingBag, Check, PackageX, Leaf } from "lucide-react";
import type { Product } from "@/types";
import { useStore } from "@/lib/store";
import { useToast } from "@/components/ui/Toast";
import { useLang } from "@/lib/i18n";
import { Badge, Price } from "@/components/ui/primitives";
import { SmartImage } from "@/components/ui/SmartImage";
import { isOrganic } from "@/lib/product-flags";
import { faDigits } from "@/lib/format";

/**
 * کارت محصول هلسا — چیدمان لاغر و پرمیوم (بازطراحی ۱.۱۸.۰):
 * تصویر مربع ۱:۱، بج‌های کوچک فقط روی گوشهٔ تصویر (پیشنهاد امروز / پرفروش / تخفیف / طبیعی)،
 * نام، وزن، قیمت (+قیمت قبل تخفیف) و «یک» کنش اصلی: افزودن به سبد.
 * مشاهدهٔ سریع/مقایسه/علاقه‌مندی از کارت حذف شدند (جست‌وجو و علاقه‌مندی از هدر؛
 * جزئیات کامل در صفحهٔ محصول) — توجه خریدار روی کشف محصول می‌ماند.
 */
export function ProductCard({ product, today = false }: { product: Product; today?: boolean }) {
  const addItem = useStore((s) => s.addItem);
  const toast = useToast();
  const { t } = useLang();
  const [added, setAdded] = useState(false);
  const out = product.stock <= 0;
  const organic = isOrganic(product);
  const name = product.name;

  const onAdd = () => {
    if (out) {
      toast.push(t("toast.unavailable"), "error");
      return;
    }
    addItem(
      {
        key: `p-${product.id}`,
        kind: "product",
        id: product.id,
        name: product.name,
        slug: product.slug,
        image: product.image,
        price: product.price,
        weight: product.weight,
      },
      Math.min(1, product.stock),
    );
    toast.push(t("toast.added"));
    setAdded(true);
    window.setTimeout(() => setAdded(false), 2200);
  };

  return (
    <article className="group prem-card flex h-full flex-col rounded-[20px] border border-line/70 bg-surface p-3 shadow-soft transition-all duration-200 hover:-translate-y-0.5 hover:border-brand-200 hover:shadow-lift">
      <div className="relative overflow-hidden rounded-[14px] border border-line-soft bg-gradient-to-br from-surface2 to-surface3/70 aspect-square">
        <Link href={`/products/${product.slug}`} aria-label={name} className="block size-full">
          <SmartImage
            src={product.image}
            alt={product.imageAlt || name}
            sizes="(min-width: 1280px) 22vw, (min-width: 768px) 30vw, 46vw"
            className="size-full object-cover transition-transform duration-200 group-hover:scale-[1.03]"
          />
        </Link>

        {/* بج‌ها — فقط گوشهٔ تصویر، کوچک و آرام */}
        <div className="absolute top-2.5 start-2.5 flex flex-col items-start gap-1.5">
          {today && (
            <span className="inline-flex items-center gap-1 rounded-full border border-gold-400/60 bg-ink-950/45 px-2.5 py-1 text-[9.5px] font-black text-gold-300 backdrop-blur-md">
              پیشنهاد امروز
            </span>
          )}
          {product.badge && product.badge !== "تخفیف" && <Badge tone="brand">{product.badge}</Badge>}
          {product.discount > 0 && <Badge tone="accent">{faDigits(product.discount)}٪ تخفیف</Badge>}
          {organic && (
            <span className="inline-flex items-center gap-1 rounded-full border border-white/30 bg-ink-950/35 px-2.5 py-1 text-[9.5px] font-bold text-white backdrop-blur-md" title="کاملاً طبیعی و بدون افزودنی">
              <Leaf className="size-3" aria-hidden /> طبیعی
            </span>
          )}
        </div>

        {out && (
          <div className="absolute inset-0 flex items-center justify-center bg-surface/70 backdrop-blur-[2px]">
            <span className="flex items-center gap-2 rounded-full border border-line bg-surface px-4 py-2 text-xs font-bold text-body">
              <PackageX className="size-4" aria-hidden /> {t("card.out")}
            </span>
          </div>
        )}
      </div>

      <div className="flex flex-1 flex-col px-0.5 pt-3">
        <Link href={`/products/${product.slug}`} className="group/title">
          <h3 className="text-[13px] font-extrabold leading-6 text-heading line-clamp-2-fa transition-colors duration-200 group-hover/title:text-brand-600">
            {name}
          </h3>
        </Link>
        <p className="mt-1 text-[10.5px] font-bold text-muted">{product.weight}</p>

        <div className="mt-2.5 mb-3">
          <Price price={product.price} oldPrice={product.oldPrice} size="md" />
        </div>

        <button
          onClick={onAdd}
          disabled={out}
          aria-label={`افزودن ${name} به سبد`}
          className="mt-auto inline-flex h-10 w-full items-center justify-center gap-1.5 rounded-full bg-brand-700 text-[11.5px] font-black text-inverse shadow-soft transition-all duration-200 hover:bg-brand-800 active:scale-[0.98] disabled:opacity-40"
        >
          {added ? <Check className="size-4 shrink-0" aria-hidden /> : <ShoppingBag className="size-4 shrink-0" aria-hidden />}
          {added ? "افزوده شد" : t("card.add")}
        </button>
      </div>
    </article>
  );
}
