-- Chạy một lần trên Supabase hiện tại: SQL Editor > New query.
-- Tạo bảng điểm danh hằng ngày, liên kết mã nhân viên thông qua employee_id.
CREATE TABLE IF NOT EXISTS public.employee_attendance (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id uuid NOT NULL REFERENCES public.employees(id) ON DELETE CASCADE,
  attendance_date date NOT NULL,
  status text NOT NULL CHECK (
    status IN ('Đi làm','Nghỉ tự do','Nghỉ không phép','Nghỉ không lương','Nghỉ 1/2 ngày')
  ),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(employee_id, attendance_date)
);

ALTER TABLE public.employee_attendance ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "authenticated users can manage attendance" ON public.employee_attendance;
CREATE POLICY "authenticated users can manage attendance"
ON public.employee_attendance
FOR ALL TO authenticated
USING (true)
WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE
ON public.employee_attendance TO authenticated;

-- Trigger cập nhật updated_at khi thay đổi trạng thái
CREATE OR REPLACE FUNCTION public.set_employee_attendance_updated_at()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_employee_attendance_updated_at ON public.employee_attendance;
CREATE TRIGGER trg_employee_attendance_updated_at
BEFORE UPDATE ON public.employee_attendance
FOR EACH ROW EXECUTE FUNCTION public.set_employee_attendance_updated_at();

-- Kiểm tra bảng
SELECT table_name
FROM information_schema.tables
WHERE table_schema='public' AND table_name='employee_attendance';
