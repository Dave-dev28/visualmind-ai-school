"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

const TRACKS = [
  {
    id: "AI Video & Cinema",
    emoji: "🎬",
    accent: "#ff6a3d",
    title: "AI Video & Cinema",
    blurb:
      "Direct the camera with words. Make real AI images and film clips — shot types, motion, lighting, storytelling.",
    makes: "You'll make: cinematic clips, ad-style visuals, your own short films.",
  },
  {
    id: "Build Apps with AI",
    emoji: "💻",
    accent: "#4ade80",
    title: "Build Apps with AI",
    blurb:
      "Turn ideas into working software by directing AI — no computer-science degree needed. This school itself was built this way.",
    makes: "You'll make: real working apps and tools you can show (and sell).",
  },
] as const;

/**
 * Choose-path (PRD §F1.4) — after Foundations, the student picks a track.
 * Two big cards with what students make; more paths teased to measure demand.
 */
export default function ChoosePathPage() {
  const router = useRouter();
  const supabase = createClient();
  const [busy, setBusy] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const pick = async (trackId: string) => {
    setBusy(trackId);
    setError(null);
    const { data, error } = await supabase.rpc("choose_track", {
      p_track: trackId,
    });
    if (error || data !== "ok") {
      setError("Couldn't save your choice — try again in a moment.");
      setBusy(null);
      return;
    }
    router.replace("/");
    router.refresh();
  };

  return (
    <main className="app-aura mx-auto flex min-h-dvh w-full max-w-md flex-col px-5 pb-10 pt-[max(1.5rem,env(safe-area-inset-top))]">
      <header>
        <p className="text-sm font-600 text-[var(--accent-strong)]">
          Basics done ✓ — big moment
        </p>
        <h1 className="mt-1 text-3xl font-800 leading-tight">
          Choose your path.
        </h1>
        <p className="mt-2 text-[var(--text-muted)]">
          Both paths use everything you just learned. Pick the one that makes
          you feel something — you can talk to David if you&apos;re torn.
        </p>
      </header>

      <div className="mt-6 flex flex-col gap-4">
        {TRACKS.map((t) => (
          <button
            key={t.id}
            onClick={() => pick(t.id)}
            disabled={busy !== null}
            className="animate-rise rounded-[var(--radius-lg)] border-2 p-5 text-left transition-transform active:scale-[0.99] disabled:opacity-60"
            style={{
              borderColor: t.accent,
              background: `radial-gradient(130% 110% at 0% 0%, ${t.accent}22, var(--surface))`,
            }}
          >
            <span className="text-3xl">{t.emoji}</span>
            <p className="mt-2 text-xl font-800">{t.title}</p>
            <p className="mt-1.5 text-sm leading-snug text-[var(--text-muted)]">
              {t.blurb}
            </p>
            <p className="mt-2.5 text-sm font-700" style={{ color: t.accent }}>
              {t.makes}
            </p>
            <span
              className="mt-4 inline-block rounded-[var(--radius-pill)] px-4 py-2 text-sm font-800"
              style={{ background: t.accent, color: "var(--accent-ink)" }}
            >
              {busy === t.id ? "Saving…" : `Start this path →`}
            </span>
          </button>
        ))}

        <div className="rounded-[var(--radius-lg)] border border-dashed border-[var(--border)] bg-[var(--surface)] p-5 opacity-70">
          <span className="text-2xl">✨</span>
          <p className="mt-2 font-800 text-[var(--text-muted)]">
            More paths coming soon
          </p>
          <p className="mt-1 text-sm text-[var(--text-muted)]">
            AI for ads &amp; marketing, websites &amp; landing pages, and more.
          </p>
        </div>
      </div>

      {error && (
        <p className="mt-4 rounded-[var(--radius-sm)] bg-[rgba(244,164,139,0.1)] px-3 py-2 text-sm font-600 text-[var(--danger)]">
          {error}
        </p>
      )}
    </main>
  );
}
