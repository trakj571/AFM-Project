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
    public class dPOIStat : IHttpHandler
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

            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(
                    "http://" + ConfigurationManager.AppSettings["RecordServer"] + "/stream.php");
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            var responseStream = new StreamReader(response.GetResponseStream());
            var responseString = responseStream.ReadToEnd();

            responseStream.Close();
            response.Close();

            //Response.Write(responseString);
            var json_serializer = new JavaScriptSerializer();
            var json = (IDictionary<string, object>)json_serializer.DeserializeObject(responseString);

            var cameras = (IList<object>)json["cameras"];


           
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spPBck_List]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;


            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;


            DataSet DS = new DataSet();

            SqlCmd.Fill(DS);
            SqlConn.Close();

            tb = DS.Tables[0];

            WriteJS(context, cameras);
        }


        private void WriteJS(HttpContext context, IList<object> cameras)
        {
            List<PoiStatSet> pois = new List<PoiStatSet>();

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                bool IsOnline = false;
                for (int j = 0; j < cameras.Count; j++)
                {
                    if (cameras[j].ToString() == tb.Rows[i]["Stream"].ToString())
                    {
                        IsOnline = true;
                        break;
                    }
                }
                pois.Add(new PoiStatSet()
                {
                    PoiID = Convert.ToInt32(tb.Rows[i]["PoiID"]),
                    EquType = tb.Rows[i]["EquType"].ToString(),
                    Stream = tb.Rows[i]["Stream"].ToString(),
                    Name = tb.Rows[i]["Name"].ToString(),
                    IsOnline = IsOnline,
                    GPSStat = tb.Rows[i]["GPSStat"].ToString(),
                    Speed = string.Format("{0:0}",tb.Rows[i]["Speed"])
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