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
    public partial class FAdd : System.Web.UI.Page
    {
        public string PATCode = "000000";
        public int retID = 0;
        List<MInput> mInputs = new List<MInput>();
        protected void Page_Load(object sender, EventArgs e)
        {
            mInputs.Add(new MInput() { HtmlInput = FBand, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = FBand2, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = FMHz, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = FMHz2, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = BandWidth, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = HID, DBType = MInput.DataType.Int });

            mInputs.Add(new MInput() { HtmlInput = Fee, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = Fon, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = LicNo, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = DtIssu, DBType = MInput.DataType.DateTime });
            mInputs.Add(new MInput() { HtmlInput = DtExp, DBType = MInput.DataType.DateTime });
            mInputs.Add(new MInput() { HtmlInput = DtNF, DBType = MInput.DataType.DateTime });
            mInputs.Add(new MInput() { HtmlInput = DtRep, DBType = MInput.DataType.DateTime });
            mInputs.Add(new MInput() { HtmlInput = Yr, DBType = MInput.DataType.String });
            

            mInputs.Add(new MInput() { HtmlInput = ActivityID, DBType = MInput.DataType.Int });
            mInputs.Add(new MInput() { HtmlInput = UsesID, DBType = MInput.DataType.Int });
            mInputs.Add(new MInput() { HtmlInput = PW, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = H, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = HID2, DBType = MInput.DataType.Int });
            mInputs.Add(new MInput() { HtmlInput = StName, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = CoName, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = AdrNo, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Road, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Location, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Lat, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = Lng, DBType = MInput.DataType.Double });

            if (!Page.IsPostBack)
            {
                MData.GetUItems(ActivityID, "tbFAct");
                MData.GetUItems(UsesID, "tbFUses");
                if (Request.QueryString["fdid"] != null)
                {
                    DataSet DS = MData.GetData("fms.spFDBGet", "fdid", Request.QueryString["fdid"], mInputs);
                    PATCode = DS.Tables[0].Rows[0]["PatCode"].ToString();
                    if (PATCode.Length < 6)
                        PATCode = PATCode.PadRight(6).Replace(" ", "0");
                }
            }
        }

        protected void bSave_ServerClick(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spFDBAdd", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@fdid", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@fdid"].Value = Request.QueryString["fdid"];

            string PATCode = "0";
            if (Request.Form["sTumbon2"] != "0")
                PATCode = Request.Form["sTumbon2"];
            else if (Request.Form["sAumphur2"] != "0")
                PATCode = Request.Form["sAumphur2"];
            else if (Request.Form["sProv2"] != "0")
                PATCode = Request.Form["sProv2"];

            SqlCmd.SelectCommand.Parameters.Add("@PATCode", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@PATCode"].Value = PATCode;

            MData.AddSqlCmd(SqlCmd, mInputs);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            retID = Convert.ToInt32(DS.Tables[0].Rows[0]["retID"]);
        }
    }
}