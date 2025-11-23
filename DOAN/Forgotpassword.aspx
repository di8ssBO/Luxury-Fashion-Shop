<%@ Page Title="" Language="C#" MasterPageFile="~/DOAN/Login.Master" AutoEventWireup="true" CodeBehind="Forgotpassword.aspx.cs" Inherits="DOAN_TMDT.DOAN.Forgotpassword" %>
<asp:Content ID="loginForm" ContentPlaceHolderID="LoginContent" runat="server">
    <h1>Reset Password</h1>

    <asp:TextBox ID="txtForgotPhone" runat="server" CssClass="form-input" Placeholder="Phone Number" />
    <asp:TextBox ID="txtForgotUsername" runat="server" CssClass="form-input" Placeholder="Username" />
    <asp:TextBox ID="txtForgotEmail" runat="server" CssClass="form-input" Placeholder="Email" TextMode="Email" />
    <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-input" Placeholder="New Password" TextMode="Password" />

    <asp:Button ID="btnResetPassword" runat="server" Text="Reset Password" CssClass="form-button" OnClick="btnResetPassword_Click" />
</asp:Content>


