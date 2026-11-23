#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# deploy-check.sh — دروازهٔ یک‌فرمانی پس از استقرار
# ───────────────────────────────────────────────────────────────────────────────
# همهٔ بررسی‌هایی که تا امروز دستی و پراکنده اجرا می‌شدند، در یک فرمان:
#
#   bash scripts/deploy-check.sh                            # دامنهٔ پیش‌فرض (helsairanian.ir)
#   bash scripts/deploy-check.sh https://staging.example.com
#   bash scripts/deploy-check.sh http://127.0.0.1:3000 --local
#   bash scripts/deploy-check.sh --full                     # + axe، PWA و QA سرتاسری (نیازمند Playwright/DB)
#
# کد خروج: 0 = GO · 1 = NO-GO. گزارش هم در helsa-audit/deploy-check-*.txt ذخیره می‌شود.
# ═══════════════════════════════════════════════════════════════════════════════
set -uo pipefail

BASE_URL_DEFAULT="https://helsairanian.ir"
BASE=""
LOCAL=0
FULL=0
for arg in "$@"; do
  case "$arg" in
    --local) LOCAL=1 ;;
    --full) FULL=1 ;;
    -h|--help) sed -n '3,14p' "$0"; exit 0 ;;
    http*) BASE="$arg" ;;
    *) echo "آرگومان ناشناخته: $arg"; exit 2 ;;
  esac
done
BASE="${BASE:-${NEXT_BASE:-$BASE_URL_DEFAULT}}"
BASE="${BASE%/}"

cd "$(dirname "$0")/.." || exit 2
STAMP=$(date -u +%Y%m%dT%H%M%SZ)
mkdir -p helsa-audit
LOG="helsa-audit/deploy-check-${STAMP}.txt"
: > "$LOG"

PASS=0; WARN=0; FAIL=0
declare -a FAILED_ITEMS=()

say()  { printf '%s\n' "$*" | tee -a "$LOG"; }
ok()   { PASS=$((PASS+1)); say "  ✓ $1"; }
warn() { WARN=$((WARN+1)); say "  ▲ $1"; }
fail() { FAIL=$((FAIL+1)); FAILED_ITEMS+=("$1"); say "  ✗ $1"; }

code() { curl -s -o /dev/null -w "%{http_code}" -m 20 "$1"; }
body() { curl -s -m 25 -L "$1"; }

say "════════════════════════════════════════════════════════════════"
say " HELSA — دروازهٔ انتشار · $BASE"
say " زمان (UTC): $STAMP · حالت: $([ $LOCAL -eq 1 ] && echo محلی || echo عمومی)"
say "════════════════════════════════════════════════════════════════"

# ── ۱) دسترس‌پذیری سرویس و دیتابیس ───────────────────────────────────────────
say ""
say "── ۱) سرویس و دیتابیس ──"
HOME_CODE=$(code "$BASE/")
[ "$HOME_CODE" = "200" ] && ok "صفحهٔ خانه: 200" || fail "صفحهٔ خانه: $HOME_CODE"

HEALTH=$(body "$BASE/api/health")
# قالب پاسخ: {"ok":true,"status":"healthy","database":{"configured":true,"reachable":true}}
if [ -n "$HEALTH" ] && printf '%s' "$HEALTH" | grep -q '"status"'; then
  if command -v python3 >/dev/null; then
    VERDICT=$(printf '%s' "$HEALTH" | python3 -c '
import json, sys
try:
    d = json.load(sys.stdin)
except Exception:
    print("bad|پاسخ JSON معتبر نیست"); raise SystemExit
db = d.get("database") or {}
cfg, reach = db.get("configured"), db.get("reachable")
label = "configured=%s reachable=%s" % (cfg, reach)
print(("ok|" if (cfg is True and reach is True) else "bad|") + label)
' 2>/dev/null)
    case "$VERDICT" in
      ok\|*) ok "api/health: دیتابیس متصل (${VERDICT#ok|})" ;;
      *) fail "api/health: دیتابیس در دسترس نیست ⇒ ${VERDICT#bad|}" ;;
    esac
  else
    printf '%s' "$HEALTH" | grep -q '"reachable"[[:space:]]*:[[:space:]]*true' \
      && ok "api/health: دیتابیس متصل" || fail "api/health: دیتابیس در دسترس نیست"
  fi
else
  fail "api/health پاسخ JSON معتبر نداد (کد $(code "$BASE/api/health"))"
fi

# ── ۲) تلهٔ noindex — بحرانی ─────────────────────────────────────────────────
say ""
say "── ۲) ایندکس‌پذیری (تلهٔ بیلد) ──"
check_index() {
  local path="$1" label="$2"
  local html robots
  html=$(body "$BASE$path")
  robots=$(printf '%s' "$html" | grep -o 'name="robots" content="[^"]*"' | head -1 | sed 's/.*content="//;s/"//')
  if [ -z "$robots" ]; then
    fail "$label: تگ robots ندارد"
  elif printf '%s' "$robots" | grep -q 'noindex'; then
    fail "$label: robots=«$robots» ⇒ بیلد بدون ALLOW_INDEXING=1 گرفته شده است"
  else
    ok "$label: robots=«$robots»"
  fi
}
check_index "/" "خانه"
check_index "/products" "فهرست محصولات"
PDP=$(body "$BASE/products" | grep -o 'href="/products/[a-z0-9-]*"' | head -1 | sed 's/href="//;s/"//')
if [ -n "$PDP" ]; then check_index "$PDP" "PDP $PDP"; else warn "PDP برای بررسی پیدا نشد"; fi

# ── ۳) robots.txt و sitemap ──────────────────────────────────────────────────
say ""
say "── ۳) robots.txt و نقشهٔ سایت ──"
RT=$(body "$BASE/robots.txt")
if printf '%s' "$RT" | grep -q 'Sitemap:'; then
  SM_URL=$(printf '%s' "$RT" | grep -o 'Sitemap: *[^ ]*' | head -1 | sed 's/Sitemap: *//')
  ok "robots.txt خط Sitemap دارد"
  case "$SM_URL" in
    *localhost*|*127.0.0.1*) fail "robots.txt دامنهٔ محلی اعلام می‌کند: $SM_URL" ;;
    *) ok "Sitemap → $SM_URL" ;;
  esac
else
  fail "robots.txt بدون خط Sitemap"
fi
printf '%s' "$RT" | grep -qE 'Disallow: */(account|admin|api)' && ok "robots.txt مسیرهای خصوصی را می‌بندد" || warn "robots.txt مسیرهای خصوصی را نمی‌بندد"

SM=$(body "$BASE/sitemap.xml")
if [ -n "$SM" ] && printf '%s' "$SM" | grep -q '<urlset\|<sitemapindex'; then
  N=$(printf '%s' "$SM" | grep -c '<loc>')
  CHILD=$(printf '%s' "$SM" | grep -o '<loc>[^<]*\.xml</loc>' | sed 's/<loc>//;s/<\/loc>//' | head -6)
  TOTAL=$N
  for cu in $CHILD; do
    cpath="/$(printf '%s' "$cu" | sed -E 's#^https?://[^/]+/##')"
    CT=$(body "$BASE$cpath" | grep -c '<loc>' || true)
    TOTAL=$((TOTAL + CT))
  done
  [ "$TOTAL" -ge 20 ] && ok "sitemap: $TOTAL آدرس (ریشه + نقشه‌های فرزند)" || fail "sitemap: فقط $TOTAL آدرس"
else
  fail "sitemap.xml خالی یا نامعتبر (کد $(code "$BASE/sitemap.xml"))"
fi

# ── ۴) امنیت پاسخ‌ها ────────────────────────────────────────────────────────
say ""
say "── ۴) سرآیندهای امنیتی ──"
H=$(curl -s -I -m 20 "$BASE/")
for pair in "strict-transport-security:HSTS" "x-content-type-options:nosniff" "x-frame-options:ضد iframe" "referrer-policy:referrer"; do
  key="${pair%%:*}"; label="${pair##*:}"
  printf '%s' "$H" | grep -qi "^$key:" && ok "سرآیند $label" || fail "سرآیند $label وجود ندارد"
done
printf '%s' "$H" | grep -qi "^content-security-policy:" && ok "Content-Security-Policy" || warn "CSP ندارد (ریسک XSS باقی می‌ماند)"
printf '%s' "$H" | grep -qi "^permissions-policy:" && ok "Permissions-Policy" || warn "Permissions-Policy ندارد"

# ── ۵) صفحات حقوقی و تراکنشی ────────────────────────────────────────────────
say ""
say "── ۵) صفحات ضروری ──"
for p in /terms /privacy /refund /shipping /contact /faq /products /cart; do
  c=$(code "$BASE$p")
  [ "$c" = "200" ] && ok "$p → 200" || fail "$p → $c"
done

# ── ۶) assetlinks (App Links) ───────────────────────────────────────────────
say ""
say "── ۶) App Links اندروید ──"
AL_CODE=$(code "$BASE/.well-known/assetlinks.json")
case "$AL_CODE" in
  200) AL=$(body "$BASE/.well-known/assetlinks.json")
       printf '%s' "$AL" | grep -q 'delegate_permission/common.handle_all_urls' \
         && ok "assetlinks.json معتبر (۲۰۰ با اثر انگشت)" \
         || fail "assetlinks.json ناقص است" ;;
  404) warn "assetlinks.json → ۴۰۴ (ANDROID_APP_SHA256 تنظیم نشده؛ رفتار صادقانه، نه خطا)" ;;
  *) fail "assetlinks.json → $AL_CODE" ;;
esac

# ── ۷) ابزارهای ممیزی روی همان دامنه ────────────────────────────────────────
say ""
say "── ۷) ممیزی‌های خودکار روی همین دامنه ──"
run_py() {
  local name="$1"; shift
  if out=$("$@" 2>&1); then
    local line; line=$(printf '%s' "$out" | grep -E '^نتیجه:' | tail -1)
    ok "$name — ${line:-بدون خطای اجرا}"
    printf '%s\n' "$out" >> "$LOG"
  else
    local line; line=$(printf '%s' "$out" | grep -E '^نتیجه:' | tail -1)
    fail "$name — ${line:-اجرا شکست خورد}"
    printf '%s\n' "$out" >> "$LOG"
  fi
}
command -v python3 >/dev/null && {
  run_py "SEO" python3 scripts/seo-audit.py "$BASE"
  run_py "دسترس‌پذیری محتوا/UI" env NEXT_BASE="$BASE" python3 scripts/ui-audit.py
  run_py "کنتراست" python3 scripts/contrast-audit.py
  run_py "حقوقی" python3 scripts/legal-audit.py "$BASE"
} || warn "python3 نیست — ممیزی‌های پایتونی رد شد"

if [ "$FULL" -eq 1 ] && command -v node >/dev/null; then
  if node -e "require.resolve('playwright')" 2>/dev/null; then
    if node scripts/a11y-audit.mjs "$BASE" >/tmp/a11y.out 2>&1; then
      ok "axe-core — $(grep -oE '[0-9]+ نقض axe در [0-9]+ صفحه' /tmp/a11y.out | tail -1)"
    else
      fail "axe-core — $(grep -oE '[0-9]+ نقض axe در [0-9]+ صفحه' /tmp/a11y.out | tail -1 || echo 'نقض دارد')"
    fi
    tee -a "$LOG" < /tmp/a11y.out >/dev/null
    if node scripts/pwa-audit.mjs "$BASE" >/tmp/pwa.out 2>&1; then
      ok "PWA — $(grep -E '^نتیجه:' /tmp/pwa.out | tail -1)"
    else
      fail "PWA — $(grep -E '^نتیجه:' /tmp/pwa.out | tail -1)"
    fi
    tee -a "$LOG" < /tmp/pwa.out >/dev/null
  else
    warn "Playwright نصب نیست — axe و PWA رد شد (npx playwright install chromium)"
  fi
fi

# ── جمع‌بندی ────────────────────────────────────────────────────────────────
say ""
say "════════════════════════════════════════════════════════════════"
say " PASS=$PASS · WARN=$WARN · FAIL=$FAIL"
if [ "$FAIL" -eq 0 ]; then
  say " 🟢 GO — می‌توانید لانچ کنید (هشدارها را هم بخوانید)"
else
  say " 🔴 NO-GO — این موارد باید رفع شوند:"
  for f in "${FAILED_ITEMS[@]}"; do say "    • $f"; done
fi
say " گزارش: $LOG"
say "════════════════════════════════════════════════════════════════"
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
