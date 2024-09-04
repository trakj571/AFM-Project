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
    public partial class AnEvent : System.Web.UI.Page
    {
        public DataTable tbH, tbD;
       
        protected void Page_Load(object sender, EventArgs e)
        {
            SchData();
        }

        private void SchData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spEvent_ScanID", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value = cConvert.ToInt(Request["ScanID"]);


           
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
                columns.Add("Station:Station");
                columns.Add("Dt:วัน-เวลา ที่ตรวจพบ");
                columns.Add("Freq:ความถี่(MHz)");
                columns.Add("Signal:ความแรงสัญญาณ(dBm)");
                columns.Add("HostName:ผู้ครอบครองความถี่");


                Export.ToFile(tbD, columns, "", "");
            }
        }
    }
}