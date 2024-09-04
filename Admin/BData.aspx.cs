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
using System.Globalization;

namespace EBMSMap.Web.SysCfg
{
    public partial class BData : System.Web.UI.Page
    {
        public int retID = 0;
        public String LabelName = "";
        public DataTable tbH, tbD;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request["table"] == null)
                Response.Redirect("BData.aspx?table=tbRBW&selid=RBWID");

            if (Request["del"] != null)
                DelData();

            GetData(Request["table"], Request["selid"], Request["page"], cText.StrFromUTF8(Request["kw"]));
            
        }

        static public string getTableTH(string table)
        {
            switch (table)
            {
                case "tbRBW": return "RBW";
       
            }
            return "";
        }

        private void DelData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[fms].[spUD_Add]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@Table", SqlDbType.VarChar, 20);
            SqlCmd.SelectCommand.Parameters["@Table"].Value = Request.QueryString["table"];

            SqlCmd.SelectCommand.Parameters.Add("@xID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@xID"].Value = "-" + Request.QueryString["del"];

            SqlCmd.SelectCommand.Parameters.Add("@xIDName", SqlDbType.VarChar, 20);
            SqlCmd.SelectCommand.Parameters["@xIDName"].Value = Request.QueryString["selid"];


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

        }
        private void GetData(object table, object idname, object page, object kw)
        {
            LabelName = getTableTH(table.ToString());

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[fms].[spUD_Get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@Table", SqlDbType.VarChar, 20);
            SqlCmd.SelectCommand.Parameters["@Table"].Value = table;

            SqlCmd.SelectCommand.Parameters.Add("@xIDName", SqlDbType.VarChar, 20);
            SqlCmd.SelectCommand.Parameters["@xIDName"].Value = idname;

            SqlCmd.SelectCommand.Parameters.Add("@Page", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@Page"].Value = page;


            SqlCmd.SelectCommand.Parameters.Add("@Kw", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Kw"].Value = kw;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbH = DS.Tables[0];
            tbD = DS.Tables[1];
        }
    }
}