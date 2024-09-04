using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.Net;

namespace EBMSMap30.data
{
    /// <summary>
    /// Summary description for dGISDef
    /// </summary>
    public class dRoute : IHttpHandler
    {
        DataSet DS = new DataSet();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            using (WebClient wc = new WebClient())
            {
                var data = (new WebClient()).DownloadData("https://mmmap15.longdo.com/mmroute/geojson/route?flon=" + context.Request["flon"] + "&flat=" + context.Request["flat"] + "&tlon=" + context.Request["tlon"] + "&tlat=" + context.Request["tlat"] + "&key=6906c0ee48f7220655e6436a20a49aab");
                var text = System.Text.Encoding.UTF8.GetString(data);
                context.Response.Write(text);
            }
            context.Response.End();
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