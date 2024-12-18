using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using System.Transactions;

namespace KIMPACK.Pages.MaterialsInvoices
{
    public class CreateModel : PageModel
    {
        [BindProperty]
        public required DateTime NgayCungCap { get; set; }

        [BindProperty]
        public required char HinhThucThanhToan { get; set; }

        [BindProperty]
        public required decimal MucThueSuat { get; set; }

        [BindProperty]
        public required int MaNCC { get; set; }

        [BindProperty]
        public List<OrderDetail> OrderDetails { get; set; } = new List<OrderDetail>();

        public string? Message { get; private set; }

        private readonly IConfiguration _configuration;

        public CreateModel(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public void OnGet()
        {
        }

        [Obsolete]
        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }

            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                try
                {
                    bool result = await AddSupplyAsync(NgayCungCap, HinhThucThanhToan, MucThueSuat, MaNCC);

                    if (result)
                    {
                        bool detailResult = await AddOrderDetailsAsync(OrderDetails);

                        if (detailResult)
                        {
                            transaction.Complete();
                            return RedirectToPage("./Index"); // Sửa chuyển hướng chính xác
                        }
                    }

                    Message = "Thêm cung cấp hoặc chi tiết đơn hàng thất bại.";
                    return Page();
                }
                catch (Exception ex)
                {
                    Message = $"Lỗi xảy ra: {ex.Message}";
                    return Page();
                }
            }
        }

        [Obsolete]
        private async Task<bool> AddSupplyAsync(DateTime ngayCungCap, char hinhThucThanhToan, decimal mucThueSuat, int maNCC)
        {
#pragma warning disable CS8600 // Converting null literal or possible null value to non-nullable type.
            string connectionString = _configuration.GetConnectionString("DefaultConnection");
#pragma warning restore CS8600 // Converting null literal or possible null value to non-nullable type.
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    await connection.OpenAsync();
                    using (SqlCommand command = new SqlCommand("spThemCungCap", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@ngayCungCap", ngayCungCap.Date);
                        command.Parameters.AddWithValue("@hinhThucThanhToan", hinhThucThanhToan);
                        command.Parameters.AddWithValue("@mucThueSuat", mucThueSuat);
                        command.Parameters.AddWithValue("@maNCC", maNCC);

                        SqlParameter outputParam = new SqlParameter("@ketQua", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                        command.Parameters.Add(outputParam);

                        await command.ExecuteNonQueryAsync();
                        return (bool)command.Parameters["@ketQua"].Value;
                    }
                }
                catch
                {
                    return false;
                }
            }
        }

        [Obsolete]
        private async Task<bool> AddOrderDetailsAsync(List<OrderDetail> orderDetails)
        {
#pragma warning disable CS8600 // Converting null literal or possible null value to non-nullable type.
            string connectionString = _configuration.GetConnectionString("DefaultConnection");
#pragma warning restore CS8600 // Converting null literal or possible null value to non-nullable type.
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    await connection.OpenAsync();
                    foreach (var detail in orderDetails)
                    {
                        using (SqlCommand command = new SqlCommand("spthemCungCapChiTiet", connection))
                        {
                            command.CommandType = CommandType.StoredProcedure;
                            command.Parameters.AddWithValue("@maCC", MaNCC);
                            command.Parameters.AddWithValue("@maNVL", detail.MaNVL);
                            command.Parameters.AddWithValue("@soLuong", detail.SoLuong);

                            SqlParameter outputParam = new SqlParameter("@ketQua", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                            command.Parameters.Add(outputParam);

                            await command.ExecuteNonQueryAsync();
                            if (!(bool)command.Parameters["@ketQua"].Value)
                            {
                                return false;
                            }
                        }
                    }
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }
    }

    public class OrderDetail
    {
        public required int MaNVL { get; set; }
        public decimal SoLuong { get; set; }
    }
}
