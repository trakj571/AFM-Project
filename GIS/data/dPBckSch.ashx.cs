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
    public class dPBckSch : IHttpHandler
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

            

            
            DateTime A = ConvertToDateTime(context.Request.QueryString["a"]);
            DateTime B = ConvertToDateTime(context.Request.QueryString["b"]);

            double a = Comm.DateTimeToUnixTimestamp(A);
            double b = Comm.DateTimeToUnixTimestamp(B); ;
            
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(
                    "http://" + ConfigurationManager.AppSettings["RecordServer"] + "/record.php?stream=" + context.Request.QueryString["s"] + "&a=" + a + "&b=" + b);
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            var responseStream = new StreamReader(response.GetResponseStream());
            var responseString = responseStream.ReadToEnd();

            responseStream.Close();
            response.Close();

            //Response.Write(responseString);
            var json_serializer = new JavaScriptSerializer();
            //var json = (IDictionary<string, object>)json_serializer.DeserializeObject(responseString);
            var json = (IList<object>)json_serializer.DeserializeObject(responseString);

            string[] strms = new string[json.Count];
            string[] dts = new string[json.Count];
            for (int i = 0; i < json.Count; i++)
            {
                var obj = (IDictionary<string, object>)json[i];
                strms[i] = obj["stream"].ToString();
                dts[i] = obj["Start"].ToString();
            }
            string strArr = string.Join(",", strms);
            string dtArr = string.Join(",", dts);

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spPBck_Info]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@stream", SqlDbType.VarChar, strArr.Length + 1);
            SqlCmd.SelectCommand.Parameters["@stream"].Value = strArr;

            SqlCmd.SelectCommand.Parameters.Add("@Dt", SqlDbType.VarChar, dtArr.Length+1);
            SqlCmd.SelectCommand.Parameters["@Dt"].Value = dtArr;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tb = DS.Tables[0];

            WriteJS(context, json);
        }

        private DateTime ConvertToDateTime(string a)
        {
            try
            {
                var As = a.Trim().Split(' ');
                if (As.Length == 2)
                    return (DateTime)Comm.ConvertToDateTH(As[0], As[1]);
                else
                    return (DateTime)Comm.ConvertToDateTH(As[0]);
            }
            catch (Exception) { }

            return DateTime.Now;
        }
        private void WriteJS(HttpContext context,IList<object> json)
        {
            List<PlayBackSet> pois = new List<PlayBackSet>();

            for (int i = 0; i < json.Count; i++)
            {
                var obj = (IDictionary<string, object>)json[i];
                string key = obj["stream"] + "_" + obj["Start"];
                DataRow[] dr = tb.Select("key='" + key + "'");
                if (dr.Length == 0)
                    continue;
                pois.Add(new PlayBackSet()
                {
                    Name = dr[0]["Name"].ToString(),
                    Key = dr[0]["key"] + "_http://" + ConfigurationManager.AppSettings["RecordServer"] + obj["Playlist"] + "_" + obj["Duration"] + "_" + dr[0]["PoiID"] + "_" + dr[0]["Lng"] + "_" + dr[0]["Lat"],
                    Points = (dr[0]["Lng"] + "," + dr[0]["Lat"])=="0,0"?"": (dr[0]["Lng"] + "," + dr[0]["Lat"]),
                    Icon = cUtils.IconUrl(dr[0]["TypeID"], "*", cUsr.Token),
                    Playlist = obj["Playlist"].ToString(),
                    Duration = Convert.ToInt32(obj["Duration"])

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