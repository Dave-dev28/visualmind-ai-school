import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { getAllLessons } from "@/lib/lessons";
import type { Lesson } from "@/lib/beats";

/**
 * Home (PRD §7.1) — one dominant thing: the next step in the journey.
 * Journey: Foundations (everyone) → choose a path → track lessons.
 * No scores anywhere (they stay hidden until Friday).
 */
export default async function Home() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const [{ data: profile }, lessons, { data: progressRows }] =
    await Promise.all([
      supabase
        .from("profiles")
        .select("display_name, credits, track")
        .eq("id", user!.id)
        .maybeSingle(),
      getAllLessons(),
      supabase
        .from("lesson_progress")
        .select("lesson_id, completed")
        .eq("user_id", user!.id),
    ]);

  const doneIds = new Set(
    (progressRows ?? []).filter((r) => r.completed).map((r) => r.lesson_id),
  );

  const foundations = lessons
    .filter((l) => l.track === "Foundations")
    .sort((a, b) => a.day - b.day);
  const trackLessons = profile?.track
    ? lessons
        .filter((l) => l.track === profile.track)
        .sort((a, b) => a.day - b.day)
    : [];

  const nextFoundation = foundations.find((l) => !doneIds.has(l.id));
  const foundationsDone = foundations.length > 0 && !nextFoundation;
  const nextTrackLesson = trackLessons.find((l) => !doneIds.has(l.id));

  const firstName = (profile?.display_name || "").split(" ")[0] || "there";

  // What's the one dominant thing right now?
  let hero: React.ReactNode;
  if (nextFoundation) {
    hero = (
      <HeroLesson
        lesson={nextFoundation}
        kicker={`Basics · class ${nextFoundation.day} of ${foundations.length} · everyone starts here`}
      />
    );
  } else if (foundationsDone && !profile?.track) {
    hero = (
      <Link
        href="/choose-path"
        className="mt-6 block overflow-hidden rounded-[var(--radius-lg)] border-2 border-[var(--accent)] active:scale-[0.99]"
        style={{
          background:
            "radial-gradient(120% 100% at 0% 0%, rgba(255,106,61,0.25), var(--surface))",
        }}
      >
        <div className="p-6">
          <p className="text-xs font-700 uppercase tracking-wide text-[var(--accent-strong)]">
            Basics complete ✓
          </p>
          <p className="mt-2 text-2xl font-800 leading-tight">
            Time to choose your path. 🎬💻
          </p>
          <p className="mt-1 text-[var(--text-muted)]">
            AI Video &amp; Cinema, or Build Apps with AI — pick what you&apos;ll
            master.
          </p>
          <span
            className="mt-5 inline-block rounded-[var(--radius-pill)] px-5 py-3 text-base font-800"
            style={{ background: "var(--accent)", color: "var(--accent-ink)" }}
          >
            Choose my path →
          </span>
        </div>
      </Link>
    );
  } else if (nextTrackLesson) {
    hero = (
      <HeroLesson
        lesson={nextTrackLesson}
        kicker={`Today · ${nextTrackLesson.track}`}
      />
    );
  } else {
    hero = (
      <div className="mt-6 rounded-[var(--radius-lg)] border border-[var(--border)] bg-[var(--surface)] p-6">
        <p className="text-2xl font-800">You&apos;re all caught up. 🌟</p>
        <p className="mt-1 text-[var(--text-muted)]">
          {profile?.track
            ? `New ${profile.track} classes drop soon — David is building the next one.`
            : "New classes drop soon."}
        </p>
      </div>
    );
  }

  return (
    <main className="app-aura mx-auto flex min-h-dvh w-full max-w-md flex-col px-5 pb-10 pt-[max(1.5rem,env(safe-area-inset-top))]">
      <header className="flex items-center justify-between gap-3">
        <div>
          <p className="text-sm font-600 text-[var(--text-muted)]">AI School</p>
          <h1 className="text-2xl font-800">
            Hey {firstName} — ready to make something?
          </h1>
        </div>
        <div
          className="flex flex-none items-center gap-1.5 rounded-[var(--radius-pill)] px-3 py-1.5 text-sm font-800"
          style={{ background: "var(--surface)", color: "var(--accent-strong)" }}
          title="Your creation credits"
        >
          ⚡ <span>{profile?.credits ?? 0}</span>
        </div>
      </header>

      {hero}

      {/* Lesson map — the Foundations journey, then the chosen path */}
      <p className="mt-8 text-xs font-700 uppercase tracking-wide text-[var(--text-muted)]">
        Your journey
      </p>
      <div className="mt-3 flex flex-col gap-2">
        {foundations.map((l) => (
          <MapRow
            key={l.id}
            lesson={l}
            done={doneIds.has(l.id)}
            active={nextFoundation?.id === l.id}
          />
        ))}
        <div
          className="flex items-center gap-3 rounded-[var(--radius-md)] px-4 py-3"
          style={{
            background: foundationsDone ? "var(--surface-2)" : "var(--surface)",
            opacity: foundationsDone ? 1 : 0.55,
          }}
        >
          <span className="text-lg">🎯</span>
          <span className="text-sm font-700">
            {profile?.track ? (
              <>
                Path chosen: {profile.track}{" "}
                <Link
                  href="/choose-path"
                  className="ml-1 text-xs font-600 text-[var(--text-muted)] underline"
                >
                  change
                </Link>
              </>
            ) : (
              "Choose your path"
            )}
          </span>
        </div>
        {trackLessons.map((l) => (
          <MapRow
            key={l.id}
            lesson={l}
            done={doneIds.has(l.id)}
            active={nextTrackLesson?.id === l.id && !nextFoundation}
          />
        ))}
      </div>

      <p className="mt-auto pt-8 text-center text-xs text-[var(--text-muted)]">
        Scores stay hidden until Friday.
      </p>
    </main>
  );
}

function HeroLesson({ lesson, kicker }: { lesson: Lesson; kicker: string }) {
  return (
    <Link
      href={`/lesson/${lesson.id}`}
      className="mt-6 block overflow-hidden rounded-[var(--radius-lg)] border border-[var(--border)] active:scale-[0.99]"
      style={{
        background:
          "radial-gradient(120% 100% at 0% 0%, rgba(255,106,61,0.18), var(--surface))",
      }}
    >
      <div className="p-6">
        <p className="text-xs font-700 uppercase tracking-wide text-[var(--accent-strong)]">
          {kicker}
        </p>
        <p className="mt-2 text-2xl font-800 leading-tight">{lesson.title}</p>
        <p className="mt-1 text-[var(--text-muted)]">
          {lesson.beats.length} quick steps · about {lesson.minutes} min
        </p>
        <span
          className="mt-5 inline-block rounded-[var(--radius-pill)] px-5 py-3 text-base font-800"
          style={{ background: "var(--accent)", color: "var(--accent-ink)" }}
        >
          Start this class →
        </span>
      </div>
    </Link>
  );
}

function MapRow({
  lesson,
  done,
  active,
}: {
  lesson: Lesson;
  done: boolean;
  active: boolean;
}) {
  return (
    <Link
      href={`/lesson/${lesson.id}`}
      className="flex items-center gap-3 rounded-[var(--radius-md)] px-4 py-3 transition-transform active:scale-[0.99]"
      style={{
        background: active ? "rgba(255,106,61,0.12)" : "var(--surface)",
        outline: active ? "2px solid var(--accent)" : "none",
        // Finished classes fade back — progress is visible at a glance and
        // the eye lands on the highlighted next class. Still tappable to replay.
        opacity: done ? 0.45 : 1,
        filter: done ? "saturate(0.6)" : "none",
      }}
    >
      <span
        className="grid h-7 w-7 flex-none place-items-center rounded-full text-sm font-800"
        style={{
          background: done ? "var(--success)" : "var(--surface-2)",
          color: done ? "var(--success-ink)" : "var(--text-muted)",
        }}
      >
        {done ? "✓" : lesson.day}
      </span>
      <span className="min-w-0">
        <span
          className="block truncate text-sm font-700"
          style={{
            textDecoration: done ? "line-through" : "none",
            textDecorationColor: "var(--text-muted)",
          }}
        >
          {lesson.title}
        </span>
        <span className="block text-xs text-[var(--text-muted)]">
          {done ? "Done · tap to replay" : `${lesson.track} · ${lesson.minutes} min`}
        </span>
      </span>
    </Link>
  );
}
