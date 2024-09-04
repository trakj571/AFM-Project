using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Drawing;

namespace EBMSMap30.data
{
    public partial class addpoi : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        POIDetailSet _PoiDetail;
        String Name = "";
        String ColIDs = "";
        String ColDats = "";
        List<FileUpload> fileUpload;
        protected void bSave_Click(object sender, EventArgs e)
        {
            Name = "";
            ColIDs = "";
            ColDats = "";
            fileUpload = new List<FileUpload>();

            _PoiDetail = GetPOIDetail(Convert.ToInt32(Request["poiid"]), Convert.ToInt32(Request.Form["TypeID"]));

            CollectData(_PoiDetail.POICols);

            for (int i = 0; i < _PoiDetail.POIForms.Count; i++)
            {
                CollectData(_PoiDetail.POIForms[i].POICols);
            }

            bool isOK = AddPOI(Convert.ToInt32(Request.QueryString["poiid"]), Convert.ToInt32(Request.Form["LyID"]), Convert.ToInt32(Request.Form["TypeID"]), Convert.ToInt32(Request.QueryString["PoiType"]),
                Name, Request.Form["LineColor"], Convert.ToInt32(Request.Form["LineOpacity"]), Convert.ToInt32(Request.Form["LineWidth"]),
                Request.Form["FillColor"], Convert.ToInt32(Request.Form["FillOpacity"]), Request.Form["Point"], Convert.ToDouble(Request.Form["Distance"]),
                Convert.ToDouble(Request.Form["Area"]), Convert.ToDouble(Request.Form["Radius"]), ColIDs, ColDats, fileUpload);

            if (isOK)
            {
                Response.Write("<script language=javascript>");
                Response.Write("parent.addPOIDone(" + _PoiDetail.PoiID + "," + _PoiDetail.LyID + ", '" + Request.QueryString["tab"] + "','" + (Convert.ToInt32(Request.QueryString["poiid"]) > 0 ? "edit" : "add") + "');");
                Response.Write("</"+"script>");
                Response.End();
            }
            else
            {
                Response.Write("<script language=javascript>");
                Response.Write("alert('Add POI Error');");
                Response.Write("</" + "script>");
            }
        }

        private void CollectData(List<POICol> POICols)
        {
            for (int i = 0; i < POICols.Count; i++)
            {
                var col = POICols[i];
                if (ColIDs!= "")
                {
                    ColIDs += ",";
                    ColDats += ",";
                }
                ColIDs += col.ColID;
                string data = "";
                if (col.InputType == "T")
                {
                    data = Request.Form["ColData_" + col.ColID];
                    if (col.IsHeader)
                    {
                        Name += data + " ";
                    }
                }
                else if (col.InputType == "S")
                {
                    data = Request.Form["ColData_" + col.ColID];
                    if (col.IsHeader)
                    {
                        Name += data + " ";
                    }
                }
                else if (col.InputType == "D")
                {
                    data = Request.Form["ColData_" + col.ColID] + "";
                    if (col.IsHeader)
                    {
                        Name += data + " ";
                    }
                }
                else if (col.InputType == "C")
                {
                    data = Request.Form["ColData_" + col.ColID] + "";

                }
                else if (col.InputType == "P")
                {
                    string del = Request.Form["ColData_D_" + col.ColID];
                    if (del == "1")
                        data = "N";
                    else
                        data = "Y";

                    if (Request.Files["ColData_" + col.ColID] != null && Request.Files["ColData_" + col.ColID].FileName != "")
                    {
                        data = "Y";
                        Stream stream = Request.Files["ColData_" + col.ColID].InputStream;
                        byte[] buffer = new byte[stream.Length];
                        stream.Read(buffer, 0, buffer.Length);
                        fileUpload.Add(new FileUpload() { Key = col.ColID.ToString(), Buffer = buffer });
                    }
                    else
                        data = "N";

                }
                if (col.InputType == "L")
                {
                    data = Request["ColData_" + col.ColID];
                    if (col.IsHeader)
                    {
                        Name += data + " ";
                    }
                }
                else if (col.InputType == "V")
                {
                    string data1 = "";

                    if (Request.Files["ColData_" + col.ColID] != null)
                    {
                        data1 = Request.Files["ColData_" + col.ColID].FileName.Replace("/", @"\");
                        if (data1 != "")
                            data1 = data1.Substring(data1.LastIndexOf(@"\") + 1);
                    }

                    string del = Request["ColData_D_" + col.ColID];
                    if (del == "1")
                        data = "N";
                    else
                        data = "Y|" + data1;

                    if (data1 != "")
                    {
                        data = "Y|" + data1;
                        Stream stream = Request.Files["ColData_" + col.ColID].InputStream;
                        byte[] buffer = new byte[stream.Length];
                        stream.Read(buffer, 0, buffer.Length);
                        fileUpload.Add(new FileUpload() { Key = col.ColID.ToString(), Buffer = buffer });
                    }
                    else
                        data = "N";
                }

                ColDats += cUtils.ReplaceComma(data + "");

            }
        }

        public bool AddPOI(int PoiID, int LyID, int TypeID, int PoiType, string Name, string LineColor, int LineOpacity, int LineWidth,
             string FillColor, int FillOpacity, string Points, double Distance, double Area, double Radius,
             string ColIDs, string ColDats, List<FileUpload> fileUpload)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spPOI_Add]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@poiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@poiID"].Value = PoiID;

            SqlCmd.SelectCommand.Parameters.Add("@LyID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@LyID"].Value = LyID;

            SqlCmd.SelectCommand.Parameters.Add("@TypeID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@TypeID"].Value = TypeID;

            SqlCmd.SelectCommand.Parameters.Add("@Name", SqlDbType.NVarChar, 100);
            SqlCmd.SelectCommand.Parameters["@Name"].Value = Name;

            SqlCmd.SelectCommand.Parameters.Add("@PoiType", SqlDbType.TinyInt);
            SqlCmd.SelectCommand.Parameters["@PoiType"].Value = PoiType;

            if (PoiType == 1)
            {

            }
            else if (PoiType == 2)
            {

                SqlCmd.SelectCommand.Parameters.Add("@LineColor", SqlDbType.VarChar, 6);
                SqlCmd.SelectCommand.Parameters["@LineColor"].Value = LineColor;

                SqlCmd.SelectCommand.Parameters.Add("@LineOpacity", SqlDbType.TinyInt);
                SqlCmd.SelectCommand.Parameters["@LineOpacity"].Value = LineOpacity;

                SqlCmd.SelectCommand.Parameters.Add("@LineWidth", SqlDbType.TinyInt);
                SqlCmd.SelectCommand.Parameters["@LineWidth"].Value = LineWidth;
            }
            else if (PoiType == 3 || PoiType == 4)
            {

                SqlCmd.SelectCommand.Parameters.Add("@LineColor", SqlDbType.VarChar, 6);
                SqlCmd.SelectCommand.Parameters["@LineColor"].Value = LineColor;

                SqlCmd.SelectCommand.Parameters.Add("@LineOpacity", SqlDbType.TinyInt);
                SqlCmd.SelectCommand.Parameters["@LineOpacity"].Value = LineOpacity;

                SqlCmd.SelectCommand.Parameters.Add("@LineWidth", SqlDbType.TinyInt);
                SqlCmd.SelectCommand.Parameters["@LineWidth"].Value = LineWidth;

                SqlCmd.SelectCommand.Parameters.Add("@FillColor", SqlDbType.VarChar, 6);
                SqlCmd.SelectCommand.Parameters["@FillColor"].Value = FillColor;

                SqlCmd.SelectCommand.Parameters.Add("@FillOpacity", SqlDbType.TinyInt);
                SqlCmd.SelectCommand.Parameters["@FillOpacity"].Value = FillOpacity;
            }
            if (Points != null)
            {
                
                string[] points = Points.Split(',');
                double Lat1 = 90;
                double Lng1 = 180;
                double Lat2 = -90;
                double Lng2 = -180;
                string StPoint = "";
                if (PoiType == 1 || PoiType == 4)
                {
                    StPoint = "POINT(" + Points.Replace(",", " ") + ")";
                }
                else  if (PoiType == 2)
                {
                    StPoint = "LINESTRING(";
                }
                else  if (PoiType == 3)
                {
                    StPoint = "POLYGON((";
                }
                for (int i = 0; i < points.Length; i += 2)
                {
                    double lng = Convert.ToDouble(points[i]);
                    double lat = Convert.ToDouble(points[i + 1]);
                    Lat1 = Math.Min(Lat1, lat);
                    Lng1 = Math.Min(Lng1, lng);
                    Lat2 = Math.Max(Lat2, lat);
                    Lng2 = Math.Max(Lng2, lng);
                    if (PoiType == 2 || PoiType == 3)
                    {
                        if (i > 0)
                            StPoint += ",";
                        StPoint += points[i] + " " + points[i + 1];
                    }
                }
                if (PoiType == 2)
                {
                    StPoint += ")";
                }
                if (PoiType == 3)
                {
                    if (points[0] + " " + points[1] != points[points.Length - 2] + " " + points[points.Length - 1])
                    {
                        StPoint += ",";
                        StPoint += points[0] + " " + points[1];
                    }
                    StPoint += "))";
                }

                SqlCmd.SelectCommand.Parameters.Add("@Points", SqlDbType.VarChar, StPoint.Length + 1);
                SqlCmd.SelectCommand.Parameters["@Points"].Value = StPoint;


                SqlCmd.SelectCommand.Parameters.Add("@Lat1", SqlDbType.Float);
                SqlCmd.SelectCommand.Parameters["@Lat1"].Value = Lat1;

                SqlCmd.SelectCommand.Parameters.Add("@Lng1", SqlDbType.Float);
                SqlCmd.SelectCommand.Parameters["@Lng1"].Value = Lng1;

                SqlCmd.SelectCommand.Parameters.Add("@Lat2", SqlDbType.Float);
                SqlCmd.SelectCommand.Parameters["@Lat2"].Value = Lat2;

                SqlCmd.SelectCommand.Parameters.Add("@Lng2", SqlDbType.Float);
                SqlCmd.SelectCommand.Parameters["@Lng2"].Value = Lng2;

                SqlCmd.SelectCommand.Parameters.Add("@Distance", SqlDbType.Float);
                SqlCmd.SelectCommand.Parameters["@Distance"].Value = Distance;

                SqlCmd.SelectCommand.Parameters.Add("@Area", SqlDbType.Float);
                SqlCmd.SelectCommand.Parameters["@Area"].Value = Area;

                SqlCmd.SelectCommand.Parameters.Add("@Radius", SqlDbType.Float);
                SqlCmd.SelectCommand.Parameters["@Radius"].Value = Radius;
            }

            SqlCmd.SelectCommand.Parameters.Add("@ColIDs", SqlDbType.NVarChar, ColIDs.Length + 1);
            SqlCmd.SelectCommand.Parameters["@ColIDs"].Value = ColIDs;

            SqlCmd.SelectCommand.Parameters.Add("@ColDats", SqlDbType.NVarChar, ColDats.Length + 1);
            SqlCmd.SelectCommand.Parameters["@ColDats"].Value = ColDats;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            int poiid = Convert.ToInt32(DS.Tables[0].Rows[0]["PoiID"]);
            if (poiid > 0)
            {
                _PoiDetail = GetPOIDetail(poiid, 0);

                string spoiid = string.Format("{0:000000000}", poiid);
                if (fileUpload != null)
                    cUtils.Log("upload", "POI:" + poiid + "-> fileUpload [count] = " + fileUpload.Count);
                else
                    cUtils.Log("upload", "POI:" + poiid + "-> fileUpload = null");
                
                if (fileUpload != null && fileUpload.Count > 0)
                {
                    foreach (FileUpload file in fileUpload)
                    {
                        foreach (POICol pcol in _PoiDetail.POICols)
                        {
                            if (pcol.ColID.ToString() != file.Key)
                                continue;

                            if (pcol.DataType == "P")
                            {
                                FileInfo fi = new FileInfo(ConfigurationManager.AppSettings[cUtils.GetWebDir(cUsr.Token)] + "\\Files\\POI\\" + spoiid.Substring(0, 3) + "\\" + spoiid.Substring(3, 3) + "\\" + spoiid.Substring(6, 3) + "_" + file.Key + ".jpg");
                                try
                                {
                                    if (!fi.Directory.Exists)
                                        fi.Directory.Create();

                                    MemoryStream ms = new MemoryStream(file.Buffer);
                                    Bitmap bm = new Bitmap(ms);
                                    bm.Save(fi.FullName, System.Drawing.Imaging.ImageFormat.Jpeg);
                                    ms.Close();
                                    bm.Dispose();
                                    cUtils.Log("upload", fi.FullName + "-> OK");
                                }
                                catch (Exception ex)
                                {
                                    cUtils.Log("upload", fi.FullName + "-> Error -> " + ex.Message);
                                }
                            }
                            else if (pcol.DataType == "V")
                            {
                                if (pcol.Data == null || pcol.Data == "") continue;
                                string[] pdatas = pcol.Data.Split('|');
                                if (pdatas.Length < 2 || pdatas[1].IndexOf(".") == -1) continue;

                                string ext = pdatas[1].Substring(pdatas[1].LastIndexOf("."));
                                FileInfo fi = new FileInfo(ConfigurationManager.AppSettings[cUtils.GetWebDir(cUsr.Token)] + "\\Files\\POI\\" + spoiid.Substring(0, 3) + "\\" + spoiid.Substring(3, 3) + "\\" + spoiid.Substring(6, 3) + "_" + file.Key + ext);
                                try
                                {
                                    if (!fi.Directory.Exists)
                                        fi.Directory.Create();

                                    FileStream fs = new FileStream(fi.FullName, FileMode.Create);
                                    fs.Write(file.Buffer, 0, file.Buffer.Length);
                                    fs.Close();
                                    cUtils.Log("upload", fi.FullName + "-> OK");
                                }
                                catch (Exception ex)
                                {
                                    cUtils.Log("upload", fi.FullName + "-> Error -> " + ex.Message);
                                }
                            }
                        }
                    }
                }
                return true;
            }

            return false;
        }


        private POIDetailSet GetPOIDetail(int poiid, int typeid)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spPOI_GetDet]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@poiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@poiID"].Value = poiid;

            SqlCmd.SelectCommand.Parameters.Add("@TypeID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@TypeID"].Value = typeid;

            DataSet DS = new DataSet();

            SqlCmd.Fill(DS);
            SqlConn.Close();

            POIDetailSet poiinfoset = new POIDetailSet();
            if (DS.Tables[0].Rows.Count > 0)
            {
                poiinfoset.PoiID = Convert.ToInt32(DS.Tables[0].Rows[0]["PoiID"]);
                poiinfoset.LyID = Convert.ToInt32(DS.Tables[0].Rows[0]["LyID"]);
                poiinfoset.TypeID = Convert.ToInt32(DS.Tables[0].Rows[0]["TypeID"]);
                poiinfoset.PoiType = Convert.ToInt32(DS.Tables[0].Rows[0]["PoiType"]);
                poiinfoset.Name = DS.Tables[0].Rows[0]["Name"].ToString();
                poiinfoset.Points = DS.Tables[0].Rows[0]["Points"].ToString();

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
                    poiCol.InputType = DS.Tables[1].Rows[i]["InputType"].ToString();

                    SetColOpts(poiCol, DS.Tables[2], DS.Tables[1].Rows[i]["ColID"] + "");
                    SetColData(poiCol, DS.Tables[3], DS.Tables[1].Rows[i]["ColID"] + "", poiinfoset.PoiID);
                    /*

                    DataRow[] dr = DS.Tables[2].Select("ColID=" + DS.Tables[1].Rows[i]["ColID"], "optID");
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
                    DataRow[] ddr = DS.Tables[3].Select("ColID=" + DS.Tables[1].Rows[i]["ColID"]);
                    if (ddr.Length > 0)
                    {
                        if (poiCol.InputType == "P")
                        {
                            if (ddr[0]["Data"].ToString() == "Y")
                                poiCol.Data = cUtils.ImgUrl(poiinfoset.PoiID, poiCol.ColID, cUsr.Token);
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
                                        poiCol.Data = ddr[0]["Data"].ToString() + "|" + cUtils.ImgUrl(poiinfoset.PoiID, poiCol.ColID, cUsr.Token).Replace(".jpg", "." + fn[1]);
                                }
                            }
                        }
                        else
                        {
                            poiCol.Data = ddr[0]["Data"].ToString();
                        }
                    }
                     */
                    poiinfoset.POICols.Add(poiCol);
                    
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
                        DataRow[] dr = DS.Tables[5].Select("FormID=" + poiForm.FormID, "iorder");
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
                            poiCol.DpColID = Convert.ToInt32(dr[i]["DpColID"]);

                            SetColOpts(poiCol, DS.Tables[6], dr[i]["ColID"] + "");
                            SetColData(poiCol, DS.Tables[3], dr[i]["ColID"] + "", poiinfoset.PoiID);


                            poiForm.POICols.Add(poiCol);
                        }
                        poiinfoset.POIForms.Add(poiForm);
                    }
                }
            }

            return poiinfoset;
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
                }
            }
            if (poiCol.Data == null) poiCol.Data = "";
        }
    }
}