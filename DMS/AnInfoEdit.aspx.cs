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
    public partial class AnInfoEdit : System.Web.UI.Page
    {
        public DataTable tbH,tbS, tbD;
        public int retID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {

            GetData();
            GetScanData();
        }


        private void GetData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spScan_Get", SqlConn);
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
            if (tbS.Rows[0]["DataType"].ToString() == "O")
                DataType.Text = "Occupancy";
            else
                DataType.Text = "Field Stength";


        }

        private void GetScanData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spScan_GetData_Pg", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value = Request["ScanID"];

            SqlCmd.SelectCommand.Parameters.Add("@IsFExc", SqlDbType.Char,1);
            SqlCmd.SelectCommand.Parameters["@IsFExc"].Value = "N";

            SqlCmd.SelectCommand.Parameters.Add("@fFreq", SqlDbType.BigInt);
            SqlCmd.SelectCommand.Parameters["@fFreq"].Value = cConvert.ToDouble(Request["sfFreq"]) * 1000000;

            SqlCmd.SelectCommand.Parameters.Add("@tFreq", SqlDbType.BigInt);
            SqlCmd.SelectCommand.Parameters["@tFreq"].Value = cConvert.ToDouble(Request["stFreq"]) * 1000000;

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
        }


        protected void bSave_ServerClick(object sender, EventArgs e)
        {
            for (int i = 0; i < tbD.Rows.Count; i++)
            {
                if(cConvert.ToDouble(Request["Signal" + tbD.Rows[i]["ScanDID"]])== cConvert.ToDouble(tbD.Rows[i]["Signal"]) &&
                    cConvert.ToDouble(Request["Bearing" + tbD.Rows[i]["ScanDID"]]) == cConvert.ToDouble(tbD.Rows[i]["Bearing"]) &&
                    cConvert.ToDouble(Request["Qt" + tbD.Rows[i]["ScanDID"]]) == cConvert.ToDouble(tbD.Rows[i]["Qt"]) &&
                    cConvert.ToDouble(Request["OccMax" + tbD.Rows[i]["ScanDID"]]) == cConvert.ToDouble(tbD.Rows[i]["OccMax"]) &&
                    cConvert.ToDouble(Request["OccAvg" + tbD.Rows[i]["ScanDID"]]) == cConvert.ToDouble(tbD.Rows[i]["OccAvg"])
                    )
                {
                    continue;
                }

                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
                SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spScan_EditData", SqlConn);
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

                SqlCmd.SelectCommand.Parameters.Add("@Bearing", SqlDbType.Float);
                SqlCmd.SelectCommand.Parameters["@Bearing"].Value = cConvert.ToDouble(Request["Bearing" + tbD.Rows[i]["ScanDID"]]);

                SqlCmd.SelectCommand.Parameters.Add("@Qt", SqlDbType.Float);
                SqlCmd.SelectCommand.Parameters["@Qt"].Value = cConvert.ToDouble(Request["Qt" + tbD.Rows[i]["ScanDID"]]);

                SqlCmd.SelectCommand.Parameters.Add("@OccMax", SqlDbType.Float);
                SqlCmd.SelectCommand.Parameters["@OccMax"].Value = cConvert.ToDouble(Request["OccMax" + tbD.Rows[i]["ScanDID"]]);

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