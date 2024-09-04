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

namespace EBMSMap.Web.Admin
{
    public partial class History : System.Web.UI.Page
    {
        public int retID;
        protected void Page_Load(object sender, EventArgs e)
        {

            cUsr.CheckAuth("A");
            if (Request.QueryString["fdt"] != null)
            {
                FrmDt.Value = Request.QueryString["fdt"];
            }
            else
            {
                FrmDt.Value = String.Format(new CultureInfo("th-TH"), "{0:dd/MM/yyyy}", DateTime.Now);
            }
            if (Request.QueryString["tdt"] != null)
            {
                ToDt.Value = Request.QueryString["tdt"];
            }
            else
            {
                ToDt.Value = String.Format(new CultureInfo("th-TH"), "{0:dd/MM/yyyy}", DateTime.Now);
            }

            if (Request.QueryString["act"] != null)
            {
                Action.Value = Request.QueryString["act"];
            }

            GetUsers();
            GetGrps();
            GetOrgs();

            if (Request.QueryString["ugid"] != null)
            {
                UGrp.Value = Request.QueryString["ugid"];
            }
            if (Request.QueryString["orgid"] != null)
            {
                Org.Value = Request.QueryString["orgid"];
            }
            if (Request.QueryString["u"] != null)
                GetLog();
        }


        public DataTable tbH, tbB;

        private void GetLog()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spUR_GetLog]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = Request.QueryString["u"];

            SqlCmd.SelectCommand.Parameters.Add("@Page", SqlDbType.SmallInt);
            SqlCmd.SelectCommand.Parameters["@Page"].Value = Request.QueryString["page"];

            if (FrmDt.Value != "")
            {
                SqlCmd.SelectCommand.Parameters.Add("@FDt", SqlDbType.SmallDateTime);
                SqlCmd.SelectCommand.Parameters["@FDt"].Value = Comm.ConvertToDateTH(FrmDt.Value);
            }
            if (ToDt.Value != "")
            {
                SqlCmd.SelectCommand.Parameters.Add("@TDt", SqlDbType.SmallDateTime);
                SqlCmd.SelectCommand.Parameters["@TDt"].Value = Comm.ConvertToDateTH(ToDt.Value);
            }

            SqlCmd.SelectCommand.Parameters.Add("@Fno", SqlDbType.Char, 1);
            SqlCmd.SelectCommand.Parameters["@Fno"].Value = "A";

            SqlCmd.SelectCommand.Parameters.Add("@Action", SqlDbType.VarChar, 30);
            SqlCmd.SelectCommand.Parameters["@Action"].Value = Request.QueryString["act"];

            SqlCmd.SelectCommand.Parameters.Add("@UGID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UGID"].Value = Request.QueryString["ugid"];

            SqlCmd.SelectCommand.Parameters.Add("@OrgID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@OrgID"].Value = Request.QueryString["orgid"];


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbH = DS.Tables[0];
            tbB = DS.Tables[1];
        }

        private void GetUsers()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spUR_Get", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
            {
                Users.Items.Add(new ListItem(DS.Tables[0].Rows[i]["Login"] + "(" + DS.Tables[0].Rows[i]["FName"] + " " + DS.Tables[0].Rows[i]["LName"] + ")", DS.Tables[0].Rows[i]["UID"] + ""));
            }

            if (Request.QueryString["u"] != null)
            {
                Users.Value = Request.QueryString["u"];
            }
        }

        private void GetOrgs()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spOrg_Get", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            Org.Items.Add(new ListItem("=== All ===", "0"));
            for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
            {
                Org.Items.Add(new ListItem(DS.Tables[0].Rows[i]["Name"].ToString(), DS.Tables[0].Rows[i]["OrgID"].ToString()));
            }
        }

        private void GetGrps()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spUR_GetUGrp", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            UGrp.Items.Add(new ListItem("=== All ===", "0"));
            for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
            {
                UGrp.Items.Add(new ListItem(DS.Tables[0].Rows[i]["Name"].ToString(), DS.Tables[0].Rows[i]["UGID"].ToString()));
            }
        }
        
    }
}