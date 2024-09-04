using EBMSMap30;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AFMProj.FMS
{
    public partial class mFDBStn : System.Web.UI.Page
    {
        public int retID;
        public string PATCode = "000000";
        List<MInput> mInputs = new List<MInput>();
        protected void Page_Load(object sender, EventArgs e)
        {
            mInputs.Add(new MInput() { HtmlInput = StName, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = PWUnit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = PW, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = H, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = AdrNo, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = CoorType, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Lat, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = Lng, DBType = MInput.DataType.Double });
            if (!IsPostBack)
            {
                if (cConvert.ToInt(Request["StnID"]) > 0)
                {
                    DataSet DS = MDataDC.GetData("[fms].[spFDBStnGet]", "StnID", Request.QueryString["StnID"], mInputs);
                    PATCode = DS.Tables[0].Rows[0]["PatCode"].ToString();
                    if (PATCode.Length < 6)
                        PATCode = PATCode.PadRight(6).Replace(" ", "0");
                }
                else
                {
                    //Lat.Value = "13.75";
                    //Lng.Value = "100.5";
                }
            }


        }
        protected void bSave_ServerClick(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["NBTCDC"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[fms].[spFDBStnAdd]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@StnID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@StnID"].Value = cConvert.ToInt(Request["StnID"]);

            SqlCmd.SelectCommand.Parameters.Add("@FuID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@FuID"].Value = cConvert.ToInt(Request["FuID"]);

            SqlCmd.SelectCommand.Parameters.Add("@TmpKey", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@TmpKey"].Value = Request["TmpKey"];


            SqlCmd.SelectCommand.Parameters.Add("@PatCode", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@PatCode"].Value = GetPatCode("1");


            MDataDC.AddSqlCmd(SqlCmd, mInputs);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            retID = Convert.ToInt32(DS.Tables[0].Rows[0]["retID"]);


        }
        private string GetPatCode(string idx)
        {
            string PATCode = "0";
            if (Request.Form["sTumbon2"] != "0")
                PATCode = Request.Form["sTumbon2"];
            else if (Request.Form["sAumphur2"] != "0")
                PATCode = Request.Form["sAumphur2"];
            else if (Request.Form["sProv2"] != "0")
                PATCode = Request.Form["sProv2"];

            return PATCode;
        }
    }
}