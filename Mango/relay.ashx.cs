using EBMSMap30;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;

namespace AFMProj.Mango
{
    /// <summary>
    /// Summary description for relay
    /// </summary>
    public class relay : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            if (context.Request["uuid"] != "218")
            {
                context.Response.Write("Error");
                context.Response.End();
            }
            string url = "http://10.8.0.163/cgi-bin/relay?pin="+ context.Request["pin"] +"&status=" + context.Request["status"];
            try
            {
                using (WebClient wc = new WebClient())
                {
                    string result = wc.DownloadString(url);

                    context.Response.Write(result);

                    cUtils.Log("relay", url + " " + result);
                    context.Response.Write("OK");
                }
            }
            catch (Exception ex)
            {
                context.Response.Write("Error");
                cUtils.Log("relay", url + " " + ex.Message);
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