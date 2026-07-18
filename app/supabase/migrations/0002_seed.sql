-- Seed data for the pilot. Cohort + demo lesson (JSON authored, PRD §F10) +
-- a handful of single-use access codes for manual onboarding.

-- Pilot cohort — reveal next Friday 18:00 (PRD §F6 weekly Friday ritual).
insert into public.cohorts (id, name, starts_on, friday_reveal_at)
values (
  '00000000-0000-0000-0000-000000000001',
  'Pilot — Week 1',
  current_date,
  (date_trunc('week', now()) + interval '4 days 18 hours')  -- Friday 18:00 this week
)
on conflict (id) do nothing;

-- Demo lesson — same content as the design-lock lesson, now DB-authored.
insert into public.lessons (id, track, day, title, minutes, content, published)
values (
  'demo',
  'AI Video & Cinema',
  3,
  'Prompting the camera',
  6,
  $json${
    "beats": [
      {
        "id": "b1",
        "type": "drag_sort",
        "prompt": "Sort each shot into how close the camera is.",
        "items": [
          { "id": "i1", "label": "Eyes filling the frame" },
          { "id": "i2", "label": "Head and shoulders" },
          { "id": "i3", "label": "Whole body, head to toe" },
          { "id": "i4", "label": "Tiny figure in a huge landscape" }
        ],
        "buckets": [
          { "id": "close", "label": "Close-up" },
          { "id": "medium", "label": "Medium" },
          { "id": "wide", "label": "Wide" }
        ],
        "correct": { "i1": "close", "i2": "medium", "i3": "wide", "i4": "wide" }
      },
      {
        "id": "b2",
        "type": "select",
        "prompt": "Predict what the camera does.",
        "question": "You write: “the camera slowly pushes in on her face.” What happens?",
        "options": [
          { "id": "o1", "label": "The camera moves closer to her", "explain": "Yes — “push in” means the camera itself travels toward the subject, building tension." },
          { "id": "o2", "label": "She walks toward the camera", "explain": "Not quite — that would be the subject moving. “Push in” is the camera moving." },
          { "id": "o3", "label": "The image zooms with no movement", "explain": "Close, but a zoom flattens depth. A push-in physically moves, so the background shifts too — it feels alive." }
        ],
        "correct": "o1"
      },
      {
        "id": "b3",
        "type": "lever",
        "prompt": "Pull the lever to change how fast the camera moves. Land on a slow, emotional push-in.",
        "minLabel": "Still",
        "maxLabel": "Fast",
        "states": [
          { "label": "Locked off", "description": "No movement. Calm, observational — the viewer just watches." },
          { "label": "Slow push-in", "description": "A gentle drift closer. Intimate, emotional — we lean into her feeling." },
          { "label": "Steady dolly", "description": "A clear, deliberate move. Cinematic and confident." },
          { "label": "Fast whip", "description": "A sudden rush. Energetic, tense — great for action, wrong for a quiet moment." }
        ],
        "target": 1
      }
    ],
    "tomorrow": "Day 4 — Lighting a face so it feels like a movie."
  }$json$::jsonb,
  true
)
on conflict (id) do update
  set track = excluded.track, day = excluded.day, title = excluded.title,
      minutes = excluded.minutes, content = excluded.content,
      published = excluded.published;

-- Pilot access codes (single-use). David hands these out after payment.
insert into public.access_codes (code, cohort_id, credits_grant)
values
  ('PILOT-001', '00000000-0000-0000-0000-000000000001', 100),
  ('PILOT-002', '00000000-0000-0000-0000-000000000001', 100),
  ('PILOT-003', '00000000-0000-0000-0000-000000000001', 100),
  ('PILOT-004', '00000000-0000-0000-0000-000000000001', 100),
  ('PILOT-005', '00000000-0000-0000-0000-000000000001', 100)
on conflict (code) do nothing;
