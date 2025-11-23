using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DOAN_TMDT.DOAN.OrdersCustomer
{
    public partial class OrdersCustomer : System.Web.UI.Page
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
                // Kiểm tra các trường bắt buộc cho OrderSummary
                if (string.IsNullOrEmpty(e.Values["NguoiNhanHang"]?.ToString()) ||
                    string.IsNullOrEmpty(e.Values["AddressReceiver"]?.ToString()) ||
                    string.IsNullOrEmpty(e.Values["PhoneReceiver"]?.ToString()) ||
                    string.IsNullOrEmpty(e.Values["ProductName"]?.ToString()) ||
                    string.IsNullOrEmpty(e.Values["Quantity"]?.ToString()) ||
                    string.IsNullOrEmpty(e.Values["TotalPrice"]?.ToString()))
                {
                    e.Cancel = true;
                    DisplayErrorMessage("Please fill in all required fields.");
                    return;
                }

                // Validate Quantity is a valid integer
                if (!int.TryParse(e.Values["Quantity"].ToString(), out int quantity) || quantity <= 0)
                {
                    e.Cancel = true;
                    DisplayErrorMessage("Please enter a valid quantity (positive number).");
                    return;
                }

                // Validate TotalPrice is a valid decimal
                if (!decimal.TryParse(e.Values["TotalPrice"].ToString(), out decimal totalPrice) || totalPrice <= 0)
                {
                    e.Cancel = true;
                    DisplayErrorMessage("Please enter a valid total price (positive number).");
                    return;
                }

                // Validate Phone number format (basic validation)
                string phoneNumber = e.Values["PhoneReceiver"].ToString().Trim();
                if (!IsValidPhoneNumber(phoneNumber))
                {
                    e.Cancel = true;
                    DisplayErrorMessage("Please enter a valid phone number (10-15 digits).");
                    return;
                }
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

        private void DisplaySuccessMessage(string message)
        {
            // Hiển thị thông báo thành công
            ClientScript.RegisterStartupScript(this.GetType(), "success",
                "alert('" + message.Replace("'", "\\'") + "');", true);

            // Cập nhật UI nếu control tồn tại
            if (statusMessage != null && lblStatus != null)
            {
                statusMessage.Visible = true;
                statusMessage.Attributes["class"] = "status-message success";
                lblStatus.Text = message;
            }
        }

        protected void ListView1_ItemUpdating(object sender, ListViewUpdateEventArgs e)
        {
            try
            {
                // Validate required fields
                if (string.IsNullOrEmpty(e.NewValues["NguoiNhanHang"]?.ToString()) ||
                    string.IsNullOrEmpty(e.NewValues["AddressReceiver"]?.ToString()) ||
                    string.IsNullOrEmpty(e.NewValues["PhoneReceiver"]?.ToString()) ||
                    string.IsNullOrEmpty(e.NewValues["ProductName"]?.ToString()) ||
                    string.IsNullOrEmpty(e.NewValues["Quantity"]?.ToString()))
                {
                    e.Cancel = true;
                    DisplayErrorMessage("Please fill in all required fields.");
                    return;
                }

                // Validate Quantity
                if (!int.TryParse(e.NewValues["Quantity"].ToString(), out int quantity) || quantity <= 0)
                {
                    e.Cancel = true;
                    DisplayErrorMessage("Please enter a valid quantity (positive number).");
                    return;
                }

                // Validate Phone number
                string phoneNumber = e.NewValues["PhoneReceiver"].ToString().Trim();
                if (!IsValidPhoneNumber(phoneNumber))
                {
                    e.Cancel = true;
                    DisplayErrorMessage("Please enter a valid phone number (10-15 digits).");
                    return;
                }

                // Clean phone number (remove spaces and special characters except +)
                e.NewValues["PhoneReceiver"] = CleanPhoneNumber(phoneNumber);
            }
            catch (Exception ex)
            {
                e.Cancel = true;
                DisplayErrorMessage("Error updating: " + ex.Message);
            }
        }

        protected void ListView1_ItemUpdated(object sender, ListViewUpdatedEventArgs e)
        {
            if (e.Exception == null && e.AffectedRows > 0)
            {
                DisplaySuccessMessage("Order updated successfully!");
            }
            else if (e.Exception != null)
            {
                DisplayErrorMessage("Error updating order: " + e.Exception.Message);
                e.ExceptionHandled = true;
            }
        }

        protected void ListView1_ItemDeleted(object sender, ListViewDeletedEventArgs e)
        {
            if (e.Exception == null && e.AffectedRows > 0)
            {
                DisplaySuccessMessage("Order deleted successfully!");
            }
            else if (e.Exception != null)
            {
                DisplayErrorMessage("Error deleting order: " + e.Exception.Message);
                e.ExceptionHandled = true;
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
                    // Tạo câu lệnh SQL tìm kiếm dựa trên lựa chọn cho OrderSummary
                    string searchQuery = "";

                    switch (idType)
                    {
                        case "OrderSummaryID":
                            if (int.TryParse(searchValue, out int orderId))
                            {
                                searchQuery = $"SELECT * FROM [OrderSummary] WHERE [OrderSummaryID] = {orderId}";
                            }
                            else
                            {
                                DisplayErrorMessage("Please enter a valid Order ID (number).");
                                return;
                            }
                            break;
                        case "NguoiNhanHang":
                            searchQuery = $"SELECT * FROM [OrderSummary] WHERE [NguoiNhanHang] LIKE '%{searchValue.Replace("'", "''")}%'";
                            break;
                        case "PhoneReceiver":
                            searchQuery = $"SELECT * FROM [OrderSummary] WHERE [PhoneReceiver] LIKE '%{searchValue.Replace("'", "''")}%'";
                            break;
                        case "ProductName":
                            searchQuery = $"SELECT * FROM [OrderSummary] WHERE [ProductName] LIKE '%{searchValue.Replace("'", "''")}%'";
                            break;
                        default:
                            searchQuery = $"SELECT * FROM [OrderSummary] WHERE [OrderSummaryID] = {searchValue}";
                            break;
                    }

                    SqlDataSource1.SelectCommand = searchQuery;
                }
                else
                {
                    // Nếu không có giá trị tìm kiếm, lấy tất cả dữ liệu
                    SqlDataSource1.SelectCommand = "SELECT * FROM [OrderSummary] ORDER BY [OrderSummaryID] DESC";
                }

                // Cập nhật ListView
                ListView1.DataBind();

                // Kiểm tra xem có kết quả không
                if (ListView1.Items.Count == 0)
                {
                    DisplayErrorMessage("No orders found matching your search criteria.");
                }
            }
            catch (Exception ex)
            {
                DisplayErrorMessage("Lỗi tìm kiếm: " + ex.Message);
            }
        }

        // Helper method to validate phone numbers
        private bool IsValidPhoneNumber(string phoneNumber)
        {
            if (string.IsNullOrEmpty(phoneNumber))
                return false;

            // Remove all non-digit characters except +
            string cleanPhone = System.Text.RegularExpressions.Regex.Replace(phoneNumber, @"[^\d+]", "");

            // Check if it's between 10-15 digits (including country code)
            if (cleanPhone.StartsWith("+"))
            {
                return cleanPhone.Length >= 11 && cleanPhone.Length <= 16; // +1234567890 to +123456789012345
            }
            else
            {
                return cleanPhone.Length >= 10 && cleanPhone.Length <= 15; // 1234567890 to 123456789012345
            }
        }

        // Helper method to clean phone number
        private string CleanPhoneNumber(string phoneNumber)
        {
            if (string.IsNullOrEmpty(phoneNumber))
                return phoneNumber;

            // Keep only digits, spaces, dashes, parentheses, and plus sign
            return System.Text.RegularExpressions.Regex.Replace(phoneNumber, @"[^\d\s\-\(\)\+]", "").Trim();
        }
    }
}