using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Data.SqlClient;

namespace KIMPACK.Pages.Products
{
    public class Index : PageModel
    {

        public List<ProductInformation> ProductsList { get; set; } = new List<ProductInformation>();

        public void OnGet()
        {
            try
            {
                string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                string sql = "SELECT * FROM dbo.SAN_PHAM";
                using var command = new SqlCommand(sql, connection);
                using var reader = command.ExecuteReader();
                while (reader.Read())
                {
                    var productInformation = new ProductInformation
                    {
                        MaSP = reader.GetInt32(0),
                        TenSP = reader.GetString(1),
                        DonViTinh = reader.GetString(2),
                        DonGia = reader.GetDecimal(3),
                    };
                    ProductsList.Add(productInformation);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi: " + ex.Message);
            }
        }

        public class ProductInformation
        {
            public int MaSP { get; set; }
            public string TenSP { get; set; } = "";
            public string DonViTinh { get; set; } = "";
            public decimal DonGia { get; set; } 
        }
    }
}