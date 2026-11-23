#!/usr/bin/env bash
# بازسازی سریع پیش‌نمایش HELSA بعد از ریست سندباکس
# استفاده:  bash /home/user/restore-helsa-preview.sh [PORT]
set -uo pipefail
PORT="${1:-3101}"
ROOT=/home/user/helsa
PATCH=/home/user/helsa-upsell-to-main.patch
PHOTOS=/home/user/helsa-photo-edits
cd "$ROOT" || exit 1

echo "▸ ۱/۶ نصب وابستگی‌ها (اگر لازم باشد)…"
if [ ! -d node_modules ]; then npm ci --no-audit --no-fund >/tmp/npmci.log 2>&1; echo "   npm ci exit=$?"; else echo "   node_modules موجود است"; fi

echo "▸ ۲/۶ بازگرداندن ۵ فایل پایه از origin/main…"
for f in src/components/layout/Shell.tsx src/components/product/ProductCard.tsx \
         src/components/product/ProductDetailClient.tsx src/data/products.ts package.json; do
  mkdir -p "$(dirname "$f")"
  curl -sL "https://raw.githubusercontent.com/ezzatiyusuf-ops/Helsa-web/main/$f" -o "$f"
done

echo "▸ ۳/۶ اعمال پچ قابلیت پیشنهاد سبد…"
rm -f src/lib/upsell.ts src/lib/upsell-store.ts src/data/product-relations.ts \
      src/app/api/products/upsell/route.ts src/components/cart/useAddWithUpsell.ts \
      src/components/cart/CartUpsellDrawer.tsx tests/upsell.test.ts \
      scripts/qa-upsell-e2e.mjs scripts/fix-catalog-consistency.sql
patch -p1 --batch --forward -i "$PATCH" 2>&1 | grep -vE "^patching file|Hunk|^$" | head -5

echo "▸ ۴/۶ بازگرداندن فایل‌های کتابخانه‌ای بیلد (۱۰ فایل)…"
for f in order-dto order-access card receipt-file health-sanitize card-payment metadata producer; do
  curl -sL "https://raw.githubusercontent.com/ezzatiyusuf-ops/Helsa-web/main/src/lib/$f.ts" -o "src/lib/$f.ts"
done
for f in card-transfer support; do
  curl -sL "https://raw.githubusercontent.com/ezzatiyusuf-ops/Helsa-web/main/src/config/$f.ts" -o "src/config/$f.ts"
done

echo "▸ ۵/۶ عکس‌های واقعی + پچ صفحه‌های درباره ما و تماس با ما…"
mkdir -p public/images/editorial
cp "$PHOTOS/hero-banner-v1/hero-mazafati.jpg"   public/images/editorial/about-origin.jpg
cp "$PHOTOS/final-v2/07-2.jpg"                  public/images/editorial/about-nature.jpg
cp "$PHOTOS/final-v2/06-1.jpg"                  public/images/editorial/about-sourcing.jpg
cp "$PHOTOS/final-v2/09-4.jpg"                  public/images/editorial/about-quality.jpg
cp "$PHOTOS/final-v2/10-7.jpg"                  public/images/editorial/about-packaging.jpg
cp "$PHOTOS/final-v2/14-tg2.jpg"                public/images/editorial/about-hospitality.jpg
cp "$PHOTOS/hero-banner-v1/hero-mazeh-tray.jpg" public/images/editorial/contact-welcome.jpg
python3 - <<'PY'
p='src/app/about/page.tsx'; s=open(p,encoding='utf-8').read()
repl=[('    image: "/images/story-grove.jpg",\n  },','    image: "/images/editorial/about-origin.jpg",\n    alt: "خرماهای تازه در کاسهٔ سفالی — عکس واقعی از محصولات هلسا",\n  },'),
('    image: "/images/opt/piaram-dates.jpg",\n  },','    image: "/images/editorial/about-nature.jpg",\n    alt: "کاسهٔ مغز گردو و گردوی کامل — عکس واقعی از محصولات هلسا",\n  },'),
('    image: "/images/opt/sourcing-groves.jpg",\n  },','    image: "/images/editorial/about-sourcing.jpg",\n    alt: "مرتبان پسته با برچسب هلسا — عکس واقعی از محصولات هلسا",\n  },'),
('    image: "/images/opt/mazafati-dates.jpg",\n  },','    image: "/images/editorial/about-quality.jpg",\n    alt: "کاسهٔ فلزی پر از مغز گردوی تازه — عکس واقعی از محصولات هلسا",\n  },'),
('    image: "/images/chocolate-craft.jpg",\n  },','    image: "/images/editorial/about-packaging.jpg",\n    alt: "مرتبان شیشه‌ای با برچسب هلسا — عکس واقعی از محصولات هلسا",\n  },'),
('    image: "/images/mazeh-board.jpg",\n  },','    image: "/images/editorial/about-hospitality.jpg",\n    alt: "سینی چوبی چای هلسا با استکان و قوری — عکس واقعی از محصولات هلسا",\n  },')]
for a,b in repl:
    if a in s: s=s.replace(a,b,1)
s=s.replace('<SmartImage src={c.image} alt={c.title} sizes="(min-width:1024px) 33vw, 100vw" className="w-full aspect-[4/3] object-cover" />',
            '<SmartImage src={c.image} alt={c.alt} sizes="(min-width:1024px) 46vw, 100vw" className="w-full aspect-[4/3] object-cover" />',1)
if 'const CHAPTERS: Array<' not in s:
    s=s.replace('const CHAPTERS = [','const CHAPTERS: Array<{ icon: typeof Mountain; title: string; text: string; image: string; alt: string }> = [',1)
open(p,'w',encoding='utf-8').write(s)
print("   about editorial refs:", s.count("/images/editorial/"))

p='src/app/contact/ContactClient.tsx'; s=open(p,encoding='utf-8').read()
if 'contact-welcome.jpg' not in s:
    if 'SmartImage' not in s:
        s=s.replace('import { Reveal, SectionHead } from "@/components/ui/primitives";',
                    'import { Reveal, SectionHead } from "@/components/ui/primitives";\nimport { SmartImage } from "@/components/ui/SmartImage";',1)
    band='''      {/* نوار عکس واقعی — از عکس‌های ادیت‌شدهٔ خود هلسا */}
      <section className="container-x pt-10 md:pt-14" aria-label="سفرهٔ هلسا">
        <Reveal>
          <figure className="overflow-hidden rounded-[1.75rem] border border-line/70 bg-surface2">
            <SmartImage src="/images/editorial/contact-welcome.jpg"
              alt="سینی چوبی چیدمان هلسا با کاسه‌های آجیل، خرما و شکلات — عکس واقعی از محصولات هلسا"
              sizes="(min-width:1024px) 1100px, 100vw"
              className="h-[220px] w-full object-cover sm:h-[300px] lg:h-[360px]" priority />
            <figcaption className="flex flex-wrap items-center justify-between gap-2 border-t border-line/70 bg-surface px-5 py-3">
              <span className="text-[12px] font-bold text-body">از چیدمان‌های هلسا</span>
              <span className="text-[11px] text-muted">عکس واقعی از محصولات هلسا</span>
            </figcaption>
          </figure>
        </Reveal>
      </section>

      {/* contact cards */}'''
    s=s.replace('      {/* contact cards */}', band, 1)
open(p,'w',encoding='utf-8').write(s)
print("   contact band:", s.count("contact-welcome.jpg"))

p='next.config.ts'; s=open(p,encoding='utf-8').read()
if '"localhost"' not in s:
    s=s.replace('allowedDevOrigins: ["*.e2b.app"],','allowedDevOrigins: ["*.e2b.app", "localhost", "127.0.0.1"],',1)
    open(p,'w',encoding='utf-8').write(s)
print("   allowedDevOrigins ok:", '"localhost"' in s)
PY

echo "▸ ۵.۵/۶ پچ CSRF پیش‌نمایش (security.ts)…"
python3 scripts/patch-csrf-preview.py

echo "▸ ۶/۶ اجرای سرور روی پورت $PORT…"
pkill -f "next dev.*-p $PORT" 2>/dev/null; sleep 1
rm -rf .next
nohup npx next dev -H 0.0.0.0 -p "$PORT" > "/tmp/helsa-dev-$PORT.log" 2>&1 &
for i in $(seq 1 40); do
  sleep 1
  code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 5 "http://localhost:$PORT/" 2>/dev/null)
  if [ "$code" = "200" ]; then echo "   ✓ سرور آماده است: http://localhost:$PORT  (اولین رندر ${i}s)"; break; fi
done
echo "--- وضعیت مسیرها ---"
for u in / /products /about /contact /cart; do
  printf "  %-10s %s\n" "$u" "$(curl -s -o /dev/null -w '%{http_code}' --max-time 60 http://localhost:$PORT$u)"
done
