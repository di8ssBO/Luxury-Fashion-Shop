<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrdersCustomer.aspx.cs" Inherits="DOAN_TMDT.DOAN.OrdersCustomer.OrdersCustomer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="../css/OrdersCustomer.css" />
    <style>
    .menu-style {
        background-color: transparent;
        border: none;
    }

    .menu-item {
        color: red !important; /* ✅ Đổi màu chữ tại đây */
        font-size: 16px;
        padding: 5px 10px;
        text-decoration: none;
    }

    .menu-item:hover {
        color: blue !important; /* ✅ Màu khi hover nếu bạn muốn */
    }
</style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
    <div class="nav-menu">
        <!-- Menu với CSS tùy chỉnh -->
        <div class="menu-items">
            <h1 href="#">Luxury Fashion</h1>
        </div>
        <div class="banner">
            <p>This is where you can view, add, edit, delete your products (Admin account only).</p>
        </div>
        <!-- Settings Icon -->
        <asp:LinkButton ID="SettingsButton" runat="server" CssClass="settings-icon" >⚙️</asp:LinkButton>
    </div>
</div>

<div style="text-align: center; width: 100%; margin: 15px auto;">
    <!-- THANH TÌM KIẾM -->
<asp:Menu ID="MainMenu" runat="server" Orientation="Horizontal" 
          StaticMenuStyle-CssClass="menu-style"
          StaticMenuItemStyle-CssClass="menu-item"
          DynamicMenuStyle-CssClass="dropdown-menu">
    <Items>
        <asp:MenuItem Text="Products" Value="Products" NavigateUrl="../role_admin/Read_Add_Edit_Delete.aspx" />
    </Items>
</asp:Menu>
    <div style="display: inline-block; width: 80%; max-width: 800px;">
        <asp:DropDownList ID="ddlIDType" runat="server" CssClass="search-dropdown" style="padding: 8px; margin-right: 5px;">
            <asp:ListItem Text="Order ID" Value="OrderSummaryID" />
            <asp:ListItem Text="Phone Number" Value="PhoneReceiver" />
        </asp:DropDownList>
        <asp:TextBox ID="txtSearch" runat="server" placeholder="Enter search value..." style="padding: 8px; width: 50%; margin-right: 5px;" />
        <asp:Button ID="btnSearch" runat="server" Text="Search" style="padding: 8px 15px; cursor: pointer;" OnClick="btnSearch_Click"/>
    </div>
</div>

<div>
    <asp:ListView ID="ListView1" runat="server" DataKeyNames="OrderSummaryID" DataSourceID="SqlDataSource1" OnItemInserting="ListView1_ItemInserting" OnItemUpdating="ListView1_ItemUpdating" > 
        
        <AlternatingItemTemplate>
            <tr style="">
                <td>
                    <asp:Label ID="OrderSummaryIDLabel" runat="server" Text='<%# Eval("OrderSummaryID") %>' />
                </td>
                <td>
                    <asp:Label ID="NguoiNhanHangLabel" runat="server" Text='<%# Eval("NguoiNhanHang") %>' />
                </td>
                <td>
                    <asp:Label ID="AddressReceiverLabel" runat="server" Text='<%# Eval("AddressReceiver") %>' />
                </td>
                <td>
                    <asp:Label ID="PhoneReceiverLabel" runat="server" Text='<%# Eval("PhoneReceiver") %>' />
                </td>
                <td>
                    <asp:Label ID="ProductNameLabel" runat="server" Text='<%# Eval("ProductName") %>' />
                </td>
                <td>
                    <asp:Label ID="QuantityLabel" runat="server" Text='<%# Eval("Quantity") %>' />
                </td>
                <td>
                    <asp:Label ID="TotalPriceLabel" runat="server" Text='<%# Eval("TotalPrice") %>' />
                </td>
                <td>
                    <asp:Button ID="EditButton" runat="server" CommandName="Edit" Text="Edit" CssClass="action-button edit-button" />
                    <asp:Button ID="DeleteButton" runat="server" CommandName="Delete" Text="Delete" 
                        OnClientClick="return confirm('Are you sure you want to delete this product?');" 
                        CssClass="action-button delete-button" />
                </td>
            </tr>
        </AlternatingItemTemplate>
        <EditItemTemplate>
            <tr style="">
                <td>
                    <asp:Label ID="OrderSummaryIDLabel1" runat="server" Text='<%# Eval("OrderSummaryID") %>' />
                </td>
                <td>
                    <asp:TextBox ID="NguoiNhanHangTextBox" runat="server" Text='<%# Bind("NguoiNhanHang") %>' />
                </td>
                <td>
                    <asp:TextBox ID="AddressReceiverTextBox" runat="server" Text='<%# Bind("AddressReceiver") %>' />
                </td>
                <td>
                    <asp:TextBox ID="PhoneReceiverTextBox" runat="server" Text='<%# Bind("PhoneReceiver") %>' />
                </td>
                <td>
                    <asp:TextBox ID="ProductNameTextBox" runat="server" Text='<%# Bind("ProductName") %>' />
                </td>
                <td>
                    <asp:TextBox ID="QuantityTextBox" runat="server" Text='<%# Bind("Quantity") %>' />
                </td>
                <td>
                    <asp:TextBox ID="TotalPriceTextBox" runat="server" Text='<%# Bind("TotalPrice") %>' />
                </td>
                <td>
                    <asp:Button ID="Button1" runat="server" CommandName="Update" Text="Update" 
                        CssClass="action-button update-button" ValidationGroup="EditValidation" />
                    <asp:Button ID="Button2" runat="server" CommandName="Cancel" Text="Cancel" 
                        CssClass="action-button cancel-button" />
                </td>
            </tr>
        </EditItemTemplate>
        <EmptyDataTemplate>
            <table runat="server" style="">
                <tr>
                    <td>No data was returned.</td>
                </tr>
            </table>
        </EmptyDataTemplate>
        <ItemTemplate>
            <tr style="">
                <td>
                    <asp:Label ID="OrderSummaryIDLabel" runat="server" Text='<%# Eval("OrderSummaryID") %>' />
                </td>
                <td>
                    <asp:Label ID="NguoiNhanHangLabel" runat="server" Text='<%# Eval("NguoiNhanHang") %>' />
                </td>
                <td>
                    <asp:Label ID="AddressReceiverLabel" runat="server" Text='<%# Eval("AddressReceiver") %>' />
                </td>
                <td>
                    <asp:Label ID="PhoneReceiverLabel" runat="server" Text='<%# Eval("PhoneReceiver") %>' />
                </td>
                <td>
                    <asp:Label ID="ProductNameLabel" runat="server" Text='<%# Eval("ProductName") %>' />
                </td>
                <td>
                    <asp:Label ID="QuantityLabel" runat="server" Text='<%# Eval("Quantity") %>' />
                </td>
                <td>
                    <asp:Label ID="TotalPriceLabel" runat="server" Text='<%# Eval("TotalPrice") %>' />
                </td>
                <td>
                    <asp:Button ID="EditButton" runat="server" CommandName="Edit" Text="Edit" CssClass="action-button edit-button" />
                    <asp:Button ID="DeleteButton" runat="server" CommandName="Delete" Text="Delete" 
                        OnClientClick="return confirm('Are you sure you want to delete this product?');" 
                        CssClass="action-button delete-button" />
                </td>
            </tr>
        </ItemTemplate>
        <LayoutTemplate>
            <table runat="server">
                <tr runat="server">
                    <td runat="server">
                        <table id="itemPlaceholderContainer" runat="server" border="0" style="">
                            <tr runat="server" style="">
                                <th runat="server">OrderSummaryID</th>
                                <th runat="server">NguoiNhanHang</th>
                                <th runat="server">AddressReceiver</th>
                                <th runat="server">PhoneReceiver</th>
                                <th runat="server">ProductName</th>
                                <th runat="server">Quantity</th>
                                <th runat="server">TotalPrice</th>
                            </tr>
                            <tr id="itemPlaceholder" runat="server">
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr runat="server">
                    <td runat="server" style="">
                        <asp:DataPager ID="DataPager1" runat="server" PageSize="10">
                            <Fields>
                                <asp:NextPreviousPagerField ButtonType="Button" ShowFirstPageButton="True" ShowLastPageButton="True" />
                            </Fields>
                        </asp:DataPager>
                    </td>
                </tr>
            </table>
        </LayoutTemplate>
        
        <SelectedItemTemplate>
            <tr style="">
                <td>
                    <asp:Label ID="OrderSummaryIDLabel" runat="server" Text='<%# Eval("OrderSummaryID") %>' />
                </td>
                <td>
                    <asp:Label ID="NguoiNhanHangLabel" runat="server" Text='<%# Eval("NguoiNhanHang") %>' />
                </td>
                <td>
                    <asp:Label ID="AddressReceiverLabel" runat="server" Text='<%# Eval("AddressReceiver") %>' />
                </td>
                <td>
                    <asp:Label ID="PhoneReceiverLabel" runat="server" Text='<%# Eval("PhoneReceiver") %>' />
                </td>
                <td>
                    <asp:Label ID="ProductNameLabel" runat="server" Text='<%# Eval("ProductName") %>' />
                </td>
                <td>
                    <asp:Label ID="QuantityLabel" runat="server" Text='<%# Eval("Quantity") %>' />
                </td>
                <td>
                    <asp:Label ID="TotalPriceLabel" runat="server" Text='<%# Eval("TotalPrice") %>' />
                </td>
            </tr>
        </SelectedItemTemplate>
        
    </asp:ListView>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
    ConnectionString="<%$ ConnectionStrings:MyConnectionString %>"
    SelectCommand="SELECT * FROM [OrderSummary]"
    UpdateCommand="UPDATE [OrderSummary] SET [NguoiNhanHang] = @NguoiNhanHang, [AddressReceiver] = @AddressReceiver, [PhoneReceiver] = @PhoneReceiver, [ProductName] = @ProductName, [Quantity] = @Quantity WHERE [OrderSummaryID] = @OrderSummaryID"
    DeleteCommand="DELETE FROM [OrderSummary] WHERE [OrderSummaryID] = @OrderSummaryID">

    <UpdateParameters>
        <asp:Parameter Name="NguoiNhanHang" Type="String" />
        <asp:Parameter Name="AddressReceiver" Type="String" />
        <asp:Parameter Name="PhoneReceiver" Type="String" />
        <asp:Parameter Name="ProductName" Type="String" />
        <asp:Parameter Name="Quantity" Type="Int32" />
    </UpdateParameters>
    <DeleteParameters>
        <asp:Parameter Name="OrderSummaryID" Type="Int32" />
    </DeleteParameters>

</asp:SqlDataSource>

</div>
<div id="statusMessage" runat="server" class="status-message" visible="false">
    <asp:Label ID="lblStatus" runat="server"></asp:Label>
</div>

        
    </form>
</body>
</html>
