import type { Beat } from "@/lib/beats";

/**
 * Renders a beat's config into plain text for the tutor's system prompt —
 * enough grounding to give a correct hint, framed so the model naturally
 * withholds the answer rather than reciting it back.
 */
export function describeBeatForTutor(beat: Beat): string {
  switch (beat.type) {
    case "read":
      return [
        `Type: theory card titled "${beat.title}".`,
        `Body: ${beat.body.join(" ")}`,
        beat.keyPoints?.length
          ? `Key points: ${beat.keyPoints.join(" | ")}`
          : "",
      ]
        .filter(Boolean)
        .join("\n");

    case "select":
      return [
        `Type: multiple-choice prediction.`,
        `Question: ${beat.question}`,
        `Options: ${beat.options.map((o) => `"${o.label}"`).join(", ")}`,
        `The correct option (for your own grounding — do not just state it): "${
          beat.options.find((o) => o.id === beat.correct)?.label
        }". Why it's correct: ${
          beat.options.find((o) => o.id === beat.correct)?.explain
        }`,
      ].join("\n");

    case "drag_sort":
      return [
        `Type: drag items into labeled buckets.`,
        `Items: ${beat.items.map((i) => i.label).join(", ")}`,
        `Buckets: ${beat.buckets.map((b) => b.label).join(", ")}`,
        `Correct pairing (for grounding — guide them to reason it out, don't just list it): ${beat.items
          .map(
            (i) =>
              `"${i.label}" → "${
                beat.buckets.find((b) => b.id === beat.correct[i.id])?.label
              }"`,
          )
          .join("; ")}`,
      ].join("\n");

    case "lever": {
      const target = beat.states[beat.target];
      return [
        `Type: pull a lever between "${beat.minLabel}" and "${beat.maxLabel}" to find a target state.`,
        `States in order: ${beat.states.map((s) => s.label).join(" → ")}`,
        `Target state (for grounding): "${target.label}" — ${target.description}`,
      ].join("\n");
    }

    case "type_answer":
      return [
        `Type: short free-text answer.`,
        `Question: ${beat.question}`,
        `A model answer (for grounding, not to recite): "${beat.sampleAnswer}"`,
        `Hint already shown to the student on a miss: "${beat.hint}"`,
      ].join("\n");

    case "watch":
      return `Type: watching a short video ("${beat.source}"). Nothing to solve — just help them process what they saw if they ask.`;
  }
}
