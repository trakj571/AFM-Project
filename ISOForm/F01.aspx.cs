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
    public partial class F01 : System.Web.UI.Page
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

            int TypeID = cConvert.ToInt(Request["TypeID"]);

            if (TypeID == 1) TypeID1.Checked = true;
            if (TypeID == 2) TypeID2.Checked = true;
            //if (TypeID == 3) TypeID3.Checked = true;

            OFFICE_NAME.InnerText = tbD.Rows[0]["OFFICE_NAME"].ToString();
            ST_TYPE_ID.InnerText = tbD.Rows[0]["ST_TYPE_ID"].ToString();
            S_NAME.InnerText = tbD.Rows[0]["S_NAME"].ToString();
            if(TypeID==2)
                FREQUENCY.InnerText = tbD.Rows[0]["FREQ_ASSIGN"].ToString();
            else
                 FREQUENCY.InnerText = tbD.Rows[0]["FREQUENCY"].ToString();

            if (TypeID == 1 || TypeID == 2)
            {
                COORDINATOR_NAME.InnerText = tbD.Rows[0]["COORDINATOR_NAME"].ToString();
                COORDINATOR_TEL.InnerText = tbD.Rows[0]["COORDINATOR_TEL"].ToString();
                EMISSION.InnerText = tbD.Rows[0]["EMISSION"].ToString();
            }

            if (tbD.Rows[0]["LICENSENO"].ToString() != "")
            {
                if (TypeID == 1 || TypeID == 2)
                {
                    LICENSENO1.InnerText = tbD.Rows[0]["LICENSENO"].ToString();
                    Status1.Checked = true;
                }
                if (TypeID == 3)
                {
                    Status2.Checked = true;
                    LICENSENO2.InnerText = tbD.Rows[0]["LICENSENO"].ToString();
                }
            }
            //LICENSENO3.InnerText = tbD.Rows[0]["LICENSENO"].ToString();

            ADDRESS.InnerText = tbD.Rows[0]["ADDRESS"].ToString();
            LATITUDE.InnerText = tbD.Rows[0]["LATITUDE"].ToString();
            LONGITUDE.InnerText = tbD.Rows[0]["LONGITUDE"].ToString();


            FREQ_MEAS.InnerText = tbD.Rows[0]["FREQ_MEAS"].ToString();
            AERIALTYPE_ID.InnerText = tbD.Rows[0]["AERIALTYPE_ID"].ToString();
            AERIALLINE_TYPE.InnerText = tbD.Rows[0]["AERIALLINE_TYPE"].ToString();
            FREQ_GAIN.InnerText = tbD.Rows[0]["FREQ_GAIN"].ToString();
            AERIALLINE_HEIGHT.InnerText = tbD.Rows[0]["AERIALLINE_HEIGHT"].ToString();
            INSP_COMMENT.InnerText = tbD.Rows[0]["INSP_COMMENT"].ToString();
            INSP_MACHINE.InnerText = tbD.Rows[0]["INSP_MACHINE"].ToString();
            INSP_DATEF.InnerText = string.Format("{0:dd/MM/yyyy}",tbD.Rows[0]["INSP_DATEF"]);
            REPORT_DATEF.InnerText = string.Format("{0:dd/MM/yyyy}",tbD.Rows[0]["REPORT_DATEF"]);
            INSP_NAME1.InnerText = tbD.Rows[0]["INSP_NAME1"].ToString();
            INSP_POSITION1.InnerText = tbD.Rows[0]["INSP_POSITION1"].ToString();
            INSP_NAME2.InnerText = tbD.Rows[0]["INSP_NAME2"].ToString();
            INSP_POSITION2.InnerText = tbD.Rows[0]["INSP_POSITION2"].ToString();
            INSP_NAME3.InnerText = tbD.Rows[0]["INSP_NAME3"].ToString();
            INSP_POSITION3.InnerText = tbD.Rows[0]["INSP_POSITION3"].ToString();
            INSP_NAME4.InnerText = tbD.Rows[0]["INSP_NAME4"].ToString();
            INSP_POSITION4.InnerText = tbD.Rows[0]["INSP_POSITION4"].ToString();


            DIRECTOR.InnerText = tbD.Rows[0]["DIRECTOR"].ToString();
            APPROVE_POSITION.InnerText = tbD.Rows[0]["APPROVE_POSITION"].ToString();
        }
    }
}