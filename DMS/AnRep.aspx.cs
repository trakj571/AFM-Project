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
    public partial class AnRep : System.Web.UI.Page
    {
        public DataTable tbH, tbD;
        List<MInput> mInputs = new List<MInput>();

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Page.IsPostBack)
            {
                if (fDt.Value == "") fDt.Value = string.Format("{0:dd/MM/yyyy}", DateTime.Now.AddDays(-1));
                if (tDt.Value == "") tDt.Value = string.Format("{0:dd/MM/yyyy}", DateTime.Now);

            }


            if (Request.ServerVariables["query_string"].ToString() != "")
            {
                fDt.Value = cText.StrFromUTF8(Request.QueryString["fDt"]);
                tDt.Value = cText.StrFromUTF8(Request.QueryString["tDt"]);
                 TypeID.Value = cText.StrFromUTF8(Request.QueryString["TypeID"]);
                OffID.Value = cText.StrFromUTF8(Request.QueryString["OffID"]);
                SName.Value = cText.StrFromUTF8(Request.QueryString["SName"]);
                SAdr.Value = cText.StrFromUTF8(Request.QueryString["SAdr"]);

                mInputs.Add(new MInput() { HtmlInput = TypeID, DBType = MInput.DataType.Int });
                mInputs.Add(new MInput() { HtmlInput = OffID, DBType = MInput.DataType.Int });
                mInputs.Add(new MInput() { HtmlInput = SName, DBType = MInput.DataType.String });
                mInputs.Add(new MInput() { HtmlInput = SAdr, DBType = MInput.DataType.String });
                
                SchData();
            }
        }

        private void SchData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spVF_Sch", SqlConn);
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

            
            

            if (Request["export"] != null)
            {
                List<string> columns = new List<string>();
                columns.Add("Station:Equipment");
                columns.Add("DataTypeText:Data Type");
                columns.Add("DtBegin:วัน-เวลา เริ่มต้น");
                columns.Add("fFreq:ความถี่เริ่มต้น(MHz)");
                columns.Add("tFreq:ความถี่สิ้นสุด(MHz)");
                

                Export.ToFile(tbD, columns, "", "");
            }
        }
       
    }
}