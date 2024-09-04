using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;

namespace EBMSMap30.data
{
    /// <summary>
    /// Summary description for dPoiSch
    /// </summary>
    public class dLayer : IHttpHandler
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
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spPOI_Layer]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@Place", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Place"].Value = HttpContext.Current.Request.QueryString["place"];

            SqlCmd.Fill(DS);
            SqlConn.Close();
        }

        private void WriteJS(HttpContext context)
        {
            StringBuilder sb = new StringBuilder();
            DataRow[] dr = DS.Tables[0].Select("pLyID=0");
            sb.Append("[");
            for (int i = 0; i < dr.Length; i++)
            {
                if (i > 0) sb.Append(",");
                sb.Append("{");
                sb.Append("\"data\": \"" + cText.StrToJSONHex(dr[i]["Name"]) + "\",");
                sb.Append("\"attr\" : { \"id\" : \"li_node_id" + dr[i]["LyID"] + "\" },");
                sb.Append("\"metadata\": {\"id\":" + dr[i]["LyID"] + "}");
                sb.Append(JSON_Child(dr[i]["LyID"]));
                sb.Append("}");
            }
            sb.Append("]");

            context.Response.Write(sb.ToString());
        }

        private string JSON_Child(object pid)
        {
            DataRow[] dr = DS.Tables[0].Select("pLyID=" + pid);
            DataRow[] dre = DS.Tables[1].Select("LyID=" + pid, "Name");
            if (dr.Length == 0 && dre.Length == 0) return "";
          
            StringBuilder sb = new StringBuilder();
            sb.Append(",\"children\":[");
            for (int j = 0; j < dr.Length; j++)
            {
                if (j > 0) sb.Append(",");
                sb.Append("{");
                sb.Append("\"data\": \"" + dr[j]["Name"] + "\",");
                sb.Append("\"attr\" : { \"id\" : \"li_node_id" + dr[j]["LyID"] + "\",\"rel\":\"root\" },");
                sb.Append("\"metadata\": {\"id\":" + dr[j]["LyID"] + "}");
                sb.Append(JSON_Child(dr[j]["LyID"]));
                sb.Append("}");
            }
            if (HttpContext.Current.Request.QueryString["equ"] != null)
            {
                for (int j = 0; j < dre.Length; j++)
                {
                    if (dr.Length > 0 || j > 0) sb.Append(",");
                    sb.Append("{");
                    sb.Append("\"data\": \"" + dre[j]["Name"] + "\",");
                    sb.Append("\"attr\" : { \"id\" : \"li_node_id_e" + dre[j]["PoiID"] + "\",\"equtype\" : \"" + dre[j]["EquType"] + "\",\"rel\":\"type"+dre[j]["poiType"]+"\"},");
                    sb.Append("\"metadata\": {\"id\":" + dre[j]["PoiID"] + "}");
                    sb.Append("}");
                }
            }
            sb.Append("]");
            return sb.ToString();
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