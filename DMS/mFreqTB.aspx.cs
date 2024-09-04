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

namespace AFMProj.DMS
{
    public partial class mFreqTB : System.Web.UI.Page
    {
        public int retID = 0; 
        List<MInput> mInputs = new List<MInput>();

        protected void Page_Load(object sender, EventArgs e)
        {
            mInputs.Add(new MInput() { HtmlInput = fFreq, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = tFreq, DBType = MInput.DataType.Double });
            mInputs.Add(new MInput() { HtmlInput = ChSp, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = nCh, DBType = MInput.DataType.Int });

            if (!Page.IsPostBack)
            {
                if (cConvert.ToInt(Request["FtID"]) > 0)
                {
                    MData.GetData("dms.spFreqTBGet", "FtID", Request["FtID"], mInputs);
                }
            }
            
        }

        protected void bSave_ServerClick(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spFreqTBAdd", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@ftid", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ftid"].Value = Request.QueryString["ftid"];

            SqlCmd.SelectCommand.Parameters.Add("@Yr", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@Yr"].Value = cConvert.ToInt(Request.QueryString["Yr"]);

          
            MData.AddSqlCmd(SqlCmd, mInputs);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            retID = Convert.ToInt32(DS.Tables[0].Rows[0]["retID"]);
        }
       
    }
}