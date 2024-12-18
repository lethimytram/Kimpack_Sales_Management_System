using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace KIMPACK.Pages.SalesInvoices
{
    public class CreateModel : PageModel
    {
        [BindProperty]
        public required DateTime NgayCungCap { get; set; }

        [BindProperty]
        public required char HinhThucThanhToan { get; set; } // '0' or '1'

        [BindProperty]
        public required decimal MucThueSuat { get; set; } // Tax rate

        [BindProperty]
        public required int MaNCC { get; set; } // Supplier ID

        public string? Message { get; private set; } // Thuộc tính hiển thị thông báo

        private readonly IConfiguration _configuration;

        public CreateModel(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public void OnGet()
        {
            // Load any required data here
        }

#pragma warning disable MVC1002 // Route attributes cannot be applied to page handler methods
        [HttpPost]
        [Obsolete]
#pragma warning restore MVC1002 // Route attributes cannot be applied to page handler methods
        public async Task<JsonResult> OnPostAddInvoiceAsync()
        {
            if (!ModelState.IsValid)
            {
                Message = "Dữ liệu không hợp lệ.";
                return new JsonResult(new { success = false, message = Message });
            }

            int? idHoaDonMoi = await AddSupplyAsync(NgayCungCap, HinhThucThanhToan, MucThueSuat, MaNCC);

            if (idHoaDonMoi.HasValue)
            {
                Message = "Hóa đơn đã được thêm thành công.";
                return new JsonResult(new { success = true, id = idHoaDonMoi.Value, message = Message });
            }
            else
            {
                Message = "Thêm hóa đơn thất bại.";
                return new JsonResult(new { success = false, message = Message });
            }
        }

        [Obsolete]
        private async Task<int?> AddSupplyAsync(DateTime ngayCungCap, char hinhThucThanhToan, decimal mucThueSuat, int maNCC)
        {
            string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    await connection.OpenAsync();
                    using (SqlCommand command = new SqlCommand("spThemCungCap", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("@ngayCungCap", ngayCungCap);
                        command.Parameters.AddWithValue("@hinhThucThanhToan", hinhThucThanhToan);
                        command.Parameters.AddWithValue("@mucThueSuat", mucThueSuat);
                        command.Parameters.AddWithValue("@maNCC", maNCC);

                        SqlParameter outputParam = new SqlParameter("@idHoaDonMoi", SqlDbType.Int)
                        {
                            Direction = ParameterDirection.Output
                        };
                        command.Parameters.Add(outputParam);

                        await command.ExecuteNonQueryAsync();

                        return (int?)outputParam.Value;
                    }
                }
                catch (Exception ex)
                {
                    Message = $"Lỗi: {ex.Message}";
                    Console.WriteLine(Message);
                    return null;
                }
            }
        }
    }
}
