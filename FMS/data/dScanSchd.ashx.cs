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
    public class dScanSchd : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            ExecDB(context);
            context.Response.End();
        }
        private void ExecDB(HttpContext context)
        {
            int nSec = cConvert.ToInt(context.Request["nHr"]) * 3600 + cConvert.ToInt(context.Request["nMin"]) * 60 + cConvert.ToInt(context.Request["nSec"]);
            
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
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
            SqlCmd.SelectCommand.Parameters["@nSec"].Value = nSec;

            SqlCmd.SelectCommand.Parameters.Add("@Mode", SqlDbType.Char,1);
            SqlCmd.SelectCommand.Parameters["@Mode"].Value = context.Request["Mode"];

            SqlCmd.SelectCommand.Parameters.Add("@ScanType", SqlDbType.Char, 1);
            SqlCmd.SelectCommand.Parameters["@ScanType"].Value = "S";

            SqlCmd.SelectCommand.Parameters.Add("@DtStart", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@DtStart"].Value = cConvert.ConvertToDateTH(context.Request["DtStart"]);

            SqlCmd.SelectCommand.Parameters.Add("@ChSp", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@ChSp"].Value = cConvert.ToDouble(context.Request["ChSp"]);

            SqlCmd.SelectCommand.Parameters.Add("@Threshold", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Threshold"].Value = -cConvert.ToDouble(context.Request["Threshold"]);

            SqlCmd.SelectCommand.Parameters.Add("@RadMode", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@RadMode"].Value = context.Request["RadMode"];

            SqlCmd.SelectCommand.Parameters.Add("@DDC1", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@DDC1"].Value = context.Request["DDC1"];

            SqlCmd.SelectCommand.Parameters.Add("@DDC2", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@DDC2"].Value = context.Request["DDC2"];

            SqlCmd.SelectCommand.Parameters.Add("@DFBw", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@DFBw"].Value = context.Request["DFBw"];

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
           
            context.Response.Write("{\"result\":\"OK\",\"retID\":"+DS.Tables[0].Rows[0]["retID"]+"}");
              
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