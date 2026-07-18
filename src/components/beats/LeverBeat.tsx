"use client";

import { useState } from "react";
import type { LeverBeat as LeverBeatConfig } from "@/lib/beats";

interface Props {
  beat: LeverBeatConfig;
  onSolved: () => void;
}

/**
 * lever — drag a slider and watch the outcome change live (PRD §5).
 * The reward is the live visual change + the "found it" moment when the
 * student lands on the target state. Snaps to discrete notches.
 */
export default function LeverBeat({ beat, onSolved }: Props) {
  const last = beat.states.length - 1;
  const [pos, setPos] = useState(0);
  const [solved, setSolved] = useState(false);
  const [touched, setTouched] = useState(false);
  // Per-state visual narration images that failed to load (not added yet) —
  // those states fall back to the built-in animated preview.
  const [failedImages, setFailedImages] = useState<Set<string>>(new Set());

  const onTarget = pos === beat.target;
  const state = beat.states[pos];

  const settle = (value: number) => {
    const clamped = Math.max(0, Math.min(last, value));
    setPos(clamped);
    setTouched(true);
    if (clamped === beat.target && !solved) {
      setSolved(true);
      window.setTimeout(onSolved, 650);
    }
  };

  // Map the slider's 0..last onto the live "camera" preview.
  const intensity = last === 0 ? 0 : pos / last;

  return (
    <div className="flex h-full flex-col gap-6">
      {/* Live preview — the outcome changes as the lever moves. When the
          current state has an authored image (visual narration), it IS the
          preview; otherwise the built-in animated preview shows. */}
      <div
        className="relative grid place-items-center overflow-hidden rounded-[var(--radius-lg)] border border-[var(--border)] transition-colors duration-200"
        style={{
          minHeight: 190,
          background:
            "radial-gradient(120% 90% at 50% 30%, var(--surface-2), var(--surface))",
        }}
      >
        {state.image && !failedImages.has(state.image) ? (
          /* eslint-disable-next-line @next/next/no-img-element */
          <img
            key={state.image}
            src={state.image}
            alt={state.label}
            onError={() =>
              setFailedImages((s) => new Set(s).add(state.image!))
            }
            className="animate-pop absolute inset-0 h-full w-full object-cover"
          />
        ) : (
          <div
            className="grid place-items-center rounded-full transition-transform duration-300 ease-out"
            style={{
              width: 96,
              height: 96,
              background:
                "radial-gradient(circle at 40% 35%, var(--accent-strong), var(--accent))",
              transform: `scale(${1 + intensity * 0.9})`,
              boxShadow: `0 0 ${20 + intensity * 60}px rgba(255,106,61,${
                0.25 + intensity * 0.4
              })`,
            }}
          >
            <span className="text-3xl" aria-hidden>
              🎬
            </span>
          </div>
        )}
        <div
          className="pointer-events-none absolute inset-3 rounded-[var(--radius-md)] border transition-colors duration-200"
          style={{ borderColor: onTarget ? "var(--accent)" : "transparent" }}
        />
      </div>

      {/* Preload every state visual so pulling the lever swaps instantly */}
      <div className="hidden" aria-hidden>
        {beat.states
          .filter((s) => s.image)
          .map((s) => (
            /* eslint-disable-next-line @next/next/no-img-element */
            <img key={s.image} src={s.image} alt="" />
          ))}
      </div>

      {/* State readout */}
      <div
        className="animate-rise rounded-[var(--radius-md)] border p-4 transition-colors duration-200"
        key={pos}
        style={{
          background: onTarget ? "rgba(255,106,61,0.10)" : "var(--surface)",
          borderColor: onTarget ? "var(--accent)" : "var(--border)",
        }}
      >
        <p className="text-lg font-800" style={{ color: "var(--accent-strong)" }}>
          {state.label}
        </p>
        <p className="mt-1 text-sm leading-snug text-[var(--text-muted)]">
          {state.description}
        </p>
      </div>

      {/* The lever */}
      <div className="mt-auto">
        <input
          type="range"
          min={0}
          max={last}
          step={1}
          value={pos}
          onChange={(e) => settle(Number(e.target.value))}
          className="ai-lever w-full"
          aria-label="Camera movement lever"
          style={{
            background: `linear-gradient(to right, var(--accent) 0%, var(--accent) ${
              intensity * 100
            }%, var(--surface-2) ${intensity * 100}%, var(--surface-2) 100%)`,
          }}
        />
        <div className="mt-1 flex justify-between text-xs font-600 text-[var(--text-muted)]">
          <span>{beat.minLabel}</span>
          <span>{beat.maxLabel}</span>
        </div>
        <p className="mt-3 min-h-5 text-center text-sm font-700">
          {solved ? (
            <span style={{ color: "var(--accent-strong)" }}>
              That&apos;s the one — you found it. 🎯
            </span>
          ) : touched ? (
            <span className="text-[var(--text-muted)]">
              Keep going until it feels slow and emotional…
            </span>
          ) : (
            <span className="text-[var(--text-muted)]">
              Slide the lever and watch it change.
            </span>
          )}
        </p>
      </div>

      <style jsx>{`
        .ai-lever {
          -webkit-appearance: none;
          appearance: none;
          height: 14px;
          border-radius: var(--radius-pill);
          outline: none;
        }
        .ai-lever::-webkit-slider-thumb {
          -webkit-appearance: none;
          appearance: none;
          width: 34px;
          height: 34px;
          border-radius: 50%;
          background: var(--text);
          border: 4px solid var(--accent);
          box-shadow: 0 4px 14px rgba(0, 0, 0, 0.45);
          cursor: grab;
        }
        .ai-lever::-webkit-slider-thumb:active {
          cursor: grabbing;
          transform: scale(1.08);
        }
        .ai-lever::-moz-range-thumb {
          width: 34px;
          height: 34px;
          border-radius: 50%;
          background: var(--text);
          border: 4px solid var(--accent);
          box-shadow: 0 4px 14px rgba(0, 0, 0, 0.45);
          cursor: grab;
        }
      `}</style>
    </div>
  );
}
