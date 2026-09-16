"use client";
import Link from "next/link";
import {
  ArrowLeft, Award, ShieldCheck, Leaf, Truck, HeartHandshake, Headphones, Gem, Quote, Sparkles,
} from "lucide-react";
import { TRAYS } from "@/data/trays";
import { BLOG_POSTS } from "@/data/content";
import { ProductCard } from "@/components/product/ProductCard";
import { TrayCard } from "@/components/mazeh/TrayCard";
import { Reveal, SectionHead, LinkButton } from "@/components/ui/primitives";
import { CouponBanner } from "@/components/ui/CouponBanner";
import type { Product } from "@/types";

/* ——— festival strip (quiet, editorial) ——— */
export function FestivalStrip() {
  return (
    <section className="border-b border-line/70 bg-surface2" aria-label="جشنواره هلسا">
      <div className="container-x flex flex-col md:flex-row items-start md:items-center justify-between gap-4 py-5">
        <div className="flex items-center gap-4">
          <svg viewBox="0 0 24 24" className="size-4 text-gold-500 fill-current shrink-0" aria-hidden>
            <path d="M12 2l2.4 6.2L21 9l-5 4.4 1.5 6.6L12 16.6 6.5 20 8 13.4 3 9l6.6-.8z" />
          </svg>
          <div>
            <p className="text-sm font-black text-heading">جشنواره هلسا</p>
            <p className="text-[11.5px] text-muted mt-0.5">تا ۲۰٪ تخفیف روی منتخب محصولات</p>
          </div>
        </div>
        <LinkButton href="/campaigns" variant="outline" size="sm">
          مشاهده جشنواره
          <ArrowLeft className="size-3.5" aria-hidden />
        </LinkButton>
      </div>
    </section>
  );
}

/* ——— categories: 8 quiet tiles ——— */
const CATEGORY_CARDS = [
  { name: "خرما", desc: "پیارم، مضافتی، مجول", href: "/products?cat=dates", image: "/images/opt/medjool-dates.jpg" },
  { name: "آجیل و مغزها", desc: "آجیل ممتاز و تک‌مغز", href: "/products?cat=nuts", image: "/images/opt/premium-mixed-nuts.jpg" },
  { name: "خشکبار", desc: "انجیر، توت، برگه", href: "/products?cat=dried-fruits", image: "/images/opt/dried-figs.jpg" },
  { name: "شکلات خرمایی", desc: "دست‌ساز کارگاه هلسا", href: "/products?cat=date-products", image: "/images/chocolate-craft.jpg" },
  { name: "قند خرما", desc: "شیرینی طبیعی خرما", href: "/products?q=قند خرما", image: "/images/opt/date-sugar.jpg" },
  { name: "عسل", desc: "طبیعی، با آنالیز", href: "/products?q=عسل", image: "/images/opt/natural-gon-honey.jpg" },
  { name: "زعفران", desc: "سرگل نگین قائنات", href: "/products?q=زعفران", image: "/images/opt/saffron-negin.jpg" },
  { name: "محصولات طبیعی", desc: "ارده، چای، دمنوش، ادویه", href: "/products?cat=natural", image: "/images/opt/lahijan-black-tea.jpg" },
];

export function CategoriesSection() {
  return (
    <section className="container-x py-20 md:py-28" aria-label="دسته‌بندی محصولات">
      <Reveal>
        <SectionHead eyebrow="ویترین هلسا" title="دسته‌بندی محصولات" desc="هر دسته، با وسواس انتخاب و با بسته‌بندی اختصاصی هلسا عرضه می‌شود." />
      </Reveal>
      <div className="grid grid-cols-2 md:grid-cols-4 gap-x-5 gap-y-10">
        {CATEGORY_CARDS.map((c, i) => (
          <Reveal key={c.name} delay={(i % 4) * 0.06}>
            <Link href={c.href} className="group block">
              <span className="block rounded-2xl overflow-hidden aspect-[4/5] bg-surface2 border border-line/60">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img src={c.image} alt={c.name} loading="lazy" className="size-full object-cover transition-transform duration-500 group-hover:scale-[1.04]" />
              </span>
              <span className="mt-4 block text-[15px] font-black text-heading group-hover:text-brand-600 transition-colors">{c.name}</span>
              <span className="mt-1 block text-xs text-muted">{c.desc}</span>
            </Link>
          </Reveal>
        ))}
      </div>
    </section>
  );
}

/* ——— featured ——— */
export function FeaturedProducts({ products }: { products: Product[] }) {
  const featured = products.filter((p) => p.badge).slice(0, 4);
  return (
    <section className="bg-surface2/70 border-y border-line/60 py-20 md:py-28" aria-label="منتخب هلسا">
      <div className="container-x">
        <Reveal>
          <SectionHead eyebrow="منتخب هلسا" title="محبوب‌ترین‌های این فصل" desc="چیزهایی که خودمان هم هر هفته به سفره‌مان می‌بریم." />
        </Reveal>
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 md:gap-6">
          {featured.map((p, i) => (
            <Reveal key={p.id} delay={(i % 4) * 0.06}>
              <ProductCard product={p} />
            </Reveal>
          ))}
        </div>
        <Reveal className="mt-12 text-center">
          <LinkButton href="/products" variant="outline">مشاهده همه محصولات</LinkButton>
        </Reveal>
      </div>
    </section>
  );
}

/* ——— signature: three editorial experiences ——— */
export function SignatureSection() {
  const items = [
    { title: "مزه هلسا", sub: "هر مزه، یک تجربه", href: "/mazeh", image: "/images/chocolate-craft.jpg" },
    { title: "سینی مزه هلسا", sub: "یک سینی، دنیایی از مزه‌ها", href: "/mazeh-trays", image: "/images/mazeh-board.jpg" },
    { title: "مهمانی هلسا", sub: "پذیرایی، به سبک ایرانی", href: "/mehmani", image: "/images/opt/golden.jpg" },
  ];
  return (
    <section className="container-x py-20 md:py-28" aria-label="امضای هلسا">
      <Reveal>
        <SectionHead eyebrow="امضای هلسا" title="سه تجربه، یک امضا" />
      </Reveal>
      <div className="grid md:grid-cols-3 gap-5 md:gap-6">
        {items.map((it, i) => (
          <Reveal key={it.title} delay={i * 0.08}>
            <Link href={it.href} className="group relative block rounded-2xl overflow-hidden aspect-[3/4]">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img src={it.image} alt={it.title} loading="lazy" className="absolute inset-0 size-full object-cover transition-transform duration-500 group-hover:scale-[1.04]" />
              <div className="absolute inset-0 bg-gradient-to-t from-brand-950/85 via-brand-950/20 to-transparent" aria-hidden />
              <div className="absolute inset-x-0 bottom-0 p-7">
                <p className="text-[11px] font-bold tracking-[0.2em] text-gold-300">{it.sub}</p>
                <h3 className="mt-2 text-2xl font-black text-inverse">{it.title}</h3>
                <span className="mt-4 inline-flex items-center gap-2 text-xs font-bold text-inverse/90">
                  کشف
                  <ArrowLeft className="size-3.5 transition-transform duration-300 group-hover:-translate-x-1" aria-hidden />
                </span>
              </div>
            </Link>
          </Reveal>
        ))}
      </div>
    </section>
  );
}

/* ——— mazeh trays teaser ——— */
export function MazehTeaser() {
  return (
    <section className="bg-surface2/70 border-y border-line/60 py-20 md:py-28" aria-label="سینی مزه هلسا">
      <div className="container-x grid lg:grid-cols-2 gap-12 lg:gap-20 items-center">
        <Reveal>
          <div className="rounded-2xl overflow-hidden border border-line/70 img-zoom">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src="/images/mazeh-board.jpg" alt="سینی مزه هلسا با پنیر، زیتون، خرما، شکلات و مغزها" loading="lazy" className="w-full object-cover aspect-[4/3]" />
          </div>
        </Reveal>
        <Reveal delay={0.1}>
          <span className="text-[11px] font-bold tracking-[0.2em] text-gold-600">سینی مزه هلسا</span>
          <h2 className="mt-4 text-3xl md:text-[40px] font-black leading-[1.4] text-heading">
            یک سینی،
            <br />
            دنیایی از مزه‌ها
          </h2>
          <p className="mt-6 text-sm md:text-[15px] leading-8 text-muted max-w-md">
            از پنیر و زیتون تا خرما و شکلات دست‌ساز؛ ترکیبی شور و شیرین برای لحظه‌هایی که قرار است به یاد بمانند. چیدمان روز، مواد تازه، و امضای بصری ایرانی-مدرن.
          </p>
          <div className="mt-8 flex flex-wrap gap-3">
            <LinkButton href="/mazeh-trays" variant="primary">مشاهده سینی‌ها</LinkButton>
            <LinkButton href="/mazeh-trays/build" variant="outline">سینی خودت را بساز</LinkButton>
          </div>
        </Reveal>
      </div>

      {/* trays — same visual system as product cards */}
      <div className="container-x mt-16">
        <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
          {TRAYS.slice(0, 3).map((t, i) => (
            <Reveal key={t.slug} delay={i * 0.08}>
              <TrayCard tray={t} />
            </Reveal>
          ))}
        </div>
        <div className="mt-10 text-center">
          <LinkButton href="/mazeh-trays" variant="outline">
            مشاهده همه سینی‌ها
            <ArrowLeft className="size-4" aria-hidden />
          </LinkButton>
        </div>
      </div>
    </section>
  );
}

/* ——— promo banners ——— */
export function PromoBanners() {
  return (
    <section className="container-x py-20 md:py-28 space-y-5" aria-label="پیشنهادهای تبلیغاتی">
      <div className="grid md:grid-cols-2 gap-5">
        <PromoCard href="/campaigns" title="جشنواره خرما" sub="طعم اصیل جنوب، در بسته‌بندی هلسا" cta="مشاهده خرماها" image="/images/opt/medjool-dates.jpg" />
        <PromoCard href="/products?cat=date-products" title="شکلات دست‌ساز خرمایی" sub="خرمای اصیل ایرانی، در روکش شکلات دست‌ساز" cta="خرید شکلات" image="/images/chocolate-craft.jpg" />
      </div>
      <CouponBanner />
    </section>
  );
}

function PromoCard({ title, sub, cta, image, href }: { title: string; sub: string; cta: string; image: string; href: string }) {
  return (
    <Link href={href} className="group relative block rounded-2xl overflow-hidden min-h-60 card-hover">
      {/* eslint-disable-next-line @next/next/no-img-element */}
      <img src={image} alt={title} loading="lazy" className="absolute inset-0 size-full object-cover transition-transform duration-500 group-hover:scale-[1.04]" />
      <div className="absolute inset-0 bg-gradient-to-l from-brand-950/85 via-brand-950/35 to-transparent" aria-hidden />
      <div className="relative h-full flex flex-col justify-end p-8">
        <h3 className="text-xl md:text-2xl font-black text-inverse">{title}</h3>
        <p className="mt-2 text-xs md:text-sm text-inverse/85">{sub}</p>
        <span className="mt-4 inline-flex items-center gap-2 text-xs font-bold text-gold-300">
          {cta}
          <ArrowLeft className="size-3.5 transition-transform duration-300 group-hover:-translate-x-1" aria-hidden />
        </span>
      </div>
    </Link>
  );
}

/* ——— story band ——— */
export function StoryBand() {
  return (
    <section className="bg-surface2/70 border-y border-line/60 py-20 md:py-28" aria-label="داستان هلسا">
      <div className="container-x grid lg:grid-cols-2 gap-12 lg:gap-20 items-center">
        <Reveal>
          <div className="rounded-2xl overflow-hidden border border-line/70 img-zoom">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src="/images/story-grove.jpg" alt="نخلستان خرما در نور طلوع" loading="lazy" className="w-full aspect-[4/3] object-cover" />
          </div>
        </Reveal>
        <Reveal delay={0.1}>
          <span className="text-[11px] font-bold tracking-[0.2em] text-gold-600">داستان هلسا</span>
          <h2 className="mt-4 text-3xl md:text-[40px] font-black leading-[1.4] text-heading">
            هلسا؛ پیوند طبیعت ایران
            <br />
            با هنر زندگی امروز
          </h2>
          <p className="mt-6 text-sm md:text-[15px] leading-8 text-muted max-w-md">
            هلسا ایرانیان با هدف ارائه محصولات باکیفیت، طبیعی و اصیل ایرانی شکل گرفته است؛ محصولاتی که ریشه در طبیعت و فرهنگ ایران دارند و با نگاهی مدرن انتخاب، آماده‌سازی و عرضه می‌شوند.
          </p>
          <div className="mt-8">
            <LinkButton href="/about" variant="outline">
              آشنایی با هلسا
              <ArrowLeft className="size-4" aria-hidden />
            </LinkButton>
          </div>
        </Reveal>
      </div>
    </section>
  );
}

/* ——— trust: hairline row, not cards ——— */
export function TrustSection() {
  const items = [
    { icon: Award, t: "انتخاب باکیفیت", d: "آزمون چشایی هر محموله" },
    { icon: Leaf, t: "محصولات طبیعی", d: "بدون افزودنی غیرضروری" },
    { icon: Gem, t: "بسته‌بندی شکیل", d: "در شأن هدیه و پذیرایی" },
    { icon: Headphones, t: "پشتیبانی", d: "پاسخ‌گو در ساعات کاری" },
    { icon: Truck, t: "ارسال مطمئن", d: "بسته‌بندی محافظ و زنجیره سرد" },
  ];
  return (
    <section className="container-x py-20 md:py-24" aria-label="چرا هلسا؟">
      <Reveal>
        <SectionHead eyebrow="چرا هلسا؟" title="دلایل ساده، برای اعتماد ساده" />
      </Reveal>
      <div className="grid grid-cols-2 md:grid-cols-5 gap-y-10 border-t border-line/70 pt-12">
        {items.map((it, i) => (
          <Reveal key={it.t} delay={i * 0.06}>
            <div className="text-center px-3">
              <span className="inline-flex size-11 rounded-full border border-brand-200 text-brand-700 items-center justify-center">
                <it.icon className="size-4.5" aria-hidden />
              </span>
              <h3 className="mt-4 text-[13px] font-black text-heading">{it.t}</h3>
              <p className="mt-1.5 text-[11px] text-muted leading-5">{it.d}</p>
            </div>
          </Reveal>
        ))}
      </div>
    </section>
  );
}

/* ——— testimonials ——— */
export function Testimonials() {
  const reviews = [
    { text: "کیفیت خرما و بسته‌بندی فراتر از انتظارم بود؛ حس یک برند اصیل ایرانی را منتقل می‌کند.", role: "تهران" },
    { text: "سینی مزه مهمانی برای دورهمی خانوادگی گرفتم؛ چیدمان و تازگی بی‌نقص بود.", role: "اصفهان" },
    { text: "شکلات دست‌ساز خرما طعمی دارد که تکرار می‌شود؛ واقعاً کار دست است.", role: "مشهد" },
  ];
  return (
    <section className="bg-brand-900 py-20 md:py-28 relative overflow-hidden" aria-label="اعتماد مشتریان">
      <div className="pattern-persian-light absolute inset-0 opacity-60" aria-hidden />
      <div className="relative container-x">
        <Reveal>
          <SectionHead light eyebrow="اعتماد مشتریان" title="صدای کسانی که هلسا را چشیده‌اند" />
        </Reveal>
        <div className="grid md:grid-cols-3 gap-5">
          {reviews.map((r, i) => (
            <Reveal key={i} delay={i * 0.08}>
              <figure className="rounded-2xl border border-cream-50/12 bg-surface/5 p-7 h-full flex flex-col">
                <Quote className="size-5 text-gold-400" aria-hidden />
                <blockquote className="mt-4 text-sm leading-8 text-inverse flex-1">{r.text}</blockquote>
                <figcaption className="mt-5 pt-4 border-t border-cream-50/10 text-[11px] text-inverse/70">
                  مشتری هلسا — {r.role}
                </figcaption>
              </figure>
            </Reveal>
          ))}
        </div>
      </div>
    </section>
  );
}

/* ——— blog teaser ——— */
export function BlogTeaser() {
  return (
    <section className="container-x py-20 md:py-28" aria-label="مجله هلسا">
      <Reveal>
        <SectionHead eyebrow="مجله هلسا" title="دانستنی‌های طعم و سلامت" />
      </Reveal>
      <div className="grid md:grid-cols-3 gap-5">
        {BLOG_POSTS.slice(0, 3).map((b, i) => (
          <Reveal key={b.slug} delay={i * 0.08}>
            <Link href={`/blog/${b.slug}`} className="group block rounded-2xl overflow-hidden bg-surface border border-line/70 card-hover">
              <div className="aspect-[16/9] overflow-hidden">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img src={b.image} alt={b.title} loading="lazy" className="size-full object-cover transition-transform duration-500 group-hover:scale-[1.04]" />
              </div>
              <div className="p-6">
                <span className="text-[11px] font-bold text-gold-600">{b.category}</span>
                <h3 className="mt-2 text-sm font-extrabold leading-7 text-heading line-clamp-2-fa group-hover:text-brand-600 transition-colors">{b.title}</h3>
              </div>
            </Link>
          </Reveal>
        ))}
      </div>
    </section>
  );
}

/* ——— final CTA ——— */
export function FinalCTA() {
  return (
    <section className="border-t border-line/60 bg-surface2" aria-label="انتخاب از هلسا">
      <div className="container-x py-20 md:py-24 grid lg:grid-cols-2 gap-10 items-center">
        <Reveal>
          <span className="inline-flex items-center gap-2 text-[11px] font-bold tracking-[0.2em] text-gold-600">
            <Sparkles className="size-3.5" aria-hidden />
            شروع سفر طعم
          </span>
          <h2 className="mt-4 text-3xl md:text-[40px] font-black leading-[1.4] text-heading">
            انتخاب خود را
            <br />
            از هلسا آغاز کنید
          </h2>
          <div className="mt-8 flex flex-wrap gap-3">
            <LinkButton href="/products" variant="primary" size="lg">مشاهده محصولات</LinkButton>
            <LinkButton href="/mazeh-trays/build" variant="outline" size="lg">ساخت سینی شخصی</LinkButton>
          </div>
        </Reveal>
        <Reveal delay={0.1}>
          <div className="rounded-2xl overflow-hidden border border-line/70 img-zoom">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src="/images/chocolate-craft.jpg" alt="شکلات دست‌ساز خرما هلسا" loading="lazy" className="w-full aspect-[16/10] object-cover" />
          </div>
        </Reveal>
      </div>
    </section>
  );
}
