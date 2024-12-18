using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Data.SqlClient;

namespace KIMPACK.Pages.Materials
{
    public class Index : PageModel
    {

        public List<MaterialInformation> MaterialsList { get; set; } = new List<MaterialInformation>();

        public void OnGet()
        {
            try
            {
                string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                string sql = "SELECT * FROM dbo.NGUYEN_VAT_LIEU";
                using var command = new SqlCommand(sql, connection);
                using var reader = command.ExecuteReader();
                while (reader.Read())
                {
                    var materialInformation = new MaterialInformation
                    {
                        MaNVL = reader.GetInt32(0),
                        TenNVL = reader.GetString(1),
                        DonViTinh = reader.GetString(2),
                        DonGia = reader.GetDecimal(3),
                    };
                    MaterialsList.Add(materialInformation);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi: " + ex.Message);
            }
        }

        public class MaterialInformation
        {
            public int MaNVL { get; set; }
            public string TenNVL { get; set; } = "";
            public string DonViTinh { get; set; } = "";
            public decimal DonGia { get; set; } 
        }
    }
}