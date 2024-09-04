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

namespace AFMProj.ISOForm
{
    public partial class F04 : System.Web.UI.Page
    {
        public DataTable tbD;
        public string[] ColsData = new string[0];
        protected void Page_Load(object sender, EventArgs e)
        {
            int TypeID = cConvert.ToInt(Request["typeid"]);
            if (TypeID == 1)
                ColsData = AFMProj.DMS.VFCols.TypeID1;
            if (TypeID == 2)
                ColsData = AFMProj.DMS.VFCols.TypeID2;
            if (TypeID == 3)
                ColsData = AFMProj.DMS.VFCols.TypeID3;
            if (TypeID == 4)
                ColsData = AFMProj.DMS.VFCols.TypeID4;

            GetData();
        }

        private void GetData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spVF_Get", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@s_ID", SqlDbType.VarChar, 20);
            SqlCmd.SelectCommand.Parameters["@s_ID"].Value = Request["S_ID"];

            SqlCmd.SelectCommand.Parameters.Add("@TypeID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@TypeID"].Value = cConvert.ToInt(Request["TypeID"]);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbD = DS.Tables[0];


            OFFICE_NAME.InnerText = tbD.Rows[0]["OFFICE_NAME"].ToString();
            if (tbD.Rows[0]["ST_TYPE_ID"].ToString() == "01")
                S_TYPE1.Checked = true;
            if (tbD.Rows[0]["ST_TYPE_ID"].ToString() == "02")
                S_TYPE2.Checked = true;

            S_NAME.InnerText = tbD.Rows[0]["S_NAME"].ToString();

            LICENSENO.InnerText = tbD.Rows[0]["LICENSENO"].ToString();
            LICENSEISSUE.InnerText = string.Format("{0:dd/MM/yyyy}", tbD.Rows[0]["LICENSEISSUE"]);
            
            INSP_DATEF.InnerText = string.Format("{0:dd/MM/yyyy}", tbD.Rows[0]["INSP_DATEF"]);
            REPORT_DATEF.InnerText = string.Format("{0:dd/MM/yyyy}", tbD.Rows[0]["REPORT_DATEF"]);

            RESULT_DESC.InnerText = tbD.Rows[0]["RESULT_DESC"].ToString();
            COMMENT_DESC.InnerText = tbD.Rows[0]["COMMENT_DESC"].ToString();

            INSP_NAME1.InnerText = tbD.Rows[0]["INSP_NAME1"].ToString();

            INSP_POSITION1.InnerText = tbD.Rows[0]["INSP_POSITION1"].ToString();
            INSP_NAME2.InnerText = tbD.Rows[0]["INSP_NAME2"].ToString();
            INSP_POSITION2.InnerText = tbD.Rows[0]["INSP_POSITION2"].ToString();
            DIRECTOR.InnerText = tbD.Rows[0]["DIRECTOR"].ToString();

            Lat.Value = tbD.Rows[0]["CURRENT_LAT"].ToString();
            Lng.Value = tbD.Rows[0]["CURRENT_LONG"].ToString();
        }
    }
}