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
    public class dPoiGets : IHttpHandler
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
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spPOI_Gets]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@LyIDs", SqlDbType.VarChar, context.Request["lyids"].Length+1);
            SqlCmd.SelectCommand.Parameters["@LyIDs"].Value = context.Request["lyids"];


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tb = DS.Tables[0];

            cUtils.Log("poiget",cUtils.GetToken(cUsr.Token)+" "+context.Request["lyids"]);
        }

        private void WriteJS(HttpContext context)
        {
            List<POISet> pois = new List<POISet>();

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                pois.Add(new POISet()
                {
                    PoiID = Convert.ToInt32(tb.Rows[i]["PoiID"]),
                    PoiType = Convert.ToInt32(tb.Rows[i]["PoiType"]),
                    LyID = Convert.ToInt32(tb.Rows[i]["LyID"]),
                    TypeID = Convert.ToInt32(tb.Rows[i]["TypeID"]),
                    Name = tb.Rows[i]["Name"].ToString()+(tb.Rows[i]["EquType"].ToString()=="GPS"?string.Format("({0:0}กม/ชม)",tb.Rows[i]["Speed"]):""),
                    Points = tb.Rows[i]["Points"].ToString() == "0,0" ? "" : tb.Rows[i]["Points"].ToString(),
                    Icon = cUtils.IconUrl(tb.Rows[i]["TypeID"], tb.Rows[i]["Icon"], cUsr.Token),
                    LineColor = string.Format("{0:X2}", Convert.ToInt32(tb.Rows[i]["LineOpacity"] == DBNull.Value ? 0 : tb.Rows[i]["LineOpacity"]) * 255 / 100) + tb.Rows[i]["LineColor"].ToString(),
                    LineWidth = Convert.ToInt32(tb.Rows[i]["LineWidth"] == DBNull.Value ? 0 : tb.Rows[i]["LineWidth"]),
                    LineOpacity = Convert.ToInt32(tb.Rows[i]["LineOpacity"] == DBNull.Value ? 0 : tb.Rows[i]["LineOpacity"]),
                    FillColor = string.Format("{0:X2}", Convert.ToInt32(tb.Rows[i]["FillOpacity"] == DBNull.Value ? 0 : tb.Rows[i]["FillOpacity"]) * 255 / 100) + tb.Rows[i]["FillColor"].ToString(),
                    FillOpacity = Convert.ToInt32(tb.Rows[i]["FillOpacity"] == DBNull.Value ? 0 : tb.Rows[i]["FillOpacity"]),
                    Lat1 = Convert.ToDouble(tb.Rows[i]["Lat1"]),
                    Lng1 = Convert.ToDouble(tb.Rows[i]["Lng1"]),
                    Lat2 = Convert.ToDouble(tb.Rows[i]["Lat2"]),
                    Lng2 = Convert.ToDouble(tb.Rows[i]["Lng2"]),
                    Radius = Convert.ToDouble(tb.Rows[i]["Radius"]),
                    Heading = cConvert.ToDouble(tb.Rows[i]["Heading"]),
                    EquType = tb.Rows[i]["EquType"].ToString()
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