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
    public partial class ChgPwd : System.Web.UI.Page
    {
        public int UID = 0;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (cUsr.UID == 0)
            {
                Response.End();
            }
        }

        protected void bSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            cRc4 _rc4_o = new cRc4();
            cRc4 _rc4 = new cRc4();

           
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD30"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spUR_ChgPwd", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@Pwd", SqlDbType.NVarChar, 32);
            SqlCmd.SelectCommand.Parameters["@Pwd"].Value = _rc4_o.EnDeCrypt(OPwd.Value, OPwd.Value);

            SqlCmd.SelectCommand.Parameters.Add("@NPwd", SqlDbType.NVarChar, 32);
            SqlCmd.SelectCommand.Parameters["@NPwd"].Value = _rc4.EnDeCrypt(Pwd.Value, Pwd.Value);


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            UID = Convert.ToInt32(DS.Tables[0].Rows[0]["UID"]);
        }
    }
}