using System;
using System.Data.SqlClient;
using System.Configuration;

namespace DOAN_TMDT.DOAN
{
    public partial class Forgotpassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            string phone = txtForgotPhone.Text.Trim();
            string username = txtForgotUsername.Text.Trim();
            string email = txtForgotEmail.Text.Trim();
            string newPassword = txtNewPassword.Text.Trim();

            string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"]?.ConnectionString;

            if (string.IsNullOrEmpty(connectionString))
            {
                Response.Write("<script>alert('Database connection string is missing!');</script>");
                return;
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT COUNT(*) FROM Customers WHERE Phone = @Phone AND Username = @Username AND Email = @Email";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Phone", phone);
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Email", email);

                int count = (int)cmd.ExecuteScalar();

                if (count == 1)
                {
                    // Đúng, cho phép đổi mật khẩu
                    string updateQuery = "UPDATE Customers SET Password = @Password WHERE Phone = @Phone AND Username = @Username AND Email = @Email";
                    SqlCommand updateCmd = new SqlCommand(updateQuery, conn);
                    updateCmd.Parameters.AddWithValue("@Password", newPassword);
                    updateCmd.Parameters.AddWithValue("@Phone", phone);
                    updateCmd.Parameters.AddWithValue("@Username", username);
                    updateCmd.Parameters.AddWithValue("@Email", email);

                    int updated = updateCmd.ExecuteNonQuery();

                    if (updated > 0)
                    {
                        Response.Write("<script>alert('Password reset successfully! Please login again.'); window.location='trangchu.aspx';</script>");
                    }
                    else
                    {
                        Response.Write("<script>alert('Failed to reset password. Try again later.');</script>");
                    }
                }
                else
                {
                    // Sai thông tin
                    Response.Write("<script>alert('Incorrect information. Please check your Phone, Full Name, Username, and Email!');</script>");
                }
            }
        }
    }
}
