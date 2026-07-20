"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

interface Cohort {
  id: string;
  name: string;
}

export default function GenerateCodeForm({ cohorts }: { cohorts: Cohort[] }) {
  const router = useRouter();
  const supabase = createClient();
  const [cohortId, setCohortId] = useState(cohorts[0]?.id ?? "");
  const [credits, setCredits] = useState(100);
  const [busy, setBusy] = useState(false);
  const [result, setResult] = useState<string | null>(null);
  const [copied, setCopied] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const generate = async () => {
    setBusy(true);
    setError(null);
    setResult(null);
    const { data, error } = await supabase.rpc("admin_generate_code", {
      p_cohort_id: cohortId || null,
      p_credits: credits,
    });
    if (error || !data) {
      setError("Couldn't generate a code — try again.");
      setBusy(false);
      return;
    }
    setResult(data as string);
    setBusy(false);
    router.refresh();
  };

  const copy = async () => {
    if (!result) return;
    await navigator.clipboard.writeText(result);
    setCopied(true);
    window.setTimeout(() => setCopied(false), 1500);
  };

  return (
    <div className="mt-4 flex flex-col gap-3">
      <div className="flex flex-wrap gap-3">
        {cohorts.length > 0 && (
          <label className="flex flex-col gap-1">
            <span className="text-xs font-600 text-[var(--text-muted)]">Cohort</span>
            <select
              value={cohortId}
              onChange={(e) => setCohortId(e.target.value)}
              className="rounded-[var(--radius-sm)] border border-[var(--border)] bg-[var(--surface-2)] px-3 py-2 text-sm font-600"
            >
              {cohorts.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.name}
                </option>
              ))}
            </select>
          </label>
        )}
        <label className="flex flex-col gap-1">
          <span className="text-xs font-600 text-[var(--text-muted)]">Starter credits</span>
          <input
            type="number"
            min={0}
            step={10}
            value={credits}
            onChange={(e) => setCredits(Number(e.target.value))}
            className="w-28 rounded-[var(--radius-sm)] border border-[var(--border)] bg-[var(--surface-2)] px-3 py-2 text-sm font-600"
          />
        </label>
      </div>

      <button
        onClick={generate}
        disabled={busy}
        className="self-start rounded-[var(--radius-pill)] px-5 py-2.5 text-sm font-800 transition-transform active:scale-95 disabled:opacity-50"
        style={{ background: "var(--accent)", color: "var(--accent-ink)" }}
      >
        {busy ? "Generating…" : "Generate code"}
      </button>

      {error && (
        <p className="text-sm font-600 text-[var(--danger)]">{error}</p>
      )}

      {result && (
        <div className="flex items-center gap-3 rounded-[var(--radius-md)] border border-[var(--accent)] bg-[rgba(255,106,61,0.08)] px-4 py-3">
          <span className="flex-1 text-lg font-800 tracking-wide">{result}</span>
          <button
            onClick={copy}
            className="flex-none rounded-[var(--radius-pill)] bg-[var(--surface-2)] px-3 py-1.5 text-xs font-700"
          >
            {copied ? "Copied ✓" : "Copy"}
          </button>
        </div>
      )}
    </div>
  );
}
