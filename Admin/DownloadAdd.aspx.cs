using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using EBMSMap30;

namespace EBMSMap.Web.Admin
{
    public partial class DownloadAdd : System.Web.UI.Page
    {
        public int retID;
        public DataTable tbDL;
        List<MInput> mInputs = new List<MInput>();
        protected void Page_Load(object sender, EventArgs e)
        {
            cUsr.CheckAuth("A");
            mInputs.Add(new MInput() { HtmlInput = Name, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = DocType, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = SysGrp, DBType = MInput.DataType.String });
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["DlID"] != null)
                {
                    DataSet DS = MData.GetDataAdm("spDLd_Get", "DlID", Request.QueryString["DlID"], mInputs);
                    tbDL = DS.Tables[0];
                }
            }
        }


        protected void bSave_ServerClick(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spDLd_Add", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@DlID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@DlID"].Value = Request.QueryString["DlID"];

            MData.AddSqlCmd(SqlCmd, mInputs);


            if (Request.Files["File1"].ContentLength > 0)
            {
                string fileExt = Request.Files["File1"].FileName.Substring(Request.Files["File1"].FileName.LastIndexOf(".") + 1);
                SqlCmd.SelectCommand.Parameters.Add("@FileExt", SqlDbType.VarChar, 10);
                SqlCmd.SelectCommand.Parameters["@FileExt"].Value = fileExt;

            }

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            

            retID = Convert.ToInt32(DS.Tables[0].Rows[0]["retID"]);

            if (retID > 0 && Request.Files["File1"].ContentLength > 0)
            {
                string fileExt = Request.Files["File1"].FileName.Substring(Request.Files["File1"].FileName.LastIndexOf(".") + 1);
                string fileid = string.Format("{0:000000000}", retID);
                FileInfo fi = new FileInfo(Server.MapPath("../Files") + @"\Download\Doc" + retID + "." + fileExt);


                if (!fi.Directory.Exists)
                    fi.Directory.Create();

                Request.Files["File1"].SaveAs(fi.FullName);
            }
        }
    }
}