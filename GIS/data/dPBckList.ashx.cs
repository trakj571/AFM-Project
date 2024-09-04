using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Net;
using System.IO;
using System.Text;

namespace EBMSMap30.data
{
    /// <summary>
    /// Summary description for dPoiSch
    /// </summary>
    public class dPBckList : IHttpHandler
    {
        DataSet DS = new DataSet();

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            ExecDB(context);
            WriteJS(context);
        }

        private void ExecDB(HttpContext context)
        {
            if (!cUsr.VerifyToken(cUsr.Token))
            {
                context.Response.Write(cUtils.getJSON_ERR("403"));
                context.Response.End();
                return;
            }
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spPBck_List]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            
            SqlCmd.Fill(DS);
            SqlConn.Close();
        }

        private void WriteJS(HttpContext context)
        {
            StringBuilder sb = new StringBuilder();
            DataRow[] dr = DS.Tables[0].Select("","Name");
            sb.Append("[");
            for (int i = 0; i < dr.Length; i++)
            {
                if (i > 0) sb.Append(",");
                sb.Append("{");
                sb.Append("\"poiid\": \"" + cText.StrToJSONHex(dr[i]["poiid"]) + "\",");
                sb.Append("\"equtype\": \"" + cText.StrToJSONHex(dr[i]["EquType"]) + "\",");
                sb.Append("\"value\": \"" + cText.StrToJSONHex(dr[i]["Stream"]) + "\",");
                sb.Append("\"text\": \"" + cText.StrToJSONHex(dr[i]["Name"]) + "\"");
                sb.Append("}");
            }
            sb.Append("]");

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