using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using EBMSMap30;


namespace AFMProj.FMS.data
{
    /// <summary>
    /// Summary description for dScanBegin
    /// </summary>
    public class dScanBegin : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            CheckScan(context);
            ExecDB(context);
            context.Response.End();
        }
        private void CheckScan(HttpContext context)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spScan_Get", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = context.Request["PoiID"];

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value = "0";


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            if (DS.Tables[0].Rows.Count > 0)
            {
                context.Response.Write("{\"result\":\"EXT\"}");
                context.Response.End();
            }
        }
        private void ExecDB(HttpContext context)
        {
            int nSec = cConvert.ToInt(context.Request["nHr"]) * 3600 + cConvert.ToInt(context.Request["nMin"]) * 60 + cConvert.ToInt(context.Request["nSec"]);
            System.Diagnostics.ProcessStartInfo oStartInfo = new System.Diagnostics.ProcessStartInfo();
            oStartInfo.FileName = ConfigurationManager.AppSettings["AFM_Batch"] + @"\AFM_Batch.exe";
            oStartInfo.Arguments = "scan " + cUsr.UID + " " + context.Request["PoiID"] + " A " + context.Request["fFreq"] + " " + context.Request["tFreq"] + " " + context.Request["RBW"] + " " + nSec + " " + context.Request["Threshold"] + " " + context.Request["ChSp"]+" 0 "+
                context.Request["RadMode"]+" "+ context.Request["DDC1"] + " " + context.Request["DDC2"] + " " + context.Request["DFBw"];
            System.Diagnostics.Process.Start(oStartInfo);


            /*SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spScan_Begin", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = context.Request["PoiID"];

            SqlCmd.SelectCommand.Parameters.Add("@fFreq", SqlDbType.BigInt);
            SqlCmd.SelectCommand.Parameters["@fFreq"].Value = context.Request["fFreq"];

            SqlCmd.SelectCommand.Parameters.Add("@tFreq", SqlDbType.BigInt);
            SqlCmd.SelectCommand.Parameters["@tFreq"].Value = context.Request["tFreq"];

            SqlCmd.SelectCommand.Parameters.Add("@RBW", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@RBW"].Value = context.Request["RBW"];

            SqlCmd.SelectCommand.Parameters.Add("@nSec", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@nSec"].Value = context.Request["nSec"];

            SqlCmd.SelectCommand.Parameters.Add("@Mode", SqlDbType.Char,1);
            SqlCmd.SelectCommand.Parameters["@Mode"].Value = "A";

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            */
            context.Response.Write("{\"result\":\"OK\"}");
              
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}