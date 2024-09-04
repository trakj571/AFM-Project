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
    public partial class AnFStr : System.Web.UI.Page
    {
        public DataTable tbS, tbF;
        protected void Page_Load(object sender, EventArgs e)
        {
            GetData();
            GetFStr();
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
        }

        private void GetFStr()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spScanFstr", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value = Request["ScanID"];



            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbF = DS.Tables[0];

            if (Request["export"] != null)
            {
                List<string> columns = new List<string>();
                columns.Add("Freq:Frequency (MHz)");
                columns.Add("dBuVmx:Maximum Field Strength (dBuV/m)");
                columns.Add("dBuVav:Average Field Strength (dBuV/m)");


                Export.ToFile(tbF, columns, "", "");
            }
        }
    }
}