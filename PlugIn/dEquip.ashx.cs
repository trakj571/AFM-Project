using EBMSMap30;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace AFMProj.PlugIn
{
    /// <summary>
    /// Summary description for dPlugIn
    /// </summary>
    public class dEquip : IHttpHandler
    {

        public class POIRet
        {
            public int PoiID { get; set; }
            public string UUID { get; set; }
            public string Name { get; set; }
            public string PubIPAdr { get; set; }
            public string LocIPAdr { get; set; }
            public string PubPort { get; set; }
            public string LocPort { get; set; }
            public string IsOnline { get; set; }

            public string EquType { get; set; }
            public string AnyDeskCmd { get; set; }
        }

        public void ProcessRequest(HttpContext context)
        {
           
            context.Response.ContentType = "text/plain";
            var id = cUsr.GetIdentity(context.Request["token"]);

            var poi = new POIRet();
            if (id.IsVerify)
            {
                var dr = GetStations(id.UID, context.Request["PoiID"]);
                if (dr.Length > 0)
                {
                    poi.PoiID = cConvert.ToInt(dr[0]["PoiID"]);
                    poi.Name = dr[0]["Name"].ToString();
                    poi.UUID = dr[0]["UUID"].ToString();
                    poi.PubIPAdr = dr[0]["IPAdd"].ToString();
                    poi.IsOnline = dr[0]["IsOnline"].ToString();
                    poi.PubIPAdr = dr[0]["IPAdd"].ToString();
                    poi.PubPort = dr[0]["Port"].ToString() == "" ? "8081" : dr[0]["Port"].ToString();
                    poi.LocIPAdr = "192.168.7.100";
                    poi.LocPort = "80";

                    if(poi.PubIPAdr== "139.5.146.243")
                    {
                        //poi.LocIPAdr = "172.17.200.100";
                        poi.LocIPAdr = "rgw.nbtc.go.th";
                        poi.LocPort = poi.PubPort;
                    }

                    poi.EquType = dr[0]["EquType"].ToString();

                    if (poi.EquType == "STN")
                        ///poi.AnyDeskCmd = "echo " + dr[0]["Password"] + " | \"C:\\Program Files (x86)\\AnyDesk\\AnyDesk.exe\" " + dr[0]["AnyDeskID"].ToString().Replace(" ", "") + " --with-password --fullscreen";
                        poi.AnyDeskCmd = "echo " + dr[0]["Password"] + " | \"C:\\AnyDesk\\AnyDesk.exe\" " + dr[0]["AnyDeskID"].ToString().Replace(" ", "") + " --with-password --fullscreen";
                    else
                        poi.AnyDeskCmd = "";
                }
            }

            ReturnSet returnSet = new ReturnSet();
            returnSet.result = "OK";
            returnSet.datas = poi;
            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            context.Response.Write(jSearializer.Serialize(returnSet));
        }

        private DataRow[] GetStations(int UID,string PoiID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spEquip_Gets]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = UID;

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = cConvert.ToInt(PoiID);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@EquType", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@EquType"].Value = "STN+STN2";

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            return DS.Tables[0].Select("PoiID=" + PoiID);
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