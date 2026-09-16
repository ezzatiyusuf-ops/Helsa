"use client";
import { useState } from "react";
import { Price } from "@/components/ui/primitives";
import Link from "next/link";
import { Plus, ShoppingBag } from "lucide-react";
import { useStore } from "@/lib/store";
import { useToast } from "@/components/ui/Toast";
import { faDigits, formatToman, formatPriceShort } from "@/lib/format";
import type { MazehTray } from "@/types";
import { trayVisual } from "@/lib/trayVisuals";

/**
 * کارت سینی مزه طلایی برای نوار پیشنهاد ویژه — قیمت واقعی از دیتابیس
 * (basePrice/oldPrice) + Quick Add با همان الگوی TrayDetailClient.
 */
export function GoldenTrayCard({ tray }: { tray: MazehTray }) {
  const addItem = useStore((s) => s.addItem);
  const toast = useToast();
  const [added, setAdded] = useState(false);
  const image = trayVisual(tray.slug, tray.image);
  const discount = tray.oldPrice && tray.oldPrice > tray.basePrice
    ? Math.round((1 - tray.basePrice / tray.oldPrice) * 100)
    : 0;

  const quickAdd = () => {
    addItem(
      {
        key: `t-${tray.id}`,
        kind: "tray",
        id: tray.id,
        name: tray.name,
        slug: tray.slug,
        image,
        price: tray.basePrice,
        meta: `برای ${faDigits(tray.servesMin)} تا ${faDigits(tray.servesMax)} نفر`,
      },
      1,
    );
    toast.push("سینی مزه طلایی به سبد خرید اضافه شد");
    setAdded(true);
    window.setTimeout(() => setAdded(false), 1600);
  };

  return (
    <article className="flex h-full flex-col overflow-hidden rounded-2xl border border-gold-300/70 bg-surface shadow-soft transition-shadow hover:shadow-lift">
      <Link href={`/mazeh-trays/${tray.slug}`} className="relative block aspect-[4/5] overflow-hidden img-zoom" aria-label={tray.name}>
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img src={image} alt={tray.name} loading="lazy" decoding="async" className="size-full object-cover" />
        {discount > 0 && (
          <span className="absolute top-3 start-3 rounded-full bg-accent-600 px-2.5 py-1 text-[10.5px] font-black text-inverse">
            {faDigits(discount)}٪ تخفیف
          </span>
        )}
        <span className="absolute bottom-3 start-3 rounded-full border border-white/30 bg-ink-950/40 px-2.5 py-1 text-[10px] font-bold text-white backdrop-blur-md">
          برای {faDigits(tray.servesMin)} تا {faDigits(tray.servesMax)} نفر
        </span>
      </Link>
      <div className="flex flex-1 flex-col p-4">
        <Link href={`/mazeh-trays/${tray.slug}`} className="text-[13.5px] font-extrabold leading-6 text-heading hover:text-brand-700">{tray.name}</Link>
        <div className="mt-1.5">
          <Price price={tray.basePrice} oldPrice={tray.oldPrice} />
        </div>
        <p className="mt-1.5 pb-3 flex items-center gap-1.5 text-[11px] font-bold text-muted">
          <span className="size-1.5 rounded-full bg-brand-500" aria-hidden />
          آمادهٔ ساخت و ارسال
        </p>
        <button
          type="button"
          onClick={quickAdd}
          className="mt-auto inline-flex h-11 items-center justify-center gap-1.5 self-stretch rounded-full bg-brand-700 text-[11.5px] font-bold text-inverse transition-colors hover:bg-brand-800"
        >
          {added ? <ShoppingBag className="size-4" aria-hidden /> : <Plus className="size-4" aria-hidden />}
          {added ? "به سبد اضافه شد" : "افزودن سریع"}
        </button>
      </div>
    </article>
  );
}
