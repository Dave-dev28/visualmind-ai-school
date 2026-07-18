"use client";

import { useEffect, useRef, useState } from "react";
import Link from "next/link";
import type { Beat, Lesson } from "@/lib/beats";
import { createClient } from "@/lib/supabase/client";
import DragSortBeat from "@/components/beats/DragSortBeat";
import SelectBeat from "@/components/beats/SelectBeat";
import LeverBeat from "@/components/beats/LeverBeat";
import WatchBeat from "@/components/beats/WatchBeat";
import TypeAnswerBeat from "@/components/beats/TypeAnswerBeat";
import BeatImage from "@/components/beats/BeatImage";
import ReadBeat from "@/components/beats/ReadBeat";
import ProgressDots from "./ProgressDots";
import TutorButton from "./TutorButton";
import RecapScreen from "./RecapScreen";

/** A concrete "Today you…" verb per beat, for the recap (PRD §F2). */
function recapVerb(beat: Beat): string {
  switch (beat.type) {
    case "read":
      return `Learned: ${beat.title}`;
    case "drag_sort":
      return `Sorted ${beat.items.length} cards into the right groups`;
    case "select":
      return "Made a prediction and saw exactly why";
    case "lever":
      return "Pulled a lever and watched the outcome change";
    case "watch":
      return `Watched: ${beat.source}`;
    case "type_answer":
      return "Explained an idea in your own words";
  }
}

export default function LessonPlayer({
  lesson,
  initialDone = [],
}: {
  lesson: Lesson;
  initialDone?: string[];
}) {
  const supabase = createClient();
  const total = lesson.beats.length;

  const [done, setDone] = useState<boolean[]>(() =>
    lesson.beats.map((b) => initialDone.includes(b.id)),
  );
  // Start on the first not-yet-done beat so returning students resume.
  const [index, setIndex] = useState(() => {
    const firstUndone = lesson.beats.findIndex(
      (b) => !initialDone.includes(b.id),
    );
    return firstUndone === -1 ? 0 : firstUndone;
  });
  const [showRecap, setShowRecap] = useState(false);
  const userId = useRef<string | null>(null);

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => {
      userId.current = data.user?.id ?? null;
    });
  }, [supabase]);

  const saveProgress = (doneFlags: boolean[], completed: boolean) => {
    if (!userId.current) return;
    const beatsDone = lesson.beats
      .filter((b, i) => doneFlags[i])
      .map((b) => b.id);
    // Fire-and-forget upsert; UI never waits on the network.
    void supabase.from("lesson_progress").upsert(
      {
        user_id: userId.current,
        lesson_id: lesson.id,
        beats_done: beatsDone,
        completed,
        updated_at: new Date().toISOString(),
      },
      { onConflict: "user_id,lesson_id" },
    );
  };

  const beat = lesson.beats[index];
  const currentDone = done[index];
  const isLast = index === total - 1;

  const markSolved = () =>
    setDone((d) => {
      if (d[index]) return d;
      const next = [...d];
      next[index] = true;
      saveProgress(next, next.every(Boolean));
      return next;
    });

  const advance = () => {
    if (isLast) {
      setShowRecap(true);
      saveProgress(done, true);
    } else {
      setIndex((i) => i + 1);
    }
  };

  if (showRecap) {
    return (
      <main className="app-aura mx-auto flex min-h-dvh w-full max-w-md flex-col px-5 pb-6 pt-[max(1rem,env(safe-area-inset-top))]">
        <RecapScreen lesson={lesson} verbs={lesson.beats.map(recapVerb)} />
      </main>
    );
  }

  return (
    <main className="app-aura relative mx-auto flex min-h-dvh w-full max-w-md flex-col px-5 pb-6 pt-[max(0.75rem,env(safe-area-inset-top))]">
      <header className="flex flex-col gap-3">
        <div className="flex items-center gap-3">
          <Link
            href="/"
            className="grid h-9 w-9 flex-none place-items-center rounded-full bg-[var(--surface)] text-[var(--text-muted)] active:scale-95"
            aria-label="Leave lesson"
          >
            ✕
          </Link>
          <ProgressDots total={total} current={index} done={done} />
        </div>
        <p className="text-sm font-600 text-[var(--text-muted)]">
          Day {lesson.day} · {lesson.title}
        </p>
      </header>

      <section className="flex flex-1 flex-col pt-5" key={beat.id}>
        <p className="animate-rise mb-5 text-xl font-800 leading-snug">
          {beat.prompt}
        </p>
        {beat.image && <BeatImage image={beat.image} />}
        <div className="flex flex-1 flex-col">
          {beat.type === "read" && (
            <ReadBeat beat={beat} onSolved={markSolved} />
          )}
          {beat.type === "drag_sort" && (
            <DragSortBeat beat={beat} onSolved={markSolved} />
          )}
          {beat.type === "select" && (
            <SelectBeat beat={beat} onSolved={markSolved} />
          )}
          {beat.type === "lever" && (
            <LeverBeat beat={beat} onSolved={markSolved} />
          )}
          {beat.type === "watch" && (
            <WatchBeat beat={beat} onSolved={markSolved} />
          )}
          {beat.type === "type_answer" && (
            <TypeAnswerBeat beat={beat} onSolved={markSolved} />
          )}
        </div>
      </section>

      <div className="pt-4">
        <button
          onClick={advance}
          disabled={!currentDone}
          className="w-full rounded-[var(--radius-pill)] py-4 text-lg font-800 transition-all duration-200 disabled:opacity-40"
          style={{
            background: currentDone ? "var(--accent)" : "var(--surface-2)",
            color: currentDone ? "var(--accent-ink)" : "var(--text-muted)",
          }}
        >
          {isLast ? "Finish class" : "Continue"}
        </button>
      </div>

      <div className="pointer-events-none fixed inset-x-0 bottom-24 z-40 mx-auto flex w-full max-w-md justify-end px-5">
        <div className="pointer-events-auto">
          <TutorButton beatPrompt={beat.prompt} />
        </div>
      </div>
    </main>
  );
}
