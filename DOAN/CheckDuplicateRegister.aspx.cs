using System;
using System.Data.SqlClient;
using System.Configuration;

namespace DOAN_TMDT.DOAN
{
    public partial class CheckDuplicateRegister : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string type = Request.Form["type"];
            string value = Request.Form["value"];

            if (!string.IsNullOrEmpty(type) && !string.IsNullOrEmpty(value))
            {
                string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "";

                    if (type == "username")
                        query = "SELECT COUNT(*) FROM Customers WHERE Username = @Value";
                    else if (type == "email")
                        query = "SELECT COUNT(*) FROM Customers WHERE Email = @Value";
                    else if (type == "phone")
                        query = "SELECT COUNT(*) FROM Customers WHERE Phone = @Value";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Value", value);

                    int count = (int)cmd.ExecuteScalar();

                    if (count > 0)
                        Response.Write("EXISTS");
                    else
                        Response.Write("NOT_EXISTS");
                }
            }

            Response.End();
        }
    }
}
