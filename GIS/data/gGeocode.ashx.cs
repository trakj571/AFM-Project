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
    public class gGeocode : IHttpHandler
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
                //client.Headers[HttpRequestHeader.UserAgent] = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.874.121 Safari/535.2";
                var data = client.DownloadData("https://maps.googleapis.com/maps/api/geocode/json?address=" + context.Request["kw"] + "&key=AIzaSyAXX_lmoHM0itEz1MKzqAj7GxA6zHkkcuk");
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