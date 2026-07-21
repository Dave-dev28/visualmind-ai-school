# Visual narration images — drop them in this folder

Every image below has a **slot already wired into a lesson**. The app works
fine while a file is missing (the slot just stays hidden), so you can add
them one by one. **Filenames must match exactly** (all lowercase, `.jpg`).

## Style guide (keep every image consistent)

Add this to the end of every generation prompt:

> Flat modern illustration, warm dark background (#17130f), hot coral orange
> (#ff6a3d) as the main accent color, soft glow, clean shapes, no words or
> text anywhere in the image, 16:9 widescreen.

**Size:** 1200×675 (16:9). **Save as JPG, keep each file under ~300 KB**
(students pay for data). If your tool only exports PNG, just drop the PNG in
this folder and tell Claude — it converts/renames/compresses before deploying.

⚠️ AI image tools garble text — always say **"no words or text in the image"**
and reject any output that contains lettering.

---

## Lesson 1 — What is AI, really?

| File | Where it shows | Generation prompt (add style guide) |
|---|---|---|
| `l1-ai-around-you.jpg` | Opening question | A smartphone floating in the center, surrounded by softly glowing icons: a map route, a face scan, a voice wave, a photo gallery — everyday AI features orbiting the phone |
| `l1-learns-vs-rules.jpg` | Learns-vs-rules sort | Split image: left side a friendly robot studying a pile of photos with a magnifier; right side mechanical gears following a rigid checklist path |
| `l1-faces-10.jpg` | Lever state 1 | A confused robot looking at just 10 scattered face photos, question marks floating, blurry uncertain vibe |
| `l1-faces-1k.jpg` | Lever state 2 | A robot examining a wall grid of hundreds of face photos, half-focused, some photos highlighted correctly and some wrongly |
| `l1-faces-100k.jpg` | Lever state 3 | A confident robot in front of a massive dense wall of face photos, most highlighted correctly with coral glow |
| `l1-faces-millions.jpg` | Lever state 4 | A sharp-eyed robot before an endless sea of face photos stretching to the horizon, laser-focused beam correctly locking onto one face |

## Lesson 2 — Where AI came from

| File | Where it shows | Generation prompt |
|---|---|---|
| `l2-turing.jpg` | Opening question | A 1950s scientist silhouette beside a room-sized vintage computer with reels and blinking lights, vintage-futuristic mood |
| `l2-timeline.jpg` | Era sorting | A horizontal timeline road in three glowing segments: a small spark at the start, a long dim frozen middle stretch, a bright explosive burst at the end |
| `l2-1950s.jpg` | Lever state 1 | A giant room-sized 1950s computer with tape reels playing tic-tac-toe on a tiny screen |
| `l2-1990s.jpg` | Lever state 2 | A chunky 1990s desktop PC facing a chessboard, chess pieces mid-game, CRT monitor glow |
| `l2-2010s.jpg` | Lever state 3 | A rack of glowing GPU servers with a smartphone in front recognizing faces and soundwaves |
| `l2-2020s.jpg` | Lever state 4 | A vast futuristic data centre with light streams flowing out and forming images, film clips, and text — creation pouring from the machines |

## Lesson 3 — How machines actually learn

| File | Where it shows | Generation prompt |
|---|---|---|
| `l3-naira-notes.jpg` | Opening question | Banknotes under a large magnifying glass, one glowing genuine, one revealing subtle flaws, detective inspection mood (generic banknotes, no real currency text) |
| `l3-training-loop.jpg` | Who-brings-what sort | A circular loop diagram made of glowing arrows: photos flow into a robot head, a guess comes out, a score meter judges it, an adjustment wrench feeds back in — an endless cycle |
| `l3-train-0.jpg` | Lever state 1 | A robot flipping a coin, shrugging, surrounded by random question marks — pure guessing |
| `l3-train-some.jpg` | Lever state 2 | A robot squinting at banknotes, catching one obvious fake but missing others, half-lit progress bar |
| `l3-train-good.jpg` | Lever state 3 | A sharp confident robot instantly spotting a subtle fake note with a coral scanning beam, near-full progress bar |
| `l3-train-overfit.jpg` | Lever state 4 | A robot hugging a small stack of memorized flashcards while a new unfamiliar note slips past unnoticed behind its back |

## Lesson 4 — Meet the LLM

| File | Where it shows | Generation prompt |
|---|---|---|
| `l4-next-word.jpg` | Opening question | A sentence being built from glowing word tiles, with several ghost candidate tiles hovering for the next position, one glowing brightest (abstract tiles, no readable text) |
| `l4-temp-0.jpg` | Lever state 1 | A robot speaking in perfectly straight identical gray rows — rigid, mechanical, repetitive mood |
| `l4-temp-low.jpg` | Lever state 2 | A robot speaking in clean orderly light streams, calm and precise |
| `l4-temp-med.jpg` | Lever state 3 | A robot speaking in flowing colorful creative streams with sparks of coral — lively but controlled |
| `l4-temp-max.jpg` | Lever state 4 | A robot with swirling psychedelic chaos pouring out — melting shapes, a golden octopus dream, beautiful nonsense |
| `l4-prompting.jpg` | Prompting habits sort | Split image: left a person handing a robot a clear glowing blueprint; right a person shrugging vaguely while the robot produces a shapeless gray blob |
| `l4-confident-wrong.jpg` | Confidently-wrong question | A cheerful proud robot presenting a chart that is obviously nonsense — upside-down axes, tangled lines — while beaming with confidence |

## Lesson 5 — Your AI toolbox

| File | Where it shows | Generation prompt |
|---|---|---|
| `l5-toolbox.jpg` | Opening question | An open toolbox glowing from inside, with floating holographic icons rising out: a speech bubble, a picture frame, a film clapper, a soundwave, angle brackets for code |
| `l5-lever-diy.jpg` | Lever state 1 | A person hand-painting a huge wall alone with a tiny brush, moonlight, slow honest work |
| `l5-lever-assist.jpg` | Lever state 2 | A person working at a desk while a small robot hands them drafts and sketches — helpful but the human is doing the heavy lifting |
| `l5-lever-director.jpg` | Lever state 3 | A person in a director's chair pointing confidently while robots operate cameras and paint canvases exactly to their vision — the human clearly in charge, coral spotlight |
| `l5-lever-autopilot.jpg` | Lever state 4 | A person asleep in a chair while a robot assembly line churns out identical gray generic copies of the same product |

## Lesson 6 — You are the director (mindset class)

Deliberately reuses `l5-lever-director.jpg` twice (opening image + lever target)
— same "director in the chair" picture the whole way through Foundations, on
purpose. Only 3 new images needed here.

| File | Where it shows | Generation prompt |
|---|---|---|
| `l7-vague-vs-clear.jpg` | Vague-vs-clear sort | Split image: left half a blurry, foggy, indistinct scene with no visible detail; right half the exact same scene rendered sharp, warm, and richly detailed with clear light and expression |
| `l7-scrolling.jpg` | Lever state 1 | A person lying back on a couch late at night, passively scrolling a glowing phone, screen reflecting colorful content, nothing else happening in the room around them |
| `l7-copying.jpg` | Lever state 2 | A person typing at a desk while a faint translucent hand that isn't their own guides their fingers on the keyboard, uninspired expression |
| `l7-vague.jpg` | Lever state 3 | A person shrugging at a screen with a single fuzzy thought-bubble above their head, a confused robot on the other side producing a dull shapeless gray blob |

---

# Track: AI Video & Cinema (chosen after Foundations)

## Day 1 — The camera's vocabulary (shot sizes)

| File | Where it shows | Generation prompt |
|---|---|---|
| `l6-shot-wide.jpg` | Lever state — wide | A full-body figure in a clear, grounded environment, calm neutral framing, room to breathe around them |
| `l6-shot-medium.jpg` | Lever state — medium | A figure framed from the waist up, natural conversational distance, warm approachable mood |
| `l6-shot-close.jpg` | Lever state — close-up | A face filling most of the frame, intimate and emotionally direct, soft warm light |
| `l6-shot-xcu.jpg` | Lever state — extreme wide | A tiny lone figure dwarfed by a vast dramatic landscape, epic and lonely mood |

## Day 2 — Angles & the story they tell

| File | Where it shows | Generation prompt |
|---|---|---|
| `l6-angle-low.jpg` | Lever state — low angle | Camera looking sharply upward at a confident figure who towers over the frame, powerful dominant mood |
| `l6-angle-eye.jpg` | Lever state — eye-level | Two figures framed at equal eye height, neutral balanced conversation mood |
| `l6-angle-high.jpg` | Lever state — high angle | Camera looking sharply down at a small, vulnerable-looking figure below, diminished mood |
| `l6-angle-pov.jpg` | Lever state — POV | First-person view through a figure's own eyes looking at their hands or straight ahead, immersive framing |

## Day 3 — Prompting the camera (movement; existing 'demo' lesson)

| File | Where it shows | Generation prompt |
|---|---|---|
| `l6-motion-locked.jpg` | Lever state — locked off | A perfectly still, calm scene, camera frozen in place, observational quiet mood |
| `l6-motion-push.jpg` | Lever state — slow push-in | A face growing slightly larger in frame as if the camera drifted closer, gentle intimate blur at the edges |
| `l6-motion-dolly.jpg` | Lever state — steady dolly | A smooth confident forward glide past a figure, cinematic motion streaks, deliberate mood |
| `l6-motion-whip.jpg` | Lever state — fast whip | A sudden motion-blurred rush past the frame, energetic chaotic streaks, tense fast mood |

## Day 4 — Lighting a face like a movie

| File | Where it shows | Generation prompt |
|---|---|---|
| `l6-light-flat.jpg` | Lever state — flat, even | A face lit evenly from the front with no shadows, bright neutral office-like mood |
| `l6-light-soft.jpg` | Lever state — soft key+fill | A face lit with gentle warm balanced light, soft flattering shadows, natural glowing mood |
| `l6-light-dramatic.jpg` | Lever state — dramatic low-key | A face lit strongly from one side only, deep moody shadows on the other side, cinematic serious mood |
| `l6-light-horror.jpg` | Lever state — horror underlight | A face lit harshly from directly below with no fill light, unsettling frightening shadows upward |

## Day 5 — Planning before you prompt

| File | Where it shows | Generation prompt |
|---|---|---|
| `l6-planning.jpg` | Opening question | A desk with hand-drawn storyboard sketches in a row, a script page with a few lines, a pencil resting on top, warm desk lamp light |

## Day 6 — Meet Higgsfield

| File | Where it shows | Generation prompt |
|---|---|---|
| `l6-higgsfield.jpg` | Opening question | A sleek dashboard interface showing several glowing video-model option tiles side by side, a cursor comparing them, futuristic clean UI mood |

## Day 7 — Meet Google Flow

| File | Where it shows | Generation prompt |
|---|---|---|
| `l6-flow.jpg` | Opening question | A single glowing reference portrait connected by thin light lines to several film-strip frames showing the same character in different shots, consistency and connection mood |

---

**Want different framing, extra slots, or `.jpg`/`.webp` instead?** Ask Claude
to update the lesson SQL and this list together so filenames stay in sync.
