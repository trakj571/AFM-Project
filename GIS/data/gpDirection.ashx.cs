using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Net;

namespace EBMSMap30.data
{
    /// <summary>
    /// Summary description for dBoundInfo
    /// </summary>
    public class gpDirection : IHttpHandler
    {
        DataSet DS = new DataSet();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            Request(context);
           
        }

        private void Request(HttpContext context)
        {
            using (WebClient client = new WebClient())
            {
                var data = client.DownloadData("https://maps.googleapis.com/maps/api/directions/json?origin=" + context.Request["origin"] + "&destination=" + context.Request["destination"] + "&language=th&key=AIzaSyAXX_lmoHM0itEz1MKzqAj7GxA6zHkkcuk");
                string s = Encoding.UTF8.GetString(data);
                
                context.Response.Write("jDirCallBack(" + s + ");");
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