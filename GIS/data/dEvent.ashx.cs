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
    public class dEvent : IHttpHandler
    {
        DataTable tb,tbA,tbM;
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
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spEvent_get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = cConvert.ToInt(context.Request["s"]);

            SqlCmd.SelectCommand.Parameters.Add("@LyID1", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@LyID1"].Value = cConvert.ToInt(context.Request["ly1"]);

            SqlCmd.SelectCommand.Parameters.Add("@LyID2", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@LyID2"].Value = cConvert.ToInt(context.Request["ly2"]);


            SqlCmd.SelectCommand.Parameters.Add("@EvTypeID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@EvTypeID"].Value = cConvert.ToInt(context.Request["ev"]);

            SqlCmd.SelectCommand.Parameters.Add("@EvID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@EvID"].Value = cConvert.ToInt(context.Request["EvID"]);


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tb = DS.Tables[0];
            //tbA = DS.Tables[1];
            tbM = DS.Tables[1];
        }

        private void WriteJS(HttpContext context)
        {

            List<EventSet> evset = new List<EventSet>();

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                evset.Add(new EventSet()
                {
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
                    rType=""
                });
            }

           /* for (int i = 0; i < tbA.Rows.Count; i++)
            {
                evset.Add(new EventSet()
                {
                    EvID = Convert.ToInt32(tbA.Rows[i]["EvID"]),
                    PoiID = Convert.ToInt32(tbA.Rows[i]["PoiID"]),
                    HostName = tbA.Rows[i]["HostName"].ToString(),
                    Station = tbA.Rows[i]["Station"].ToString(),
                    EvName = tbA.Rows[i]["EvName"].ToString(),
                    Freq = cConvert.ToDouble(tbA.Rows[i]["Freq"]),
                    Signal = cConvert.ToDouble(tbA.Rows[i]["Signal"]),
                    Lat = cConvert.ToDouble(tbA.Rows[i]["Lat"]),
                    Lng = cConvert.ToDouble(tbA.Rows[i]["Lng"]),
                    DtAdd = string.Format("{0:yyyy-MM-dd}", tbA.Rows[i]["DtAdd"]),
                    TmAdd = string.Format("{0:HH:mm:ss}", tbA.Rows[i]["DtAdd"]),
                    rType = "A"
                });
            }*/
            for (int i = 0; i < tbM.Rows.Count; i++)
            {
                evset.Add(new EventSet()
                {
                    EvID = cConvert.ToInt(tbM.Rows[i]["EvID"]),
                    rType = "M"
                });
            }
            ReturnSet returnSet = new ReturnSet();
            returnSet.result = "OK";
            returnSet.datas = evset;
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