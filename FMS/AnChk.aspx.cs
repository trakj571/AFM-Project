using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Net;
using EBMSMap30;
using System.Web.Script.Serialization;
using System.Security.Cryptography.X509Certificates;

namespace AFMProj.FMS
{
    public partial class AnChk : System.Web.UI.Page
    {
        private static bool ValidateRemoteCertificate(object sender, X509Certificate certificate, X509Chain chain, System.Net.Security.SslPolicyErrors policyErrors)
        {
            return true;
        }
        public DataTable tbH, tbD;
        List<MInput> mInputs = new List<MInput>();

        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (!Page.IsPostBack)
            {
                if (fDt.Value == "") fDt.Value = string.Format("{0:dd/MM/yyyy}", DateTime.Now.AddDays(-1));
                if (tDt.Value == "") tDt.Value = string.Format("{0:dd/MM/yyyy}", DateTime.Now);

                MData.GetUItems(RegID, "fms.vwRegionLy");
                MData.GetUItems(AreaID, "fms.vwAreaLy", "AreaID", "Name");
                MData.GetUItems(AreaID_raw, "fms.vwAreaLy", "RegID,AreaID", "Name");

                MData.GetUItems(PoiID, "vwAFM", "PoiID", "Name");
                MData.GetUItems(PoiID_raw, "vwAFM", "AreaID,PoiID", "Name");
                //GetEuips();
            }


            if (Request.ServerVariables["query_string"].ToString() != "")
            {
                RegID.Value = cText.StrFromUTF8(Request.QueryString["RegID"]);
                AreaID.Value = cText.StrFromUTF8(Request.QueryString["AreaID"]);
                PoiID.Value = cText.StrFromUTF8(Request.QueryString["PoiID"]);
                fDt.Value = cText.StrFromUTF8(Request.QueryString["fDt"]);
                tDt.Value = cText.StrFromUTF8(Request.QueryString["tDt"]);
                fFreq.Value = cText.StrFromUTF8(Request.QueryString["fFreq"]);
                tFreq.Value = cText.StrFromUTF8(Request.QueryString["tFreq"]);
                ChSp.Value = cText.StrFromUTF8(Request.QueryString["ChSp"]);
                Mode.Value = cText.StrFromUTF8(Request.QueryString["Mode"]);

                DateTime fdt = cConvert.ConvertToDateTH(fDt.Value) == null ? DateTime.Now : (DateTime)cConvert.ConvertToDateTH(fDt.Value);
                DateTime tdt = cConvert.ConvertToDateTH(tDt.Value) == null ? DateTime.Now : (DateTime)cConvert.ConvertToDateTH(tDt.Value);

                fDt.Value = string.Format("{0:dd/MM/yyyy}",fdt);
                tDt.Value = string.Format("{0:dd/MM/yyyy}", tdt);

                mInputs.Add(new MInput() { HtmlInput = RegID, DBType = MInput.DataType.Int });
                mInputs.Add(new MInput() { HtmlInput = AreaID, DBType = MInput.DataType.Int });

                mInputs.Add(new MInput() { HtmlInput = PoiID, DBType = MInput.DataType.Int });
                mInputs.Add(new MInput() { HtmlInput = ChSp, DBType = MInput.DataType.Double });
                mInputs.Add(new MInput() { HtmlInput = Mode, DBType = MInput.DataType.String });
                
                SchData();
            }
        }

        private void GetEuips()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spEquip_Gets]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@EquType", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@EquType"].Value = "STN";

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            DataTable tbE = DS.Tables[0];
            PoiID.Items.Clear();
            PoiID.Items.Add(new ListItem("= ทั้งหมด =", "0"));

            for (int i = 0; i < tbE.Rows.Count; i++)
            {
                PoiID.Items.Add(new ListItem(tbE.Rows[i]["Name"].ToString(), tbE.Rows[i]["PoiID"].ToString()));
            }
        }


        private void SchData()
        {
            string spName = "fms.spScanSch";
            //if(RegID.Value=="8")
              //  spName = "fms.spScanSch_AFM2";
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter(spName, SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@fDt", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@fDt"].Value = cConvert.ConvertToDateTH(fDt.Value);

            SqlCmd.SelectCommand.Parameters.Add("@tDt", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@tDt"].Value = cConvert.ConvertToDateTH(tDt.Value);

            SqlCmd.SelectCommand.Parameters.Add("@fFreq", SqlDbType.BigInt);
            SqlCmd.SelectCommand.Parameters["@fFreq"].Value = cConvert.ToDouble(fFreq.Value)*1000000;

            SqlCmd.SelectCommand.Parameters.Add("@tFreq", SqlDbType.BigInt);
            SqlCmd.SelectCommand.Parameters["@tFreq"].Value = cConvert.ToDouble(tFreq.Value) * 1000000;

            MData.AddSqlCmd(SqlCmd, mInputs);

            if (Request["export"] != null)
            {
                SqlCmd.SelectCommand.Parameters.Add("@nPage", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@nPage"].Value = 30000;
            }
            else
            {
                SqlCmd.SelectCommand.Parameters.Add("@Page", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@Page"].Value = Request["Page"];
            }

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbH = DS.Tables[0];
            tbD = DS.Tables[1];
            DataTable tbP = DS.Tables[2];
            if (Mode.Value == "M" && cConvert.ToInt(PoiID.Value)<=5)
            {
                tbH.Rows[0]["PageSize"] = 1000;
                tbH.Rows[0]["Page"] = 1;

                //tbD.Clear();
                ServicePointManager.ServerCertificateValidationCallback += new System.Net.Security.RemoteCertificateValidationCallback(ValidateRemoteCertificate);

                using (var w = new WebClient())
                {

                    var json_data = string.Empty;
                    string url = "https://lmtr.nbtc.go.th/afm/1.01/service/record.php";
                    string parms = "id=" + PoiID.Value + "&start=" + GetSec1970((DateTime)cConvert.ConvertToDateTH(fDt.Value)) + "&end=" + (GetSec1970((DateTime)cConvert.ConvertToDateTH(tDt.Value))) + "&limit=1000&offset=0";

                    cUtils.Log("fmschk", url + "?" + parms);

                    // attempt to download JSON data as a string
                    try
                    {
                        json_data = w.DownloadString(url + "?" + parms);
                        JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
                        var result = (Dictionary<string, object>)jsSerializer.DeserializeObject(json_data);

                        var data = (Object[])result["data"];



                        int total = 0;
                        for (int i = 0; i < data.Length; i++)
                        {
                            var d = (Dictionary<string, object>)data[i];
                            if (d.ContainsKey("station"))
                            {
                                var poi = tbP.Select("PoiID=" + d["station"]);
                                if (poi.Length == 0)
                                    continue;
                            }
                            total++;
                            DataRow dr = tbD.NewRow();
                          
                            if (d.ContainsKey("station"))
                                dr["Station"] = "Station-" + d["station"];
                            else
                                dr["Station"] = "Station-" + PoiID.Value;

                            dr["DtBegin"] = GetDT1970(cConvert.ToDouble(d["start"]));
                            dr["DtEnd"] = GetDT1970(cConvert.ToDouble(d["end"]));
                            dr["Mode"] = "M";
                            dr["ModeName"] = "Listening";
                            dr["nTime"] = ToHHMMSS(cConvert.ToDouble(d["duration"]));
                            dr["DataPath"] = result["datapath"];
                            dr["PlayList"] = d["playlist"];

                            tbD.Rows.Add(dr);
                        }

                        tbH.Rows[0]["nTotal"] = tbD.Rows.Count;

                    }
                    catch (Exception ex)
                    {
                        cUtils.Log("fmschk", url + "?" + parms+" "+ ex.ToString());
                    }
                    // if string with JSON data is not empty, deserialize it to clas
                }
            }

            if (Request["export"] != null)
            {
                List<string> columns = new List<string>();
                columns.Add("Station:Station");
                columns.Add("DtBegin:วัน-เวลา เริ่มต้น");
                columns.Add("DtEnd:วัน-เวลา สิ้นสุด");
                columns.Add("ModeName:Mode");
                columns.Add("nEvent:Event");
                

                Export.ToFile(tbD, columns, "", "");
            }
        }
        private long GetSec1970(DateTime current)
        {
            return (long)current.ToUniversalTime().Subtract(
                new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)
                ).TotalMilliseconds / 1000;
        }
        private DateTime GetDT1970(double timestamp)
        {
            DateTime origin = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
            return origin.AddSeconds(timestamp);

        }

        private string ToHHMMSS(double sec_num)
        {
            //var sec_num = parseInt(this, 10); // don't forget the second param
            var hours = Math.Floor(sec_num / 3600);
            var minutes = Math.Floor((sec_num - (hours * 3600)) / 60);
            var seconds = sec_num - (hours * 3600) - (minutes * 60);

            var time = string.Format("{0:00}:{1:00}:{2:00}", hours, minutes, seconds);
            return time;
        }

        private DateTime ConvertToDate(string dtm)
        {
            //08-03-2018 13:59:50
            string dt = dtm.Split(' ')[0];
            string tm = dtm.Split(' ')[1];
            try
            {
                string[] dts = dt.Split('-');
                string[] tms = tm.Split(':');
                DateTime ret = new DateTime(
                    int.Parse(dts[2]),
                    int.Parse(dts[1]),
                    int.Parse(dts[0]),
                    int.Parse(tms[0]),
                    int.Parse(tms[1]), 0

                    );

                if (ret > DateTime.Now.AddYears(-100) && ret < DateTime.Now.AddYears(100))
                    return ret;
            }
            catch (Exception)
            { }

            return new DateTime(1990,1,1);
        }
    }
}