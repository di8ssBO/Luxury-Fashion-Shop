using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DOAN_TMDT.DOAN.GioHang
{
    public partial class WebForm_GioHang : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Initialize shopping cart if it doesn't exist
                if (Session["ShoppingCart"] == null)
                {
                    Session["ShoppingCart"] = CreateEmptyCartTable();
                }

                // Convert Dictionary to DataTable for display
                ConvertCartDictionaryToDataTable();

                // Load shopping cart items for display
                LoadShoppingCart();
            }
        }

        // New method to convert the Dictionary to DataTable
        private void ConvertCartDictionaryToDataTable()
        {
            Dictionary<int, int> cartDict = Session["ShoppingCart"] as Dictionary<int, int>;

            if (cartDict != null && cartDict.Count > 0)
            {
                // Create or get the cart DataTable
                DataTable cartTable = Session["CartDataTable"] as DataTable ?? CreateEmptyCartTable();

                // Clear existing rows to avoid duplicates
                cartTable.Clear();

                string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    foreach (var item in cartDict)
                    {
                        int productId = item.Key;
                        int quantity = item.Value;

                        // First, try to get variant info for this product
                        using (SqlCommand cmd = new SqlCommand(@"
                            SELECT ProductID, ProductName, Price, Images 
                            FROM Products
                            WHERE ProductID = @ProductID", conn))
                        {
                            cmd.Parameters.AddWithValue("@ProductID", productId);

                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    // Add product with variant info
                                    DataRow newRow = cartTable.NewRow();
                                    newRow["ProductID"] = reader["ProductID"];
                                    newRow["ProductName"] = reader["ProductName"];
                                    newRow["Images"] = reader["Images"];
                                    newRow["Price"] = reader["Price"];
                                    newRow["Quantity"] = quantity;
                                    cartTable.Rows.Add(newRow);
                                }
                            }
                        }
                    }
                }

                // Save the DataTable to session
                Session["CartDataTable"] = cartTable;
            }
        }

        // Method to load shopping cart items from session
        private void LoadShoppingCart()
        {
            DataTable cartTable = Session["CartDataTable"] as DataTable;

            if (cartTable != null && cartTable.Rows.Count > 0)
            {
                ListView1.DataSource = cartTable;
                ListView1.DataBind();
                DebugLabel.Text = $"🛒 Có {cartTable.Rows.Count} sản phẩm trong giỏ.";
            }
            else
            {
                ListView1.DataSource = null;
                ListView1.DataBind();
                DebugLabel.Text = "🛒 Giỏ hàng trống.";
            }

            // Update the UI display of quantities
            ClientScript.RegisterStartupScript(this.GetType(), "UpdateCartTotals", "updateCartTotal();", true);
        }

        // Create an empty cart data table
        private DataTable CreateEmptyCartTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ProductID", typeof(int));
            dt.Columns.Add("ProductName", typeof(string));
            dt.Columns.Add("Images", typeof(string));
            dt.Columns.Add("Price", typeof(decimal));
            dt.Columns.Add("Quantity", typeof(int));
            return dt;
        }

        // Add product to cart
        public void AddProductToCart(int productId)
        {
            DataTable cartTable = (DataTable)Session["ShoppingCart"];

            // Check if product already exists in cart
            DataRow[] foundRows = cartTable.Select($"ProductID = {productId}");

            if (foundRows.Length > 0)
            {
                // Product already exists, increase quantity
                foundRows[0]["Quantity"] = Convert.ToInt32(foundRows[0]["Quantity"]) + 1;
            }
            else
            {
                // Fetch product details from database
                string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["LUXURY_FASHION_SHOPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("SELECT ProductID, ProductName, Images, Price FROM Products WHERE ProductID = @ProductID", conn))
                    {
                        cmd.Parameters.AddWithValue("@ProductID", productId);
                        conn.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Add new product to cart
                                DataRow newRow = cartTable.NewRow();
                                newRow["ProductID"] = reader["ProductID"];
                                newRow["ProductName"] = reader["ProductName"];
                                newRow["Images"] = reader["Images"];
                                newRow["Price"] = reader["Price"];
                                newRow["Quantity"] = 1;
                                cartTable.Rows.Add(newRow);
                            }
                        }
                    }
                }
            }

            // Update session and rebind
            Session["ShoppingCart"] = cartTable;
            ListView1.DataSource = cartTable;
            ListView1.DataBind();
        }

        //// Handle ListView item command (Delete, Update)
        // Update the ListView_ItemCommand method in WebForm-GioHang.aspx.cs
        protected void ListView1_ItemCommand(object sender, ListViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteItem")
            {
                if (int.TryParse(e.CommandArgument?.ToString(), out int productId))
                {
                    // Remove from dictionary first
                    Dictionary<int, int> cartDict = Session["ShoppingCart"] as Dictionary<int, int>;
                    if (cartDict != null && productId > 0 && cartDict.ContainsKey(productId))
                    {
                        cartDict.Remove(productId);
                        Session["ShoppingCart"] = cartDict;
                    }

                    // Then remove from DataTable
                    DataTable cartTable = Session["CartDataTable"] as DataTable;
                    if (cartTable != null)
                    {
                        DeleteProduct(productId, cartTable);
                        Session["CartDataTable"] = cartTable;
                    }
                }

                // Reload shopping cart
                LoadShoppingCart();
            }
        }

        // Helper method to get ProductID from VariantID
        private int GetProductIdForVariant(int variantId)
        {
            DataTable cartTable = Session["CartDataTable"] as DataTable;
            if (cartTable != null)
            {
                DataRow[] rows = cartTable.Select($"VariantID = {variantId}");
                if (rows.Length > 0 && rows[0]["ProductID"] != DBNull.Value)
                {
                    return Convert.ToInt32(rows[0]["ProductID"]);
                }
            }
            return 0;
        }

        // Method to delete product from cart
        private void DeleteProduct(int productId, DataTable cartTable)
        {
            DataRow[] rows = cartTable.Select($"ProductID = {productId}");
            if (rows.Length > 0)
            {
                foreach (DataRow row in rows.ToList()) // Dùng ToList để tránh lỗi khi xóa
                {
                    cartTable.Rows.Remove(row);
                }
                cartTable.AcceptChanges(); // Đảm bảo các thay đổi được áp dụng
            }
            else
            {
                DebugLabel.Text = "❌ Lỗi: Không tìm thấy sản phẩm với VariantID = " + productId;
            }
        }

        // Method to update product quantity
        private void UpdateProductQuantity(int productId, int quantity, DataTable cartTable)
        {
            DataRow[] rows = cartTable.Select($"ProductID = {productId}");
            if (rows.Length > 0)
            {
                rows[0]["Quantity"] = quantity;
            }
        }
        protected void btnPurchase_Click(object sender, EventArgs e)
        {
            // Chuyển sang trang thanh toán OrdersPay.aspx
            Response.Redirect("/DOAN/OrdersPay/OrdersPay.aspx");
        }
    }
}