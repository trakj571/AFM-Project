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
    public partial class AnOcc : System.Web.UI.Page
    {
        public DataTable tbS, tbO;
        protected void Page_Load(object sender, EventArgs e)
        {
            GetData();
            GetOcc();
            GetApvAuth();
        }
        private void GetApvAuth()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spScan_ApvAuth", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Grp", SqlDbType.VarChar, 3);
            SqlCmd.SelectCommand.Parameters["@Grp"].Value = "FMS";

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

            fFreq.Text = string.Format("{0:0.00}", cConvert.ToDouble(tbS.Rows[0]["fFreq"]) / 1e6);
            tFreq.Text = string.Format("{0:0.00}", cConvert.ToDouble(tbS.Rows[0]["tFreq"]) / 1e6);

            string dur = "";
            int nsec = cConvert.ToInt(tbS.Rows[0]["nSec"]);
            if (nsec / 3600 > 0) dur += (nsec / 3600) + " hr ";
            if (nsec / 60 % 60 > 0) dur += (nsec / 60 % 60) + " min ";
            if (nsec % 60 > 0) dur += (nsec % 60) + " sec ";

            nSec.Text = dur;

            Threshold.Text = tbS.Rows[0]["Threshold"].ToString();
            ChSp.Value = tbS.Rows[0]["ChSp"].ToString();

            FreqRange.Items.Clear();
            FreqRange.Items.Add(new ListItem("= เลือก =", "0"));

            for (int i = 0; i < DS.Tables[1].Rows.Count; i++)
            {
                FreqRange.Items.Add(new ListItem(DS.Tables[1].Rows[i]["Name"].ToString(), DS.Tables[1].Rows[i]["FtID"].ToString()));

            }
            FreqRange.Value = cConvert.ToInt(Request["FtID"]).ToString();
        }

        public double GetValueF(double f)
        {
            DataRow[] dr = tbO.Select("Freq=" + f);
            if (dr.Length > 0)
            {
                return cConvert.ToDouble(dr[0]["Occ"]);
            }
            return 0;
        }
        private void GetOcc()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spScanOcc", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value = Request["ScanID"];

            SqlCmd.SelectCommand.Parameters.Add("@IsAll", SqlDbType.Char, 1);
            SqlCmd.SelectCommand.Parameters["@IsAll"].Value = Request["all"];

            SqlCmd.SelectCommand.Parameters.Add("@FtID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@FtID"].Value = cConvert.ToInt(Request["FtID"]);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbO = DS.Tables[0];

            if (Request["export"] != null)
            {
                List<string> columns = new List<string>();
                columns.Add("FreqMHz:Frequency (MHz)");
                columns.Add("Occ:Occupancy (%)");


                Export.ToFile(tbO, columns, "", "");
            }
        }

    }
}