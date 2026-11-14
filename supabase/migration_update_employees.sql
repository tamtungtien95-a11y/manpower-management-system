-- Chạy một lần trên Supabase hiện tại: SQL Editor > New query.
-- Bổ sung ngày vào công ty và phân loại nhân viên.
ALTER TABLE public.employees
  ADD COLUMN IF NOT EXISTS hire_date date,
  ADD COLUMN IF NOT EXISTS classification text;

-- Bỏ CHECK cũ liên quan đến team (bản fixed cũ chỉ cho Kitting/Shipment),
-- rồi cho phép 4 nhóm mới.
DO $$
DECLARE c record;
BEGIN
  FOR c IN
    SELECT con.conname
    FROM pg_constraint con
    JOIN pg_class rel ON rel.oid = con.conrelid
    JOIN pg_namespace nsp ON nsp.oid = rel.relnamespace
    WHERE nsp.nspname = 'public'
      AND rel.relname = 'employees'
      AND con.contype = 'c'
      AND pg_get_constraintdef(con.oid) ILIKE '%team%'
  LOOP
    EXECUTE format('ALTER TABLE public.employees DROP CONSTRAINT %I', c.conname);
  END LOOP;
END $$;

ALTER TABLE public.employees
  ADD CONSTRAINT employees_team_allowed_check
  CHECK (team IN ('Kitting','Shipment','Shift LD','Item'));

-- Kiểm tra cột và các nhóm hiện có.
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema='public' AND table_name='employees'
ORDER BY ordinal_position;

SELECT team, count(*) AS total
FROM public.employees
GROUP BY team
ORDER BY team;
