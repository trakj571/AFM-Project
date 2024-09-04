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

namespace AFMProj.DashB
{
    public partial class Download : System.Web.UI.Page
    {
        public DataTable tbB;
        protected void Page_Load(object sender, EventArgs e)
        {
            GetDoc();
        }

        private void GetDoc()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spDLd_Get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@SysGrp", SqlDbType.VarChar,5);
            SqlCmd.SelectCommand.Parameters["@SysGrp"].Value = "AFM";

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            tbB = DS.Tables[0];

        }

    }
}