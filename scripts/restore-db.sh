#!/usr/bin/env bash
# ==========================================================
# HELSA — PostgreSQL restore
# بازگرداندن یک بکاپ به دیتابیس هدف (پیش‌فرض: همان helsa_db)
# Run:  bash scripts/restore-db.sh backups/helsa-XXXX.dump [--force]
#   بدون --force: از بازنویسی دیتابیسِ دارای داده سؤال می‌پرسد.
#   TRG_DB=other_db برای بازگردانی به دیتابیس دیگر (مثلاً تست)
# متغیرهای محیطی: DB_USER, DB_PASS, DB_HOST, DB_PORT, TRG_DB
# ==========================================================
set -euo pipefail
cd "$(dirname "$0")/.."

DUMP="${1:?استفاده: bash scripts/restore-db.sh backups/helsa-XXXX.dump [--force]}"
FORCE="${2:-}"
DB_USER="${DB_USER:-helsa}"
DB_PASS="${DB_PASS:-helsa_dev_pw}"
DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-5432}"
TRG_DB="${TRG_DB:-helsa_db}"
export PGPASSWORD="$DB_PASS"

[ -f "$DUMP" ] || { echo "❌ فایل یافت نشد: $DUMP"; exit 1; }

# صحت آرشیو
pg_restore --list "$DUMP" >/dev/null || { echo "❌ آرشیو خراب است: $DUMP"; exit 1; }

# اگر چک‌سام همزمان وجود دارد، بررسی شود
BASE="${DUMP%.dump}"
if [ -f "$BASE.sha256" ]; then
  sha256sum -c "$BASE.sha256" --quiet \
    && echo "[restore] چک‌سام ✔" || { echo "❌ چک‌سام مطابق نیست!"; exit 1; }
fi

CURRENT_ROWS=$(psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$TRG_DB" -tAc \
  "SELECT count(*) FROM products" 2>/dev/null || echo 0)
if [ "$CURRENT_ROWS" != "0" ] && [ "$FORCE" != "--force" ] && [ "${TRG_FORCE:-}" != "1" ]; then
  echo "⚠️ دیتابیس مقصد «$TRG_DB» دارای $CURRENT_ROWS محصول است."
  read -r -p "بازنویسی؟ [y/N] " ans
  [ "$ans" = "y" ] || { echo "لغو شد."; exit 1; }
fi

echo "[restore] بازگردانی $DUMP → $TRG_DB …"
# DROP/CREATE هرکدام در فرمان جدا (DROP DATABASE داخل تراکنش مجاز نیست).
# ترجیحاً با postgres (restore عملیات ادمینی است؛ کاربر اپ CREATEDB ندارد)
ADMIN_PSQL=(psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d postgres)
if command -v sudo >/dev/null 2>&1 && sudo -u postgres psql -d postgres -tAc "SELECT 1" >/dev/null 2>&1; then
  ADMIN_PSQL=(sudo -u postgres psql -d postgres)
fi
"${ADMIN_PSQL[@]}" -c \
  "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='$TRG_DB' AND pid<>pg_backend_pid();" >/dev/null 2>&1 || true
"${ADMIN_PSQL[@]}" -c "DROP DATABASE IF EXISTS \"$TRG_DB\";" >/dev/null
"${ADMIN_PSQL[@]}" -c "CREATE DATABASE \"$TRG_DB\" OWNER \"$DB_USER\";" >/dev/null
pg_restore -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$TRG_DB" --no-owner --no-privileges --clean --if-exists "$DUMP"

PRODUCTS=$(psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$TRG_DB" -tAc "SELECT count(*) FROM products")
ORDERS=$(psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$TRG_DB" -tAc "SELECT count(*) FROM orders" 2>/dev/null || echo 0)
echo "[restore] ✔ انجام شد — $TRG_DB: products=$PRODUCTS, orders=$ORDERS"
