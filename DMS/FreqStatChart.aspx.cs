using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Net;
using EBMSMap30;
using System.Web.Script.Serialization;

namespace AFMProj.DMS
{

    public partial class FreqStatChart : System.Web.UI.Page
    {
        public DataTable tbT,tbF;

        string fDt, tDt, Level, ProvID, LyID1, LyID2;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.ServerVariables["query_string"].ToString() != "")
            {
                fDt = cText.StrFromUTF8(Request.QueryString["fDt"]);
                tDt = cText.StrFromUTF8(Request.QueryString["tDt"]);
                Level = cText.StrFromUTF8(Request.QueryString["Level"]);
                ProvID = cText.StrFromUTF8(Request.QueryString["ProvID"]);
                LyID1 = cText.StrFromUTF8(Request.QueryString["LyID1"]);
                LyID2 = cText.StrFromUTF8(Request.QueryString["LyID2"]);

                SchData();
            }
        }

        
        public void SchData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spDMS_FreqStat", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@fDt", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@fDt"].Value = cConvert.ConvertToDateTH(fDt);

            SqlCmd.SelectCommand.Parameters.Add("@tDt", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@tDt"].Value = cConvert.ConvertToDateTH(tDt);

            SqlCmd.SelectCommand.Parameters.Add("@Level", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@Level"].Value = cConvert.ToInt(Level);

            SqlCmd.SelectCommand.Parameters.Add("@ProvID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ProvID"].Value = cConvert.ToInt(ProvID);

            SqlCmd.SelectCommand.Parameters.Add("@LyID1", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@LyID1"].Value = cConvert.ToInt(LyID1);

            SqlCmd.SelectCommand.Parameters.Add("@LyID2", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@LyID2"].Value = cConvert.ToInt(LyID2);

            
            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbF = DS.Tables[2];

            int iLevel = cConvert.ToInt(Level);
            tbT = FreqStat.BuiltTbT(DS, iLevel,true);

            
        }

    }
}