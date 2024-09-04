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
    public partial class AnInfo : System.Web.UI.Page
    {
        public DataTable tbS;

        protected void Page_Load(object sender, EventArgs e)
        {
            GetData();
        }

        private void GetData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spScan_Get", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value =Request["ScanID"];

            

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbS = DS.Tables[0];

            fFreq.Text = string.Format("{0:0.00}",cConvert.ToDouble(tbS.Rows[0]["fFreq"])/1e6);
            tFreq.Text = string.Format("{0:0.00}", cConvert.ToDouble(tbS.Rows[0]["tFreq"]) / 1e6);
            string dur = "";
            int nsec = cConvert.ToInt(tbS.Rows[0]["nSec"]);
            if (nsec / 3600 > 0) dur += (nsec / 3600) + " hr ";
            if (nsec / 60 % 60 > 0) dur += (nsec / 60 % 60) + " min ";
            if (nsec % 60 > 0) dur += (nsec % 60) + " sec ";

            nSec.Text = dur;
            Threshold.Text = tbS.Rows[0]["Threshold"].ToString();
            int iChSp = cConvert.ToInt(tbS.Rows[0]["ChSp"]);
            if (iChSp > 1e6)
                ChSp.Text = string.Format("{0:0.00} MHz", iChSp / 1e6);
            else if (iChSp > 1e3)
                ChSp.Text = string.Format("{0:0.00} kHz", iChSp / 1e3);
        }
    }
}