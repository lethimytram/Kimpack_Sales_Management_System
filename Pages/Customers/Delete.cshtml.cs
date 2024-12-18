using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace KIMPACK.Pages.Customers
{
    public class DeleteModel : PageModel
    {
        [BindProperty]
        public int MaKH { get; set; }
        public string? Message { get; private set; }
        private readonly IConfiguration _configuration;
        private readonly ILogger<DeleteModel> _logger;

        public DeleteModel(IConfiguration configuration, ILogger<DeleteModel> logger)
        {
            _configuration = configuration;
            _logger = logger;
        }

        [Obsolete]
        public async Task OnGetAsync(int maKH)
        {
            try
            {
                // Lấy thông tin khách hàng để hiển thị
                string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
                using (var connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT MaKH FROM KHACH_HANG WHERE MaKH = @MaKH";
                    var command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@MaKH", maKH);

                    await connection.OpenAsync();
                    var reader = await command.ExecuteReaderAsync();
                    if (await reader.ReadAsync())
                    {
                        MaKH = reader.GetInt32(reader.GetOrdinal("MaKH"));
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Lỗi khi lấy thông tin khách hàng {MaKH}", maKH);
                Message = "Đã xảy ra lỗi khi lấy thông tin khách hàng.";
            }
        }

        [Obsolete]
        public async Task<IActionResult> OnPostAsync()
        {
            if (MaKH <= 0)
            {
                Message = "Mã khách hàng không hợp lệ.";
                return Page();
            }

            try
            {
                bool ketQua = await DeleteCustomerAsync(MaKH);
                if (!ketQua)
                {
                    Message = "Xóa khách hàng thất bại. Khách hàng có thể có dữ liệu liên quan hoặc không tồn tại.";
                    return Page();
                }

                TempData["SuccessMessage"] = "Khách hàng đã được xóa thành công.";
                return RedirectToPage("/Customers/Index");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Lỗi khi xóa khách hàng {MaKH}", MaKH);
                Message = "Đã xảy ra lỗi khi xóa khách hàng.";
                return Page();
            }
        }

        [Obsolete]
        private async Task<bool> DeleteCustomerAsync(int maKH)
        {
            string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
            using (var connection = new SqlConnection(connectionString))
            {
                try
                {
                    await connection.OpenAsync();
                    using (var command = new SqlCommand("spXoaKhachHang", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("@MaKH", maKH);

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
                    _logger.LogError(e, "Lỗi khi gọi thủ tục xóa khách hàng {MaKH}", maKH);
                    throw;
                }
            }
        }
    }
}
