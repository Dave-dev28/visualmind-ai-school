"use client";

import { useState } from "react";
import type { TypeAnswerBeat as TypeAnswerBeatConfig } from "@/lib/beats";

interface Props {
  beat: TypeAnswerBeatConfig;
  onSolved: () => void;
  /** Fires on each miss — feeds the tutor's trigger rule. */
  onWrongAttempt?: () => void;
}

type Status = "idle" | "missed" | "revealed" | "solved";

/**
 * type_answer — short free answer, concept-checked (PRD §5).
 * v1 check = keyword-group rubric (does the answer touch the key ideas?),
 * swapped for an LLM concept-check when the tutor ships. Kind phrasing on a
 * miss; second miss reveals a model answer and lets the student continue —
 * never a red-X wall.
 */
export default function TypeAnswerBeat({ beat, onSolved, onWrongAttempt }: Props) {
  const [answer, setAnswer] = useState("");
  const [status, setStatus] = useState<Status>("idle");
  const [misses, setMisses] = useState(0);

  const matchedGroups = (text: string) => {
    const norm = text.toLowerCase().replace(/[^\p{L}\p{N}\s]/gu, " ");
    return beat.keywords.filter((group) =>
      group.some((kw) => norm.includes(kw.toLowerCase())),
    ).length;
  };

  const check = () => {
    if (status === "solved" || status === "revealed") return;
    if (matchedGroups(answer) >= beat.minMatches) {
      setStatus("solved");
      window.setTimeout(onSolved, 450);
      return;
    }
    const next = misses + 1;
    setMisses(next);
    onWrongAttempt?.();
    if (next >= 2) {
      // Show a model answer and let them move on — comparing is the lesson.
      setStatus("revealed");
      window.setTimeout(onSolved, 300);
    } else {
      setStatus("missed");
    }
  };

  const tooShort = answer.trim().length < 10;

  return (
    <div className="flex h-full flex-col gap-4">
      <p className="text-lg font-700 leading-snug">{beat.question}</p>

      <textarea
        value={answer}
        onChange={(e) => {
          setAnswer(e.target.value);
          if (status === "missed") setStatus("idle");
        }}
        rows={4}
        placeholder="Your own words — no big grammar needed."
        disabled={status === "solved" || status === "revealed"}
        className="w-full resize-none rounded-[var(--radius-md)] border border-[var(--border)] bg-[var(--surface)] p-4 text-base font-600 leading-snug text-[var(--text)] outline-none transition-colors focus:border-[var(--accent)]"
      />

      {status === "missed" && (
        <div className="animate-rise rounded-[var(--radius-md)] border border-[var(--border)] bg-[var(--surface-2)] p-3.5 text-sm leading-snug">
          <p className="font-700 text-[var(--accent-strong)]">
            Good try — you&apos;re close.
          </p>
          <p className="mt-1 text-[var(--text-muted)]">{beat.hint}</p>
        </div>
      )}

      {status === "solved" && (
        <div className="animate-rise rounded-[var(--radius-md)] border p-3.5 text-sm leading-snug"
          style={{ borderColor: "var(--success)", background: "rgba(74,222,128,0.08)" }}>
          <p className="font-700" style={{ color: "var(--success)" }}>
            You nailed the idea. 🎯
          </p>
        </div>
      )}

      {status === "revealed" && (
        <div className="animate-rise rounded-[var(--radius-md)] border border-[var(--border)] bg-[var(--surface-2)] p-3.5 text-sm leading-snug">
          <p className="font-700 text-[var(--accent-strong)]">
            Here&apos;s one good way to put it:
          </p>
          <p className="mt-1.5 text-[var(--text)]">“{beat.sampleAnswer}”</p>
          <p className="mt-2 text-[var(--text-muted)]">
            Compare it with yours, then continue — you&apos;re learning, not
            being graded.
          </p>
        </div>
      )}

      <div className="mt-auto">
        {status !== "solved" && status !== "revealed" && (
          <button
            onClick={check}
            disabled={tooShort}
            className="w-full rounded-[var(--radius-pill)] border-2 py-3.5 font-800 transition-all active:scale-[0.99] disabled:opacity-40"
            style={{ borderColor: "var(--accent)", color: "var(--accent-strong)" }}
          >
            {tooShort ? "Write a little more…" : "Check my answer"}
          </button>
        )}
      </div>
    </div>
  );
}
