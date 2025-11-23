using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DOAN_TMDT.DOAN
{
    public partial class ProductDetail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Request.QueryString["ProductID"] != null)
            {
                int id = int.Parse(Request.QueryString["ProductID"]);
                LoadProductDetail(id);
            }
        }

        private void LoadProductDetail(int productId)
        {
            string cs = ConfigurationManager.ConnectionStrings["MyConnString"].ConnectionString;
            using (SqlConnection cn = new SqlConnection(cs))
            {
                string sql = @"SELECT ProductName, Descriptions, Price, Images 
                               FROM Products WHERE ProductID=@id";
                using (SqlCommand cmd = new SqlCommand(sql, cn))
                {
                    cmd.Parameters.AddWithValue("@id", productId);
                    cn.Open();
                    using (SqlDataReader rd = cmd.ExecuteReader())
                    {
                        if (rd.Read())
                        {
                            lblName.Text = rd["ProductName"].ToString();
                            litDescription.Text = rd["Descriptions"].ToString();
                            lblPrice.Text = string.Format("{0:C}", rd["Price"]);
                            imgProduct.ImageUrl = rd["Images"].ToString();
                            // Nếu bạn có bảng ProductVariants để lấy size:
                            LoadSizes(productId);
                        }
                    }
                }
            }
        }

        private void LoadSizes(int productId)
        {
            string cs = ConfigurationManager.ConnectionStrings["MyConnString"].ConnectionString;
            using (SqlConnection cn = new SqlConnection(cs))
            {
                string sql = "SELECT Size FROM ProductVariants WHERE ProductID=@id";
                using (SqlCommand cmd = new SqlCommand(sql, cn))
                {
                    cmd.Parameters.AddWithValue("@id", productId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        rptSizes.DataSource = dt;
                        rptSizes.DataBind();
                    }
                }
            }
        }
    }
}