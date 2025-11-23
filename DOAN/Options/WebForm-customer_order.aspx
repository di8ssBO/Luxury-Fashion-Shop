<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm-customer_order.aspx.cs" Inherits="DOAN_TMDT.Webform.WebForm_customer_order" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Order</title>
    <link rel="stylesheet" href="../css/CSS-customer_order.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h1>Unleash your creativity, we've got your back!</h1>
            <p class="description">*Please enter complete information so we can find and store the details to deliver your order quickly.*</p>
            <div class="form-row">
                <div class="form-group">
                    <select name="productType">
                        <option value="" selected="selected" disabled="disabled">Product type</option>
                        <option value="type1">Balenciaga T-shirt</option>
                        <option value="type2">Balenciaga jacket</option>
                        <option value="type3">Balenciaga jeans</option>
                        <option value="type4">Balenciaga shirt</option>
                        <option value="type5">Balenciaga shorts</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <select name="vignette">
                        <option value="" selected="selected" disabled="disabled">vignette</option>
                        <option value="type1">Small floral frame motifs</option>
                        <option value="type2">Badge-like motifs</option>
                        <option value="type3">Lace edging motifs</option>
                        <option value="type4">Miniature bordered illustrations</option>
                        <option value="type5">Stylized letters or numbers in frames</option>
                    </select>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <select name="material">
                        <option value="" selected="selected" disabled="disabled">Desired material</option>
                        <option value="material1">Cotton</option>
                        <option value="material2">Linen</option>
                        <option value="material3">Wool</option>
                        <option value="material4">Leather</option>
                        <option value="material5">Silk</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <div class="color-input">
                        <input type="text" name="color" placeholder="color"/>
                        <input type="color"/>
                    </div>
                </div>
            </div>
            
            <div class="form-group full">
                <input type="text" name="measurement" placeholder="Measurement:"/>
            </div>
            
            <div class="form-group full">
                <input type="text" name="referenceImages" placeholder="Reference images (if any)"/>
            </div>
            
            <div class="form-group full">
                <textarea name="moreInformation" placeholder="More information"></textarea>
            </div>
            
            <button type="submit">Find out</button>
        </div>
    </form>
</body>
</html>
