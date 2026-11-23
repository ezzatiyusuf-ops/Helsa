# Implementation Plan — Smart Cart Upsell & Cross-Sell

> Written **after** inspecting the actual codebase (not assumed).

## 1. What already exists

| Concern | Reality in the repo |
|---|---|
| Cart state | `src/lib/store.ts` — zustand + `persist` (`helsa-store-v2`), `addItem(item, qty)`, `items[]`, no server cart |
| Add-to-cart handlers | `ProductCard.onAdd`, `ProductDetailClient.onAdd`, `FrequentlyBought`, tray/gift builders (`TrayBuilderClient`, `TrayCard`, `GiftBoxCard`, `GoldenTrayCard`, `Hero`) |
| Cart page cross-sell | `src/components/cart/CartUpsell.tsx` → `POST /api/products/cross-sell` (cart-level, max 3 products) |
| Catalog source | `getProducts()` in `src/services/catalog.ts` — DB when configured, static `src/data/products.ts` (184 products) otherwise |
| Product fields | `price`, `oldPrice`, `weight`, `stock`, `image`, `category`, `tags[]`, `rating`, `reviews`, `isActive/isVisible`, `variants[]` — **no `relatedIds` field in schema** |
| Design system | Tailwind v4 tokens in `globals.css` (`brand-*`, `gold-*`, `ink-*`, `surface`, `line`, `heading`, `muted`), `SmartImage`, `formatToman`, `faDigits`, `Toast` |
| Modal primitive | `src/components/ui/controls.tsx` → `Modal` — **centered only, no Esc, no focus trap, no scroll lock** → not sufficient |
| Analytics | `trackEvent(event, params)` → `window.dataLayer` |
| Tests | `tests/unit.test.ts`, `node --import tsx --test`; unit tests import with **relative** paths |

## 2. Decisions

1. **No DB migration.** Explicit relations live in `src/data/product-relations.ts` (typed config). Admin editing them would need a migration — flagged as "requires backend change", not silently claimed.
2. **New non-persisted UI store** (`src/lib/upsell-store.ts`) so the persisted cart store and its version/merge behaviour stay untouched.
3. **Recommendation logic is a pure function** (`src/lib/upsell.ts`) — no React, no DB, unit-testable. The API route is a thin wrapper over it.
4. **Server route** `POST /api/products/upsell` returns authoritative price/stock from the same catalog service the rest of the site uses; the client never invents prices.
5. **New drawer component** instead of extending the shared `Modal` (avoids regressing ~10 existing consumers).
6. **Trigger through one hook** `useAddWithUpsell()` so every product add-point behaves identically.

## 3. Priority order implemented

1. Explicit relations (`product-relations.ts`)
2. Category/tag complement rules (`COMPLEMENT_RULES`)
3. Same-category similar products
4. Deterministic fallback (featured → rating·reviews → stock → id)

Every candidate is filtered by: not the seed, active, visible, `stock > 0`, and (when supplied) not already in the cart.

## 4. Files

**New**
- `src/lib/upsell.ts` — engine (pure)
- `src/data/product-relations.ts` — explicit relations
- `src/lib/upsell-store.ts` — open/close + seed state
- `src/app/api/products/upsell/route.ts` — endpoint
- `src/components/cart/CartUpsellDrawer.tsx` — modal / bottom sheet
- `src/components/cart/useAddWithUpsell.ts` — trigger hook
- `tests/upsell.test.ts` — engine tests

**Modified**
- `src/components/layout/Shell.tsx` — mount drawer once
- `src/components/product/ProductCard.tsx` — use hook
- `src/components/product/ProductDetailClient.tsx` — use hook
- `package.json` — `test:upsell` script

## 5. Out of scope (needs backend/catalog work — stated, not faked)

- Bundle/percentage discounts: the offer system exists (`campaigns`, `offers`) but no per-bundle validation API → **no discount UI shipped**.
- Admin UI for editing relations.
- Server cart / cross-device merge.
