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
    public partial class HAdd : System.Web.UI.Page
    {
        public string PATCode = "000000";
        public int retID = 0;
        List<MInput> mInputs = new List<MInput>();

        protected void Page_Load(object sender, EventArgs e)
        {
            mInputs.Add(new MInput() { HtmlInput = Name, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = TelNo, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = AdrNo, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Road, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = PostCode, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = TaxID, DBType = MInput.DataType.String });
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["hid"] != null)
                {
                    DataSet DS = MData.GetData("fms.spHostGet", "hid", Request.QueryString["hid"], mInputs);
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
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spHostAdd", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@hid", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@hid"].Value = Request.QueryString["hid"];

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