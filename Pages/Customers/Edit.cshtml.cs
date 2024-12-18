using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace KIMPACK.Pages.Customers
{
    public class EditModel : PageModel
    {
        [BindProperty]
        public required int MaKH { get; set; }

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

        public EditModel(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        // Use only OnGetAsync
        [Obsolete]
        public async Task OnGetAsync(int maKH)
        {
            string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
            using (var connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM KHACH_HANG WHERE MaKH = @MaKH";
                var command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@MaKH", maKH);

                await connection.OpenAsync();
                var reader = await command.ExecuteReaderAsync();
                if (await reader.ReadAsync())
                {
                    MaKH = reader.GetInt32(reader.GetOrdinal("MaKH"));
                    TenKH = reader.GetString(reader.GetOrdinal("TenKH"));
                    DiaChiKH = reader.GetString(reader.GetOrdinal("DiaChiKH"));
                    SoDienThoaiKH = reader.GetString(reader.GetOrdinal("SoDienThoaiKH"));
                    SoTaiKhoanKH = reader.GetString(reader.GetOrdinal("SoTaiKhoanKH"));
                }
            }
        }

        [Obsolete]
        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
            {
                return Page(); // Nếu dữ liệu không hợp lệ, quay lại trang nhập
            }

            bool result = await UpdateCustomerAsync(MaKH, TenKH, DiaChiKH, SoDienThoaiKH, SoTaiKhoanKH);

            if (result)
            {
                // Chuyển hướng về trang danh sách khách hàng sau khi sửa thành công
                return RedirectToPage("/Customers/Index");
            }
            else
            {
                // Nếu thất bại, hiển thị thông báo lỗi và quay lại trang nhập
                Message = "Cập nhật khách hàng thất bại. Vui lòng kiểm tra dữ liệu!";
                return Page();
            }
        }

        [Obsolete]
        private async Task<bool> UpdateCustomerAsync(int maKH, string tenKH, string diaChiKH, string soDienThoaiKH, string soTaiKhoanKH)
        {
            string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    await connection.OpenAsync();

                    using (SqlCommand command = new SqlCommand("spsuaKhachHang", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // Thêm tham số cho thủ tục
                        command.Parameters.AddWithValue("@maKH", maKH);
                        command.Parameters.AddWithValue("@tenKH", tenKH);
                        command.Parameters.AddWithValue("@diaChiKH", diaChiKH);
                        command.Parameters.AddWithValue("@soDienThoaiKH", soDienThoaiKH);
                        command.Parameters.AddWithValue("@soTaiKhoanKH", soTaiKhoanKH);

                        // Output parameter cho kết quả
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
