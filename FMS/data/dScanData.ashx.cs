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
    public class dScanData : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            ExecDB(context);
            context.Response.End();
        }
        private void ExecDB(HttpContext context)
        {

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spScan_GetData", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value = context.Request["ScanID"];


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            context.Response.Write("[");
            for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
            {
                if (i > 0) context.Response.Write(",");
                context.Response.Write("[" + DS.Tables[0].Rows[i]["Freq"] + "," + DS.Tables[0].Rows[i]["Signal"]+"]");
            }
            context.Response.Write("]");
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