-- ════════════════════════════════════════════════════════════════════════════
-- AI School — one-paste setup (schema + RLS + functions + seed).
-- Run this in the Supabase Dashboard → SQL Editor → New query → Run.
-- Safe to re-run (idempotent).
-- ════════════════════════════════════════════════════════════════════════════

-- ─── Cohorts ────────────────────────────────────────────────────────────────
create table if not exists public.cohorts (
  id             uuid primary key default gen_random_uuid(),
  name           text not null,
  starts_on      date,
  friday_reveal_at timestamptz,
  created_at     timestamptz not null default now()
);

-- ─── Profiles ───────────────────────────────────────────────────────────────
create table if not exists public.profiles (
  id              uuid primary key references auth.users (id) on delete cascade,
  display_name    text,
  referral_source text,
  track           text,
  cohort_id       uuid references public.cohorts (id),
  seat_claimed    boolean not null default false,
  credits         integer not null default 0,
  created_at      timestamptz not null default now()
);

-- ─── Access codes (manual payment gate) ─────────────────────────────────────
create table if not exists public.access_codes (
  id            uuid primary key default gen_random_uuid(),
  code          text not null unique,
  cohort_id     uuid references public.cohorts (id),
  credits_grant integer not null default 0,
  status        text not null default 'unused' check (status in ('unused','redeemed')),
  redeemed_by   uuid references auth.users (id),
  redeemed_at   timestamptz,
  created_at    timestamptz not null default now()
);

-- ─── Lessons (JSON authored) ────────────────────────────────────────────────
create table if not exists public.lessons (
  id         text primary key,
  track      text not null,
  day        integer not null,
  title      text not null,
  minutes    integer not null default 0,
  content    jsonb not null,
  published  boolean not null default true,
  created_at timestamptz not null default now()
);

-- ─── Lesson progress ────────────────────────────────────────────────────────
create table if not exists public.lesson_progress (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users (id) on delete cascade,
  lesson_id  text not null references public.lessons (id),
  beats_done jsonb not null default '[]'::jsonb,
  completed  boolean not null default false,
  updated_at timestamptz not null default now(),
  unique (user_id, lesson_id)
);

-- ─── New-user trigger ───────────────────────────────────────────────────────
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (id, display_name, referral_source)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'display_name', ''),
    new.raw_user_meta_data ->> 'referral_source'
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ─── redeem_access_code (single-use, security definer) ──────────────────────
create or replace function public.redeem_access_code(p_code text)
returns text language plpgsql security definer set search_path = '' as $$
declare
  v_uid  uuid := auth.uid();
  v_code public.access_codes%rowtype;
begin
  if v_uid is null then return 'unauthenticated'; end if;

  if exists (select 1 from public.profiles where id = v_uid and seat_claimed) then
    return 'already_claimed';
  end if;

  select * into v_code
  from public.access_codes
  where code = upper(trim(p_code)) and status = 'unused'
  for update;

  if not found then return 'invalid'; end if;

  update public.access_codes
  set status = 'redeemed', redeemed_by = v_uid, redeemed_at = now()
  where id = v_code.id;

  update public.profiles
  set seat_claimed = true, cohort_id = v_code.cohort_id,
      credits = credits + v_code.credits_grant
  where id = v_uid;

  return 'ok';
end;
$$;

grant execute on function public.redeem_access_code(text) to authenticated;

-- ─── Row Level Security ─────────────────────────────────────────────────────
alter table public.cohorts         enable row level security;
alter table public.profiles        enable row level security;
alter table public.access_codes    enable row level security;
alter table public.lessons         enable row level security;
alter table public.lesson_progress enable row level security;

drop policy if exists "read own profile" on public.profiles;
create policy "read own profile" on public.profiles
  for select using (auth.uid() = id);

drop policy if exists "authenticated read cohorts" on public.cohorts;
create policy "authenticated read cohorts" on public.cohorts
  for select to authenticated using (true);

drop policy if exists "authenticated read published lessons" on public.lessons;
create policy "authenticated read published lessons" on public.lessons
  for select to authenticated using (published);

drop policy if exists "read own progress" on public.lesson_progress;
create policy "read own progress" on public.lesson_progress
  for select using (auth.uid() = user_id);

drop policy if exists "insert own progress" on public.lesson_progress;
create policy "insert own progress" on public.lesson_progress
  for insert with check (auth.uid() = user_id);

drop policy if exists "update own progress" on public.lesson_progress;
create policy "update own progress" on public.lesson_progress
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
-- access_codes: intentionally NO policies (unreadable by students).

-- ════════════════════════════════════════════════════════════════════════════
-- SEED
-- ════════════════════════════════════════════════════════════════════════════
insert into public.cohorts (id, name, starts_on, friday_reveal_at)
values ('00000000-0000-0000-0000-000000000001', 'Pilot — Week 1',
  current_date, (date_trunc('week', now()) + interval '4 days 18 hours'))
on conflict (id) do nothing;

insert into public.lessons (id, track, day, title, minutes, content, published)
values ('demo', 'AI Video & Cinema', 3, 'Prompting the camera', 6,
$json${
  "beats": [
    { "id": "b1", "type": "drag_sort",
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
      "correct": { "i1": "close", "i2": "medium", "i3": "wide", "i4": "wide" } },
    { "id": "b2", "type": "select",
      "prompt": "Predict what the camera does.",
      "question": "You write: “the camera slowly pushes in on her face.” What happens?",
      "options": [
        { "id": "o1", "label": "The camera moves closer to her", "explain": "Yes — “push in” means the camera itself travels toward the subject, building tension." },
        { "id": "o2", "label": "She walks toward the camera", "explain": "Not quite — that would be the subject moving. “Push in” is the camera moving." },
        { "id": "o3", "label": "The image zooms with no movement", "explain": "Close, but a zoom flattens depth. A push-in physically moves, so the background shifts too — it feels alive." }
      ],
      "correct": "o1" },
    { "id": "b3", "type": "lever",
      "prompt": "Pull the lever to change how fast the camera moves. Land on a slow, emotional push-in.",
      "minLabel": "Still", "maxLabel": "Fast",
      "states": [
        { "label": "Locked off", "description": "No movement. Calm, observational — the viewer just watches." },
        { "label": "Slow push-in", "description": "A gentle drift closer. Intimate, emotional — we lean into her feeling." },
        { "label": "Steady dolly", "description": "A clear, deliberate move. Cinematic and confident." },
        { "label": "Fast whip", "description": "A sudden rush. Energetic, tense — great for action, wrong for a quiet moment." }
      ],
      "target": 1 }
  ],
  "tomorrow": "Day 4 — Lighting a face so it feels like a movie."
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;

insert into public.access_codes (code, cohort_id, credits_grant)
values
  ('PILOT-001', '00000000-0000-0000-0000-000000000001', 100),
  ('PILOT-002', '00000000-0000-0000-0000-000000000001', 100),
  ('PILOT-003', '00000000-0000-0000-0000-000000000001', 100),
  ('PILOT-004', '00000000-0000-0000-0000-000000000001', 100),
  ('PILOT-005', '00000000-0000-0000-0000-000000000001', 100)
on conflict (code) do nothing;
