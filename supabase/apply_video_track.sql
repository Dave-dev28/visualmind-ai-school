-- ════════════════════════════════════════════════════════════════════════════
-- AI School — "AI Video & Cinema" track, built out (7 lessons)
-- Run in Supabase Dashboard → SQL Editor → Run. Safe to re-run (idempotent).
--
-- Arc: shot vocabulary → angles → camera movement (existing 'demo' lesson,
-- revised) → lighting → planning & script writing → Higgsfield → Google Flow.
-- Same "learn → then do" rhythm as Foundations; interactivity only where it
-- helps understanding. The generate beat (real AI video output) comes after
-- this arc, once an image/video provider + credit pricing are decided (PRD §13).
--
-- Videos verified live on YouTube (2026-07-20, via oEmbed):
--   AyML8xuKfoc  StudioBinder — Ultimate Guide to Camera Shots (Shot List Ep.1)
--   sDZ6KlzWjAQ  Shawn Dolinski — Camera Angles in Filmmaking Explained
--   BfH4gDTi6ME  Media Studies Pro — Key/Fill/Back Light: Three-Point Lighting
--   0SNaOisC2II  Film Riot — How To Write A Screenplay (For Beginners)
--   Pjw8nnxHo5I  Mariana Montoya — How to use Higgsfield AI for Beginners
--   yCmGsYFeCz0  The Pennywise Owl — Google Flow Veo 3 Tutorial for Beginners
-- ════════════════════════════════════════════════════════════════════════════

-- ─── Day 1 — The camera's vocabulary (shot sizes) ───────────────────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('video-1', 'AI Video & Cinema', 1, 'The camera''s vocabulary', 14,
$json${
  "beats": [
    { "id": "b0", "type": "watch",
      "prompt": "Before anything else — look what's possible.",
      "videoId": "LZ5nxL9EjBA",
      "source": "You Owe Yourself — David, AI-directed",
      "extra": [
        { "videoId": "jk_uie_srbE", "source": "Destiny — David, AI-directed" },
        { "videoId": "_IdkWYzcQR4", "source": "Ocean Drive — David, AI-directed" }
      ] },
    { "id": "b1", "type": "read",
      "prompt": "First, the idea.",
      "title": "How close the camera is changes how we feel",
      "body": [
        "Every shot has a size — how much of the person or scene fills the frame. This isn't a technical detail, it's an emotional dial. Filmmakers pick shot size on purpose, every single time.",
        "A wide shot shows the whole body and the world around it — it says \"here's the place, here's the situation.\" A close-up fills the frame with a face — it says \"feel what this person feels, right now.\"",
        "When you prompt an AI video generator, the shot size is one of the first things to decide. \"A woman in a wide shot\" and \"a close-up of a woman's face\" describe the same woman completely differently."
      ],
      "keyPoints": [
        "Wide shot = context and place.",
        "Close-up = emotion and intimacy.",
        "Shot size is a choice, not a default."
      ] },
    { "id": "b2", "type": "select",
      "prompt": "Predict the effect.",
      "question": "A film wants you to feel a character's private, quiet sadness. Which shot size fits best?",
      "options": [
        { "id": "o1", "label": "Wide shot", "explain": "A wide shot would make her feel small and distant — good for loneliness in a landscape, but not for intimate sadness on her face." },
        { "id": "o2", "label": "Close-up", "explain": "Exactly. A close-up puts you right there with her feeling — nowhere to hide, nothing else competing for attention." },
        { "id": "o3", "label": "Extreme wide shot", "explain": "That's even further away than a wide shot — great for \"tiny person, huge world,\" but it erases the very feeling we want to see." }
      ],
      "correct": "o2" },
    { "id": "b3", "type": "watch",
      "prompt": "Watch: every shot size explained (4 min).",
      "videoId": "AyML8xuKfoc", "start": 20, "end": 260,
      "source": "StudioBinder — Ultimate Guide to Camera Shots" },
    { "id": "b4", "type": "drag_sort",
      "prompt": "Sort each description to its shot size.",
      "items": [
        { "id": "i1", "label": "You see the whole street, the person is small in it" },
        { "id": "i2", "label": "You see the person head-to-toe, with some room around them" },
        { "id": "i3", "label": "You see them from the waist up — a normal conversation distance" },
        { "id": "i4", "label": "Their face fills almost the whole frame" }
      ],
      "buckets": [
        { "id": "wide", "label": "Wide" },
        { "id": "medium", "label": "Medium" },
        { "id": "close", "label": "Close-up" }
      ],
      "correct": { "i1": "wide", "i2": "wide", "i3": "medium", "i4": "close" } },
    { "id": "b5", "type": "lever",
      "prompt": "Pull the lever from extreme wide to extreme close-up and watch the feeling change.",
      "minLabel": "Extreme wide", "maxLabel": "Extreme close-up",
      "states": [
        { "label": "Extreme wide", "description": "A tiny figure in a huge landscape. Feels epic, lonely, insignificant against the world.", "image": "/media/l6-shot-xcu.jpg" },
        { "label": "Wide", "description": "Full body, clear surroundings. Feels grounded — you understand the place and the situation.", "image": "/media/l6-shot-wide.jpg" },
        { "label": "Medium", "description": "Waist-up, natural conversation distance. Feels normal, present — the sweet spot for dialogue.", "image": "/media/l6-shot-medium.jpg" },
        { "label": "Close-up", "description": "The face fills the frame. Feels intimate, urgent — nowhere to hide the emotion.", "image": "/media/l6-shot-close.jpg" }
      ],
      "target": 2 },
    { "id": "b6", "type": "type_answer",
      "prompt": "Make the idea yours.",
      "question": "Why would a filmmaker cut from a wide shot to a close-up in the middle of a scene, instead of just picking one shot size for everything?",
      "keywords": [
        ["context", "place", "world", "situation", "wide", "establish"],
        ["emotion", "feeling", "close", "intimate", "face", "focus"]
      ],
      "minMatches": 2,
      "hint": "Think about what each size gives you that the other doesn't — one sets the scene, the other pulls you into the feeling.",
      "sampleAnswer": "The wide shot shows the place and situation so you understand where you are. Then cutting to a close-up pulls you into the character's feeling at exactly the right emotional beat — you need both." }
  ],
  "tomorrow": "Day 2 — Camera angles: the silent way films tell you who has the power."
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;

-- ─── Day 2 — Angles & the story they tell ───────────────────────────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('video-2', 'AI Video & Cinema', 2, 'Angles & the story they tell', 14,
$json${
  "beats": [
    { "id": "b1", "type": "read",
      "prompt": "First, the idea.",
      "title": "Where the camera looks FROM is a silent opinion",
      "body": [
        "A camera angle is where the camera is positioned relative to the subject — below them, above them, or level with their eyes. It sounds technical, but it's really about power.",
        "Look up at someone (a low angle) and they feel powerful, dominant, larger than life. Look down on someone (a high angle) and they feel small, weak, vulnerable. Eye-level feels equal — neither of you has the upper hand.",
        "Directors choose angles on purpose to tell you, without a single word, who's in control of a scene."
      ],
      "keyPoints": [
        "Low angle (looking up) = power, dominance.",
        "High angle (looking down) = vulnerability, weakness.",
        "Eye-level = equality, neutrality."
      ] },
    { "id": "b2", "type": "watch",
      "prompt": "Watch: camera angles explained (4 min).",
      "videoId": "sDZ6KlzWjAQ", "end": 240,
      "source": "Shawn Dolinski — Camera Angles in Filmmaking Explained" },
    { "id": "b3", "type": "select",
      "prompt": "Use the idea.",
      "question": "A villain is about to deliver his big, menacing speech. Which angle makes him feel most terrifying?",
      "options": [
        { "id": "o1", "label": "Low angle, camera looking up at him", "explain": "Right — looking up at him makes him tower over the viewer. That's exactly the power and menace a villain's big moment needs." },
        { "id": "o2", "label": "High angle, camera looking down at him", "explain": "That would make him look small and weak — the opposite of menacing. Save high angles for his moment of defeat." },
        { "id": "o3", "label": "Eye-level, straight on", "explain": "Eye-level feels neutral and equal — fine for a normal conversation, but it won't give his speech any extra power." }
      ],
      "correct": "o1" },
    { "id": "b4", "type": "drag_sort",
      "prompt": "Sort each angle to the feeling it creates.",
      "items": [
        { "id": "i1", "label": "Camera looks up at the hero as she stands her ground" },
        { "id": "i2", "label": "Camera looks down at a character curled up, defeated" },
        { "id": "i3", "label": "Camera sits at the same height as two people talking" },
        { "id": "i4", "label": "Camera shows exactly what the character sees, from their eyes" }
      ],
      "buckets": [
        { "id": "power", "label": "Power (low angle)" },
        { "id": "vulnerable", "label": "Vulnerable (high angle)" },
        { "id": "equal", "label": "Equal / immersive" }
      ],
      "correct": { "i1": "power", "i2": "vulnerable", "i3": "equal", "i4": "equal" } },
    { "id": "b5", "type": "lever",
      "prompt": "Tilt the camera from a low angle up to a high angle and watch the character's power change.",
      "minLabel": "Low angle", "maxLabel": "High angle",
      "states": [
        { "label": "Low angle", "description": "Camera looks up. The subject towers, dominant and powerful.", "image": "/media/l6-angle-low.jpg" },
        { "label": "Eye-level", "description": "Camera sits level. Neutral and equal — you and the subject meet as equals.", "image": "/media/l6-angle-eye.jpg" },
        { "label": "High angle", "description": "Camera looks down. The subject shrinks, feels small and vulnerable.", "image": "/media/l6-angle-high.jpg" },
        { "label": "POV (point of view)", "description": "The camera becomes their eyes. You don't watch the character — you become them.", "image": "/media/l6-angle-pov.jpg" }
      ],
      "target": 0 },
    { "id": "b6", "type": "type_answer",
      "prompt": "Make the idea yours.",
      "question": "You're prompting an AI clip of a hero facing her biggest fear and winning. What angle would you ask for, and why?",
      "keywords": [
        ["low", "up", "power", "strong", "dominant", "tower"],
        ["hero", "win", "fear", "confidence", "strength"]
      ],
      "minMatches": 1,
      "hint": "Which angle made a character feel powerful in the lesson? That's the one for her winning moment.",
      "sampleAnswer": "I'd ask for a low angle looking up at her — it makes her feel powerful and dominant, which matches the feeling of a hero overcoming her fear." }
  ],
  "tomorrow": "Day 3 — Prompting the camera: giving it movement, not just position."
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;

-- ─── Day 3 — Prompting the camera (EXISTING 'demo' lesson, revised) ─────────
-- Keeps the same id (progress rows + /lesson/demo stay valid). Shot-size
-- sorting moved to Day 1, so this lesson now focuses purely on MOVEMENT —
-- adds a read + drag_sort + type_answer around the original select + lever.
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('demo', 'AI Video & Cinema', 3, 'Prompting the camera', 15,
$json${
  "beats": [
    { "id": "b1", "type": "read",
      "prompt": "First, the idea.",
      "title": "A still camera and a moving camera tell different stories",
      "body": [
        "So far the camera has been still — a position, a shot size, an angle. But cameras also move, and movement is its own language.",
        "A locked-off (still) camera feels calm and observational — you're just watching. A push-in (the camera itself travels closer) feels intimate and building — we lean into a feeling. A pan (camera swivels in place) reveals something new. A tracking shot follows action, keeping you in the middle of it.",
        "When you write a prompt like \"the camera slowly pushes in,\" you're not describing what's in the shot — you're directing how the camera itself behaves."
      ],
      "keyPoints": [
        "Locked-off = calm, observational.",
        "Push-in = building intimacy or tension.",
        "Movement is a direction to the camera, not the subject."
      ] },
    { "id": "b2", "type": "drag_sort",
      "prompt": "Sort each camera movement to what it's best for.",
      "items": [
        { "id": "i1", "label": "Locked-off (no movement)" },
        { "id": "i2", "label": "Slow push-in" },
        { "id": "i3", "label": "Pan (swivel to reveal)" },
        { "id": "i4", "label": "Tracking shot (follows the action)" }
      ],
      "buckets": [
        { "id": "calm", "label": "Calm observation" },
        { "id": "emotion", "label": "Building emotion" },
        { "id": "action", "label": "Following action / revealing" }
      ],
      "correct": { "i1": "calm", "i2": "emotion", "i3": "action", "i4": "action" } },
    { "id": "b3", "type": "select",
      "prompt": "Predict what the camera does.",
      "question": "You write: “the camera slowly pushes in on her face.” What happens?",
      "options": [
        { "id": "o1", "label": "The camera moves closer to her", "explain": "Yes — “push in” means the camera itself travels toward the subject, building tension." },
        { "id": "o2", "label": "She walks toward the camera", "explain": "Not quite — that would be the subject moving. “Push in” is the camera moving." },
        { "id": "o3", "label": "The image zooms with no movement", "explain": "Close, but a zoom flattens depth. A push-in physically moves, so the background shifts too — it feels alive." }
      ],
      "correct": "o1" },
    { "id": "b4", "type": "lever",
      "prompt": "Pull the lever to change how fast the camera moves. Land on a slow, emotional push-in.",
      "minLabel": "Still", "maxLabel": "Fast",
      "states": [
        { "label": "Locked off", "description": "No movement. Calm, observational — the viewer just watches.", "image": "/media/l6-motion-locked.jpg" },
        { "label": "Slow push-in", "description": "A gentle drift closer. Intimate, emotional — we lean into her feeling.", "image": "/media/l6-motion-push.jpg" },
        { "label": "Steady dolly", "description": "A clear, deliberate move. Cinematic and confident.", "image": "/media/l6-motion-dolly.jpg" },
        { "label": "Fast whip", "description": "A sudden rush. Energetic, tense — great for action, wrong for a quiet moment.", "image": "/media/l6-motion-whip.jpg" }
      ],
      "target": 1 },
    { "id": "b5", "type": "type_answer",
      "prompt": "Make the idea yours.",
      "question": "When would you deliberately choose a locked-off (still) camera instead of any movement at all?",
      "keywords": [
        ["calm", "still", "quiet", "observ", "steady", "simple"],
        ["distract", "focus", "attention", "dialogue", "moment"]
      ],
      "minMatches": 1,
      "hint": "Movement draws attention to itself. Sometimes the moment is strong enough on its own.",
      "sampleAnswer": "I'd use a locked-off camera for a quiet, still moment — like two people just talking — where any movement would distract from the emotion already in the scene." }
  ],
  "tomorrow": "Day 4 — Lighting a face so it feels like a movie."
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;

-- ─── Day 4 — Lighting a face like a movie ───────────────────────────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('video-4', 'AI Video & Cinema', 4, 'Lighting a face like a movie', 15,
$json${
  "beats": [
    { "id": "b1", "type": "read",
      "prompt": "First, the idea.",
      "title": "Light is mood — three lights, endless feelings",
      "body": [
        "The classic film setup uses three lights. The key light is the main source, lighting the face and setting the overall look. The fill light softens the shadows the key light creates, so the face doesn't look half-hidden. The back light separates the person from the background, giving them a subtle glow around the edges.",
        "How you balance these three lights changes everything. Bright, even key + fill = a cheerful, safe mood. A strong key with almost no fill = harsh shadows, drama, danger. Remove the back light and people flatten into their background — no separation, no polish.",
        "When you prompt AI video, describing the light (\"soft window light,\" \"harsh single lamp,\" \"golden backlight at sunset\") does as much emotional work as describing the shot itself."
      ],
      "keyPoints": [
        "Key light = main source, sets the look.",
        "Fill light = softens shadows.",
        "Back light = separates subject from background."
      ] },
    { "id": "b2", "type": "watch",
      "prompt": "Watch: the three lights explained (4 min).",
      "videoId": "BfH4gDTi6ME", "end": 240,
      "source": "Media Studies Pro — Three-Point Lighting Mastery" },
    { "id": "b3", "type": "drag_sort",
      "prompt": "Sort each light to its job.",
      "items": [
        { "id": "i1", "label": "Main light on the face, sets the overall look" },
        { "id": "i2", "label": "Softens the harsh shadows from the main light" },
        { "id": "i3", "label": "Creates a glowing edge that separates the person from the background" }
      ],
      "buckets": [
        { "id": "key", "label": "Key light" },
        { "id": "fill", "label": "Fill light" },
        { "id": "back", "label": "Back light" }
      ],
      "correct": { "i1": "key", "i2": "fill", "i3": "back" } },
    { "id": "b4", "type": "select",
      "prompt": "Predict the mood.",
      "question": "A scene uses one hard light from below, no fill light at all, deep shadows on the face. What mood does this create?",
      "options": [
        { "id": "o1", "label": "Warm and cheerful", "explain": "The opposite — hard light with deep unfilled shadows reads as tense or frightening, not warm." },
        { "id": "o2", "label": "Tense, eerie, or villainous", "explain": "Exactly. Hard shadows with no softening fill is classic horror and villain lighting — it hides as much as it shows." },
        { "id": "o3", "label": "Completely neutral, no mood at all", "explain": "Lighting always creates mood — there's no neutral option. This particular setup reads as tense or scary." }
      ],
      "correct": "o2" },
    { "id": "b5", "type": "lever",
      "prompt": "Pull the lever through four lighting moods and watch the same face change feeling.",
      "minLabel": "Flat", "maxLabel": "Extreme",
      "states": [
        { "label": "Flat, even light", "description": "Bright key and fill balanced evenly. Safe, neutral, a little dull — like an office.", "image": "/media/l6-light-flat.jpg" },
        { "label": "Soft key + fill", "description": "Gentle key light, soft fill. Warm, natural, flattering — the classic “beautiful” look.", "image": "/media/l6-light-soft.jpg" },
        { "label": "Dramatic, low-key", "description": "Strong key, minimal fill, deep shadows on one side. Moody, cinematic, serious.", "image": "/media/l6-light-dramatic.jpg" },
        { "label": "Horror, hard underlight", "description": "Harsh light from below, no fill at all. Unsettling, frightening — breaks every “flattering” rule on purpose.", "image": "/media/l6-light-horror.jpg" }
      ],
      "target": 1 },
    { "id": "b6", "type": "type_answer",
      "prompt": "Make the idea yours.",
      "question": "You're prompting a clip of two old friends reuniting after years apart. Describe the lighting you'd ask for, and why.",
      "keywords": [
        ["soft", "warm", "gentle", "golden", "natural"],
        ["happy", "warm", "reunion", "joy", "comfort", "safe"]
      ],
      "minMatches": 1,
      "hint": "A joyful, safe moment calls for soft, warm, flattering light — not harsh shadows.",
      "sampleAnswer": "I'd ask for soft, warm key and fill light, maybe golden like late afternoon sun — it matches the warmth and safety of the reunion, without any harsh shadows to fight the mood." }
  ],
  "tomorrow": "Day 5 — Planning before you prompt: loglines, beats, and shot lists."
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;

-- ─── Day 5 — Planning before you prompt (script writing basics) ────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('video-5', 'AI Video & Cinema', 5, 'Planning before you prompt', 14,
$json${
  "beats": [
    { "id": "b1", "type": "read",
      "prompt": "First, the idea.",
      "title": "Even a 10-second AI clip deserves a plan",
      "image": { "src": "/media/l6-planning.jpg", "alt": "Storyboard sketches and a script page laid out on a desk", "caption": "Planning takes minutes. Skipping it costs hours of retries." },
      "body": [
        "It's tempting to just type a prompt and hit generate. But the students who make the most memorable clips plan first — even briefly. Planning isn't bureaucracy, it's thinking before spending.",
        "A logline is one sentence: who wants what, and what's stopping them. A beat sheet is 2-3 short lines: what happens first, what changes, how it ends. A shot list is the order of shots you'll need — wide, then medium, then close, in the sequence that tells the story.",
        "For AI video, planning also saves your credits: knowing exactly what shot you want before you prompt means fewer wasted generations chasing an idea you hadn't actually decided on yet."
      ],
      "keyPoints": [
        "Logline = one sentence: who wants what, what's in the way.",
        "Beat sheet = the 2-3 moments that make the story.",
        "Shot list = the order of shots you'll generate."
      ] },
    { "id": "b2", "type": "watch",
      "prompt": "Watch: how a short story actually gets written (4 min).",
      "videoId": "0SNaOisC2II", "end": 240,
      "source": "Film Riot — How To Write A Screenplay (For Beginners)" },
    { "id": "b3", "type": "read",
      "prompt": "One more piece before you plan your own.",
      "title": "The 3-beat mini structure",
      "body": [
        "You don't need a whole screenplay for a short AI clip — you need three beats. Setup: show the normal situation in one shot. Turn: something changes or is revealed. Payoff: the result of that change, the feeling you leave the viewer with.",
        "A student's 15-second clip: Setup — a woman waters a dead-looking plant (wide shot, flat light). Turn — a single green leaf unfurls (close-up, push-in, warm light). Payoff — she smiles, camera pulls back to show a whole windowsill of plants she's brought back (wide shot). Three shots, one clear feeling."
      ],
      "keyPoints": [
        "Setup → Turn → Payoff is enough structure for a short clip.",
        "Each beat can be one shot with its own size, angle, movement, and light."
      ] },
    { "id": "b4", "type": "drag_sort",
      "prompt": "Sort each planning document to what it actually is.",
      "items": [
        { "id": "i1", "label": "“A tired delivery rider finds one small kindness on his hardest night.”" },
        { "id": "i2", "label": "Wide (street) → close-up (his tired face) → medium (the kindness) → wide (he rides on, lighter)" },
        { "id": "i3", "label": "Setup: he's exhausted. Turn: a stranger helps. Payoff: he smiles." }
      ],
      "buckets": [
        { "id": "logline", "label": "Logline" },
        { "id": "shotlist", "label": "Shot list" },
        { "id": "beats", "label": "Beat sheet" }
      ],
      "correct": { "i1": "logline", "i2": "shotlist", "i3": "beats" } },
    { "id": "b5", "type": "type_answer",
      "prompt": "Now plan your own — no wrong answers here.",
      "question": "Write a one-sentence logline for an AI clip you'd love to make. Who wants what, and what's in the way?",
      "keywords": [],
      "minMatches": 0,
      "hint": "",
      "sampleAnswer": "" }
  ],
  "tomorrow": "Day 6 — Meet Higgsfield: your AI camera crew."
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;

-- ─── Day 6 — Meet Higgsfield (platform literacy) ────────────────────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('video-6', 'AI Video & Cinema', 6, 'Meet Higgsfield — your AI camera crew', 14,
$json${
  "beats": [
    { "id": "b1", "type": "read",
      "prompt": "First, the idea.",
      "title": "One platform, many AI directors to choose from",
      "image": { "src": "/media/l6-higgsfield.jpg", "alt": "A dashboard showing multiple AI video model options side by side", "caption": "Different models, different strengths — Higgsfield lets you compare." },
      "body": [
        "Higgsfield is a platform that gives you access to several different AI video models — like Veo, Kling, Sora, and others — all from one place, instead of signing up for each one separately.",
        "Why does that matter? Because no single AI model is best at everything. One might handle realistic human motion better; another might be stronger with stylized or animated looks. Higgsfield lets you write your prompt once and compare how different models interpret the same shot — using everything you've learned about shot size, angle, movement, and light.",
        "It also has editing tools after generation — so if a clip is almost right, you can touch up specific areas instead of starting over and spending more credits."
      ],
      "keyPoints": [
        "Higgsfield hosts multiple AI video models in one workspace.",
        "Comparing models helps you pick the best result for your specific shot.",
        "Edit tools let you fix small things without regenerating from scratch."
      ] },
    { "id": "b1b", "type": "read",
      "prompt": "The single most important habit before you touch any platform.",
      "title": "Start from an image, then animate it",
      "body": [
        "Every AI video tool gives you two starting points. Text-to-video: type a prompt, get a moving clip straight away. Image-to-video: first generate (or pick) ONE still image, check it looks exactly right, THEN tell the AI how that exact image should move.",
        "Text-to-video is fast, but you're gambling — the AI decides the framing, the character's face, the composition, all in one step, and it can shift slightly every time you regenerate. You spend credits without knowing what you'll get.",
        "Image-to-video flips that. You already know how to build a strong still — shot size (Day 1), angle (Day 2), lighting (Day 4) — everything you've learned so far is really \"how to compose one great frame.\" Nail that frame first, confirm it's right, THEN animate it with movement (Day 3) on top. You're directing a photo into becoming a scene, one confirmed decision at a time.",
        "This is also why planning (Day 5) matters so much: a shot list is really a list of stills to generate first, in order, before any of them get animated."
      ],
      "keyPoints": [
        "Text-to-video = fast, but you don't control the exact frame.",
        "Image-to-video = generate the still first, confirm it, then animate it — far more control.",
        "This is the default workflow most working AI creators use, on Higgsfield and elsewhere."
      ] },
    { "id": "b1c", "type": "select",
      "prompt": "Use the idea before you watch it in action.",
      "question": "You need your character's face to look exactly right — same face the whole scene. Which starting approach gives you the most control over that?",
      "options": [
        { "id": "o1", "label": "Text-to-video — type a prompt and generate the clip directly", "explain": "Text-to-video decides the face and framing for you in one step — you won't know exactly what you'll get, and it can shift between generations." },
        { "id": "o2", "label": "Image-to-video — generate a still image first, confirm it looks right, then animate it", "explain": "Exactly — you lock in the exact face and frame as a still first, THEN animate it. No surprises." },
        { "id": "o3", "label": "Generate ten clips and pick the best one", "explain": "That burns ten times the credits chasing luck. Locking the frame first with image-to-video gets you there in one confirmed step." }
      ],
      "correct": "o2" },
    { "id": "b2", "type": "watch",
      "prompt": "Watch: using Higgsfield as a total beginner (5 min).",
      "videoId": "Pjw8nnxHo5I", "end": 300,
      "source": "Mariana Montoya — How to use Higgsfield AI for Beginners" },
    { "id": "b3", "type": "select",
      "prompt": "Use the idea.",
      "question": "Your first generation looks close but the character's motion feels stiff and unnatural. What's a smart next move on a multi-model platform?",
      "options": [
        { "id": "o1", "label": "Try the same prompt on a different available model", "explain": "Exactly the advantage of a platform like this — different models have different strengths, so switching can fix an issue without changing your idea at all." },
        { "id": "o2", "label": "Give up on the shot entirely", "explain": "Too early to give up — the idea might be fine, just mismatched to that particular model. Try another one first." },
        { "id": "o3", "label": "Make the prompt much longer and more complicated", "explain": "A longer prompt won't fix a model's weakness at motion. Trying a different model built for that strength is the faster fix." }
      ],
      "correct": "o1" },
    { "id": "b4", "type": "drag_sort",
      "prompt": "Sort each Higgsfield feature to what it's for.",
      "items": [
        { "id": "i1", "label": "Switching between Veo, Kling, Sora and others" },
        { "id": "i2", "label": "Brush-selecting one area of a clip to touch up" },
        { "id": "i3", "label": "Starting from a ready-made template instead of a blank prompt" }
      ],
      "buckets": [
        { "id": "compare", "label": "Comparing models" },
        { "id": "edit", "label": "Fixing after generating" },
        { "id": "start", "label": "Getting started fast" }
      ],
      "correct": { "i1": "compare", "i2": "edit", "i3": "start" } },
    { "id": "b5", "type": "type_answer",
      "prompt": "Make the idea yours.",
      "question": "In your own words: what's the benefit of a platform with many AI models, instead of just using one model's own app?",
      "keywords": [
        ["compare", "switch", "different", "options", "choose", "best"],
        ["model", "models", "strength", "strengths", "weakness"]
      ],
      "minMatches": 1,
      "hint": "Think about what happens when one model isn't great at something specific — what does having options let you do?",
      "sampleAnswer": "Different AI models are better at different things, so having them all in one place lets me compare results on the same prompt and pick whichever one actually nails my shot." }
  ],
  "tomorrow": "Day 7 — Meet Google Flow: keeping your story's world consistent."
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;

-- ─── Day 7 — Meet Google Flow (scenes & consistency) ────────────────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('video-7', 'AI Video & Cinema', 7, 'Meet Google Flow — scenes & consistency', 14,
$json${
  "beats": [
    { "id": "b1", "type": "read",
      "prompt": "First, the idea.",
      "title": "The hardest problem in AI video: staying consistent",
      "image": { "src": "/media/l6-flow.jpg", "alt": "A character reference image connected to multiple generated scene shots", "caption": "Same face, same outfit, every shot — that's an “ingredient.”" },
      "body": [
        "Google Flow is Google's AI filmmaking tool, built around Veo. Its biggest idea is something it calls “ingredients”: a consistent character, object, or style you create once — from a photo or a text prompt — and reuse across every shot in your story. This is the image-first habit from yesterday, taken further: instead of locking one still, you lock a reusable reference and animate multiple shots from it.",
        "Without an ingredient, every new shot you generate might give your character a slightly different face, outfit, or hair. With one, Flow keeps them recognizable from your wide shot all the way to your close-up — which is exactly what a real short film needs.",
        "Flow also has a Scene Builder for stitching multiple shots into one sequence, and lets you type camera instructions directly — “low angle,” “slow push-in,” “tracking shot” — using the exact vocabulary you've already learned this week."
      ],
      "keyPoints": [
        "An “ingredient” = a reusable character, object, or style reference.",
        "Consistency across shots is what makes a sequence feel like one story.",
        "Camera instructions in Flow use the same words you already know."
      ] },
    { "id": "b2", "type": "watch",
      "prompt": "Watch: Google Flow for total beginners (5 min).",
      "videoId": "yCmGsYFeCz0", "end": 300,
      "source": "The Pennywise Owl — Google Flow Veo 3 Tutorial for Beginners" },
    { "id": "b3", "type": "select",
      "prompt": "Diagnose the problem.",
      "question": "You generate three shots of your main character. In each one, her jacket is a different color. What went wrong?",
      "options": [
        { "id": "o1", "label": "No consistent “ingredient” reference was used for her", "explain": "Exactly — without a saved reference image or description locked in as an ingredient, the AI re-imagines her fresh each time." },
        { "id": "o2", "label": "The camera angle was wrong", "explain": "Angle affects how she's framed, not what color her jacket is — this is a consistency problem, not an angle problem." },
        { "id": "o3", "label": "You used too many shots", "explain": "Number of shots isn't the issue — even two shots would show the same inconsistency without a saved character reference." }
      ],
      "correct": "o1" },
    { "id": "b4", "type": "drag_sort",
      "prompt": "Sort each Flow concept to what it does.",
      "items": [
        { "id": "i1", "label": "A saved reference so your character looks the same in every shot" },
        { "id": "i2", "label": "Stitching several shots into one sequence" },
        { "id": "i3", "label": "Typing “low angle, slow push-in” directly into your prompt" }
      ],
      "buckets": [
        { "id": "ingredient", "label": "Ingredient" },
        { "id": "scenebuilder", "label": "Scene Builder" },
        { "id": "cameracontrol", "label": "Camera controls" }
      ],
      "correct": { "i1": "ingredient", "i2": "scenebuilder", "i3": "cameracontrol" } },
    { "id": "b5", "type": "type_answer",
      "prompt": "Make the idea yours — last question before you start creating for real.",
      "question": "In your own words: why does keeping a consistent “ingredient” matter for making a short film feel believable?",
      "keywords": [
        ["same", "consistent", "consistency", "recognizable", "match"],
        ["character", "story", "believe", "believable", "real", "confus"]
      ],
      "minMatches": 1,
      "hint": "Imagine watching a film where the main character looks like a different person every scene — what would that do to the story?",
      "sampleAnswer": "If the character looks different in every shot, the audience gets confused about who they're watching — a consistent ingredient keeps the story feeling like one real world instead of random disconnected clips." }
  ],
  "tomorrow": "You've finished the AI Video & Cinema foundations — next: your first real generation."
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;
