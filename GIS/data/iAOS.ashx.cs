using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Drawing;


namespace EBMSMap30.data
{
    /// <summary>
    /// Summary description for iALT
    /// </summary>
    public class iAOS : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            DT2 dt2 = new DT2();
            Dictionary<int, List<DT2.PointAOS>> aosset = dt2.AOS(new DT2.Point()
            {
                X=Convert.ToDouble(context.Request["lng"]),
                Y=Convert.ToDouble(context.Request["lat"])
            }, Convert.ToDouble(context.Request["r"]));

            int w = 512;
            int h = 512;
            double Lat1 = Convert.ToDouble(context.Request["lat1"]);
            double Lat2 = Convert.ToDouble(context.Request["lat2"]);
            double Lng1 = Convert.ToDouble(context.Request["lng1"]);
            double Lng2 = Convert.ToDouble(context.Request["lng2"]);
            double resx = w / Math.Abs(Lng2 - Lng1);
            double resy = h / Math.Abs(Lat2 - Lat1);
            
            Bitmap bm = new Bitmap(w, h);
            Graphics g = Graphics.FromImage(bm);
            g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;

            foreach (var items in aosset)
            {
                foreach (var item in items.Value)
                {
                    PointF[] pf = new PointF[item.Polygon.Length];
                    for(int i=0;i<pf.Length;i++)
                    {
                        pf[i] = new PointF(
                            (float)((item.Polygon[i].X - Lng1) * resx),
                            h - (float)((item.Polygon[i].Y - Lat1) * resy)
                        );
                    }
                    if (item.isVis)
                    {
                        g.FillPolygon(new SolidBrush(Color.FromArgb(0,0xc0,0)), pf);
                        g.DrawLines(new Pen(new SolidBrush(Color.FromArgb(0,0xc0,0)),1), pf);
                    }
                    else
                    {
                        g.FillPolygon(new SolidBrush(Color.FromArgb(0xc0,0, 0)), pf);
                        g.DrawLines(new Pen(new SolidBrush(Color.FromArgb(0xc0,0, 0)), 1), pf);
                    }
                }
            }

            MemoryStream oStr = new MemoryStream();
            bm.Save(oStr, System.Drawing.Imaging.ImageFormat.Png);
            context.Response.ClearContent();
            context.Response.ContentType = "image/Png";
            context.Response.BinaryWrite(oStr.ToArray());
            oStr.Close();
            g.Dispose();
            bm.Dispose();
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