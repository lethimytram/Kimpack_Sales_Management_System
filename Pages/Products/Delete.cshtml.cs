using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace KIMPACK.Pages.Products
{
    public class DeleteModel : PageModel
    {
        [BindProperty]
        public int MaSP { get; set; }  // Change this to MaSP for product deletion
        public string? Message { get; private set; }
        private readonly IConfiguration _configuration;
        private readonly ILogger<DeleteModel> _logger;

        public DeleteModel(IConfiguration configuration, ILogger<DeleteModel> logger)
        {
            _configuration = configuration;
            _logger = logger;
        }

        [Obsolete]
        public async Task OnGetAsync(int maSP)  // Changed parameter to maSP
        {
            try
            {
                // Lấy thông tin sản phẩm để hiển thị (Get product info to display)
                string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
                using (var connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT MaSP FROM SAN_PHAM WHERE MaSP = @MaSP";
                    var command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@MaSP", maSP);

                    await connection.OpenAsync();
                    var reader = await command.ExecuteReaderAsync();
                    if (await reader.ReadAsync())
                    {
                        MaSP = reader.GetInt32(reader.GetOrdinal("MaSP"));
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Lỗi khi lấy thông tin sản phẩm {MaSP}", maSP);
                Message = "Đã xảy ra lỗi khi lấy thông tin sản phẩm.";
            }
        }

        [Obsolete]
        public async Task<IActionResult> OnPostAsync()  // Same method, changed to use MaSP
        {
            if (MaSP <= 0)
            {
                Message = "Mã sản phẩm không hợp lệ.";
                return Page();
            }

            try
            {
                bool ketQua = await DeleteProductAsync(MaSP);  // Changed to call DeleteProductAsync
                if (!ketQua)
                {
                    Message = "Xóa sản phẩm thất bại. Sản phẩm có thể có dữ liệu liên quan hoặc không tồn tại.";
                    return Page();
                }

                TempData["SuccessMessage"] = "Sản phẩm đã được xóa thành công.";
                return RedirectToPage("/Products/Index");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Lỗi khi xóa sản phẩm {MaSP}", MaSP);
                Message = "Đã xảy ra lỗi khi xóa sản phẩm.";
                return Page();
            }
        }

        [Obsolete]
        private async Task<bool> DeleteProductAsync(int maSP)  // Changed method to handle product deletion
        {
            string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
            using (var connection = new SqlConnection(connectionString))
            {
                try
                {
                    await connection.OpenAsync();
                    using (var command = new SqlCommand("spXoaSanPham", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("@MaSP", maSP);

                        var ketQuaParam = new SqlParameter("@KetQua", SqlDbType.Bit)
                        {
                            Direction = ParameterDirection.Output
                        };
                        command.Parameters.Add(ketQuaParam);

                        await command.ExecuteNonQueryAsync();

                        return ketQuaParam.Value != DBNull.Value && (bool)ketQuaParam.Value;
                    }
                }
                catch (Exception e)
                {
                    _logger.LogError(e, "Lỗi khi gọi thủ tục xóa sản phẩm {MaSP}", maSP);
                    throw;
                }
            }
        }
    }
}
