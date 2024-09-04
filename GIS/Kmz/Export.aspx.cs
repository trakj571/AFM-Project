using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using SharpKml.Base;
using SharpKml.Dom;
using SharpKml.Engine;
using EBMSMap30;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO.Compression;

namespace AFMProj.GIS.Kmz
{
    public partial class Export : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ExportPOI();
        }

        private void ExportPOI()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spPOI_Gets]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@LyIDs", SqlDbType.VarChar, Request["poiid"].Length + 1);
            SqlCmd.SelectCommand.Parameters["@LyIDs"].Value = Request["poiid"];

            DataSet DS = new DataSet();

            SqlCmd.Fill(DS);
            SqlConn.Close();

            Document document = new Document();
            document.Name = "export.kml";
            document.Open = false;
            for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
            {
                if (cConvert.ToInt(DS.Tables[0].Rows[i]["PoiType"]) == 1)
                {

                    document.AddFeature(CreatePlacemark(DS.Tables[0].Rows[i]));
                }
                if (cConvert.ToInt(DS.Tables[0].Rows[i]["PoiType"]) == 2)
                {

                    document.AddFeature(CreateLinestring(DS.Tables[0].Rows[i]));
                }
                if (cConvert.ToInt(DS.Tables[0].Rows[i]["PoiType"]) == 3)
                {

                    document.AddFeature(CreatePolygon(DS.Tables[0].Rows[i]));
                }
                if (cConvert.ToInt(DS.Tables[0].Rows[i]["PoiType"]) == 4)
                {

                    document.AddFeature(CreateCircle(DS.Tables[0].Rows[i]));
                }
            }
            KmlFile kml = KmlFile.Create(document, false);
            KmzFile kmz = KmzFile.Create(kml);
            using (var ms = new MemoryStream())
            {
                kmz.Save(ms);

                Response.ClearContent();
                Response.AddHeader("Content-Disposition", "attachment; filename=kmz_export.kmz");

                Response.BinaryWrite(ms.ToArray());

            }
            Response.End();
        }

        private Placemark CreatePlacemark(DataRow dr)
        {
            string[] points = dr["Points"].ToString().Split(',');
            Point point = new Point();

            point.Coordinate = new Vector(cConvert.ToDouble(points[1]), cConvert.ToDouble(points[0]));

            // This is the Element we are going to save to the Kml file.
            Placemark placemark = new Placemark();
            placemark.Geometry = point;
            placemark.Name = dr["Name"].ToString();

            return placemark;
        }

        private Placemark CreateLinestring(DataRow dr)
        {
            string[] points = dr["Points"].ToString().Split(',');
            LineString line = new LineString();
            line.Coordinates = new CoordinateCollection();
            for (int i = 0; i < points.Length; i+=2)
            {
                line.Coordinates.Add(new Vector(cConvert.ToDouble(points[i+1]), cConvert.ToDouble(points[i])));
            }
            // This is the Element we are going to save to the Kml file.
           
            Placemark placemark = new Placemark();
            placemark.Geometry = line;
            placemark.Name = dr["Name"].ToString();

            var style = new Style();
            style.Line = new LineStyle();
            style.Line.ColorMode = SharpKml.Dom.ColorMode.Normal;
            System.Drawing.Color col = System.Drawing.ColorTranslator.FromHtml("#"+dr["LineColor"]);
            style.Line.Color = new Color32((byte)(cConvert.ToInt(dr["LineOpacity"])*255/100), col.B, col.G, col.R);
            style.Line.Width = cConvert.ToInt(dr["LineWidth"]);
            placemark.AddStyle(style);
            return placemark;
        }

        private Placemark CreatePolygon(DataRow dr)
        {
            string[] points = dr["Points"].ToString().Split(',');

            Polygon polygon = new Polygon();
            polygon.Extrude = true;
            polygon.AltitudeMode = AltitudeMode.ClampToGround;
            polygon.OuterBoundary = new OuterBoundary();
            polygon.OuterBoundary.LinearRing = new LinearRing();
            polygon.OuterBoundary.LinearRing.Coordinates = new CoordinateCollection();
            for (int i = 0; i < points.Length; i += 2)
            {
                polygon.OuterBoundary.LinearRing.Coordinates.Add(new Vector(cConvert.ToDouble(points[i + 1]), cConvert.ToDouble(points[i])));
            }
            // This is the Element we are going to save to the Kml file.

            Placemark placemark = new Placemark();
            placemark.Geometry = polygon;
            placemark.Name = dr["Name"].ToString();

            var style = new Style();
            style.Polygon = new PolygonStyle();
            style.Line = new LineStyle();
            style.Line.ColorMode = SharpKml.Dom.ColorMode.Normal;
            System.Drawing.Color col = System.Drawing.ColorTranslator.FromHtml("#" + dr["LineColor"]);
            System.Drawing.Color col2 = System.Drawing.ColorTranslator.FromHtml("#" + dr["FillColor"]);
            style.Line.Color = new Color32((byte)(cConvert.ToInt(dr["LineOpacity"]) * 255 / 100), col.B, col.G, col.R);
            style.Polygon.Color = new Color32((byte)(cConvert.ToInt(dr["FillOpacity"]) * 255 / 100), col2.B, col2.G, col2.R);
            style.Line.Width = cConvert.ToInt(dr["LineWidth"]);
            placemark.AddStyle(style);
            return placemark;
        }

        private Placemark CreateCircle(DataRow dr)
        {
            string[] points = dr["Points"].ToString().Split(',');

            Polygon polygon = new Polygon();
            polygon.Extrude = true;
            polygon.AltitudeMode = AltitudeMode.ClampToGround;
            polygon.OuterBoundary = new OuterBoundary();
            polygon.OuterBoundary.LinearRing = new LinearRing();
            polygon.OuterBoundary.LinearRing.Coordinates = new CoordinateCollection();
            
            double Latitud = deg2rad(cConvert.ToDouble(points[1]));
            double Longitud = deg2rad(cConvert.ToDouble(points[0]));
            double d_rad = (cConvert.ToDouble(dr["Radius"]) / 6378137);
            for (int j = 0; j <= 360; j++)
            {
                double radial = (Math.PI * j) / 180;
                double lat_rad = Math.Asin((Math.Sin(Latitud) * Math.Cos(d_rad)) + (Math.Cos(Latitud) * Math.Sin(d_rad) * Math.Cos(radial)));
                double dlon_rad = Math.Atan2(Math.Sin(radial) * Math.Sin(d_rad) * Math.Cos(Latitud), Math.Cos(d_rad) - Math.Sin(Latitud) * Math.Sin(lat_rad));
                double lon_rad = ((Longitud + dlon_rad + Math.PI) % (2 * Math.PI)) - Math.PI;
                polygon.OuterBoundary.LinearRing.Coordinates.Add(new Vector(rad2deg(lat_rad), rad2deg(lon_rad)));
            }

            Placemark placemark = new Placemark();
            placemark.Geometry = polygon;
            placemark.Name = dr["Name"].ToString();

            var style = new Style();
            style.Polygon = new PolygonStyle();
            style.Line = new LineStyle();
            style.Line.ColorMode = SharpKml.Dom.ColorMode.Normal;
            System.Drawing.Color col = System.Drawing.ColorTranslator.FromHtml("#" + dr["LineColor"]);
            System.Drawing.Color col2 = System.Drawing.ColorTranslator.FromHtml("#" + dr["FillColor"]);
            style.Line.Color = new Color32((byte)(cConvert.ToInt(dr["LineOpacity"]) * 255 / 100), col.B, col.G, col.R);
            style.Polygon.Color = new Color32((byte)(cConvert.ToInt(dr["FillOpacity"]) * 255 / 100), col2.B, col2.G, col2.R);
            style.Line.Width = cConvert.ToInt(dr["LineWidth"]);
            placemark.AddStyle(style);
            return placemark;
        }

            private double deg2rad(double deg)
       {
           return Math.PI* deg / 180;
       }
       private double rad2deg(double rad)
       {
           return rad *(180 / Math.PI);
       }

    }
}