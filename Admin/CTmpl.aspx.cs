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
using System.IO;

namespace EBMSMap.Web.Admin
{
    public partial class CTmpl : System.Web.UI.Page
    {
        public int retID;
        public DataTable tbC;
        List<MInput> mInputs = new List<MInput>();
        protected void Page_Load(object sender, EventArgs e)
        {
            cUsr.CheckAuth("A");
            mInputs.Add(new MInput() { HtmlInput = Name, DBType = MInput.DataType.String }); 
            mInputs.Add(new MInput() { HtmlInput = Detail, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsActive, DBType = MInput.DataType.Check });
           
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["TplID"] != null)
                {
                    LoadCTpl();
                }
            }
        }

        private void LoadCTpl()
        {
            DataSet DS = MData.GetDataAdm("spCon_GetTpl", "TplID", Request.QueryString["TplID"], mInputs);
            DataTable tbD = DS.Tables[0];
            tbC = DS.Tables[1];
        }
        protected void SaveOrder_ServerClick(object sender, EventArgs e)
        {
            if (ColIDs.Value=="")
                return;
            string[] colIDs =ColIDs.Value.Split(',');
            string[] orders = Orders.Value.Split(',');

            for (int k = 0; k < colIDs.Length; k += 5)
            {
                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
                SqlDataAdapter SqlCmd = new SqlDataAdapter("[spCon_OrderColsT]", SqlConn);
                SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

                SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

                SqlCmd.SelectCommand.Parameters.Add("@TplID", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@TplID"].Value = Request.QueryString["TplID"];


                for (int i = 0; i < 5 && k + i < colIDs.Length; i++)
                {
                    if (colIDs[k + i].Trim() == "")
                        continue;

                    SqlCmd.SelectCommand.Parameters.Add("@ColID" + (i + 1), SqlDbType.Int);
                    SqlCmd.SelectCommand.Parameters["@ColID" + (i + 1)].Value = colIDs[k + i];

                    SqlCmd.SelectCommand.Parameters.Add("@iOrder" + (i + 1), SqlDbType.SmallInt);
                    SqlCmd.SelectCommand.Parameters["@iOrder" + (i + 1)].Value = orders[k + i];
                }
                DataSet DS = new DataSet();
                SqlCmd.Fill(DS);
                SqlConn.Close();

                retID = 1;
                LoadCTpl();
            }
        }

        
    }
}