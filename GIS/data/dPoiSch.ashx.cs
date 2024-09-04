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
    public class dPoiSch : IHttpHandler
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
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spPOI_Sch]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            string[] keywords = cText.StrFromUTF8(context.Request["keyword"]).Split(' ');
            for (int i = 0; i < keywords.Length; i++)
            {

                SqlCmd.SelectCommand.Parameters.Add("@kw" + (i + 1), SqlDbType.VarChar, 30);
                SqlCmd.SelectCommand.Parameters["@kw" + (i + 1)].Value = keywords[i];
            }

            SqlCmd.SelectCommand.Parameters.Add("@Lat", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lat"].Value =  context.Request["lat"];

            SqlCmd.SelectCommand.Parameters.Add("@Lng", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lng"].Value =  context.Request["lng"];

            SqlCmd.SelectCommand.Parameters.Add("@Code", SqlDbType.VarChar, 20);
            SqlCmd.SelectCommand.Parameters["@Code"].Value = context.Request["code"];

            SqlCmd.SelectCommand.Parameters.Add("@TypeID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@TypeID"].Value = context.Request["typeid"];

            SqlCmd.SelectCommand.Parameters.Add("@LyIDs", SqlDbType.VarChar, context.Request["lyids"].Length + 1);
            SqlCmd.SelectCommand.Parameters["@LyIDs"].Value = context.Request["lyids"];

            SqlCmd.SelectCommand.Parameters.Add("@RegID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@RegID"].Value = cConvert.ToInt(context.Request["reg"]);

            SqlCmd.SelectCommand.Parameters.Add("@AreaID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AreaID"].Value = cConvert.ToInt(context.Request["area"]);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tb = DS.Tables[0];
        }

        private void WriteJS(HttpContext context)
        {
            List<POISet> pois = new List<POISet>();

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                pois.Add(new POISet()
                {
                    PoiID = cConvert.ToInt(tb.Rows[i]["PoiID"]),
                    PoiType = cConvert.ToInt(tb.Rows[i]["PoiType"]),
                    LyID = cConvert.ToInt(tb.Rows[i]["LyID"]),
                    TypeID = cConvert.ToInt(tb.Rows[i]["TypeID"]),
                    Name = tb.Rows[i]["Name"].ToString(),
                    Points = tb.Rows[i]["Points"].ToString(),
                    Icon = cUtils.IconUrl(tb.Rows[i]["TypeID"], tb.Rows[i]["Icon"], cUsr.Token),
                    LineColor = string.Format("{0:X2}", cConvert.ToInt(tb.Rows[i]["LineOpacity"]) * 255 / 100) + tb.Rows[i]["LineColor"].ToString(),
                    LineWidth = cConvert.ToInt(tb.Rows[i]["LineWidth"]),
                    LineOpacity = cConvert.ToInt(tb.Rows[i]["LineOpacity"]),
                    FillColor = string.Format("{0:X2}", cConvert.ToInt(tb.Rows[i]["FillOpacity"]) * 255 / 100) + tb.Rows[i]["FillColor"].ToString(),
                    FillOpacity = cConvert.ToInt(tb.Rows[i]["FillOpacity"]),
                    Lat1 = cConvert.ToDouble(tb.Rows[i]["Lat1"]),
                    Lng1 = cConvert.ToDouble(tb.Rows[i]["Lng1"]),
                    Lat2 = cConvert.ToDouble(tb.Rows[i]["Lat2"]),
                    Lng2 = cConvert.ToDouble(tb.Rows[i]["Lng2"]),
                    Radius = cConvert.ToDouble(tb.Rows[i]["Radius"])
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