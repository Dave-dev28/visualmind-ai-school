"use client";

import { useState } from "react";
import type { BeatImage as BeatImageConfig } from "@/lib/beats";

/**
 * Visual narration slot. David generates these images with AI and drops them
 * into /public/media/. Until the file exists, the slot renders nothing — the
 * beat stays fully usable, so images can be added progressively.
 */
export default function BeatImage({ image }: { image: BeatImageConfig }) {
  const [failed, setFailed] = useState(false);
  if (failed) return null;

  return (
    <figure className="animate-pop mb-4">
      {/* Plain <img>: local public asset, unknown dimensions, needs onError
          fallback while files are still being added. */}
      {/* eslint-disable-next-line @next/next/no-img-element */}
      <img
        src={image.src}
        alt={image.alt}
        onError={() => setFailed(true)}
        className="w-full rounded-[var(--radius-lg)] border border-[var(--border)] object-cover"
      />
      {image.caption && (
        <figcaption className="mt-1.5 text-xs text-[var(--text-muted)]">
          {image.caption}
        </figcaption>
      )}
    </figure>
  );
}
