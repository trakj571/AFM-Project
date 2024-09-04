using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace EBMSMap30.data
{
    /// <summary>
    /// Summary description for dPoiSch
    /// </summary>
    public class dPOISchG : IHttpHandler
    {
        DataTable tb;
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            ExecDB(context);
            WriteJS(context);
        }

        private void ExecDB(HttpContext context)
        {
            if (!cUsr.VerifyToken(cUsr.Token))
            {
                context.Response.Write(cUtils.getJSON_ERR("403"));
                context.Response.End();
                return;
            }

            double lat = Convert.ToDouble(context.Request["lat"]);
            double lng = Convert.ToDouble(context.Request["lng"]);
            double r = Convert.ToDouble(context.Request["r"]);
            double lat1 = double.MaxValue;
            double lat2 = double.MinValue;
            double lng1 = double.MaxValue;
            double lng2 = double.MinValue;

            DT2.Point c = new DT2.Point(){X=lng,Y=lat};
            for (int i = 0; i < 360; i+=90)
            {
                DT2.Point p = cMath.PointAtR(i, c, r);
                lat1 = Math.Min(lat1, p.Y);
                lat2 = Math.Max(lat2, p.Y);
                lng1 = Math.Min(lng1, p.X);
                lng2 = Math.Max(lng2, p.X);
            }


            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spPoi_SchG]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@Lat1", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lat1"].Value =  lat1;

            SqlCmd.SelectCommand.Parameters.Add("@Lng1", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lng1"].Value = lng1;

            SqlCmd.SelectCommand.Parameters.Add("@Lat2", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lat2"].Value = lat2;

            SqlCmd.SelectCommand.Parameters.Add("@Lng2", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lng2"].Value = lng2;

            SqlCmd.SelectCommand.Parameters.Add("@LyIDs", SqlDbType.VarChar, context.Request["lyids"].Length + 1);
            SqlCmd.SelectCommand.Parameters["@LyIDs"].Value = context.Request["lyids"];

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tb = DS.Tables[0];
        }

        private void WriteJS(HttpContext context)
        {
            List<POISet> pois = new List<POISet>();
            double lat = Convert.ToDouble(context.Request["lat"]);
            double lng = Convert.ToDouble(context.Request["lng"]);
            double r = Convert.ToDouble(context.Request["r"]);

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                double Lat1 = Convert.ToDouble(tb.Rows[i]["Lat1"]);
                double Lng1 = Convert.ToDouble(tb.Rows[i]["Lng1"]);
                double Lat2 = Convert.ToDouble(tb.Rows[i]["Lat2"]);
                double Lng2 = Convert.ToDouble(tb.Rows[i]["Lng2"]);

                DT2.Point p = new DT2.Point() { X = lng, Y = lat };
                DT2.Point p1 = new DT2.Point() { X = Lng1, Y = Lat1 };
                DT2.Point p2 = new DT2.Point() { X = Lng1, Y = Lat2 };
                DT2.Point p3 = new DT2.Point() { X = Lng2, Y = Lat2 };
                DT2.Point p4 = new DT2.Point() { X = Lng2, Y = Lat1 };

                if (cMath.Distance(p, p1) > r &&
                    cMath.Distance(p, p2) > r &&
                    cMath.Distance(p, p3) > r &&
                    cMath.Distance(p, p4) > r) continue;

                pois.Add(new POISet()
                {
                    PoiID = Convert.ToInt32(tb.Rows[i]["PoiID"]),
                    PoiType = Convert.ToInt32(tb.Rows[i]["PoiType"]),
                    LyID = Convert.ToInt32(tb.Rows[i]["LyID"]),
                    TypeID = Convert.ToInt32(tb.Rows[i]["TypeID"]),
                    Name = tb.Rows[i]["Name"].ToString(),
                    Points = tb.Rows[i]["Points"].ToString(),
                    Icon = cUtils.IconUrl(tb.Rows[i]["TypeID"], tb.Rows[i]["Icon"], cUsr.Token),
                    LineColor = string.Format("{0:X2}", Convert.ToInt32(tb.Rows[i]["LineOpacity"] == DBNull.Value ? 0 : tb.Rows[i]["LineOpacity"]) * 255 / 100) + tb.Rows[i]["LineColor"].ToString(),
                    LineWidth = Convert.ToInt32(tb.Rows[i]["LineWidth"] == DBNull.Value ? 0 : tb.Rows[i]["LineWidth"]),
                    LineOpacity = Convert.ToInt32(tb.Rows[i]["LineOpacity"] == DBNull.Value ? 0 : tb.Rows[i]["LineOpacity"]),
                    FillColor = string.Format("{0:X2}", Convert.ToInt32(tb.Rows[i]["FillOpacity"] == DBNull.Value ? 0 : tb.Rows[i]["FillOpacity"]) * 255 / 100) + tb.Rows[i]["FillColor"].ToString(),
                    FillOpacity = Convert.ToInt32(tb.Rows[i]["FillOpacity"] == DBNull.Value ? 0 : tb.Rows[i]["FillOpacity"]),
                    Lat1 = Lat1,
                    Lng1 = Lng1,
                    Lat2 = Lat1,
                    Lng2 = Lng2,
                    Radius = Convert.ToDouble(tb.Rows[i]["Radius"])
                });
            }

            ReturnSet returnSet = new ReturnSet();
            returnSet.result = "OK";
            returnSet.datas = pois;
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