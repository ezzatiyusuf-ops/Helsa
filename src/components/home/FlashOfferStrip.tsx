import { Sparkles } from "lucide-react";
import type { Product } from "@/types";
import { getTrays } from "@/services/catalog";
import { getGiftPackages } from "@/services/gifts";
import { ProductCard } from "@/components/product/ProductCard";
import { GoldenTrayCard } from "@/components/home/GoldenTrayCard";
import { GiftBoxCard } from "@/components/home/GiftBoxCard";
import { CarouselRow } from "@/components/ui/CarouselRow";
import { Countdown, Reveal, SectionHead } from "@/components/ui/primitives";

/**
 * نوار پیشنهاد ویژه (CRO) — چهار محصول هیروی هلسا با قیمت واقعی:
 * شکلات خرمایی · قند خرما · سینی مزه طلایی (mazeh_trays) · جعبهٔ هدیه (gift_packages).
 * تخفیف/قیمت قدیمی فقط جایی نمایش داده می‌شود که در دادهٔ واقعی وجود دارد.
 * شمارش معکوس تا پایان واقعی کمپین فعال (id 7 — 2026-12-30).
 */
const CAMPAIGN_END = "2026-12-30T23:59:59";
const DEAL_SLUGS = ["date-sugar", "handmade-date-chocolate"];
const GIFT_SLUG = "classic-personal-gift";

export async function FlashOfferStrip({ products }: { products: Product[] }) {
  const trays = await getTrays();
  const golden = trays.find((t) => t.slug === "golden" && t.active);
  const gift = (await getGiftPackages()).find((g) => g.slug === GIFT_SLUG && g.stock > 0);
  const deals = DEAL_SLUGS.map((slug) => products.find((p) => p.slug === slug)).filter(
    (p): p is Product => Boolean(p),
  );
  if (deals.length < 2) return null;

  return (
    <section className="border-y border-gold-300/60 bg-gradient-to-l from-gold-50 via-surface to-surface py-10 md:py-12" aria-label="پیشنهاد ویژه امروز">
      <div className="container-x">
        <Reveal>
          <div className="flex flex-wrap items-end justify-between gap-4">
            <SectionHead
              eyebrow="جشنوارهٔ هدیهٔ هلسا"
              title="پیشنهاد ویژه امروز"
              desc="چهار انتخاب ممتاز با قیمت واقعی — تا پایان جشنواره:"
            />
            <div className="shrink-0 pb-1" aria-label="شمارش معکوس پایان جشنواره">
              <Countdown until={CAMPAIGN_END} />
            </div>
          </div>
        </Reveal>
        <CarouselRow ariaLabel="پیشنهاد ویژه امروز — نوار کشویی" className="mt-7">
          {deals.map((p, i) => (
            <div key={p.slug} className="w-[62vw] min-[400px]:w-[54vw] sm:w-[252px] lg:w-[232px] shrink-0 snap-start">
              <ProductCard product={p} />
            </div>
          ))}
          {golden && (
            <div className="w-[62vw] min-[400px]:w-[54vw] sm:w-[252px] lg:w-[232px] shrink-0 snap-start">
              <GoldenTrayCard tray={golden} />
            </div>
          )}
          {gift && (
            <div className="w-[62vw] min-[400px]:w-[54vw] sm:w-[252px] lg:w-[232px] shrink-0 snap-start">
              <GiftBoxCard gift={gift} />
            </div>
          )}
        </CarouselRow>
        <Reveal delay={100}>
          <p className="mt-5 flex items-center justify-center gap-1.5 text-[11px] font-bold text-muted">
            <Sparkles className="size-3.5 text-gold-600" aria-hidden />
            تخفیف‌ها روی قیمت واقعی محصولات اعمال شده‌اند — سبد خرید، قیمت نهایی را نشان می‌دهد.
          </p>
        </Reveal>
      </div>
    </section>
  );
}
