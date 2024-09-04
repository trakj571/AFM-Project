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
    public partial class FreqStat : System.Web.UI.Page
    {

        public DataTable tbT, tbL, tbF, tbC;
        List<MInput> mInputs = new List<MInput>();

        protected void Page_Load(object sender, EventArgs e)
        {

            GetLayers();
            if (!Page.IsPostBack)
            {
                if (fDt.Value == "") fDt.Value = string.Format("{0:dd/MM/yyyy}", DateTime.Now.AddDays(-1));
                if (tDt.Value == "") tDt.Value = string.Format("{0:dd/MM/yyyy}", DateTime.Now);

            }


            if (Request.ServerVariables["query_string"].ToString() != "")
            {
                fDt.Value = cText.StrFromUTF8(Request.QueryString["fDt"]);
                tDt.Value = cText.StrFromUTF8(Request.QueryString["tDt"]);
                Level.Value = cText.StrFromUTF8(Request.QueryString["Level"]);
                ProvID.Value = cText.StrFromUTF8(Request.QueryString["ProvID"]);
                LyID1.Value = cText.StrFromUTF8(Request.QueryString["LyID1"]);
                LyID2.Value = cText.StrFromUTF8(Request.QueryString["LyID2"]);

                mInputs.Add(new MInput() { HtmlInput = Level, DBType = MInput.DataType.Int });
                mInputs.Add(new MInput() { HtmlInput = LyID1, DBType = MInput.DataType.Int });
                mInputs.Add(new MInput() { HtmlInput = LyID2, DBType = MInput.DataType.Int });
                mInputs.Add(new MInput() { HtmlInput = ProvID, DBType = MInput.DataType.Int });

                SchData();
            }
        }

        private void GetLayers()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spEquip_GetLayer]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = -99;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbL = DS.Tables[0];
            LyID1.Items.Clear();
            LyID1.Items.Add(new ListItem("= ทั้งหมด =", "0"));

            LyID2.Items.Clear();
            LyID2.Items.Add(new ListItem("= ทั้งหมด =", "0"));

            for (int l0 = 0; l0 < tbL.Rows.Count; l0++)
            {
                if (cConvert.ToInt(tbL.Rows[l0]["pLyID"]) > 0)
                    continue;
                int pLyID0 = cConvert.ToInt(tbL.Rows[l0]["LyID"]);
                for (int l1 = 0; l1 < tbL.Rows.Count; l1++)
                {
                    if (cConvert.ToInt(tbL.Rows[l1]["pLyID"]) != pLyID0)
                        continue;
                    LyID1.Items.Add(new ListItem(tbL.Rows[l1]["Name"].ToString(), tbL.Rows[l1]["LyID"].ToString()));
                    int pLyID1 = cConvert.ToInt(tbL.Rows[l1]["LyID"]);
                    for (int l2 = 0; l2 < tbL.Rows.Count; l2++)
                    {
                        if (cConvert.ToInt(tbL.Rows[l2]["pLyID"]) != pLyID1)
                            continue;

                        LyID2.Items.Add(new ListItem(tbL.Rows[l2]["Name"].ToString(), tbL.Rows[l2]["LyID"].ToString()));
                    }
                }
            }
        }

        public void SchData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spDMS_FreqStat", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@fDt", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@fDt"].Value = cConvert.ConvertToDateTH(fDt.Value);

            SqlCmd.SelectCommand.Parameters.Add("@tDt", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@tDt"].Value = cConvert.ConvertToDateTH(tDt.Value);


            MData.AddSqlCmd(SqlCmd, mInputs);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();


            tbF = DS.Tables[2];
            tbC = DS.Tables[3];

            int iLevel = cConvert.ToInt(Level.Value);
            tbT = BuiltTbT(DS, iLevel,false);

            if (Request["export"] != null)
            {
                for (int i = 0; i < tbT.Rows.Count; i++)
                {
                    tbT.Rows[i]["Area"] = tbT.Rows[i]["Area"].ToString().Replace("&nbsp;", " ");
                }
                List<string> columns = new List<string>();
                columns.Add("Area:พื้นที่");
                for (int i = 0; i < tbF.Rows.Count; i++)
                {
                    columns.Add("Freq" + tbF.Rows[i]["FtID"] + ":" + string.Format("{0}-{1} MHz", tbF.Rows[i]["fFreq"], tbF.Rows[i]["tFreq"]));
                }

                Export.ToFile(tbT, columns, "", "");
            }
        }

        public static DataTable BuiltTbT(DataSet DS, int iLevel ,bool IsChart)
        {
            DataTable tbL1 = DS.Tables[0];
            DataTable tbP = DS.Tables[1];
            DataTable tbF = DS.Tables[2];
            DataTable tbC = DS.Tables[3];

            DataTable tbT = new DataTable();
            tbT.Columns.Add("Area");
            for (int i = 0; i < tbF.Rows.Count; i++)
            {
                //tbT.Columns.Add(string.Format("{0}-{1} MHz",tbF.Rows[i]["fFreq"],tbF.Rows[i]["tFreq"]));
                tbT.Columns.Add("Freq" + tbF.Rows[i]["FtID"].ToString());
            }


            if (iLevel == 4)
            {
                foreach (var dr4 in tbL1.Select("Level=" + iLevel))
                {
                    tbT.Rows.Add(AddRow(tbT, DS, iLevel, dr4, 4)); //TH
                    if (IsChart)
                        continue;
                    foreach (var dr3 in tbL1.Select("pLyID=" + dr4["LyID"]))
                    {
                        tbT.Rows.Add(AddRow(tbT, DS, iLevel, dr3, 3)); //R
                        foreach (var dr2 in tbL1.Select("pLyID=" + dr3["LyID"]))
                        {
                            tbT.Rows.Add(AddRow(tbT, DS, iLevel, dr2, 2)); //D
                            foreach (var dr1 in tbP.Select("LyID=" + dr2["LyID"]))
                            {
                                tbT.Rows.Add(AddRow(tbT, DS, iLevel, dr1, 1)); //P
                            }
                        }
                    }
                }
            }

            if (iLevel == 3)
            {
                foreach (var dr3 in tbL1.Select("Level=" + iLevel))
                {
                    tbT.Rows.Add(AddRow(tbT, DS, iLevel, dr3, 3)); //R
                    if (IsChart)
                        continue;
                       
                    foreach (var dr2 in tbL1.Select("pLyID=" + dr3["LyID"]))
                    {
                        tbT.Rows.Add(AddRow(tbT, DS, iLevel, dr2, 2)); //D
                        foreach (var dr1 in tbP.Select("LyID=" + dr2["LyID"]))
                        {
                            tbT.Rows.Add(AddRow(tbT, DS, iLevel, dr1, 1)); //P
                        }
                    }
                }
            }

            if (iLevel == 2)
            {
                foreach (var dr2 in tbL1.Select("Level=" + iLevel))
                {
                    tbT.Rows.Add(AddRow(tbT, DS, iLevel, dr2, 2)); //D
                    if (IsChart)
                        continue;
                    foreach (var dr1 in tbP.Select("LyID=" + dr2["LyID"]))
                    {
                        tbT.Rows.Add(AddRow(tbT, DS, iLevel, dr1, 1)); //P
                    }
                }
            }
            return tbT;
        }
        static DataRow AddRow(DataTable tbT, DataSet DS, int iLevel, DataRow dr, int level)
        {
            DataTable tbL1 = DS.Tables[0];
            DataTable tbP = DS.Tables[1];
            DataTable tbF = DS.Tables[2];
            DataTable tbC = DS.Tables[3];

            DataRow dr1 = tbT.NewRow();
            string sp = "";
            for (int i = 0; i < iLevel - level; i++)
                sp += "&nbsp;&nbsp;";

            dr1["Area"] = sp + dr["Name"].ToString();


            for (int i = 0; i < tbF.Rows.Count; i++)
            {
                DataRow[] drc = null;
                if (level == 4)
                    drc = tbC.Select("PoiID=0 and LyID1=0 and LyID2=0 and FtID=" + tbF.Rows[i]["FtID"]);
                if (level == 3)
                    drc = tbC.Select("PoiID=0 and LyID1=" + dr["LyID"] + " and LyID2=0 and FtID=" + tbF.Rows[i]["FtID"]);
                if (level == 2)
                    drc = tbC.Select("PoiID=0 and LyID1=" + dr["pLyID"] + " and LyID2=" + dr["LyID"] + " and FtID=" + tbF.Rows[i]["FtID"]);
                if (level == 1)
                    drc = tbC.Select("PoiID=" + dr["PoiID"] + " and FtID=" + tbF.Rows[i]["FtID"]);

                if (drc != null && drc.Length > 0)
                    dr1["Freq" + tbF.Rows[i]["FtID"]] = cConvert.ToInt(drc[0]["cnt"]) > 0 ? drc[0]["cnt"].ToString() : drc[0]["isScan"].ToString();
            }

            return dr1;
        }

        
    }
}