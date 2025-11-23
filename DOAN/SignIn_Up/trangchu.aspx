<%@ Page Title="" Language="C#" MasterPageFile="~/DOAN/Login.Master" AutoEventWireup="true" CodeBehind="trangchu.aspx.cs" Inherits="DOAN_TMDT.DOAN.SignIn_Up.trangchu" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <script src="../js/checkregister.js"></script>
</asp:Content>


<asp:Content ID="loginForm" ContentPlaceHolderID="LoginContent" runat="server">
    <h1>Login here.</h1>
    <asp:TextBox ID="txtLoginEmail" runat="server" CssClass="form-input" Placeholder="Email or Username" />
    <asp:TextBox ID="txtLoginPassword" runat="server" CssClass="form-input" Placeholder="Password" TextMode="Password" />
    <div class="content">
        <div class="content checkbox">
            <asp:Button ID="btnLogin" runat="server" Text="LOGIN" CssClass="form-button" OnClick="btnLogin_Click" />
            <asp:CheckBox ID="chkRemember" runat="server" Text="Remember me" />
           </div>
       <div class="pass-link">
                <button type="button" id="btnForgot" class="form-button">Forgot password?</button>
       </div>
      </div>

    <span>or use your account</span>

    <div class="social-container">
        <a href="#" class="social"><i class="lni lni-google"></i></a>
    </div>
</asp:Content>

<asp:Content ID="registerForm" ContentPlaceHolderID="RegisterContent" runat="server">
    <h1>Register here.</h1>
    <asp:TextBox ID="txtName" runat="server" CssClass="form-input" Placeholder="Name" />

    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-input" Placeholder="Username" onblur="checkDuplicate('username')" />
    <span id="usernameStatus" style="margin-left: 10px; color: red; font-size: 20px;"></span>
    <div id="usernameError" class="error-message"></div>


    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" Placeholder="Email" onblur="checkDuplicate('email')" TextMode="Email" />
    <span id="emailStatus" style="margin-left: 10px; color: red; font-size: 20px;"></span>
    <div id="emailError" class="error-message"></div>


    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-input" Placeholder="Phone" onblur="checkDuplicate('phone')" TextMode="Phone" />
    <span id="phoneStatus" style="margin-left: 10px; color: red; font-size: 20px;"></span>
    <div id="phoneError" class="error-message"></div>


    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input" Placeholder="Password" TextMode="Password" />
    

    <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="form-button" OnClick="btnRegister_Click" />
</asp:Content>

