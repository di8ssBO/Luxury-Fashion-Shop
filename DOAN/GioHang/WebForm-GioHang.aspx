    <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm-GioHang.aspx.cs" Inherits="DOAN_TMDT.DOAN.GioHang.WebForm_GioHang" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="../css/CSS-GioHang.css" />
    
</head>
<body>
    <div style="background: url('../image/background_den7.png') no-repeat center center; background-size: cover; min-height: 100vh; /* đảm bảo bao phủ toàn trang */">
    <form id="form1" runat="server">
        <div class="navbar">
            <div class="menu-container">
                <!-- ASP.NET Menu Control -->
                <asp:Menu ID="NavigationMenu" runat="server"  StaticMenuStyle-CssClass="nav-menu" 
                    Orientation="Horizontal" StaticMenuItemStyle-CssClass="nav-item" 
                    StaticMenuItemStyle-ItemSpacing="30" StaticEnableDefaultPopOutImage="false" 
                    StaticItemSpacing="30" StaticMenuItemStyle-HorizontalPadding="20" 
                    StaticMenuItemStyle-VerticalPadding="20" Height="60px">
                    <Items>
                        <asp:MenuItem Text="Home" Value="Home" NavigateUrl="../Homepage/WebForm-Homepage.aspx"/>
                        <asp:MenuItem Text="Product" Value="Product" NavigateUrl="../ProductPage/ProductPage.aspx"/>
                        <asp:MenuItem Text="Luxury Fashion" Value="LuxuryFashion" NavigateUrl="../Firstpage/WebForm-FirstPage.aspx"/>
                    </Items>
                </asp:Menu>
                
                <!-- Settings Icon -->
                <asp:LinkButton ID="SettingsButton" runat="server" CssClass="settings-icon" >⚙️</asp:LinkButton>
                
            </div>
        </div>
        <div class="container">
            <h2 class="cart-title-container" style="text-align: center; color: white">Your shopping cart</h2>
            <asp:ListView ID="ListView1" runat="server" DataKeyNames="ProductID" OnItemCommand="ListView1_ItemCommand" >
                

                <EmptyDataTemplate>
                    <table runat="server" style="">
                        <tr>
                            <td>
                                <div style="text-align:center; padding:20px;">
                                    <p style="color: white;">There are no products in your shopping cart.</p>
                                </div>
                            </td>
                        </tr>
                    </table>
                </EmptyDataTemplate>
                <AlternatingItemTemplate>
                    <tr style="">
                        
                        <td>
                            <input type="checkbox" class="checkbox product-checkbox" />
                        </td>
                        
                        <td>
                            <div style="display:flex; align-items:center;">
                            <asp:ImageButton ID="ImagesLabel" runat="server" ImageUrl ='<%#"../image(Products)/" + Eval("Images") %>' CssClass="product-image" />
                                
                            </div>
                        </td>
                        <td>
                            <asp:Label ID="ProductNameLabel" runat="server" Text='<%# Eval("ProductName") %>' />
                        </td>
                        
                        <td>
                            <asp:Label ID="PriceLabel" runat="server" Text='<%#"$" + Eval("Price", "{0:N2}") %>' />
                        </td>
                        <td>
                            <div class="quantity-control">
                                <button type="button" class="quantity-btn" onclick="decreaseQuantity(this)">−</button>
                                <input type="text" class="quantity-input" value="1" min="1" data-price='<%# Eval("Price") %>' onchange="validateAndUpdateTotal(this)" onkeyup="validateAndUpdateTotal(this)" onkeydown="preventFormSubmit(event)"/>
                                <button type="button" class="quantity-btn" onclick="increaseQuantity(this)">+</button>
                            </div>
                        </td>
                        <td>
                            <span class="total-price">
                              $<%# (Convert.ToDecimal(Eval("Price")) * Convert.ToInt32(Eval("Quantity"))).ToString("N2") %>
                            </span>
                        
                        <td>
                            <asp:LinkButton ID="Delete" runat="server" type="button" class="action-btn" 
                                             CommandName="DeleteItem" CommandArgument='<%# Eval("ProductID") %>'>Delete</asp:LinkButton> <br />
                        </td>
                        <td>
                            <asp:Label ID="ProductIDLabel" Visible="false" runat="server" Text='<%# Eval("ProductID") %>' />
                        </td>
                    </tr>
                </AlternatingItemTemplate>
                <ItemTemplate>
                    <tr style="">
                        <td>
                            <input type="checkbox" class="checkbox product-checkbox" />
                        </td>
                        <td>
                            <div style="display:flex; align-items:center;">
                            <asp:ImageButton ID="ImagesLabel" runat="server" ImageUrl ='<%#"../image(Products)/" + Eval("Images") %>' CssClass="product-image" />
                                
                            </div>
                        </td>
                        <td>
                            <asp:Label ID="ProductNameLabel" runat="server" Text='<%# Eval("ProductName") %>' />
                        </td>
                        <td>
                            <asp:Label ID="PriceLabel" runat="server" Text='<%#"$" + Eval("Price", "{0:N2}") %>' />
                        </td>
                        <td>
                            <div class="quantity-control">
                              <button type="button" class="quantity-btn" onclick="decreaseQuantity(this)">−</button>

                              <!-- bind Quantity từ DataTable vào giá trị của textbox -->
                              <asp:TextBox ID="QuantityTextBox" runat="server"
                                           CssClass="quantity-input"
                                           Text='<%# Eval("Quantity") %>'
                                           AutoPostBack="false"
                                           onkeydown="preventFormSubmit(event)" />

                              <button type="button" class="quantity-btn" onclick="increaseQuantity(this)">+</button>
                            </div>

                        </td>
                        <td>
                            <span class="total-price"><%# "$" + Convert.ToDecimal(Eval("Price")).ToString("N2") %></span>
                        </td>
                        <td>
                            <asp:LinkButton ID="Delete" runat="server" type="button" class="action-btn" 
                                             CommandName="DeleteItem" CommandArgument='<%# Eval("ProductID") %>'>Delete</asp:LinkButton> <br />
                        </td>
                        <td>
                            <asp:Label ID="ProductIDLabel" Visible="false" runat="server" Text='<%# Eval("ProductID") %>' />
                        </td>
                    </tr>
                </ItemTemplate>
                <LayoutTemplate>
                    <table runat="server">
                        <tr runat="server">
                            <td runat="server">
                                <table class="product-grid" id="itemPlaceholderContainer" runat="server"  border="0" style="">
                                    <tr runat="server" style="">
                                        <th><input type="checkbox" id="selectAll" onclick="toggleAllCheckboxes()" /></th>
                                        <th runat="server">Image</th>
                                        <th runat="server">Product</th>
                                        <th runat="server">Price</th>
                                        <th runat="server">Quantity</th>
                                        <th runat="server">Total-Price</th>
                                        <th runat="server">Cancel</th>
                                    </tr>
                                    <tr id="itemPlaceholder" runat="server">
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr runat="server">
                            <td runat="server" style=""></td>
                        </tr>
                    </table>
                </LayoutTemplate>
            </asp:ListView>
            
            <asp:Label ID="DebugLabel" runat="server" ForeColor="Red" />
            <asp:Label ID="Label1" runat="server" ForeColor="Gray" />

            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MyConnectionString %>" SelectCommand="SELECT [VariantID], [ProductID], [VariantName], [Images], [Price] FROM [ProductVariants]"></asp:SqlDataSource> 

            <!-- Cart Summary -->
            <div class="cart-summary">
                <div class="cart-total">
                    <span class="cart-total-label">Total Payment:</span>
                    <span id="cartTotalValue" class="cart-total-value">$0</span>
                </div>
                <asp:Button ID="btnPurchase" runat="server" CssClass="checkout-btn" Text="Purchase" OnClick="btnPurchase_Click" />
            </div>
        </div>
        <script type="text/javascript" src="../js/GioHang.js"> </script>
    </form>
    </div>
</body>
</html>
