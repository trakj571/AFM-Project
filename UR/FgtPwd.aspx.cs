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
    public partial class FgtPwd : System.Web.UI.Page
    {
        public int retCode = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request["u"] != null)
            {
                EmailOTP(Request["u"]);
            }
        }

        protected void bConfirm_ServerClick(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            EmailOTP(UserName.Value);
        }

        private void EmailOTP(string Uname)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD30"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spFgtPwd", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Login", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Login"].Value = Uname;

            SqlCmd.SelectCommand.Parameters.Add("@Type", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Type"].Value = "E";

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            retCode = Convert.ToInt32(DS.Tables[0].Rows[0]["retCode"]);
            DataTable tbD = DS.Tables[0];

            if (retCode == 1)
            {
                string email = tbD.Rows[0]["Email"].ToString();
                string actURL = ConfigurationManager.AppSettings["LinkURL"] + "/UR/ResetPwd.aspx?c=" + tbD.Rows[0]["OTP"];


                string mailtext = "คุณได้ทำการขอเปลี่ยนรหัสผ่านของคุณ <br /><br />" +


                  "คุณจะต้องคลิกลิงค์ด้านล่างนี้ เพื่อเข้าไปเปลี่ยนรหัสผ่านใหม่<br />" +
                  "Activate URL: <a href='" + actURL + "'>" + actURL + "</a><br />" +
                  "(ในกรณีที่ไม่สามารถคลิกลิงค์ได้ ให้คัดลอกลิงค์ ไปเปิดที่หน้าบราวเซอร์)<br /><br />" +

                  "ถ้าคุณไม่ได้เป็นผู้ขอรหัสผ่านใหม่ คุณไม่จำเป็นต้องคลิกลิงก์ใดๆ ใน E-mail นี้ กรณีนี้อาจเกิดขึ้นจากผู้ใช้ท่านอื่น กรอกข้อมูลผิดเป็น Username ของคุณ";

                EBMSMap30.Gmail.SentMail_GMail(email, "AFM : ลืมรหัสผ่าน‏", mailtext);

            }
        }
        
    }
}