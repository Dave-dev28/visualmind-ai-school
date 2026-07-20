"use client";

import { useEffect, useRef, useState } from "react";
import type { Beat } from "@/lib/beats";

interface ChatMessage {
  role: "user" | "assistant";
  content: string;
}

interface Props {
  lessonId: string;
  lessonTitle: string;
  track: string;
  beat: Beat;
  /** Monotonic counter — bumped by the parent on every wrong attempt across
   * the whole lesson. This component (remounted fresh per beat via
   * key={beat.id}) captures its value at mount as a baseline and diffs
   * against it, so "wrong attempts on THIS beat" needs no reset wiring. */
  wrongAttemptTick: number;
  /** True once the current beat is solved — stops the stall timer. */
  solved: boolean;
}

/**
 * Tutor chat (PRD §F3) — scoped to the current beat. Opens on a manual tap,
 * or on a dismissible nudge from an event trigger (wrong_attempts >= 2, or a
 * 90s stall since this beat began). The nudge fires at most once per beat;
 * dismissing it (or opening the chat) doesn't bring it back, though the
 * floating button itself always opens the chat regardless.
 */
export default function TutorButton({
  lessonId,
  lessonTitle,
  track,
  beat,
  wrongAttemptTick,
  solved,
}: Props) {
  const [open, setOpen] = useState(false);
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [input, setInput] = useState("");
  const [sending, setSending] = useState(false);
  const listRef = useRef<HTMLDivElement>(null);

  // Baseline captured once at mount — this instance is fresh per beat, so
  // "wrong attempts on THIS beat" is just the tick's growth since mount.
  const [baselineTick] = useState(wrongAttemptTick);
  const wrongAttemptsHere = wrongAttemptTick - baselineTick;

  // Stall half of the trigger needs a timer; the wrong-attempt half is a
  // pure derivation below, so only the timer needs an effect.
  const [stalled, setStalled] = useState(false);
  const [dismissed, setDismissed] = useState(false);

  useEffect(() => {
    if (solved) return;
    const startedAt = Date.now();
    const id = setInterval(() => {
      if (Date.now() - startedAt >= 90_000) setStalled(true);
    }, 5_000);
    return () => clearInterval(id);
  }, [solved]);

  // Nudge fires once per beat (wrong_attempts >= 2 OR a 90s stall — PRD §F3),
  // never while the chat is already open, never after being dismissed once.
  const nudge = !dismissed && !open && !solved && (wrongAttemptsHere >= 2 || stalled);

  const openChat = () => {
    setOpen(true);
    setDismissed(true);
  };

  const dismissNudge = (e: React.MouseEvent) => {
    e.stopPropagation();
    setDismissed(true);
  };

  const send = async () => {
    const text = input.trim();
    if (!text || sending) return;
    setInput("");
    const history = messages;
    setMessages((m) => [...m, { role: "user", content: text }]);
    setSending(true);

    try {
      const res = await fetch("/api/tutor", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          lessonId,
          lessonTitle,
          track,
          beat,
          history,
          message: text,
        }),
      });
      const data = await res.json();
      setMessages((m) => [
        ...m,
        { role: "assistant", content: data.reply ?? "Sorry, could you try asking that again?" },
      ]);
    } catch {
      setMessages((m) => [
        ...m,
        {
          role: "assistant",
          content: "Having trouble connecting — check your data and try again.",
        },
      ]);
    } finally {
      setSending(false);
      requestAnimationFrame(() => {
        listRef.current?.scrollTo({ top: listRef.current.scrollHeight });
      });
    }
  };

  return (
    <>
      <div className="relative">
        {nudge && !open && (
          <button
            onClick={openChat}
            className="animate-rise absolute bottom-full right-0 mb-3 flex w-56 items-start gap-2 rounded-[var(--radius-md)] border border-[var(--border)] bg-[var(--surface)] p-3 text-left shadow-xl"
          >
            <span className="flex-1 text-sm font-700 leading-snug">
              Need a hand with this one?
            </span>
            <span
              onClick={dismissNudge}
              className="grid h-5 w-5 flex-none place-items-center rounded-full text-xs text-[var(--text-muted)]"
              aria-label="Dismiss"
            >
              ✕
            </span>
          </button>
        )}

        <button
          onClick={openChat}
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
      </div>

      {open && (
        <div
          className="fixed inset-0 z-50 flex items-end justify-center bg-black/50 p-4"
          onClick={() => setOpen(false)}
        >
          <div
            className="animate-rise flex w-full max-w-md flex-col rounded-[var(--radius-lg)] border border-[var(--border)] bg-[var(--surface)] p-4"
            style={{ maxHeight: "70dvh" }}
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center gap-3">
              <span className="grid h-10 w-10 flex-none place-items-center rounded-full bg-[var(--accent)] text-xl">
                💬
              </span>
              <div className="min-w-0">
                <p className="font-800">Your tutor</p>
                <p className="truncate text-xs text-[var(--text-muted)]">
                  Scoped to: {beat.prompt}
                </p>
              </div>
              <button
                onClick={() => setOpen(false)}
                className="ml-auto flex-none text-[var(--text-muted)]"
                aria-label="Close"
              >
                ✕
              </button>
            </div>

            <div
              ref={listRef}
              className="mt-3 flex-1 space-y-2.5 overflow-y-auto"
              style={{ minHeight: 120 }}
            >
              {messages.length === 0 && (
                <p className="rounded-[var(--radius-md)] bg-[var(--surface-2)] p-3 text-sm leading-snug text-[var(--text-muted)]">
                  Ask me anything about this step — I&apos;ll give you a hint,
                  not the answer. Try &quot;I don&apos;t get it&quot; or
                  &quot;explain it differently&quot;.
                </p>
              )}
              {messages.map((m, i) => (
                <div
                  key={i}
                  className={`max-w-[85%] rounded-[var(--radius-md)] px-3.5 py-2.5 text-sm leading-snug ${
                    m.role === "user" ? "ml-auto" : ""
                  }`}
                  style={{
                    background:
                      m.role === "user" ? "var(--accent)" : "var(--surface-2)",
                    color: m.role === "user" ? "var(--accent-ink)" : "var(--text)",
                  }}
                >
                  {m.content}
                </div>
              ))}
              {sending && (
                <div
                  className="max-w-[85%] rounded-[var(--radius-md)] px-3.5 py-2.5 text-sm text-[var(--text-muted)]"
                  style={{ background: "var(--surface-2)" }}
                >
                  Thinking…
                </div>
              )}
            </div>

            <div className="mt-3 flex gap-2">
              <input
                value={input}
                onChange={(e) => setInput(e.target.value)}
                onKeyDown={(e) => e.key === "Enter" && send()}
                placeholder="Ask a question…"
                className="flex-1 rounded-[var(--radius-pill)] border border-[var(--border)] bg-[var(--surface-2)] px-4 py-2.5 text-sm outline-none focus:border-[var(--accent)]"
              />
              <button
                onClick={send}
                disabled={sending || !input.trim()}
                className="flex-none rounded-[var(--radius-pill)] px-4 py-2.5 text-sm font-800 disabled:opacity-40"
                style={{ background: "var(--accent)", color: "var(--accent-ink)" }}
              >
                Send
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
