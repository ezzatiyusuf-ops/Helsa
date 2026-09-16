"use client";
import { useState } from "react";
import { Price } from "@/components/ui/primitives";
import Link from "next/link";
import { Plus, ShoppingBag } from "lucide-react";
import { useStore } from "@/lib/store";
import { useToast } from "@/components/ui/Toast";
import { faDigits, formatToman, formatPriceShort } from "@/lib/format";
import type { GiftPackage } from "@/types";

/**
 * کارت جعبهٔ هدیه برای نوار پیشنهاد ویژه — یکی از ۴ محصول هیروی هلسا
 * (شکلات خرمایی · قند خرما · سینی مزه · جعبهٔ هدیه). قیمت/موجودی واقعی از
 * جدول gift_packages؛ Quick Add با kind="gift" (همان مسیر پرداخت هدیه).
 */
export function GiftBoxCard({ gift }: { gift: GiftPackage }) {
  const addItem = useStore((s) => s.addItem);
  const toast = useToast();
  const [added, setAdded] = useState(false);
  const out = gift.stock <= 0;
  const discount = gift.oldPrice && gift.oldPrice > gift.basePrice
    ? Math.round((1 - gift.basePrice / gift.oldPrice) * 100)
    : 0;

  const quickAdd = () => {
    if (out) return;
    addItem(
      {
        key: `g-${gift.id}`,
        kind: "gift",
        id: gift.id,
        name: gift.name,
        slug: gift.slug,
        image: gift.image,
        price: gift.basePrice,
        meta: "جعبهٔ هدیهٔ هلسا",
      },
      1,
    );
    toast.push("جعبهٔ هدیه به سبد خرید اضافه شد");
    setAdded(true);
    window.setTimeout(() => setAdded(false), 1600);
  };

  return (
    <article className="flex h-full flex-col overflow-hidden rounded-2xl border border-gold-300/70 bg-surface shadow-soft transition-shadow hover:shadow-lift">
      <Link
        href={`/gifts/${gift.kind === "corporate" ? "corporate" : "personal"}/${gift.slug}`}
        className="relative block aspect-[4/5] overflow-hidden img-zoom"
        aria-label={gift.name}
      >
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img src={gift.image} alt={gift.imageAlt || gift.name} loading="lazy" decoding="async" className="size-full object-cover" />
        {discount > 0 && (
          <span className="absolute top-3 start-3 rounded-full bg-accent-600 px-2.5 py-1 text-[10.5px] font-black text-inverse">
            {faDigits(discount)}٪ تخفیف
          </span>
        )}
        <span className="absolute bottom-3 start-3 rounded-full border border-white/30 bg-ink-950/40 px-2.5 py-1 text-[10px] font-bold text-white backdrop-blur-md">
          جعبهٔ هدیهٔ هلسا
        </span>
      </Link>
      <div className="flex flex-1 flex-col p-4">
        <Link
          href={`/gifts/${gift.kind === "corporate" ? "corporate" : "personal"}/${gift.slug}`}
          className="text-[13.5px] font-extrabold leading-6 text-heading hover:text-brand-700"
        >
          {gift.name}
        </Link>
        <div className="mt-1.5">
          <Price price={gift.basePrice} oldPrice={gift.oldPrice} />
        </div>
        <p className="mt-1.5 pb-3 flex items-center gap-1.5 text-[11px] font-bold text-muted">
          <span className={`size-1.5 rounded-full ${out ? "bg-accent-500" : "bg-brand-500"}`} aria-hidden />
          {out ? "موقتاً ناموجود" : "آمادهٔ ارسال"}
        </p>
        <button
          type="button"
          onClick={quickAdd}
          disabled={out}
          className="mt-auto inline-flex h-11 items-center justify-center gap-1.5 self-stretch rounded-full bg-brand-700 text-[11.5px] font-bold text-inverse transition-colors hover:bg-brand-800 disabled:opacity-40"
        >
          {added ? <ShoppingBag className="size-4" aria-hidden /> : <Plus className="size-4" aria-hidden />}
          {added ? "به سبد اضافه شد" : out ? "ناموجود" : "افزودن سریع"}
        </button>
      </div>
    </article>
  );
}
