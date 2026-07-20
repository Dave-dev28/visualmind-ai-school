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
 *
 * When `beat.extra` is present this becomes a small tab switcher over several
 * clips (e.g. a "look what's possible" showcase) — still ONE beat in the
 * progress dots, so it never breaks the "no video twice in a row" rule.
 */
export default function WatchBeat({ beat, onSolved }: Props) {
  const [confirmed, setConfirmed] = useState(false);
  const clips = [
    { videoId: beat.videoId, source: beat.source, start: beat.start, end: beat.end },
    ...(beat.extra ?? []),
  ];
  const [active, setActive] = useState(0);
  const clip = clips[active];

  const params = new URLSearchParams({ rel: "0", modestbranding: "1" });
  if (clip.start) params.set("start", String(clip.start));
  if (clip.end) params.set("end", String(clip.end));
  const src = `https://www.youtube-nocookie.com/embed/${clip.videoId}?${params}`;

  const confirm = () => {
    if (confirmed) return;
    setConfirmed(true);
    onSolved();
  };

  return (
    <div className="flex h-full flex-col gap-4">
      {clips.length > 1 && (
        <div className="flex gap-2 overflow-x-auto pb-1">
          {clips.map((c, i) => (
            <button
              key={c.videoId}
              onClick={() => setActive(i)}
              className="flex-none rounded-[var(--radius-pill)] px-3.5 py-2 text-sm font-700 transition-colors"
              style={{
                background: i === active ? "var(--accent)" : "var(--surface-2)",
                color: i === active ? "var(--accent-ink)" : "var(--text-muted)",
              }}
            >
              {c.source.split("—")[0].trim() || `Clip ${i + 1}`}
            </button>
          ))}
        </div>
      )}

      <div className="overflow-hidden rounded-[var(--radius-lg)] border border-[var(--border)] bg-black">
        <iframe
          key={clip.videoId}
          src={src}
          title={clip.source}
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
          allowFullScreen
          className="aspect-video w-full"
        />
      </div>

      <p className="text-xs text-[var(--text-muted)]">
        ▶ {clip.source} · on YouTube
        {clip.end ? " · we picked the key part for you" : ""}
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
