using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EBMSMap30.data
{
    /// <summary>
    /// Summary description for iALT
    /// </summary>
    public class iHST : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            DT2 dt2 = new DT2();
            DT2.PointD r = dt2.HST(new DT2.Point(){
                X=Convert.ToDouble(context.Request["lng1"]),
                Y=Convert.ToDouble(context.Request["lat1"])
            }, new DT2.Point()
            {
                X = Convert.ToDouble(context.Request["lng2"]),
                Y = Convert.ToDouble(context.Request["lat2"])
            });

            if (r.Z == -1e6) r.Z = 0;
            ReturnSet returnSet = new ReturnSet();
            returnSet.result = "OK";
            returnSet.datas = r;
            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            context.Response.Write(jSearializer.Serialize(returnSet));

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