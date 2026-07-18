# AI School — Userflows & Final Plan (Pre-PRD)

**Working name:** TBD
**Owner:** David
**Date:** July 17, 2026

---

## 1. Product Definition (v1)

An interactive PWA school that teaches AI skills to beginners through short interactive lessons, an AI voice tutor, vocal exams in simple English, and a weekly cohort rhythm ending in a Friday score reveal + demo day. Launches with two tracks: **AI Video Generation & Cinema** and **Build Apps with AI** — more courses added later.

**v1 decisions (locked):**

| Decision | Choice |
|---|---|
| Launch tracks | AI Video Generation & Cinema + Build Apps with AI (more courses later) |
| Language | English (native Pidgin version in Phase 2) |
| Pricing | Paid from day one: students buy generation credits at onboarding (Paystack/Flutterwave, naira). Generation APIs are integrated into the app — no student API keys |
| First intake | **One student** — concierge pilot; course built one lesson ahead of him, then scale to a cohort |
| Format | Cohort-based, weekly rhythm (post-pilot) |
| Platform | Installable PWA, mobile-first, low-data |
| Cost controls | Prebuilt shared beats/animations; event-triggered tutor (no always-on AI); voice reserved for serious exams only |

**Core loop:** Watch a short beat → do something interactive → build toward a weekly artifact → speak a vocal exam → see scores + demo on Friday.

**North-star metric:** % of cohort that completes the course and produces a final video. (Completion, not signups.)

---

## 2. Users

- **Student (primary):** Nigerian beginner, mid-range Android, expensive data, curious about AI, wants a skill that can earn. May be anxious about "tech" and about written English.
- **Instructor/Admin (you):** Creates lessons, monitors cohort progress, runs Friday sessions, reviews flagged exam answers.

---

## 3. Userflows

### Flow A — First-time onboarding (target: under 3 minutes to first "wow")

1. **Landing/install:** Student opens link (from WhatsApp/social) → sees a 30-sec student-made AI video as the hero ("students made these") → "Join the next cohort."
2. **Signup:** Phone number or Google. No long forms. Name + how they heard about it, done.
   **Credits at onboarding:** buy a starter credit bundle (naira, Paystack/Flutterwave) — this powers all their in-app generation for the course. Framed as "your creation fuel," with clear "this covers the whole course" pricing.
3. **Pick a track:** Two big cards — AI Video & Cinema or Build Apps with AI — each with a 15-sec preview of what students make. ("More courses coming soon" teased below.)
4. **Micro-placement chat (60 sec):** The tutor (text or voice) asks 3 casual questions ("Have you used ChatGPT before?") — not a test, a conversation. Sets their starting point and shows the assisted-learning personality immediately.
5. **Instant taste of the product:** Before the cohort even starts, they do one 2-minute interactive mini-lesson from their chosen track and make/see one result (an AI video clip, or a tiny working app tweak). They leave day one having *done* something.
6. **Cohort placement:** "Your cohort starts Monday. 47 others are joining you." → prompt to install PWA to home screen + join cohort WhatsApp group.

**Exit state:** installed app, in a cohort, already did one interaction, knows when class starts.

### Flow B — Daily lesson loop (the core, ~20–25 min/day)

1. **Open app:** Home shows one thing big: **today's lesson** ("Day 3: Prompting the camera — 22 min"). Below it: lesson map (progress), streak, artifact gallery. No score anywhere.
2. **Lesson = 6–8 interactive beats.** The lesson itself is the interactive content; video (mostly YouTube embeds) is a *complement* dropped in where it helps, never the spine. The student is always acting:
   - *Drag beats:* drag items into categories, drag labels onto interactive images/diagrams, drag levers/sliders and watch the result change live (e.g., slide "camera speed" and see the described shot change).
   - *Select & type beats:* pick options, predict outcomes, type short answers ("describe this shot in one line") — checked by AI, not exact-match.
   - *Generate beats (the signature moment):* the student writes a prompt and generates a real image (video later) in-app, spending credits from their balance — the generation APIs are integrated, no keys to manage; the AI looks at their output, rates it, and tells them specifically what worked and what to adjust — then they try once more. Making something and having it *seen* is what makes the class memorable. Generation happens only at these designated moments, with a retry cap and the credit cost shown before each generation.
   - *All non-generated beats are prebuilt and shared:* animations, diagrams, and interactions are built once from a fixed template library (~6 interaction types) and reused by every student — nothing rendered per-student except their own generated artifacts.
   - *Watch beats:* short YouTube embed (2–3 min max) as backup/context for what they just did or are about to do.
   - *Speak beats (low stakes):* 20-sec "explain it back in your own words" to the tutor. Not scored; tutor responds encouragingly. Trains them for exam day.
3. **Struggle detection → tutor pops up (event-triggered, not always watching):** simple rules fire the tutor — e.g., N wrong answers on a task/test or a long stall — and only then does the AI wake up: "Need a hand with this one?" Student can close it (never forced) or open the chat to ask questions and get guided — a hint first, not the answer. No always-on AI monitoring; zero cost until triggered. Never a red X wall.
4. **End-of-class recap:** "Today you: predicted 3 shots, wrote 2 prompts, generated 1 clip, explained motion prompting out loud." Artifact saved to their gallery. **No score shown** — score is computed silently.
5. **Tomorrow tease:** one line + thumbnail of tomorrow's lesson.

**Exit state:** a concrete artifact in their gallery, streak +1, score recorded but hidden.

### Flow C — Tests & exams (typed by default, voice for the serious ones)

**Regular tests (end of class):** normal type-and-respond — select, type short answers, order steps. AI-checked, cheap, no voice. This is most assessments.

**Vocal exams (reserved for serious milestones — e.g., end of week / end of module):**

1. Tutor announces it plainly: "Voice exam — 4 questions, simple English, take your time."
2. Voice agent (ElevenLabs) asks one question at a time; student answers by speaking (transcribed via Groq Whisper). Repeat/rephrase button always available. No timer pressure.
3. Agent gives *acknowledgment*, not judgment: "Okay, got it." — never "correct/wrong" in the moment (protects the Friday reveal).
4. Poor audio / unclear answer → one gentle retry → then option to type instead (accessibility fallback).
5. Scoring: AI scores for concept understanding (not grammar/accent). Low-confidence scorings are flagged to admin for human review before Friday.

**Exit state:** exam done in ~5 min, student focused on what they know, not how they wrote it.

### Flow D — Friday: score reveal + demo day (the weekly ritual)

1. **Thursday night:** notification — "Results tomorrow 6pm. Finish this week's artifact."
2. **Friday reveal (in-app):** personal recap screen — week's scores per class, trend vs. their own last week (never a public leaderboard rank), tutor's 2-line summary: what they nailed, one thing to review, with a link to the exact beat to replay.
3. **Demo day (live, optional but pushed):** 45-min group call; 5–6 students show the week's artifact (their generated clips). Others react. You (or later, a facilitator) give quick feedback.
4. **Week close:** badge/artifact stamped, next week's theme teased.

**Exit state:** feedback loop closed, social proof generated (demo clips = your marketing content, with permission), momentum into next week.

### Flow E — Falling behind / re-engagement

1. Missed a day → notification is *specific*, not guilt-y: "Day 4 is 18 min. You can still make Friday's reveal."
2. Missed 3+ days → tutor reaches out in-app with a catch-up plan ("Do these 2 condensed lessons to rejoin the cohort"). Optional WhatsApp nudge.
3. Missed the cohort entirely → auto-offer a seat in the next intake, progress preserved.

### Flow F — Instructor/Admin

1. Dashboard: cohort progress heatmap (who's on which day), flagged exam answers queue, this week's demo signups.
2. Lesson builder: assemble beats (video upload/embed, checkpoint types, exam questions) from templates — no code.
3. Friday prep view: auto-generated cohort summary (average scores per concept → tells you what to reteach).

---

## 4. App Structure (screens)

1. **Home** — today's lesson (dominant), lesson map, streak, next cohort event.
2. **Lesson player** — full-screen beats, progress dots on top, tutor button floating.
3. **Tutor** — persistent chat/voice sidebar, context-aware (knows current beat).
4. **My Gallery** — every artifact made, downloadable/shareable (each share = marketing).
5. **Exam room** — distinct calm visual mode, voice-first.
6. **Friday screen** — locked until reveal time (countdown builds ritual), then scores + recap.
7. **Cohort** — classmates' shared demo clips, demo day schedule, link to WhatsApp group.
8. **Profile/Settings** — language (Pidgin toggle greyed with "coming soon" — measures demand), data-saver mode, notifications.

---

## 5. PWA / Technical Principles

- **Installable PWA:** add-to-home-screen prompt during onboarding; feels like an app, no app-store friction or 30% cut.
- **Low-data by design:** videos are YouTube embeds (YouTube handles quality adaptation), interactive beats are lightweight and work offline where possible; only generate beats, exams, and Friday reveal require connection.
- **Voice stack (decided):** **ElevenLabs conversational agent** runs the tests/exams (asks questions, listens, responds); **Groq Whisper** transcribes student speech for scoring. Test both against Nigerian-accented English before launch — this is still the highest technical risk; prototype it first, standalone.
- **Scoring pipeline:** every checkpoint, generated output rating, and exam response scored silently server-side; nothing surfaced client-side until Friday unlock.
- **Stack suggestion (indicative, decide in PRD):** React/Next.js PWA + Supabase (auth, DB, storage) + an LLM API for the tutor, answer-checking, and rating generated outputs + ElevenLabs/Groq Whisper for voice + integrated image/video-gen APIs (server-side keys) + a credits ledger + Paystack/Flutterwave at v1 for credit purchase.
- **Analytics from day one:** beat-level drop-off, checkpoint fail rates, exam completion — this tells you which lessons to fix.

---

## 6. What v1 deliberately does NOT include

Additional courses beyond the two launch tracks (websites, foundations, etc. — later phases), Pidgin (Phase 2), public leaderboards (never, probably), certificates (Phase 2), native app stores, community forum beyond WhatsApp. (Payments ARE in v1 — credits at onboarding.)

---

## 7. Roadmap

**Phase 0 — One-student pilot:** a single student goes through the course as it's built, one lesson ahead of him. He pays for credits like a real student (tests the payment flow too). You watch everything: beat-level friction, tutor triggers, voice-exam accuracy on a real Nigerian accent, real phone, real data. Fix as you go. Success = he finishes and made things he's proud of.

**Phase 1 — First paid cohort (6–8 wks):** open to 30–50 students using the content proven in Phase 0, both tracks, you as instructor. Students buy credits at onboarding. Success = ≥60% finish + testimonials + demo artifacts. (If content production for two tracks at once proves too heavy, stagger: AI Video cohort starts week 1, Build Apps cohort 2–3 weeks later.) The school itself is proof for the apps track: "this app was built the way this course teaches."

**Phase 2 — Monetize + Pidgin:** paid cohorts (naira, installments), native Pidgin recordings of the proven tracks, Pidgin voice exams (evaluate Nigerian speech-AI providers then).

**Phase 3 — More courses:** additional tracks (websites & landing pages, AI foundations as a free funnel, etc.), reusing the whole platform.

---

## 8. Open questions for the PRD

1. Which AI image/video providers does the app integrate for generate beats? (One image + one video provider is ideal to start.)
2. Credit pricing: bundle size, naira price, and margin over raw API cost so credits cover your platform costs — needs a quick real-world test of actual per-generation cost.
3. Demo day hosting: WhatsApp video, Google Meet, or in-app later?
4. Score formula: what % from typed tests vs. vocal exams vs. generated-artifact ratings?
5. Tutor trigger thresholds: how many fails / how long a stall before the popup? (Tune during the one-student pilot.)
