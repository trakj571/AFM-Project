using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using EBMSMap30;
using System.Net;
using System.Threading;

namespace AFMProj.FMS.data
{
    /// <summary>
    /// Summary description for dSensor
    /// </summary>
    public class cReset : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            if(context.Request["index"]=="0")
                ExecCmd(context);
            if (context.Request["index"] == "1")
                ExecCmd1(context);
            context.Response.End();
        }
        private void ExecCmd(HttpContext context)
        {   
            try
            {
                using (WebClient wc = new WebClient())
                {
                    string result = wc.DownloadString("http://lmtr.nbtc.go.th/afm/1.01/" + context.Request["poiid"] + "/service/stream_reset.php");
                    context.Response.Write(result);
                }
            }
            catch (Exception) {
                context.Response.Write("Error");
            }
            
        }
        private void ExecCmd1(HttpContext context)
        {
            try
            {
                using (WebClient wc = new WebClient())
                {
                    wc.Headers[HttpRequestHeader.ContentType] = "application/x-www-form-urlencoded";
                    string result = wc.UploadString("http://lmtr.nbtc.go.th/afm/1.01/" + context.Request["poiid"] + "/service/set.php","POST", "name=Power&value=1");
                    //context.Response.Write(result);
                }
                Thread.Sleep(5 * 1000);
               
                using (WebClient wc = new WebClient())
                {
                    wc.Headers[HttpRequestHeader.ContentType] = "application/x-www-form-urlencoded";
                    string result = wc.UploadString("http://lmtr.nbtc.go.th/afm/1.01/" + context.Request["poiid"] + "/service/set.php", "POST", "name=Power&value=0");
                    context.Response.Write(result);
                }
            }
            catch (Exception)
            {
                context.Response.Write("Error");
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