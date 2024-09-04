using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using EBMSMap30;


namespace AFMProj.DMS.data
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
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spScan_GetData", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value = context.Request["ScanID"];


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            if (context.Request["EquType"] == "MOB")
            {
                sb.Append("{\"data\" : [");
                for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
                {
                    if (i > 0) sb.Append(",");
                    sb.Append("[" + DS.Tables[0].Rows[i]["Bearing"] + "," + DS.Tables[0].Rows[i]["Signal"] + "]");
                }
                sb.Append("],");
                sb.Append("\"data2\" : [");
                for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
                {
                    if (i > 0) sb.Append(",");
                    sb.Append("[" + DS.Tables[0].Rows[i]["Bearing"] + "," + DS.Tables[0].Rows[i]["Qt"] + "]");
                }
                sb.Append("]}");
            }
            else if (context.Request["DataType"] == "O")
            {
                sb.Append("{\"data\" : [");
                for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
                {
                    if (i > 0) sb.Append(",");
                    sb.Append("[" + DS.Tables[0].Rows[i]["Freq"] + "," + DS.Tables[0].Rows[i]["OccAvgC"] + "]");
                }
                sb.Append("],");
                sb.Append("\"data2\" : [");
               
                for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
                {
                    if (i > 0) sb.Append(",");
                    sb.Append("[" + DS.Tables[0].Rows[i]["Freq"] + "," + DS.Tables[0].Rows[i]["OccMaxC"] + "]");
                }
                sb.Append("]}");
            }
            else
            {
                sb.Append("[");
                for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
                {
                    if (i > 0) sb.Append(",");
                    sb.Append("[" + DS.Tables[0].Rows[i]["Freq"] + "," + DS.Tables[0].Rows[i]["Signal"] + "]");
                }
                sb.Append("]");
            }

            context.Response.Write(sb.ToString());
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