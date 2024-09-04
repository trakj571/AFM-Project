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
    public partial class CGrpAdd : System.Web.UI.Page
    {
        public int retID;
        List<MInput> mInputs = new List<MInput>();
        protected void Page_Load(object sender, EventArgs e)
        {
            cUsr.CheckAuth("A");
            mInputs.Add(new MInput() { HtmlInput = Name, DBType = MInput.DataType.String }); 
            mInputs.Add(new MInput() { HtmlInput = Detail, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsActive, DBType = MInput.DataType.Check });
           
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["CGID"] != null)
                {
                    DataSet DS = MData.GetDataAdm("spCon_GetGrp", "CGID", Request.QueryString["CGID"], mInputs);
                    UGIDs.Value = JSData.Join(DS.Tables[1], "UGID");
                    OrgIDs.Value = JSData.Join(DS.Tables[2], "OrgID");     
                }
            }
        }


        protected void bSave_ServerClick(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spCon_AddGrp", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@CGID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@CGID"].Value = Request.QueryString["CGID"];

            SqlCmd.SelectCommand.Parameters.Add("@UGIDs", SqlDbType.NVarChar, UGIDs.Value.Length + 1);
            SqlCmd.SelectCommand.Parameters["@UGIDs"].Value = UGIDs.Value;

            SqlCmd.SelectCommand.Parameters.Add("@OrgIDs", SqlDbType.NVarChar,OrgIDs.Value.Length+1);
            SqlCmd.SelectCommand.Parameters["@OrgIDs"].Value = OrgIDs.Value;

            MData.AddSqlCmd(SqlCmd, mInputs);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            retID = Convert.ToInt32(DS.Tables[0].Rows[0]["retID"]);
        }
        
    }
}