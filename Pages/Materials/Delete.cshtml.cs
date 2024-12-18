using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace KIMPACK.Pages.Materials  // Updated to handle materials
{
    public class DeleteModel : PageModel
    {
        [BindProperty]
        public int MaNVL { get; set; }  // Changed to MaNVL for material deletion
        public string? Message { get; private set; }
        private readonly IConfiguration _configuration;
        private readonly ILogger<DeleteModel> _logger;

        public DeleteModel(IConfiguration configuration, ILogger<DeleteModel> logger)
        {
            _configuration = configuration;
            _logger = logger;
        }

        [Obsolete]
        public async Task OnGetAsync(int maNVL)  // Changed to maNVL for material deletion
        {
            try
            {
                // Lấy thông tin nguyên vật liệu để hiển thị (Get material info to display)
                string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
                using (var connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT MaNVL FROM NGUYEN_VAT_LIEU WHERE MaNVL = @MaNVL";
                    var command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@MaNVL", maNVL);

                    await connection.OpenAsync();
                    var reader = await command.ExecuteReaderAsync();
                    if (await reader.ReadAsync())
                    {
                        MaNVL = reader.GetInt32(reader.GetOrdinal("MaNVL"));
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Lỗi khi lấy thông tin nguyên vật liệu {MaNVL}", maNVL);
                Message = "Đã xảy ra lỗi khi lấy thông tin nguyên vật liệu.";
            }
        }

        [Obsolete]
        public async Task<IActionResult> OnPostAsync()  // Same method, changed to use MaNVL
        {
            if (MaNVL <= 0)
            {
                Message = "Mã nguyên vật liệu không hợp lệ.";
                return Page();
            }

            try
            {
                bool ketQua = await DeleteMaterialAsync(MaNVL);  // Changed to call DeleteMaterialAsync
                if (!ketQua)
                {
                    Message = "Xóa nguyên vật liệu thất bại. Nguyên vật liệu có thể có dữ liệu liên quan hoặc không tồn tại.";
                    return Page();
                }

                TempData["SuccessMessage"] = "Nguyên vật liệu đã được xóa thành công.";
                return RedirectToPage("/Materials/Index");  // Redirect to material index
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Lỗi khi xóa nguyên vật liệu {MaNVL}", MaNVL);
                Message = "Đã xảy ra lỗi khi xóa nguyên vật liệu.";
                return Page();
            }
        }

        [Obsolete]
        private async Task<bool> DeleteMaterialAsync(int maNVL)  // Changed method to handle material deletion
        {
            string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
            using (var connection = new SqlConnection(connectionString))
            {
                try
                {
                    await connection.OpenAsync();
                    using (var command = new SqlCommand("spXoaNguyenVatLieu", connection))  // Call spXoaNguyenVatLieu stored procedure
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("@MaNVL", maNVL);

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
                    _logger.LogError(e, "Lỗi khi gọi thủ tục xóa nguyên vật liệu {MaNVL}", maNVL);
                    throw;
                }
            }
        }
    }
}
