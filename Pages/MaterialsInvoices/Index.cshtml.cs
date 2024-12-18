using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Data.SqlClient;

namespace KIMPACK.Pages.MaterialsInvoices
{
    public class Index : PageModel
    {
        public List<SupplyInformation> SupplyList { get; set; } = new List<SupplyInformation>();

        public void OnGet()
        {
            try
            {
                string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                string sql = "SELECT C.MaCC, C.KyHieuHD, C.NgayCungCap, C.HinhThucThanhToan, C.TongTienNVL, " +
                             "C.MucThueSuatGTGT, C.TienThueGTGT, C.TongTienThanhToan, NCC.TenNCC " +
                             "FROM dbo.CUNG_CAP C " +
                             "INNER JOIN dbo.NHA_CUNG_CAP NCC ON C.MaNCC = NCC.MaNCC";
                using var command = new SqlCommand(sql, connection);
                using var reader = command.ExecuteReader();
                while (reader.Read())
                {
                    var supplyInformation = new SupplyInformation
                    {
                        MaCC = reader.GetInt32(0),
                        KyHieuHD = reader.GetString(1),
                        NgayCungCap = reader.GetDateTime(2),
                        HinhThucThanhToan = reader.GetString(3),
                        TongTienNVL = reader.IsDBNull(4) ? (decimal?)null : reader.GetDecimal(4),
                        MucThueSuatGTGT = reader.GetDecimal(5),
                        TienThueGTGT = reader.IsDBNull(6) ? (decimal?)null : reader.GetDecimal(6),
                        TongTienThanhToan = reader.IsDBNull(7) ? (decimal?)null : reader.GetDecimal(7),
                        TenNCC = reader.GetString(8)
                    };
                    SupplyList.Add(supplyInformation);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi: " + ex.Message);
            }
        }

        public class SupplyInformation
        {
            public int MaCC { get; set; }
            public string KyHieuHD { get; set; } = "";
            public DateTime NgayCungCap { get; set; }
            public string HinhThucThanhToan { get; set; } = "";
            public decimal? TongTienNVL { get; set; }
            public decimal MucThueSuatGTGT { get; set; }
            public decimal? TienThueGTGT { get; set; }
            public decimal? TongTienThanhToan { get; set; }
            public string TenNCC { get; set; } = "";
        }
    }
}
