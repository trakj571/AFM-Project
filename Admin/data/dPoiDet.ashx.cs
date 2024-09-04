using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace EBMSMap30.Admin.data
{
    /// <summary>
    /// Summary description for dPoiSch
    /// </summary>
    public class dPoiDet : IHttpHandler
    {
        DataSet DS = new DataSet();
        DataSet DSGps = new DataSet();
        int dulation = 0;
        string playlist = "";
        string start = "";
        double lng = 0;
        double lat = 0;

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            context.Response.CacheControl = "no-cache";
            if ((int)Comm.ConvertToInt(context.Request["poiid"]) > 0 || context.Request["poiid"] == "0" || context.Request["poiid"] == null || context.Request["poiid"]=="")
            {
                ExecDB(context, context.Request["poiid"]);
            }
            else if (context.Request["poiid"].ToString().StartsWith("@"))
            {
                string[] keys = context.Request["poiid"].Substring(1).Split('_');
                ExecDB(context, keys[0]);
            }
            else
            {
                string[] keys = context.Request["poiid"].Split('_');
                start = keys[1];
                playlist = keys[2];
                dulation = (int)Comm.ConvertToInt(keys[3]);
                int poiid = (int)Comm.ConvertToInt(keys[4]);
                lng = (double)Comm.ConvertToDouble(keys[5]);
                lat = (double)Comm.ConvertToDouble(keys[6]);

                ExecDB(context, poiid);
                ExecDBGps(context, poiid, start, dulation);
            }
            WriteJS(context);
        }

        private void ExecDB(HttpContext context,object PoiID)
        {
            if (!cUsr.VerifyToken(cUsr.Token))
            {
                context.Response.Write(cUtils.getJSON_ERR("403"));
                context.Response.End();
                return;
            }
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spPOI_GetDet]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@poiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@poiID"].Value = PoiID;

            SqlCmd.SelectCommand.Parameters.Add("@TypeID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@TypeID"].Value =  context.Request["typeid"];

           
            SqlCmd.Fill(DS);
            SqlConn.Close();
        }

        private void ExecDBGps(HttpContext context,object PoiID, object start,int duration)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spPOI_GetDetGps]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@poiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@poiID"].Value = PoiID;

            string[] starts = start.ToString().Split(' ');
            string[] dts = starts[0].Split('-');

            SqlCmd.SelectCommand.Parameters.Add("@Start", SqlDbType.DateTime);
            SqlCmd.SelectCommand.Parameters["@Start"].Value = Comm.ConvertToDate(dts[2] + "/" + dts[1] + "/" + dts[0], starts[1]);

            SqlCmd.SelectCommand.Parameters.Add("@duration", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@duration"].Value = duration;


            SqlCmd.Fill(DSGps);
            SqlConn.Close();
        }
        private void WriteJS(HttpContext context)
        {
            if (DS.Tables[0].Rows.Count > 0 && Convert.ToInt32(DS.Tables[0].Rows[0]["PoiID"]) < 0)
            {
                context.Response.Write(cUtils.getJSON_ERR("404"));
                context.Response.End();
                return;
            }

            POIDetailSet poiinfoset = new POIDetailSet();
            if (DS.Tables[0].Rows.Count > 0)
            {
                poiinfoset.PoiID = Convert.ToInt32(DS.Tables[0].Rows[0]["PoiID"]);
                poiinfoset.LyID = Convert.ToInt32(DS.Tables[0].Rows[0]["LyID"]);
                poiinfoset.TypeID = Convert.ToInt32(DS.Tables[0].Rows[0]["TypeID"]);
                poiinfoset.PoiType = Convert.ToInt32(DS.Tables[0].Rows[0]["PoiType"]);
                poiinfoset.Name = DS.Tables[0].Rows[0]["Name"].ToString();
                if (playlist == "")
                    poiinfoset.Points = DS.Tables[0].Rows[0]["Points"].ToString();
                else
                    poiinfoset.Points = lng+","+lat;

                poiinfoset.Icon = cUtils.IconUrl(DS.Tables[0].Rows[0]["TypeID"], "*", cUsr.Token);
                poiinfoset.LineColor = DS.Tables[0].Rows[0]["LineColor"].ToString();
                poiinfoset.LineWidth = Convert.ToInt32(DS.Tables[0].Rows[0]["LineWidth"] == DBNull.Value ? 0 : DS.Tables[0].Rows[0]["LineWidth"]);
                poiinfoset.LineOpacity = Convert.ToInt32(DS.Tables[0].Rows[0]["LineOpacity"] == DBNull.Value ? 0 : DS.Tables[0].Rows[0]["LineOpacity"]);
                poiinfoset.FillColor = DS.Tables[0].Rows[0]["FillColor"].ToString();
                poiinfoset.FillOpacity = Convert.ToInt32(DS.Tables[0].Rows[0]["FillOpacity"] == DBNull.Value ? 0 : DS.Tables[0].Rows[0]["FillOpacity"]);

                poiinfoset.Lat = (Convert.ToDouble(DS.Tables[0].Rows[0]["Lat1"]) + Convert.ToDouble(DS.Tables[0].Rows[0]["Lat2"])) / 2;
                poiinfoset.Lng = (Convert.ToDouble(DS.Tables[0].Rows[0]["Lng1"]) + Convert.ToDouble(DS.Tables[0].Rows[0]["Lng2"])) / 2;
                poiinfoset.Distance = Convert.ToDouble(DS.Tables[0].Rows[0]["Distance"]);
                poiinfoset.Area = Convert.ToDouble(DS.Tables[0].Rows[0]["Area"]);
                poiinfoset.Radius = Convert.ToDouble(DS.Tables[0].Rows[0]["Radius"]);
                poiinfoset.EquType = DS.Tables[0].Rows[0]["EquType"].ToString();

               
            }
            if (DS.Tables[1].Rows.Count > 0)
            {
                poiinfoset.POICols = new List<POICol>();
                for (int i = 0; i < DS.Tables[1].Rows.Count; i++)
                {
                    POICol poiCol = new POICol();
                    poiCol.ColID = Convert.ToInt32(DS.Tables[1].Rows[i]["ColID"]);
                    poiCol.DataName = DS.Tables[1].Rows[i]["DataName"].ToString();
                    poiCol.DataType = DS.Tables[1].Rows[i]["DataType"].ToString();
                    poiCol.Label = DS.Tables[1].Rows[i]["Label"].ToString();
                    poiCol.Unit = DS.Tables[1].Rows[i]["Unit"].ToString();
                    poiCol.MaxLength = Convert.ToInt16(DS.Tables[1].Rows[i]["MaxLength"]);
                    poiCol.IsHeader = DS.Tables[1].Rows[i]["IsHeader"].ToString() == "Y";
                    poiCol.IsRequire = DS.Tables[1].Rows[i]["IsRequire"].ToString() == "Y";
                    poiCol.IsHide = DS.Tables[1].Rows[i]["IsHide"].ToString() == "Y";
                    poiCol.InputType = DS.Tables[1].Rows[i]["InputType"].ToString();
                    poiCol.DpColID = DS.Tables[1].Rows[i]["DpColID"]==DBNull.Value?0:Convert.ToInt32(DS.Tables[1].Rows[i]["DpColID"]);

                    SetColOpts(poiCol, DS.Tables[2], DS.Tables[1].Rows[i]["ColID"] + "");
                    if (playlist != "" && (poiCol.DataName == "WEB_Link" || poiCol.DataName == "MOBILE_Link"))
                    {
                        poiCol.Data = playlist;// "http://ebmsapp.com:8008/hls/record/4/playlist.m3u8";
                    }
                    else
                    {
                        SetColData(poiCol, DS.Tables[3], DS.Tables[1].Rows[i]["ColID"] + "", poiinfoset.PoiID);
                    }
                    
                    poiinfoset.POICols.Add(poiCol);
                }
            }
            poiinfoset.POIForms = new List<POIForm>();
            if (DS.Tables[4].Rows.Count > 0)
            {
                
                for (int k = 0; k < DS.Tables[4].Rows.Count; k++)
                {
                    POIForm poiForm = new POIForm();
                    poiForm.FormID = Convert.ToInt32(DS.Tables[4].Rows[k]["FormID"]);
                    poiForm.Name = DS.Tables[4].Rows[k]["Name"].ToString();

                    poiForm.POICols = new List<POICol>();
                    DataRow[] dr = DS.Tables[5].Select("FormID=" + poiForm.FormID,"iorder");
                    for (int i = 0; i < dr.Length; i++)
                    {
                        POICol poiCol = new POICol();
                        poiCol.ColID = Convert.ToInt32(dr[i]["ColID"]);
                        poiCol.DataName = dr[i]["DataName"].ToString();
                        poiCol.DataType = dr[i]["DataType"].ToString();
                        poiCol.Label = dr[i]["Label"].ToString();
                        poiCol.Unit = dr[i]["Unit"].ToString();
                        poiCol.MaxLength = Convert.ToInt16(dr[i]["MaxLength"]);
                        poiCol.IsHeader = dr[i]["IsHeader"].ToString() == "Y";
                        poiCol.IsRequire = dr[i]["IsRequire"].ToString() == "Y";
                        poiCol.InputType = dr[i]["InputType"].ToString();
                        poiCol.DpColID = dr[i]["DpColID"]==DBNull.Value?0:Convert.ToInt32(dr[i]["DpColID"]);

                        SetColOpts(poiCol, DS.Tables[6], dr[i]["ColID"] + "");
                        
                        SetColData(poiCol, DS.Tables[3], dr[i]["ColID"] + "", poiinfoset.PoiID); 
                        poiForm.POICols.Add(poiCol);
                    }
                    poiinfoset.POIForms.Add(poiForm);
                }
            }
            if (dulation > 0)
            {
                poiinfoset.PointHis = new List<PointHisSet>();
                for (int i = 0; i < DSGps.Tables[0].Rows.Count ;i++ )
                {
                    poiinfoset.PointHis.Add(new PointHisSet()
                    {
                        Sec = Convert.ToInt32(DSGps.Tables[0].Rows[i]["Sec"]),
                        Lat = Convert.ToDouble(DSGps.Tables[0].Rows[i]["Lat"]),
                        Lng = Convert.ToDouble(DSGps.Tables[0].Rows[i]["Lng"]),
                        Speed = Convert.ToDouble(DSGps.Tables[0].Rows[i]["Speed"]),
                        Heading = Convert.ToDouble(DSGps.Tables[0].Rows[i]["Heading"])
                    });
                }
            }
            ReturnSet returnSet = new ReturnSet();
            returnSet.result = "OK";
            returnSet.datas = poiinfoset;
            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            context.Response.Write(jSearializer.Serialize(returnSet));
        }

        private void SetColOpts(POICol poiCol, DataTable tbO, string ColID)
        {
            DataRow[] dr = tbO.Select("ColID=" + ColID, "optID");
            if (dr.Length > 0)
            {
                poiCol.Options = new List<POIColOpt>();
                for (int j = 0; j < dr.Length; j++)
                {
                    poiCol.Options.Add(new POIColOpt()
                    {
                        Value = dr[j]["Value"].ToString(),
                        Text = dr[j]["Text"].ToString()
                    });
                }
            }
        }
        private void SetColData(POICol poiCol, DataTable tbD, string ColID, int PoiID)
        {
            DataRow[] ddr = tbD.Select("ColID=" + ColID);
            if (ddr.Length > 0)
            {
                if (poiCol.InputType == "P")
                {
                    if (ddr[0]["Data"].ToString() == "Y")
                        poiCol.Data = cUtils.ImgUrl(PoiID, poiCol.ColID, cUsr.Token);
                    else
                        poiCol.Data = "";
                }
                else if (poiCol.InputType == "V")
                {
                    poiCol.Data = "";
                    if (ddr[0]["Data"].ToString().StartsWith("Y"))
                    {
                        string[] datas = ddr[0]["Data"].ToString().Split('|');
                        if (datas.Length == 2)
                        {
                            string[] fn = datas[1].Split('.');
                            if (fn.Length == 2)
                                poiCol.Data = ddr[0]["Data"].ToString() + "|" + cUtils.ImgUrl(PoiID, poiCol.ColID, cUsr.Token).Replace(".jpg", "." + fn[1]);
                        }
                    }
                }
                else
                {
                    poiCol.Data = ddr[0]["Data"].ToString();
                    if (poiCol.DataName == "PATCode")
                        poiCol.DataText = GetPATCodeText(poiCol.Data);
                }
            }
            if (poiCol.Data == null) poiCol.Data = "";
        }

        private string GetPATCodeText(string PATCode)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spPOI_GetPATCodeText]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@PATCode", SqlDbType.VarChar,6);
            SqlCmd.SelectCommand.Parameters["@PATCode"].Value = PATCode;

            DataSet DS = new DataSet();

            SqlCmd.Fill(DS);
            SqlConn.Close();

            return DS.Tables[0].Rows[0]["Name"].ToString();
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