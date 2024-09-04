using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Net;
using EBMSMap30;
using System.Web.Script.Serialization;

namespace AFMProj.DMS
{
    public partial class DImpLog : System.Web.UI.Page
    {
        public DataTable tbH, tbD,tbL;
        List<MInput> mInputs = new List<MInput>();

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Page.IsPostBack)
            {
                GetLayers();
                if (fDt.Value == "") fDt.Value = string.Format("{0:dd/MM/yyyy}", DateTime.Now.AddDays(-1));
                if (tDt.Value == "") tDt.Value = string.Format("{0:dd/MM/yyyy}", DateTime.Now);

            }


            if (Request.ServerVariables["query_string"].ToString() != "")
            {
                fDt.Value = cText.StrFromUTF8(Request.QueryString["fDt"]);
                tDt.Value = cText.StrFromUTF8(Request.QueryString["tDt"]);
                ImpType.Value = cText.StrFromUTF8(Request.QueryString["ImpType"]);
                LyID.Value = cText.StrFromUTF8(Request.QueryString["LyID"]);

                mInputs.Add(new MInput() { HtmlInput = ImpType, DBType = MInput.DataType.String });
                mInputs.Add(new MInput() { HtmlInput = LyID, DBType = MInput.DataType.Int });
             
                SchData();
            }
        }

        private void GetLayers()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spEquip_GetLayer]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbL = DS.Tables[0];
            LyID.Items.Clear();
            LyID.Items.Add(new ListItem("= ทั้งหมด =","0"));

            for (int l0 = 0; l0 < tbL.Rows.Count; l0++)
            {
                if (cConvert.ToInt(tbL.Rows[l0]["pLyID"]) > 0)
                    continue;
                int pLyID0 = cConvert.ToInt(tbL.Rows[l0]["LyID"]);
                for (int l1 = 0; l1 < tbL.Rows.Count; l1++)
                {
                    if (cConvert.ToInt(tbL.Rows[l1]["pLyID"]) != pLyID0)
                        continue;

                    int pLyID1 = cConvert.ToInt(tbL.Rows[l1]["LyID"]);
                    for (int l2 = 0; l2 < tbL.Rows.Count; l2++)
                    {
                        if (cConvert.ToInt(tbL.Rows[l2]["pLyID"]) != pLyID1)
                            continue;

                            LyID.Items.Add(new ListItem(tbL.Rows[l2]["Name"].ToString(), tbL.Rows[l2]["LyID"].ToString()));
                    }
                }
            }
        }

        private void SchData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spDMS_ImpLogSch", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@fDt", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@fDt"].Value = cConvert.ConvertToDateTH(fDt.Value);

            SqlCmd.SelectCommand.Parameters.Add("@tDt", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@tDt"].Value = cConvert.ConvertToDateTH(tDt.Value);

          
            MData.AddSqlCmd(SqlCmd, mInputs);

            if (Request["export"] != null)
            {
                SqlCmd.SelectCommand.Parameters.Add("@nPage", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@nPage"].Value = 30000;
            }
            else
            {
                SqlCmd.SelectCommand.Parameters.Add("@Page", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@Page"].Value = Request["Page"];
            }

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbH = DS.Tables[0];
            tbD = DS.Tables[1];

            
            

        }
       
    }
}