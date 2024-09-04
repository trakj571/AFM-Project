using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace EBMSMap30.UR
{
    public partial class Act : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["c"] != null)
            {
                act(Request.QueryString["c"]);
            }
        }

        private void act(string acode)
        {
            string[] acodes = acode.Split(':');
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD30"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spUSR_Act", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = acodes[0];

            SqlCmd.SelectCommand.Parameters.Add("@ACode", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@ACode"].Value = acodes[1].Replace("==","");

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            int UID = Convert.ToInt32(DS.Tables[0].Rows[0]["UID"]);

            if (UID > 0)
            {
                Response.Redirect("Login.aspx?a=1");
            }
            else
            {
                Response.Redirect("Login.aspx?a=0");
            }
        }
        
    }
}