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
    public class dScanLoc : IHttpHandler
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
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spScan_GetLoc", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = context.Request["PoiID"];

            SqlCmd.SelectCommand.Parameters.Add("@DtScan", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@DtScan"].Value = cConvert.ConvertToDateTH(context.Request["DtScan"]);


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            context.Response.Write(cConvert.ToJSON(DS.Tables[0]));
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