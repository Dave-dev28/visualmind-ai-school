import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import GenerateCodeForm from "@/components/admin/GenerateCodeForm";

interface Student {
  id: string;
  email: string;
  display_name: string | null;
  track: string | null;
  seat_claimed: boolean;
  credits: number;
  cohort_name: string | null;
  created_at: string;
  last_sign_in_at: string | null;
}

interface CodeRow {
  id: string;
  code: string;
  cohort_name: string | null;
  credits_grant: number;
  status: string;
  redeemed_by_name: string | null;
  redeemed_at: string | null;
  created_at: string;
}

interface Cohort {
  id: string;
  name: string;
  starts_on: string | null;
  friday_reveal_at: string | null;
}

/**
 * Admin dashboard (PRD §F10, brought forward) — who's signed up, who still
 * needs a seat, and a one-click access-code generator so David never has to
 * touch SQL for the day-to-day of running the pilot/cohort.
 */
export default async function AdminPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const { data: profile } = await supabase
    .from("profiles")
    .select("is_admin")
    .eq("id", user!.id)
    .maybeSingle();

  if (!profile?.is_admin) redirect("/");

  const [{ data: students }, { data: codes }, { data: cohorts }] =
    await Promise.all([
      supabase.rpc("admin_list_students"),
      supabase.rpc("admin_list_codes"),
      supabase.rpc("admin_list_cohorts"),
    ]);

  const rows = (students ?? []) as Student[];
  const codeRows = (codes ?? []) as CodeRow[];
  const cohortRows = (cohorts ?? []) as Cohort[];

  const needSeat = rows.filter((r) => !r.seat_claimed);
  const seated = rows.filter((r) => r.seat_claimed);

  return (
    <main className="mx-auto min-h-dvh w-full max-w-3xl px-5 pb-16 pt-[max(1.5rem,env(safe-area-inset-top))]"
      style={{ background: "var(--bg)", color: "var(--text)" }}>
      <header className="flex items-center justify-between">
        <div>
          <p className="text-sm font-600 text-[var(--text-muted)]">Admin</p>
          <h1 className="text-2xl font-800">Cohort control</h1>
        </div>
        <Link
          href="/"
          className="rounded-[var(--radius-pill)] bg-[var(--surface)] px-4 py-2 text-sm font-700 text-[var(--text-muted)]"
        >
          ← Student view
        </Link>
      </header>

      {/* Quick stats */}
      <div className="mt-6 grid grid-cols-3 gap-3">
        <Stat label="Signed up" value={rows.length} />
        <Stat label="Need a seat" value={needSeat.length} accent />
        <Stat label="Seated" value={seated.length} />
      </div>

      {/* Generate a code */}
      <section className="mt-8 rounded-[var(--radius-lg)] border border-[var(--border)] bg-[var(--surface)] p-5">
        <p className="text-xs font-700 uppercase tracking-wide text-[var(--text-muted)]">
          Issue a new access code
        </p>
        <p className="mt-1 text-sm text-[var(--text-muted)]">
          Confirm the student&apos;s payment yourself, then generate a code here
          and send it to them — it unlocks one seat, once.
        </p>
        <GenerateCodeForm cohorts={cohortRows} />
      </section>

      {/* Students needing a seat first — the actionable list */}
      {needSeat.length > 0 && (
        <section className="mt-8">
          <p className="mb-2 text-xs font-700 uppercase tracking-wide text-[var(--danger)]">
            Waiting for a seat ({needSeat.length})
          </p>
          <div className="flex flex-col gap-2">
            {needSeat.map((s) => (
              <div
                key={s.id}
                className="flex items-center justify-between rounded-[var(--radius-md)] bg-[var(--surface)] px-4 py-3"
              >
                <div className="min-w-0">
                  <p className="truncate text-sm font-700">
                    {s.display_name || "(no name)"}
                  </p>
                  <p className="truncate text-xs text-[var(--text-muted)]">
                    {s.email}
                  </p>
                </div>
                <span className="flex-none text-xs text-[var(--text-muted)]">
                  {timeAgo(s.created_at)}
                </span>
              </div>
            ))}
          </div>
        </section>
      )}

      {/* All students */}
      <section className="mt-8">
        <p className="mb-2 text-xs font-700 uppercase tracking-wide text-[var(--text-muted)]">
          All students ({rows.length})
        </p>
        <div className="overflow-x-auto rounded-[var(--radius-md)] border border-[var(--border)]">
          <table className="w-full min-w-[560px] text-left text-sm">
            <thead>
              <tr className="border-b border-[var(--border)] text-xs uppercase text-[var(--text-muted)]">
                <th className="px-3 py-2">Name</th>
                <th className="px-3 py-2">Email</th>
                <th className="px-3 py-2">Track</th>
                <th className="px-3 py-2">Cohort</th>
                <th className="px-3 py-2">Credits</th>
                <th className="px-3 py-2">Last seen</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((s) => (
                <tr key={s.id} className="border-b border-[var(--border)] last:border-0">
                  <td className="px-3 py-2 font-700">{s.display_name || "—"}</td>
                  <td className="px-3 py-2 text-[var(--text-muted)]">{s.email}</td>
                  <td className="px-3 py-2">{s.track || "—"}</td>
                  <td className="px-3 py-2">{s.cohort_name || "—"}</td>
                  <td className="px-3 py-2">⚡ {s.credits}</td>
                  <td className="px-3 py-2 text-[var(--text-muted)]">
                    {s.last_sign_in_at ? timeAgo(s.last_sign_in_at) : "never"}
                  </td>
                </tr>
              ))}
              {rows.length === 0 && (
                <tr>
                  <td colSpan={6} className="px-3 py-6 text-center text-[var(--text-muted)]">
                    No students yet.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </section>

      {/* Access codes */}
      <section className="mt-8">
        <p className="mb-2 text-xs font-700 uppercase tracking-wide text-[var(--text-muted)]">
          Access codes ({codeRows.length})
        </p>
        <div className="overflow-x-auto rounded-[var(--radius-md)] border border-[var(--border)]">
          <table className="w-full min-w-[520px] text-left text-sm">
            <thead>
              <tr className="border-b border-[var(--border)] text-xs uppercase text-[var(--text-muted)]">
                <th className="px-3 py-2">Code</th>
                <th className="px-3 py-2">Cohort</th>
                <th className="px-3 py-2">Credits</th>
                <th className="px-3 py-2">Status</th>
                <th className="px-3 py-2">Redeemed by</th>
              </tr>
            </thead>
            <tbody>
              {codeRows.map((c) => (
                <tr key={c.id} className="border-b border-[var(--border)] last:border-0">
                  <td className="px-3 py-2 font-800 tracking-wide">{c.code}</td>
                  <td className="px-3 py-2">{c.cohort_name || "—"}</td>
                  <td className="px-3 py-2">⚡ {c.credits_grant}</td>
                  <td className="px-3 py-2">
                    <span
                      className="rounded-full px-2 py-0.5 text-xs font-700"
                      style={{
                        background:
                          c.status === "redeemed"
                            ? "rgba(74,222,128,0.12)"
                            : "rgba(255,106,61,0.12)",
                        color:
                          c.status === "redeemed" ? "var(--success)" : "var(--accent-strong)",
                      }}
                    >
                      {c.status}
                    </span>
                  </td>
                  <td className="px-3 py-2 text-[var(--text-muted)]">
                    {c.redeemed_by_name || "—"}
                  </td>
                </tr>
              ))}
              {codeRows.length === 0 && (
                <tr>
                  <td colSpan={5} className="px-3 py-6 text-center text-[var(--text-muted)]">
                    No codes issued yet.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </section>
    </main>
  );
}

function Stat({
  label,
  value,
  accent,
}: {
  label: string;
  value: number;
  accent?: boolean;
}) {
  return (
    <div className="rounded-[var(--radius-md)] border border-[var(--border)] bg-[var(--surface)] p-4 text-center">
      <p
        className="text-2xl font-800"
        style={{ color: accent && value > 0 ? "var(--accent-strong)" : "var(--text)" }}
      >
        {value}
      </p>
      <p className="text-xs font-600 text-[var(--text-muted)]">{label}</p>
    </div>
  );
}

function timeAgo(iso: string): string {
  const ms = Date.now() - new Date(iso).getTime();
  const mins = Math.floor(ms / 60000);
  if (mins < 1) return "just now";
  if (mins < 60) return `${mins}m ago`;
  const hours = Math.floor(mins / 60);
  if (hours < 24) return `${hours}h ago`;
  const days = Math.floor(hours / 24);
  return `${days}d ago`;
}
