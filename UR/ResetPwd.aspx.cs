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
    public partial class ResetPwd : System.Web.UI.Page
    {
        public int retCode = 0;
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void bConfirm_ServerClick(object sender, System.EventArgs e)
        {
            if (!Page.IsValid) return;

            cRc4 _rc4 = new cRc4();

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD30"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spResetPwd", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Pwd", SqlDbType.NVarChar, 15);
            SqlCmd.SelectCommand.Parameters["@Pwd"].Value = _rc4.EnDeCrypt(Pwd.Value, Pwd.Value);

            SqlCmd.SelectCommand.Parameters.Add("@OTP", SqlDbType.NVarChar, 40);
            SqlCmd.SelectCommand.Parameters["@OTP"].Value = Request.QueryString["c"];


            SqlCmd.SelectCommand.Parameters.Add("@Type", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Type"].Value = "E";

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            retCode = Convert.ToInt32(DS.Tables[0].Rows[0]["retCode"]);
        }
        
    }
}