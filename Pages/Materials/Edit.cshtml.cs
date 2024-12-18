using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace KIMPACK.Pages.Materials // Đảm bảo namespace đúng
{
    public class EditModel : PageModel
    {
        [BindProperty]
        public required int MaNVL { get; set; } // Mã nguyên vật liệu

        [BindProperty]
        public required string TenNVL { get; set; } // Tên nguyên vật liệu

        [BindProperty]
        public required string DonViTinh { get; set; } // Đơn vị tính

        [BindProperty]
        public required decimal DonGia { get; set; } // Đơn giá

        public string? Message { get; private set; } // Thông báo kết quả

        private readonly IConfiguration _configuration;

        public EditModel(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        // Sử dụng phương thức bất đồng bộ OnGetAsync để lấy thông tin nguyên vật liệu
        [Obsolete]
        public async Task OnGetAsync(int maNVL)
        {
            string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";

            using (var connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM NGUYEN_VAT_LIEU WHERE MaNVL = @MaNVL";
                var command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@MaNVL", maNVL);

                await connection.OpenAsync();
                var reader = await command.ExecuteReaderAsync();

                if (await reader.ReadAsync())
                {
                    MaNVL = reader.GetInt32(reader.GetOrdinal("MaNVL"));
                    TenNVL = reader.GetString(reader.GetOrdinal("TenNVL"));
                    DonViTinh = reader.GetString(reader.GetOrdinal("DonViTinh"));
                    DonGia = reader.GetDecimal(reader.GetOrdinal("DonGia"));
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

            bool result = await UpdateNguyenVatLieuAsync(MaNVL, TenNVL, DonViTinh, DonGia);

            if (result)
            {
                // Chuyển hướng về trang danh sách nguyên vật liệu sau khi sửa thành công
                return RedirectToPage("/Products/Index");
            }
            else
            {
                // Nếu thất bại, hiển thị thông báo lỗi và quay lại trang nhập
                Message = "Cập nhật nguyên vật liệu thất bại. Vui lòng kiểm tra dữ liệu!";
                return Page();
            }
        }

        [Obsolete]
        private async Task<bool> UpdateNguyenVatLieuAsync(int maNVL, string tenNVL, string donViTinh, decimal donGia)
        {
            string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    await connection.OpenAsync();

                    using (SqlCommand command = new SqlCommand("spsuaNguyenVatLieu", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // Thêm tham số đầu vào
                        command.Parameters.AddWithValue("@maNVL", maNVL);
                        command.Parameters.AddWithValue("@tenNVL", tenNVL);
                        command.Parameters.AddWithValue("@donViTinh", donViTinh);
                        command.Parameters.AddWithValue("@donGia", donGia);

                        // Thêm tham số đầu ra
                        SqlParameter outputParam = new SqlParameter("@ketQua", SqlDbType.Bit)
                        {
                            Direction = ParameterDirection.Output
                        };
                        command.Parameters.Add(outputParam);

                        // Thực thi thủ tục
                        await command.ExecuteNonQueryAsync();

                        // Lấy giá trị từ tham số đầu ra
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
