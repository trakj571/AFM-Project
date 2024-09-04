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
using System.IO;
using Org.BouncyCastle.Asn1.X509;
using Org.BouncyCastle.Asn1.Ocsp;

namespace EBMSMap.Web.Admin
{
    public partial class Equip : System.Web.UI.Page
    {
        public int retID;
        public DataTable tbS;
        protected void Page_Load(object sender, EventArgs e)
        {
            cUsr.CheckAuth("A");

            if (Request["kill"] == "1")
                KillProcess();

            GetStatus();


        }

        private void KillProcess() {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spStnKillPc", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = cConvert.ToInt(Request["PoiID"]);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            Response.Redirect("Equip.aspx?poiid=" + Request["PoiID"]);
        }

        private void GetStatus()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spSensorGet", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = -1;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbS = DS.Tables[0];

        }

    }
}