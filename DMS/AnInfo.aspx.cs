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


namespace AFMProj.DMS
{
    public partial class AnInfo : System.Web.UI.Page
    {
        public DataTable tbS,tbF;

        protected void Page_Load(object sender, EventArgs e)
        {
            GetData();
            if (Request["export"] != null)
                ExportXls();
            GetApvAuth();
        }
        private void GetApvAuth()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spScan_ApvAuth", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Grp", SqlDbType.VarChar, 3);
            SqlCmd.SelectCommand.Parameters["@Grp"].Value = "DMS";

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value = Request["ScanID"];



            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            AuthID.Items.Clear();
            var tbA = DS.Tables[0];
            AuthID.Items.Add(new ListItem("กรุณาเลือก", "0"));
            for (int i = 0; i < tbA.Rows.Count; i++)
            {
                AuthID.Items.Add(new ListItem(tbA.Rows[i]["AuthNameR"].ToString(), tbA.Rows[i]["AuthID"].ToString()));

            }
        }

        private void ExportXls()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spScan_GetData", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value = cConvert.ToInt(Request["ScanID"]);


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

          
            List<string> columns = new List<string>();
            columns.Add("FreqMHz:Frequency");
            if (tbS.Rows[0]["DataType"].ToString() == "O")
            {
                columns.Add("OccMax:Occupancy Max");
                columns.Add("OccAvg:Occupancy Avg");
            }
            else
            {
                columns.Add("Signal:Signal");
            }
            Export.ToFile(DS.Tables[0], columns, "", "");

        }

        private void GetData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spScan_Get", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value = cConvert.ToInt(Request["ScanID"]);



            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbS = DS.Tables[0];

            if (tbS.Rows.Count == 0)
            {
                Response.Redirect("AnChk.aspx");
            }

            DtBegin.Text = string.Format("{0:dd/MM/yyyy HH:mm}", tbS.Rows[0]["DtBegin"]);
            if(tbS.Rows[0]["DtEnd"]!=DBNull.Value)
                DtBegin.Text += string.Format(" - {0:dd/MM/yyyy HH:mm}", tbS.Rows[0]["DtEnd"]);

            fFreq.Text = string.Format("{0:0.00}", cConvert.ToDouble(tbS.Rows[0]["fFreq"]) / 1e6);
            tFreq.Text = string.Format("{0:0.00}", cConvert.ToDouble(tbS.Rows[0]["tFreq"]) / 1e6);

            ChSpText.Text = string.Format("{0:0.0}kHz", cConvert.ToDouble(tbS.Rows[0]["ChSp"]) / 1e3);
            Station.Text = tbS.Rows[0]["Station"].ToString();
            if (tbS.Rows[0]["DataType"].ToString() == "O")
                DataType.Text = "Occupancy";
            else if (tbS.Rows[0]["DataType"].ToString() == "R")
                DataType.Text = "Occupancy Report";
            else
                DataType.Text = "Field Stength";

            GetConf(cConvert.ToInt(tbS.Rows[0]["PoiID"]));
        }


        private void GetConf(int PoiID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spPOI_ConfGet", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = PoiID;


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            FStr.Text = string.Format("{0:0.00}", DS.Tables[0].Rows[0]["FStr"]);
            Occ.Text = string.Format("{0:0.00}", DS.Tables[0].Rows[0]["Occ"]);

            tbF = DS.Tables[1];
        }
    }
}