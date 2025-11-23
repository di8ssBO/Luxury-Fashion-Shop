<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductPage.aspx.cs" Inherits="DOAN_TMDT.DOAN.ProductPage.ProductPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Products</title>
    <link rel="stylesheet" href="../css/ProductStyles.css" />
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
        <style>
    .welcome-label, .username-label {
        font-family: "Playwrite DK Loopet", cursive;
        font-size: 20px;
        font-weight: 400;
        font-style: normal;
        display: inline-block;
        margin: 0;
        vertical-align: middle; /* Căn giữa theo chiều dọc */
    }
    .search-container {
        position: relative;
        display: flex;
        align-items: center; /* Căn giữa tất cả các phần tử */
        gap: 0;
    }
    .settings-icon {
        background: none;
        border: none;
        font-size: 20px;
        cursor: pointer;
        padding: 5px;
        margin-left: 5px;
        vertical-align: middle; /* Căn giữa với văn bản */
        line-height: 20px; /* Đồng bộ với font-size của văn bản */
    }
    .login-button {
        background-color: #007bff;
        color: white;
        border: none;
        padding: 8px 12px;
        border-radius: 3px;
        cursor: pointer;
        vertical-align: middle; /* Căn giữa khi hiển thị nút Login */
    }
    .login-button:hover {
        background-color: #0056b3;
    }
    .account-info-panel {
        display: none;
        position: absolute;
        top: 40px;
        right: 0;
        background-color: #fff;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        padding: 15px;
        z-index: 1000;
        min-width: 200px;
    }
    .account-info-panel p {
        margin: 5px 0;
        font-size: 14px;
        color: #000 !important;
    }
    .logout-button {
        background-color: #dc3545;
        color: white;
        border: none;
        padding: 8px 12px;
        border-radius: 3px;
        cursor: pointer;
        width: 100%;
        margin-top: 10px;
    }
    .logout-button:hover {
        background-color: #c82333;
    }
</style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <div class="nav-menu">
                <div class="menu-items">
                    <a href="../Homepage/WebForm-Homepage.aspx">Home</a>
                    <a href="../ProductPage/ProductPage.aspx">Product</a>
                
                </div>
                <div class="right-icons">
                    <a href="#"><i class="fas fa-cog"></i></a>
                    <a href="#"><i class="fas fa-search"></i></a>
                    <a href="#"><i class="fas fa-shopping-cart"></i></a>
                    <!-- Shopping cart icon with count -->
                    <a href="../GioHang/Webform-GioHang.aspx" class="cart-container">
                        <i class="fas fa-shopping-cart cart-icon"></i>
                        <span class="cart-icon" runat="server">🛒</span>
                        <span class="cart-count" id="cartCount" runat="server">0</span>
                    </a>
                    </div>
                     <div class="search-container">
     <asp:Panel ID="pnlWelcome" runat="server" Visible="false">
         <asp:Label ID="lblWelcome" runat="server" CssClass="welcome-label" Text="Welcome, " />
         <asp:Label ID="lblUsernameSearch" runat="server" CssClass="username-label"></asp:Label>
         <button type="button" id="settingsButton" class="settings-icon" onclick="toggleAccountInfo()">⚙️</button>
     </asp:Panel>
     <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="login-button" OnClick="btnLogin_Click" Visible="true" />
     <asp:Panel ID="pnlAccountInfo" runat="server" CssClass="account-info-panel">
         <p><strong>Username:</strong> <asp:Label ID="Label1" runat="server" /></p>
         <p><strong>Email:</strong> <asp:Label ID="lblEmail" runat="server" /></p>
         <p><strong>Phone:</strong> <asp:Label ID="lblPhone" runat="server" /></p>
         <asp:Button ID="btnLogout" runat="server" Text="Đăng xuất" OnClick="btnLogout_Click" CssClass="logout-button" />
     </asp:Panel>
                </div>
            </div>
        </div>
        
        <div class="main-container">
            <div class="banner">
                <h1>LUXURY FASHION AT YOUR FINGERTIPS</h1>
                <p>Discover exclusive collections from the world's leading luxury brands. Premium quality, iconic designs, and unparalleled craftsmanship - elevate your style with our curated selection of fashion statements.</p>
            </div>
            
            <div class="product-container">
                <div class="sidebar">
                    <div class="category-title">Categories</div>
                    
                    <!-- All Products Checkbox -->
                    <div class="category-item">
                        <label class="filter-label">
                            <asp:CheckBox ID="chkAllProducts" runat="server" CssClass="filter-checkbox" 
                                AutoPostBack="true" OnCheckedChanged="CategoryCheckbox_CheckedChanged" />
                            <span class="checkbox-text">All Products</span>
                        </label>
                    </div>
                    
                    <!-- Ready to Wear Checkbox -->
                    <div class="category-item">
                        <label class="filter-label">
                            <asp:CheckBox ID="chkClothing" runat="server" CssClass="filter-checkbox" 
                                AutoPostBack="true" OnCheckedChanged="CategoryCheckbox_CheckedChanged" />
                            <span class="checkbox-text">Ready to Wear</span>
                        </label>
                    </div>
                    
                    <!-- Sneakers Checkbox -->
                    <div class="category-item">
                        <label class="filter-label">
                            <asp:CheckBox ID="chkSneakers" runat="server" CssClass="filter-checkbox" 
                                AutoPostBack="true" OnCheckedChanged="CategoryCheckbox_CheckedChanged" />
                            <span class="checkbox-text">Sneakers</span>
                        </label>
                    </div>
                    
                    <!-- Handbags Checkbox -->
                    <div class="category-item">
                        <label class="filter-label">
                            <asp:CheckBox ID="chkHandbags" runat="server" CssClass="filter-checkbox" 
                                AutoPostBack="true" OnCheckedChanged="CategoryCheckbox_CheckedChanged" />
                            <span class="checkbox-text">Handbags</span>
                        </label>
                    </div>
                    
                    <!-- Glasses Checkbox -->
                    <div class="category-item">
                        <label class="filter-label">
                            <asp:CheckBox ID="chkGlasses" runat="server" CssClass="filter-checkbox" 
                                AutoPostBack="true" OnCheckedChanged="CategoryCheckbox_CheckedChanged" />
                            <span class="checkbox-text">Glasses</span>
                        </label>
                    </div>
                    
                    <!-- Belts Checkbox -->
                    <div class="category-item">
                        <label class="filter-label">
                            <asp:CheckBox ID="chkBelts" runat="server" CssClass="filter-checkbox" 
                                AutoPostBack="true" OnCheckedChanged="CategoryCheckbox_CheckedChanged" />
                            <span class="checkbox-text">Belts</span>
                        </label>
                    </div>
                    
                    <!-- Brands Section -->
                    <div class="brand-filter">
                        <div class="brand-title">Brands</div>
                        
                        <!-- Louis Vuitton Checkbox -->
                        <div class="category-item">
                            <label class="filter-label">
                                <asp:CheckBox ID="chkLouisVuitton" runat="server" CssClass="filter-checkbox" 
                                    AutoPostBack="true" OnCheckedChanged="BrandCheckbox_CheckedChanged" />
                                <span class="checkbox-text">Louis Vuitton</span>
                            </label>
                        </div>
                        
                        <!-- Gucci Checkbox -->
                        <div class="category-item">
                            <label class="filter-label">
                                <asp:CheckBox ID="chkGucci" runat="server" CssClass="filter-checkbox" 
                                    AutoPostBack="true" OnCheckedChanged="BrandCheckbox_CheckedChanged" />
                                <span class="checkbox-text">Gucci</span>
                            </label>
                        </div>
                        
                        <!-- Dior Checkbox -->
                        <div class="category-item">
                            <label class="filter-label">
                                <asp:CheckBox ID="chkDior" runat="server" CssClass="filter-checkbox" 
                                    AutoPostBack="true" OnCheckedChanged="BrandCheckbox_CheckedChanged" />
                                <span class="checkbox-text">Dior</span>
                            </label>
                        </div>
                        
                        <!-- Balenciaga Checkbox -->
                        <div class="category-item">
                            <label class="filter-label">
                                <asp:CheckBox ID="chkBalenciaga" runat="server" CssClass="filter-checkbox" 
                                    AutoPostBack="true" OnCheckedChanged="BrandCheckbox_CheckedChanged" />
                                <span class="checkbox-text">Balenciaga</span>
                            </label>
                        </div>
                        
                        <!-- Hermes Checkbox -->
                        <div class="category-item">
                            <label class="filter-label">
                                <asp:CheckBox ID="chkHermes" runat="server" CssClass="filter-checkbox" 
                                    AutoPostBack="true" OnCheckedChanged="BrandCheckbox_CheckedChanged" />
                                <span class="checkbox-text">Hermes</span>
                            </label>
                        </div>
                    </div>
                    
                    <!-- Reset Filters Button -->
                    <asp:LinkButton ID="lnkResetFilters" runat="server" Text="Reset All Filters" 
                        OnClick="ResetFilters_Click" CssClass="reset-filters-btn" />
                </div>
                
                <div style="flex: 1;">
                    <asp:SqlDataSource ID="SqlDataSource" runat="server"
                        ConnectionString="<%$ ConnectionStrings:MyConnectionString %>"
                        SelectCommand="SELECT [ProductID], [ProductName], [Price], [Images] FROM [Products]">
                    </asp:SqlDataSource>
                    
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <h2 style="margin: 0;">Featured Products</h2>
                        <asp:DropDownList ID="SortDropDown" runat="server" AutoPostBack="true" 
                            OnSelectedIndexChanged="SortDropDown_SelectedIndexChanged">
                            <asp:ListItem Text="Sort By" Value=""></asp:ListItem>
                            <asp:ListItem Text="Price: Low to High" Value="PriceAsc"></asp:ListItem>
                            <asp:ListItem Text="Price: High to Low" Value="PriceDesc"></asp:ListItem>
                            <asp:ListItem Text="Name: A to Z" Value="NameAsc"></asp:ListItem>
                            <asp:ListItem Text="Name: Z to A" Value="NameDesc"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- Active Filters Display -->
                    <div class="filter-display">
                        <asp:Label ID="lblActiveFilters" runat="server" Text="Active Filters:" Visible="false" />
                        <asp:Panel ID="pnlFilterBadges" runat="server">
                            <!-- Filter badges will be added here programmatically -->
                        </asp:Panel>
                        <asp:Label ID="lblCurrentFilter" runat="server" Text="All Products - All Brands" />
                        <asp:LinkButton ID="lnkClearFilters" runat="server" Text="Clear All Filters" 
                            OnClick="ResetFilters_Click" Visible="false" CssClass="filter-reset" />
                    </div>

                    <!-- Hidden Fields to store filter states -->
                    <asp:HiddenField ID="hdnShowAll" runat="server" Value="false" />
                    <asp:HiddenField ID="hdnSelectedCategories" runat="server" Value="" />
                    <asp:HiddenField ID="hdnSelectedBrands" runat="server" Value="" />
                    
                    <!-- Products ListView -->
                    <asp:ListView ID="ListView1" runat="server" DataSourceID="SqlDataSource">
                        <LayoutTemplate>
                            <div class="product-grid">
                                <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                            </div>
                        </LayoutTemplate>
                        <EmptyDataTemplate>
                            <div style="text-align: center; padding: 40px;">
                                <h3>No products found matching your criteria.</h3>
                                <p>Try adjusting your filters or search terms.</p>
                            </div>
                        </EmptyDataTemplate>
                        <ItemTemplate>
                            <div class="product-card">
                                <asp:Image 
                                    ID="imgProduct" 
                                    runat="server"
                                    ImageUrl='<%# ("../image(Products)/") + Eval("Images") %>'
                                    AlternateText='<%# Eval("ProductName") %>' 
                                    CssClass="product-image" />
                                <h3><%# Eval("ProductName") %></h3>
                                <span><%# String.Format("{0:C}", Eval("Price")) %></span>
                                <div style="padding: 0 15px 15px;">
                                    <asp:Button ID="btnAddToCart" runat="server" Text="Add to Cart" CssClass="add-to-cart-btn" 
                                        CommandName="AddToCart" 
                                        CommandArgument='<%# Eval("ProductID") %>' 
                                        OnCommand="AddToCart_Command" />
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:ListView>                 
                </div>
            </div>
            
            <div class="view-all">
                <asp:Button ID="btnViewAll" runat="server" Text="View All" CssClass="view-all-btn" OnClick="btnViewAll_Click" />
            </div>
        </div>

        <!-- Di chuyển ScriptManager lên đầu form -->
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <!-- Thêm div notification ở đầu form -->
        <div id="notification" class="notification-popup" style="display:none;"></div>
        
        <!-- UpdatePanel for cart count -->
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hdnCartCount" runat="server" Value="0" />
            </ContentTemplate>
        </asp:UpdatePanel>

    </form>
    <script src="../js/ProductPage.js"></script>
     <script>
     function toggleAccountInfo() {
         var panel = document.getElementById('<%= pnlAccountInfo.ClientID %>');
     panel.style.display = panel.style.display === 'block' ? 'none' : 'block';
 }

 // Ẩn panel khi nhấp ra ngoài
 document.addEventListener('click', function (e) {
     const settingsButton = document.getElementById('settingsButton');
     const panel = document.getElementById('<%= pnlAccountInfo.ClientID %>');
     if (!settingsButton.contains(e.target) && !panel.contains(e.target)) {
         panel.style.display = 'none';
     }
 });
     </script>
</body>
</html>