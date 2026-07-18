"use client";

import { useState } from "react";
import type { SelectBeat as SelectBeatConfig } from "@/lib/beats";

interface Props {
  beat: SelectBeatConfig;
  onSolved: () => void;
}

/**
 * select — tap 1-of-N to predict/quiz (PRD §5).
 * Feedback reveals *why*, not just right/wrong. A wrong tap explains the miss
 * kindly and lets the student try again; the right tap unlocks Continue.
 */
export default function SelectBeat({ beat, onSolved }: Props) {
  const [picked, setPicked] = useState<string | null>(null);
  const [solved, setSolved] = useState(false);

  const choose = (id: string) => {
    if (solved) return;
    setPicked(id);
    if (id === beat.correct) {
      setSolved(true);
      window.setTimeout(onSolved, 450);
    }
  };

  return (
    <div className="flex h-full flex-col gap-5">
      <p className="text-lg font-700 leading-snug">{beat.question}</p>

      <div className="flex flex-col gap-3">
        {beat.options.map((opt) => {
          const isPicked = picked === opt.id;
          const isCorrect = opt.id === beat.correct;
          const revealed = isPicked;
          const showAsCorrect = revealed && isCorrect;
          const showAsWrong = revealed && !isCorrect;

          return (
            <button
              key={opt.id}
              onClick={() => choose(opt.id)}
              disabled={solved && !isCorrect}
              className="rounded-[var(--radius-md)] border-2 p-4 text-left transition-[transform,border-color,background-color] duration-200 active:scale-[0.99]"
              style={{
                borderColor: showAsCorrect
                  ? "var(--success)"
                  : showAsWrong
                    ? "var(--danger)"
                    : "var(--border)",
                background: showAsCorrect
                  ? "rgba(74,222,128,0.10)"
                  : showAsWrong
                    ? "rgba(244,164,139,0.08)"
                    : "var(--surface)",
              }}
            >
              <span className="flex items-center gap-3">
                <span
                  className="grid h-6 w-6 flex-none place-items-center rounded-full text-sm font-800"
                  style={{
                    background: showAsCorrect
                      ? "var(--success)"
                      : showAsWrong
                        ? "var(--danger)"
                        : "var(--surface-2)",
                    color:
                      showAsCorrect || showAsWrong
                        ? "var(--accent-ink)"
                        : "var(--text-muted)",
                  }}
                >
                  {showAsCorrect ? "✓" : showAsWrong ? "!" : ""}
                </span>
                <span className="font-700">{opt.label}</span>
              </span>
              {revealed && (
                <span className="animate-rise mt-2.5 block pl-9 text-sm leading-snug text-[var(--text-muted)]">
                  {opt.explain}
                </span>
              )}
            </button>
          );
        })}
      </div>

      {picked && !solved && (
        <p className="text-center text-sm font-600 text-[var(--text-muted)]">
          Have another look — tap the one that fits.
        </p>
      )}
    </div>
  );
}
