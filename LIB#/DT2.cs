using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace EBMSMap30
{
    public class DT2
    {
        public class Point
        {
            public Point() { }
            public Point(double X, double Y, double Z) {
                this.X = X;
                this.Y = Y;
                this.Z = Z;
            }
            public double X { get; set; }
            public double Y { get; set; }
            public double Z { get; set; }
        }
        public class PointD
        {
            public double X { get; set; }
            public double Y { get; set; }
            public double Z { get; set; }
        }
        public class PointAOS
        {
            public Point C { get; set; }
            public PointD[] Polygon { get; set; }
            public bool isVis { get; set; }
        }
        public class AOSSet
        {
            public object Inv { get; set; }
            public object Vis { get; set; }
        }
        double _Res = 1000.0;

        string DTED_FILE = "";//ConfigurationManager.AppSettings["EBMSData"] + @"\Dted_tif\smp.tif";

        #region LOS
        public List<List<Point>> LOS(List<Point> points)
        {
            Dictionary<string, List<Point>> dict = new Dictionary<string, List<Point>>();
            List<List<Point>> dted_points = new List<List<Point>>();

            if (points.Count < 2)
                return dted_points;

            //prepare data
            double totalradius = TotalRadius(points);
            double step = totalradius / _Res;

            for (int i = 1; i < points.Count; i++)
            {
                var p1 = points[i - 1] as Point;
                var p2 = points[i] as Point;
                List<Point> sub_dted_points = new List<Point>();
                double theta = Math.Atan2(p2.Y - p1.Y, p2.X - p1.X);
                double radius = Math.Sqrt((p2.Y - p1.Y) * (p2.Y - p1.Y) + (p2.X - p1.X) * (p2.X - p1.X));
                int n = (int)Math.Round(_Res / totalradius * radius);
                for (int j = 0; j < n; j++)
                {
                    Point p = new Point();
                    p.X = p1.X + (j * step * Math.Cos(theta));
                    p.Y = p1.Y + (j * step * Math.Sin(theta));
                    p.Z = -1;

                    sub_dted_points.Add(p);
                    string key = string.Format("{0:000}_{1:00}", Math.Floor(p.X), Math.Floor(p.Y));
                    if (dict.ContainsKey(key))
                    {
                        dict[key].Add(p);
                    }
                    else
                    {
                        List<Point> lp = new List<Point>();
                        lp.Add(p);
                        dict.Add(key, lp);
                    }
                }
                dted_points.Add(sub_dted_points);
            }
            //feach data
            foreach (var item in dict)
            {
                GetGrid(item.Key, item.Value);
            }

            return dted_points;
        }

        private void GetGrid(string key, List<Point> points)
        {
            if (DTED_FILE != "")
            {
                MapWinGIS.Grid grid = new MapWinGIS.Grid();
                grid.Open(DTED_FILE, MapWinGIS.GridDataType.UnknownDataType, true, MapWinGIS.GridFileType.GeoTiff, null);
                
                for (int i = 0; i < points.Count; i++)
                {
                    UTM utm = new UTM();
                    var zone = Math.Floor((points[i].X + 180.0) / 6) + 1;
                    double[] xy = new double[2];
                    utm.LatLonToUTMXY(utm.DegToRad(points[i].Y), utm.DegToRad(points[i].X), zone, xy);

                    int col = (int)Math.Round((xy[0] - grid.Header.XllCenter) / grid.Header.dX);
                    int row = grid.Header.NumberRows - 1 - (int)Math.Round((xy[1] - grid.Header.YllCenter) / grid.Header.dY);
                    points[i].Z = (double)grid.Value[col, row];
                }
                grid.Close();
            }
            else
            {
                string filepath = string.Format(@"{0}\DTED_lv2\e{1}\n{2}.dt2", ConfigurationManager.AppSettings["EBMSData"] , key.Split('_')[0], key.Split('_')[1]);
                MapWinGIS.Grid grid = new MapWinGIS.Grid();
                grid.Open(filepath, MapWinGIS.GridDataType.UnknownDataType, true, MapWinGIS.GridFileType.DTed, null);
                for (int i = 0; i < points.Count; i++)
                {
                    int col = (int)Math.Round((points[i].X - grid.Header.XllCenter) / grid.Header.dX);
                    int row = grid.Header.NumberRows - 1 - (int)Math.Round((points[i].Y - grid.Header.YllCenter) / grid.Header.dY);
                    points[i].Z = (int)grid.Value[col, row];
                    if (points[i].Z < 0)
                        points[i].Z = 0;
                }
                grid.Close();
            }
        }

        #endregion

        #region Deep
        public List<List<Point>> DEEP(List<Point> points,string dt)
        {
            Dictionary<string, List<Point>> dict = new Dictionary<string, List<Point>>();
            List<List<Point>> dted_points = new List<List<Point>>();

            if (points.Count < 2)
                return dted_points;

            //prepare data
            double totalradius = TotalRadius(points);
            double step = totalradius / _Res;

            for (int i = 1; i < points.Count; i++)
            {
                var p1 = points[i - 1] as Point;
                var p2 = points[i] as Point;
                List<Point> sub_dted_points = new List<Point>();
                double theta = Math.Atan2(p2.Y - p1.Y, p2.X - p1.X);
                double radius = Math.Sqrt((p2.Y - p1.Y) * (p2.Y - p1.Y) + (p2.X - p1.X) * (p2.X - p1.X));
                int n = (int)Math.Round(_Res / totalradius * radius);
                for (int j = 0; j < n; j++)
                {
                    Point p = new Point();
                    p.X = p1.X + (j * step * Math.Cos(theta));
                    p.Y = p1.Y + (j * step * Math.Sin(theta));
                    p.Z = -1;

                    sub_dted_points.Add(p);
                    string key = string.Format("{0:000}_{1:00}", Math.Floor(p.X), Math.Floor(p.Y));
                    if (dict.ContainsKey(key))
                    {
                        dict[key].Add(p);
                    }
                    else
                    {
                        List<Point> lp = new List<Point>();
                        lp.Add(p);
                        dict.Add(key, lp);
                    }
                }
                dted_points.Add(sub_dted_points);
            }
            //feach data
            foreach (var item in dict)
            {
                GetGridDeep(item.Key, item.Value,dt);
            }

            return dted_points;
        }

        private void GetGridDeep(string key, List<Point> points,string dt)
        {
            DataTable tbD = GetDeepDB(dt);
            for (int i = 0; i < points.Count; i++)
            {
                UTM utm = new UTM();
                var zone = Math.Floor((points[i].X + 180.0) / 6) + 1;
                double[] xy = new double[2];
                utm.LatLonToUTMXY(utm.DegToRad(points[i].Y), utm.DegToRad(points[i].X), zone, xy);

                int X = Convert.ToInt32(xy[0]);
                int Y = Convert.ToInt32(xy[1]);
                
                var query = tbD.AsEnumerable().Select(n => new { n, distance = Math.Abs((int)n["X"] - X) + Math.Abs((int)n["y"] - Y) })
                  .OrderBy(p => p.distance)
                  .Select(p => p.n)
                  .Take(5);  

                double vpd = 0;
                double pd = 0;
                bool isZ = false;
                foreach (var q in query)
                {
                    int x = Convert.ToInt32(q["X"]);
                    int y = Convert.ToInt32(q["Y"]);
                    double d = (double)Math.Sqrt((X - x) * (X - x) + (Y - y) * (Y - y));
                    if(d==0){
                        points[i].Z = -(double)q["Deep"];
                        isZ = true;
                        break;
                    }
                    vpd += (double)q["Deep"] / d;
                    pd += 1 / d;
                }
                if(!isZ)
                    points[i].Z = - vpd / pd;

            }
        }

        private DataTable GetDeepDB(string dt)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[uLog].[spDeep_Get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@DtLog", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@DtLog"].Value = Comm.ConvertToDateTH(dt);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            return DS.Tables[0];

        }
        #endregion

        #region ALT
        public PointD ALT(Point point)
        {
            if (DTED_FILE != "")
            {
                UTM utm = new UTM();
                var zone = Math.Floor((point.X + 180.0) / 6) + 1;
                double[] xy = new double[2];
                utm.LatLonToUTMXY(utm.DegToRad(point.Y), utm.DegToRad(point.X), zone, xy);

                MapWinGIS.Grid grid = new MapWinGIS.Grid();
                grid.Open(DTED_FILE, MapWinGIS.GridDataType.UnknownDataType, true, MapWinGIS.GridFileType.GeoTiff, null);
                int col = (int)Math.Round((xy[0] - grid.Header.XllCenter) / grid.Header.dX);
                int row = grid.Header.NumberRows - 1 - (int)Math.Round((xy[1] - grid.Header.YllCenter) / grid.Header.dY);
                double z = (double)grid.Value[col, row];
                if (z < -1e6)
                    z = 0;

                grid.Close();
                return new PointD() { X = point.X, Y = point.Y, Z = z };
            }
            else
            {
                string key = string.Format("{0:000}_{1:00}", Math.Floor(point.X), Math.Floor(point.Y));
                string filepath = string.Format(@"{0}\DTED_lv2\e{1}\n{2}.dt2", ConfigurationManager.AppSettings["EBMSData"], key.Split('_')[0], key.Split('_')[1]);
                MapWinGIS.Grid grid = new MapWinGIS.Grid();
                grid.Open(filepath, MapWinGIS.GridDataType.UnknownDataType, true, MapWinGIS.GridFileType.DTed, null);
                int col = (int)Math.Round((point.X - grid.Header.XllCenter) / grid.Header.dX);
                int row = grid.Header.NumberRows - 1 - (int)Math.Round((point.Y - grid.Header.YllCenter) / grid.Header.dY);
                double z = (int)grid.Value[col, row];
                if (z < 0)
                    z = 0;

                grid.Close();
                return new PointD() { X = point.X, Y = point.Y, Z = z };
            }
        }

        #endregion

        #region HST
        public PointD HST(Point point1, Point point2)
        {
            Dictionary<string, Point[]> dict = new Dictionary<string, Point[]>();
            int x1 = (int)Math.Floor(point1.X);
            int x2 = (int)Math.Ceiling(point2.X);
            int y1 = (int)Math.Floor(point1.Y);
            int y2 = (int)Math.Ceiling(point2.Y);
            for (int i = x1; i < x2; i++)
            {
                for (int j = y1; j <y2 ; j++)
                {
                    Point[] points = new Point[2];
                    points[0] = new Point() { X = i, Y = j };
                    points[1] = new Point() { X = i+1, Y = j+1 };
                   
                    if (i == x1)
                        points[0].X = point1.X;
                    if (i == x2-1)
                        points[1].X = point2.X;

                    if (j == y1)
                        points[0].Y = point1.Y;
                    if (j == y2-1)
                        points[1].Y = point2.Y;

                    string key = string.Format("{0:000}_{1:00}", i, j);
                    dict.Add(key, points);
                }
            }

            PointD hst = new PointD();
            hst.Z = -1e6;
            foreach (var item in dict)
            {
                PointD itemPoint = GetHstGrid(item.Key,item.Value);
                if (itemPoint.Z >= hst.Z)
                {
                    hst = itemPoint;
                }
            }

            return hst;
        }

        private PointD GetHstGrid(string key, Point[] points)
        {
            if (DTED_FILE != "")
            {
                MapWinGIS.Grid grid = new MapWinGIS.Grid();
                grid.Open(DTED_FILE, MapWinGIS.GridDataType.UnknownDataType, true, MapWinGIS.GridFileType.GeoTiff, null);
                PointD hst = new PointD();
                hst.Z = -1e6;
                UTM utm = new UTM();
                var zone = Math.Floor((points[0].X + 180.0) / 6) + 1;
                double[] xy0 = new double[2];
                utm.LatLonToUTMXY(utm.DegToRad(points[0].Y), utm.DegToRad(points[0].X), zone, xy0);
                double[] xy1 = new double[2];
                utm.LatLonToUTMXY(utm.DegToRad(points[1].Y), utm.DegToRad(points[1].X), zone, xy1);

                int col1 = (int)Math.Round((xy0[0] - grid.Header.XllCenter) / grid.Header.dX);
                int row1 = grid.Header.NumberRows - 1 - (int)Math.Round((xy0[1] - grid.Header.YllCenter) / grid.Header.dY);
                int col2 = (int)Math.Round((xy1[0] - grid.Header.XllCenter) / grid.Header.dX);
                int row2 = grid.Header.NumberRows - 1 - (int)Math.Round((xy1[1] - grid.Header.YllCenter) / grid.Header.dY);

                if (row1 > row2)
                {
                    int tmp = row1;
                    row1 = row2;
                    row2 = tmp;
                }

                for (int row = row1; row < row2; row++)
                {
                    for (int col = col1; col < col2; col++)
                    {
                        double z = (double)grid.Value[col, row];
                        if (z<1e6 && z >= hst.Z)
                        {
                            hst.X = col;
                            hst.Y = row;
                            hst.Z = z;
                        }
                    }
                }


                hst.X = hst.X * grid.Header.dX + grid.Header.XllCenter;
                hst.Y = (grid.Header.NumberRows - 1 - hst.Y) * grid.Header.dY + grid.Header.YllCenter;

                double[] latlng = new double[2];
                utm.UTMXYToLatLon(hst.X, hst.Y, zone, false, latlng);

                hst.X = utm.RadToDeg(latlng[1]);
                hst.Y = utm.RadToDeg(latlng[0]);

                if (hst.X < points[0].X) hst.X = points[0].X;
                if (hst.X > points[1].X) hst.X = points[1].X;
                if (hst.Y < points[0].Y) hst.Y = points[0].Y;
                if (hst.Y > points[1].Y) hst.Y = points[1].Y;

                grid.Close();
                return hst;
            }
            else
            {
                string filepath = string.Format(@"{0}\DTED_lv2\e{1}\n{2}.dt2", ConfigurationManager.AppSettings["EBMSData"], key.Split('_')[0], key.Split('_')[1]);
                MapWinGIS.Grid grid = new MapWinGIS.Grid();
                grid.Open(filepath, MapWinGIS.GridDataType.UnknownDataType, true, MapWinGIS.GridFileType.DTed, null);
                PointD hst = new PointD();
                hst.Z = 0;
                int col1 = (int)Math.Round((points[0].X - grid.Header.XllCenter) / grid.Header.dX);
                int row2 = grid.Header.NumberRows - 1 - (int)Math.Round((points[0].Y - grid.Header.YllCenter) / grid.Header.dY);
                int col2 = (int)Math.Round((points[1].X - grid.Header.XllCenter) / grid.Header.dX);
                int row1 = grid.Header.NumberRows - 1 - (int)Math.Round((points[1].Y - grid.Header.YllCenter) / grid.Header.dY);

                for (int row = row1; row < row2; row++)
                {
                    for (int col = col1; col < col2; col++)
                    {
                        int z = (int)grid.Value[col, row];
                        if (z >= hst.Z)
                        {
                            hst.X = col;
                            hst.Y = row;
                            hst.Z = z;
                        }
                    }
                }


                hst.X = hst.X * grid.Header.dX + grid.Header.XllCenter;
                hst.Y = (grid.Header.NumberRows - 1 - hst.Y) * grid.Header.dY + grid.Header.YllCenter;

                if (hst.X < points[0].X) hst.X = points[0].X;
                if (hst.X > points[1].X) hst.X = points[1].X;
                if (hst.Y < points[0].Y) hst.Y = points[0].Y;
                if (hst.Y > points[1].Y) hst.Y = points[1].Y;

                grid.Close();
                return hst;
            }
        }

        #endregion

        #region AOS
        public static int aos_n = 20;
        public static int aos_deg = 5;
        public Dictionary<int, List<PointAOS>> AOS(Point point, double radius)
        {
            Dictionary<int, List<PointAOS>> degDict = new Dictionary<int, List<PointAOS>>();

            for (var j = 0; j < 360; j += aos_deg)
            {
                Point pointr = cMath.PointAtR(j, point, radius);
                degDict.Add(j, findPointInDeg(j, aos_deg, point, pointr));
            }

            Dictionary<string, List<Point>> gridDict = new Dictionary<string, List<Point>>();

            foreach (var items in degDict)
            {
                foreach (var p in items.Value)
                {
                    string key = string.Format("{0:000}_{1:00}", Math.Floor(p.C.X), Math.Floor(p.C.Y));
                    if (gridDict.ContainsKey(key))
                    {
                        gridDict[key].Add(p.C);
                    }
                    else
                    {
                        List<Point> lp = new List<Point>();
                        lp.Add(p.C);
                        gridDict.Add(key, lp);
                    }
                }
            }

            //feach data
            foreach (var item in gridDict)
            {
                GetGrid(item.Key, item.Value);
            }
            
            
            foreach (var items in degDict)
            {
                double maxZ=-1e6;
                double z1 = -1e6;
                foreach(var paos in items.Value){
                    if (maxZ == -1e6)
                    {
                        maxZ = paos.C.Z;
                        z1 = paos.C.Z;
                    }
                    if (paos.C.Z<1e6 && paos.C.Z >= maxZ || (maxZ == z1 && paos.C.Z < z1))
                    {
                        maxZ = paos.C.Z;
                        paos.isVis = true;
                    }
                    else
                    {
                        paos.isVis = false;
                    }
                    
                }
            }
           
            
            return degDict;
        }

       

        private List<PointAOS> findPointInDeg(double deg,double stepDeg,Point p1,Point p2)
        {
            double theta = deg / 180 * Math.PI;
            double radius = Math.Sqrt((p2.Y - p1.Y) * (p2.Y - p1.Y) + (p2.X - p1.X) * (p2.X - p1.X));
            double dtheta = stepDeg/ 2 / 180 * Math.PI;
            int n = aos_n;
            double step = radius / n;
            List<PointAOS> rAOS = new List<PointAOS>();
            for (int j = 0; j < n; j++)
            {
                PointAOS paos = new PointAOS();
                paos.C =  new Point(){
                        X=p1.X + (j * step * Math.Cos(theta)),
                        Y=p1.Y + (j * step * Math.Sin(theta))
                };
                paos.Polygon = new PointD[5];
              
                double j1 = j-0.5;
                double j2 = j+0.5;
                if (j1 < 0) j1 = 0;
                if (j2 >= n) j2 = j;

                double p1x = p1.X + (j1 * step * Math.Cos(theta - dtheta));
                double p1y = p1.Y + (j1 * step * Math.Sin(theta - dtheta));
                double p2x = p1.X + (j2 * step * Math.Cos(theta - dtheta));
                double p2y = p1.Y + (j2 * step * Math.Sin(theta - dtheta));
                double p3x = p1.X + (j2 * step * Math.Cos(theta + dtheta));
                double p3y = p1.Y + (j2 * step * Math.Sin(theta + dtheta));
                double p4x = p1.X + (j1 * step * Math.Cos(theta + dtheta));
                double p4y = p1.Y + (j1 * step * Math.Sin(theta + dtheta));

                paos.Polygon[0] = new PointD() { X = p1x, Y = p1y };
                paos.Polygon[1] = new PointD() { X = p2x, Y = p2y };
                paos.Polygon[2] = new PointD() { X = p3x, Y = p3y };
                paos.Polygon[3] = new PointD() { X = p4x, Y = p4y };
                paos.Polygon[4] = new PointD() { X = p1x, Y = p1y };

                rAOS.Add(paos);
            }
            
            return rAOS;
        }

        
        private double TotalRadius(List<Point> points)
        {
            double totalradius = 0;
            for (int i = 1; i < points.Count; i++)
            {
                var p1 = points[i - 1] as Point;
                var p2 = points[i] as Point;
                totalradius += Math.Sqrt((p2.Y - p1.Y) * (p2.Y - p1.Y) + (p2.X - p1.X) * (p2.X - p1.X));
            }

            return totalradius;
        }

        #endregion

    }
}