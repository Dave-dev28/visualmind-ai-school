import type { Lesson } from "@/lib/beats";

/**
 * Sequential unlocking: classes must be completed in order.
 * The learning path is Foundations (by day) → chosen track (by day).
 * A lesson is unlocked when every lesson before it is completed — so the
 * unlocked set is: all completed lessons (replayable) + the first incomplete.
 *
 * Pure function used by BOTH the home map (to render locks) and the lesson
 * page (server-side, so typing a URL can't skip ahead).
 */
export function unlockedIds(
  lessons: Lesson[],
  doneIds: Set<string>,
  track: string | null,
): Set<string> {
  const path = [
    ...lessons
      .filter((l) => l.track === "Foundations")
      .sort((a, b) => a.day - b.day),
    ...(track
      ? lessons.filter((l) => l.track === track).sort((a, b) => a.day - b.day)
      : []),
  ];

  const unlocked = new Set<string>();
  let previousAllDone = true;
  for (const lesson of path) {
    if (previousAllDone) unlocked.add(lesson.id);
    previousAllDone = previousAllDone && doneIds.has(lesson.id);
  }
  return unlocked;
}
