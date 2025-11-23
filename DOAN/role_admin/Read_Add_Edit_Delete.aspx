<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Read_Add_Edit_Delete.aspx.cs" Inherits="DOAN_TMDT.DOAN.Role_Admin.Read_Add_Edit_Delete" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="../css/Read_Add_Edit_Delete.css" />
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
            <div style="display: inline-block; width: 80%; max-width: 800px;">
                <asp:DropDownList ID="ddlIDType" runat="server" CssClass="search-dropdown" style="padding: 8px; margin-right: 5px;">
                    <asp:ListItem Text="Product ID" Value="ProductID" />
                    <asp:ListItem Text="Category ID" Value="CategoryID" />
                    <asp:ListItem Text="Brand ID" Value="BrandID" />
                </asp:DropDownList>
                <asp:TextBox ID="txtSearch" runat="server" placeholder="Enter the ID you want to find..." style="padding: 8px; width: 50%; margin-right: 5px;" />
                <asp:Button ID="btnSearch" runat="server" Text="Search" style="padding: 8px 15px; cursor: pointer;" OnClick="btnSearch_Click"/>
            </div>
                        <!-- Menu với CSS tùy chỉnh -->
            <asp:Menu ID="MainMenu" runat="server" Orientation="Horizontal" 
          StaticMenuStyle-CssClass="menu-style"
          StaticMenuItemStyle-CssClass="menu-item"
          DynamicMenuStyle-CssClass="dropdown-menu">
            <Items>
               <asp:MenuItem Text="Order details" Value="Order details" NavigateUrl="../orderscustomer/OrdersCustomer.aspx" />
             </Items>
                </asp:Menu>
        </div>

        <div>
            <asp:ListView ID="ListView1" runat="server" DataKeyNames="ProductID" DataSourceID="SqlDataSource1" 
                InsertItemPosition="FirstItem" OnItemInserting="ListView1_ItemInserting" OnItemUpdating="ListView1_ItemUpdating" > 
                
                <AlternatingItemTemplate>
                    <tr style="">
                        <td>
                            <asp:image ID="ImagesLabel" runat="server" ImageUrl ='<%#"../image(Products)/" + Eval("Images") %>' CssClass="product-image" />
                        </td>
                        <td>
                            <asp:Label ID="ProductIDLabel" runat="server" Text='<%# Eval("ProductID") %>' />
                        </td>
                        <td>
                            <asp:Label ID="CategoryIDLabel" runat="server" Text='<%# Eval("CategoryID") %>' />
                        </td>
                        <td>
                            <asp:Label ID="BrandIDLabel" runat="server" Text='<%# Eval("BrandID") %>' />
                        </td>
                        <td>
                            <asp:Label ID="ProductNameLabel" runat="server" Text='<%# Eval("ProductName") %>' />
                        </td>
                        <td>
                            <asp:Label ID="DescriptionsLabel" runat="server" Text='<%# Eval("Descriptions") %>' />
                        </td>
                        <td>
                            <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price") %>' />
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
                            <asp:TextBox ID="ImageURLTextBoxEdit" runat="server" Text='<%# Bind("Images") %>' placeholder="Enter image URL" />
                            <div class="current-image-info">Current: <asp:Label ID="CurrentImageLabel" runat="server" Text='<%# Eval("Images") %>' /></div>
                        </td>
                        <td>
                            <asp:Label ID="ProductIDLabel1" runat="server" Text='<%# Eval("ProductID") %>' />
                        </td>
                        <td>
                            <asp:TextBox ID="CategoryIDTextBox" runat="server" Text='<%# Bind("CategoryID") %>' />
                            <asp:RequiredFieldValidator ID="rfvCategoryIDEdit" runat="server" 
                                ControlToValidate="CategoryIDTextBox" Display="Dynamic" 
                                ErrorMessage="*" ForeColor="Red" ValidationGroup="EditValidation" />
                        </td>
                        <td>
                            <asp:TextBox ID="BrandIDTextBox" runat="server" Text='<%# Bind("BrandID") %>' />
                            <asp:RequiredFieldValidator ID="rfvBrandIDEdit" runat="server" 
                                ControlToValidate="BrandIDTextBox" Display="Dynamic" 
                                ErrorMessage="*" ForeColor="Red" ValidationGroup="EditValidation" />
                        </td>
                        <td>
                            <asp:TextBox ID="ProductNameTextBox" runat="server" Text='<%# Bind("ProductName") %>' />
                            <asp:RequiredFieldValidator ID="rfvProductNameEdit" runat="server" 
                                ControlToValidate="ProductNameTextBox" Display="Dynamic" 
                                ErrorMessage="*" ForeColor="Red" ValidationGroup="EditValidation" />
                        </td>
                        <td>
                            <asp:TextBox ID="DescriptionsTextBox" runat="server" Text='<%# Bind("Descriptions") %>' TextMode="MultiLine" Rows="3" />
                        </td>
                        <td>
                            <asp:TextBox ID="PriceTextBox" runat="server" Text='<%# Bind("Price") %>' />
                            <asp:RequiredFieldValidator ID="rfvPriceEdit" runat="server" 
                                ControlToValidate="PriceTextBox" Display="Dynamic" 
                                ErrorMessage="*" ForeColor="Red" ValidationGroup="EditValidation" />
                            <asp:RegularExpressionValidator ID="revPriceEdit" runat="server" 
                                ControlToValidate="PriceTextBox" Display="Dynamic" 
                                ErrorMessage="Invalid price" ForeColor="Red" ValidationGroup="EditValidation" 
                                ValidationExpression="^\d+(\.\d{1,2})?$" />
                        </td>
                        <td>
                            <asp:Button ID="UpdateButton" runat="server" CommandName="Update" Text="Update" 
                                CssClass="action-button update-button" ValidationGroup="EditValidation" />
                            <asp:Button ID="CancelButton" runat="server" CommandName="Cancel" Text="Cancel" 
                                CssClass="action-button cancel-button" />
                        </td>
                    </tr>
                </EditItemTemplate>
                <EmptyDataTemplate>
                    <table runat="server" style="">
                        <tr>
                            <td>There are no products in this search.</td>
                        </tr>
                    </table>
                </EmptyDataTemplate>
                <InsertItemTemplate>
                    <tr style="background-color: #f1f1f1;">
                        <td>
                            <asp:TextBox ID="ImageURLTextBoxInsert" runat="server" Text='<%# Bind("Images") %>' placeholder="Enter image URL" />
                            <asp:RequiredFieldValidator ID="rfvImageURL" runat="server" 
                                ControlToValidate="ImageURLTextBoxInsert" Display="Dynamic" 
                                ErrorMessage="*" ForeColor="Red" ValidationGroup="InsertValidation" />
                        </td>
                        <td>
                            <asp:Label runat="server" Text="Auto" />
                        </td>
                        <td>
                            <asp:TextBox ID="CategoryIDTextBox" runat="server" Text='<%# Bind("CategoryID") %>' placeholder="Category ID" />
                            <asp:RequiredFieldValidator ID="rfvCategoryID" runat="server" 
                                ControlToValidate="CategoryIDTextBox" Display="Dynamic" 
                                ErrorMessage="*" ForeColor="Red" ValidationGroup="InsertValidation" />
                            <asp:RegularExpressionValidator ID="revCategoryID" runat="server" 
                                ControlToValidate="CategoryIDTextBox" Display="Dynamic" 
                                ErrorMessage="Numbers only" ForeColor="Red" ValidationGroup="InsertValidation" 
                                ValidationExpression="^\d+$" />
                        </td>
                        <td>
                            <asp:TextBox ID="BrandIDTextBox" runat="server" Text='<%# Bind("BrandID") %>' placeholder="Brand ID" />
                            <asp:RequiredFieldValidator ID="rfvBrandID" runat="server" 
                                ControlToValidate="BrandIDTextBox" Display="Dynamic" 
                                ErrorMessage="*" ForeColor="Red" ValidationGroup="InsertValidation" />
                            <asp:RegularExpressionValidator ID="revBrandID" runat="server" 
                                ControlToValidate="BrandIDTextBox" Display="Dynamic" 
                                ErrorMessage="Numbers only" ForeColor="Red" ValidationGroup="InsertValidation" 
                                ValidationExpression="^\d+$" />
                        </td>
                        <td>
                            <asp:TextBox ID="ProductNameTextBox" runat="server" Text='<%# Bind("ProductName") %>' placeholder="Product Name" />
                            <asp:RequiredFieldValidator ID="rfvProductName" runat="server" 
                                ControlToValidate="ProductNameTextBox" Display="Dynamic" 
                                ErrorMessage="*" ForeColor="Red" ValidationGroup="InsertValidation" />
                        </td>
                        <td>
                            <asp:TextBox ID="DescriptionsTextBox" runat="server" Text='<%# Bind("Descriptions") %>' TextMode="MultiLine" Rows="3" placeholder="Description" />
                        </td>
                        <td>
                            <asp:TextBox ID="PriceTextBox" runat="server" Text='<%# Bind("Price") %>' placeholder="Price" />
                            <asp:RequiredFieldValidator ID="rfvPrice" runat="server" 
                                ControlToValidate="PriceTextBox" Display="Dynamic" 
                                ErrorMessage="*" ForeColor="Red" ValidationGroup="InsertValidation" />
                            <asp:RegularExpressionValidator ID="revPrice" runat="server" 
                                ControlToValidate="PriceTextBox" Display="Dynamic" 
                                ErrorMessage="Enter valid price" ForeColor="Red" ValidationGroup="InsertValidation" 
                                ValidationExpression="^\d+(\.\d{1,2})?$" />
                        </td>
                        <td>
                            <asp:Button ID="InsertButton" runat="server" CommandName="Insert" Text="Insert" 
                                CssClass="action-button insert-button" ValidationGroup="InsertValidation" />
                            <asp:Button ID="CancelButton" runat="server" CommandName="Cancel" Text="Clear" 
                                CssClass="action-button cancel-button" />
                        </td>
                    </tr>
                </InsertItemTemplate>
                <ItemTemplate>
                    <tr style="">
                        <td>
                            <asp:image ID="Image1" runat="server" ImageUrl ='<%#"../image(Products)/" + Eval("Images") %>' CssClass="product-image" />
                        </td>
                        <td>
                            <asp:Label ID="ProductIDLabel" runat="server" Text='<%# Eval("ProductID") %>' />
                        </td>
                        <td>
                            <asp:Label ID="CategoryIDLabel" runat="server" Text='<%# Eval("CategoryID") %>' />
                        </td>
                        <td>
                            <asp:Label ID="BrandIDLabel" runat="server" Text='<%# Eval("BrandID") %>' />
                        </td>
                        <td>
                            <asp:Label ID="ProductNameLabel" runat="server" Text='<%# Eval("ProductName") %>' />
                        </td>
                        <td>
                            <asp:Label ID="DescriptionsLabel" runat="server" Text='<%# Eval("Descriptions") %>' />
                        </td>
                        <td>
                            <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price") %>' />
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
                                        <th runat="server">Images</th>
                                        <th runat="server">ProductID</th>
                                        <th runat="server">CategoryID</th>
                                        <th runat="server">BrandID</th>
                                        <th runat="server">ProductName</th>
                                        <th runat="server">Descriptions</th>
                                        <th runat="server">Price</th>
                                        <th runat="server">Actions</th>
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
                
            </asp:ListView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:MyConnectionString %>" 
                SelectCommand="SELECT * FROM [Products] ORDER BY [ProductID] DESC"
                InsertCommand="INSERT INTO [Products] ([CategoryID], [BrandID], [ProductName], [Descriptions], [Price], [Images]) VALUES (@CategoryID, @BrandID, @ProductName, @Descriptions, @Price, @Images)"
                UpdateCommand="UPDATE [Products] SET [CategoryID] = @CategoryID, [BrandID] = @BrandID, [ProductName] = @ProductName, [Descriptions] = @Descriptions, [Price] = @Price, [Images] = @Images WHERE [ProductID] = @ProductID"
                DeleteCommand="DELETE FROM [Products] WHERE [ProductID] = @ProductID">
                <InsertParameters>
                    <asp:Parameter Name="CategoryID" Type="Int32" />
                    <asp:Parameter Name="BrandID" Type="Int32" />
                    <asp:Parameter Name="ProductName" Type="String" />
                    <asp:Parameter Name="Descriptions" Type="String" />
                    <asp:Parameter Name="Price" Type="Decimal" />
                    <asp:Parameter Name="Images" Type="String" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="CategoryID" Type="Int32" />
                    <asp:Parameter Name="BrandID" Type="Int32" />
                    <asp:Parameter Name="ProductName" Type="String" />
                    <asp:Parameter Name="Descriptions" Type="String" />
                    <asp:Parameter Name="Price" Type="Decimal" />
                    <asp:Parameter Name="Images" Type="String" />
                    <asp:Parameter Name="ProductID" Type="Int32" />
                </UpdateParameters>
                <DeleteParameters>
                    <asp:Parameter Name="ProductID" Type="Int32" />
                </DeleteParameters>
            </asp:SqlDataSource>
        </div>
        <div id="statusMessage" runat="server" class="status-message" visible="false">
            <asp:Label ID="lblStatus" runat="server"></asp:Label>
        </div>

        
    </form>
</body>
</html>
