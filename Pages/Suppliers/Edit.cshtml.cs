using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace KIMPACK.Pages.Suppliers
{
    public class EditModel : PageModel
    {
        [BindProperty]
        public required int MaNCC { get; set; }

        [BindProperty]
        public required string TenNCC { get; set; }

        [BindProperty]
        public required string DiaChiNCC { get; set; }

        [BindProperty]
        public required string SoDienThoaiNCC { get; set; }

        [BindProperty]
        public required string SoTaiKhoanNCC { get; set; }

        public string? Message { get; private set; }

        private readonly IConfiguration _configuration;

        public EditModel(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        // Use only OnGetAsync
        [Obsolete]
        public async Task OnGetAsync(int maNCC)
        {
            string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
            using (var connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM NHA_CUNG_CAP WHERE MaNCC = @MaNCC";
                var command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@MaNCC", maNCC);

                await connection.OpenAsync();
                var reader = await command.ExecuteReaderAsync();
                if (await reader.ReadAsync())
                {
                    MaNCC = reader.GetInt32(reader.GetOrdinal("MaNCC"));
                    TenNCC = reader.GetString(reader.GetOrdinal("TenNCC"));
                    DiaChiNCC = reader.GetString(reader.GetOrdinal("DiaChiNCC"));
                    SoDienThoaiNCC = reader.GetString(reader.GetOrdinal("SoDienThoaiNCC"));
                    SoTaiKhoanNCC = reader.GetString(reader.GetOrdinal("SoTaiKhoanNCC"));
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

            bool result = await UpdateCustomerAsync(MaNCC, TenNCC, DiaChiNCC, SoDienThoaiNCC, SoTaiKhoanNCC);

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
        private async Task<bool> UpdateCustomerAsync(int maNCC, string tenNCC, string diaChiNCC, string soDienThoaiNCC, string soTaiKhoanNCC)
        {
            string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    await connection.OpenAsync();

                    using (SqlCommand command = new SqlCommand("spsuaNhaCungCap", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // Thêm tham số cho thủ tục
                        command.Parameters.AddWithValue("@maNCC", maNCC);
                        command.Parameters.AddWithValue("@tenNCC", tenNCC);
                        command.Parameters.AddWithValue("@diaChiNCC", diaChiNCC);
                        command.Parameters.AddWithValue("@soDienThoaiNCC", soDienThoaiNCC);
                        command.Parameters.AddWithValue("@soTaiKhoanNCC", soTaiKhoanNCC);

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
