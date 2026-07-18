import { createClient } from "@/lib/supabase/server";
import type { Beat, Lesson } from "@/lib/beats";

interface LessonRow {
  id: string;
  track: string;
  day: number;
  title: string;
  minutes: number;
  content: { beats: Beat[]; tomorrow?: string };
}

/** Map a DB row (JSONB content) into the Lesson shape the player renders. */
function rowToLesson(row: LessonRow): Lesson {
  return {
    id: row.id,
    track: row.track,
    day: row.day,
    title: row.title,
    minutes: row.minutes,
    beats: row.content.beats,
    tomorrow: row.content.tomorrow,
  };
}

/** Load a single published lesson from the DB, or null if not found. */
export async function getLesson(id: string): Promise<Lesson | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("lessons")
    .select("id, track, day, title, minutes, content")
    .eq("id", id)
    .eq("published", true)
    .maybeSingle();

  if (error || !data) return null;
  return rowToLesson(data as LessonRow);
}

/** All published lessons, ordered by day. Home partitions these by track. */
export async function getAllLessons(): Promise<Lesson[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("lessons")
    .select("id, track, day, title, minutes, content")
    .eq("published", true)
    .order("day", { ascending: true });

  if (error || !data) return [];
  return (data as LessonRow[]).map(rowToLesson);
}
