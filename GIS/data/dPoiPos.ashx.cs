using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;

namespace EBMSMap30.data
{
    /// <summary>
    /// Summary description for dPoiPos
    /// </summary>
    public class dPoiPos : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            UpdPOIPoints(context, context.Request.Form["poiid"],Convert.ToInt32(context.Request.Form["poitype"]), context.Request.Form["points"], context.Request.Form["distance"], context.Request.Form["Area"], context.Request.Form["radius"]);
        }

        public void UpdPOIPoints(HttpContext context, string PoiID,int PoiType, string Points, string Distance, string Area, string Radius)
        {
            if (!cUsr.VerifyToken(cUsr.Token))
            {
                context.Response.Write(cUtils.getJSON_ERR("403"));
                context.Response.End();
                return;
            }

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spPOI_Pos]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@poiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@poiID"].Value = PoiID;

            string StPoint = "";

           
            string[] points = Points.Split(',');
            double Lat1 = 90;
            double Lng1 = 180;
            double Lat2 = -90;
            double Lng2 = -180;

            if (PoiType == 1 || PoiType == 4)
            {
                StPoint = "POINT(" + Points.Replace(",", " ") + ")";
            }
            else if (PoiType == 2)
            {
                StPoint = "LINESTRING(";
            }
            else if (PoiType == 3)
            {
                StPoint = "POLYGON((";
            }

            for (int i = 0; i < points.Length; i += 2)
            {
                double lng = Convert.ToDouble(points[i]);
                double lat = Convert.ToDouble(points[i + 1]);
                Lat1 = Math.Min(Lat1, lat);
                Lng1 = Math.Min(Lng1, lng);
                Lat2 = Math.Max(Lat2, lat);
                Lng2 = Math.Max(Lng2, lng);

                if (PoiType == 2 || PoiType == 3)
                {
                    if (i > 0)
                        StPoint += ",";
                    StPoint += points[i] + " " + points[i + 1];
                }
            }
           

            if (PoiType == 2)
            {
                StPoint += ")";
            }
            if (PoiType == 3)
            {
                if (points[0] + " " + points[1] != points[points.Length - 2] + " " + points[points.Length - 1])
                {
                    StPoint += ",";
                    StPoint += points[0] + " " + points[1];
                }
                StPoint += "))";
            }

            SqlCmd.SelectCommand.Parameters.Add("@Points", SqlDbType.VarChar, StPoint.Length + 1);
            SqlCmd.SelectCommand.Parameters["@Points"].Value = StPoint;

            SqlCmd.SelectCommand.Parameters.Add("@Lat1", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lat1"].Value = Lat1;

            SqlCmd.SelectCommand.Parameters.Add("@Lng1", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lng1"].Value = Lng1;

            SqlCmd.SelectCommand.Parameters.Add("@Lat2", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lat2"].Value = Lat2;

            SqlCmd.SelectCommand.Parameters.Add("@Lng2", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lng2"].Value = Lng2;

            SqlCmd.SelectCommand.Parameters.Add("@Distance", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Distance"].Value = Distance;

            SqlCmd.SelectCommand.Parameters.Add("@Area", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Area"].Value = Area;

            SqlCmd.SelectCommand.Parameters.Add("@Radius", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Radius"].Value = Radius;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            if (Convert.ToInt32(DS.Tables[0].Rows[0]["PoiID"]) > 0)
            {
                 context.Response.Write("{\"result\":\"OK\",\"code\":\"1\"}");
            }
            else
            {
                context.Response.Write("{\"result\":\"ERR\",\"code\":\"0\"}");
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