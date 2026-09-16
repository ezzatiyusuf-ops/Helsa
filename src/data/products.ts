import type { Product } from "@/types";

const IMG = {
  dates: [
    "/images/opt/medjool-dates-3.jpg",
    "/images/opt/mazafati-dates.jpg",
    "/images/opt/kabkab-dates.jpg",
    "/images/opt/medjool-dates.jpg",
    "/images/opt/mazafati-dates-2.jpg",
    "/images/opt/medjool-dates-2.jpg",
    "/images/opt/piaram-dates.jpg",
    "/images/opt/khasoei-dates.jpg",
  ],
  choc: [
    "/images/opt/handmade-date-chocolate.jpg",
    "/images/opt/date-chocolate-walnut.jpg",
    "/images/opt/chocolate-coated-dates.jpg",
    "/images/opt/date-powder.jpg",
    "/images/opt/handmade-date-chocolate-2.jpg",
    "/images/opt/date-sugar.jpg",
  ],
  nuts: [
    "/images/opt/premium-mixed-nuts.jpg",
    "/images/opt/party-nuts.jpg",
    "/images/opt/special-yalda-nuts.jpg",
    "/images/opt/four-nut-mix.jpg",
    "/images/opt/akbari-pistachios.jpg",
    "/images/opt/tree-almonds.jpg",
    "/images/opt/economic-nuts.jpg",
  ],
  dried: [
    "/images/opt/dried-figs.jpg",
    "/images/opt/dried-mulberries.jpg",
    "/images/opt/dried-fruit-mix.jpg",
    "/images/opt/golden-raisins.jpg",
    "/images/opt/dried-apricots.jpg",
    "/images/opt/dried-plums.jpg",
  ],
  natural: [
    "/images/opt/natural-gon-honey.jpg",
    "/images/opt/saffron-negin.jpg",
    "/images/opt/lahijan-black-tea.jpg",
    "/images/opt/sesame-tahini.jpg",
    "/images/opt/natural-gon-honey-2.jpg",
    "/images/opt/bidmeshk-distillate.jpg",
    "/images/opt/herbal-tea-borage.jpg",
  ],
};

let seq = 0;
interface Seed {
  name: string;
  slug: string;
  category: string;
  price: number;
  oldPrice?: number;
  weight: string;
  image: string;
  gallery?: string[];
  desc: string;
  rating?: number;
  reviews?: number;
  stock?: number;
  badge?: string;
  tags?: string[];
  origin: string;
  packaging: string;
  storage: string;
  allergens?: string[];
  nutrition?: [string, string][];
  created?: string;
}

function p(s: Seed): Product {
  seq += 1;
  const discount = s.oldPrice ? Math.round(((s.oldPrice - s.price) / s.oldPrice) * 100) : 0;
  return {
    id: seq,
    name: s.name,
    slug: s.slug,
    category: s.category,
    sku: `HLA-${String(seq).padStart(4, "0")}`,
    price: s.price,
    oldPrice: s.oldPrice ?? null,
    discount,
    weight: s.weight,
    image: s.image,
    gallery: s.gallery ?? [s.image],
    description: s.desc,
    rating: s.rating ?? 4.7,
    reviews: s.reviews ?? 48,
    stock: s.stock ?? 24,
    badge: s.badge ?? null,
    tags: s.tags ?? [],
    features: [
      { label: "وزن", value: s.weight },
      { label: "مواد اولیه", value: s.tags?.[0] ?? "طبیعی و منتخب" },
      { label: "محل تولید", value: s.origin },
      { label: "نوع بسته‌بندی", value: s.packaging },
      { label: "شرایط نگهداری", value: s.storage },
      { label: "تاریخ تولید", value: "۱۴۰۴/۰۷/۰۱" },
      { label: "تاریخ انقضا", value: "۱۴۰۵/۰۷/۰۱" },
    ],
    nutrition: (s.nutrition ?? [
      ["انرژی", "۲۸ کیلوکالری"],
      ["پروتئین", "۲.۵ گرم"],
      ["کربوهیدرات", "۷۵ گرم"],
      ["چربی", "۰.۴ گرم"],
    ]).map(([label, value]) => ({ label, value })),
    storage: s.storage,
    allergens: s.allergens ?? [],
    createdAt: s.created ?? "2025-03-01",
  };
}

export const PRODUCTS: Product[] = [
  // ————— خرما —————
  p({ name: "خرما پیارم هلسا", slug: "piaram-dates", category: "dates", price: 485000, oldPrice: 560000, weight: "۱ کیلوگرم", image: IMG.dates[0], gallery: [IMG.dates[0], IMG.dates[3], IMG.dates[6]], desc: "خرما پیارم هرمزگان؛ کشیده، خوش‌بافت و با شیرینی متعادل. منتخب درشت‌ترین خوشه‌های جهرم و حاجی‌آباد، با بسته‌بندی اختصاصی هلسا که عطر و بافت خرما را تا لحظه پذیرایی حفظ می‌کند.", badge: "پرفروش", rating: 4.9, reviews: 214, tags: ["خرما پیارم", "خرمای لوکس"], origin: "هرمزگان، حاجی‌آباد", packaging: "جعبه مقوایی لوکس با ظرف داخلی", storage: "دمای خنک (۴ تا ۱۰ درجه)", allergens: [], created: "2025-06-10" }),
  p({ name: "خرما مضافتی بم", slug: "mazafati-dates", category: "dates", price: 320000, oldPrice: 380000, weight: "۱ کیلوگرم", image: IMG.dates[1], gallery: [IMG.dates[1], IMG.dates[4]], desc: "خرما مضافتی بم با پوستی نازک و گوشتی نرم و شهدی؛ انتخاب اول سفره‌های افطار و پذیرایی روزمره با طعم اصیل کرمان.", badge: "محبوب", rating: 4.8, reviews: 186, tags: ["خرما مضافتی"], origin: "کرمان، بم", packaging: "بسته زیپ‌کیپ تازه‌ماندگار", storage: "یخچال (۰ تا ۵ درجه)", created: "2025-05-02" }),
  p({ name: "خرما کبکاب", slug: "kabkab-dates", category: "dates", price: 265000, weight: "۱ کیلوگرم", image: IMG.dates[2], desc: "خرما کبکاب بوشهر با شیرینی عمیق و بافت گوشتی؛ مناسب شیرینی‌پزی، شیره‌گیری و پذیرایی سنتی.", rating: 4.6, reviews: 92, tags: ["خرما کبکاب"], origin: "بوشهر، برازجان", packaging: "کارتن بهداشتی وکیوم", storage: "مكان خنک و خشک" }),
  p({ name: "خرما زاهدی", slug: "zahedi-dates", category: "dates", price: 210000, oldPrice: 245000, weight: "۱ کیلوگرم", image: IMG.dates[4], desc: "خرما زاهدی (قصب) با ماندگاری بالا و شیرینی ملایم؛ خرما خشک محبوب ورزشکاران و میان‌وعده‌های سالم.", badge: "تخفیف", rating: 4.5, reviews: 77, tags: ["خرما زاهدی"], origin: "خوزستان", packaging: "بسته کرافت زیپ‌دار", storage: "دمای محیط، دور از رطوبت" }),
  p({ name: "خرما خاصویی", slug: "khasoei-dates", category: "dates", price: 240000, weight: "۱ کیلوگرم", image: IMG.dates[7], desc: "خرما خاصویی فارس؛ ریزتر، پرانرژی و سرشار از فیبر؛ انتخابی اقتصادی برای قنادی و مصرف روزانه.", rating: 4.4, reviews: 51, tags: ["خرما خاصویی"], origin: "فارس، جهرم", packaging: "بسته وکیوم", storage: "دمای خنک" }),
  p({ name: "خرما مجول سلطنتی", slug: "medjool-dates", category: "dates", price: 780000, oldPrice: 890000, weight: "۷۰۰ گرم", image: IMG.dates[5], gallery: [IMG.dates[5], IMG.dates[0]], desc: "خرما مجول؛ درشت‌ترین و لوکس‌ترین خرمای جهان با بافت کاراملی. نسخه سلطنتی هلسا با سایز سوپرژامبو و جعبه هدیه مخمل.", badge: "ویژه", rating: 5, reviews: 143, stock: 12, tags: ["خرما مجول", "هدیه"], origin: "وارداتی درجه یک / کشت ایران", packaging: "جعبه هدیه مخمل با مدالیون هلسا", storage: "یخچال", created: "2025-08-15" }),
  // ————— فرآورده‌های خرما —————
  p({ name: "شکلات دست‌ساز خرما", slug: "handmade-date-chocolate", category: "date-products", price: 395000, oldPrice: 460000, weight: "۳۵۰ گرم (۱۴ عدد)", image: IMG.choc[0], gallery: [IMG.choc[0], IMG.choc[2], IMG.choc[4]], desc: "خرمای پیارم بدون هسته، غرق در شکلات تلخ ۷۰٪ دست‌ساز با پاشش پسته و گلبرگ خشک. بدون شکر افزوده؛ شیرینی فقط از خرما.", badge: "ویژه", rating: 4.9, reviews: 168, stock: 18, tags: ["شکلات خرما", "دست‌ساز", "بدون شکر افزوده"], origin: "کارگاه هلسا، تهران", packaging: "جعبه مقوایی سخت با جداکننده داخلی", storage: "دمای ۱۸ تا ۲۲ درجه", allergens: ["مغزها", "لبنیات", "سویا"], nutrition: [["انرژی", "۵۲۰ کیلوکالری"], ["پروتئین", "۶ گرم"], ["کربوهیدرات", "۴۸ گرم"], ["چربی", "۳۲ گرم"]], created: "2025-07-20" }),
  p({ name: "شکلات خرما با مغز گردو", slug: "date-chocolate-walnut", category: "date-products", price: 420000, weight: "۳۵۰ گرم", image: IMG.choc[1], desc: "لایه‌های خرما، گردوی تازه و شکلات شیری؛ ترکیبی که با چای عصرانه ایرانی کامل می‌شود.", badge: "جدید", rating: 4.8, reviews: 64, tags: ["شکلات خرما", "گردو"], origin: "کارگاه هلسا", packaging: "جعبه هدیه", storage: "دمای خنک", allergens: ["مغزها", "لبنیات"], created: "2025-09-01" }),
  p({ name: "قند خرما هلسا", slug: "date-sugar", category: "date-products", price: 185000, weight: "۵۰۰ گرم", image: IMG.choc[5], desc: "قند خرما؛ جایگزین طبیعی شکر با نمایه گلیسمی پایین. آسیاب‌شده از خرمای زاهدی خشک، بدون هیچ افزودنی.", badge: "محبوب", rating: 4.7, reviews: 121, tags: ["قند خرما", "بدون شکر"], origin: "خوزستان", packaging: "بسته کرافت پنجره‌دار", storage: "دمای محیط، درب بسته" }),
  p({ name: "شیره خرما غلیظ", slug: "date-syrup", category: "date-products", price: 230000, oldPrice: 265000, weight: "۷۰ گرم", image: IMG.natural[4], desc: "شیره خرما با غلظت طبیعی و طعم کاراملی؛ حاصل پخت آرام خرمای کبکاب. مناسب صبحانه، معجون و دسر.", rating: 4.6, reviews: 88, tags: ["شیره خرما"], origin: "بوشهر", packaging: "شیشه دهان‌گشاد درب فلزی", storage: "پس از باز شدن در یخچال" }),
  p({ name: "پودر خرما طبیعی", slug: "date-powder", category: "date-products", price: 165000, weight: "۴۰ گرم", image: IMG.choc[3], desc: "پودر خرما برای اسموتی، اوورنایت و پخت؛ شیرینی طبیعی با فیبر بالا بدون افزودنی.", rating: 4.5, reviews: 43, tags: ["پودر خرما"], origin: "خرما زاهدی", packaging: "بسته زیپ‌کیپ", storage: "مكان خشک" }),
  p({ name: "خرما شکلات‌پوش پسته‌ای", slug: "chocolate-coated-dates", category: "date-products", price: 445000, oldPrice: 520000, weight: "۴۰۰ گرم", image: IMG.choc[2], desc: "خرمای مضافتی بدون هسته با روکش شکلات بلژیکی و خرده پسته اکبری؛ هدیه‌ای که همیشه به یاد می‌ماند.", badge: "تخفیف", rating: 4.8, reviews: 97, tags: ["شکلات خرما", "هدیه"], origin: "کارگاه هلسا", packaging: "جعبه هدیه طلایی", storage: "دمای ۱۸ تا ۲۲", allergens: ["مغزها", "لبنیات"] }),
  // ————— آجیل —————
  p({ name: "آجیل ممتاز شب‌چره", slug: "premium-mixed-nuts", category: "nuts", price: 890000, oldPrice: 1020000, weight: "۱ کیلوگرم", image: IMG.nuts[0], gallery: [IMG.nuts[0], IMG.nuts[1], IMG.nuts[3]], desc: "ترکیب ممتاز پسته اکبری، بادام هندی، فندق، مغز گردو و بادام درختی؛ بو داده با حرارت ملایم و نمک دریا.", badge: "پرفروش", rating: 4.9, reviews: 232, tags: ["آجیل ممتاز", "شب‌چره"], origin: "کرمان و قزوین", packaging: "بسته متالایز تازه‌ماندگار", storage: "مكان خنک و خشک", allergens: ["مغزها"], created: "2025-04-12" }),
  p({ name: "آجیل چهارمغز", slug: "four-nut-mix", category: "nuts", price: 760000, weight: "۱ کیلوگرم", image: IMG.nuts[3], desc: "چهارمغز خالص: پسته، بادام، فندق و گردو بدون هیچ افزودنی؛ بمب امگا۳ برای صبحانه و دسر.", rating: 4.8, reviews: 118, tags: ["چهارمغز"], origin: "ایران", packaging: "بسته وکیوم", storage: "یخچال برای ماندگاری بیشتر", allergens: ["مغزها"] }),
  p({ name: "آجیل پذیرایی مجلسی", slug: "party-nuts", category: "nuts", price: 980000, oldPrice: 1150000, weight: "۱ کیلوگرم", image: IMG.nuts[1], desc: "آجیل پذیرایی با پسته اکبری خندان، بادام هندی درشت و مغز گردوی سفید؛ انتخاب مجلس‌های رسمی و عیدانه.", badge: "ویژه", rating: 4.9, reviews: 154, tags: ["آجیل پذیرایی"], origin: "کرمان", packaging: "جعبه لوکس پذیرایی", storage: "مكان خنک", allergens: ["مغزها"] }),
  p({ name: "آجیل اقتصادی روزانه", slug: "economic-nuts", category: "nuts", price: 520000, weight: "۱ کیلوگرم", image: IMG.nuts[6], desc: "ترکیبی متعادل و مقرون‌به‌صرفه از نخودچی، کشمش، بادام و فندق برای مصرف روزانه خانواده.", badge: "تخفیف", rating: 4.4, reviews: 66, tags: ["آجیل اقتصادی"], origin: "ایران", packaging: "بسته زیپ‌کیپ", storage: "دمای محیط", allergens: ["مغزها"] }),
  p({ name: "آجیل ویژه یلدایی هلسا", slug: "special-yalda-nuts", category: "nuts", price: 1250000, oldPrice: 1450000, weight: "۱.۵ کیلوگرم", image: IMG.nuts[2], desc: "نسخه محدود یلدایی: پسته اکبری، فندق کامل، بادام هندی طلایی و مغز پسته با جعبه چوبی هلسا.", badge: "محدود", rating: 5, reviews: 89, stock: 8, tags: ["یلدا", "آجیل ویژه"], origin: "کرمان", packaging: "جعبه چوبی با مدالیون طلاکوب", storage: "مكان خنک", allergens: ["مغزها"], created: "2025-10-01" }),
  p({ name: "پسته اکبری درشت", slug: "akbari-pistachios", category: "nuts", price: 1180000, weight: "۵۰۰ گرم", image: IMG.nuts[4], desc: "پسته اکبری سوپر درشت رفسنجان، خندان و شورِ ملایم؛ لوکس‌ترین مغز ایران.", badge: "محبوب", rating: 4.9, reviews: 176, tags: ["پسته"], origin: "رفسنجان", packaging: "بسته متالایز", storage: "مكان خنک", allergens: ["مغزها"] }),
  p({ name: "بادام درختی سنگی", slug: "tree-almonds", category: "nuts", price: 465000, weight: "۵۰ گرم", image: IMG.nuts[5], desc: "بادام درختی سنگی سبزستان با مغز پر و طعم شیرین طبیعی؛ خام و بدون بو دادگی.", rating: 4.6, reviews: 71, tags: ["بادام"], origin: "سبزوار", packaging: "بسته کرافت", storage: "مكان خشک", allergens: ["مغزها"] }),
  p({ name: "مغز گردوی چهارپره", slug: "walnut-kernels", category: "nuts", price: 620000, oldPrice: 690000, weight: "۵۰ گرم", image: IMG.nuts[2], desc: "مغز گردوی سفید چهارپره تویسرکان؛ تازه، بدون تلخی و سرشار از امگا۳.", rating: 4.7, reviews: 103, tags: ["گردو"], origin: "تویسرکان", packaging: "بسته وکیوم", storage: "یخچال", allergens: ["مغزها"] }),
  // ————— خشکبار —————
  p({ name: "کشمش سبز طلایی", slug: "golden-raisins", category: "dried-fruits", price: 195000, weight: "۵۰ گرم", image: IMG.dried[3], desc: "کشمش سبز بیدانه ملایر با رنگ طلایی طبیعی و شیرینی متعادل؛ خشک‌شده در سایه.", rating: 4.6, reviews: 84, tags: ["کشمش"], origin: "ملایر", packaging: "بسته زیپ‌کیپ", storage: "دمای خنک" }),
  p({ name: "انجیر خشک استهبان", slug: "dried-figs", category: "dried-fruits", price: 430000, oldPrice: 495000, weight: "۵۰ گرم", image: IMG.dried[0], gallery: [IMG.dried[0], IMG.dried[2]], desc: "انجیر خشک درجه یک استهبان فارس؛ دهان‌باز، سفید و یکدست با سایز ۱۰۱. نگین سفره‌های افطار.", badge: "پرفروش", rating: 4.8, reviews: 141, tags: ["انجیر خشک"], origin: "استهبان، فارس", packaging: "جعبه مقوایی لوکس", storage: "یخچال" }),
  p({ name: "توت خشک طبیعت", slug: "dried-mulberries", category: "dried-fruits", price: 240000, weight: "۴۰ گرم", image: IMG.dried[1], desc: "توت خشک سفید مراغه؛ شیرینی طبیعی بدون سولفیت، مناسب چای و میان‌وعده کودکان.", rating: 4.5, reviews: 58, tags: ["توت خشک"], origin: "مراغه", packaging: "بسته کرافت", storage: "مكان خشک" }),
  p({ name: "برگه زردآلو ملایم", slug: "dried-apricots", category: "dried-fruits", price: 285000, weight: "۵۰ گرم", image: IMG.dried[4], desc: "برگه زردآلو خشک‌شده آفتابی بدون مواد نگهدارنده؛ رنگ کهربایی طبیعی و بافت گوشتی.", rating: 4.6, reviews: 69, tags: ["برگه زردآلو"], origin: "ملارد", packaging: "بسته زیپ‌کیپ", storage: "یخچال" }),
  p({ name: "آلو خشک دودی", slug: "dried-plums", category: "dried-fruits", price: 210000, oldPrice: 240000, weight: "۵۰ گرم", image: IMG.dried[5], desc: "آلو خشک دودی با طعم ملس و عطر ملایم دود؛ میان‌وعده‌ای متفاوت برای سلیقه‌های خاص.", badge: "جدید", rating: 4.4, reviews: 37, tags: ["آلو خشک"], origin: "چهارمحال", packaging: "بسته وکیوم", storage: "دمای محیط" }),
  p({ name: "میکس میوه خشک هلسا", slug: "dried-fruit-mix", category: "dried-fruits", price: 360000, weight: "۶۰ گرم", image: IMG.dried[2], desc: "ترکیب رنگارنگ انجیر، برگه، توت، کشمش و سیب خشک؛ کاسه سلامتی روزانه هلسا.", badge: "محبوب", rating: 4.7, reviews: 95, tags: ["میوه خشک"], origin: "ایران", packaging: "جعبه پذیرایی", storage: "یخچال" }),
  // ————— محصولات طبیعی —————
  p({ name: "عسل طبیعی گون", slug: "natural-gon-honey", category: "natural", price: 680000, oldPrice: 760000, weight: "۹۰۰ گرم", image: IMG.natural[0], gallery: [IMG.natural[0], IMG.natural[4]], desc: "عسل طبیعی گون زاگرس با آنالیز آزمایشگاهی؛ عطر کوهستان و بافت کریستالی نرم. برداشت امسال، بدون حرارت.", badge: "پرفروش", rating: 4.9, reviews: 187, tags: ["عسل"], origin: "زاگرس", packaging: "شیشه دهان‌گشاد", storage: "دمای محیط، دور از نور" }),
  p({ name: "زعفران سرگل نگین", slug: "saffron-negin", category: "natural", price: 1450000, oldPrice: 1680000, weight: "۴.۶ گرم (مثقالی)", image: IMG.natural[1], desc: "زعفران سرگل نگین قائنات با قدرت رنگ‌دهی ۲۹۰؛ بسته‌بندی فلزی لوکس با هولوگرام اصالت هلسا.", badge: "ویژه", rating: 5, reviews: 132, stock: 15, tags: ["زعفران"], origin: "قائنات", packaging: "قوطی فلزی طلاکوب", storage: "مكان تاریک و خشک" }),
  p({ name: "ارده کنجد سنگی", slug: "sesame-tahini", category: "natural", price: 265000, weight: "۶۵۰ گرم", image: IMG.natural[3], desc: "ارده کنجد آسیاب‌سنگی اردکان؛ بدون افزودنی، با بافت مخملی برای صبحانه و حلواارده.", rating: 4.7, reviews: 74, tags: ["ارده"], origin: "اردکان", packaging: "شیشه درب فلزی", storage: "پس از باز شدن یخچال", allergens: ["کنجد"] }),
  p({ name: "شیره انگور درجه یک", slug: "grape-syrup", category: "natural", price: 245000, weight: "۷۰ گرم", image: IMG.natural[4], desc: "شیره انگور ملایر با پخت سنتی و غلظت طبیعی؛ صبحانه‌ای مقوی برای روزهای سرد.", rating: 4.6, reviews: 61, tags: ["شیره"], origin: "ملایر", packaging: "شیشه", storage: "دمای محیط" }),
  p({ name: "چای سیاه لاهیجان", slug: "lahijan-black-tea", category: "natural", price: 320000, weight: "۵۰۰ گرم", image: IMG.natural[2], desc: "چای سیاه قلم بهاره لاهیجان با عطر هل طبیعی؛ دم‌کشیده و خوش‌رنگ، بدون اسانس.", badge: "محبوب", rating: 4.8, reviews: 149, tags: ["چای"], origin: "لاهیجان", packaging: "بسته متالایز", storage: "مكان خشک" }),
  p({ name: "دمنوش گل‌گاوزبان و سنبل‌الطیب", slug: "herbal-tea-borage", category: "natural", price: 185000, oldPrice: 215000, weight: "۱۵۰ گرم", image: IMG.natural[6], desc: "دمنوش آرام‌بخش گل‌گاوزبان، سنبل‌الطیب و لیمو عمانی؛ ritual شب‌های آرام هلسا.", badge: "تخفیف", rating: 4.6, reviews: 55, tags: ["دمنوش"], origin: "کاشان", packaging: "بسته کرافت پنجره‌دار", storage: "مكان خشک" }),
  p({ name: "عرق بیدمشک دوآتشه", slug: "bidmeshk-distillate", category: "natural", price: 165000, weight: "۱ لیتر", image: IMG.natural[5], desc: "عرق بیدمشک دوآتشه قمصر کاشان با عطر ماندگار؛ مناسب شربت، دسر و پذیرایی سنتی.", rating: 4.5, reviews: 42, tags: ["عرقیات"], origin: "قمصر کاشان", packaging: "شیشه ضخیم درب‌دار", storage: "دمای محیط" }),
  p({ name: "سماق پرک کوهی", slug: "sumac-flakes", category: "natural", price: 145000, weight: "۳۰ گرم", image: IMG.natural[1], desc: "سماق پرک کوهی بدون هسته و بدون نمک افزوده؛ رنگ سرخ طبیعی و طعم ملس.", rating: 4.4, reviews: 33, tags: ["ادویه"], origin: "کردستان", packaging: "بسته زیپ‌کیپ", storage: "مكان خشک" }),
];

export function productBySlug(slug: string): Product | undefined {
  return PRODUCTS.find((pr) => pr.slug === slug);
}
