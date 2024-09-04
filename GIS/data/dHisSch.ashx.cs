using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Net;
using System.IO;
using System.Web.Script.Serialization;

namespace EBMSMap30.data
{
    /// <summary>
    /// Summary description for dPoiSch
    /// </summary>
    public class dHisSch : IHttpHandler
    {
        DataTable tb;
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            ExecDB(context);
            
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
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spEquip_HisSch]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = cConvert.ToInt(context.Request["s"]);

            SqlCmd.SelectCommand.Parameters.Add("@EvTypeID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@EvTypeID"].Value = cConvert.ToInt(context.Request["ev"]);


            SqlCmd.SelectCommand.Parameters.Add("@Dt1", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@Dt1"].Value = cConvert.ConvertToDateTH(context.Request["d1"]);
             
            SqlCmd.SelectCommand.Parameters.Add("@Dt2", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@Dt2"].Value = cConvert.ConvertToDateTH(context.Request["d2"]);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tb = DS.Tables[0];

            List<EventSet> pois = new List<EventSet>();
            for (int i = 0; i < tb.Rows.Count; i++)
            {
                pois.Add(new EventSet()
                {
                    //Key = "@" + tb.Rows[i]["PoiID"] + "_" + tb.Rows[i]["EvTypeID"] + "_" + tb.Rows[i]["LogID1"] + "_" + tb.Rows[i]["LogID2"],
                    EvID = Convert.ToInt32(tb.Rows[i]["EvID"]),
                    PoiID = Convert.ToInt32(tb.Rows[i]["PoiID"]),
                    EvPoiID = Convert.ToInt32(tb.Rows[i]["EvPoiID"]),
                    HostName = tb.Rows[i]["HostName"].ToString(),
                    Station = tb.Rows[i]["Station"].ToString(),
                    EvName = tb.Rows[i]["EvName"].ToString(),
                    Freq = cConvert.ToDouble(tb.Rows[i]["Freq"]),
                    Signal = cConvert.ToDouble(tb.Rows[i]["Signal"]),
                    Lat = cConvert.ToDouble(tb.Rows[i]["Lat"]),
                    Lng = cConvert.ToDouble(tb.Rows[i]["Lng"]),
                    
                    DtAdd = string.Format("{0:yyyy-MM-dd}", tb.Rows[i]["DtAdd"]),
                    TmAdd = string.Format("{0:HH:mm:ss}", tb.Rows[i]["DtAdd"]),
                    rType = ""
                });
            }

            WriteJS(context,pois);
        }


        private void WriteJS(HttpContext context, List<EventSet> pois)
        {
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