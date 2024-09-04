using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using EBMSMap30;
using System.Net;
using System.IO;

namespace EBMSMap30.UR
{
    public partial class OTPPwd : System.Web.UI.Page
    {
        public int retCode = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            GetOTP();
        }

        private void GetOTP()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD30"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spFgtPwd", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Login", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Login"].Value = Request.QueryString["u"];

            SqlCmd.SelectCommand.Parameters.Add("@Type", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Type"].Value = "S";

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            //retCode = Convert.ToInt32(DS.Tables[0].Rows[0]["retCode"]);

            if (Convert.ToInt32(DS.Tables[0].Rows[0]["retCode"]) == 1)
            {
                //SMS
                string TelNo = DS.Tables[0].Rows[0]["TelNo"].ToString();
                TelNo = TelNo.Replace("-", "");
                TelNo = TelNo.Replace(" ", "");
                if (TelNo.Length == 10)
                    SendSms(TelNo, "AFM รหัส OTP สำหรับเปลี่ยนรหัสผ่านของคุณคือ " + DS.Tables[0].Rows[0]["OTP"]);
            }
        }

        public static void SendSms(string mobileno, string msg)
        {
            try
            {
                //for SSL (https)
                //ServicePointManager.CertificatePolicy = new trustedCertificatePolicy();
                /*
                string lcUrl = "http://smsapi.cheesemobile.com:4000";
                HttpWebRequest loHttp = (HttpWebRequest)System.Net.WebRequest.Create(lcUrl);
                loHttp.KeepAlive = false;
                loHttp.ProtocolVersion = HttpVersion.Version10;
                string strPost = "username=Talonnet";
                strPost += "&passwd=T5";
                strPost += "&from=S-M-S";
                strPost += "&to=" + mobileno;
                strPost += "&text=" + msg;
                strPost += "&datacoding=U";
                
                loHttp.Method = "POST";
                byte[] lbPostBuffer = System.Text.Encoding.GetEncoding(874).GetBytes(strPost);
                loHttp.ContentLength = lbPostBuffer.Length;
                loHttp.ContentType = "application/x-www-form-urlencoded";

                Stream loPostData = loHttp.GetRequestStream();
                loPostData.Write(lbPostBuffer, 0, lbPostBuffer.Length);
                loPostData.Close();

                HttpWebResponse loWebResponse = (HttpWebResponse)loHttp.GetResponse();
                System.Text.Encoding enc = System.Text.Encoding.GetEncoding(874);
                StreamReader loResponseStream = new StreamReader(loWebResponse.GetResponseStream(), enc);

                string lcHtml = loResponseStream.ReadToEnd();
                loWebResponse.Close();
                loResponseStream.Close();
                 */

                string lcUrl = ConfigurationManager.AppSettings["FwServiceURL"] + "/service/smsfw.aspx";
                HttpWebRequest loHttp = (HttpWebRequest)System.Net.WebRequest.Create(lcUrl);
                loHttp.KeepAlive = false;
                loHttp.ProtocolVersion = HttpVersion.Version10;
                string strPost = "username=Talonnet";
                strPost += "&to=" + mobileno;
                strPost += "&text=" + msg;

                loHttp.Method = "POST";
                byte[] lbPostBuffer = System.Text.Encoding.GetEncoding(874).GetBytes(strPost);
                loHttp.ContentLength = lbPostBuffer.Length;
                loHttp.ContentType = "application/x-www-form-urlencoded";

                Stream loPostData = loHttp.GetRequestStream();
                loPostData.Write(lbPostBuffer, 0, lbPostBuffer.Length);
                loPostData.Close();

                HttpWebResponse loWebResponse = (HttpWebResponse)loHttp.GetResponse();
                System.Text.Encoding enc = System.Text.Encoding.GetEncoding(874);
                StreamReader loResponseStream = new StreamReader(loWebResponse.GetResponseStream(), enc);

                string lcHtml = loResponseStream.ReadToEnd();
                loWebResponse.Close();
                loResponseStream.Close();

                cUtils.Log("sms_otp", " -> " + mobileno + " -> " + msg + " -> OK ");
            }
            catch (Exception ex)
            {
                cUtils.Log("sms_otp", " -> " + mobileno + " -> " + msg + " -> ERR " + ex.ToString());
            }
        }

        protected void bConfirm_ServerClick(object sender, System.EventArgs e)
        {
            if (!Page.IsValid) return;

            cRc4 _rc4 = new cRc4();

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD30"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spResetPwd", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Login", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Login"].Value = Request.QueryString["u"];


            SqlCmd.SelectCommand.Parameters.Add("@Pwd", SqlDbType.NVarChar, 15);
            SqlCmd.SelectCommand.Parameters["@Pwd"].Value = _rc4.EnDeCrypt(Pwd.Value, Pwd.Value);

            SqlCmd.SelectCommand.Parameters.Add("@OTP", SqlDbType.NVarChar, 40);
            SqlCmd.SelectCommand.Parameters["@OTP"].Value = OTP.Value;


            SqlCmd.SelectCommand.Parameters.Add("@Type", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Type"].Value = "S";

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            retCode = Convert.ToInt32(DS.Tables[0].Rows[0]["retCode"]);
        }
        
    }
}