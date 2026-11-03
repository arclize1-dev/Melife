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

create table if not exists public.daily_spending (
  id text primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  spending_date date not null,
  title text not null,
  amount numeric(12, 2) not null check (amount > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists daily_spending_user_date_idx
  on public.daily_spending (user_id, spending_date);

revoke all on public.daily_spending from anon;
grant select, insert, update, delete on public.daily_spending to authenticated;

alter table public.daily_spending enable row level security;

drop policy if exists "Users can read their own daily spending" on public.daily_spending;
create policy "Users can read their own daily spending"
  on public.daily_spending for select
  using (auth.uid() = user_id);

drop policy if exists "Users can create their own daily spending" on public.daily_spending;
create policy "Users can create their own daily spending"
  on public.daily_spending for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own daily spending" on public.daily_spending;
create policy "Users can update their own daily spending"
  on public.daily_spending for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own daily spending" on public.daily_spending;
create policy "Users can delete their own daily spending"
  on public.daily_spending for delete
  using (auth.uid() = user_id);

create table if not exists public.income_entries (
  id text primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  income_date date not null,
  title text not null,
  amount numeric(12, 2) not null check (amount > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists income_entries_user_date_idx
  on public.income_entries (user_id, income_date);

revoke all on public.income_entries from anon;
grant select, insert, update, delete on public.income_entries to authenticated;

alter table public.income_entries enable row level security;

drop policy if exists "Users can read their own income entries" on public.income_entries;
create policy "Users can read their own income entries"
  on public.income_entries for select
  using (auth.uid() = user_id);

drop policy if exists "Users can create their own income entries" on public.income_entries;
create policy "Users can create their own income entries"
  on public.income_entries for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own income entries" on public.income_entries;
create policy "Users can update their own income entries"
  on public.income_entries for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own income entries" on public.income_entries;
create policy "Users can delete their own income entries"
  on public.income_entries for delete
  using (auth.uid() = user_id);

create table if not exists public.monthly_budgets (
  id text primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  month_start date not null,
  amount numeric(12, 2) not null check (amount >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, month_start)
);

create index if not exists monthly_budgets_user_month_idx
  on public.monthly_budgets (user_id, month_start);

revoke all on public.monthly_budgets from anon;
grant select, insert, update, delete on public.monthly_budgets to authenticated;

alter table public.monthly_budgets enable row level security;

drop policy if exists "Users can read their own monthly budgets" on public.monthly_budgets;
create policy "Users can read their own monthly budgets"
  on public.monthly_budgets for select
  using (auth.uid() = user_id);

drop policy if exists "Users can create their own monthly budgets" on public.monthly_budgets;
create policy "Users can create their own monthly budgets"
  on public.monthly_budgets for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own monthly budgets" on public.monthly_budgets;
create policy "Users can update their own monthly budgets"
  on public.monthly_budgets for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own monthly budgets" on public.monthly_budgets;
create policy "Users can delete their own monthly budgets"
  on public.monthly_budgets for delete
  using (auth.uid() = user_id);
