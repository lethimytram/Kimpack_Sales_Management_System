## Giới thiệu về dự án KIMPACK

### Mục đích của Dự án

- Ôn lại kiến thức **HTML**, **CSS**, **Bootstrap**.  
- Lập trình với ngôn ngữ **C#**, **ASP.NET Core**, **Azure Page Model** (**lập trình hướng đối tượng**).  
- Ôn lại kiến thức **cơ sở dữ liệu SQL Server**.  
- Bài tập lớn môn **quản trị cơ sở dữ liệu**.  

### Kế hoạch

1. **Phân tích và thiết kế website**
   - Khởi tạo project  
   - Xây dựng CSDL **Kimpack**  
   - Chuẩn bị EF Core Database First  
     i. Phát sinh Entity Model  
     ii. Khai báo chuỗi kết nối `appsettings.json`  
     iii. Cấu hình để dụng **DbContext**

2. **Xây dựng Layout cho website**
   - Layout trang khách hàng  
   - Module hóa các thành phần giao diện  
   - Menu động sử dụng **ViewComponent**  
   - Đa ngôn ngữ  
   - Viết mã cho các module giao diện của layout trang chủ:  
     + Nhà cung cấp  
     + Khách hàng  
     + Bán hàng
## Cách chạy dự án bằng Docker

### Yêu cầu
- Docker và Docker Compose đã được cài đặt trên máy.

### Các bước thực hiện
1. Clone repository:
   ```bash
   git clone https://github.com/username/repository.git
   cd repository
     + Mua nguyên vật liệu 
     + Sản phẩm
     + Nguyên vật liệu
2. Chạy con
   ```docker run -p 5000:80 yourprojectname

