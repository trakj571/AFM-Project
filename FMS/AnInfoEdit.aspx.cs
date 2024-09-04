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
    public partial class AnInfoEdit : System.Web.UI.Page
    {
        public DataTable tbS, tbD;
        public int retID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {

            GetData();
            GetScanData();
        }


        private void GetData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spScan_Get", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value = Request["ScanID"];



            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbS = DS.Tables[0];

            DtBegin.Text = string.Format("{0:dd/MM/yyyy HH:mm}", tbS.Rows[0]["DtBegin"]);
            fFreq.Text = string.Format("{0:0.00}", cConvert.ToDouble(tbS.Rows[0]["fFreq"]) / 1e6);
            tFreq.Text = string.Format("{0:0.00}", cConvert.ToDouble(tbS.Rows[0]["tFreq"]) / 1e6);

            ChSpText.Text = string.Format("{0:0.0}kHz", cConvert.ToDouble(tbS.Rows[0]["ChSp"]) / 1e3);
            Station.Text = tbS.Rows[0]["Station"].ToString();
            DataType.Text = "Occupancy";

            FreqRange.Items.Clear();
            FreqRange.Items.Add(new ListItem("= เลือก =", "0"));

            for (int i = 0; i < DS.Tables[1].Rows.Count; i++)
            {
                FreqRange.Items.Add(new ListItem(DS.Tables[1].Rows[i]["Name"].ToString(), DS.Tables[1].Rows[i]["FtID"].ToString()));

            }
            FreqRange.Value = cConvert.ToInt(Request["FtID"]).ToString();
        }

        private void GetScanData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spScan_GetData2", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value = Request["ScanID"];

            //SqlCmd.SelectCommand.Parameters.Add("@IsFExc", SqlDbType.Char,1);
            //SqlCmd.SelectCommand.Parameters["@IsFExc"].Value = "N";

            SqlCmd.SelectCommand.Parameters.Add("@IsAll", SqlDbType.Char, 1);
            SqlCmd.SelectCommand.Parameters["@IsAll"].Value = Request["all"];

             SqlCmd.SelectCommand.Parameters.Add("@FtID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@FtID"].Value = cConvert.ToInt(Request["FtID"]);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbD = DS.Tables[0];
        }


        protected void bSave_ServerClick(object sender, EventArgs e)
        {
            for (int i = 0; i < tbD.Rows.Count; i++)
            {
                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
                SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spScan_EditData", SqlConn);
                SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

                SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

                if (i == 0)
                {
                    SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
                    SqlCmd.SelectCommand.Parameters["@ScanID"].Value = Request["ScanID"];
                }

                
                SqlCmd.SelectCommand.Parameters.Add("@ScanDID", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@ScanDID"].Value = tbD.Rows[i]["ScanDID"];

                SqlCmd.SelectCommand.Parameters.Add("@Freq", SqlDbType.Float);
                SqlCmd.SelectCommand.Parameters["@Freq"].Value = cConvert.ToDouble(Request["Freq"+tbD.Rows[i]["ScanDID"]]);

                SqlCmd.SelectCommand.Parameters.Add("@Signal", SqlDbType.Float);
                SqlCmd.SelectCommand.Parameters["@Signal"].Value = cConvert.ToDouble(Request["Signal" + tbD.Rows[i]["ScanDID"]]);
            
                SqlCmd.SelectCommand.Parameters.Add("@OccAvg", SqlDbType.Float);
                SqlCmd.SelectCommand.Parameters["@OccAvg"].Value = cConvert.ToDouble(Request["OccAvg" + tbD.Rows[i]["ScanDID"]]);

                DataSet DS = new DataSet();
                SqlCmd.Fill(DS);
                SqlConn.Close();
            }
            retID = 1;
        }
    }
}