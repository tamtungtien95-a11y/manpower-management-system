-- Dùng khi tạo mới hoàn toàn. Với Project đang có dữ liệu, chạy migration_update_employees.sql.
create extension if not exists pgcrypto;

create table if not exists public.employees (
  id uuid primary key default gen_random_uuid(),
  hire_date date,
  employee_code text not null unique,
  full_name text not null,
  team text not null check (team in ('Kitting','Shipment','Shift LD','Item')),
  classification text,
  created_at timestamptz not null default now()
);

create table if not exists public.manpower_reports (
  id uuid primary key default gen_random_uuid(),
  employee_id uuid not null references public.employees(id) on delete cascade,
  report_date date not null,
  created_at timestamptz not null default now(),
  unique(employee_id, report_date)
);

alter table public.employees enable row level security;
alter table public.manpower_reports enable row level security;

drop policy if exists "authenticated users can manage employees" on public.employees;
create policy "authenticated users can manage employees"
on public.employees for all to authenticated using (true) with check (true);

drop policy if exists "authenticated users can manage reports" on public.manpower_reports;
create policy "authenticated users can manage reports"
on public.manpower_reports for all to authenticated using (true) with check (true);

grant usage on schema public to authenticated;
grant select, insert, update, delete on public.employees to authenticated;
grant select, insert, update, delete on public.manpower_reports to authenticated;
