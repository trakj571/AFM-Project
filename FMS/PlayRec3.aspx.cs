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
using System.Net;
using System.Web.Script.Serialization;
using System.Security.Cryptography.X509Certificates;

namespace AFMProj.FMS
{
    public partial class PlayRec3 : System.Web.UI.Page
    {
        public DataTable tbD;
        public string StreamURL;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (cConvert.ToInt(Request["ScanID"]) > 0)
            {
                GetData();
            }
            StreamURL = "http://lmtr.nbtc.go.th" + Request["datapath"] + Request["playlist"];
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

            tbD = DS.Tables[0];

            int n = EBMSMap30.cConvert.ToInt(tbD.Rows[0]["VoicePart"]);
            for (int i = 0; i <= n; i++)
            {

                mPlayList.Items.Add(new ListItem("Part - " + (i + 1), "../Files/FTPAFM2/" + tbD.Rows[0]["POIID"] + "/Voice/" + tbD.Rows[0]["VoiceFile"] + (i > 0 ? "-^" + string.Format("{0:000}", i) : "") + ".wav"));
            }
        }
    }
}