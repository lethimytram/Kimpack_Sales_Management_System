using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace KIMPACK.Pages.SalesInvoices
{
    public class DeleteModel : PageModel
    {
        [BindProperty(SupportsGet = true)] // Hỗ trợ nhận giá trị từ URL
        public int MaD { get; set; } // Mã đơn đặt hàng
        public string? Message { get; private set; }
        private readonly IConfiguration _configuration;
        private readonly ILogger<DeleteModel> _logger;

        public DeleteModel(IConfiguration configuration, ILogger<DeleteModel> logger)
        {
            _configuration = configuration;
            _logger = logger;
        }

        [Obsolete]
        public async Task OnGetAsync(int maD) // Phương thức lấy thông tin đơn đặt hàng
        {
            try
            {
                // Lấy thông tin đơn đặt hàng từ cơ sở dữ liệu để hiển thị
                string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
                using (var connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT MaD FROM DAT WHERE MaD = @MaD";
                    var command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@MaD", maD);

                    await connection.OpenAsync();
                    var reader = await command.ExecuteReaderAsync();
                    if (await reader.ReadAsync())
                    {
                        MaD = reader.GetInt32(reader.GetOrdinal("MaD"));
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Lỗi khi lấy thông tin đơn đặt hàng {MaD}", maD);
                Message = "Đã xảy ra lỗi khi lấy thông tin đơn đặt hàng.";
            }
        }

        [Obsolete]
        public async Task<IActionResult> OnPostAsync() // Phương thức xử lý xóa đơn đặt hàng
        {
            if (MaD <= 0)
            {
                Message = "Mã đơn đặt hàng không hợp lệ.";
                return Page();
            }

            try
            {
                bool ketQua = await DeleteOrderAsync(MaD); // Gọi phương thức xóa đơn đặt hàng
                if (!ketQua)
                {
                    Message = "Xóa đơn đặt hàng thất bại. Đơn đặt hàng có thể có dữ liệu liên quan hoặc không tồn tại.";
                    return Page();
                }

                TempData["SuccessMessage"] = "Đơn đặt hàng đã được xóa thành công.";
                return RedirectToPage("/MaterialsInvoices/Index"); // Chuyển hướng về danh sách đơn đặt hàng
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Lỗi khi xóa đơn đặt hàng {MaD}", MaD);
                Message = "Đã xảy ra lỗi khi xóa đơn đặt hàng.";
                return Page();
            }
        }

        [Obsolete]
        private async Task<bool> DeleteOrderAsync(int maD) // Phương thức gọi thủ tục xóa đơn đặt hàng
        {
            string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
            using (var connection = new SqlConnection(connectionString))
            {
                try
                {
                    await connection.OpenAsync();
                    using (var command = new SqlCommand("spXoaDatHang", connection)) // Thủ tục xóa đơn đặt hàng
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("@MaD", maD);

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
                    _logger.LogError(e, "Lỗi khi gọi thủ tục xóa đơn đặt hàng {MaD}", maD);
                    throw;
                }
            }
        }
    }
}
