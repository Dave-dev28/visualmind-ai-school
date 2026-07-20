import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import SignOutButton from "@/components/auth/SignOutButton";

/**
 * Profile & Settings (PRD §7.8) — identity, credit balance, learning path,
 * and honest "coming soon" stubs (Pidgin greyed out measures demand).
 */
export default async function ProfilePage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const { data: profile } = await supabase
    .from("profiles")
    .select("display_name, credits, track, cohort_id, created_at")
    .eq("id", user!.id)
    .maybeSingle();

  const { data: cohort } = profile?.cohort_id
    ? await supabase
        .from("cohorts")
        .select("name, friday_reveal_at")
        .eq("id", profile.cohort_id)
        .maybeSingle()
    : { data: null };

  const name = profile?.display_name || "Student";
  const initial = (name[0] || "?").toUpperCase();

  return (
    <main className="app-aura mx-auto flex min-h-dvh w-full max-w-md flex-col px-5 pb-10 pt-[max(1.5rem,env(safe-area-inset-top))]">
      <header className="flex items-center gap-3">
        <Link
          href="/"
          className="grid h-9 w-9 flex-none place-items-center rounded-full bg-[var(--surface)] text-[var(--text-muted)] active:scale-95"
          aria-label="Back to home"
        >
          ←
        </Link>
        <h1 className="text-xl font-800">Profile &amp; settings</h1>
      </header>

      {/* Identity */}
      <section className="mt-6 flex items-center gap-4 rounded-[var(--radius-lg)] border border-[var(--border)] bg-[var(--surface)] p-5">
        <div
          className="grid h-14 w-14 flex-none place-items-center rounded-full text-2xl font-800"
          style={{ background: "var(--accent)", color: "var(--accent-ink)" }}
        >
          {initial}
        </div>
        <div className="min-w-0">
          <p className="truncate text-lg font-800">{name}</p>
          <p className="truncate text-sm text-[var(--text-muted)]">
            {user?.email}
          </p>
        </div>
      </section>

      {/* Credits */}
      <section className="mt-4 rounded-[var(--radius-lg)] border border-[var(--border)] bg-[var(--surface)] p-5">
        <p className="text-xs font-700 uppercase tracking-wide text-[var(--text-muted)]">
          Creation credits
        </p>
        <p className="mt-1 text-3xl font-800" style={{ color: "var(--accent-strong)" }}>
          ⚡ {profile?.credits ?? 0}
        </p>
        <p className="mt-1 text-sm text-[var(--text-muted)]">
          Credits power your AI generations. Need more? Message David to top up.
        </p>
      </section>

      {/* Learning */}
      <section className="mt-4 rounded-[var(--radius-lg)] border border-[var(--border)] bg-[var(--surface)] p-5">
        <p className="text-xs font-700 uppercase tracking-wide text-[var(--text-muted)]">
          Your learning
        </p>
        <div className="mt-3 flex flex-col gap-3">
          <Row label="Path">
            {profile?.track ? (
              <span className="flex items-center gap-2">
                {profile.track}
                <Link
                  href="/choose-path"
                  className="text-xs font-600 text-[var(--accent-strong)] underline"
                >
                  change
                </Link>
              </span>
            ) : (
              "Not chosen yet — finish the basics first"
            )}
          </Row>
          <Row label="Cohort">{cohort?.name ?? "—"}</Row>
          <Row label="Joined">
            {profile?.created_at
              ? new Date(profile.created_at).toLocaleDateString("en-GB", {
                  day: "numeric",
                  month: "short",
                  year: "numeric",
                })
              : "—"}
          </Row>
        </div>
      </section>

      {/* Settings — honest stubs; greyed Pidgin measures demand (PRD §7.8) */}
      <section className="mt-4 rounded-[var(--radius-lg)] border border-[var(--border)] bg-[var(--surface)] p-5">
        <p className="text-xs font-700 uppercase tracking-wide text-[var(--text-muted)]">
          Settings
        </p>
        <div className="mt-3 flex flex-col gap-3">
          <Row label="Language">
            <span>
              English{" "}
              <span className="rounded-full bg-[var(--surface-2)] px-2 py-0.5 text-xs text-[var(--text-muted)]">
                Pidgin — coming soon
              </span>
            </span>
          </Row>
          <Row label="Data saver">
            <span className="text-[var(--text-muted)]">Coming soon</span>
          </Row>
          <Row label="Notifications">
            <span className="text-[var(--text-muted)]">Coming soon</span>
          </Row>
        </div>
      </section>

      <div className="mt-6">
        <SignOutButton />
      </div>

      <p className="mt-6 text-center text-xs text-[var(--text-muted)]">
        VisualMind AI School · made with students, for students
      </p>
    </main>
  );
}

function Row({
  label,
  children,
}: {
  label: string;
  children: React.ReactNode;
}) {
  return (
    <div className="flex items-start justify-between gap-4 text-sm">
      <span className="flex-none font-600 text-[var(--text-muted)]">
        {label}
      </span>
      <span className="text-right font-700">{children}</span>
    </div>
  );
}
