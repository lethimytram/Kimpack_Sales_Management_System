using KIMPACK.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using KIMPACK.Data;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Lấy connection string từ appsettings.json
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

// Thêm dịch vụ vào container
builder.Services.AddControllersWithViews();  // Dùng cho các controller MVC nếu có
builder.Services.AddRazorPages();  // Thêm hỗ trợ Razor Pages

// Cấu hình DbContext cho ứng dụng sử dụng SQL Server
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(connectionString));

// Cấu hình Identity với các tùy chọn cho mật khẩu
builder.Services.AddIdentity<AppUser, IdentityRole>(options =>
{
    options.Password.RequiredUniqueChars = 0;
    options.Password.RequireUppercase = false;
    options.Password.RequiredLength = 8;
    options.Password.RequireNonAlphanumeric = false;
    options.Password.RequireLowercase = false;
})
.AddEntityFrameworkStores<ApplicationDbContext>()
.AddDefaultTokenProviders();  // Thêm các provider mặc định cho token



builder.Services.AddRazorPages();



var app = builder.Build();

// Cấu hình HTTP request pipeline
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();  // Sử dụng HSTS trong môi trường sản xuất
}

app.UseHttpsRedirection();
app.UseStaticFiles();  // Hỗ trợ các file tĩnh như CSS, JS, ảnh

app.UseRouting();

app.UseAuthorization();  // Xác thực người dùng

// Thêm routing cho Razor Pages
app.MapRazorPages();  // Map các Razor Pages

app.Run();
