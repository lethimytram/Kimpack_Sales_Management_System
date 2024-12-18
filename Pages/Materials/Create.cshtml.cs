using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace KIMPACK.Pages.Materials // Đổi namespace phù hợp
{
    public class CreateModel : PageModel
    {
        [BindProperty]
        public required string TenNVL { get; set; } // Tên nguyên vật liệu

        [BindProperty]
        public required string DonViTinh { get; set; } // Đơn vị tính

        [BindProperty]
        public required decimal DonGia { get; set; } // Đơn giá

        public string? Message { get; private set; } // Thông báo kết quả

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

            bool result = await AddNguyenVatLieuAsync(TenNVL, DonViTinh, DonGia);

            if (result)
            {
                // Chuyển hướng về trang danh sách nguyên vật liệu sau khi thêm thành công
                return RedirectToPage("/Materials/Index");
            }
            else
            {
                // Nếu thất bại, hiển thị thông báo lỗi và quay lại trang nhập
                Message = "Thêm nguyên vật liệu thất bại. Vui lòng kiểm tra dữ liệu!";
                return Page();
            }
        }

        [Obsolete]
        private async Task<bool> AddNguyenVatLieuAsync(string tenNVL, string donViTinh, decimal donGia)
        {
            string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    await connection.OpenAsync();

                    using (SqlCommand command = new SqlCommand("spthemNguyenVatLieu", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // Thêm tham số đầu vào
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
