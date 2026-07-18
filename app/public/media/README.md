# Visual narration images — drop them in this folder

Every image below has a **slot already wired into a lesson**. The app works
fine while a file is missing (the slot just stays hidden), so you can add
them one by one. **Filenames must match exactly** (all lowercase, `.png`).

## Style guide (keep every image consistent)

Add this to the end of every generation prompt:

> Flat modern illustration, warm dark background (#17130f), hot coral orange
> (#ff6a3d) as the main accent color, soft glow, clean shapes, no words or
> text anywhere in the image, 16:9 widescreen.

**Size:** 1200×675 (16:9). **Keep each file under ~300 KB** (students pay for
data) — export compressed PNG or convert with an optimizer.

⚠️ AI image tools garble text — always say **"no words or text in the image"**
and reject any output that contains lettering.

---

## Lesson 1 — What is AI, really?

| File | Where it shows | Generation prompt (add style guide) |
|---|---|---|
| `l1-ai-around-you.png` | Opening question | A smartphone floating in the center, surrounded by softly glowing icons: a map route, a face scan, a voice wave, a photo gallery — everyday AI features orbiting the phone |
| `l1-learns-vs-rules.png` | Learns-vs-rules sort | Split image: left side a friendly robot studying a pile of photos with a magnifier; right side mechanical gears following a rigid checklist path |
| `l1-faces-10.png` | Lever state 1 | A confused robot looking at just 10 scattered face photos, question marks floating, blurry uncertain vibe |
| `l1-faces-1k.png` | Lever state 2 | A robot examining a wall grid of hundreds of face photos, half-focused, some photos highlighted correctly and some wrongly |
| `l1-faces-100k.png` | Lever state 3 | A confident robot in front of a massive dense wall of face photos, most highlighted correctly with coral glow |
| `l1-faces-millions.png` | Lever state 4 | A sharp-eyed robot before an endless sea of face photos stretching to the horizon, laser-focused beam correctly locking onto one face |

## Lesson 2 — Where AI came from

| File | Where it shows | Generation prompt |
|---|---|---|
| `l2-turing.png` | Opening question | A 1950s scientist silhouette beside a room-sized vintage computer with reels and blinking lights, vintage-futuristic mood |
| `l2-timeline.png` | Era sorting | A horizontal timeline road in three glowing segments: a small spark at the start, a long dim frozen middle stretch, a bright explosive burst at the end |
| `l2-1950s.png` | Lever state 1 | A giant room-sized 1950s computer with tape reels playing tic-tac-toe on a tiny screen |
| `l2-1990s.png` | Lever state 2 | A chunky 1990s desktop PC facing a chessboard, chess pieces mid-game, CRT monitor glow |
| `l2-2010s.png` | Lever state 3 | A rack of glowing GPU servers with a smartphone in front recognizing faces and soundwaves |
| `l2-2020s.png` | Lever state 4 | A vast futuristic data centre with light streams flowing out and forming images, film clips, and text — creation pouring from the machines |

## Lesson 3 — How machines actually learn

| File | Where it shows | Generation prompt |
|---|---|---|
| `l3-naira-notes.png` | Opening question | Banknotes under a large magnifying glass, one glowing genuine, one revealing subtle flaws, detective inspection mood (generic banknotes, no real currency text) |
| `l3-training-loop.png` | Who-brings-what sort | A circular loop diagram made of glowing arrows: photos flow into a robot head, a guess comes out, a score meter judges it, an adjustment wrench feeds back in — an endless cycle |
| `l3-train-0.png` | Lever state 1 | A robot flipping a coin, shrugging, surrounded by random question marks — pure guessing |
| `l3-train-some.png` | Lever state 2 | A robot squinting at banknotes, catching one obvious fake but missing others, half-lit progress bar |
| `l3-train-good.png` | Lever state 3 | A sharp confident robot instantly spotting a subtle fake note with a coral scanning beam, near-full progress bar |
| `l3-train-overfit.png` | Lever state 4 | A robot hugging a small stack of memorized flashcards while a new unfamiliar note slips past unnoticed behind its back |

## Lesson 4 — Meet the LLM

| File | Where it shows | Generation prompt |
|---|---|---|
| `l4-next-word.png` | Opening question | A sentence being built from glowing word tiles, with several ghost candidate tiles hovering for the next position, one glowing brightest (abstract tiles, no readable text) |
| `l4-temp-0.png` | Lever state 1 | A robot speaking in perfectly straight identical gray rows — rigid, mechanical, repetitive mood |
| `l4-temp-low.png` | Lever state 2 | A robot speaking in clean orderly light streams, calm and precise |
| `l4-temp-med.png` | Lever state 3 | A robot speaking in flowing colorful creative streams with sparks of coral — lively but controlled |
| `l4-temp-max.png` | Lever state 4 | A robot with swirling psychedelic chaos pouring out — melting shapes, a golden octopus dream, beautiful nonsense |
| `l4-prompting.png` | Prompting habits sort | Split image: left a person handing a robot a clear glowing blueprint; right a person shrugging vaguely while the robot produces a shapeless gray blob |
| `l4-confident-wrong.png` | Confidently-wrong question | A cheerful proud robot presenting a chart that is obviously nonsense — upside-down axes, tangled lines — while beaming with confidence |

## Lesson 5 — Your AI toolbox

| File | Where it shows | Generation prompt |
|---|---|---|
| `l5-toolbox.png` | Opening question | An open toolbox glowing from inside, with floating holographic icons rising out: a speech bubble, a picture frame, a film clapper, a soundwave, angle brackets for code |
| `l5-lever-diy.png` | Lever state 1 | A person hand-painting a huge wall alone with a tiny brush, moonlight, slow honest work |
| `l5-lever-assist.png` | Lever state 2 | A person working at a desk while a small robot hands them drafts and sketches — helpful but the human is doing the heavy lifting |
| `l5-lever-director.png` | Lever state 3 | A person in a director's chair pointing confidently while robots operate cameras and paint canvases exactly to their vision — the human clearly in charge, coral spotlight |
| `l5-lever-autopilot.png` | Lever state 4 | A person asleep in a chair while a robot assembly line churns out identical gray generic copies of the same product |

---

**Want different framing, extra slots, or `.jpg`/`.webp` instead?** Ask Claude
to update the lesson SQL and this list together so filenames stay in sync.
