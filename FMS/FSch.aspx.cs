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


namespace AFMProj.FMS
{
    public partial class FSch : System.Web.UI.Page
    {
        public DataTable tbH, tbD;
        List<MInput> mInputs = new List<MInput>();
        
        protected void Page_Load(object sender, EventArgs e)
        {
            MDataDC.GetUItems(ActivityID, "fms.tbFAct");
            MDataDC.GetUItems(UsesID, "fms.tbFUses");

            mInputs.Add(new MInput() { HtmlInput = FBand, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = FMHz, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = FMHz2, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = BandWidth, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = Host, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Name, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Detail, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = ActivityID, DBType = MInput.DataType.Int });
            mInputs.Add(new MInput() { HtmlInput = UsesID, DBType = MInput.DataType.Int });
            mInputs.Add(new MInput() { HtmlInput = Status, DBType = MInput.DataType.String });

            MDataDC.SetQSValue(mInputs);

            if (Request.ServerVariables["query_string"].ToString() != "")
            {

                SchData();

            }
        }

        private void SchData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["NBTCDC"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spFDBGet", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;


            MDataDC.AddSqlCmd(SqlCmd, mInputs);

            if (Request["export"] != null)
            {
                SqlCmd.SelectCommand.Parameters.Add("@nPage", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@nPage"].Value = 30000;
            }
            else
            {
                SqlCmd.SelectCommand.Parameters.Add("@Page", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@Page"].Value = Request["Page"];
            }

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbH = DS.Tables[0];
            tbD = DS.Tables[1];

            if (Request["export"] != null)
            {
                List<string> columns = new List<string>();
                columns.Add("FBand:ย่านความถี่");
                columns.Add("FMHz:คลื่นความถี่ (MHz)");
                columns.Add("BandWidth:Bandwidth (KHz)");
                columns.Add("Name1:ผู้ใช้คลื่นความถี่");
                columns.Add("Name2:ผู้ให้ใช้คลื่นความถี่");
                columns.Add("Activity:กิจการ");
                columns.Add("Uses:การนำไปใช้งาน");
                columns.Add("Status:สถานะปัจจุบัน");
                columns.Add("DtIssu:วันที่อนุมัติ:dd/MM/yyyy");
                Export.ToFile(tbD, columns, "", "");
            }
        }
    }
}