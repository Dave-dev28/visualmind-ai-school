import { notFound, redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { getAllLessons } from "@/lib/lessons";
import { unlockedIds } from "@/lib/unlock";
import LessonPlayer from "@/components/lesson/LessonPlayer";

export default async function LessonPage({
  params,
}: {
  params: Promise<{ lessonId: string }>;
}) {
  const { lessonId } = await params;

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const [lessons, { data: profile }, { data: progressRows }] =
    await Promise.all([
      getAllLessons(),
      supabase
        .from("profiles")
        .select("track")
        .eq("id", user!.id)
        .maybeSingle(),
      supabase
        .from("lesson_progress")
        .select("lesson_id, beats_done, completed")
        .eq("user_id", user!.id),
    ]);

  const lesson = lessons.find((l) => l.id === lessonId);
  if (!lesson) notFound();

  // Sequential lock, enforced server-side: a class only opens when every
  // class before it is complete. Locked URL → straight back home.
  const doneIds = new Set(
    (progressRows ?? []).filter((r) => r.completed).map((r) => r.lesson_id),
  );
  if (!unlockedIds(lessons, doneIds, profile?.track ?? null).has(lessonId)) {
    redirect("/");
  }

  // Resume state: which beats this student already completed.
  const row = (progressRows ?? []).find((r) => r.lesson_id === lessonId);
  const initialDone = Array.isArray(row?.beats_done)
    ? (row.beats_done as string[])
    : [];

  return <LessonPlayer lesson={lesson} initialDone={initialDone} />;
}
