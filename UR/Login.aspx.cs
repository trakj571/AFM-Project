using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Security;
using System.Drawing;
using System.Text;
using System.IO;
using System.Net;
using System.DirectoryServices;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;

namespace EBMSMap30.UR
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           /*if(Request.QueryString["returnurl"]!=null){
               if (Request.QueryString["returnurl"].ToLower().IndexOf("admin") > -1
                   || Request.QueryString["returnurl"].ToLower().IndexOf("mapadm")>-1)
               {
                   Response.Redirect("Login2.aspx?returnurl=" + Request.QueryString["returnurl"].Replace("/","%2f"));
               }
           }
               */
            if (!Page.IsPostBack)
            {
                Response.Cookies["EBMSToken"].Value = "";
                FormsAuthentication.SignOut();
            }
        }
        protected void bLogin_ServerClick(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            string utype = GetUType();
            if (utype == "NBTC")
            {
                if (!doLogInWithLDAPFw())
                {
                    Rst.Text = "** ไม่สามารถเข้าระบบ โปรดตรวจสอบ ชื่อผู้ใช้งาน/รหัสผ่าน **<br>";
                    Rst.ForeColor = Color.Red;
                    return;
                }
            }

            cRc4 _rc4 = new cRc4();
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spUR_Login", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Login", SqlDbType.NVarChar, 40);
            SqlCmd.SelectCommand.Parameters["@Login"].Value = UserName.Value;

            SqlCmd.SelectCommand.Parameters.Add("@Pwd", SqlDbType.NVarChar, 40);
            SqlCmd.SelectCommand.Parameters["@Pwd"].Value = _rc4.EnDeCrypt(Password.Value, Password.Value);

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = Comm.RandPwd(10) + "." + Comm.RandPwd(10) + "." + Comm.RandPwd(10) + "." + Comm.RandPwd(10);

            SqlCmd.SelectCommand.Parameters.Add("@IsLDAP", SqlDbType.VarChar, 1);
            SqlCmd.SelectCommand.Parameters["@IsLDAP"].Value = utype == "NBTC" ? "Y" : "N";

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = Request.UserHostAddress;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            if (DS.Tables[0].Rows.Count == 0) return;

            int UID = Convert.ToInt32(DS.Tables[0].Rows[0]["UID"]);
            if (UID > 0)
            {
                //Loc
                //Response.Cookies["EBMSLocation"].Value = Location.Value;
                    
                
                string user = "USR,"+DS.Tables[0].Rows[0]["UID"].ToString() + "," + DS.Tables[0].Rows[0]["Grp"] + "," + DS.Tables[0].Rows[0]["FName"] + " " + DS.Tables[0].Rows[0]["LName"];
                user += "," + ConfigurationManager.AppSettings["DBName"] + ":" + DS.Tables[0].Rows[0]["Token"] + ":JS";
                
                if (Request.QueryString["returnurl"] != null)
                {
                    System.Web.Security.FormsAuthentication.SetAuthCookie(user, false);
                  
                    Response.Redirect(Request.QueryString["returnurl"]);
                }
                else
                {
                    System.Web.Security.FormsAuthentication.SetAuthCookie(user, false);
                    if (DS.Tables[0].Rows[0]["Grp"].ToString() == "A")
                    {
                        Response.Redirect("../Admin");
                    }
                    else
                    {
                        Response.Redirect("../Default.aspx");
                    }
                }
            }
            else if (UID==-2)
            {
                Rst.Text = "** รหัสผ่านไม่ถูกต้อง **<br>";
                Rst.ForeColor = Color.Red;

                if (cConvert.ToInt(DS.Tables[0].Rows[0]["nPwdCnt"]) == 5)
                {
                    string email = "";
                    for (int i = 0; i < DS.Tables[1].Rows.Count; i++)
                    {
                        if (i > 0)
                            email += ",";
                        email += DS.Tables[1].Rows[i]["Email"].ToString();
                    }
                    //MailToAdmin(email);
                    //MailToUser();
                }
            }
            else if (UID == -3 || UID == -4)
            {
                Rst.Text = "** ถูกระงับสิทธิ์การใช้งาน โปรดติดต่อผู้ดูแลระบบ **<br>";
                Rst.ForeColor = Color.Red;
            }
        }

        void MailToAdmin(string email)
        {
            /*try
            {
                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
                SqlDataAdapter SqlCmd = new SqlDataAdapter("spUR_Info", SqlConn);
                SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

                SqlCmd.SelectCommand.Parameters.Add("@Login", SqlDbType.NVarChar, 40);
                SqlCmd.SelectCommand.Parameters["@Login"].Value = UserName.Value;

              
                DataSet DS = new DataSet();
                SqlCmd.Fill(DS);
                SqlConn.Close();

                string MailText = "มีผู้เข้าใช้งานระบบ ใส่รหัสผ่านเกินที่กำหนด กรุณาตรวจสอบ โดยมีรายละเอียดดังนี้";
                MailText += "<br /><br /><table style='border-collapse: collapse;border-style: hidden;' cellpadding=4><tr>";
                MailText += "<td style='border: 1px solid black'>ชื่อ-นามสกุล</td>";
                MailText += "<td style='border: 1px solid black'>อีเมล์ </td>";
                MailText += "<td style='border: 1px solid black'>เบอร์โทรศัพท์</td>";
                MailText += "<td style='border: 1px solid black'>ตำแหน่ง</td>";
                MailText += "<td style='border: 1px solid black'>หน่วยงาน</td>";
                MailText += "<td style='border: 1px solid black'>ชื่อล็อกอิน</td>";
                MailText += "<td style='border: 1px solid black'>IP-Address</td></tr>";

                MailText += "<tr><td style='border: 1px solid black'>" + DS.Tables[0].Rows[0]["Fname"] + " " + DS.Tables[0].Rows[0]["LName"] + "</td>";
                MailText += "<td style='border: 1px solid black'>" + DS.Tables[0].Rows[0]["Email"] + " </td>";
                MailText += "<td style='border: 1px solid black'>" + DS.Tables[0].Rows[0]["TelNo"] + " </td>";
                MailText += "<td style='border: 1px solid black'>" + DS.Tables[0].Rows[0]["Rank"] + "+ </td>";
                MailText += "<td style='border: 1px solid black'>" + DS.Tables[0].Rows[0]["OrgName"] + " </td>";
                MailText += "<td style='border: 1px solid black'>" + UserName.Value + " </td>";
                MailText += "<td style='border: 1px solid black'>" + Request.UserHostAddress + " </td></tr>";
                MailText += "</table>";

                Gmail.SentMail_GMail(email, "NBTC : ผู้ใช้ถูกระงับการเข้าใช้งานระบบ", MailText);
            }
            //catch
            {

            }
             * */
        }

        void MailToUser()
        {
            //try
            {
                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
                SqlDataAdapter SqlCmd = new SqlDataAdapter("spUR_Info", SqlConn);
                SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

                SqlCmd.SelectCommand.Parameters.Add("@Login", SqlDbType.NVarChar, 40);
                SqlCmd.SelectCommand.Parameters["@Login"].Value = UserName.Value;


                DataSet DS = new DataSet();
                SqlCmd.Fill(DS);
                SqlConn.Close();

                if (DS.Tables[0].Rows[0]["Email"].ToString() == "")
                    return;

                string MailText = "ผู้เข้าใช้งานระบบ ใส่รหัสผ่านเกินที่กำหนด ";
                MailText += "<br /><br /><table style='border-collapse: collapse;border-style: hidden;' cellpadding=4><tr>";
                MailText += "<td style='border: 1px solid black'>ชื่อ-นามสกุล</td>";
                MailText += "<td style='border: 1px solid black'>อีเมล์ </td>";
                MailText += "<td style='border: 1px solid black'>เบอร์โทรศัพท์</td>";
                MailText += "<td style='border: 1px solid black'>ตำแหน่ง</td>";
                MailText += "<td style='border: 1px solid black'>หน่วยงาน</td>";
                MailText += "<td style='border: 1px solid black'>ชื่อล็อกอิน</td>";
                MailText += "<td style='border: 1px solid black'>IP-Address</td></tr>";

                MailText += "<tr><td style='border: 1px solid black'>" + DS.Tables[0].Rows[0]["Fname"] + " " + DS.Tables[0].Rows[0]["LName"] + "</td>";
                MailText += "<td style='border: 1px solid black'>" + DS.Tables[0].Rows[0]["Email"] + " </td>";
                MailText += "<td style='border: 1px solid black'>" + DS.Tables[0].Rows[0]["TelNo"] + " </td>";
                MailText += "<td style='border: 1px solid black'>" + DS.Tables[0].Rows[0]["Rank"] + "+ </td>";
                MailText += "<td style='border: 1px solid black'>" + DS.Tables[0].Rows[0]["OrgName"] + " </td>";
                MailText += "<td style='border: 1px solid black'>" + UserName.Value + " </td>";
                MailText += "<td style='border: 1px solid black'>" + Request.UserHostAddress + " </td></tr>";
                MailText += "</table>";

                Gmail.SentMail_GMail(DS.Tables[0].Rows[0]["Email"] + "", "NBTC : ผู้ใช้ถูกระงับการเข้าใช้งานระบบ", MailText);
            }
            //catch
            {

            }
        }
        private String GetUType()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spUR_Info", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Login", SqlDbType.NVarChar, 40);
            SqlCmd.SelectCommand.Parameters["@Login"].Value = UserName.Value;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            if (DS.Tables[0].Rows.Count == 0) return "";

            return DS.Tables[0].Rows[0]["UType"].ToString();
        }

        string initLDAPPath = "OU=R,OU=NBTCDepartments,OU=NBTC,DC=ntc,DC=domain";
        string initLDAPServer = "172.17.1.79";
        string initShortDomainName = "varonis";
        string strErrMsg;

        public string MD5(string strString)
        {
            ASCIIEncoding ASCIIenc = new ASCIIEncoding();
            string strReturn;
            byte[] ByteSourceText = ASCIIenc.GetBytes(strString);
            MD5CryptoServiceProvider Md5Hash = new MD5CryptoServiceProvider();
            byte[] ByteHash = Md5Hash.ComputeHash(ByteSourceText);
            strReturn = "";
            foreach (byte b in ByteHash)
            {
                strReturn = (strReturn + b.ToString("x2"));
            }
            return strReturn;
        }
        private bool doLogInWithLDAP()
        {
            string DomainAndUsername = "";
            string strCommu;
            bool flgLogin = false;
            strCommu = ("LDAP://"
                        + (initLDAPServer + ("/" + initLDAPPath)));
            DomainAndUsername = (initShortDomainName + ("\\" + UserName.Value));
            DirectoryEntry entry = new DirectoryEntry(strCommu, DomainAndUsername, Password.Value);
            object obj;
            try
            {
                obj = entry.NativeObject;
                DirectorySearcher search = new DirectorySearcher(entry);
                SearchResult result;
                search.Filter = ("(SAMAccountName="
                            + (UserName.Value + ")"));
                search.PropertiesToLoad.Add("cn");
                result = search.FindOne();
                if ((result == null))
                {
                    flgLogin = false;
                    strErrMsg = "Please check user/password";
                }
                else
                {
                    flgLogin = true;
                }
            }
            catch (Exception ex)
            {
                flgLogin = false;
                strErrMsg = "Please check user/password " + ex;
            }


            return flgLogin;
        }

        private static bool ValidateRemoteCertificate(object sender, X509Certificate certificate, X509Chain chain, System.Net.Security.SslPolicyErrors policyErrors)
        {
            return true;
        }
        private bool doLogInWithLDAPFw()
        {
            try
            {
                string lcUrl = ConfigurationManager.AppSettings["FwServiceURL"] + "/service/adfw.aspx";
                HttpWebRequest loHttp = (HttpWebRequest)System.Net.WebRequest.Create(lcUrl);
                ServicePointManager.ServerCertificateValidationCallback += new System.Net.Security.RemoteCertificateValidationCallback(ValidateRemoteCertificate);
               
                loHttp.KeepAlive = false;
                loHttp.ProtocolVersion = HttpVersion.Version10;
                string strPost = "";
                strPost += "u=" + Uri.EscapeDataString(UserName.Value);
                strPost += "&p=" + Uri.EscapeDataString(Password.Value);

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


                cUtils.Log("ad", " -> " + UserName.Value + " -> OK ");

                return lcHtml == "OK";
            }
            catch (Exception ex)
            {
                cUtils.Log("ad", " -> " + UserName.Value + " -> ERR " + ex.ToString());
            }

            return false;
        }
    }
}