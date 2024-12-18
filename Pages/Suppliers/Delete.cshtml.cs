using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace KIMPACK.Pages.Suppliers
{
    public class DeleteModel : PageModel
    {
        [BindProperty]
        public int MaNCC { get; set; }
        public string? Message { get; private set; }
        private readonly IConfiguration _configuration;
        private readonly ILogger<DeleteModel> _logger;

        public DeleteModel(IConfiguration configuration, ILogger<DeleteModel> logger)
        {
            _configuration = configuration;
            _logger = logger;
        }

        [Obsolete]
        public async Task OnGetAsync(int maNCC)
        {
            try
            {
                // Lấy thông tin nhà cung cấp để hiển thị
                string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
                using (var connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT MaNCC FROM NHA_CUNG_CAP WHERE MaNCC = @MaNCC";
                    var command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@MaNCC", maNCC);

                    await connection.OpenAsync();
                    var reader = await command.ExecuteReaderAsync();
                    if (await reader.ReadAsync())
                    {
                        MaNCC = reader.GetInt32(reader.GetOrdinal("MaNCC"));
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Lỗi khi lấy thông tin nhà cung cấp {MaNCC}", maNCC);
                Message = "Đã xảy ra lỗi khi lấy thông tin nhà cung cấp.";
            }
        }

        [Obsolete]
        public async Task<IActionResult> OnPostAsync()
        {
            if (MaNCC <= 0)
            {
                Message = "Mã nhà cung cấp không hợp lệ.";
                return Page();
            }

            try
            {
                bool ketQua = await DeleteSupplierAsync(MaNCC);
                if (!ketQua)
                {
                    Message = "Xóa nhà cung cấp thất bại. nhà cung cấp có thể có dữ liệu liên quan hoặc không tồn tại.";
                    return Page();
                }

                TempData["SuccessMessage"] = "nhà cung cấp đã được xóa thành công.";
                return RedirectToPage("/Suppliers/Index");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Lỗi khi xóa nhà cung cấp {MaKH}", MaNCC);
                Message = "Đã xảy ra lỗi khi xóa nhà cung cấp.";
                return Page();
            }
        }

        [Obsolete]
        private async Task<bool> DeleteSupplierAsync(int maNCC)
        {
            string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
            using (var connection = new SqlConnection(connectionString))
            {
                try
                {
                    await connection.OpenAsync();
                    using (var command = new SqlCommand("spXoaNhaCungCap", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("@MaNCC", maNCC);

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
                    _logger.LogError(e, "Lỗi khi gọi thủ tục xóa nhà cung cấp {MaNCC}", maNCC);
                    throw;
                }
            }
        }
    }
}
