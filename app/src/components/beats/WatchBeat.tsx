"use client";

import { useState } from "react";
import type { WatchBeat as WatchBeatConfig } from "@/lib/beats";

interface Props {
  beat: WatchBeatConfig;
  onSolved: () => void;
}

/**
 * watch — short YouTube embed (PRD §5). Video complements the interaction,
 * never the spine. Uses the privacy-enhanced nocookie domain; YouTube handles
 * quality adaptation for low-data connections (PRD §8).
 */
export default function WatchBeat({ beat, onSolved }: Props) {
  const [confirmed, setConfirmed] = useState(false);

  const params = new URLSearchParams({ rel: "0", modestbranding: "1" });
  if (beat.start) params.set("start", String(beat.start));
  if (beat.end) params.set("end", String(beat.end));
  const src = `https://www.youtube-nocookie.com/embed/${beat.videoId}?${params}`;

  const confirm = () => {
    if (confirmed) return;
    setConfirmed(true);
    onSolved();
  };

  return (
    <div className="flex h-full flex-col gap-4">
      <div className="overflow-hidden rounded-[var(--radius-lg)] border border-[var(--border)] bg-black">
        <iframe
          src={src}
          title={beat.source}
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
          allowFullScreen
          className="aspect-video w-full"
        />
      </div>

      <p className="text-xs text-[var(--text-muted)]">
        ▶ {beat.source} · on YouTube
        {beat.end ? " · we picked the key part for you" : ""}
      </p>

      <div className="mt-auto">
        <button
          onClick={confirm}
          disabled={confirmed}
          className="w-full rounded-[var(--radius-pill)] border-2 py-3.5 font-800 transition-all active:scale-[0.99]"
          style={{
            borderColor: confirmed ? "var(--success)" : "var(--accent)",
            color: confirmed ? "var(--success)" : "var(--accent-strong)",
            background: confirmed ? "rgba(74,222,128,0.08)" : "transparent",
          }}
        >
          {confirmed ? "Nice — watched ✓" : "Done watching"}
        </button>
        <p className="mt-2 text-center text-xs text-[var(--text-muted)]">
          This step needs internet. Short on data? Watch it later and continue.
        </p>
      </div>
    </div>
  );
}
