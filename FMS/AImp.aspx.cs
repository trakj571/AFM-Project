using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using EBMSMap30;

using NPOI.XSSF.UserModel;
using NPOI.XSSF;
using NPOI.POIFS.FileSystem;
using NPOI.XSSF.Util;
using System.Text;
using System.Xml;
using System.Globalization;
using NPOI.HSSF.UserModel;

namespace AFMProj.FMS
{
    public partial class AImp : System.Web.UI.Page
    {
        public int retID = 0;
        public DataTable tbMD1, tbC,tbF;
        public string fileName = "",fID = "0",nEvent = "0";

        protected void Page_Load(object sender, EventArgs e)
        {
            var uIdentity = EBMSMap30.cUsr.GetIdentity(EBMSMap30.cUsr.Token);
            if (!uIdentity.IsVerify)
            {
                Response.Redirect("../UR/Logout.aspx");
            }
            
            if (uIdentity.Permission["IsFMSFMon"].ToString() != "Y")
            {
                if (uIdentity.Permission["IsFMSViewOnly"].ToString() == "Y" || uIdentity.Permission["IsFMSEdit"].ToString() == "Y")
                {
                    Response.Redirect("AnChk.aspx");
                }
                else
                {
                    Response.Redirect("../DashB");
                }
            }

            if (Request.QueryString["file"] != null) {
                rFile1.Enabled = false;
            }

            if (!Page.IsPostBack)
            {
                TmpKey.Value = Comm.RandPwd(10) + string.Format("-{0:yyMMddHHmmss}", DateTime.Now);
                DtBegin.Value = string.Format(new CultureInfo("th-TH"), "{0:dd/MM/yyyy}", DateTime.Now);
                TmBegin.Value = string.Format(new CultureInfo("th-TH"), "{0:HH:mm}", DateTime.Now);
                DtEnd.Value = string.Format(new CultureInfo("th-TH"), "{0:dd/MM/yyyy}", DateTime.Now.AddHours(1));
                TmEnd.Value = string.Format(new CultureInfo("th-TH"), "{0:HH:mm}", DateTime.Now.AddHours(1));

                for (int i = 0; i < 60; i++)
                {
                    if (i <= 24)
                    {
                        nHr.Items.Add(new ListItem(string.Format("{0:00}", i), i.ToString()));
                    }
                    nMin.Items.Add(new ListItem(string.Format("{0:00}", i), i.ToString()));
                    nSec.Items.Add(new ListItem(string.Format("{0:00}", i), i.ToString()));
                }

                nHr.Value = "0";
                nMin.Value = "0";
                nSec.Value = "10";

                if (Request.QueryString["file"] != null)
                {
                    ReadDateTime();
                }
            }

        }

       

        protected void bSave_ServerClick(object sender, EventArgs e)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spFMSFileSave", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@TmpKey", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@TmpKey"].Value = Request["TmpKey"];

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = cConvert.ToInt(Request["PoiID"]);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            retID = Convert.ToInt32(DS.Tables[0].Rows[0]["retID"]);

            //GetMainDisp(retID);
        }


        private void ReadDateTime() {
            try
            {
                var fi1 = new FileInfo(ConfigurationManager.AppSettings["FTPAFM1Dir"] + @"\" + Request.QueryString["file"]);
                if (fi1.Extension != ".csv") return;

                Regex CSVParser = new Regex(",(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))");
                var csvtexts = File.ReadAllLines(fi1.FullName);
                if (csvtexts.Length == 0) return;
                var line1 = csvtexts[0].Split(',');
                var sdt = line1[3].Split('-');
                var stm = line1[4].Split(':');
                var dt = new DateTime(cConvert.ToInt(sdt[0]), cConvert.ToInt(sdt[1]), cConvert.ToInt(sdt[2]), cConvert.ToInt(stm[0]), cConvert.ToInt(stm[1]), cConvert.ToInt(stm[2]));

                DtBegin.Value = string.Format(new CultureInfo("th-TH"), "{0:dd/MM/yyyy}", dt);
                TmBegin.Value = string.Format(new CultureInfo("th-TH"), "{0:HH:mm}", dt);

            }
            catch (Exception) { }
          

        }
        protected void bPreview_ServerClick(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;
            int nSec = cConvert.ToInt(Request["nHr"]) * 3600 + cConvert.ToInt(Request["nMin"]) * 60 + cConvert.ToInt(Request["nSec"]);

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spDMSFileAdd", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@TmpKey", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@TmpKey"].Value = Request["TmpKey"];

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = cConvert.ToInt(Request["PoiID"]);

            SqlCmd.SelectCommand.Parameters.Add("@DataType", SqlDbType.Char, 1);
            SqlCmd.SelectCommand.Parameters["@DataType"].Value = "O";
            string fileExt = "";

            if (Request.QueryString["file"] != null)
            {
                var fi = new FileInfo(ConfigurationManager.AppSettings["FTPAFM1Dir"]+@"\"+Request.QueryString["file"]);

                SqlCmd.SelectCommand.Parameters.Add("@FileName", SqlDbType.VarChar, 100);
                SqlCmd.SelectCommand.Parameters["@FileName"].Value = fi.Name;

                fileExt = fi.Name.Substring(fi.Name.LastIndexOf(".") + 1).ToLower();
                SqlCmd.SelectCommand.Parameters.Add("@FileExt", SqlDbType.VarChar, 20);
                SqlCmd.SelectCommand.Parameters["@FileExt"].Value = fileExt;
            }
            else
            {
                var fi = new FileInfo(File1.PostedFile.FileName);

                SqlCmd.SelectCommand.Parameters.Add("@FileName", SqlDbType.VarChar, 100);
                SqlCmd.SelectCommand.Parameters["@FileName"].Value = fi.Name;

                if (File1.PostedFile.ContentLength > 0)
                {
                    fileExt = File1.PostedFile.FileName.Substring(File1.PostedFile.FileName.LastIndexOf(".") + 1).ToLower();
                    SqlCmd.SelectCommand.Parameters.Add("@FileExt", SqlDbType.VarChar, 20);
                    SqlCmd.SelectCommand.Parameters["@FileExt"].Value = fileExt;
                }
            }
            SqlCmd.SelectCommand.Parameters.Add("@DtBegin", SqlDbType.DateTime);
            SqlCmd.SelectCommand.Parameters["@DtBegin"].Value = cConvert.ConvertToDateTH(DtBegin.Value+" "+TmBegin.Value);

            //SqlCmd.SelectCommand.Parameters.Add("@DtEnd", SqlDbType.DateTime);
            //SqlCmd.SelectCommand.Parameters["@DtEnd"].Value = cConvert.ConvertToDateTH(DtEnd.Value + " " + TmEnd.Value);

            SqlCmd.SelectCommand.Parameters.Add("@nSec", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@nSec"].Value = nSec;

            SqlCmd.SelectCommand.Parameters.Add("@fFreq", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@fFreq"].Value = cConvert.ToDouble(fFreq.Value);

            SqlCmd.SelectCommand.Parameters.Add("@tFreq", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@tFreq"].Value = cConvert.ToDouble(tFreq.Value);

            SqlCmd.SelectCommand.Parameters.Add("@ChSp", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@ChSp"].Value = cConvert.ToDouble(ChSp.Value);

            SqlCmd.SelectCommand.Parameters.Add("@Lat", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lat"].Value = cConvert.ToDouble(Lat.Value);

            SqlCmd.SelectCommand.Parameters.Add("@Lng", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lng"].Value = cConvert.ToDouble(Lng.Value);

            SqlCmd.SelectCommand.Parameters.Add("@PatCode", SqlDbType.VarChar,6);
            SqlCmd.SelectCommand.Parameters["@PatCode"].Value = PatCode.Value;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            int retAID = Convert.ToInt32(DS.Tables[0].Rows[0]["retID"]);



            
            try
            {
                if (retAID > 0)
                {
                    if (Request.QueryString["file"] != null)
                    {
                        var fi1 = new FileInfo(ConfigurationManager.AppSettings["FTPAFM1Dir"] + @"\" + Request.QueryString["file"]);
                        string fileid = string.Format("{0:000000000}", retAID);
                        FileInfo fi = new FileInfo(HttpContext.Current.Server.MapPath("../Files") + @"\" + @"DMS\File" + @"\" + fileid.Substring(0, 3) + @"\" + fileid.Substring(3, 3) + @"\" + fileid.Substring(6, 3) + "." + fileExt);


                        if (!fi.Directory.Exists)
                            fi.Directory.Create();

                        fi1.CopyTo(fi.FullName);
                    }
                    else
                    {
                        MData.SaveFileData(File1, @"DMS\File", DS.Tables[0].Rows[0]["retID"]);
                    }

                    if (fileExt == "xls")
                    {
                        ProcessXLS(DS.Tables[0].Rows[0]["retID"], fileExt);
                    }
                    if (fileExt == "xlsx")
                    {
                        ProcessXLSx(DS.Tables[0].Rows[0]["retID"], fileExt);
                    }
                    if (fileExt == "csv" || fileExt == "spa")
                    {
                        ProcessCSV(DS.Tables[0].Rows[0]["retID"], fileExt);
                    }
                    if (fileExt == "compressed" || fileExt == "rtxt")
                    {
                        ProcessCSVTab(DS.Tables[0].Rows[0]["retID"], fileExt);
                    }
                    if (fileExt == "xml")
                    {
                        ProcessXML(DS.Tables[0].Rows[0]["retID"], fileExt);
                    }

                    fileName = "../Files/DMS/File/" + MData.GetSaveFileUrl(DS.Tables[0].Rows[0]["retID"]) + "." + fileExt;
                    fID = DS.Tables[0].Rows[0]["retID"].ToString();

                }

                GetMainDisp(retAID);
                LogImp("OK", "", "");
            }
            catch (Exception ex)
            {
                retID = -99;
                LogImp("ERR", "ผิด Format",ex.Message);
            }
        }

        private void GetMainDisp(int fID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spFMS_MainDisp", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@fID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@fID"].Value = fID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbMD1 = DS.Tables[0];
            tbC = DS.Tables[1];
            tbF = DS.Tables[2];

        }
        public bool IsMobile()
        {
            try
            {
                string u = Request.ServerVariables["HTTP_USER_AGENT"];
                Regex b = new Regex(@"(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino", RegexOptions.IgnoreCase | RegexOptions.Multiline);
                Regex v = new Regex(@"1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-", RegexOptions.IgnoreCase | RegexOptions.Multiline);
                if ((b.IsMatch(u) || v.IsMatch(u.Substring(0, 4))))
                {
                    return true;
                }

            }
            catch (Exception) { }
            return false;
        }

        private void PutData(CSVData data, string cs, string f)
        {
            if (cs == "A") data.A = f;
            if (cs == "B") data.B = f;
            if (cs == "C") data.C = f;
            if (cs == "D") data.D = f;
            if (cs == "E") data.E = f;
            if (cs == "F") data.F = f;
            if (cs == "G") data.G = f;
            if (cs == "H") data.H = f;
            if (cs == "I") data.I = f;
            if (cs == "J") data.J = f;
            if (cs == "K") data.K = f;

            if (cs == "L") data.L = f;
            if (cs == "M") data.M = f;
            if (cs == "N") data.N = f;
            if (cs == "O") data.O = f;
            if (cs == "P") data.P = f;
            if (cs == "Q") data.Q = f;
            if (cs == "R") data.R = f;
            if (cs == "S") data.S = f;
            if (cs == "T") data.T = f;
            if (cs == "U") data.U = f;
            if (cs == "V") data.V = f;
            if (cs == "W") data.W = f;
            if (cs == "X") data.X = f;
            if (cs == "Y") data.Y = f;
            if (cs == "Z") data.Z = f;

        }
        private void InsertCSV(CSVDatas csvDatas)
        {
            using (IDataReader reader = csvDatas.GetDataReader())
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]))
            using (SqlBulkCopy bcp = new SqlBulkCopy(conn))
            {
                conn.Open();
                bcp.BulkCopyTimeout = 30 * 60;
                bcp.DestinationTableName = "AFM_LOG.dbo.tbDMS_CSV";
                bcp.WriteToServer(reader);
            }

        }

        private void ClrAFCCSV(object fID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spDMS_CSVClr", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@fID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@fID"].Value = fID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

        }

        private void ProcessCSV(object id,string FileExt)
        {
            ClrAFCCSV(id);

            string fileid = string.Format("{0:000000000}", id);
            FileInfo fi = new FileInfo(HttpContext.Current.Server.MapPath("../Files") + @"\DMS\File\" + fileid.Substring(0, 3) + @"\" + fileid.Substring(3, 3) + @"\" + fileid.Substring(6, 3) + "." + FileExt);

            if (!fi.Exists) return;

            Regex CSVParser = new Regex(",(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))");
            var csvtexts = File.ReadAllLines(fi.FullName);

            string C = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM,AN,AO,AP,AQ,AR,AS,AT,AU,AV,AW,AX,AY,AZ";
            string[] Cs = C.Split(',');

            int rownum = 0;
            var csvDatas = new CSVDatas();
            for (int i = 0; i < csvtexts.Length; i++)
            {
                if (csvtexts[0].Trim() == "sep=^")
                {
                    if (i == 0)
                        continue;
                    csvtexts[i] = csvtexts[i].Replace("^", ",");
                }


                rownum++;


                CSVData data = new CSVData();
                data.fID = cConvert.ToInt(id);
                data.rowNum = rownum;

                string[] Fields = CSVParser.Split(csvtexts[i]);
                for (int j = 0; j < Fields.Length; j++)
                {
                    string f = Fields[j].Replace("\"", "");
                    PutData(data, Cs[j], f);

                }
                csvDatas.Add(data);
            }
            InsertCSV(csvDatas);

            /*int rownum = 0;
            for (int i = 0; i < csvtexts.Length; i++)
            {
                
                if (csvtexts[0].Trim() == "sep=^")
                {
                    if (i == 0)
                        continue;
                    csvtexts[i] = csvtexts[i].Replace("^", ",");
                }
               

                rownum++;
                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
                SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spDMS_CSVAdd", SqlConn);
                SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

                SqlCmd.SelectCommand.Parameters.Add("@fID", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@fID"].Value = id;

                SqlCmd.SelectCommand.Parameters.Add("@RowNum", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@RowNum"].Value = rownum;


                
                string[] Fields = CSVParser.Split(csvtexts[i]);
                for (int j = 0; j < Fields.Length; j++)
                {
                    string f = Fields[j].Replace("\"", "");

                    SqlCmd.SelectCommand.Parameters.Add("@" + Cs[j], SqlDbType.NVarChar, 100);
                    SqlCmd.SelectCommand.Parameters["@" + Cs[j]].Value = f;

                }

                DataSet DS = new DataSet();
                SqlCmd.Fill(DS);
                SqlConn.Close();
            }*/

        }

        private void ProcessCSVTab(object id,string fileExt)
        {
            ClrAFCCSV(id);

            string fileid = string.Format("{0:000000000}", id);
            FileInfo fi = new FileInfo(HttpContext.Current.Server.MapPath("../Files") + @"\DMS\File\" + fileid.Substring(0, 3) + @"\" + fileid.Substring(3, 3) + @"\" + fileid.Substring(6, 3) + "."+fileExt);

            if (!fi.Exists) return;

            Regex CSVParser = new Regex(",(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))");
            var csvtexts = File.ReadAllLines(fi.FullName);
            string C = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM,AN,AO,AP,AQ,AR,AS,AT,AU,AV,AW,AX,AY,AZ";
            string[] Cs = C.Split(',');

            var csvDatas = new CSVDatas();
            for (int i = 0; i < csvtexts.Length; i++)
            {
                CSVData data = new CSVData();
                data.fID = cConvert.ToInt(id);
                data.rowNum = i + 1;

                string[] Fields = CSVParser.Split(csvtexts[i].Replace("\t", ","));
                for (int j = 0; j < Fields.Length; j++)
                {
                    string f = Fields[j].Replace("\"", "");
                    PutData(data, Cs[j], f);

                }
                csvDatas.Add(data);
            }
            InsertCSV(csvDatas);

            /*for (int i = 0; i < csvtexts.Length; i++)
            {
                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
                SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spDMS_CSVAdd", SqlConn);
                SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

                SqlCmd.SelectCommand.Parameters.Add("@fID", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@fID"].Value = id;

                SqlCmd.SelectCommand.Parameters.Add("@RowNum", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@RowNum"].Value = (i + 1);


                string[] Fields = CSVParser.Split(csvtexts[i].Replace("\t",","));
                for (int j = 0; j < Fields.Length; j++)
                {
                    string f = Fields[j].Replace("\"", "");

                    SqlCmd.SelectCommand.Parameters.Add("@" + Cs[j], SqlDbType.NVarChar, 100);
                    SqlCmd.SelectCommand.Parameters["@" + Cs[j]].Value = f;

                }

                DataSet DS = new DataSet();
                SqlCmd.Fill(DS);
                SqlConn.Close();
            }*/

        }

        private void ProcessXLSx(object id, string fileExt)
        {
            ClrAFCCSV(id);

            string fileid = string.Format("{0:000000000}", id);
            FileInfo fi = new FileInfo(HttpContext.Current.Server.MapPath("../Files") + @"\DMS\File\" + fileid.Substring(0, 3) + @"\" + fileid.Substring(3, 3) + @"\" + fileid.Substring(6, 3) + "." + fileExt);

            if (!fi.Exists) return;
            using (FileStream ips = new FileStream(fi.FullName, FileMode.Open, FileAccess.Read))
            {
                var hssfwb = new XSSFWorkbook(ips);
                var sheet = hssfwb.GetSheetAt(0);
                string C = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM,AN,AO,AP,AQ,AR,AS,AT,AU,AV,AW,AX,AY,AZ";
                string[] Cs = C.Split(',');

                var csvDatas = new CSVDatas();
                for (int i = 0; i <= sheet.LastRowNum; i++)
                {
                    if (sheet.GetRow(i) != null)
                    {

                        CSVData data = new CSVData();
                        data.fID = cConvert.ToInt(id);
                        data.rowNum = i + 1;


                        for (int j = 0; j <= sheet.GetRow(i).LastCellNum; j++)
                        {
                            try
                            {
                                string f = sheet.GetRow(i).GetCell(j).ToString();
                                PutData(data, Cs[j], f);
                            }
                            catch (Exception) { }
                        }
                        csvDatas.Add(data);
                    }

                }
                InsertCSV(csvDatas);

            }

        }
        private void ProcessXLS(object id,string fileExt)
        {
            ClrAFCCSV(id);

            string fileid = string.Format("{0:000000000}", id);
            FileInfo fi = new FileInfo(HttpContext.Current.Server.MapPath("../Files") + @"\DMS\File\" + fileid.Substring(0, 3) + @"\" + fileid.Substring(3, 3) + @"\" + fileid.Substring(6, 3) + "." + fileExt);

            if (!fi.Exists) return;
            using (FileStream ips = new FileStream(fi.FullName, FileMode.Open, FileAccess.Read))
            {
                var hssfwb = new HSSFWorkbook(ips);
                var sheet = hssfwb.GetSheetAt(0);
                string C = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM,AN,AO,AP,AQ,AR,AS,AT,AU,AV,AW,AX,AY,AZ";
                string[] Cs = C.Split(',');

                var csvDatas = new CSVDatas();
                for (int i = 0; i <= sheet.LastRowNum; i++)
                {
                    if (sheet.GetRow(i) != null)
                    {

                        CSVData data = new CSVData();
                        data.fID = cConvert.ToInt(id);
                        data.rowNum = i + 1;


                        for (int j = 0; j <= sheet.GetRow(i).LastCellNum; j++)
                        {
                            try
                            {
                                string f = sheet.GetRow(i).GetCell(j).ToString();
                                PutData(data, Cs[j], f);
                            }
                            catch (Exception) { }
                        }
                        csvDatas.Add(data);
                    }

                }
                InsertCSV(csvDatas);

            }
            
        }


        private void ProcessXML(object id, string fileExt)
        {
            ClrAFCCSV(id);

            string fileid = string.Format("{0:000000000}", id);
            FileInfo fi = new FileInfo(HttpContext.Current.Server.MapPath("../Files") + @"\DMS\File\" + fileid.Substring(0, 3) + @"\" + fileid.Substring(3, 3) + @"\" + fileid.Substring(6, 3) + "." + fileExt);

            if (!fi.Exists) return;

            var xmltexts = File.ReadAllText(fi.FullName);

            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(xmltexts);

            String date =xmlDoc.DocumentElement.Attributes["date"].InnerText;
            String time = xmlDoc.DocumentElement.Attributes["time"].InnerText;

            XmlNodeList nodeList = xmlDoc.DocumentElement.SelectNodes("//DATA");
            var csvDatas = new CSVDatas();
            int i = 0;
            foreach (XmlNode node in nodeList)
            {
                CSVData data = new CSVData();
                data.fID = cConvert.ToInt(id);
                data.rowNum = i + 1;
                data.A = node.Attributes["x"].InnerText;
                data.B = node.Attributes["y"].InnerText;
                data.C = date + " " + time;
                csvDatas.Add(data);
                i++;
            }
            InsertCSV(csvDatas);

            /*
            foreach (XmlNode node in nodeList)
            {
                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
                SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spDMS_CSVAdd", SqlConn);
                SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

                SqlCmd.SelectCommand.Parameters.Add("@fID", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@fID"].Value = id;

                SqlCmd.SelectCommand.Parameters.Add("@RowNum", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@RowNum"].Value = (i + 1);

                SqlCmd.SelectCommand.Parameters.Add("@A", SqlDbType.NVarChar, 100);
                SqlCmd.SelectCommand.Parameters["@A"].Value = node.Attributes["x"].InnerText;

                SqlCmd.SelectCommand.Parameters.Add("@B", SqlDbType.NVarChar, 100);
                SqlCmd.SelectCommand.Parameters["@B"].Value = node.Attributes["y"].InnerText;

                SqlCmd.SelectCommand.Parameters.Add("@C", SqlDbType.NVarChar, 100);
                SqlCmd.SelectCommand.Parameters["@C"].Value = date+" "+time;

                

                DataSet DS = new DataSet();
                SqlCmd.Fill(DS);
                SqlConn.Close();
                i++;
            }

            */
        }


        protected void LogImp(string result, string remark, string error)
        {

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[dms].[spDMS_ImpLog]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@TmpKey", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@TmpKey"].Value = Request["TmpKey"];

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = cConvert.ToInt(Request["PoiID"]);

            SqlCmd.SelectCommand.Parameters.Add("@ImpType", SqlDbType.Char, 1);
            SqlCmd.SelectCommand.Parameters["@ImpType"].Value = "W";

            SqlCmd.SelectCommand.Parameters.Add("@Result", SqlDbType.VarChar, 5);
            SqlCmd.SelectCommand.Parameters["@Result"].Value = result;

            SqlCmd.SelectCommand.Parameters.Add("@Remark", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Remark"].Value = remark;

            SqlCmd.SelectCommand.Parameters.Add("@Error", SqlDbType.VarChar, 250);
            SqlCmd.SelectCommand.Parameters["@Error"].Value = error;


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
        }
    }
}