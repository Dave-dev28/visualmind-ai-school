"use client";

import { useRouter } from "next/navigation";
import type { Lesson } from "@/lib/beats";

interface Props {
  lesson: Lesson;
  /** Concrete "Today you…" verbs, one per completed beat. */
  verbs: string[];
}

/**
 * End-of-class recap (PRD §F2). Concrete verbs, an artifact saved feel, a
 * tomorrow tease — and deliberately NO score (scores stay hidden until Friday).
 */
export default function RecapScreen({ lesson, verbs }: Props) {
  const router = useRouter();
  return (
    <div className="animate-pop flex h-full flex-col">
      <div className="animate-celebrate mx-auto grid h-20 w-20 place-items-center rounded-full text-4xl"
        style={{ background: "var(--accent)", color: "var(--accent-ink)" }}>
        🎉
      </div>

      <h1 className="mt-5 text-center text-2xl font-800">Class done.</h1>
      <p className="mt-1 text-center text-[var(--text-muted)]">
        You made something today.
      </p>

      <div className="mt-6 rounded-[var(--radius-lg)] border border-[var(--border)] bg-[var(--surface)] p-5">
        <p className="text-xs font-700 uppercase tracking-wide text-[var(--text-muted)]">
          Today you
        </p>
        <ul className="mt-3 flex flex-col gap-2.5">
          {verbs.map((v, i) => (
            <li key={i} className="flex items-start gap-2.5 font-600">
              <span
                className="mt-0.5 grid h-5 w-5 flex-none place-items-center rounded-full text-xs"
                style={{ background: "var(--success)", color: "var(--success-ink)" }}
              >
                ✓
              </span>
              {v}
            </li>
          ))}
        </ul>
      </div>

      {lesson.tomorrow && (
        <div className="mt-4 rounded-[var(--radius-md)] border border-[var(--border)] bg-[var(--surface-2)] p-4">
          <p className="text-xs font-700 uppercase tracking-wide text-[var(--text-muted)]">
            Tomorrow
          </p>
          <p className="mt-1 font-700">{lesson.tomorrow}</p>
        </div>
      )}

      <button
        onClick={() => {
          // refresh() invalidates the client router cache so home re-reads
          // progress from the DB — the finished class dims, the next one
          // lights up. A plain <Link> could show a stale snapshot.
          router.refresh();
          router.push("/");
        }}
        className="mt-auto block w-full rounded-[var(--radius-pill)] py-4 text-center text-lg font-800 active:scale-[0.99]"
        style={{ background: "var(--accent)", color: "var(--accent-ink)" }}
      >
        Back to home
      </button>
    </div>
  );
}
