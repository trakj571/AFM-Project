using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Text;
using EBMSMap30;

namespace EBMSMap.Web.SysCfg
{
    public partial class BDataAdd : System.Web.UI.Page
    {
        public int retID = 0;
        public String LabelName = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            LabelName = BData.getTableTH(Request["table"]);
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["id"] != "0")
                {
                    GetData();
                }
            }
        }

        private void GetData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[oss].[spUD_Get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@Table", SqlDbType.VarChar, 20);
            SqlCmd.SelectCommand.Parameters["@Table"].Value = Request.QueryString["table"];

            SqlCmd.SelectCommand.Parameters.Add("@xIDName", SqlDbType.VarChar, 20);
            SqlCmd.SelectCommand.Parameters["@xIDName"].Value = Request.QueryString["selid"];

            SqlCmd.SelectCommand.Parameters.Add("@xID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@xID"].Value = Request.QueryString["id"];


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            Code.Value = DS.Tables[0].Rows[0]["Code"].ToString();
            Name.Value = DS.Tables[0].Rows[0]["Name"].ToString();
            Detail.Value = DS.Tables[0].Rows[0]["Detail"].ToString();
        }
        protected void bSave_ServerClick(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[oss].[spBD_Add]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@Table", SqlDbType.VarChar, 20);
            SqlCmd.SelectCommand.Parameters["@Table"].Value = Request.QueryString["table"];

            SqlCmd.SelectCommand.Parameters.Add("@xID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@xID"].Value = Request.QueryString["id"];

            SqlCmd.SelectCommand.Parameters.Add("@xIDName", SqlDbType.VarChar, 20);
            SqlCmd.SelectCommand.Parameters["@xIDName"].Value = Request.QueryString["selid"];

            SqlCmd.SelectCommand.Parameters.Add("@Name", SqlDbType.NVarChar, 250);
            SqlCmd.SelectCommand.Parameters["@Name"].Value = Name.Value;

            SqlCmd.SelectCommand.Parameters.Add("@Detail", SqlDbType.NVarChar, 250);
            SqlCmd.SelectCommand.Parameters["@Detail"].Value = Detail.Value;

            SqlCmd.SelectCommand.Parameters.Add("@Code", SqlDbType.NVarChar, 255);
            SqlCmd.SelectCommand.Parameters["@Code"].Value = Code.Value;


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            retID = Convert.ToInt32(DS.Tables[0].Rows[0]["retID"]);

        }
    }
}