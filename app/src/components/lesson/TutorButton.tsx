"use client";

import { useState } from "react";

interface Props {
  /** Context line for the current beat — the real tutor will use this as scope. */
  beatPrompt: string;
}

/**
 * Floating tutor button (PRD §F3). In the design-lock milestone this is a
 * stub: it opens a scoped panel but does not call the LLM yet. The real
 * behavior (event triggers: N wrong / stall, hint-first chat) lands in the
 * tutor build step. This proves placement + the "never forced" interaction.
 */
export default function TutorButton({ beatPrompt }: Props) {
  const [open, setOpen] = useState(false);

  return (
    <>
      <button
        onClick={() => setOpen(true)}
        className="grid h-14 w-14 place-items-center rounded-full text-2xl shadow-xl transition-transform active:scale-95"
        style={{
          background: "var(--accent)",
          color: "var(--accent-ink)",
          boxShadow: "0 8px 24px rgba(255,106,61,0.4)",
        }}
        aria-label="Ask the tutor"
      >
        💬
      </button>

      {open && (
        <div
          className="fixed inset-0 z-50 flex items-end justify-center bg-black/50 p-4"
          onClick={() => setOpen(false)}
        >
          <div
            className="animate-rise w-full max-w-md rounded-[var(--radius-lg)] border border-[var(--border)] bg-[var(--surface)] p-5"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center gap-3">
              <span className="grid h-10 w-10 place-items-center rounded-full bg-[var(--accent)] text-xl">
                💬
              </span>
              <div>
                <p className="font-800">Need a hand with this one?</p>
                <p className="text-xs text-[var(--text-muted)]">
                  Your tutor · scoped to this step
                </p>
              </div>
            </div>

            <p className="mt-4 rounded-[var(--radius-md)] bg-[var(--surface-2)] p-3 text-sm leading-snug text-[var(--text-muted)]">
              I&apos;ll give you a hint first — never the whole answer. (Live chat
              connects in the tutor build step.)
              <br />
              <span className="mt-2 block text-[var(--text)]">
                This step: “{beatPrompt}”
              </span>
            </p>

            <button
              onClick={() => setOpen(false)}
              className="mt-4 w-full rounded-[var(--radius-pill)] bg-[var(--surface-2)] py-3 font-700 text-[var(--text)] active:scale-[0.99]"
            >
              I&apos;ve got it — close
            </button>
          </div>
        </div>
      )}
    </>
  );
}
