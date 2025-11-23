using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DOAN_TMDT.DOAN.OrdersPay
{
    public partial class OrdersPay : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Dùng CartDataTable thay vì ShoppingCart
                if (Session["CartDataTable"] != null)
                {
                    DataTable cartTable = Session["CartDataTable"] as DataTable;

                    if (cartTable.Rows.Count > 0)
                    {
                        DataTable orderDetailsTable = CreateOrderDetailsTable();

                        foreach (DataRow cartRow in cartTable.Rows)
                        {
                            DataRow newRow = orderDetailsTable.NewRow();
                            newRow["OrderDetailID"] = Guid.NewGuid().ToString();
                            newRow["ProductID"] = cartRow["ProductID"];
                            newRow["ProductName"] = cartRow["ProductName"];
                            newRow["Quantity"] = cartRow["Quantity"];

                            decimal price = Convert.ToDecimal(cartRow["Price"]);
                            int quantity = Convert.ToInt32(cartRow["Quantity"]);
                            newRow["UnitPrice"] = price * quantity;

                            newRow["Images"] = cartRow["Images"];

                            orderDetailsTable.Rows.Add(newRow);
                        }

                        Session["OrderDetails"] = orderDetailsTable;

                        ListView1.DataSource = orderDetailsTable;
                        ListView1.DataBind();

                        decimal totalAmount = CalculateTotal(orderDetailsTable);
                        if (Page.FindControl("totalAmount") is Label totalLabel)
                        {
                            totalLabel.Text = totalAmount.ToString("C2");
                        }
                    }
                    else
                    {
                        Response.Redirect("~/DOAN/GioHang/WebForm-GioHang.aspx");
                    }
                }
                else
                {
                    Response.Redirect("~/DOAN/GioHang/WebForm-GioHang.aspx");
                }
            }
        }

        // Create the data structure for OrderDetails
        private DataTable CreateOrderDetailsTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("OrderDetailID", typeof(string));
            dt.Columns.Add("ProductID", typeof(int));
            dt.Columns.Add("ProductName", typeof(string)); // Add ProductName column
            dt.Columns.Add("UnitPrice", typeof(decimal));
            dt.Columns.Add("Quantity", typeof(int));
            dt.Columns.Add("Images", typeof(string));
            dt.Columns.Add("nguoiNhanHang", typeof(string));
            dt.Columns.Add("phoneReceiver", typeof(string));
            dt.Columns.Add("addressReceiver", typeof(string));
            return dt;
        }

        // Calculate the total amount from the order details
        private decimal CalculateTotal(DataTable orderDetails)
        {
            decimal total = 0;

            foreach (DataRow row in orderDetails.Rows)
            {
                total += Convert.ToDecimal(row["UnitPrice"]);
            }

            return total;
        }


        protected void Submit1_Click(object sender, EventArgs e)
        {
            // Lấy dữ liệu từ form
            string NguoiNhanHang = txtNguoiNhanHang.Text.Trim();
            string AddressReceiver = txtAddressReceiver.Text.Trim();
            string PhoneReceiver = txtPhoneReceiver.Text.Trim();

            if (string.IsNullOrEmpty(NguoiNhanHang) || string.IsNullOrEmpty(AddressReceiver) || string.IsNullOrEmpty(PhoneReceiver))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Vui lòng điền đầy đủ thông tin.');", true);
                return;
            }


            if (Session["OrderDetails"] is DataTable orderDetailsTable)
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LUXURY_FASHION_SHOPConnectionString1"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Giả sử bạn đã có OrderID (ví dụ: tạo đơn hàng xong rồi lấy ID)
                    int customerId = Convert.ToInt32(Session["CustomerID"]);
                    int orderId = CreateOrderAndGetID(conn, customerId);


                    foreach (DataRow row in orderDetailsTable.Rows)
                    {
                        // Thêm dữ liệu vào bảng OrderSummary
                        using (SqlCommand summaryCmd = new SqlCommand("INSERT INTO OrderSummary (NguoiNhanHang, AddressReceiver, PhoneReceiver, ProductName, Quantity, TotalPrice) VALUES (@NguoiNhanHang, @AddressReceiver, @PhoneReceiver, @ProductName, @Quantity, @TotalPrice)", conn))
                        {
                            summaryCmd.Parameters.AddWithValue("@NguoiNhanHang", NguoiNhanHang);
                            summaryCmd.Parameters.AddWithValue("@AddressReceiver", AddressReceiver);
                            summaryCmd.Parameters.AddWithValue("@PhoneReceiver", PhoneReceiver);
                            summaryCmd.Parameters.AddWithValue("@ProductName", row["ProductName"].ToString());
                            summaryCmd.Parameters.AddWithValue("@Quantity", Convert.ToInt32(row["Quantity"]));
                            summaryCmd.Parameters.AddWithValue("@TotalPrice", Convert.ToDecimal(row["UnitPrice"]));

                            summaryCmd.ExecuteNonQuery();
                        }

                    }

                    // Sau khi lưu thành công
                    Session["ShoppingCart"] = null;
                    Session["OrderDetails"] = null;

                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Đặt hàng thành công!');", true);
                }
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Không tìm thấy dữ liệu giỏ hàng.');", true);
            }
        }

        private int CreateOrderAndGetID(SqlConnection conn, int customerId)
        {
            using (SqlCommand cmd = new SqlCommand("INSERT INTO Orders (CustomerID, OrderDate, OrderStatus) OUTPUT INSERTED.OrderID VALUES (@CustomerID, @OrderDate, @OrderStatus)", conn))
            {
                cmd.Parameters.AddWithValue("@CustomerID", customerId);
                cmd.Parameters.AddWithValue("@OrderDate", DateTime.Now);
                cmd.Parameters.AddWithValue("@OrderStatus", "Pending"); // Trạng thái mặc định

                int newOrderId = (int)cmd.ExecuteScalar();
                return newOrderId;
            }
        }



        // Hàm tạo đơn hàng mới trả về OrderID
        private int CreateNewOrder(int customerId)
        {
            int newOrderId = 0;
            string connectionString = ConfigurationManager.ConnectionStrings["LUXURY_FASHION_SHOPConnectionString1"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // Thêm @OrderStatus và giá trị mặc định ví dụ 'Pending'
                string query = @"INSERT INTO Orders (CustomerID, OrderDate, OrderStatus) 
                         VALUES (@CustomerID, GETDATE(), @OrderStatus);
                         SELECT CAST(SCOPE_IDENTITY() AS int);";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CustomerID", customerId);
                    cmd.Parameters.AddWithValue("@OrderStatus", "Pending"); // hoặc trạng thái bạn muốn

                    conn.Open();
                    newOrderId = (int)cmd.ExecuteScalar();
                    conn.Close();
                }
            }
            return newOrderId;
        }



    }
}
