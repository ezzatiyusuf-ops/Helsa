"use client";
import { useEffect, useState } from "react";
import { AdminPageHead } from "@/components/admin/AdminShell";
import { faDigits, formatToman } from "@/lib/format";

type Corp = { code: string; companyName: string; contactName: string; mobile: string; quantity: number; status: string; indicativeTotal: number | null; createdAt: string };
type Ws = { code: string; companyName: string; contactName: string; mobile: string; businessType: string; city: string; status: string; createdAt: string };

export default function AdminInquiriesPage() {
  const [corporate, setCorporate] = useState<Corp[]>([]);
  const [wholesale, setWholesale] = useState<Ws[]>([]);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch("/api/admin/inquiries")
      .then((r) => r.json())
      .then((d) => {
        if (!d.ok) throw new Error(d.message || "خطا");
        setCorporate(d.corporate ?? []);
        setWholesale(d.wholesale ?? []);
      })
      .catch((e) => setError(e instanceof Error ? e.message : "خطا"))
      .finally(() => setLoading(false));
  }, []);

  return (
    <>
      <AdminPageHead title="درخواست‌های سازمانی و عمده" desc="درخواست‌های ثبت‌شده از وب‌سایت؛ قیمت نهایی فقط پس از بررسی کارشناسی." />
      {loading && <p className="text-sm text-muted">در حال بارگذاری...</p>}
      {error && <p className="text-sm text-accent-600">{error}</p>}
      <section className="space-y-8">
        <div>
          <h2 className="mb-3 text-sm font-black">هدایای سازمانی</h2>
          {!corporate.length && !loading ? <p className="text-xs text-muted">درخواستی ثبت نشده است.</p> : (
            <div className="overflow-x-auto rounded-2xl border border-line bg-surface">
              <table className="w-full min-w-[720px] text-xs">
                <thead className="bg-surface2"><tr><th className="p-3 text-start">کد</th><th>شرکت</th><th>مسئول</th><th>تعداد</th><th>تقریبی</th><th>وضعیت</th></tr></thead>
                <tbody>
                  {corporate.map((r) => (
                    <tr key={r.code} className="border-t border-line-soft">
                      <td className="p-3" dir="ltr">{r.code}</td>
                      <td className="text-center">{r.companyName}</td>
                      <td className="text-center">{r.contactName}<br /><span dir="ltr">{r.mobile}</span></td>
                      <td className="text-center">{faDigits(r.quantity)}</td>
                      <td className="text-center">{r.indicativeTotal ? formatToman(r.indicativeTotal) : "—"}</td>
                      <td className="text-center">{r.status}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
        <div>
          <h2 className="mb-3 text-sm font-black">خرید عمده</h2>
          {!wholesale.length && !loading ? <p className="text-xs text-muted">درخواستی ثبت نشده است.</p> : (
            <div className="overflow-x-auto rounded-2xl border border-line bg-surface">
              <table className="w-full min-w-[720px] text-xs">
                <thead className="bg-surface2"><tr><th className="p-3 text-start">کد</th><th>مجموعه</th><th>نوع</th><th>شهر</th><th>مسئول</th><th>وضعیت</th></tr></thead>
                <tbody>
                  {wholesale.map((r) => (
                    <tr key={r.code} className="border-t border-line-soft">
                      <td className="p-3" dir="ltr">{r.code}</td>
                      <td className="text-center">{r.companyName}</td>
                      <td className="text-center">{r.businessType}</td>
                      <td className="text-center">{r.city}</td>
                      <td className="text-center">{r.contactName}<br /><span dir="ltr">{r.mobile}</span></td>
                      <td className="text-center">{r.status}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </section>
    </>
  );
}
