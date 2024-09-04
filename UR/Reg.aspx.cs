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
    public partial class Reg : System.Web.UI.Page
    {
        public int UID;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                GetDiv();
            }
        }
        protected void bSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            cRc4 _rc4 = new cRc4();

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD30"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spUSR_Reg", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Login", SqlDbType.NVarChar, 30);
            SqlCmd.SelectCommand.Parameters["@Login"].Value = Login.Value;

            SqlCmd.SelectCommand.Parameters.Add("@Pwd", SqlDbType.NVarChar, 32);
            SqlCmd.SelectCommand.Parameters["@Pwd"].Value = _rc4.EnDeCrypt(Pwd.Value, Pwd.Value);

            SqlCmd.SelectCommand.Parameters.Add("@Email", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Email"].Value = this.Email.Value;
            string[] Names = FLName.Value.Split(' ');
            string FName = "";
            string LName = "";
            if (Names.Length == 2)
            {
                FName = Names[0];
                LName = Names[1];
            }
            else if (Names.Length > 2)
            {
                FName = Names[0];
                LName = FLName.Value.Substring(FName.Length).Trim();
            }
            else
            {
                FName = FLName.Value;
            }

            SqlCmd.SelectCommand.Parameters.Add("@FName", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@FName"].Value = FName;

            SqlCmd.SelectCommand.Parameters.Add("@LName", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@LName"].Value = LName;

            SqlCmd.SelectCommand.Parameters.Add("@TelNo", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@TelNo"].Value = TelNo.Value;

            SqlCmd.SelectCommand.Parameters.Add("@Rank", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Rank"].Value = Rank.Value;

            SqlCmd.SelectCommand.Parameters.Add("@OrgID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@OrgID"].Value = this.DivID.Value;

            SqlCmd.SelectCommand.Parameters.Add("@FgtQ", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@FgtQ"].Value = FgtQ.Value;

            SqlCmd.SelectCommand.Parameters.Add("@FgtA", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@FgtA"].Value = FgtA.Value;


            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 15);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = Request.UserHostAddress;


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            UID = Convert.ToInt32(DS.Tables[0].Rows[0]["UID"]);
            if (UID > 0)
            {
                string email = "";
                for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
                {
                    if (i > 0)
                        email += ",";
                    email += DS.Tables[0].Rows[i]["Email"].ToString();
                }

                MailToAdmin(email);
                Response.Redirect("Act.aspx");
            }
        }

        private void GetDiv()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spOrg_Get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

           
            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            DivID.Items.Add(new ListItem("== เลือกหน่วยงาน ==", "0"));
            for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
            {
                DivID.Items.Add(new ListItem(DS.Tables[0].Rows[i]["Name"].ToString(), DS.Tables[0].Rows[i]["orgID"].ToString()));
            }
        }

        void MailToAdmin(string email)
        {
            try
            {
                string MailText = "ผู้สมัครเข้าใช้งานระบบ EBMSApp โดยมีรายละเอียดดังนี้";
                MailText += "<br /><br /><table style='border-collapse: collapse;border-style: hidden;' cellpadding=4><tr>";
                MailText += "<td style='border: 1px solid black'>ชื่อ-นามสกุล</td>";
                MailText += "<td style='border: 1px solid black'>อีเมล์</td>";
                MailText += "<td style='border: 1px solid black'>เบอร์โทรศัพท์</td>";
                MailText += "<td style='border: 1px solid black'>ตำแหน่ง</td>";
                MailText += "<td style='border: 1px solid black'>หน่วยงาน</td>";
                MailText += "<td style='border: 1px solid black'>ชื่อล็อกอิน</td></tr>";

                MailText += "<tr><td style='border: 1px solid black'>"+FLName.Value+"</td>";
                MailText += "<td style='border: 1px solid black'>" + Email.Value+" </td>";
                MailText += "<td style='border: 1px solid black'>" + TelNo.Value+" </td>";
                MailText += "<td style='border: 1px solid black'>"+Rank.Value+"+ </td>";
                MailText += "<td style='border: 1px solid black'>" + DivID.Items[DivID.SelectedIndex].Text.Trim()+" </td>";
                MailText += "<td style='border: 1px solid black'>" + Login.Value+" </td></tr>";
                MailText += "</table>";

                Gmail.SentMail_GMail(email, "EBMSApp : รายงานการสมัครเข้าใช้งานระบบ", MailText);
            }
            catch
            {

            }
        }
    }
}