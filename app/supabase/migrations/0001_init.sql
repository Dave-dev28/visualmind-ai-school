-- AI School — thin-slice schema (PRD §3, §F1, §F8 manual-payment v1).
-- Auth (email+password) + access-code seat gate + lessons-from-DB + progress.
-- Scores/credits are NOT computed in this slice; the append-only credit ledger
-- and generation flow arrive with the `generate` beat.

-- ─────────────────────────────────────────────────────────────────────────────
-- Cohorts
-- ─────────────────────────────────────────────────────────────────────────────
create table if not exists public.cohorts (
  id             uuid primary key default gen_random_uuid(),
  name           text not null,
  starts_on      date,
  friday_reveal_at timestamptz,       -- weekly Friday reveal (PRD §F6)
  created_at     timestamptz not null default now()
);

-- ─────────────────────────────────────────────────────────────────────────────
-- Profiles — one per auth user, created by trigger on signup
-- ─────────────────────────────────────────────────────────────────────────────
create table if not exists public.profiles (
  id              uuid primary key references auth.users (id) on delete cascade,
  display_name    text,
  referral_source text,
  track           text,
  cohort_id       uuid references public.cohorts (id),
  seat_claimed    boolean not null default false,
  credits         integer not null default 0,   -- funded by admin grant via access code
  created_at      timestamptz not null default now()
);

-- ─────────────────────────────────────────────────────────────────────────────
-- Access codes — manual payment gate (PRD §F1/§F8 v1). Single-use, admin-issued.
-- Never directly readable by students; only the redeem function touches them.
-- ─────────────────────────────────────────────────────────────────────────────
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

-- ─────────────────────────────────────────────────────────────────────────────
-- Lessons — authored as JSON (PRD §F10). content matches the Beat[] TS types.
-- ─────────────────────────────────────────────────────────────────────────────
create table if not exists public.lessons (
  id         text primary key,        -- e.g. 'demo'
  track      text not null,
  day        integer not null,
  title      text not null,
  minutes    integer not null default 0,
  content    jsonb not null,          -- { beats: [...], tomorrow: "..." }
  published  boolean not null default true,
  created_at timestamptz not null default now()
);

-- ─────────────────────────────────────────────────────────────────────────────
-- Lesson progress — per student, per lesson. Completion only (not a score).
-- ─────────────────────────────────────────────────────────────────────────────
create table if not exists public.lesson_progress (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users (id) on delete cascade,
  lesson_id  text not null references public.lessons (id),
  beats_done jsonb not null default '[]'::jsonb,   -- array of completed beat ids
  completed  boolean not null default false,
  updated_at timestamptz not null default now(),
  unique (user_id, lesson_id)
);

-- ─────────────────────────────────────────────────────────────────────────────
-- New-user trigger — create a profile row from signup metadata
-- ─────────────────────────────────────────────────────────────────────────────
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
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

-- ─────────────────────────────────────────────────────────────────────────────
-- redeem_access_code — the ONLY way a seat is claimed / credits granted.
-- Single-use enforced with row lock. Returns a status string.
-- ─────────────────────────────────────────────────────────────────────────────
create or replace function public.redeem_access_code(p_code text)
returns text
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid  uuid := auth.uid();
  v_code public.access_codes%rowtype;
begin
  if v_uid is null then
    return 'unauthenticated';
  end if;

  if exists (select 1 from public.profiles where id = v_uid and seat_claimed) then
    return 'already_claimed';
  end if;

  -- Lock the code row so two people can't redeem the same code at once.
  select * into v_code
  from public.access_codes
  where code = upper(trim(p_code)) and status = 'unused'
  for update;

  if not found then
    return 'invalid';
  end if;

  update public.access_codes
  set status = 'redeemed', redeemed_by = v_uid, redeemed_at = now()
  where id = v_code.id;

  update public.profiles
  set seat_claimed = true,
      cohort_id    = v_code.cohort_id,
      credits      = credits + v_code.credits_grant
  where id = v_uid;

  return 'ok';
end;
$$;

grant execute on function public.redeem_access_code(text) to authenticated;

-- ─────────────────────────────────────────────────────────────────────────────
-- Row Level Security
-- ─────────────────────────────────────────────────────────────────────────────
alter table public.cohorts        enable row level security;
alter table public.profiles       enable row level security;
alter table public.access_codes   enable row level security;
alter table public.lessons        enable row level security;
alter table public.lesson_progress enable row level security;

-- Profiles: a student reads only their own row. Mutations go through functions.
create policy "read own profile"
  on public.profiles for select
  using (auth.uid() = id);

-- Cohorts: any signed-in user can read (to show cohort name / Friday time).
create policy "authenticated read cohorts"
  on public.cohorts for select
  to authenticated using (true);

-- Lessons: published lessons are readable by any signed-in user.
create policy "authenticated read published lessons"
  on public.lessons for select
  to authenticated using (published);

-- Progress: a student fully manages only their own rows.
create policy "read own progress"
  on public.lesson_progress for select
  using (auth.uid() = user_id);
create policy "insert own progress"
  on public.lesson_progress for insert
  with check (auth.uid() = user_id);
create policy "update own progress"
  on public.lesson_progress for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- access_codes: intentionally NO policies → unreadable/unwritable by students.
-- Only redeem_access_code() (security definer) and admins (dashboard) touch it.
