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
    public partial class AnChkFq : System.Web.UI.Page
    {
        public DataTable tbH, tbD;
        List<MInput> mInputs = new List<MInput>();

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Page.IsPostBack)
            {
                if (fDt.Value == "") fDt.Value = string.Format("{0:dd/MM/yyyy}", DateTime.Now.AddDays(-1));
                if (tDt.Value == "") tDt.Value = string.Format("{0:dd/MM/yyyy}", DateTime.Now);

                MData.GetUItems(RegID, "fms.vwRegion");
                MData.GetUItems(AreaID, "fms.vwArea", "AreaID", "Name");
                MData.GetUItems(AreaID_raw, "fms.vwArea", "RegID,AreaID", "Name");
                MData.GetUItems(PoiID, "vwEquip", "PoiID", "Name");
                MData.GetUItems(PoiID_raw, "vwEquip", "AreaID,PoiID", "Name");

                //GetEuips();
            }


            if (Request.ServerVariables["query_string"].ToString() != "")
            {
                RegID.Value = cText.StrFromUTF8(Request.QueryString["RegID"]);
                AreaID.Value = cText.StrFromUTF8(Request.QueryString["AreaID"]);
                PoiID.Value = cText.StrFromUTF8(Request.QueryString["PoiID"]);
                fDt.Value = cText.StrFromUTF8(Request.QueryString["fDt"]);
                tDt.Value = cText.StrFromUTF8(Request.QueryString["tDt"]);
                fFreq.Value = cText.StrFromUTF8(Request.QueryString["fFreq"]);
                tFreq.Value = cText.StrFromUTF8(Request.QueryString["tFreq"]);
              
                mInputs.Add(new MInput() { HtmlInput = RegID, DBType = MInput.DataType.Int });
                mInputs.Add(new MInput() { HtmlInput = AreaID, DBType = MInput.DataType.Int });
                mInputs.Add(new MInput() { HtmlInput = PoiID, DBType = MInput.DataType.Int });
                
                SchData();
            }
        }

        private void GetEuips()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spEquip_Gets]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@EquType", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@EquType"].Value = "DMS";


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            DataTable tbE = DS.Tables[0];
            PoiID.Items.Clear();
            PoiID.Items.Add(new ListItem("= ทั้งหมด =", "0"));

            for (int i = 0; i < tbE.Rows.Count; i++)
            {
                PoiID.Items.Add(new ListItem(tbE.Rows[i]["Name"].ToString(), tbE.Rows[i]["PoiID"].ToString()));
            }
        }


        private void SchData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.[spScanSchFq]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;
            SqlCmd.SelectCommand.CommandTimeout = 180;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@fDt", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@fDt"].Value = cConvert.ConvertToDateTH(fDt.Value);

            SqlCmd.SelectCommand.Parameters.Add("@tDt", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@tDt"].Value = cConvert.ConvertToDateTH(tDt.Value);

            SqlCmd.SelectCommand.Parameters.Add("@fFreq", SqlDbType.BigInt);
            SqlCmd.SelectCommand.Parameters["@fFreq"].Value = cConvert.ToDouble(fFreq.Value);

            SqlCmd.SelectCommand.Parameters.Add("@tFreq", SqlDbType.BigInt);
            SqlCmd.SelectCommand.Parameters["@tFreq"].Value = cConvert.ToDouble(tFreq.Value);

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

            
            string freqs = "";
            for (int k = 0; k < tbD.Rows.Count; k += 100)
            {
                freqs = "";
                for (int i = k; i < tbD.Rows.Count && i < k + 100; i++)
                {
                    if (freqs != "")
                        freqs += ",";

                    freqs += tbD.Rows[i]["Freq"].ToString();
                }

                var tbHt = GetHost(freqs);
                for (int i = k; i < tbD.Rows.Count && i < k + 100; i++)
                {
                    tbD.Rows[i]["HostName"] = tbHt.Rows[i - k]["HostName"].ToString().PadRight(200).Substring(0,199);
                }
            }
            
            if (Request["export"] != null)
            {
                List<string> columns = new List<string>();
                columns.Add("Freq:ความถี่");
                columns.Add("Occ:% Occupancy");
                columns.Add("Area:เขต");
                columns.Add("Equip:อุปกรณ์");
                columns.Add("DtBegin:วันที่ตรวจสอบ");
                columns.Add("HostName:หน่วยงานผู้ใช้คลื่น");


                Export.ToFile(tbD, columns, "", "");
            }
        }

        private DataTable GetHost(string freqs)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["NBTCDC"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[fms].[spHostGets]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@Freqs", SqlDbType.VarChar, freqs.Length + 1);
            SqlCmd.SelectCommand.Parameters["@Freqs"].Value = freqs;



            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            return DS.Tables[0];
        }
    }
}