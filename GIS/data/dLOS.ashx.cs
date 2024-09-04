using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Drawing;
using System.Drawing.Text;
using System.IO;
using System.Drawing.Drawing2D;

namespace EBMSMap30.data
{
    /// <summary>
    /// Summary description for iLos
    /// </summary>
    public class dLOS : IHttpHandler
    {
        
        public void ProcessRequest(HttpContext context)
        {
            int w = (int)cConvert.ToDouble(context.Request.QueryString["w"]);
            int h = (int)cConvert.ToDouble(context.Request.QueryString["h"]);
            string[] points = context.Request.QueryString["points"].Split(',');
            string cacheName = "dt_Los" + context.Request.QueryString["points"] + "_" + w + "_" + h + "_";
            DT2 dt2 = new DT2();

            List<List<DT2.Point>> _Result = null;
            List<DT2.Point> _Points = new List<DT2.Point>();
            for (int i = 0; i < points.Length; i += 2)
            {
                _Points.Add(new DT2.Point() { X = Convert.ToDouble(points[i]), Y = Convert.ToDouble(points[i + 1]) });
            }

            if (context.Cache[cacheName] != null)
            {
                _Result = context.Cache[cacheName] as List<List<DT2.Point>>;
            }
            else
            {
                _Result = dt2.LOS(_Points);
                context.Cache.Insert(cacheName, _Result, null, DateTime.Now.AddMinutes(5), TimeSpan.Zero);
            }

            List<string> z = new List<string>();
            foreach (var list_pnts in _Result)
            {
                foreach (var pnt in list_pnts)
                {
                    if (pnt.Z < -1e6 || pnt.Z > 1e6)
                        z.Add("-");
                    else
                        z.Add(string.Format("{0:0.00}", pnt.Z));
                }
            }

            ReturnSet returnSet = new ReturnSet();
            returnSet.result = "OK";
            returnSet.datas = z;
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