using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Data.SqlClient;

namespace KIMPACK.Pages.SalesInvoices
{
    public class Index : PageModel
    {
        public List<OrderInformation> OrderList { get; set; } = new List<OrderInformation>();

        public void OnGet()
        {
            try
            {
                string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                string sql = "SELECT D.MaD, D.KyHieuHD, D.NgayDat, D.HinhThucThanhToan, D.TongTienSP, " +
                             "D.MucThueSuatGTGT, D.TienThueGTGT, D.TongTienThanhToan, KH.TenKH, KH.DiaChiKH " +
                             "FROM dbo.DAT D " +
                             "INNER JOIN dbo.KHACH_HANG KH ON D.MaKH = KH.MaKH";
                using var command = new SqlCommand(sql, connection);
                using var reader = command.ExecuteReader();
                while (reader.Read())
                {
                    var orderInformation = new OrderInformation
                    {
                        MaD = reader.GetInt32(0),
                        KyHieuHD = reader.GetString(1),
                        NgayDat = reader.GetDateTime(2),
                        HinhThucThanhToan = reader.GetString(3),
                        TongTienSP = reader.IsDBNull(4) ? (decimal?)null : reader.GetDecimal(4),
                        MucThueSuatGTGT = reader.GetDecimal(5),
                        TienThueGTGT = reader.IsDBNull(6) ? (decimal?)null : reader.GetDecimal(6),
                        TongTienThanhToan = reader.IsDBNull(7) ? (decimal?)null : reader.GetDecimal(7),
                        TenKH = reader.GetString(8),
                        DiaChiKH = reader.GetString(9)
                    };
                    OrderList.Add(orderInformation);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi: " + ex.Message);
            }
        }

        public class OrderInformation
        {
            public int MaD { get; set; }
            public string KyHieuHD { get; set; } = "";
            public DateTime NgayDat { get; set; }
            public string HinhThucThanhToan { get; set; } = "";
            public decimal? TongTienSP { get; set; }
            public decimal MucThueSuatGTGT { get; set; }
            public decimal? TienThueGTGT { get; set; }
            public decimal? TongTienThanhToan { get; set; }
            public string TenKH { get; set; } = "";
            public string DiaChiKH { get; set; } = "";
        }
    }
}
