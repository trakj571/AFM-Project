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
    public class iDeep : IHttpHandler
    {
        
        public void ProcessRequest(HttpContext context)
        {
            int w = Convert.ToInt32(context.Request.QueryString["w"]);
            int h = Convert.ToInt32(context.Request.QueryString["h"]);
            string[] points = context.Request.QueryString["points"].Split(',');
            string dt = context.Request.QueryString["dt"];

            string cacheName = "dt_Deep" + context.Request.QueryString["points"] + "_" + w + "_" + h + "_" + dt;
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
                 _Result = dt2.DEEP(_Points,dt);
                context.Cache.Insert(cacheName, _Result, null, DateTime.Now.AddMinutes(5), TimeSpan.Zero);
            }
            Bitmap bm = new Bitmap(w, h);
            Graphics g = Graphics.FromImage(bm);
            g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;
            g.TextRenderingHint = TextRenderingHint.AntiAlias;

            g.DrawLine(new Pen(Brushes.LightGray,0.5f), 45, 25, w - 15, 25);
            g.DrawLine(new Pen(Brushes.LightGray, 0.5f), 45, 45, w - 15, 45);
            g.DrawLine(new Pen(Brushes.LightGray, 0.5f), 45, 65, w - 15, 65);
            g.DrawLine(new Pen(Brushes.LightGray, 0.5f), 45, 85, w - 15, 85);
            g.DrawLine(new Pen(Brushes.LightGray, 0.5f), 45, 105, w - 15, 105);

           float x = 50;
            float y = 105;
            float xstep = (float)(w - 50 - 20) / 1000;
            double[] Zmaxmin = GetMaxMinZ(_Result);
            if (Zmaxmin[0] > 0) Zmaxmin[0] = 0;
            double dZ = Math.Ceiling(Zmaxmin[1] - Zmaxmin[0]);
           
            if (dZ < 5) dZ = 5;
            int n = 0;
            for (int i = 0; i < _Result.Count; i++)
            {
                n += _Result[i].Count;
            }
            PointF[] lineSegment = new PointF[n+2];
            PointF[] dotSegment = new PointF[_Result.Count-1];
            lineSegment[0] = new PointF(x, 5);
            int k = 1;

            int ii = 0;
            foreach (var list_pnts in _Result)
            {
                int jj = 0;
                foreach (var pnt in list_pnts)
                {
                    if (pnt.Z < -1e6 || pnt.Z > 1e6)
                        pnt.Z = Zmaxmin[0];
                    lineSegment[k] = new PointF(x, y - (float)((pnt.Z - Zmaxmin[0]) * (y - 5) / dZ));
                    x += xstep;
                    k++;

                    if (jj == list_pnts.Count - 1 && ii < _Result.Count-1)
                        dotSegment[ii] = new PointF(x, y - (float)((pnt.Z - Zmaxmin[0]) * (y - 5) / dZ));
                    jj++;
                }
                ii++;
            }

            lineSegment[k] = new PointF(x, 5);
            //if (Math.Ceiling(Zmaxmin[1] - Zmaxmin[0]) != 0)
            {
                g.FillPolygon(Brushes.LightSkyBlue, lineSegment);
                g.DrawLines(Pens.Black, lineSegment);
            }
            for (int i = 0; i < dotSegment.Length; i++)
            {
                g.FillRectangle(new SolidBrush(Color.FromArgb(0xFF, 0xAD, 0xD8, 0xE6)), dotSegment[i].X - 4, dotSegment[i].Y - 4, 8, 8);
                g.DrawRectangle(Pens.Blue, dotSegment[i].X - 4, dotSegment[i].Y - 4, 8, 8);

            }

            //Y Scale
            double yScale = 1;
            yScale = (int)(dZ / 5);

            Font font = new Font("tahoma",8,FontStyle.Regular);
            g.DrawString(string.Format("{0:0} m", Zmaxmin[0]), font, Brushes.Black, 5, 97);
            g.DrawString(string.Format("{0:0} m", Zmaxmin[0] + yScale), font, Brushes.Black, 5, 77);
            g.DrawString(string.Format("{0:0} m", Zmaxmin[0] + 2 * yScale), font, Brushes.Black, 5, 57);
            g.DrawString(string.Format("{0:0} m", Zmaxmin[0] + 3 * yScale), font, Brushes.Black, 5, 37);
            g.DrawString(string.Format("{0:0} m", Zmaxmin[0] + 4 * yScale), font, Brushes.Black, 5, 17);

            int nx = 10;
            if (w < 400)
                nx = 5;
            double dist = 0;
            for (int i = 1; i < _Points.Count; i++)
            {
                dist += cMath.Distance(_Points[i - 1], _Points[i]);
            }
            int xScale = (int)(dist / nx);
            
            g.DrawLine(Pens.Black, 50, 105, 50, 109);
            for (int i = 1; i < nx; i++)
            {
                string tbx = "";
                if (dist < 1000)
                    tbx = String.Format("{0:#,##0} m", i * xScale);
                else if (dist < 10000)
                    tbx = String.Format("{0:#,##0.0} km", (double)(i * xScale) / 1000);
                else
                    tbx = String.Format("{0:#,##0.0} km", i * xScale / 1000);

                g.DrawLine(Pens.Black, 50 + i * (w - 50 - 20) / nx, 105, 50 + i * (w - 50 - 20) / nx, 109);
                g.DrawString(tbx, font, Brushes.Black, 50 + i * (w - 50 - 20) / nx - g.MeasureString(tbx, font).Width / 2, 110);
            }
            g.DrawLine(Pens.Black, w - 20, 105, w - 20, 109);

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



        private double[] GetMaxMinZ(List<List<DT2.Point>> _Result)
        {
            double maxz = double.MinValue;
            double minz = double.MaxValue;
            foreach (var list_pnts in  _Result)
            {
                foreach (var pnt in list_pnts)
                {
                    if (pnt.Z < -1e6 || pnt.Z>1e6) continue;
                    maxz = Math.Max(maxz, pnt.Z);
                    minz = Math.Min(minz, pnt.Z);
                }
              
            }
            return new double[] { minz, maxz };
        }

        
    }
}