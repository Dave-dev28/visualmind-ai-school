"use client";

import { useRef, useState } from "react";
import type { DragSortBeat as DragSortBeatConfig } from "@/lib/beats";

type Assignments = Record<string, string | null>;

interface Props {
  beat: DragSortBeatConfig;
  onSolved: () => void;
}

/**
 * drag_sort — drag items into labeled buckets (PRD §5).
 *
 * Smoothness: the dragged card is a single fixed "ghost" element whose
 * transform is written directly to the DOM on every pointermove (no React
 * re-render per frame). State only changes on pick-up, bucket-hover-change,
 * and drop — a handful of renders per drag, not one per pixel.
 *
 * Feedback: correct drop snaps in; wrong drop shows kindly, then floats back.
 * Tap-to-select is the always-available fallback for touch.
 */
export default function DragSortBeat({ beat, onSolved }: Props) {
  const [assign, setAssign] = useState<Assignments>(() =>
    Object.fromEntries(beat.items.map((i) => [i.id, null])),
  );
  const [solved, setSolved] = useState(false);
  const [selected, setSelected] = useState<string | null>(null);
  const [hint, setHint] = useState<string | null>(null);
  const [draggingId, setDraggingId] = useState<string | null>(null);
  const [hoverBucket, setHoverBucket] = useState<string | null>(null);

  const ghostRef = useRef<HTMLDivElement>(null);
  // Mutable drag state that must NOT trigger re-renders.
  const drag = useRef<{ id: string; hover: string | null } | null>(null);
  const rafId = useRef<number | null>(null);

  const place = (itemId: string, bucketId: string) => {
    const isCorrect = beat.correct[itemId] === bucketId;
    setSelected(null);
    if (!isCorrect) {
      setAssign((a) => ({ ...a, [itemId]: bucketId }));
      setHint("Almost — that one belongs on a different shelf. Try again.");
      window.setTimeout(
        () => setAssign((a) => ({ ...a, [itemId]: null })),
        550,
      );
      return;
    }
    setHint(null);
    setAssign((a) => {
      const next = { ...a, [itemId]: bucketId };
      if (beat.items.every((i) => next[i.id] === beat.correct[i.id])) {
        setSolved(true);
        window.setTimeout(onSolved, 500);
      }
      return next;
    });
  };

  const bucketAtPoint = (x: number, y: number): string | null => {
    const el = document.elementFromPoint(x, y);
    return el?.closest<HTMLElement>("[data-bucket]")?.dataset.bucket ?? null;
  };

  const moveGhost = (x: number, y: number) => {
    const g = ghostRef.current;
    if (g) g.style.transform = `translate3d(${x}px, ${y}px, 0) translate(-50%, -50%) scale(1.05)`;
  };

  const onItemPointerDown = (e: React.PointerEvent, itemId: string) => {
    if (solved || assign[itemId]) return;
    (e.currentTarget as HTMLElement).setPointerCapture(e.pointerId);
    drag.current = { id: itemId, hover: null };
    setDraggingId(itemId);
    setSelected(itemId);
    moveGhost(e.clientX, e.clientY);
  };

  const onItemPointerMove = (e: React.PointerEvent) => {
    if (!drag.current) return;
    const { clientX: x, clientY: y } = e;
    // Position update runs on the animation frame — buttery, coalesced.
    if (rafId.current == null) {
      rafId.current = requestAnimationFrame(() => {
        rafId.current = null;
        moveGhost(x, y);
      });
    }
    const over = bucketAtPoint(x, y);
    if (over !== drag.current.hover) {
      drag.current.hover = over;
      setHoverBucket(over); // low-frequency: only on boundary crossings
    }
  };

  const endDrag = (e: React.PointerEvent) => {
    if (!drag.current) return;
    const target = bucketAtPoint(e.clientX, e.clientY);
    const id = drag.current.id;
    drag.current = null;
    if (rafId.current != null) {
      cancelAnimationFrame(rafId.current);
      rafId.current = null;
    }
    setDraggingId(null);
    setHoverBucket(null);
    if (target) place(id, target);
  };

  const draggingItem = beat.items.find((i) => i.id === draggingId) ?? null;
  const trayItems = beat.items.filter((i) => !assign[i.id]);

  return (
    <div className="flex h-full flex-col gap-5">
      {/* Buckets */}
      <div className="grid grid-cols-3 gap-3">
        {beat.buckets.map((bucket) => {
          const placed = beat.items.filter((i) => assign[i.id] === bucket.id);
          const isHover = hoverBucket === bucket.id;
          return (
            <button
              key={bucket.id}
              data-bucket={bucket.id}
              onClick={() => selected && place(selected, bucket.id)}
              className="flex min-h-40 flex-col rounded-[var(--radius-md)] border-2 border-dashed p-2.5 text-left transition-[border-color,background-color,transform] duration-150"
              style={{
                borderColor: isHover ? "var(--accent)" : "var(--border)",
                background: isHover ? "rgba(255,106,61,0.12)" : "var(--surface)",
                transform: isHover ? "scale(1.04)" : "scale(1)",
              }}
            >
              <span className="mb-2 text-sm font-700 text-[var(--text-muted)]">
                {bucket.label}
              </span>
              <span className="flex flex-1 flex-col gap-1.5">
                {placed.map((i) => (
                  <span
                    key={i.id}
                    className="animate-snap rounded-[var(--radius-sm)] bg-[var(--surface-2)] px-2 py-1.5 text-[13px] font-600 leading-tight text-[var(--text)]"
                  >
                    {i.label}
                  </span>
                ))}
              </span>
            </button>
          );
        })}
      </div>

      <p className="min-h-5 text-center text-sm font-600 text-[var(--danger)]">
        {hint}
      </p>

      {/* Tray */}
      <div className="mt-auto">
        <p className="mb-2 text-center text-xs font-600 uppercase tracking-wide text-[var(--text-muted)]">
          {selected && !draggingId
            ? "Now tap a shelf above"
            : "Drag a card up — or tap it, then tap a shelf"}
        </p>
        <div className="flex flex-wrap justify-center gap-2.5">
          {trayItems.map((item) => {
            const isDragging = draggingId === item.id;
            const isSelected = selected === item.id && !isDragging;
            return (
              <button
                key={item.id}
                onPointerDown={(e) => onItemPointerDown(e, item.id)}
                onPointerMove={onItemPointerMove}
                onPointerUp={endDrag}
                onPointerCancel={endDrag}
                onClick={() =>
                  setSelected((s) => (s === item.id ? null : item.id))
                }
                className="animate-pop touch-none select-none rounded-[var(--radius-md)] px-3.5 py-3 text-sm font-700 leading-tight shadow-lg transition-[opacity,transform] duration-150"
                style={{
                  background: isSelected ? "var(--accent)" : "var(--surface-2)",
                  color: isSelected ? "var(--accent-ink)" : "var(--text)",
                  border: "1px solid var(--border)",
                  // Source stays in the layout but hides while its ghost flies.
                  opacity: isDragging ? 0.25 : 1,
                }}
              >
                {item.label}
              </button>
            );
          })}
          {trayItems.length === 0 && !solved && (
            <span className="text-sm text-[var(--text-muted)]">
              Nice — checking your shelves…
            </span>
          )}
        </div>
      </div>

      {/* Single reused ghost — moved via direct DOM writes, never re-rendered */}
      <div
        ref={ghostRef}
        aria-hidden
        className="pointer-events-none fixed left-0 top-0 z-50 rounded-[var(--radius-md)] px-3.5 py-3 text-sm font-700 leading-tight shadow-2xl"
        style={{
          background: "var(--accent)",
          color: "var(--accent-ink)",
          border: "1px solid var(--accent-strong)",
          willChange: "transform",
          visibility: draggingItem ? "visible" : "hidden",
          transition: "none",
        }}
      >
        {draggingItem?.label ?? ""}
      </div>
    </div>
  );
}
