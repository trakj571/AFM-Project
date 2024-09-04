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
    /// Summary description for dBoundInfo
    /// </summary>
    public class dBoundInfo : IHttpHandler
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
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapS"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spBound_GetInfo]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Grp", SqlDbType.Char, 1);
            SqlCmd.SelectCommand.Parameters["@Grp"].Value = context.Request["Grp"];

            SqlCmd.SelectCommand.Parameters.Add("@Code", SqlDbType.VarChar, 20);
            SqlCmd.SelectCommand.Parameters["@Code"].Value = context.Request["Code"];

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
                sb.Append("\"data\": \"" + cText.StrToJSONHex(DS.Tables[0].Rows[i]["name_t"]) + "\",");
                sb.Append("\"attr\" : { \"id\" : \"li_node_id" + DS.Tables[0].Rows[i]["code"] + "\" },");
                sb.Append("\"metadata\": {\"id\":" + DS.Tables[0].Rows[i]["code"] + "},");
                if(context.Request["Grp"]=="T")
                    sb.Append("\"state\": \"opened\"");
                else
                    sb.Append("\"state\": \"closed\"");
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