using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Data.SqlClient;

namespace KIMPACK.Pages.Customers
{
    public class Index : PageModel
    {

        public List<CustomerInformation> CustomerList { get; set; } = new List<CustomerInformation>();

        public void OnGet()
        {
            try
            {
                string connectionString = "Server=.;Database=Kimpack;Trusted_Connection=True;TrustServerCertificate=True;";
                using var connection = new SqlConnection(connectionString);
                connection.Open();
                string sql = "SELECT * FROM dbo.KHACH_HANG";
                using var command = new SqlCommand(sql, connection);
                using var reader = command.ExecuteReader();
                while (reader.Read())
                {
                    var customerInformation = new CustomerInformation
                    {
                        MaKH = reader.GetInt32(0),
                        TenKH = reader.GetString(1),
                        DiaChiKH = reader.GetString(2),
                        SoDienThoaiKH = reader.GetString(3),
                        SoTaiKhoanKH = reader.GetString(4)
                    };
                    CustomerList.Add(customerInformation);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi: " + ex.Message);
            }
        }

        public class CustomerInformation
        {
            public int MaKH { get; set; }
            public string TenKH { get; set; } = "";
            public string DiaChiKH { get; set; } = "";
            public string SoDienThoaiKH { get; set; } = "";
            public string SoTaiKhoanKH { get; set; } = "";
        }
    }
}