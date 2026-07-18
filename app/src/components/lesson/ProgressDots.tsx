interface Props {
  total: number;
  current: number; // 0-based index of the active beat
  done: boolean[]; // which beats are completed
}

/** Progress dots along the top of the lesson player (PRD §F2). */
export default function ProgressDots({ total, current, done }: Props) {
  return (
    <div className="flex items-center gap-1.5" aria-label={`Beat ${current + 1} of ${total}`}>
      {Array.from({ length: total }).map((_, i) => {
        const isDone = done[i];
        const isCurrent = i === current;
        return (
          <span
            key={i}
            className="h-1.5 rounded-[var(--radius-pill)] transition-all duration-300"
            style={{
              flex: isCurrent ? "2 1 0" : "1 1 0",
              background: isDone
                ? "var(--accent)"
                : isCurrent
                  ? "var(--accent-strong)"
                  : "var(--surface-2)",
              opacity: isDone || isCurrent ? 1 : 0.7,
            }}
          />
        );
      })}
    </div>
  );
}
