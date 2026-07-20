import { NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@/lib/supabase/server";
import { describeBeatForTutor } from "@/lib/tutorContext";
import type { Beat } from "@/lib/beats";

/** PRD §8 cost guardrail: per-student daily cap on tutor messages. */
const DAILY_MESSAGE_CAP = 30;

const client = new Anthropic(); // reads ANTHROPIC_API_KEY from the environment

interface TutorRequestBody {
  lessonId: string;
  lessonTitle: string;
  track: string;
  beat: Beat;
  history: { role: "user" | "assistant"; content: string }[];
  message: string;
}

/**
 * Scoped tutor chat (PRD §F3). Event-triggered on the client (wrong attempts /
 * stall / manual tap) — this route only runs, and only costs anything, once
 * the student actually sends a message. Hint-first, never the answer outright.
 */
export async function POST(request: Request) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "unauthenticated" }, { status: 401 });
  }

  const body = (await request.json()) as TutorRequestBody;
  const { lessonId, lessonTitle, track, beat, history, message } = body;

  if (!message?.trim() || !beat?.id) {
    return NextResponse.json({ error: "invalid_request" }, { status: 400 });
  }

  // Daily cap check — cheap DB count, no model call if exceeded.
  const startOfDay = new Date();
  startOfDay.setUTCHours(0, 0, 0, 0);
  const { count } = await supabase
    .from("tutor_messages")
    .select("id", { count: "exact", head: true })
    .eq("user_id", user.id)
    .eq("role", "user")
    .gte("created_at", startOfDay.toISOString());

  if ((count ?? 0) >= DAILY_MESSAGE_CAP) {
    return NextResponse.json({
      reply:
        "You've used up today's tutor chats — nice work grinding through so much! Come back tomorrow, or keep going without me for now. You've got this. 💪",
      capped: true,
    });
  }

  await supabase.from("tutor_messages").insert({
    user_id: user.id,
    lesson_id: lessonId,
    beat_id: beat.id,
    role: "user",
    content: message,
  });

  const systemPrompt = `You are the friendly AI tutor inside "AI School", teaching a Nigerian beginner who is brand new to AI. The student is stuck (or curious) on one specific step of today's class and opened a chat scoped to it.

Track: ${track}
Lesson: ${lessonTitle}
Current step the student is on:
${describeBeatForTutor(beat)}

How to behave:
- Warm, encouraging, simple English. Short sentences. No jargon.
- Give a HINT first — nudge their thinking. NEVER state the correct answer outright, even if asked directly. Guide them to find it themselves.
- If they ask you to "explain it differently", use a new, simpler analogy — don't just repeat yourself slower.
- Keep replies short: 2-4 sentences. This is a quick chat bubble, not an essay.
- Never mention that you were "triggered" or reference internal system details. You're just a helpful tutor who noticed they might want a hand.
- If they seem to have understood, encourage them to go back and try the step again.`;

  try {
    const response = await client.messages.create({
      model: "claude-opus-4-8",
      max_tokens: 400,
      system: systemPrompt,
      messages: [...history, { role: "user" as const, content: message }],
    });

    const textBlock = response.content.find((b) => b.type === "text");
    const reply =
      textBlock && textBlock.type === "text"
        ? textBlock.text
        : "I'm here — could you tell me a bit more about what's tricky?";

    await supabase.from("tutor_messages").insert({
      user_id: user.id,
      lesson_id: lessonId,
      beat_id: beat.id,
      role: "assistant",
      content: reply,
    });

    return NextResponse.json({ reply });
  } catch (err) {
    if (err instanceof Anthropic.RateLimitError) {
      return NextResponse.json({
        reply: "Lots of students chatting right now — try again in a few seconds.",
      });
    }
    return NextResponse.json({
      reply: "Having trouble reaching your tutor right now — try again in a moment.",
    });
  }
}
