using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace KIMPACK.Pages.Products // Đảm bảo namespace đúng
{
    public class EditModel : PageModel
    {
        [BindProperty]
        public required int MaSP { get; set; } // Mã sản phẩm

        [BindProperty]
        public required string TenSP { get; set; } // Tên sản phẩm

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

        // Sử dụng phương thức bất đồng bộ OnGetAsync để lấy thông tin sản phẩm
        [Obsolete]
        public async Task OnGetAsync(int maSP)
        {
            string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";

            using (var connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM SAN_PHAM WHERE MaSP = @MaSP";
                var command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@MaSP", maSP);

                await connection.OpenAsync();
                var reader = await command.ExecuteReaderAsync();

                if (await reader.ReadAsync())
                {
                    MaSP = reader.GetInt32(reader.GetOrdinal("MaSP"));
                    TenSP = reader.GetString(reader.GetOrdinal("TenSP"));
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

            bool result = await UpdateSanPhamAsync(MaSP, TenSP, DonViTinh, DonGia);

            if (result)
            {
                // Chuyển hướng về trang danh sách sản phẩm sau khi sửa thành công
                return RedirectToPage("/Products/Index");
            }
            else
            {
                // Nếu thất bại, hiển thị thông báo lỗi và quay lại trang nhập
                Message = "Cập nhật sản phẩm thất bại. Vui lòng kiểm tra dữ liệu!";
                return Page();
            }
        }

        [Obsolete]
        private async Task<bool> UpdateSanPhamAsync(int maSP, string tenSP, string donViTinh, decimal donGia)
        {
            string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    await connection.OpenAsync();

                    using (SqlCommand command = new SqlCommand("spsuaSanPham", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // Thêm tham số đầu vào
                        command.Parameters.AddWithValue("@maSP", maSP);
                        command.Parameters.AddWithValue("@tenSP", tenSP);
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
