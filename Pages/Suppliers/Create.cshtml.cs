using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace KIMPACK.Pages.Suppliers
{
    public class CreateModel(IConfiguration configuration) : PageModel
    {
        [BindProperty]
        public required string TenNCC { get; set; }

        [BindProperty]
        public required string DiaChiNCC { get; set; }

        [BindProperty]
        public required string SoDienThoaiNCC { get; set; }

        [BindProperty]
        public required string SoTaiKhoanNCC { get; set; }

        public string? Message { get; private set; }

        private readonly IConfiguration _configuration = configuration;

        public void OnGet()
        {
            // GET method: chuẩn bị trang
        }

        [Obsolete]
        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
            {
                return Page(); // Nếu dữ liệu không hợp lệ, quay lại trang nhập
            }

            bool result = await AddCustomerAsync(TenNCC, DiaChiNCC, SoDienThoaiNCC, SoTaiKhoanNCC);

            if (result)
            {
                // Chuyển hướng về trang danh sách khách hàng sau khi thêm thành công
                return RedirectToPage("/Suppliers/Index");
            }
            else
            {
                // Nếu thất bại, hiển thị thông báo lỗi và quay lại trang nhập
                Message = "Thêm nhà cung cấp thất bại. Vui lòng kiểm tra dữ liệu!";
                return Page();
            }
        }

        [Obsolete]
        private async Task<bool> AddCustomerAsync(string tenNCC, string diaChiNCC, string soDienThoaiNCC, string soTaiKhoanNCC)
        {
            string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    await connection.OpenAsync();

                    using (SqlCommand command = new SqlCommand("spthemNhaCungCap", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // Thêm tham số
                        command.Parameters.AddWithValue("@tenNCC", tenNCC);
                        command.Parameters.AddWithValue("@diaChiNCC", diaChiNCC);
                        command.Parameters.AddWithValue("@soDienThoaiNCC", soDienThoaiNCC);
                        command.Parameters.AddWithValue("@soTaiKhoanNCC", soTaiKhoanNCC);

                        SqlParameter outputParam = new SqlParameter("@ketQua", SqlDbType.Bit)
                        {
                            Direction = ParameterDirection.Output
                        };
                        command.Parameters.Add(outputParam);

                        // Thực thi thủ tục
                        await command.ExecuteNonQueryAsync();

                        // Lấy giá trị đầu ra
                        return (bool)command.Parameters["@ketQua"].Value;
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Lỗi: {ex.Message}");
                    return false;
                }
            }
        }
    }
}
