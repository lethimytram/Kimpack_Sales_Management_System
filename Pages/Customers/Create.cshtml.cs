using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace KIMPACK.Pages.Customers
{
    public class CreateModel : PageModel
    {
        [BindProperty]
        public required string TenKH { get; set; }

        [BindProperty]
        public required string DiaChiKH { get; set; }

        [BindProperty]
        public required string SoDienThoaiKH { get; set; }

        [BindProperty]
        public required string SoTaiKhoanKH { get; set; }

        public string? Message { get; private set; }

        private readonly IConfiguration _configuration;

        public CreateModel(IConfiguration configuration)
        {
            _configuration = configuration;
        }

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

            bool result = await AddCustomerAsync(TenKH, DiaChiKH, SoDienThoaiKH, SoTaiKhoanKH);

            if (result)
            {
                // Chuyển hướng về trang danh sách khách hàng sau khi thêm thành công
                return RedirectToPage("/Customers/Index");
            }
            else
            {
                // Nếu thất bại, hiển thị thông báo lỗi và quay lại trang nhập
                Message = "Thêm khách hàng thất bại. Vui lòng kiểm tra dữ liệu!";
                return Page();
            }
        }

        [Obsolete]
        private async Task<bool> AddCustomerAsync(string tenKH, string diaChiKH, string soDienThoaiKH, string soTaiKhoanKH)
        {
            string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    await connection.OpenAsync();

                    using (SqlCommand command = new SqlCommand("spthemKhachHang", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // Thêm tham số
                        command.Parameters.AddWithValue("@tenKH", tenKH);
                        command.Parameters.AddWithValue("@diaChiKH", diaChiKH);
                        command.Parameters.AddWithValue("@soDienThoaiKH", soDienThoaiKH);
                        command.Parameters.AddWithValue("@soTaiKhoanKH", soTaiKhoanKH);

                        // Output parameter for the result
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
