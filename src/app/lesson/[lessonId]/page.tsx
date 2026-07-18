import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { getLesson } from "@/lib/lessons";
import LessonPlayer from "@/components/lesson/LessonPlayer";

export default async function LessonPage({
  params,
}: {
  params: Promise<{ lessonId: string }>;
}) {
  const { lessonId } = await params;
  const lesson = await getLesson(lessonId);
  if (!lesson) notFound();

  // Resume state: which beats this student already completed.
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const { data: progress } = await supabase
    .from("lesson_progress")
    .select("beats_done")
    .eq("user_id", user!.id)
    .eq("lesson_id", lessonId)
    .maybeSingle();

  const initialDone = Array.isArray(progress?.beats_done)
    ? (progress!.beats_done as string[])
    : [];

  return <LessonPlayer lesson={lesson} initialDone={initialDone} />;
}
