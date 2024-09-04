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

namespace EBMSMap.Web.Admin
{
    public partial class UGrpAdd : System.Web.UI.Page
    {
        public int retID;
        public DataTable tbU;
        List<MInput> mInputs = new List<MInput>();
        protected void Page_Load(object sender, EventArgs e)
        {
            cUsr.CheckAuth("A");
            mInputs.Add(new MInput() { HtmlInput = Name, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Detail, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsDataMng, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsRVI, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsRMB, DBType = MInput.DataType.String });

            mInputs.Add(new MInput() { HtmlInput = IsVSS, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsGPS, DBType = MInput.DataType.String });

            mInputs.Add(new MInput() { HtmlInput = IsCopEquipment, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsCopViewOnly, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsCopEdit, DBType = MInput.DataType.String });

            mInputs.Add(new MInput() { HtmlInput = IsFmsFMon, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsFmsViewOnly, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsFmsEdit, DBType = MInput.DataType.String });

            mInputs.Add(new MInput() { HtmlInput = IsFmrControl, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsFmrLive, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsFmrPlayBack, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsFmrMapViewOnly, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsFmrMapEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsCopInfo, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsDmsImp, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsDmsViewOnly, DBType = MInput.DataType.String });

            mInputs.Add(new MInput() { HtmlInput = IsISO05SvyView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO05SvyEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO05CompView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO05CompEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO09PlanView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO09PlanEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO09ChkView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO09ChkEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO26ChkView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO26ChkEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO10FreqView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO10FreqEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO11ChkView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO11ChkEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO12ChkView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO12ChkEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO13ChkView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO13ChkEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO14RaidView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO14RaidEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO14CaseView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO14CaseEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO15RecView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO15RecEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO15ChkView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO15ChkEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO16ShopView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO16ShopEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO16PlanView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO16PlanEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO16ChkView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO16ChkEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO17StnView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO17StnEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO17RadView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO17RadEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO18RepView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO18RepEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO28ChkView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO28ChkEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO29ChkView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISO29ChkEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISOPPEquipView, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsISOPPEquipEdit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsCCTVMode, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsCCTVMatch, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsCCTVSource, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsCCTVRep, DBType = MInput.DataType.String });

            if (!Page.IsPostBack)
            {
                if (Request.QueryString["UgID"] != null)
                {
                    DataSet DS = MData.GetDataAdm("spUR_GetUGrp", "UgID", Request.QueryString["UgID"], mInputs);
                    tbU = DS.Tables[1];
                }
            }
        }


        protected void bSave_ServerClick(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spUR_AddUGrp", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@UGID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UGID"].Value = Request.QueryString["UGID"];

            MData.AddSqlCmd(SqlCmd, mInputs);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            retID = Convert.ToInt32(DS.Tables[0].Rows[0]["retID"]);
        }

    }
}