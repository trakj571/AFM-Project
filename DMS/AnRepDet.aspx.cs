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
    public partial class AnRepDet : System.Web.UI.Page
    {
        public DataTable tbD,tbS;
        public string[] ColsData = new string[0];
        protected void Page_Load(object sender, EventArgs e)
        {

            int TypeID = cConvert.ToInt(Request["typeid"]);
            if (TypeID == 1)
                ColsData = AFMProj.DMS.VFCols.TypeID1;
            if (TypeID == 2)
                ColsData = AFMProj.DMS.VFCols.TypeID2;
            if (TypeID == 3)
                ColsData = AFMProj.DMS.VFCols.TypeID3;
            if (TypeID == 4)
                ColsData = AFMProj.DMS.VFCols.TypeID4;

            GetData();

            if (TypeID == 1)
                GetScan(tbD.Rows[0]["OFFICE_NAME"].ToString(), tbD.Rows[0]["INSP_MACHINE"].ToString(), tbD.Rows[0]["INSP_DATEF"].ToString(), tbD.Rows[0]["INSP_DATET"].ToString(), tbD.Rows[0]["FREQUENCY"].ToString());
            if (TypeID == 2)
                GetScan(tbD.Rows[0]["OFFICE_NAME"].ToString(), tbD.Rows[0]["INSP_MACHINE"].ToString(), tbD.Rows[0]["INSP_DATEF"].ToString(), tbD.Rows[0]["INSP_DATET"].ToString(), tbD.Rows[0]["FREQ_ASSIGN"].ToString());
        
            if (TypeID == 3)
                GetScan(tbD.Rows[0]["OFFICE_NAME"].ToString(), tbD.Rows[0]["INSP_MACHINE"].ToString(), tbD.Rows[0]["INSP_DATEF"].ToString(), tbD.Rows[0]["INSP_DATET"].ToString(), tbD.Rows[0]["FREQUENCY"].ToString());
        
               
        }


        private void GetData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spVF_Get", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@s_ID", SqlDbType.VarChar, 20);
            SqlCmd.SelectCommand.Parameters["@s_ID"].Value = Request["S_ID"];

            SqlCmd.SelectCommand.Parameters.Add("@TypeID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@TypeID"].Value = cConvert.ToInt(Request["TypeID"]);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbD = DS.Tables[0];


            if (Request["export"] != null)
            {
                List<string> columns = new List<string>();
                for (int i = 0; i < ColsData.Length; i += 2)
                {
                    columns.Add(ColsData[i] + ":" + ColsData[i+1]);
                }

                Export.ToFile(DS.Tables[0], columns, "", "");
            }
        }

        private void GetScan(string LyName,string EquName,string fDt,string tDt,string Freq)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spVF_Scan", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@LyName", SqlDbType.NVarChar,50);
            SqlCmd.SelectCommand.Parameters["@LyName"].Value = LyName;

            SqlCmd.SelectCommand.Parameters.Add("@EquName", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@EquName"].Value = EquName;

            SqlCmd.SelectCommand.Parameters.Add("@fDt", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@fDt"].Value = cConvert.ConvertToDateTH(fDt);

            SqlCmd.SelectCommand.Parameters.Add("@tDt", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@tDt"].Value = cConvert.ConvertToDateTH(tDt);

            SqlCmd.SelectCommand.Parameters.Add("@fFreq", SqlDbType.BigInt);
            SqlCmd.SelectCommand.Parameters["@fFreq"].Value = cConvert.ToDouble(Freq) * 1000000;

            SqlCmd.SelectCommand.Parameters.Add("@tFreq", SqlDbType.BigInt);
            SqlCmd.SelectCommand.Parameters["@tFreq"].Value = cConvert.ToDouble(Freq) * 1000000;

          
            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbS = DS.Tables[0];



        }
    }
}