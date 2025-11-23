<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductDetail.aspx.cs" Inherits="DOAN_TMDT.DOAN.ProductDetail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Product Detail</title>
    <link rel="stylesheet" href="css/ProductDetail.css" />
    <script src="js/Quantity.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="detail-container">
            <asp:Image ID="imgProduct" runat="server" CssClass="product-image" />
            <div class="product-info">
                <h1><asp:Label ID="lblName" runat="server" /></h1>
                <p><asp:Literal ID="litDescription" runat="server" /></p>
                <div class="size-options">
                    Size:
                    <asp:Repeater ID="rptSizes" runat="server">
                        <ItemTemplate>
                            <button type="button" class="size-btn"><%# Eval("Size") %></button>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <div class="quantity-control">
                    Quantity:
                    <button type="button" id="btnMinus">-</button>
                    <input type="text" id="txtQty" value="1" readonly />
                    <button type="button" id="btnPlus">+</button>
                </div>
                <div class="price">
                    Total Price: <asp:Label ID="lblPrice" runat="server" />
                </div>
                <asp:Button ID="btnAddToCart" runat="server" Text="Add to Cart" CssClass="add-to-cart" />
            </div>
        </div>
    </form>
</body>
</html>
