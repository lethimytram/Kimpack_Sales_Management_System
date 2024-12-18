using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace KIMPACK.Pages.MaterialsInvoices
{
    public class DeleteModel : PageModel
    {
        [BindProperty(SupportsGet = true)] // Hỗ trợ nhận giá trị từ URL
        public int MaCC { get; set; } // Mã cung cấp
        public string? Message { get; private set; }
        private readonly IConfiguration _configuration;
        private readonly ILogger<DeleteModel> _logger;

        public DeleteModel(IConfiguration configuration, ILogger<DeleteModel> logger)
        {
            _configuration = configuration;
            _logger = logger;
        }

        [Obsolete]
        public async Task OnGetAsync(int maCC) // Phương thức lấy thông tin cung cấp
        {
            try
            {
                // Lấy thông tin cung cấp từ cơ sở dữ liệu để hiển thị
                string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
                using (var connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT MaCC FROM CUNG_CAP WHERE MaCC = @MaCC";
                    var command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@MaCC", maCC);

                    await connection.OpenAsync();
                    var reader = await command.ExecuteReaderAsync();
                    if (await reader.ReadAsync())
                    {
                        MaCC = reader.GetInt32(reader.GetOrdinal("MaCC"));
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Lỗi khi lấy thông tin cung cấp {MaCC}", maCC);
                Message = "Đã xảy ra lỗi khi lấy thông tin cung cấp.";
            }
        }

        [Obsolete]
        public async Task<IActionResult> OnPostAsync() // Phương thức xử lý xóa cung cấp
        {
            if (MaCC <= 0)
            {
                Message = "Mã cung cấp không hợp lệ.";
                return Page();
            }

            try
            {
                bool ketQua = await DeleteSupplyAsync(MaCC); // Gọi phương thức xóa cung cấp
                if (!ketQua)
                {
                    Message = "Xóa cung cấp thất bại. Cung cấp có thể có dữ liệu liên quan hoặc không tồn tại.";
                    return Page();
                }

                TempData["SuccessMessage"] = "Cung cấp đã được xóa thành công.";
                return RedirectToPage("/MaterialsInvoices/Index"); // Chuyển hướng về danh sách cung cấp
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Lỗi khi xóa cung cấp {MaCC}", MaCC);
                Message = "Đã xảy ra lỗi khi xóa cung cấp.";
                return Page();
            }
        }

        [Obsolete]
        private async Task<bool> DeleteSupplyAsync(int maCC) // Phương thức gọi thủ tục xóa cung cấp
        {
            string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
            using (var connection = new SqlConnection(connectionString))
            {
                try
                {
                    await connection.OpenAsync();
                    using (var command = new SqlCommand("spXoaCungCap", connection)) // Thủ tục xóa cung cấp
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("@MaCC", maCC);

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
                    _logger.LogError(e, "Lỗi khi gọi thủ tục xóa cung cấp {MaCC}", maCC);
                    throw;
                }
            }
        }
    }
}
