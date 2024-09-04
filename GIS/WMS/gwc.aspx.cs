using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;
using System.IO;
using System.Drawing.Drawing2D;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Drawing.Imaging;
using System.Net;
using Image = System.Drawing.Image;
using System.Collections;

namespace EBMSMap30.WMS
{
    public partial class gwc : System.Web.UI.Page
    {
        string[] layers = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            //string[] BBox = Request.QueryString["BBox"].Split(',');
            int z = Convert.ToInt32(Request.QueryString["z"]);
            int x = Convert.ToInt32(Request.QueryString["x"]);
            int y = Convert.ToInt32(Request.QueryString["y"]);

            layers = Request.QueryString["layers"].Split(',');

            Bitmap bm = new Bitmap(256, 256);
            Graphics g = Graphics.FromImage(bm);
            g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;

            DrawGwc(g);   
            
            
           
            MemoryStream oStr = new MemoryStream();
            bm.Save(oStr, System.Drawing.Imaging.ImageFormat.Png);
            Response.ClearContent();
            Response.ContentType = "image/Png";
            Response.BinaryWrite(oStr.ToArray());
            oStr.Close();
            g.Dispose();
            bm.Dispose();
        }
        private void DrawGwc(Graphics g)
        {
            foreach (string alayer in layers)
            {
                if (alayer == "") continue;
               

                string LName = alayer;

                var alayer1 = alayer.ToLower();

                if (alayer1.StartsWith("afm-equip") || alayer1.StartsWith("afm-wifi"))
                {
                    DrawAFM(g, alayer1);
                    continue;
                }
                else if (alayer1.StartsWith("afm-eqpnt_station") || alayer1.StartsWith("afm-eqpnt_fmr"))
                {
                    DrawAFM(g, alayer1);
                    continue;
                }
                else if (alayer1.StartsWith("afm-rmtrad"))
                {
                    DrawRMTRad(g, alayer1);
                    continue;
                }

                var geoserver = "GeoServerURL_1";
                if (LName.ToLower().StartsWith("afm-oper") || LName.ToLower().StartsWith("afm-tracking")
                    || LName.ToLower().StartsWith("afm-stn2") || LName.ToLower().StartsWith("afm-nsmc"))
                    geoserver = "GeoServerURL";
                //string url = ConfigurationManager.AppSettings[geoserver] + "/geoserver/gwc/service/gmaps?layers={L}&zoom={Z}&x={X}&y={Y}";
                string url = ConfigurationManager.AppSettings[geoserver] + "/geoserver/gwc/service/tms/1.0.0/{L}@EPSG%3A900913@png/{Z}/{X}/{Y}.png";
                
                url = url.Replace("{L}", LName.Replace("-",":"));
                url = url.Replace("{Z}", Request.QueryString["z"]);
                url = url.Replace("{X}", Request.QueryString["X"]);
                url = url.Replace("{Y}", Request.QueryString["Y"]);

                //cUtils.Log("gwc", url);
                try
                {
                    WebClient wc = new WebClient();
                    Stream strm = wc.OpenRead(url);
                    System.Drawing.Image img = Bitmap.FromStream(strm);
                    g.DrawImage(img, 0, 0);


                    strm.Close();
                    img.Dispose();

                    if (alayer1.StartsWith("afm-tracking"))
                    {
                        DrawChk(g, alayer1);
                        continue;
                    }

                }
                catch (Exception)
                {
                    //Response.WriteFile(@"D:\ebmsData\Tiles\Blank.png");
                }
            }
        }

        private void DrawChk(Graphics g,string alayer)
        {
            int z = Convert.ToInt32(Request.QueryString["z"]);
            int x = Convert.ToInt32(Request.QueryString["x"]);
            int y = Convert.ToInt32(Request.QueryString["y"]);
            if (z < 14) return;
            DataSet DS;
            string cacheName = "DS_Stn_Chk";
            if (Cache[cacheName] != null)
            {
                DS = Cache[cacheName] as DataSet;
            }
            else
            {
                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
                SqlDataAdapter SqlCmd = new SqlDataAdapter("spStn_GwcChk", SqlConn);
                SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

                DS = new DataSet();
                SqlCmd.Fill(DS);
                SqlConn.Close();

                Cache.Insert(cacheName, DS, null, DateTime.Now.AddMinutes(60), TimeSpan.Zero);
            }
            
            
           
            RectangleF rectf = GoogleTileUtils.getTileRect(x, y, z);
            double Lng1 = rectf.X;
            double Lat1 = -rectf.Y - rectf.Height;
            double Lng2 = rectf.X + rectf.Width;
            double Lat2 = -rectf.Y;

            RectangleF rectf1 = GoogleTileUtils.getTileRect(x-1, y-1, z);
            double bLng1 = rectf1.X;
            double bLat1 = -rectf1.Y - rectf.Height;
            RectangleF rectf2 = GoogleTileUtils.getTileRect(x + 1, y + 1, z);

            double bLng2 = rectf2.X  + rectf2.Width;
            double bLat2 = -rectf2.Y;

          
            int zoom = z;

            string[] alayers = alayer.Split(':');
          
            DataTable tbS = DS.Tables[0];
            Bitmap bm0 = new Bitmap(256, 256);
            Graphics g0 = Graphics.FromImage(bm0);
            g0.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;

            Point pixel0 = GoogleTileUtils.toZoomedPixelCoords(Lat2, Lng1, zoom);
            Image iChkAll = Image.FromFile(Server.MapPath("images") + @"\allchk.png");
            Image iNotAll = Image.FromFile(Server.MapPath("images") + @"\notall.png");
            Image iNotPass = Image.FromFile(Server.MapPath("images") + @"\notpass.png");

            for (int i = 0; i < tbS.Rows.Count; i++)
            {
                if (tbS.Rows[i]["Layer"].ToString() != alayer)
                    continue;

                double lat = Convert.ToDouble(tbS.Rows[i]["Lat"]);
                double lng = Convert.ToDouble(tbS.Rows[i]["Lng"]);
             
                if (lat < bLat1 || lat > bLat2 || lng < bLng1 || lng > bLng2)
                    continue;

               
                Color FillColor = Color.Green;
                Point pixelCoords = GoogleTileUtils.toZoomedPixelCoords(lat, lng, zoom);
                float X = pixelCoords.X - pixel0.X;
                float Y = pixelCoords.Y - pixel0.Y;

                //g0.DrawString("*",new Font("Tahoma",16), new SolidBrush(FillColor), X,Y-20);
                if(tbS.Rows[i]["IsPass"].ToString()=="Y")
                    g0.DrawImage(iChkAll, X, Y-17, 10, 10);
                else if (tbS.Rows[i]["IsPass"].ToString() == "S")
                    g0.DrawImage(iNotAll, X, Y - 17, 10, 10);
                else if (tbS.Rows[i]["IsPass"].ToString() == "N")
                    g0.DrawImage(iNotPass, X, Y - 17, 10, 10);
            }

            g.DrawImage(bm0, 0, 0);
            g0.Dispose();
            bm0.Dispose();

        }

        ArrayList existText = new ArrayList();
        private void DrawAFM(Graphics g, string alayer)
        {
            int z = Convert.ToInt32(Request.QueryString["z"]);
            int x = Convert.ToInt32(Request.QueryString["x"]);
            int y = Convert.ToInt32(Request.QueryString["y"]);
            //if (z < 14) return;
            DataSet DS;
            string cacheName = "DS_AFM_POI";
            if (Cache[cacheName] != null)
            {
                DS = Cache[cacheName] as DataSet;
            }
            else
            {
                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
                SqlDataAdapter SqlCmd = new SqlDataAdapter("spAFM_GwcPOI", SqlConn);
                SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

                DS = new DataSet();
                SqlCmd.Fill(DS);
                SqlConn.Close();

                Cache.Insert(cacheName, DS, null, DateTime.Now.AddMinutes(1), TimeSpan.Zero);
            }

            var font = new Font("Cordia New", 18, FontStyle.Regular);

            RectangleF rectf = GoogleTileUtils.getTileRect(x, y, z);
            double Lng1 = rectf.X;
            double Lat1 = -rectf.Y - rectf.Height;
            double Lng2 = rectf.X + rectf.Width;
            double Lat2 = -rectf.Y;

            RectangleF rectf1 = GoogleTileUtils.getTileRect(x - 1, y - 1, z);
            double bLng1 = rectf1.X;
            double bLat1 = -rectf1.Y - rectf.Height;
            RectangleF rectf2 = GoogleTileUtils.getTileRect(x + 1, y + 1, z);

            double bLng2 = rectf2.X + rectf2.Width;
            double bLat2 = -rectf2.Y;


            int zoom = z;

            string[] alayers = alayer.Split(':');

            DataTable tbS = DS.Tables[0];
            Bitmap bm0 = new Bitmap(256, 256);
            Graphics g0 = Graphics.FromImage(bm0);
            g0.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;

            Bitmap bm1 = new Bitmap(256, 256);
            Graphics g1 = Graphics.FromImage(bm1);
            g1.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;

            Bitmap bm2 = new Bitmap(256, 256);
            Graphics g2 = Graphics.FromImage(bm2);
            g2.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;

            Point pixel0 = GoogleTileUtils.toZoomedPixelCoords(Lat2, Lng1, zoom);

            var tbImage = new Dictionary<string, Image>();
            tbImage.Add("equip_remote", Image.FromFile(Server.MapPath("images") + @"\equip_remote.png"));
            tbImage.Add("equip_afm", Image.FromFile(Server.MapPath("images") + @"\equip_afm.png"));
            tbImage.Add("equip_fmr", Image.FromFile(Server.MapPath("images") + @"\equip_fmr.png"));
             tbImage.Add("wifi_poi", Image.FromFile(Server.MapPath("images") + @"\wifi_poi.png"));
            tbImage.Add("wifi_village", Image.FromFile(Server.MapPath("images") + @"\wifi_village.png"));
            var tbColor = new Dictionary<string, Brush>();
            tbColor.Add("equip_remote", Brushes.Yellow);
            tbColor.Add("equip_afm", Brushes.DarkGreen);
            tbColor.Add("equip_fmr", Brushes.DeepPink);

            tbImage.Add("eqpnt_station", Image.FromFile(Server.MapPath("images") + @"\equip_remote.png"));
            tbImage.Add("eqpnt_fmr2", Image.FromFile(Server.MapPath("images") + @"\equip_fmr2.png"));
            tbImage.Add("eqpnt_fmr3", Image.FromFile(Server.MapPath("images") + @"\equip_fmr3.png"));

            tbColor.Add("eqpnt_station", Brushes.Yellow);
            tbColor.Add("eqpnt_fmr2", Brushes.Blue);
            tbColor.Add("eqpnt_fmr3", Brushes.Red);

            for (int i = 0; i < tbS.Rows.Count; i++)
            {
                if ("afm-" + tbS.Rows[i]["Layer"].ToString() != alayer)
                    continue;

                double lat = Convert.ToDouble(tbS.Rows[i]["Lat"]);
                double lng = Convert.ToDouble(tbS.Rows[i]["Lng"]);
                int km = cConvert.ToInt(tbS.Rows[i]["Coverage"]);

                if (km == 0 && (lat < bLat1 || lat > bLat2 || lng < bLng1 || lng > bLng2))
                    continue;

                DT2.Point pt = new DT2.Point();
                pt.X = lng;
                pt.Y = lat;
                var p1 = cMath.FromKmToNPosition(pt, km);
                var p2 = cMath.FromKmToSPosition(pt, km);
                var p3 = cMath.FromKmToWPosition(pt, km);
                var p4 = cMath.FromKmToEPosition(pt, km);

                if (p1.Y < bLat1 || p2.Y > bLat2 || p4.X < bLng1 || p3.X > bLng2)
                    continue;


                Point pixelCoords1 = GoogleTileUtils.toZoomedPixelCoords(p1.Y, p3.X, zoom);
                Point pixelCoords2 = GoogleTileUtils.toZoomedPixelCoords(p2.Y, p4.X, zoom);
                if (tbColor.ContainsKey(tbS.Rows[i]["Layer"].ToString()))
                {
                    g0.FillEllipse(tbColor[tbS.Rows[i]["Layer"].ToString()], pixelCoords1.X - pixel0.X, pixelCoords1.Y - pixel0.Y, pixelCoords2.X - pixelCoords1.X, pixelCoords2.Y - pixelCoords1.Y);
                    g0.DrawEllipse(Pens.Black, pixelCoords1.X - pixel0.X, pixelCoords1.Y - pixel0.Y, pixelCoords2.X - pixelCoords1.X, pixelCoords2.Y - pixelCoords1.Y);
                }


                Point pixelCoords = GoogleTileUtils.toZoomedPixelCoords(lat, lng, zoom);
                float X = pixelCoords.X - pixel0.X;
                float Y = pixelCoords.Y - pixel0.Y;

                g1.DrawImage(tbImage[tbS.Rows[i]["Layer"].ToString()], X - 5, Y - 5, 10, 10);



                if (zoom >= 6)
                {
                    string bld = tbS.Rows[i]["Name"].ToString();
                    var size = g2.MeasureString(bld, font);
                    var rect = new RectangleF(X - size.Width / 2, Y + 3, size.Width, size.Height);
                    bool isdraw = true;
                    foreach (RectangleF rectx in existText)
                    {
                        if (rectx.IntersectsWith(rect))
                            isdraw = false;
                    }
                    if (isdraw)
                    {
                        existText.Add(rect);
                        GraphicsPath path = new GraphicsPath(FillMode.Alternate);

                        using (StringFormat sf = new StringFormat())
                        {
                            sf.Alignment = StringAlignment.Center;
                            sf.LineAlignment = StringAlignment.Center;
                            path.AddString(bld, font.FontFamily,
                                (int)FontStyle.Regular, 18, rect, sf);
                        }


                        // Fill and draw the path.
                        //g0.FillPath(Brushes.White, path);
                        using (Pen pen = new Pen(Color.White, 3))
                        {
                            g2.DrawPath(pen, path);
                        }
                        using (Pen pen = new Pen(Color.FromArgb(0x33, 0x33, 0x33), 1))
                        {
                            g2.DrawPath(pen, path);
                        }
                    }
                }
            }
            SetImageOpacity(g, bm0, 0.20f);

            g.DrawImage(bm1, 0, 0);
            g.DrawImage(bm2, 0, 0);
            g2.Dispose();
            bm2.Dispose();

            g0.Dispose();
            bm0.Dispose();

            g1.Dispose();
            bm1.Dispose();

        }


        private void DrawRMTRad(Graphics g, string alayer)
        {
            int z = Convert.ToInt32(Request.QueryString["z"]);
            int x = Convert.ToInt32(Request.QueryString["x"]);
            int y = Convert.ToInt32(Request.QueryString["y"]);
            //if (z < 14) return;
            DataSet DS;
            string cacheName = "DS_AFM_RMT";
            if (Cache[cacheName] != null)
            {
                DS = Cache[cacheName] as DataSet;
            }
            else
            {
                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
                SqlDataAdapter SqlCmd = new SqlDataAdapter("spRMT_StnGwc", SqlConn);
                SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

                DS = new DataSet();
                SqlCmd.Fill(DS);
                SqlConn.Close();

                Cache.Insert(cacheName, DS, null, DateTime.Now.AddMinutes(60), TimeSpan.Zero);
            }

          
            RectangleF rectf = GoogleTileUtils.getTileRect(x, y, z);
            double Lng1 = rectf.X;
            double Lat1 = -rectf.Y - rectf.Height;
            double Lng2 = rectf.X + rectf.Width;
            double Lat2 = -rectf.Y;

            RectangleF rectf1 = GoogleTileUtils.getTileRect(x - 1, y - 1, z);
            double bLng1 = rectf1.X;
            double bLat1 = -rectf1.Y - rectf.Height;
            RectangleF rectf2 = GoogleTileUtils.getTileRect(x + 1, y + 1, z);

            double bLng2 = rectf2.X + rectf2.Width;
            double bLat2 = -rectf2.Y;


            int zoom = z;

            string[] alayers = alayer.Split(':');

            DataTable tbP = DS.Tables[0];
            DataTable tbS = DS.Tables[1];
            Bitmap bm0 = new Bitmap(256, 256);
            Graphics g0 = Graphics.FromImage(bm0);
            g0.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;
            Bitmap bm1 = new Bitmap(256, 256);
            Graphics g1 = Graphics.FromImage(bm1);
            g1.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;

            Point pixel0 = GoogleTileUtils.toZoomedPixelCoords(Lat2, Lng1, zoom);
            for (int i = 0; i < tbP.Rows.Count; i++)
            {
                double lat1 = Convert.ToDouble(tbP.Rows[i]["Lat1"]);
                double lng1 = Convert.ToDouble(tbP.Rows[i]["Lng1"]);
                double lat2 = Convert.ToDouble(tbP.Rows[i]["Lat2"]);
                double lng2 = Convert.ToDouble(tbP.Rows[i]["Lng2"]);

                if ((lat2 < Lat1 || lat1 > Lat2 || lng2< Lng1 || lng1 > Lng2))
                {
                    continue;
                }
                var dr = tbS.Select("PoiID=" + tbP.Rows[i]["PoiID"], "Angle");
                PointF[] points = new PointF[dr.Length];
                for(int j=0; j < dr.Length; j++)
                {
                    double lat = Convert.ToDouble(dr[j]["rLat"]);
                    double lng = Convert.ToDouble(dr[j]["rLng"]);
                    Point pixelCoords = GoogleTileUtils.toZoomedPixelCoords(lat, lng, zoom);
                    float X = pixelCoords.X - pixel0.X;
                    float Y = pixelCoords.Y - pixel0.Y;
                    points[j] = new PointF(X, Y);
                }
                g0.FillPolygon(new SolidBrush(Color.FromArgb(50, Color.Orange)), points);
                g1.DrawPolygon(Pens.Orange, points);
               
            }
           

            SetImageOpacity(g, bm0, 1f);

            g.DrawImage(bm1, 0, 0);
            g0.Dispose();
            bm0.Dispose();
            g1.Dispose();
            bm1.Dispose();

        }


        public void SetImageOpacity(Graphics gfx,Bitmap image, float opacity)
        {
            try
            {
                ColorMatrix matrix = new ColorMatrix();

                //set the opacity  
                matrix.Matrix33 = opacity;

                //create image attributes  
                ImageAttributes attributes = new ImageAttributes();

                //set the color(opacity) of the image  
                attributes.SetColorMatrix(matrix, ColorMatrixFlag.Default, ColorAdjustType.Bitmap);

                //now draw the image  
                gfx.DrawImage(image, new Rectangle(0, 0, image.Width, image.Height), 0, 0, image.Width, image.Height, GraphicsUnit.Pixel, attributes);

            }
            catch (Exception)
            {
                
               
            }
        }

    }
}