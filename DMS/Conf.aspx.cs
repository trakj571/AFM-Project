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
    public partial class Conf : System.Web.UI.Page
    {
        public DataTable tbC, tbF;
        List<MInput> mInputs = new List<MInput>();
        public int retID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            mInputs.Add(new MInput() { HtmlInput = Occ, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = FStr, DBType = MInput.DataType.Double });
            if (!Page.IsPostBack)
            {
                GetData();
            }
            
        }

        private void GetData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spPOI_ConfGet", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = Request["PoiID"];


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbC = DS.Tables[0];
            tbF = DS.Tables[1];

            Occ.Value = tbC.Rows[0]["Occ"].ToString();
            FStr.Value = tbC.Rows[0]["FStr"].ToString();

            
        }

        protected void bSave_ServerClick(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spPOI_ConfAdd", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = Request["PoiID"];

            MData.AddSqlCmd(SqlCmd, mInputs);

            string freqs = "";
            int nfreq = cConvert.ToInt(Request["nFreq"]);
            for (int i = 0; i < nfreq; i++)
            {
                if (i > 0) freqs += "\r\n";
                freqs += cConvert.ToDouble(Request["fFreq" + i]) + "," + cConvert.ToDouble(Request["tFreq" + i]);
            }
            SqlCmd.SelectCommand.Parameters.Add("@Freqs", SqlDbType.VarChar,freqs.Length+1);
            SqlCmd.SelectCommand.Parameters["@Freqs"].Value = freqs;


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            retID = cConvert.ToInt(DS.Tables[0].Rows[0]["retID"]);

        }
    }
}