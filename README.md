# Quản lý nhân lực - Supabase + Cloudflare Pages

## 1. Tạo Supabase
1. Tạo project tại https://supabase.com/
2. Vào SQL Editor, chọn New query.
3. Mở `supabase/schema.sql`, sao chép toàn bộ và Run.
4. Vào Project Settings > API (hoặc Data API) lấy Project URL và Publishable key (hoặc anon public key).
5. File `index.html` trong gói này đã được điền sẵn Project URL và Publishable Key do bạn cung cấp. Không cần dán hai dòng này vào SQL Editor. Nếu thay Project khác, chỉ sửa hai dòng JavaScript trong `index.html` bằng Notepad.
   - Chỉ dùng Publishable key / anon public key ở trình duyệt.
   - TUYỆT ĐỐI không đưa service_role hoặc secret key vào HTML.
6. Vào Authentication > Providers > Email, bật Email nếu cần.
7. Tạo tài khoản trong ứng dụng bằng email và mật khẩu. Nếu bật xác nhận email, xác nhận email trước khi đăng nhập.

## 2. Đưa mã nguồn lên GitHub
1. Tạo repository GitHub, ví dụ `manpower-report`.
2. Upload `index.html` và thư mục `supabase` lên thư mục gốc repository.
3. Kiểm tra `index.html` nằm ngay ở thư mục gốc, không nằm trong thư mục con.

## 3. Deploy Cloudflare Pages
1. Đăng nhập https://dash.cloudflare.com/
2. Workers & Pages > Create application > Pages > Connect to Git.
3. Chọn repository vừa tạo.
4. Framework preset: None.
5. Build command: để trống.
6. Build output directory: `.` (thư mục gốc).
7. Deploy. Cloudflare sẽ cấp URL dạng `https://ten-du-an.pages.dev`.

## 4. Cấu hình URL đăng nhập Supabase
Trong Supabase > Authentication > URL Configuration:
- Site URL: nhập URL Cloudflare Pages.
- Redirect URLs: thêm `https://ten-du-an.pages.dev/**`.

## Chức năng trong bản này
- Đăng ký/đăng nhập bằng Supabase Auth.
- Thêm, sửa, xóa nhân viên.
- Hai nhóm cố định: Kitting và Shipment.
- Ghi nhận nhân lực theo ngày; mỗi nhân viên chỉ có một bản ghi/ngày.
- Tổng hợp số nhân viên theo nhóm/ngày.

## Lưu ý
- Đây là bản nền tảng để chạy thử. Các chính sách RLS hiện cho phép mọi tài khoản đã đăng nhập quản lý toàn bộ dữ liệu.
- Không có trạng thái đi làm/nghỉ phép, giờ công, OT hoặc tính lương ở phiên bản này.
- Nếu dùng dữ liệu thật của công ty, hãy giới hạn người được tạo tài khoản và thiết kế phân quyền trước khi triển khai rộng.
- Mọi thay đổi `index.html` sau khi upload GitHub sẽ kích hoạt Cloudflare Pages deploy lại.


## Khắc phục lỗi Invalid login credentials
1. Kiểm tra email có xuất hiện trong Supabase > Authentication > Users của đúng Project này không.
2. Nếu chưa có, dùng Authentication > Users > Add user > Create new user để tạo tài khoản, nhập email và mật khẩu mới, bật Auto Confirm User nếu giao diện có tùy chọn.
3. Nếu tài khoản đã có, không tạo trùng. Hãy dùng chức năng đặt lại mật khẩu/Update user trong Dashboard hoặc tạo một tài khoản thử nghiệm bằng email khác mà bạn sở hữu.
4. Mở lại `index.html` bằng Chrome/Edge, nhấn Ctrl+F5 rồi đăng nhập bằng đúng email và mật khẩu đã đặt.
5. Lỗi `Invalid login credentials` không phải lỗi SQL và không thể sửa bằng cách chạy `const SUPABASE_URL` trong SQL Editor. Hai dòng `const` chỉ nằm trong file HTML.

## Thông tin kết nối đã cấu hình
Project URL: `https://juifxigovxddvmbwquyf.supabase.co`
Publishable key: đã được điền trong `index.html`. Đây là khóa publishable dùng phía trình duyệt; không đưa Secret/service_role key vào website.


## Cập nhật phiên bản quản lý nhân viên (5 trường)
- Ngày Vào Cty
- Mã Nhân Viên (duy nhất)
- Họ Và tên
- Nhóm: Kitting / Shipment / Shift LD / Item
- Phân Loại: Chính Thức / Thời Vụ / Sinh Viên

### Với Supabase Project hiện tại
Không chạy lại schema.sql trên database đang có dữ liệu.
1. Mở Supabase > SQL Editor > New query.
2. Chạy toàn bộ `supabase/migration_update_employees.sql`.
3. Mở index.html mới bằng Chrome/Edge và đăng nhập tài khoản cũ.

### Excel
- Có nút tải file mẫu, nhập Excel/CSV và xuất danh sách Excel.
- Tiêu đề cột: Ngày Vào Cty, Mã Nhân Viên, Họ Và tên, Nhóm, Phân Loại.
- Nhóm hợp lệ: Kitting, Shipment, Shift LD, Item.
- Phân loại hợp lệ: Chính Thức, Thời Vụ, Sinh Viên.
- Mã đã tồn tại được cập nhật; mã mới được thêm; người không có trong file không bị xóa.


## Chức năng mới: Điểm danh nhân viên hằng ngày
Trước khi sử dụng chức năng mới, chạy `supabase/migration_create_attendance.sql` trong Supabase SQL Editor.
Chức năng hỗ trợ 5 trạng thái:
- Đi làm
- Nghỉ tự do
- Nghỉ không phép
- Nghỉ không lương
- Nghỉ 1/2 ngày

Tab `Điểm danh`:
- Chọn ngày điểm danh, lọc theo nhóm, tìm nhân viên.
- Chọn trạng thái trực tiếp cho từng nhân viên rồi nhấn Lưu điểm danh.
- Upload Excel theo 3 cột: `Mã Nhân Viên`, `Nhân Viên`, `Trạng Thái Nghỉ`.
- Ngày được lấy từ ô Ngày điểm danh trên giao diện.
- Kiểm tra mã nhân viên phải tồn tại; tên trong Excel phải khớp danh sách; trạng thái phải thuộc 5 lựa chọn; mã trùng trong file bị báo lỗi.
- Upload nhiều lần trong cùng ngày sẽ cập nhật trạng thái cũ theo mã nhân viên, không tạo dòng trùng.
- Có thể tải file Excel mẫu và xuất điểm danh của ngày đã chọn.

Không chạy lại `schema.sql` trên Project đang có dữ liệu. Chỉ chạy migration_create_attendance.sql để tạo bảng mới.
