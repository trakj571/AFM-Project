using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using EBMSMap30;
using System.Net;
using System.Web.Script.Serialization;
using System.Security.Cryptography.X509Certificates;

namespace AFMProj.FMS
{
    public partial class PlayRec : System.Web.UI.Page
    {
        private static bool ValidateRemoteCertificate(object sender, X509Certificate certificate, X509Chain chain, System.Net.Security.SslPolicyErrors policyErrors)
        {
            return true;
        }

        public DataTable tbD;
        public string StreamURL;
        protected void Page_Load(object sender, EventArgs e)
        {
            GetScanData();
        }

        private void GetScanData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spScan_Get", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value = Request["ScanID"];


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbD = DS.Tables[0];
            if(tbD.Rows.Count==0)
            {
                Response.End();
            }

            ServicePointManager.ServerCertificateValidationCallback += new System.Net.Security.RemoteCertificateValidationCallback(ValidateRemoteCertificate);

            using (var w = new WebClient())
            {
               
                var json_data = string.Empty;
                string url = "https://lmtr.nbtc.go.th/afm/1.01/service/record.php";
                string parms = "id="+tbD.Rows[0]["PoiID"]+"&start="+GetSec1970((DateTime)tbD.Rows[0]["DtBegin"])+"&end="+(GetSec1970((DateTime)tbD.Rows[0]["DtEnd"]))+"&limit=100&offset=0";

                // attempt to download JSON data as a string
                try
                {
                // https://lmtr.nbtc.go.th/afm/1.01/service/record.php?id=5&start=1505799900&end=1505799910&limit=100&offset=0
                    //w.Headers[HttpRequestHeader.ContentType] = "application/x-www-form-urlencoded";
                    json_data = w.DownloadString(url+"?"+parms);
                    processJson(json_data, GetSec1970((DateTime)tbD.Rows[0]["DtBegin"]));

                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.ToString());
                }
                // if string with JSON data is not empty, deserialize it to clas
            }

        }

        private void processJson(string json_data,long dtbegin)
        {
           // var playlist = "https://lmtr.nbtc.go.th" + obj.datapath + e.playlist;
            JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
            var result = (Dictionary<string, object>)jsSerializer.DeserializeObject(json_data);
            if (result.ContainsKey("datapath"))
            {
                var e = (Object[])result["data"];
                if(e.Length>0){
                    var e0 = (Dictionary<string, object>)e[0];
                    StreamURL = "http://lmtr.nbtc.go.th" + result["datapath"] + e0["playlist"];
                    //long start = (long)cConvert.ToDouble(e0["start"]);
                    //Start = Math.Max(start - dtbegin,0).ToString();

                }
            }
           
        }
        private long GetSec1970(DateTime current)
        {
            return (long)current.ToUniversalTime().Subtract(
                new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)
                ).TotalMilliseconds/ 1000;
        }


    }
}