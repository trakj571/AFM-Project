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
    public partial class CSaveTpl : System.Web.UI.Page
    {
        public int retID;
        List<MInput> mInputs = new List<MInput>();
        public bool IsOK;
        protected void Page_Load(object sender, EventArgs e)
        {
            cUsr.CheckAuth("A");
            mInputs.Add(new MInput() { HtmlInput = Name, DBType = MInput.DataType.String });
           
            
          
            if (!Page.IsPostBack)
            {
               
            }
        }


        protected void bSave_ServerClick(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spCon_AddTplFrm", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@Name", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Name"].Value = Name.Value;

            SqlCmd.SelectCommand.Parameters.Add("@typeid", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@typeid"].Value = Request.QueryString["typeid"];

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            retID = Convert.ToInt32(DS.Tables[0].Rows[0]["retID"]);
           
        }
    }
}