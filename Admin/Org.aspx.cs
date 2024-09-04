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
    public partial class Org : System.Web.UI.Page
    {
        public int retID;
        public DataTable tbU;
        List<MInput> mInputs = new List<MInput>();
        protected void Page_Load(object sender, EventArgs e)
        {
            cUsr.CheckAuth("A");
            mInputs.Add(new MInput() { HtmlInput = Name, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = OrgCode, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Detail, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = pOrgID, DBType = MInput.DataType.Int });
            mInputs.Add(new MInput() { HtmlInput = Address, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = TelNo, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = FaxNo, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Email, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = WebSite, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Lat, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = Lng, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = ProvIDs1, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = ProvIDs2, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = ProvIDs3, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = ProvIDs4, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = ProvIDs5, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = ProvIDs6, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = ProvIDs7, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = ProvIDs8, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = ProvIDs9, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = ProvIDs10, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = AuthName, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = AreaList, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsRegView, DBType = MInput.DataType.Check });
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["OrgID"] != null)
                {
                    DataSet DS = MData.GetDataAdm("spOrg_Get", "OrgID", Request.QueryString["OrgID"], mInputs);
                    tbU = DS.Tables[1];

                    GetVersion();
                }
            }
        }

        private void GetVersion() {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spOrgVer_Get", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            var tb = DS.Tables[0];
            VerID.Items.Clear();
            for (int i = 0; i < tb.Rows.Count; i++) {
                VerID.Items.Add(new ListItem(tb.Rows[i]["ver"]+" ("+ tb.Rows[i]["Name"]+")", tb.Rows[i]["verid"].ToString()));
            }

            VerID.Value = VerID.Items[VerID.Items.Count - 1].Value;
        }


        public string ProvIDs(int i)
        {
            if (i == 0) return ProvIDs1.Value;
            if (i == 1) return ProvIDs2.Value;
            if (i == 2) return ProvIDs3.Value;
            if (i == 3) return ProvIDs4.Value;
            if (i == 4) return ProvIDs5.Value;
            if (i == 5) return ProvIDs6.Value;
            if (i == 6) return ProvIDs7.Value;
            if (i == 7) return ProvIDs8.Value;
            if (i == 8) return ProvIDs9.Value;
            if (i == 9) return ProvIDs10.Value;

            return "";
        }
    }
}