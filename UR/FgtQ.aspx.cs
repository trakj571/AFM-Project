using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace EBMSMap30.UR
{
    public partial class FgtQ : System.Web.UI.Page
    {
        public int UID = 0;
        public string dtFgt;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                CheckLogin();
            }
        }

        private void CheckLogin()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD30"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spUSR_FgtQ", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Login", SqlDbType.NVarChar, 30);
            SqlCmd.SelectCommand.Parameters["@Login"].Value = Request.QueryString["login"];

           
            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            UID = Convert.ToInt32(DS.Tables[0].Rows[0]["UID"]);
            if (UID > 0)
            {
                UID = 0;
                lbLogin.Text = DS.Tables[0].Rows[0]["Login"].ToString();
                lbFgtQ.Text = DS.Tables[0].Rows[0]["FgtQ"].ToString();
            }
        }

        protected void bSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            cRc4 _rc4 = new cRc4();

            string pwd = Comm.RandPwd(6);

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD30"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spUSR_FgtPwd", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Login", SqlDbType.NVarChar, 30);
            SqlCmd.SelectCommand.Parameters["@Login"].Value = Request.QueryString["login"];

            SqlCmd.SelectCommand.Parameters.Add("@FgtA", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@FgtA"].Value = FgtA.Value;

            SqlCmd.SelectCommand.Parameters.Add("@Pwd", SqlDbType.NVarChar, 32);
            SqlCmd.SelectCommand.Parameters["@Pwd"].Value = _rc4.EnDeCrypt(pwd, pwd);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            UID = Convert.ToInt32(DS.Tables[0].Rows[0]["UID"]);
            if (UID > 0 || UID == -2)
            {
                if (UID > 0)
                    MailPwd(DS.Tables[0].Rows[0]["email"].ToString(), pwd, DS.Tables[0].Rows[0]["name"].ToString());

                DateTime dt = (DateTime)DS.Tables[0].Rows[0]["dtFgt"];
                if (dt.Year == DateTime.Now.Year && dt.Month == DateTime.Now.Month && dt.Day == DateTime.Now.Day)
                {
                    this.dtFgt = string.Format(" เมื่อเวลา{0:HH.mm น.} ", DS.Tables[0].Rows[0]["dtFgt"]);
                }
                else
                {
                    this.dtFgt = string.Format(" เมื่อวันที่ {0:dd MMM yy เวลา HH.mm น.} ", DS.Tables[0].Rows[0]["dtFgt"]);
                }
            }

         
        }

        void MailPwd(string email,string pwd,string name)
        {
            try
            {
                string MailText = "เรียน คุณ " + name;
                MailText += "<br /><br />EBMSApp ได้ทำการตั้งรหัสผ่านใหม่ของคุณ คือ " + pwd;
                MailText += "<br />กรุณาล็อกอินเข้าระบบด้วยรหัสดังกล่าวอีกครั้ง";
                //MailText += "<br /><br /><a href='" + ConfigurationManager.AppSettings["LinkURL"] + "'>"+ConfigurationManager.AppSettings["LinkURL"]+"</a>";
                MailText += "<br /><br />ผู้ดูแลระบบ";
                Gmail.SentMail_GMail(email, "EBMSApp : ลืมรหัสผ่าน‏", MailText);
            }
            catch
            {

            }
        }
    }
}