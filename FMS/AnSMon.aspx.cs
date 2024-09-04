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

namespace AFMProj.FMS
{
    public partial class AnSMon : System.Web.UI.Page
    {
        public DataTable tbH, tbD;
        List<MInput> mInputs = new List<MInput>();

        protected void Page_Load(object sender, EventArgs e)
        {
           
            if (!Page.IsPostBack)
            {
                if (fDt.Value == "") fDt.Value = string.Format("{0:dd/MM/yyyy}", DateTime.Now.AddDays(-1));
                if (tDt.Value == "") tDt.Value = string.Format("{0:dd/MM/yyyy}", DateTime.Now);

                GetEuips();
            }

            if (Request.ServerVariables["query_string"].ToString() != "")
            {
                PoiID.Value = cText.StrFromUTF8(Request.QueryString["PoiID"]);
                fDt.Value = cText.StrFromUTF8(Request.QueryString["fDt"]);
                tDt.Value = cText.StrFromUTF8(Request.QueryString["tDt"]);

                mInputs.Add(new MInput() { HtmlInput = PoiID, DBType = MInput.DataType.Int });
                mInputs.Add(new MInput() { HtmlInput = fDt, DBType = MInput.DataType.DateTime });
                mInputs.Add(new MInput() { HtmlInput = tDt, DBType = MInput.DataType.DateTime });

                SchData();
            }
        }

        private void GetEuips()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spEquip_Gets]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            DataTable tbE = DS.Tables[0];
            PoiID.Items.Clear();
            PoiID.Items.Add(new ListItem("= ทั้งหมด =", "0"));

            for (int i = 0; i < tbE.Rows.Count; i++)
            {
                PoiID.Items.Add(new ListItem(tbE.Rows[i]["Name"].ToString(), tbE.Rows[i]["PoiID"].ToString()));
            }
        }


        private void SchData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spSensorSch", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;


            MData.AddSqlCmd(SqlCmd, mInputs);

            if (Request["export"] != null)
            {
                SqlCmd.SelectCommand.Parameters.Add("@nPage", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@nPage"].Value = 30000;
            }
            else
            {
                SqlCmd.SelectCommand.Parameters.Add("@Page", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@Page"].Value = Request["Page"];
            }

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbH = DS.Tables[0];
            tbD = DS.Tables[1];

            if (Request["export"] != null)
            {
                List<string> columns = new List<string>();
                columns.Add("Name:Station");
                columns.Add("DtLog:Date-Time");
                columns.Add("f3G:3G");
                columns.Add("LAN:LAN");
                columns.Add("WAN:WAN");
                columns.Add("GPS:GPS");

                columns.Add("UPSPc:UPS%");
                columns.Add("Voltage:Voltage");
                columns.Add("Current:Current");
                columns.Add("Frequency:Frequency");
                columns.Add("PAE:Energy");
                columns.Add("Temp:Temp");
                columns.Add("Door:Door");

                Export.ToFile(tbD, columns, "", "");
            }
        }
    }
}