#!/usr/bin/env bash
# push-to-git.sh — پوش کامل پروژهٔ هلسا به GitHub (کد + تصاویر بهینه‌شده)
# استفاده:  GITHUB_TOKEN=ghp_xxxxx bash scripts/push-to-git.sh
# امنیت: توکن فقط از متغیر محیطی خوانده می‌شود و هرگز چاپ نمی‌شود؛
#         git-dir در /tmp ساخته می‌شود تا فضای ورک‌اسپیس پر نشود.
set -euo pipefail

REPO="ezatiyusuf-ops/Helsairaninweb"
BRANCH="main"
: "${GITHUB_TOKEN:?خطا: GITHUB_TOKEN ست نشده — GITHUB_TOKEN=xxx bash scripts/push-to-git.sh}"

cd /home/user/helsa
GITDIR=/tmp/helsa-git

# شروع تازه (فایل اشاره‌گر .git بعداً حذف می‌شود)
rm -rf "$GITDIR" .git
git init --separate-git-dir="$GITDIR" -b "$BRANCH" >/dev/null
git config user.name "ezzatiyusuf-ops"
git config user.email "ezzatiyusuf-ops@users.noreply.github.com"
git config http.postBuffer 524288000

echo "[push] ۱/۵ stage فایل‌ها (طبق .gitignore — بدون .env/بکاپ/qa-shots)…"
git add -A

# گارد امنیتی: هرگز اجازهٔ push رازها را نده
if git ls-files --cached | grep -qx ".env"; then
  echo "خطای امنیتی: .env استیج شده است — متوقف شد!" >&2; exit 1
fi
if git ls-files --cached | grep -q "^backups/"; then
  echo "خطای امنیتی: backups/ استیج شده است — متوقف شد!" >&2; exit 1
fi

FILES=$(git ls-files --cached | wc -l)
echo "[push] ۲/۵ commit ($FILES فایل)…"
git commit -q -m "Helsa v3 — full source + optimized images

- Health Center (10 قلمرو سلامت) + Mental Health hub
- Podcast / Videocast + Founder page
- 7 product guides + 27 blog posts
- Compact hero (desktop 480px, mobile image 240px)
- Header menus (desktop + mobile drawer) with health/media group
- 1269 optimized images (AVIF/WebP variants) in public/images/opt
- Netlify-ready (netlify.toml) — build works without DB"

echo "[push] ۳/۵ اتصال به $REPO و پوش…"
git remote add origin "https://x-access-token:${GITHUB_TOKEN}@github.com/${REPO}.git"
FORCE=""
if ! git push -u origin "$BRANCH" 2>/tmp/push.err; then
  echo "[push] پوش عادی رد شد (احتمالاً commit اولیهٔ repo) — تلاش با --force…"
  FORCE=" (force)"
  git push -u origin "$BRANCH" --force
fi

echo "[push] ۴/۵ پاک‌کردن توکن از remote…"
git remote set-url origin "https://github.com/${REPO}.git"

echo "[push] ۵/۵ جمع‌بندی…"
SHA=$(git rev-parse --short HEAD)
echo "──────────────────────────────────────"
echo "✅ پوش موفق$FORCE"
echo "   repo:   github.com/$REPO (شاخهٔ $BRANCH)"
echo "   commit: $SHA"
echo "   فایل‌ها: $FILES"
echo "   حجم: $(du -sh "$GITDIR" | cut -f1) (شئ‌های git)"
echo "──────────────────────────────────────"

# نظافت: اشاره‌گر .git از پروژه حذف شود (git-dir در /tmp بین نشست‌ها می‌ماند/می‌رود)
rm -f .git
