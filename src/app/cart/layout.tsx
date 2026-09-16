import type { Metadata } from "next";

/** Cart is private/transactional — must not compete with product pages in search. */
export const metadata: Metadata = {
  robots: { index: false, follow: false },
};

export default function CartLayout({ children }: { children: React.ReactNode }) {
  return children;
}
