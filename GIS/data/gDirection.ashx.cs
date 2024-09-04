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
    public class gDirection : IHttpHandler
    {
        DataSet DS = new DataSet();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            context.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
            context.Response.Charset = "UTF-8";
            Request(context);
           
        }

        private void Request(HttpContext context)
        {
            using (WebClient client = new WebClient())
            {
                var data = client.DownloadData("https://maps.googleapis.com/maps/api/directions/json?origin=" + context.Request["origin"] + "&destination=" + context.Request["destination"] + "&language=th&key=AIzaSyAXX_lmoHM0itEz1MKzqAj7GxA6zHkkcuk");
                string s = Encoding.UTF8.GetString(data);
                
                context.Response.Write(s);
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