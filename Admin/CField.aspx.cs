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
    public partial class CField : System.Web.UI.Page
    {
        public int retID;
        List<MInput> mInputs = new List<MInput>();
        public bool IsOK;
        protected void Page_Load(object sender, EventArgs e)
        {
            cUsr.CheckAuth("A");
            mInputs.Add(new MInput() { HtmlInput = DataName, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Label, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = DataType, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = InputType, DBType = MInput.DataType.String });
            //mInputs.Add(new MInput() { HtmlInput = Options, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Unit, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Maxlength, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = DpColId, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsHeader, DBType = MInput.DataType.Check });
            mInputs.Add(new MInput() { HtmlInput = IsRequire, DBType = MInput.DataType.Check });
            mInputs.Add(new MInput() { HtmlInput = IsSearch, DBType = MInput.DataType.Check });
            mInputs.Add(new MInput() { HtmlInput = IsHide, DBType = MInput.DataType.Check });

            
          
            if (!Page.IsPostBack)
            {
                if (cConvert.ToInt(Request.QueryString["ColID"]) > 0)
                {
                    DataSet DS = MData.GetDataAdm("spCon_GetCols", "ColID", Request.QueryString["ColID"], mInputs);
                    if (Maxlength.Value == "0") Maxlength.Value = "";

                    GetType();
                    this.InputTypeH.Value = this.InputType.Value;
                    if (this.InputTypeH.Value == "S")
                    {
                        string topt = "";
                        this.Options.Disabled = false;
                        for (int i = 0; i < DS.Tables[1].Rows.Count; i++)
                        {
                            if (i > 0)
                                topt += "\r\n";
                            topt += DS.Tables[1].Rows[i]["Value"].ToString()+"|"+DS.Tables[1].Rows[i]["Text"].ToString();
                        }
                        this.Options.InnerHtml = topt;
                    }
                }
                
            }
        }


        private void GetType()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spCon_GetType]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@TypeID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@TypeID"].Value = Request.QueryString["typeid"];

            //SqlCmd.SelectCommand.Parameters.Add("@FormID", SqlDbType.Int);
            //SqlCmd.SelectCommand.Parameters["@FormID"].Value = Request.QueryString["formid"];

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            DpColId.Items.Clear();
            DataTable tbC = DS.Tables[1];
            DpColId.Items.Add(new ListItem("-- not set--", "0"));
            for (int i = 0; i < tbC.Rows.Count; i++)
            {
                if (tbC.Rows[i]["DataType"].ToString() == "C")
                    DpColId.Items.Add(new ListItem(tbC.Rows[i]["DataName"].ToString(), tbC.Rows[i]["ColID"].ToString()));
            }
        }

        protected void bSave_ServerClick(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spCon_AddCols", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@ColID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ColID"].Value = Request.QueryString["colid"];

            SqlCmd.SelectCommand.Parameters.Add("@typeid", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@typeid"].Value = Request.QueryString["typeid"];


            SqlCmd.SelectCommand.Parameters.Add("@DataName", SqlDbType.NVarChar, 20);
            SqlCmd.SelectCommand.Parameters["@DataName"].Value = DataName.Value;

            SqlCmd.SelectCommand.Parameters.Add("@Label", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Label"].Value = Label.Value;

            SqlCmd.SelectCommand.Parameters.Add("@DataType", SqlDbType.VarChar, 2);
            SqlCmd.SelectCommand.Parameters["@DataType"].Value = DataType.Value;

            SqlCmd.SelectCommand.Parameters.Add("@InputType", SqlDbType.VarChar, 2);
            SqlCmd.SelectCommand.Parameters["@InputType"].Value = InputType.Value;

            SqlCmd.SelectCommand.Parameters.Add("@Unit", SqlDbType.NVarChar, 20);
            SqlCmd.SelectCommand.Parameters["@Unit"].Value = Unit.Value;

            SqlCmd.SelectCommand.Parameters.Add("@DpColID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@DpColID"].Value = DpColId.Value;

            SqlCmd.SelectCommand.Parameters.Add("@FormID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@FormID"].Value = Request.QueryString["formid"];


            int maxlength = 0;
            if (InputType.Value == "T")
            {
                if (Maxlength.Value == "")
                    maxlength = 30;
                else
                    maxlength = Convert.ToInt16(Maxlength.Value);
            }



            SqlCmd.SelectCommand.Parameters.Add("@MaxLength", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@MaxLength"].Value = maxlength;

            SqlCmd.SelectCommand.Parameters.Add("@IsHeader", SqlDbType.Char, 1);
            SqlCmd.SelectCommand.Parameters["@IsHeader"].Value = this.IsHeader.Checked ? "Y" : "N";

            SqlCmd.SelectCommand.Parameters.Add("@IsRequire", SqlDbType.Char, 1);
            SqlCmd.SelectCommand.Parameters["@IsRequire"].Value = this.IsRequire.Checked ? "Y" : "N";

            SqlCmd.SelectCommand.Parameters.Add("@IsSearch", SqlDbType.Char, 1);
            SqlCmd.SelectCommand.Parameters["@IsSearch"].Value = this.IsSearch.Checked ? "Y" : "N";

            SqlCmd.SelectCommand.Parameters.Add("@IsHide", SqlDbType.Char, 1);
            SqlCmd.SelectCommand.Parameters["@IsHide"].Value = this.IsHide.Checked ? "Y" : "N";

            string topt = Options.Value.Replace(",", "%2C").Replace("\r\n", ",");

            SqlCmd.SelectCommand.Parameters.Add("@Opts", SqlDbType.NVarChar, topt.Length + 1);
            SqlCmd.SelectCommand.Parameters["@Opts"].Value = topt;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            if (Convert.ToInt32(DS.Tables[0].Rows[0]["RetID"]) > 0)
            {
                IsOK = true;
            }
        }
    }
}