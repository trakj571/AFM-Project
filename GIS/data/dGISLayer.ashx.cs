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
    public class dGISLayer : IHttpHandler
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
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spPOI_GISLayer]", SqlConn);
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
            sb.Append("[");

            for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
            {
                
                if (i > 0) sb.Append(",");
                sb.Append("{");
                sb.Append("\"data\": \"" + cText.StrToJSONHex(DS.Tables[0].Rows[i]["NameT"]) + "\",");
                sb.Append("\"attr\" : { \"id\" : \"li_node_id_cat" + DS.Tables[0].Rows[i]["catid"] + "\",\"class\":\"no_checkbox\" },");
                sb.Append("\"metadata\": {\"id\":\"" + DS.Tables[0].Rows[i]["catid"] + "\"}");
                DataRow[] dr = DS.Tables[1].Select("CatID=" + DS.Tables[0].Rows[i]["catid"],"gLyID");
                if (dr.Length > 0)
                {
                    sb.Append(",\"children\":[");
                    for (int j = 0; j < dr.Length; j++)
                    {
                        if (j > 0) sb.Append(",");
                        sb.Append("{");
                        sb.Append("\"data\": \"" + cText.StrToJSONHex(dr[j]["Name"]) + "\",");
                        sb.Append("\"attr\" : { \"id\" : \"li_node_id" + dr[j]["gLayer"] + "\" },");
                        sb.Append("\"metadata\": {\"id\":\"" + dr[j]["gLayer"] + "\",\"grp\":\"" + dr[j]["Grp"] + "\"}");
                        sb.Append("}");
                    }
                    sb.Append("]");
                }
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