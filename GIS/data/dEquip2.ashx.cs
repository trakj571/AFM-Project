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
    public class dEquip2 : IHttpHandler
    {
        public class PLayer
        {
            public int LyID { get; set; }
            public string Name { get; set; }
            public List<Layer> Layers {get;set;}
        }

        public class Layer
        {
            public int LyID { get; set; }
            public string Name { get; set; }
            public List<POISet> Pois { get; set; }
        }

        DataTable tb,tbL,tbpL;
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
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spEquip_Gets]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            
            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tb = DS.Tables[0];
            tbpL = DS.Tables[1];
            tbL = DS.Tables[2];
        }

        private void WriteJS(HttpContext context)
        {
            var pLayers = new List<PLayer>();
            for (int k = 0; k < tbpL.Rows.Count; k++)
            {
                var drk = tbpL.Rows[k];
                var player = new PLayer();
                player.LyID = cConvert.ToInt(drk["LyID"]);
                player.Name = drk["Name"].ToString();
                player.Layers = new List<Layer>();
                for (int j = 0; j < tbL.Rows.Count; j++)
                {
                    var drj = tbL.Rows[j];
                    if (cConvert.ToInt(drj["pLyID"]) != cConvert.ToInt(drk["LyID"]))
                        continue;

                    var layer = new Layer();
                    layer.LyID = cConvert.ToInt(drj["LyID"]);
                    layer.Name = drj["Name"].ToString();

                    layer.Pois = new List<POISet>();

                    for (int i = 0; i < tb.Rows.Count; i++)
                    {
                        if (cConvert.ToInt(drj["LyID"]) != cConvert.ToInt(tb.Rows[i]["LyID"]))
                            continue;
                        string name = tb.Rows[i]["Name"].ToString();
                        if (tb.Rows[i]["EquType"].ToString() == "GPS")
                        {
                            name += string.Format(" ({0:0}กม/ชม)", tb.Rows[i]["Speed"]);
                        }

                        layer.Pois.Add(new POISet()
                        {
                            PoiID = Convert.ToInt32(tb.Rows[i]["PoiID"]),
                            PoiType = Convert.ToInt32(tb.Rows[i]["PoiType"]),
                            LyID = Convert.ToInt32(tb.Rows[i]["LyID"]),
                            TypeID = Convert.ToInt32(tb.Rows[i]["TypeID"]),
                            Name = name,
                            pLayerName = tb.Rows[i]["LayerName"].ToString(),
                            LayerName = tb.Rows[i]["LayerName"].ToString(),
                            Points = tb.Rows[i]["Points"].ToString() == "0,0" ? "" : tb.Rows[i]["Points"].ToString(),
                            Icon = cUtils.IconUrl(tb.Rows[i]["TypeID"], "*", cUsr.Token),
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
                            EquType = tb.Rows[i]["EquType"].ToString(),
                            IsLock = tb.Rows[i]["IsLock"].ToString(),
                            IsOnline = tb.Rows[i]["IsOnline"].ToString()
                        });



                    }
                    player.Layers.Add(layer);


                }
                pLayers.Add(player);
            }


            ReturnSet returnSet = new ReturnSet();
            returnSet.result = "OK";
            returnSet.datas = pLayers;
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