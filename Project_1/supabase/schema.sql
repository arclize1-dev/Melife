create table if not exists public.calendar_events (
  id text primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  event_date date not null,
  title text not null,
  event_time time,
  yearly boolean not null default false,
  color text not null default 'purple'
    check (color in ('purple', 'green', 'orange', 'pink', 'blue', 'red', 'white')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists calendar_events_user_date_idx
  on public.calendar_events (user_id, event_date);

revoke all on public.calendar_events from anon;
grant select, insert, update, delete on public.calendar_events to authenticated;

alter table public.calendar_events enable row level security;

drop policy if exists "Users can read their own calendar events" on public.calendar_events;
create policy "Users can read their own calendar events"
  on public.calendar_events for select
  using (auth.uid() = user_id);

drop policy if exists "Users can create their own calendar events" on public.calendar_events;
create policy "Users can create their own calendar events"
  on public.calendar_events for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own calendar events" on public.calendar_events;
create policy "Users can update their own calendar events"
  on public.calendar_events for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own calendar events" on public.calendar_events;
create policy "Users can delete their own calendar events"
  on public.calendar_events for delete
  using (auth.uid() = user_id);

create table if not exists public.expenses (
  id text primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  expense_date date not null,
  title text not null,
  amount numeric(12, 2) check (amount is null or amount >= 0),
  recurrence text not null default ''
    check (recurrence in ('', 'monthly', 'yearly')),
  paid_dates date[] not null default '{}',
  skipped_dates date[] not null default '{}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.expenses
  add column if not exists skipped_dates date[] not null default '{}';

create index if not exists expenses_user_date_idx
  on public.expenses (user_id, expense_date);

revoke all on public.expenses from anon;
grant select, insert, update, delete on public.expenses to authenticated;

alter table public.expenses enable row level security;

drop policy if exists "Users can read their own expenses" on public.expenses;
create policy "Users can read their own expenses"
  on public.expenses for select
  using (auth.uid() = user_id);

drop policy if exists "Users can create their own expenses" on public.expenses;
create policy "Users can create their own expenses"
  on public.expenses for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own expenses" on public.expenses;
create policy "Users can update their own expenses"
  on public.expenses for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own expenses" on public.expenses;
create policy "Users can delete their own expenses"
  on public.expenses for delete
  using (auth.uid() = user_id);
