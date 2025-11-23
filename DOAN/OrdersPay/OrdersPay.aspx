<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrdersPay.aspx.cs" Inherits="DOAN_TMDT.DOAN.OrdersPay.OrdersPay" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="../css/OrdersPay.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="checkout-form">
                <h1>Luxury Fashion</h1>
                <div class="delivery-section">
                    <h2>Delivery</h2>
                    <div class="inline-inputs">
                        <div class="input-group">
                            <asp:TextBox ID="txtNguoiNhanHang" runat="server" placeholder="Người nhận hàng" CssClass="form-control" />
                        </div>
                    </div>
                    <div class="input-group">
                            <asp:TextBox ID="txtAddressReceiver" runat="server" placeholder="Address" CssClass="form-control" />
                    </div>
                    <div class="input-group">
                            <asp:TextBox ID="txtPhoneReceiver" runat="server" placeholder="Phone" CssClass="form-control" />
                    </div>
                </div>
                
                <div class="payment-section">
                    <h2>Payment</h2>
                    <div class="payment-options">
                        <div class="payment-option"><label>Cash on Delivery (COD)</label></div>
                        <div class="payment-option"><label>Freeship</label></div>
                    </div>
                </div>
          


                <asp:Button ID="Submit1" runat="server" Text="Complete order" CssClass="button-complete" OnClick="Submit1_Click" />
            </div>
            
            <div class="order-summary">
                <div class="order-item">
                    <asp:ListView ID="ListView1" runat="server" DataKeyNames="OrderDetailID">
                        <LayoutTemplate>
                            <table runat="server" class="order-table">
                                <tr runat="server">
                                    <td runat="server">
                                        <table id="itemPlaceholderContainer" runat="server" border="0" class="product-list">
                                            <tr runat="server" class="order-header">
                                                <th runat="server">Image</th>
                                                <th runat="server">ProductName</th>
                                                <th runat="server">quantity</th>
                                                <th runat="server">TotalPrice</th>
                                            </tr>
                                            <tr runat="server" id="itemPlaceholder">
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </LayoutTemplate>
                        <ItemTemplate>
                            <tr class="order-item">
                                <td>
                                    <div class="product-image-container">
                                        <asp:Image ID="ImagesLabel" runat="server" ImageUrl='<%# "../image(Products)/" + Eval("Images") %>' CssClass="product-image" />
                                    </div>
                                </td>
                                <td>
                                    <asp:Label ID="ProductNameLabel" runat="server" Text='<%# Eval("ProductName") %>' CssClass="product-name" />
                                </td>
                                <td>
                                    <asp:Label ID="QuantityLabel" runat="server" Text='<%# Eval("Quantity") %>' CssClass="quantity-value" />
                                </td>
                                <td>
                                    <asp:Label ID="UnitPriceLabel" runat="server" Text='<%# String.Format("${0:N2}", Eval("UnitPrice")) %>' CssClass="price-value" />
                                </td>
                                <td style="display: none;">
                                    <asp:Label ID="OrderDetailIDLabel" runat="server" Text='<%# Eval("OrderDetailID") %>' Visible="false" />
                                </td>
                                <td style="display: none;">
                                    <asp:Label ID="ProductIDLabel" runat="server" Text='<%# Eval("ProductID") %>' Visible="false" />
                                </td>
                            </tr>
                        </ItemTemplate>
                        <AlternatingItemTemplate>
                            <tr class="order-item alternate">
                                <td>
                                    <div class="product-image-container">
                                        <asp:Image ID="ImagesLabel" runat="server" ImageUrl='<%# "../image(Products)/" + Eval("Images") %>' CssClass="product-image" />
                                    </div>
                                </td>
                                <td>
                                    <asp:Label ID="ProductNameLabel" runat="server" Text='<%# Eval("ProductName") %>' CssClass="product-name" />
                                </td>
                                <td>
                                    <asp:Label ID="QuantityLabel" runat="server" Text='<%# Eval("Quantity") %>' CssClass="quantity-value" />
                                </td>
                                <td>
                                    <asp:Label ID="UnitPriceLabel" runat="server" Text='<%# String.Format("${0:N2}", Eval("UnitPrice")) %>' CssClass="price-value" />
                                </td>
                                <td style="display: none;">
                                    <asp:Label ID="OrderDetailIDLabel" runat="server" Text='<%# Eval("OrderDetailID") %>' Visible="false" />
                                </td>
                                <td style="display: none;">
                                    <asp:Label ID="ProductIDLabel" runat="server" Text='<%# Eval("ProductID") %>' Visible="false" />
                                </td>
                            </tr>
                        </AlternatingItemTemplate>
                        <EmptyDataTemplate>
                            <div class="empty-cart">
                                <p>Your shopping cart is empty.</p>
                                <a href="../GioHang/WebForm-GioHang.aspx">Return to Cart</a>
                            </div>
                        </EmptyDataTemplate>
                    </asp:ListView>
                </div>
                
                <div class="total-row">
                    <div class="total-label">Total</div>
                    <div class="total-value">
                        <asp:Label ID="totalAmount" runat="server" CssClass="total-amount"></asp:Label>
                    </div>
                </div>
            </div>
            
        </div>
        <script type="text/javascript" src="../js/OrdersPay.js"> </script>
    </form>
</body>
</html>
