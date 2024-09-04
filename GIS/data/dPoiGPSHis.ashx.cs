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
    public class dPoiGPSHis : IHttpHandler
    {
        DataTable tb,tb2;
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
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spGPS_HisDet", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = context.Request["poiid"];

            SqlCmd.SelectCommand.Parameters.Add("@LogID1", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@LogID1"].Value = context.Request["logid1"];

            SqlCmd.SelectCommand.Parameters.Add("@LogID2", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@LogID2"].Value = context.Request["logid2"];


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tb = DS.Tables[0];
            tb2 = DS.Tables[1];
        }

        private void WriteJS(HttpContext context)
        {
            PoiGPSDetSet gpsdet = new PoiGPSDetSet();
            gpsdet.PoiID = cConvert.ToInt(tb.Rows[0]["PoiID"]);
            gpsdet.Name = tb.Rows[0]["Name"].ToString();
            gpsdet.Page = cConvert.ToInt(tb.Rows[0]["Page"]);
           
            gpsdet.nPage = (int)Math.Ceiling(cConvert.ToDouble(tb.Rows[0]["nTotal"]) / cConvert.ToDouble(tb.Rows[0]["PageSize"]));
            gpsdet.Datas = new List<GpsDataSet>();

            for (int i = 0; i < tb2.Rows.Count; i++)
            {
                gpsdet.Datas.Add(new GpsDataSet()
                {
                    LogID = Convert.ToInt32(tb2.Rows[i]["LogID"]),
                    DtS = string.Format("{0:yyyy-MM-dd}",tb2.Rows[i]["DtAdd"]),
                    TmS = string.Format("{0:HH:mm:ss}", tb2.Rows[i]["DtAdd"]),
                    DtC = string.Format("{0:yyyy-MM-dd}", tb2.Rows[i]["D"]),
                    TmC = string.Format("{0:HH:mm:ss}", tb2.Rows[i]["D"]),
                    Lat = Convert.ToDouble(tb2.Rows[i]["Lat"]),
                    Lng = Convert.ToDouble(tb2.Rows[i]["Lng"]),
                    Heading = cConvert.ToDouble(tb2.Rows[i]["Heading"]),
                    Speed = cConvert.ToDouble(tb2.Rows[i]["Speed"]),
                    Alt = cConvert.ToDouble(tb2.Rows[i]["Alt"])
                });
            }

            ReturnSet returnSet = new ReturnSet();
            returnSet.result = "OK";
            returnSet.datas = gpsdet;
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