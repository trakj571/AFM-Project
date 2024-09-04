using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace EBMSMap30.data
{
    /// <summary>
    /// Summary description for dGISDef
    /// </summary>
    public class dGISDef : IHttpHandler
    {
        DataSet DS = new DataSet();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            //context.Response.Write("Hello World");
            ExecDB(context);


            DefCL defcl = new DefCL();


            string[] layers = context.Request["layers"].Split(',');
            context.Response.Write("[");
            bool is1 = true;
            foreach (string alayer in layers)
            {
                if (!is1) context.Response.Write(",");
                is1 = false;

                if (alayer.StartsWith("ALT:FLD"))
                {
                    context.Response.Write("{");
                    context.Response.Write("\"l\":\"" + alayer + "\",");
                    context.Response.Write("\"n\":\"ข้อมูลน้ำท่วม\",");
                    context.Response.Write("\"d\":[");
                    string[] defs = defcl.DefSet[alayer.Split('@')[0]] as string[];
                    for (int i = 0; i < defs.Length; i += 3)
                    {
                        if (i > 0) context.Response.Write(",");
                        context.Response.Write("{");
                        context.Response.Write("\"c\":\"" + defs[i] + "\",");
                        context.Response.Write("\"t\":\"" + defs[i + 1] + "\",");
                        context.Response.Write("\"code\":\"" + defs[i + 2] + "\"");
                        context.Response.Write("}");
                    }
                    context.Response.Write("]");
                    context.Response.Write("}");
                }
                string layername = "";
                DataRow[] dr = DS.Tables[1].Select("gLayer='" + alayer.Replace(":", "-") + "'");
                if (dr.Length > 0)
                {
                    layername = dr[0]["name"].ToString();

                    if (!defcl.DefSet.ContainsKey(alayer))
                    {
                        context.Response.Write("{");
                        context.Response.Write("\"l\":\"" + alayer + "\",");
                        context.Response.Write("\"n\":\"" + layername + "\",");
                        context.Response.Write("\"d\":[],");
                        context.Response.Write("\"ty\":\"" + dr[0]["PoiType"] + "\",");
                        context.Response.Write("\"cl\":\"" + dr[0]["lineColor"] + "\",");
                        context.Response.Write("\"cf\":\"" + dr[0]["fillColor"] + "\"");
                        context.Response.Write("}");
                    }
                    else
                    {

                        context.Response.Write("{");
                        context.Response.Write("\"l\":\"" + alayer + "\",");
                        context.Response.Write("\"n\":\"" + layername + "\",");
                        context.Response.Write("\"d\":[");
                        string[] defs = defcl.DefSet[alayer] as string[];
                        for (int i = 0; i < defs.Length; i += 3)
                        {
                            if (i > 0) context.Response.Write(",");
                            context.Response.Write("{");
                            context.Response.Write("\"c\":\"" + defs[i] + "\",");
                            context.Response.Write("\"t\":\"" + defs[i + 1] + "\",");
                            context.Response.Write("\"code\":\"" + defs[i + 2] + "\"");
                            context.Response.Write("}");
                        }
                        context.Response.Write("]");
                        context.Response.Write("}");
                    }
                }
            }
            context.Response.Write("]");
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

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}