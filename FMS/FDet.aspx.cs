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
    public partial class FDet : System.Web.UI.Page
    {
        public string PATCode = "000000";
        public DataTable tbD;
        public int retID = 0;
        List<MInput> mInputs = new List<MInput>();
        protected void Page_Load(object sender, EventArgs e)
        {
            mInputs.Add(new MInput() { HtmlInput = FBand, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = FBand2, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = FMHz, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = FMHz2, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = BandWidth, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = HID, DBType = MInput.DataType.Int });
            mInputs.Add(new MInput() { HtmlInput = IsRange, DBType = MInput.DataType.Check });
            mInputs.Add(new MInput() { HtmlInput = ChSp, DBType = MInput.DataType.Double });




            if (Request.QueryString["fdid"] != null)
            {
                DataSet DS = MDataDC.GetData("fms.spFDBGet", "fdid", Request.QueryString["fdid"], mInputs);
                if (!IsRange.Checked)
                    divChSp.Visible = false;
                GetFUse();

                if (Request["export"] != null)
                {
                    List<string> columns = new List<string>();
                    columns.Add("FBand:ความถี่ย่าน");
                    columns.Add("FBand2:ย่านความถี่");
                    columns.Add("FMHz:คลื่นความถี่ (MHz)");
                    columns.Add("FMHz2:คู่คลื่นความถี่ (MHz)");
                    columns.Add("BandWidth:Brandwidth (kHz)");

                  
                   
                    Export.ToFile(DS.Tables[0], columns, "", "");
                }
            }
        }

        private void GetFUse()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["NBTCDC"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spFDBUseGet", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@fdid", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@fdid"].Value = Request.QueryString["fdid"];

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbD = DS.Tables[0];
        }
    }
}