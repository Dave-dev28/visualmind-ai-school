-- ════════════════════════════════════════════════════════════════════════════
-- AI School — Admin dashboard (PRD §F10, brought forward from v1 backlog).
-- David needs to see who's signed up, who still needs a seat, and generate
-- access codes without touching SQL directly.
--
-- Run in Supabase Dashboard → SQL Editor → Run. Safe to re-run (idempotent).
-- ════════════════════════════════════════════════════════════════════════════

-- ─── is_admin flag ───────────────────────────────────────────────────────────
alter table public.profiles add column if not exists is_admin boolean not null default false;

-- Grant yourself admin. Replace the email below with your own login email,
-- then run just this one line any time you need to promote another admin.
update public.profiles set is_admin = true
where id = (select id from auth.users where email = 'boiparis1993@gmail.com');

-- ─── admin_list_students(): profile + auth email in one call ────────────────
-- profiles has no email column (auth.users does) — a SECURITY DEFINER
-- function is the only clean way to join them without exposing auth.users
-- broadly via RLS.
create or replace function public.admin_list_students()
returns table (
  id uuid,
  email text,
  display_name text,
  track text,
  seat_claimed boolean,
  credits integer,
  cohort_name text,
  created_at timestamptz,
  last_sign_in_at timestamptz
)
language plpgsql security definer set search_path = '' as $$
begin
  if not exists (select 1 from public.profiles where id = auth.uid() and is_admin) then
    raise exception 'not authorized';
  end if;

  return query
    select p.id, u.email, p.display_name, p.track, p.seat_claimed, p.credits,
           c.name, p.created_at, u.last_sign_in_at
    from public.profiles p
    join auth.users u on u.id = p.id
    left join public.cohorts c on c.id = p.cohort_id
    order by p.created_at desc;
end;
$$;

grant execute on function public.admin_list_students() to authenticated;

-- ─── admin_list_codes(): every access code + its status ─────────────────────
create or replace function public.admin_list_codes()
returns table (
  id uuid,
  code text,
  cohort_name text,
  credits_grant integer,
  status text,
  redeemed_by_name text,
  redeemed_at timestamptz,
  created_at timestamptz
)
language plpgsql security definer set search_path = '' as $$
begin
  if not exists (select 1 from public.profiles where id = auth.uid() and is_admin) then
    raise exception 'not authorized';
  end if;

  return query
    select ac.id, ac.code, c.name, ac.credits_grant, ac.status,
           p.display_name, ac.redeemed_at, ac.created_at
    from public.access_codes ac
    left join public.cohorts c on c.id = ac.cohort_id
    left join public.profiles p on p.id = ac.redeemed_by
    order by ac.created_at desc;
end;
$$;

grant execute on function public.admin_list_codes() to authenticated;

-- ─── admin_generate_code(): create a fresh single-use code ──────────────────
create or replace function public.admin_generate_code(
  p_cohort_id uuid,
  p_credits integer default 100
)
returns text
language plpgsql security definer set search_path = '' as $$
declare
  v_code text;
begin
  if not exists (select 1 from public.profiles where id = auth.uid() and is_admin) then
    raise exception 'not authorized';
  end if;

  -- Short, readable, hard to confuse with I/O/0/1 by accident.
  v_code := 'AI-' || upper(substr(md5(gen_random_uuid()::text), 1, 6));

  insert into public.access_codes (code, cohort_id, credits_grant)
  values (v_code, p_cohort_id, p_credits);

  return v_code;
end;
$$;

grant execute on function public.admin_generate_code(uuid, integer) to authenticated;

-- ─── admin_list_cohorts(): for the "which cohort" picker ────────────────────
create or replace function public.admin_list_cohorts()
returns table (id uuid, name text, starts_on date, friday_reveal_at timestamptz)
language plpgsql security definer set search_path = '' as $$
begin
  if not exists (select 1 from public.profiles where id = auth.uid() and is_admin) then
    raise exception 'not authorized';
  end if;
  return query select c.id, c.name, c.starts_on, c.friday_reveal_at
    from public.cohorts c order by c.starts_on desc nulls last;
end;
$$;

grant execute on function public.admin_list_cohorts() to authenticated;
