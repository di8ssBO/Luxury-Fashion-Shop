using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Security.Cryptography;
using System.Text;

//da lien ket database login_register
namespace DOAN_TMDT.DOAN.SignIn_Up
{
    public partial class trangchu : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                HttpCookie loginCookie = Request.Cookies["UserLogin"];
                if (loginCookie != null)
                {
                    txtLoginEmail.Text = loginCookie["UsernameOrEmail"];
                    txtLoginPassword.Attributes["value"] = loginCookie["Password"]; // Dùng .Attributes để không bị xóa TextMode.Password
                    chkRemember.Checked = true;
                }
            }
        }


        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string emailOrUsername = txtLoginEmail.Text.Trim();
            string passwordInput = txtLoginPassword.Text.Trim();
            string hashedPasswordInput = HashPassword(passwordInput); // ✅ mã hóa trước khi so sánh


            string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"]?.ConnectionString;

            if (string.IsNullOrEmpty(connectionString))
            {
                Response.Write("<script>alert('Database connection string is missing!');</script>");
                return;
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string query = "SELECT CustomerID, Username, Email, Phone, Role FROM Customers WHERE (Email = @Input OR Username = @Input) AND Password = @Password";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Input", emailOrUsername);
                cmd.Parameters.AddWithValue("@Password", hashedPasswordInput); // ✅ dùng password đã mã hóa

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        Session["CustomerID"] = reader["CustomerID"].ToString();
                        Session["Username"] = reader["Username"].ToString();
                        Session["Email"] = reader["Email"].ToString();
                        Session["Phone"] = reader["Phone"]?.ToString() ?? ""; // Thêm Phone, xử lý null
                        Session["IsLoggedIn"] = true;
                        Session["Role"] = reader["Role"].ToString(); // ✅ thêm dòng này

                        if (chkRemember.Checked)
                        {
                            HttpCookie loginCookie = new HttpCookie("UserLogin");
                            loginCookie["UsernameOrEmail"] = emailOrUsername;
                            loginCookie["Password"] = passwordInput;
                            loginCookie.Expires = DateTime.Now.AddDays(7);
                            Response.Cookies.Add(loginCookie);
                        }

                        string returnUrl = Request.QueryString["returnUrl"];

                        if (!string.IsNullOrEmpty(returnUrl))
                        {
                            Response.Redirect(returnUrl);
                        }
                        else
                        {
                            // ✅ Kiểm tra nếu là admin thì chuyển hướng đến trang quản lý
                            if (Session["Role"] != null && Session["Role"].ToString().ToLower() == "admin")
                            {
                                Response.Redirect("/DOAN/role_admin/Read_Add_Edit_Delete.aspx");
                            }
                            else
                            {
                                Response.Redirect("/DOAN/Homepage/WebForm-Homepage.aspx");
                            }
                        }
                    }
                    else
                    {
                        Response.Write("<script>alert('Tài khoản hoặc Mật khẩu không đúng. Vui lòng nhập lại !');</script>");
                    }
                }
            }
        }





        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string name = txtName.Text.Trim();
            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string plainPassword = txtPassword.Text.Trim();
            string hashedPassword = HashPassword(plainPassword);  // ✅ Mã hóa 1 lần thôi

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(username) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(plainPassword))
            {
                Response.Write("<script>alert('Please fill in all the required fields!');</script>");
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"]?.ConnectionString;

            if (string.IsNullOrEmpty(connectionString))
            {
                Response.Write("<script>alert('Database connection string is missing!');</script>");
                return;
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string checkQuery = "SELECT COUNT(*) FROM Customers WHERE Username = @Username OR Email = @Email OR Phone = @Phone";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@Username", username);
                checkCmd.Parameters.AddWithValue("@Email", email);
                checkCmd.Parameters.AddWithValue("@Phone", phone);

                int existCount = (int)checkCmd.ExecuteScalar();

                if (existCount > 0)
                {
                    Response.Write("<script>alert('Username, Email or Phone has already been registered!');</script>");
                    return;
                }

                string query = "INSERT INTO Customers (FullName, Username, Email, Password, Phone, Address) VALUES (@FullName, @Username, @Email, @Password, @Phone, @Address)";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@FullName", name);
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Password", hashedPassword);  // ✅ dùng đúng hash
                cmd.Parameters.AddWithValue("@Phone", phone);
                cmd.Parameters.AddWithValue("@Address", "");

                int result = cmd.ExecuteNonQuery();

                if (result > 0)
                {
                    Response.Write("<script>alert('Register successful!');</script>");
                }
                else
                {
                    Response.Write("<script>alert('Register failed!');</script>");
                }
            }
        }

        // ✅ Hàm mã hóa mật khẩu SHA256
        private string HashPassword(string password)
        {
            using (SHA256 sha256Hash = SHA256.Create())
            {
                byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                foreach (var b in bytes)
                    builder.Append(b.ToString("x2"));
                return builder.ToString();
            }
        }


    }
}



