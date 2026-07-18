"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

/**
 * Access-code / seat gate (PRD §F1, v1 manual payment). The student pays David
 * out-of-band; he issues a single-use code; entering it here claims their seat
 * and grants starter credits via the secure redeem_access_code() function.
 */
export default function SeatPage() {
  const router = useRouter();
  const supabase = createClient();
  const [code, setCode] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  const redeem = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setBusy(true);
    const { data, error } = await supabase.rpc("redeem_access_code", {
      p_code: code,
    });

    if (error) {
      setError("Couldn’t check that code. Try again in a moment.");
      setBusy(false);
      return;
    }

    switch (data) {
      case "ok":
        router.replace("/");
        router.refresh();
        return;
      case "already_claimed":
        router.replace("/");
        router.refresh();
        return;
      case "invalid":
        setError("That code isn’t valid or has already been used. Double-check it with David.");
        break;
      default:
        setError("Something went wrong. Please try again.");
    }
    setBusy(false);
  };

  const signOut = async () => {
    await supabase.auth.signOut();
    router.replace("/login");
    router.refresh();
  };

  return (
    <main className="app-aura mx-auto flex min-h-dvh w-full max-w-md flex-col justify-center px-6 pb-10">
      <div className="mb-8">
        <p className="text-sm font-600 text-[var(--accent-strong)]">
          One last step
        </p>
        <h1 className="mt-1 text-3xl font-800 leading-tight">
          Enter your seat code
        </h1>
        <p className="mt-2 text-[var(--text-muted)]">
          This is the code David sent you after your payment came through. It
          unlocks your place in the cohort.
        </p>
      </div>

      <form onSubmit={redeem} className="flex flex-col gap-3">
        <input
          value={code}
          onChange={(e) => setCode(e.target.value.toUpperCase())}
          placeholder="PILOT-001"
          autoCapitalize="characters"
          autoCorrect="off"
          className="rounded-[var(--radius-md)] border border-[var(--border)] bg-[var(--surface)] px-4 py-4 text-center text-2xl font-800 tracking-widest text-[var(--text)] outline-none transition-colors focus:border-[var(--accent)]"
        />

        {error && (
          <p className="rounded-[var(--radius-sm)] bg-[rgba(244,164,139,0.1)] px-3 py-2 text-sm font-600 text-[var(--danger)]">
            {error}
          </p>
        )}

        <button
          type="submit"
          disabled={busy || code.trim().length === 0}
          className="mt-2 rounded-[var(--radius-pill)] py-4 text-lg font-800 transition-transform active:scale-[0.99] disabled:opacity-50"
          style={{ background: "var(--accent)", color: "var(--accent-ink)" }}
        >
          {busy ? "Checking…" : "Claim my seat"}
        </button>
      </form>

      <div className="mt-8 rounded-[var(--radius-md)] border border-[var(--border)] bg-[var(--surface)] p-4 text-sm text-[var(--text-muted)]">
        Don’t have a code yet? Message David to pay and get yours — you’ll be in
        the next Friday cohort.
      </div>

      <button
        onClick={signOut}
        className="mt-6 text-center text-sm font-600 text-[var(--text-muted)] underline"
      >
        Sign out
      </button>
    </main>
  );
}
