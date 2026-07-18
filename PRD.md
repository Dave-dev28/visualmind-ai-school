# PRD — Interactive AI School (PWA)

**Owner:** David · **Date:** July 17, 2026 · **Status:** v1.0 — build spec
**Companion doc:** `ai-school-userflows-and-plan.md` (userflows & strategy)

> This PRD is written to be dropped into a repo and used directly as a build spec with Claude Code. Build order is in §12.

---

## 1. Product Summary

An installable, mobile-first PWA that teaches AI skills to complete beginners through short, hands-on interactive lessons. Students act every 60–90 seconds — dragging, selecting, typing, pulling levers, and generating real AI images/videos in-app — guided by an AI tutor that appears when they struggle. Regular tests are type-and-respond; serious milestone exams are spoken, run by a voice agent in simple English. Scores stay hidden all week and reveal every Friday alongside a cohort demo day.

**Launch tracks:** AI Video Generation & Cinema · Build Apps with AI. More courses later.
**Language:** English (native Pidgin version in Phase 2).
**Business model:** Paid from day one. **v1 payment is manual (out-of-band):** students pay David directly; once payment is confirmed he issues an **access code / seat number** that unlocks their seat. In-app Paystack/Flutterwave checkout + webhooks are **deferred to Phase 2**. Generation credits are funded by **admin manual grant** (same append-only ledger, no payment provider yet). Generation APIs are integrated server-side — students never touch API keys.
**First intake:** one student (concierge pilot), then cohorts of 30–50. **Cohort cadence: weekly, every Friday** (reveal + demo day).

### Goals
1. Students finish lessons feeling "I *made* something today" — every class ends with an artifact.
2. ≥60% course completion (vs. ~10% industry norm for online courses).
3. Credit revenue covers generation API costs with margin from student one.

### Non-Goals (v1)
Additional course tracks; Pidgin; certificates; public leaderboards (probably never); native app stores; forums beyond WhatsApp; teams/b2b.

---

## 2. Users

**Student:** Nigerian beginner on a mid-range Android with expensive data. Curious about AI, wants an earning skill. May be anxious about "tech" and written English. Needs to feel guided, never judged.

**Admin (David):** Authors lessons from templates, monitors progress, reviews flagged exam scores, runs Friday sessions. Must operate the whole school solo.

---

## 3. Core Concepts & Data Model (indicative)

- **Track** → has ordered **Weeks** → have ordered **Lessons** (~20–25 min) → have 6–8 ordered **Beats**.
- **Beat**: one interaction unit. `type` ∈ {drag, select, type_answer, lever, generate, watch, speak} + JSON config (see §5). All non-generate beats are **prebuilt and shared** — built once, every student gets the same; nothing is rendered per-student.
- **Artifact**: anything the student produced (generated image/clip, completed diagram, transcribed explanation). Belongs to student, shown in Gallery.
- **Attempt**: student's response to a beat/test/exam + AI score + confidence. Scores never sent to client before Friday unlock.
- **CreditLedger**: append-only transactions (purchase, generation spend, refund/bonus). Balance = sum. Every generation logs provider raw cost vs. credits charged.
- **Cohort**: group with start date, weekly schedule, Friday reveal timestamp.

- **AccessCode (v1 manual payment):** single-use code tied to a cohort + starter-credit amount; issued by admin after confirming an out-of-band payment; redeemed once at onboarding to claim a seat and grant credits.

Suggested tables: `users, tracks, weeks, lessons, beats, attempts, artifacts, exams, exam_answers, cohorts, cohort_members, access_codes, credit_ledger, tutor_sessions, flags`.

---

## 4. Features

### F1 — Onboarding (target: <5 min to first "I made something")
1. Landing: student-made AI video as hero → "Join the next cohort."
2. Signup: phone or Google. Name + referral source only.
3. **Access-code / seat gate (v1):** after signup the student enters the access code David issued once their manual payment was confirmed. Invalid/used code → blocked with a warm "contact David to get your seat" message. Valid code → seat claimed, cohort assigned, starter credits granted by admin. (In-app credit purchase is Phase 2.)
4. **Pick a track:** two big cards (AI Video / Build Apps), 15-sec preview of what students make. "More courses soon" teased.
5. Micro-placement chat: tutor asks 3 casual questions (not a test) to set starting point.
6. **Instant taste:** one 2-min mini-lesson from their track ending in one real generation. They leave day one having made something.
7. Cohort placement + add-to-home-screen prompt + WhatsApp group link.

### F2 — Lesson Player (the core)
- Full-screen, one beat at a time, progress dots on top, floating tutor button.
- Alternates beat types; video never twice in a row; passive time never >3 min.
- End-of-class recap: concrete verbs ("Today you: sorted 6 shot types, pulled the motion lever, generated 1 image"). Artifact saved to Gallery. **No score shown.**
- Tomorrow tease (one line + thumbnail).

### F3 — AI Tutor (event-triggered, never always-on)
- Trigger rules (configurable per beat): `wrong_attempts >= N` (default 2) OR `stall_seconds >= S` (default 90) OR student taps tutor button.
- On trigger: small popup "Need a hand with this one?" — dismissible, never forced. Opening it starts a chat scoped to the current beat (system prompt includes lesson context + student's attempts).
- Behavior: hint first, never the answer outright; offers "explain it differently" (new analogy, slower); encouraging tone, simple English.
- No background AI monitoring. Zero inference cost until triggered.

### F4 — Generate Beats (the signature moment)
- Student writes a prompt → app generates a real image (video generation added later in the course) using server-side provider keys → spends credits from balance.
- Credit cost shown **before** each generation. Retry cap per beat (default 2). Low-balance state prompts a top-up, never blocks mid-lesson without warning.
- After generation, an LLM with vision rates the output against the beat's rubric: what worked, one specific improvement → student tries once more (if retries remain).
- Result saved to Gallery automatically.

### F5 — Tests & Exams
- **Regular tests (end of class):** type-and-respond — select, type short answers, order steps. AI-checked (concept match, not exact match). Cheap, no voice.
- **Vocal exams (milestones only — end of week / end of module):** ElevenLabs conversational agent asks one question at a time in simple English; student speaks; Groq Whisper transcribes; LLM scores for concept understanding, never grammar or accent. Repeat/rephrase always available; no timer. One gentle retry on unclear audio, then type-instead fallback.
- All scores computed silently server-side. Low-confidence scores → `flags` queue for admin review before Friday.

### F6 — Friday Reveal + Demo Day
- Friday screen locked all week with a countdown (builds the ritual).
- At reveal: per-class scores, trend vs. own last week (no public ranking), tutor's 2-line summary with a deep link to the exact beat to replay.
- Demo day: live group call (WhatsApp/Meet for v1, in-app later); 5–6 students show the week's artifacts.
- Thursday-night push: "Results tomorrow 6pm. Finish this week's artifact."

### F7 — Gallery
Every artifact, chronological, downloadable and shareable (share = organic marketing). Empty state sells the promise: "Everything you make lives here."

### F8 — Credits & Payments
- **v1 (manual):** no in-app checkout. Payment happens out-of-band (student pays David directly). David confirms, then **issues an access code / seat number** and **grants starter credits** to the student's ledger from the admin panel. Access codes are single-use, tied to a cohort, and unlock the seat at onboarding (§F1).
- **Ledger is live in v1** for tracking, not purchasing: append-only, funded by admin grants, debited by every generation. Balance visible in profile and before any generation. Every generation still logs provider raw cost vs. credits charged — this is how real per-generation economics get measured (§13.2).
- **Phase 2:** Paystack/Flutterwave checkout (card, transfer, USSD) + webhook → auto-credit the ledger; top-up bundles; installments. Verify signatures, handle duplicate webhooks.
- Pricing: credits priced with margin over raw API cost (exact numbers TBD after cost testing — see §13).

### F9 — Re-engagement
- Missed 1 day: specific push — "Day 4 is 18 min. You can still make Friday's reveal."
- Missed 3+: tutor offers a 2-lesson condensed catch-up plan.
- Missed cohort: seat in next intake, progress preserved.

### F10 — Admin
- Cohort heatmap (who's on which day), flagged-scores review queue, Friday prep view (average score per concept → what to reteach).
- **Lesson authoring for v1 = JSON/config files in the repo** (you're technical; a GUI builder is Phase 2+). Beat templates make this fast: authoring = filling JSON, not building UI.

---

## 5. Beat Template Library (build these 7 components once)

Each beat is a reusable component + JSON config. This is the heart of the build.

| Type | Interaction | Config (essentials) | Feedback |
|---|---|---|---|
| `drag_sort` | Drag items into labeled buckets | items[], buckets[], correct map | Item snaps + satisfying click per correct drop |
| `drag_label` | Drag labels onto an interactive image/diagram | image, hotspots[], labels[] | Diagram animates only when fully correct (animation = reward) |
| `lever` | Drag a slider/lever, watch outcome change live | states[] keyed to lever positions, target state | Live visual change; "found it" moment |
| `select` | Tap 1-of-3/4 (predict, quiz) | question, options[], correct, per-option explain | Reveal with why, not just right/wrong |
| `type_answer` | Type a short free answer | question, rubric for AI check | AI concept-check, kind phrasing on miss |
| `generate` | Prompt → real AI image/video + AI rating | provider, credit_cost, retry_cap, rating rubric | Specific praise + one improvement |
| `watch` | YouTube embed, 2–3 min max | video_id, start/end, one-line setup | Auto-advance prompt at end |
| `speak` | 20-sec explain-it-back (low stakes, unscored) | prompt, encouragement style | Warm acknowledgment only |

Rules: animations respond to student action (mechanical "click into place"), never ambient decoration. Every beat ends with the student having *done* something visible.

---

## 6. Design Language — "fun, simple, proud"

- **Feel:** playful energy, adult respect. Duolingo's warmth without the childishness. A student should want to screenshot their recap.
- **Layout:** one thing per screen, one dominant action. Big touch targets (thumb-first), generous whitespace, max ~2 font sizes per screen. If a screen needs explaining, it's wrong.
- **Color:** warm dark base + one vivid accent per track (e.g., video = hot orange/coral, apps = electric green). High contrast for sunlight readability.
- **Type:** big, rounded, friendly sans (e.g., a Nunito/Outfit-class face). Short sentences everywhere; UI copy in simple English, warm and direct ("You nailed that" not "Correct response recorded").
- **Motion:** micro-interactions as feedback — snaps, springs, progress dots filling, the diagram animating when solved. 150–250ms, never blocking. No confetti storms; one tasteful celebration per lesson completion.
- **Empty/error states:** always warm, always with a next step. Errors never blame the student.
- **Accessibility:** works one-handed, offline-tolerant messaging, readable at arm's length, no color-only meaning.

---

## 7. Screens

1. **Home** — today's lesson dominant; lesson map, streak, next cohort event below. No scores anywhere.
2. **Lesson Player** — §F2.
3. **Tutor Chat** — slide-over, scoped to current beat.
4. **Gallery** — §F7.
5. **Exam Room** — distinct calm visual mode, voice-first for milestone exams.
6. **Friday Screen** — countdown-locked → reveal.
7. **Cohort** — classmates' shared demos, demo-day schedule, WhatsApp link.
8. **Profile/Settings** — credit balance + top-up, language (Pidgin greyed "coming soon" — measures demand), data saver, notifications.

---

## 8. Technical Requirements

- **Platform:** Next.js (App Router) PWA — installable, service worker, push notifications. Mobile-first; desktop is a scaled-up centered column.
- **Backend:** Supabase — auth (phone/Google), Postgres, storage (artifacts), RLS so students only read their own data; scores/attempts written by server only, unreadable by client until Friday unlock (enforce in RLS, not UI).
- **AI services:**
  - LLM API — tutor chat, answer checking, artifact rating (vision), exam scoring.
  - ElevenLabs conversational agent — vocal exams only.
  - Groq Whisper — transcription (exams + speak beats).
  - Image-gen provider (+ video-gen later) — server-side keys only, called via edge function that: checks balance → shows cost → generates → debits ledger → stores artifact. Idempotent; a failed generation never charges.
- **Payments (v1):** manual. Access-code table (code, cohort, credits_to_grant, status, redeemed_by, redeemed_at); admin issues codes after confirming out-of-band payment; onboarding redeems a code to claim a seat + grant starter credits. **Phase 2:** Paystack (primary) webhook → ledger credit; verify signatures; handle duplicate webhooks.
- **Low-data:** YouTube handles video adaptation; interactive beats are lightweight (JSON + small assets, cacheable); only generate/exam/reveal need connection. Honest offline messaging ("This part needs internet").
- **Analytics from day one:** beat-level events (start, complete, fail, tutor-trigger, generation, retry) → tells you which lessons to fix.
- **Cost guardrails:** per-student daily caps on tutor messages and generations; all provider costs logged per call.

---

## 9. Scoring

- Weekly score per student = weighted mix (weights configurable; starting point: 40% typed tests, 35% vocal exams, 25% generated-artifact ratings; beats themselves are practice, unscored).
- Every AI score carries a confidence value; below threshold → flag for human review.
- Nothing surfaces client-side until the cohort's Friday reveal timestamp.

## 10. Success Metrics

Activation: % of signups completing the onboarding mini-lesson. Engagement: daily lesson completion, beat drop-off, tutor-trigger rate. Completion: % finishing the course (target ≥60%). Quality: exam pass rates, artifact rating trend. Business: credit margin per student, top-up rate, share rate from Gallery.

## 11. Risks

1. **Solo content production** — mitigated by the 7-template library + JSON authoring; still the #1 risk. Never build a bespoke interaction for one lesson.
2. **Voice accuracy on Nigerian-accented English** — gate feature; tested in Phase 0 with the pilot student before exam specs are finalized. Type-fallback always exists.
3. **Handling money** — v1 sidesteps most of this: payment is manual and out-of-band, credits enter via admin grant, so there's no payment provider to reconcile yet. Ledger must still be append-only and never over-charge on failed generations. Access codes must be single-use (enforce server-side) so a seat can't be claimed twice. Real per-generation cost is measured now to price Phase-2 checkout.
4. **YouTube dependency** — creators can pull videos; reference videos by config so they're swappable; migrate to hosted video when revenue allows.
5. **Hidden-score trust** — a wrong score discovered Friday hurts; human review of flags is mandatory before each reveal.

## 12. Build Order (for Claude Code)

1. **Design-lock milestone:** one lesson-player screen with 3 working beats (drag_sort, select, lever) in the design language. Iterate the feel here before anything else.
2. Beat library: remaining templates (type_answer, watch, speak; generate stubbed).
3. Supabase schema + auth + lesson JSON loader → full lesson playable end-to-end.
4. Generate beat: provider integration + credits ledger (funded by admin manual grants; **Paystack checkout deferred to Phase 2**).
5. Tutor (event triggers + scoped chat).
6. Tests + scoring pipeline + Friday lock/reveal.
7. Vocal exam room (ElevenLabs + Groq) — after Phase 0 accent testing.
8. Home, Gallery, Cohort, Profile; PWA polish (install, push, caching).
9. Admin views (heatmap, flags queue).

**Pilot gate:** steps 1–6 + one week of real content = enough to start the one-student pilot. Don't wait for 7–9.

## 13. Open Questions

1. Image/video providers to integrate (one of each; pick for cost + quality + API reliability).
2. Credit pricing: bundle size, naira price, margin (test real per-generation costs first).
3. Demo-day platform for v1: WhatsApp video vs. Google Meet.
4. Working name + domain.
5. Score weights (start with §9 defaults, tune in pilot).
