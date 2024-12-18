using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Data.SqlClient;

namespace KIMPACK.Pages.Suppliers
{
    public class Index : PageModel
    {

        public List<SuppliersInformation> SuppliersList { get; set; } = new List<SuppliersInformation>();

        public void OnGet()
        {
            try
            {
                string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                string sql = "SELECT * FROM dbo.NHA_CUNG_CAP";
                using var command = new SqlCommand(sql, connection);
                using var reader = command.ExecuteReader();
                while (reader.Read())
                {
                    var supplierInformation = new SuppliersInformation
                    {
                        MaNCC = reader.GetInt32(0),
                        TenNCC = reader.GetString(1),
                        DiaChiNCC = reader.GetString(2),
                        SoDienThoaiNCC = reader.GetString(3),
                        SoTaiKhoanNCC = reader.GetString(4)
                    };
                    SuppliersList.Add(supplierInformation);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi: " + ex.Message);
            }
        }

        public class SuppliersInformation
        {
            public int MaNCC { get; set; }
            public string TenNCC { get; set; } = "";
            public string DiaChiNCC { get; set; } = "";
            public string SoDienThoaiNCC { get; set; } = "";
            public string SoTaiKhoanNCC { get; set; } = "";
        }
    }
}