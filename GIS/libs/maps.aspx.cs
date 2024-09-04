using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace EBMSMap30.libs
{
    public partial class maps : System.Web.UI.Page
    {
        public DataTable tbD,tbL;
        protected void Page_Load(object sender, EventArgs e)
        {
            GetDomain();
        }

        private void GetDomain()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spUR_AccDomain]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Url", SqlDbType.NVarChar, 100);
            SqlCmd.SelectCommand.Parameters["@Url"].Value = Request.UrlReferrer.GetLeftPart( UriPartial.Authority );

            SqlCmd.SelectCommand.Parameters.Add("@Key", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Key"].Value = Request.QueryString["key"];

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            
            tbD = DS.Tables[0];
            tbL = DS.Tables[1];

           
         

        }
    }
}