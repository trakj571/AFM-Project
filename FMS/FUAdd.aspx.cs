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
using System.Web.UI.HtmlControls;

namespace AFMProj.FMS
{
    public partial class FUAdd : System.Web.UI.Page
    {
        public int retID = 0;
        List<MInput> mInputs = new List<MInput>();
        List<MInput> mInputu = new List<MInput>();
        public string Grp = "1";
        protected void Page_Load(object sender, EventArgs e)
        {
            mInputs.Add(new MInput() { HtmlInput = FBand, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = FBand2, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = FMHz, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = FMHz2, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = BandWidth, DBType = MInput.DataType.Double });

            mInputu.Add(new MInput() { HtmlInput = HID, DBType = MInput.DataType.Int });
            mInputu.Add(new MInput() { HtmlInput = HID2, DBType = MInput.DataType.Int });
            mInputu.Add(new MInput() { HtmlInput = Fee, DBType = MInput.DataType.Double, Format = "0.00" });
            mInputu.Add(new MInput() { HtmlInput = Fon, DBType = MInput.DataType.String });
            mInputu.Add(new MInput() { HtmlInput = LicNo, DBType = MInput.DataType.String });
            mInputu.Add(new MInput() { HtmlInput = DtIssu, DBType = MInput.DataType.DateTime });
            mInputu.Add(new MInput() { HtmlInput = DtExp, DBType = MInput.DataType.DateTime });
            mInputu.Add(new MInput() { HtmlInput = DtNF, DBType = MInput.DataType.DateTime });
            mInputu.Add(new MInput() { HtmlInput = DtRep, DBType = MInput.DataType.DateTime });
            mInputu.Add(new MInput() { HtmlInput = Yr, DBType = MInput.DataType.String });
            mInputu.Add(new MInput() { HtmlInput = Status, DBType = MInput.DataType.String });

            mInputu.Add(new MInput() { HtmlInput = ActivityID, DBType = MInput.DataType.Int });
            mInputu.Add(new MInput() { HtmlInput = UsesID, DBType = MInput.DataType.Int });


            MDataDC.GetUItems(ActivityID, "fms.tbFAct");
            MDataDC.GetUItems(UsesID, "fms.tbFUses");
            GetH2(HID2, "fms.spFDBUseH2", "HID", "Name");

            if (!Page.IsPostBack)
            {

                if (cConvert.ToInt(Request.QueryString["fdid"]) > 0)
                {
                    DataSet DS = MDataDC.GetData("fms.spFDBGet", "fdid", Request.QueryString["fdid"], mInputs);
                }
                if (cConvert.ToInt(Request.QueryString["fuid"]) > 0)
                {
                    DataSet DS = MDataDC.GetData("fms.spFDBUseGet", "fuid", Request.QueryString["fuid"], mInputu);
                  Grp = DS.Tables[0].Rows[0]["Grp"].ToString();
                    if (DS.Tables[0].Rows[0]["Yr"].ToString() != "5 ปี" && DS.Tables[0].Rows[0]["Yr"].ToString() != "6 เดือน")
                    {
                        Yr.Items.Add(new ListItem(DS.Tables[0].Rows[0]["Yr"].ToString(), DS.Tables[0].Rows[0]["Yr"].ToString()));
                    }
                    Yr.Value = DS.Tables[0].Rows[0]["Yr"].ToString();
                    
                }
            }
        }
        public void GetH2(HtmlSelect select, string spName, string id, string Col)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["NBTCDC"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter(spName, SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@FDID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@FDID"].Value = Request.QueryString["fdid"];

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            select.Items.Clear();
            select.Items.Add(new ListItem("กรุณาเลือก", "0"));

            DataTable tb = DS.Tables[0];

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                string[] ids = id.Split(',');
                string val = "";
                for (int j = 0; j < ids.Length; j++)
                {
                    if (j > 0) val += ",";
                    val += tb.Rows[i][ids[j]];
                }

                select.Items.Add(new ListItem(tb.Rows[i][Col].ToString(), val));
            }
        }

    }
}