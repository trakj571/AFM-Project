using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using EBMSMap30;
using System.Net;

namespace AFMProj.PlugIn
{
    /// <summary>
    /// Summary description for dSensor
    /// </summary>
    public class cReset : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            ExecCmd(context);
            context.Response.End();
        }
        private void ExecCmd(HttpContext context)
        {
            var id = cUsr.GetIdentity(context.Request["token"]);

            if (!id.IsVerify)
            {
                context.Response.Write("Error");
            }
            string url = "http://202.125.84.53/rms/" + context.Request["uuid"] + "/service/reset.php?index=" + context.Request["index"];
            //218
            if (context.Request["uuid"] == "218")
            {
                string index = context.Request["index"];
                string pin = "";
                if (index == "1") pin = "2";
                if (index == "2") pin = "3";
                if (pin == "")
                    return;
                url = "http://209.15.109.126/afm/mango/relay.ashx?uuid=" + context.Request["uuid"] + "&pin=" + pin + "&status=2";
            }

            try
            {
                using (WebClient wc = new WebClient())
                {
                    string result = wc.DownloadString(url);

                    context.Response.Write(result);

                    cUtils.Log("plugin", url + " " + result);
                }
            }
            catch (Exception ex)
            {
                context.Response.Write("Error");
                cUtils.Log("plugin", url + " " + ex.Message);
            }

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