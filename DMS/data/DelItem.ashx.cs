using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using EBMSMap30;

namespace EBMSMap.Web.DMS.data
{
    /// <summary>
    /// Summary description for dOrgGet
    /// </summary>
    public class DelItem : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            context.Response.CacheControl = "no-cache";
            //context.Response.Write("Hello World");
            DelData(context);
        }

        private void DelData(HttpContext context)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter(context.Request.Form["sp"], SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@"+ context.Request.Form["id"], SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@"+ context.Request.Form["id"]].Value = -cConvert.ToInt(context.Request.Form["val"]);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();


            if(cConvert.ToInt(DS.Tables[0].Rows[0]["retID"])>0)
                context.Response.Write("{\"result\":\"OK\"}");
            else
                context.Response.Write("{\"result\":\"ERR\"}");

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