-- ════════════════════════════════════════════════════════════════════════════
-- AI School — Tutor chat (PRD §F3): event-triggered, scoped, hint-first.
-- Run in Supabase Dashboard → SQL Editor → Run. Safe to re-run (idempotent).
-- ════════════════════════════════════════════════════════════════════════════

create table if not exists public.tutor_messages (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users (id) on delete cascade,
  lesson_id  text not null,
  beat_id    text not null,
  role       text not null check (role in ('user','assistant')),
  content    text not null,
  created_at timestamptz not null default now()
);

create index if not exists tutor_messages_user_day_idx
  on public.tutor_messages (user_id, created_at);

alter table public.tutor_messages enable row level security;

-- A student can log and read only their own tutor turns (§8 cost guardrail:
-- the daily-cap count in the API route reads through this same policy).
drop policy if exists "read own tutor messages" on public.tutor_messages;
create policy "read own tutor messages"
  on public.tutor_messages for select
  using (auth.uid() = user_id);

drop policy if exists "insert own tutor messages" on public.tutor_messages;
create policy "insert own tutor messages"
  on public.tutor_messages for insert
  with check (auth.uid() = user_id);
