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
    public partial class DomainAdd : System.Web.UI.Page
    {
        public int retID;
        public DataTable tbDm;
        List<MInput> mInputs = new List<MInput>();
        protected void Page_Load(object sender, EventArgs e)
        {
            cUsr.CheckAuth("A");
            mInputs.Add(new MInput() { HtmlInput = Name, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Detail, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsActive, DBType = MInput.DataType.Check });

            mInputs.Add(new MInput() { HtmlInput = IsCRM, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsRep, DBType = MInput.DataType.String });


            if (!Page.IsPostBack)
            {
                if (Request.QueryString["DmID"] != null)
                {
                    DataSet DS = MData.GetDataAdm("spUR_GetDomain", "DmID", Request.QueryString["DmID"], mInputs);
                    tbDm = DS.Tables[0];
                    var tbLy = DS.Tables[1];
                    LyIDs.Value = "";
                    for (int i = 0; i < tbLy.Rows.Count; i++)
                    {
                        if (i > 0) LyIDs.Value += ",";
                        LyIDs.Value += tbLy.Rows[i]["LyID"].ToString();

                    }
                }
            }
        }


        protected void bSave_ServerClick(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spUR_AddDomain]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@DmID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@DmID"].Value = Request.QueryString["DmID"];

            string key = Comm.RandPwd(10) + "." + Comm.RandPwd(10) + "." + Comm.RandPwd(10);

            SqlCmd.SelectCommand.Parameters.Add("@Key", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Key"].Value = key + "==";

            SqlCmd.SelectCommand.Parameters.Add("@LyIDs", SqlDbType.NVarChar, LyIDs.Value.Length);
            SqlCmd.SelectCommand.Parameters["@LyIDs"].Value = LyIDs.Value;

            MData.AddSqlCmd(SqlCmd, mInputs);



            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            

            retID = Convert.ToInt32(DS.Tables[0].Rows[0]["retID"]);

            
        }
    }
}