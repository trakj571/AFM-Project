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
    public partial class AnOcc : System.Web.UI.Page
    {
        public DataTable tbS,tbO;
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

        public double GetValueF(double f)
        {
            DataRow[] dr = tbO.Select("Freq="+f);
            if (dr.Length > 0)
            {
                return cConvert.ToDouble(dr[0]["Occ"]);
            }
            return 0;
        }
        private void GetOcc()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spScanOcc", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value = Request["ScanID"];



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