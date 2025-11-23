using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DOAN_TMDT.DOAN.Role_Admin
{
    public partial class Read_Add_Edit_Delete : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Add this line to either disable UnobtrusiveValidationMode or set it to None
            ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;
            if (!IsPostBack)
            {
                try
                {
                    // Đảm bảo ListView được bind đúng cách
                    ListView1.DataSourceID = "SqlDataSource1";
                    ListView1.DataBind();

                    // Kiểm tra số lượng dữ liệu
                    SqlDataSource1.DataBind();
                    ListView1.DataBind();
                }
                catch (Exception ex)
                {
                    // Hiển thị lỗi để gỡ lỗi
                    Response.Write("Lỗi: " + ex.Message);
                }
            }
        }

        protected void ListView1_ItemInserting(object sender, ListViewInsertEventArgs e)
        {
            try
            {
                // Kiểm tra các trường bắt buộc
                if (string.IsNullOrEmpty(e.Values["CategoryID"].ToString()) ||
                    string.IsNullOrEmpty(e.Values["BrandID"].ToString()) ||
                    string.IsNullOrEmpty(e.Values["ProductName"].ToString()) ||
                    string.IsNullOrEmpty(e.Values["Price"].ToString()) ||
                    string.IsNullOrEmpty(e.Values["Images"].ToString()))
                {
                    e.Cancel = true;
                    DisplayErrorMessage("Please fill in all required fields including the image URL.");
                    return;
                }

                // Validate the image URL
                string imageUrl = e.Values["Images"].ToString();
                if (!IsValidImageUrl(imageUrl))
                {
                    e.Cancel = true;
                    DisplayErrorMessage("Please enter a valid image URL. URLs should start with http:// or https://");
                    return;
                }

                // No need to process file upload as we're using direct URLs now
            }
            catch (Exception ex)
            {
                e.Cancel = true;
                DisplayErrorMessage("Error: " + ex.Message);
            }
        }

        // Renamed method to prevent ambiguity
        private void DisplayErrorMessage(string message)
        {
            // Hiển thị lỗi bằng ClientScript (không bị ảnh hưởng nếu control không tồn tại)
            ClientScript.RegisterStartupScript(this.GetType(), "alert",
                "alert('" + message.Replace("'", "\\'") + "');", true);

            // Cập nhật UI nếu control tồn tại
            if (statusMessage != null && lblStatus != null)
            {
                statusMessage.Visible = true;
                statusMessage.Attributes["class"] = "status-message error";
                lblStatus.Text = message;
            }
        }

        protected void ListView1_ItemUpdating(object sender, ListViewUpdateEventArgs e)
        {
            try
            {
                // Check if the image URL is provided and valid
                if (e.NewValues["Images"] != null && !string.IsNullOrEmpty(e.NewValues["Images"].ToString()))
                {
                    string imageUrl = e.NewValues["Images"].ToString();
                    if (!IsValidImageUrl(imageUrl))
                    {
                        e.Cancel = true;
                        DisplayErrorMessage("Please enter a valid image URL. URLs should start with http:// or https://");
                        return;
                    }
                }
                else if (e.OldValues["Images"] != null)
                {
                    // Keep the old image URL if no new one is provided
                    e.NewValues["Images"] = e.OldValues["Images"];
                }
            }
            catch (Exception ex)
            {
                e.Cancel = true;
                DisplayErrorMessage("Error updating: " + ex.Message);
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {
                string idType = ddlIDType.SelectedValue;
                string searchValue = txtSearch.Text.Trim();

                if (!string.IsNullOrEmpty(searchValue))
                {
                    // Tạo câu lệnh SQL tìm kiếm dựa trên lựa chọn
                    string searchQuery = $"SELECT * FROM [Products] WHERE [{idType}] = '{searchValue}'";
                    SqlDataSource1.SelectCommand = searchQuery;
                }
                else
                {
                    // Nếu không có giá trị tìm kiếm, lấy tất cả dữ liệu
                    SqlDataSource1.SelectCommand = "SELECT * FROM [Products] ORDER BY [ProductID] DESC";
                }

                // Cập nhật ListView
                ListView1.DataBind();
            }
            catch (Exception ex)
            {
                DisplayErrorMessage("Lỗi tìm kiếm: " + ex.Message);
            }
        }
        // Helper method to validate image URLs
        private bool IsValidImageUrl(string url)
        {
       
            string[] validFolders = { "Balenciaga/", "Gucci/", "Dior/", "Hermes/", "Louis Vuitton/", "InsertImageProduct/" };
            string[] validExtensions = { ".jpg", ".png"};

            return !string.IsNullOrEmpty(url) &&
                   validFolders.Any(folder => url.StartsWith(folder, StringComparison.OrdinalIgnoreCase)) &&
                   validExtensions.Any(ext => url.EndsWith(ext, StringComparison.OrdinalIgnoreCase));
        }
        // Note: For more comprehensive validation, you could:
        // 1. Check if the URL points to an actual image file (.jpg, .png, etc.)
        // 2. Try to fetch the headers to verify it's an image
        // But those approaches would be more complex and potentially slow down the application
    }
}
