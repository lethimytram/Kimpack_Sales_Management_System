using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Data.SqlClient;
using System;
using System.Data;
using System.Threading.Tasks;
using System.Collections.Generic;
using Microsoft.Extensions.Configuration;

namespace KIMPACK.Pages.MaterialsInvoices
{
    public class EditModel : PageModel
    {
        [BindProperty]
        public int MaCC { get; set; }

        [BindProperty]
        public required string KyHieuHD { get; set; }

        [BindProperty]
        public DateTime NgayCungCap { get; set; }

        [BindProperty]
        public required string HinhThucThanhToan { get; set; }

        [BindProperty]
        public decimal? TongTienNVL { get; set; }

        [BindProperty]
        public decimal MucThueSuatGTGT { get; set; }

        [BindProperty]
        public decimal? TienThueGTGT { get; set; }

        [BindProperty]
        public decimal? TongTienThanhToan { get; set; }

        [BindProperty]
        public required int MaNCC { get; set; }

        [BindProperty]
        public required List<ChiTietCungCap> CungCapChiTiets { get; set; } = new List<ChiTietCungCap>();

        public List<Supply> SupplyList { get; set; } = new List<Supply>();

        private readonly IConfiguration _configuration;

        public EditModel(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<IActionResult> OnGetAsync(int? maCC)
        {
            if (!maCC.HasValue)
            {
                return RedirectToPage("/MaterialsInvoices/Index");
            }

            var connectionString = _configuration.GetConnectionString("DefaultConnection");
            if (string.IsNullOrEmpty(connectionString))
            {
                return BadRequest("Connection string 'DefaultConnection' not found.");
            }

            try
            {
                await LoadInvoiceDataAsync(maCC.Value, connectionString);
                await LoadCungCapChiTietsAsync(maCC.Value, connectionString);
                await LoadSupplyListAsync(maCC.Value, connectionString);
            }
            catch (Exception ex)
            {
                return BadRequest($"Error: {ex.Message}");
            }

            return Page();
        }

        private async Task LoadSupplyListAsync(int maCC, string connectionString)
        {
            SupplyList.Clear();
            using (var connection = new SqlConnection(connectionString))
            {
                var query = @"
                    SELECT MaCC, KyHieuHD, NgayCungCap, HinhThucThanhToan, 
                        TongTienNVL, MucThueSuatGTGT, TienThueGTGT, 
                        TongTienThanhToan, MaNCC
                    FROM dbo.CUNG_CAP
                    WHERE MaCC = @MaCC";

                var command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@MaCC", maCC);

                await connection.OpenAsync();
                var reader = await command.ExecuteReaderAsync();

                while (await reader.ReadAsync())
                {
                    SupplyList.Add(new Supply
                    {
                        MaCC = reader.GetInt32(reader.GetOrdinal("MaCC")),
                        KyHieuHD = reader.GetString(reader.GetOrdinal("KyHieuHD")),
                        NgayCungCap = reader.GetDateTime(reader.GetOrdinal("NgayCungCap")),
                        HinhThucThanhToan = reader.GetString(reader.GetOrdinal("HinhThucThanhToan")),
                        TongTienNVL = reader.IsDBNull(reader.GetOrdinal("TongTienNVL")) ? (decimal?)null : reader.GetDecimal(reader.GetOrdinal("TongTienNVL")),
                        MucThueSuatGTGT = reader.GetDecimal(reader.GetOrdinal("MucThueSuatGTGT")),
                        TienThueGTGT = reader.IsDBNull(reader.GetOrdinal("TienThueGTGT")) ? (decimal?)null : reader.GetDecimal(reader.GetOrdinal("TienThueGTGT")),
                        TongTienThanhToan = reader.IsDBNull(reader.GetOrdinal("TongTienThanhToan")) ? (decimal?)null : reader.GetDecimal(reader.GetOrdinal("TongTienThanhToan")),
                        MaNCC = reader.GetInt32(reader.GetOrdinal("MaNCC"))
                    });
                }
            }
        }


        private async Task LoadInvoiceDataAsync(int maCC, string connectionString)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                var query = @"
                    SELECT MaCC, KyHieuHD, NgayCungCap, HinhThucThanhToan, TongTienNVL, 
                           MucThueSuatGTGT, TienThueGTGT, TongTienThanhToan, MaNCC
                    FROM dbo.CUNG_CAP
                    WHERE MaCC = @MaCC";

                var command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@MaCC", maCC);

                await connection.OpenAsync();
                var reader = await command.ExecuteReaderAsync();

                if (await reader.ReadAsync())
                {
                    MaCC = reader.GetInt32(reader.GetOrdinal("MaCC"));
                    KyHieuHD = reader.GetString(reader.GetOrdinal("KyHieuHD"));
                    NgayCungCap = reader.GetDateTime(reader.GetOrdinal("NgayCungCap"));
                    HinhThucThanhToan = reader.GetString(reader.GetOrdinal("HinhThucThanhToan"));
                    TongTienNVL = reader.IsDBNull(reader.GetOrdinal("TongTienNVL")) ? (decimal?)null : reader.GetDecimal(reader.GetOrdinal("TongTienNVL"));
                    MucThueSuatGTGT = reader.GetDecimal(reader.GetOrdinal("MucThueSuatGTGT"));
                    TienThueGTGT = reader.IsDBNull(reader.GetOrdinal("TienThueGTGT")) ? (decimal?)null : reader.GetDecimal(reader.GetOrdinal("TienThueGTGT"));
                    TongTienThanhToan = reader.IsDBNull(reader.GetOrdinal("TongTienThanhToan")) ? (decimal?)null : reader.GetDecimal(reader.GetOrdinal("TongTienThanhToan"));
                    MaNCC = reader.GetInt32(reader.GetOrdinal("MaNCC"));
                }
            }
        }

        private async Task LoadCungCapChiTietsAsync(int maCC, string connectionString)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                var query = @"
                    SELECT CCCT.MaNVL, CCCT.SoLuong, CCCT.ThanhTien, N.DonGia, CCCT.MaCC
                    FROM dbo.CUNG_CAP_CHI_TIET CCCT
                    INNER JOIN dbo.NGUYEN_VAT_LIEU N ON CCCT.MaNVL = N.MaNVL
                    WHERE CCCT.MaCC = @MaCC";

                var command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@MaCC", maCC);

                await connection.OpenAsync();
                var reader = await command.ExecuteReaderAsync();

                CungCapChiTiets.Clear();
                while (await reader.ReadAsync())
                {
                    CungCapChiTiets.Add(new ChiTietCungCap
                    {
                        MaCC = reader.GetInt32(reader.GetOrdinal("MaCC")),
                        MaNVL = reader.GetInt32(reader.GetOrdinal("MaNVL")),
                        SoLuong = reader.GetDecimal(reader.GetOrdinal("SoLuong")),
                        ThanhTien = reader.GetDecimal(reader.GetOrdinal("ThanhTien")),
                        DonGia = reader.GetDecimal(reader.GetOrdinal("DonGia"))
                    });
                }
            }
        }

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
            {
                return new JsonResult(new { success = false, message = "Dữ liệu không hợp lệ!" });
            }

            if (TongTienNVL.HasValue && MucThueSuatGTGT > 0)
            {
                TienThueGTGT = TongTienNVL.Value * (MucThueSuatGTGT / 100);
                TongTienThanhToan = TongTienNVL.Value + TienThueGTGT;

                if (TienThueGTGT < 0 || TongTienThanhToan < 0)
                {
                    return new JsonResult(new { success = false, message = "Giá trị tiền hoặc thuế không hợp lệ!" });
                }
            }
            else
            {
                return new JsonResult(new { success = false, message = "Vui lòng nhập đầy đủ thông tin về tiền nguyên vật liệu và thuế suất!" });
            }

            var connectionString = _configuration.GetConnectionString("DefaultConnection");
            if (string.IsNullOrEmpty(connectionString))
            {
                return new JsonResult(new { success = false, message = "Không tìm thấy kết nối cơ sở dữ liệu!" });
            }

            var success = await UpdateInvoiceAsync(connectionString);
            return new JsonResult(new { success = success, message = success ? "Cập nhật thành công!" : "Cập nhật thất bại! Vui lòng kiểm tra lại dữ liệu." });
        }

        private async Task<bool> UpdateInvoiceAsync(string connectionString)
        {
            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    await connection.OpenAsync();
                    using (var command = new SqlCommand("sp_suaCungCap", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@MaCC", MaCC);
                        command.Parameters.AddWithValue("@NgayCungCap", NgayCungCap);
                        command.Parameters.AddWithValue("@HinhThucThanhToan", HinhThucThanhToan);
                        command.Parameters.AddWithValue("@MaNCC", MaNCC);
                        command.Parameters.AddWithValue("@TongTienNVL", TongTienNVL.HasValue ? (object)TongTienNVL.Value : DBNull.Value);
                        command.Parameters.AddWithValue("@MucThueSuatGTGT", MucThueSuatGTGT);
                        command.Parameters.AddWithValue("@TienThueGTGT", TienThueGTGT.HasValue ? (object)TienThueGTGT.Value : DBNull.Value);
                        command.Parameters.AddWithValue("@TongTienThanhToan", TongTienThanhToan.HasValue ? (object)TongTienThanhToan.Value : DBNull.Value);

                        SqlParameter outputParam = new SqlParameter("@ret", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                        command.Parameters.Add(outputParam);

                        await command.ExecuteNonQueryAsync();
                        return (bool)command.Parameters["@ret"].Value;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
                return false;
            }
        }

        public async Task<IActionResult> OnPostDeleteDetailAsync(int maNVL)
        {
            var connectionString = _configuration.GetConnectionString("DefaultConnection");
            if (string.IsNullOrEmpty(connectionString))
            {
                return new JsonResult(new { success = false, message = "Không tìm thấy kết nối cơ sở dữ liệu!" });
            }

            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    await connection.OpenAsync();
                    using (var command = new SqlCommand("sp_xoaCungCapChiTiet", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@MaNVL", maNVL);
                        command.Parameters.AddWithValue("@MaCC", MaCC);

                        SqlParameter outputParam = new SqlParameter("@ret", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                        command.Parameters.Add(outputParam);

                        await command.ExecuteNonQueryAsync();
                        var success = (bool)command.Parameters["@ret"].Value;
                        return new JsonResult(new { success = success });
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
                return new JsonResult(new { success = false });
            }
        }
    }

    public class ChiTietCungCap
    {
        public int MaCC { get; set; }
        public int MaNVL { get; set; }
        public decimal SoLuong { get; set; }
        public decimal ThanhTien { get; set; }
        public decimal DonGia { get; set; }
    }

    public class Supply
{
    public int MaCC { get; set; } 
    public required string KyHieuHD { get; set; }
    public DateTime NgayCungCap { get; set; }
    public required string HinhThucThanhToan { get; set; }
    public decimal? TongTienNVL { get; set; }
    public decimal MucThueSuatGTGT { get; set; }
    public decimal? TienThueGTGT { get; set; }
    public decimal? TongTienThanhToan { get; set; }
    public int MaNCC { get; set; }
}
}
