using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using EBMSMap30;

namespace EBMSMap.Web.Admin
{
    public partial class CLoadTpl : System.Web.UI.Page
    {
        public int retID;
        List<MInput> mInputs = new List<MInput>();
        public DataTable tbT, tbC;
        public bool IsOK;

        protected void Page_Load(object sender, EventArgs e)
        {
            cUsr.CheckAuth("A");
            Get1Tpl();
        }


        private void Get1Tpl()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spCon_GetTpl", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@TplID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@TplID"].Value = Request.QueryString["tplid"];

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbT = DS.Tables[0];
            tbC = DS.Tables[1];

            Name.Text = tbT.Rows[0]["Name"].ToString();
            Detail.Text = tbT.Rows[0]["Detail"].ToString();
        }

        protected void bAdd_ServerClick(object sender, System.EventArgs e)
        {
            applyTpl();
        }

        private void applyTpl()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spCon_LoadTpl", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@TplID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@TplID"].Value = Request.QueryString["tplid"];

            SqlCmd.SelectCommand.Parameters.Add("@typeid", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@typeid"].Value = Request.QueryString["typeid"];

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            if (Convert.ToInt32(DS.Tables[0].Rows[0]["TplID"]) > 0)
            {
                retID = 1;
            }
        }

    }
}