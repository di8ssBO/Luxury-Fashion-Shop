using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Services;
using System.Web.Services;

namespace DOAN_TMDT.DOAN.ProductPage
{
    public partial class ProductPage : System.Web.UI.Page
    {
        private const int DEFAULT_PRODUCT_COUNT = 60;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Kiểm tra trạng thái đăng nhập
                if (Session["IsLoggedIn"] != null && (bool)Session["IsLoggedIn"])
                {
                    // Đã đăng nhập: hiển thị Welcome, Username và biểu tượng ⚙️
                    pnlWelcome.Visible = true;
                    btnLogin.Visible = false;

                    lblUsernameSearch.Text = Session["Username"]?.ToString() ?? "Chưa có tên";
                    Label1.Text = Session["Username"]?.ToString() ?? "Chưa có tên";
                    lblEmail.Text = Session["Email"]?.ToString() ?? "Chưa có email";
                    lblPhone.Text = Session["Phone"]?.ToString() ?? "Chưa có số điện thoại";
                }
                else
                {
                    // Chưa đăng nhập: hiển thị nút Login, ẩn Welcome
                    pnlWelcome.Visible = false;
                    btnLogin.Visible = true;

                    // Chỉ ẩn thông tin tài khoản nếu không cần hiện cho khách
                    // Nếu bạn muốn khách vẫn thấy phần nội dung sản phẩm, KHÔNG nên ẩn toàn bộ panel
                    // -> Có thể giữ pnlAccountInfo.Visible = true nếu nó chứa phần sản phẩm
                }

                // Luôn luôn hiển thị dữ liệu sản phẩm
                chkAllProducts.Checked = true;
                BindData();
                UpdateCartCount();
            }
        }

        private void BindData()
        {
            // Set the initial SQL query
            UpdateProductQuery();
        }

        private void UpdateProductQuery()
        {
            // Base query
            string query = @"SELECT p.ProductID, p.ProductName, p.Price, p.Images 
                           FROM Products p";

            // Lists to track where conditions and parameters
            List<string> whereConditions = new List<string>();
            Dictionary<string, string> parameters = new Dictionary<string, string>();

            // Get selected categories
            List<string> selectedCategories = new List<string>();
            if (chkClothing.Checked) selectedCategories.Add("Ready to Wear");
            if (chkSneakers.Checked) selectedCategories.Add("Sneakers");
            if (chkHandbags.Checked) selectedCategories.Add("Handbags");
            if (chkGlasses.Checked) selectedCategories.Add("Glasses");
            if (chkBelts.Checked) selectedCategories.Add("Belts");

            // Get selected brands
            List<string> selectedBrands = new List<string>();
            if (chkLouisVuitton.Checked) selectedBrands.Add("Louis Vuitton");
            if (chkGucci.Checked) selectedBrands.Add("Gucci");
            if (chkDior.Checked) selectedBrands.Add("Dior");
            if (chkBalenciaga.Checked) selectedBrands.Add("Balenciaga");
            if (chkHermes.Checked) selectedBrands.Add("Hermes");

            // Store selected categories and brands in hidden fields for persistence
            hdnSelectedCategories.Value = string.Join(",", selectedCategories);
            hdnSelectedBrands.Value = string.Join(",", selectedBrands);

            // Check if we need joins for filtering
            bool needCategoryJoin = selectedCategories.Count > 0 && !chkAllProducts.Checked;
            bool needBrandJoin = selectedBrands.Count > 0;

            // Add JOIN clauses if needed
            if (needCategoryJoin)
            {
                query += " JOIN dbo.Categories c ON p.CategoryID = c.CategoryID";
            }

            if (needBrandJoin)
            {
                query += " JOIN dbo.Brands b ON p.BrandID = b.BrandID";
            }

            // Add category filter conditions if specific categories are selected
            if (needCategoryJoin)
            {
                string categoryCondition = "c.CategoryName IN (";
                for (int i = 0; i < selectedCategories.Count; i++)
                {
                    string paramName = $"@Category{i}";
                    categoryCondition += (i > 0 ? ", " : "") + paramName;
                    parameters.Add(paramName, selectedCategories[i]);
                }
                categoryCondition += ")";
                whereConditions.Add(categoryCondition);
            }

            // Add brand filter conditions if specific brands are selected
            if (needBrandJoin)
            {
                string brandCondition = "b.BrandName IN (";
                for (int i = 0; i < selectedBrands.Count; i++)
                {
                    string paramName = $"@Brand{i}";
                    brandCondition += (i > 0 ? ", " : "") + paramName;
                    parameters.Add(paramName, selectedBrands[i]);
                }
                brandCondition += ")";
                whereConditions.Add(brandCondition);
            }

            // Build WHERE clause
            if (whereConditions.Count > 0)
            {
                query += " WHERE " + string.Join(" AND ", whereConditions);
            }

            // Set up the sorting
            string orderByClause = "";
            string sortOption = SortDropDown.SelectedValue;

            switch (sortOption)
            {
                case "PriceAsc":
                    orderByClause = " ORDER BY p.Price ASC";
                    break;
                case "PriceDesc":
                    orderByClause = " ORDER BY p.Price DESC";
                    break;
                case "NameAsc":
                    orderByClause = " ORDER BY p.ProductName ASC";
                    break;
                case "NameDesc":
                    orderByClause = " ORDER BY p.ProductName DESC";
                    break;
                default:
                    orderByClause = " ORDER BY p.ProductID"; // Default sort by ID
                    break;
            }

            // Check if showing all products
            bool showAll = Convert.ToBoolean(hdnShowAll.Value);

            // If not showing all, limit the number of products (when no filters are active)
            if (!showAll && whereConditions.Count == 0)
            {
                // Modify query to only get TOP products
                query = query.Replace("SELECT ", "SELECT TOP " + DEFAULT_PRODUCT_COUNT + " ");
            }

            // Add the ORDER BY clause
            query += orderByClause;

            // Update the SqlDataSource
            SqlDataSource.SelectCommand = query;

            // Clear existing parameters
            SqlDataSource.SelectParameters.Clear();

            // Add parameters for filtering
            foreach (var param in parameters)
            {
                SqlDataSource.SelectParameters.Add(param.Key.Substring(1), param.Value);
            }

            // Update text for View All button
            btnViewAll.Text = showAll ? "Show Less" : "View All";

            // Update the filter display text
            UpdateFilterDisplayText();

            // Show or hide the clear filters button
            lnkClearFilters.Visible = selectedCategories.Count > 0 || selectedBrands.Count > 0 || !chkAllProducts.Checked;
        }

        protected void UpdateFilterDisplayText()
        {
            List<string> filterTexts = new List<string>();

            // Get category filter text
            if (chkAllProducts.Checked)
            {
                filterTexts.Add("All Products");
            }
            else
            {
                List<string> categoryFilters = new List<string>();
                if (chkClothing.Checked) categoryFilters.Add("Ready to Wear");
                if (chkSneakers.Checked) categoryFilters.Add("Sneakers");
                if (chkHandbags.Checked) categoryFilters.Add("Handbags");
                if (chkGlasses.Checked) categoryFilters.Add("Glasses");
                if (chkBelts.Checked) categoryFilters.Add("Belts");

                if (categoryFilters.Count > 0)
                {
                    filterTexts.Add(string.Join(", ", categoryFilters));
                }
                else
                {
                    filterTexts.Add("No Category Selected");
                }
            }

            // Get brand filter text
            List<string> brandFilters = new List<string>();
            if (chkLouisVuitton.Checked) brandFilters.Add("Louis Vuitton");
            if (chkGucci.Checked) brandFilters.Add("Gucci");
            if (chkDior.Checked) brandFilters.Add("Dior");
            if (chkBalenciaga.Checked) brandFilters.Add("Balenciaga");
            if (chkHermes.Checked) brandFilters.Add("Hermes");

            if (brandFilters.Count > 0)
            {
                filterTexts.Add(string.Join(", ", brandFilters));
            }
            else
            {
                filterTexts.Add("All Brands");
            }

            // Update the label
            lblCurrentFilter.Text = string.Join(" - ", filterTexts);
        }

        protected void SortDropDown_SelectedIndexChanged(object sender, EventArgs e)
        {
            // When sort dropdown selection changes, update the query
            UpdateProductQuery();
        }

        protected void btnViewAll_Click(object sender, EventArgs e)
        {
            // Toggle display state
            bool currentValue = Convert.ToBoolean(hdnShowAll.Value);
            hdnShowAll.Value = (!currentValue).ToString();

            // Update query and rebind data
            UpdateProductQuery();
        }

        protected void CategoryCheckbox_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox checkbox = (CheckBox)sender;

            // If "All Products" is checked, uncheck other categories
            if (checkbox.ID == "chkAllProducts" && checkbox.Checked)
            {
                chkClothing.Checked = false;
                chkSneakers.Checked = false;
                chkHandbags.Checked = false;
                chkGlasses.Checked = false;
                chkBelts.Checked = false;
            }
            // If any other category is checked, uncheck "All Products"
            else if (checkbox.ID != "chkAllProducts" && checkbox.Checked)
            {
                chkAllProducts.Checked = false;
            }

            // If no category is checked, check "All Products" by default
            if (!chkAllProducts.Checked && !chkClothing.Checked && !chkSneakers.Checked &&
                !chkHandbags.Checked && !chkGlasses.Checked && !chkBelts.Checked)
            {
                chkAllProducts.Checked = true;
            }

            // Update query based on new selections
            UpdateProductQuery();
        }

        protected void BrandCheckbox_CheckedChanged(object sender, EventArgs e)
        {
            // Update query based on brand selection changes
            UpdateProductQuery();
        }

        protected void ResetFilters_Click(object sender, EventArgs e)
        {
            // Reset all checkboxes
            chkAllProducts.Checked = true;
            chkClothing.Checked = false;
            chkSneakers.Checked = false;
            chkHandbags.Checked = false;
            chkGlasses.Checked = false;
            chkBelts.Checked = false;

            chkLouisVuitton.Checked = false;
            chkGucci.Checked = false;
            chkDior.Checked = false;
            chkBalenciaga.Checked = false;
            chkHermes.Checked = false;

            // Reset hidden fields
            hdnSelectedCategories.Value = "";
            hdnSelectedBrands.Value = "";
            hdnShowAll.Value = "false";

            // Update query and rebind data
            UpdateProductQuery();
        }

        protected string FormatImageUrl(string imageName)
        {
            // Relative path to image directory
            return "/image(Products)/" + imageName;
        }
        protected void AddToCart_Command(object sender, CommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
                // Get the product ID from the command argument
                int productId = Convert.ToInt32(e.CommandArgument);

                // Add the product to the shopping cart
                AddProductToCart(productId);

                // Update the cart count display
                UpdateCartCount();

                // Use alert instead of custom notification
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowAlert",
                    "alert('Hàng đã được thêm vào giỏ!');", true);
            }
        }

        private void AddProductToCart(int productId)
        {
            // Get or create the shopping cart list in the session
            Dictionary<int, int> cart = Session["ShoppingCart"] as Dictionary<int, int> ?? new Dictionary<int, int>();

            // If the product is already in the cart, increase quantity, otherwise add it
            if (cart.ContainsKey(productId))
            {
                cart[productId]++;
            }
            else
            {
                cart.Add(productId, 1);
            }

            // Save the updated cart back to session
            Session["ShoppingCart"] = cart;
        }

        private void UpdateCartCount()
        {
            // Calculate total items in cart
            int totalItems = 0;
            Dictionary<int, int> cart = Session["ShoppingCart"] as Dictionary<int, int>;

            if (cart != null)
            {
                foreach (var item in cart)
                {
                    totalItems += item.Value;
                }
            }

            // Update the cart count display
            cartCount.InnerText = totalItems.ToString();
            hdnCartCount.Value = totalItems.ToString();
        }

        // Web method to get product details for the cart notification
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetProductName(int productId)
        {
            string productName = string.Empty;

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT ProductName FROM Products WHERE ProductID = @ProductID", conn);
                cmd.Parameters.AddWithValue("@ProductID", productId);

                conn.Open();
                object result = cmd.ExecuteScalar();

                if (result != null)
                {
                    productName = result.ToString();
                }
            }

            return productName;
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Xoá session đăng nhập
            Session.Clear();

            // Quay lại trang đăng nhập
            Response.Redirect("../ProductPage/ProductPage.aspx");
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // Điều hướng đến trang đăng nhập
            Response.Redirect("../trangchu.aspx?returnUrl=../DOAN/ProductPage/ProductPage.aspx");
        }

    }
}