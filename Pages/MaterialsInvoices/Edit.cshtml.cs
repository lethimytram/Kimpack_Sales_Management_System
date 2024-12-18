using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace KIMPACK.Pages.MaterialsInvoices
{
    public class EditModel(IConfiguration configuration) : PageModel
    {
        private readonly IConfiguration _configuration = configuration;

        [BindProperty]
        public int MaCC { get; set; }

        [BindProperty]
        public DateTime NgayCungCap { get; set; }

        [BindProperty]
        public required string HinhThucThanhToan { get; set; }

        [BindProperty]
        public decimal MucThueSuat { get; set; }

        [BindProperty]
        public int MaNCC { get; set; }

        [BindProperty]
        public required string Message { get; set; }

        // Chi tiết cung cấp
        [BindProperty]
        public int MaNVL { get; set; }

        [BindProperty]
        public decimal SoLuong { get; set; }

        public required List<ChiTietCungCap> CungCapChiTiets { get; set; }

        [Obsolete]
        public async Task<IActionResult> OnGetAsync(int maCC)
        {
#pragma warning disable CS8600 // Converting null literal or possible null value to non-nullable type.
            string connectionString = _configuration.GetConnectionString("DefaultConnection");
#pragma warning restore CS8600 // Converting null literal or possible null value to non-nullable type.

            // Lấy thông tin từ bảng CUNG_CAP
            using (var connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM CUNG_CAP WHERE MaCC = @MaCC";
                var command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@MaCC", maCC);

                await connection.OpenAsync();
                var reader = await command.ExecuteReaderAsync();
                if (await reader.ReadAsync())
                {
                    MaCC = reader.GetInt32(reader.GetOrdinal("MaCC"));
                    NgayCungCap = reader.GetDateTime(reader.GetOrdinal("NgayCungCap"));
                    HinhThucThanhToan = reader.GetString(reader.GetOrdinal("HinhThucThanhToan"));
                    MucThueSuat = reader.GetDecimal(reader.GetOrdinal("MucThueSuatGTGT"));
                    MaNCC = reader.GetInt32(reader.GetOrdinal("MaNCC"));
                }
            }

            // Lấy thông tin chi tiết cung cấp từ bảng CUNG_CAP_CHI_TIET
            using (var connection = new SqlConnection(connectionString))
            {
                string chiTietQuery = "SELECT * FROM CUNG_CAP_CHI_TIET WHERE MaCC = @MaCC";
                var command = new SqlCommand(chiTietQuery, connection);
                command.Parameters.AddWithValue("@MaCC", maCC);

                await connection.OpenAsync();
                var reader = await command.ExecuteReaderAsync();

                List<ChiTietCungCap> cungCapChiTiets = new List<ChiTietCungCap>();
                while (await reader.ReadAsync())
                {
                    cungCapChiTiets.Add(new ChiTietCungCap
                    {
                        MaNVL = reader.GetInt32(reader.GetOrdinal("MaNVL")), // Đảm bảo MaNVL tồn tại trong bảng CUNG_CAP_CHI_TIET
                        SoLuong = reader.GetDecimal(reader.GetOrdinal("SoLuong")),
                        ThanhTien = reader.GetDecimal(reader.GetOrdinal("ThanhTien"))
                    });
                }

                // Gán danh sách chi tiết cung cấp vào model để sử dụng trong giao diện Razor
                CungCapChiTiets = cungCapChiTiets;
            }

            return Page();
        }

        [Obsolete]
        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
            {
                return Page(); // Nếu dữ liệu không hợp lệ, quay lại trang nhập
            }

            bool cungCapUpdateResult = await UpdateCungCapAsync(MaCC, NgayCungCap, HinhThucThanhToan, MucThueSuat, MaNCC);

            bool chiTietUpdateResult = false;

            // Kiểm tra xem có cung cấp chi tiết nào được sửa không
            if (MaNVL > 0 && SoLuong > 0)
            {
                chiTietUpdateResult = await UpdateCungCapChiTietAsync(MaCC, MaNVL, SoLuong);
            }

            if (cungCapUpdateResult && chiTietUpdateResult)
            {
                // Chuyển hướng về trang danh sách sau khi sửa thành công
                return RedirectToPage("/MaterialsInvoices/Index");
            }
            else
            {
                // Nếu thất bại, hiển thị thông báo lỗi và quay lại trang nhập
                Message = "Cập nhật cung cấp thất bại. Vui lòng kiểm tra lại dữ liệu!";
                return Page();
            }
        }

        [Obsolete]
        private async Task<bool> UpdateCungCapAsync(int maCC, DateTime ngayCungCap, string hinhThucThanhToan, decimal mucThueSuat, int maNCC)
        {
#pragma warning disable CS8600 // Converting null literal or possible null value to non-nullable type.
            string connectionString = _configuration.GetConnectionString("DefaultConnection");
#pragma warning restore CS8600 // Converting null literal or possible null value to non-nullable type.

            using (var connection = new SqlConnection(connectionString))
            {
                try
                {
                    await connection.OpenAsync();

                    using (var command = new SqlCommand("spSuaCungCap", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // Thêm tham số cho thủ tục
                        command.Parameters.AddWithValue("@maCC", maCC);
                        command.Parameters.AddWithValue("@ngayCungCap", ngayCungCap);
                        command.Parameters.AddWithValue("@hinhThucThanhToan", hinhThucThanhToan);
                        command.Parameters.AddWithValue("@mucThueSuat", mucThueSuat);
                        command.Parameters.AddWithValue("@maNCC", maNCC);

                        // Output parameter cho kết quả
                        SqlParameter ketQuaParam = new SqlParameter("@ketQua", SqlDbType.Bit)
                        {
                            Direction = ParameterDirection.Output
                        };
                        command.Parameters.Add(ketQuaParam);

                        // Thực thi thủ tục
                        await command.ExecuteNonQueryAsync();

                        // Lấy kết quả từ tham số output
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

        [Obsolete]
        private async Task<bool> UpdateCungCapChiTietAsync(int maCC, int maNVL, decimal soLuong)
        {
#pragma warning disable CS8600 // Converting null literal or possible null value to non-nullable type.
            string connectionString = _configuration.GetConnectionString("DefaultConnection");
#pragma warning restore CS8600 // Converting null literal or possible null value to non-nullable type.

            using (var connection = new SqlConnection(connectionString))
            {
                try
                {
                    await connection.OpenAsync();

                    using (var command = new SqlCommand("spsuaCungCapChiTiet", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // Thêm tham số cho thủ tục
                        command.Parameters.AddWithValue("@maCC", maCC);
                        command.Parameters.AddWithValue("@maNVL", maNVL);
                        command.Parameters.AddWithValue("@soLuong", soLuong);

                        // Output parameter cho kết quả
                        SqlParameter ketQuaParam = new SqlParameter("@ketQua", SqlDbType.Bit)
                        {
                            Direction = ParameterDirection.Output
                        };
                        command.Parameters.Add(ketQuaParam);

                        // Thực thi thủ tục
                        await command.ExecuteNonQueryAsync();

                        // Lấy kết quả từ tham số output
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

    public class ChiTietCungCap
    {
        public int MaNVL { get; set; }
        public decimal SoLuong { get; set; }
        public decimal ThanhTien { get; set; }
    }
}
