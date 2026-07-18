"use client";

import { useEffect } from "react";
import type { ReadBeat as ReadBeatConfig } from "@/lib/beats";

interface Props {
  beat: ReadBeatConfig;
  onSolved: () => void;
}

/**
 * read — the theory beat (learn before you do). Comfortable reading
 * typography, a highlighted "remember this" card, no gate: reading is never
 * blocked, Continue is available immediately. The interactive beats that
 * follow are what check understanding.
 */
export default function ReadBeat({ beat, onSolved }: Props) {
  // Theory has no puzzle to solve — unlock Continue right away.
  useEffect(() => {
    onSolved();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <div className="flex h-full flex-col">
      <article className="animate-rise">
        <h2
          className="text-2xl font-800 leading-snug"
          style={{ color: "var(--accent-strong)" }}
        >
          {beat.title}
        </h2>

        <div className="mt-4 flex flex-col gap-3.5">
          {beat.body.map((para, i) => (
            <p key={i} className="text-[17px] leading-relaxed text-[var(--text)]">
              {para}
            </p>
          ))}
        </div>

        {beat.keyPoints && beat.keyPoints.length > 0 && (
          <div
            className="mt-5 rounded-[var(--radius-lg)] border p-4"
            style={{
              borderColor: "var(--accent)",
              background: "rgba(255,106,61,0.08)",
            }}
          >
            <p className="text-xs font-800 uppercase tracking-wide text-[var(--accent-strong)]">
              Remember this
            </p>
            <ul className="mt-2.5 flex flex-col gap-2">
              {beat.keyPoints.map((point, i) => (
                <li key={i} className="flex items-start gap-2.5">
                  <span
                    className="mt-1 h-2 w-2 flex-none rounded-full"
                    style={{ background: "var(--accent)" }}
                  />
                  <span className="text-[15px] font-600 leading-snug">
                    {point}
                  </span>
                </li>
              ))}
            </ul>
          </div>
        )}
      </article>

      <p className="mt-auto pt-5 text-center text-xs text-[var(--text-muted)]">
        Take your time — the next step puts this into action.
      </p>
    </div>
  );
}
