using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace EBMSMap30.UR
{
    public partial class DivSch : System.Web.UI.Page
    {
        public DataTable tbH, tbB;
        public string Kw = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            
            Kw = cText.StrFromUTF8(Request.QueryString["kw"]);
            if (Request.QueryString["del"] != null)
            {
                DelDiv();
            }
            GetDiv();
        }

        private void GetDiv()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[pms].[spDiv_Get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@Kw", SqlDbType.NVarChar,50);
            SqlCmd.SelectCommand.Parameters["@Kw"].Value = Kw;

            SqlCmd.SelectCommand.Parameters.Add("@Page", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@Page"].Value = Request.QueryString["pg"];

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbH = DS.Tables[0];
            tbB = DS.Tables[1];

        }

        private void DelDiv()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[pms].[spDiv_Add]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@DivID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@DivID"].Value = "-"+Request.QueryString["del"];

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

        }
    }
}