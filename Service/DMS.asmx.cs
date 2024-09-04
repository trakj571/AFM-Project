using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Net;
using EBMSMap30;

namespace AFMProj.Service
{
    /// <summary>
    /// Summary description for DMS
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class DMS : System.Web.Services.WebService
    {
        public class Equip
        {
            public int EquipID { get; set; }
            public string EquipName { get; set; }
        }

        public class Scan
        {
            public int ScanID { get; set; }
            public int EquipID { get; set; }
            public string EquipName { get; set; }
            public string DataType { get; set; }
            public string DateTime { get; set; }
            public double FreqStart { get; set; }
            public double FreqEnd { get; set; }
        }

        public class ScanValue
        {
            public double Freq { get; set; }
            public double Signal { get; set; }
            public double OccMax { get; set; }
            public double OccAvg { get; set; }
            //public double Bearing { get; set; }
            //public double Quality { get; set; }
        }

        [WebMethod]
        public List<Equip> GetEquips()
        {
            var retList = new List<Equip>();

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spEquip_Gets]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = -99;

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

            retList.Add(new Equip() { EquipID = 0, EquipName = "All Equipment" });

            for (int i = 0; i < tbE.Rows.Count; i++)
            {
                retList.Add(new Equip() { EquipID = cConvert.ToInt(tbE.Rows[i]["PoiID"]), EquipName = tbE.Rows[i]["Name"].ToString() });
            }


            return retList;
        }

        [WebMethod]
        public List<Scan> SearchScan(int EquipID, string DtStart, string DtEnd, double FreqStart, double FreqEnd)
        {
            var retList = new List<Scan>();

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spScanSch", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = -99;

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = EquipID;

            SqlCmd.SelectCommand.Parameters.Add("@fDt", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@fDt"].Value = cConvert.ConvertToDate(DtStart);

            SqlCmd.SelectCommand.Parameters.Add("@tDt", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@tDt"].Value = cConvert.ConvertToDate(DtEnd);

            SqlCmd.SelectCommand.Parameters.Add("@fFreq", SqlDbType.BigInt);
            SqlCmd.SelectCommand.Parameters["@fFreq"].Value = FreqStart * 1000000;

            SqlCmd.SelectCommand.Parameters.Add("@tFreq", SqlDbType.BigInt);
            SqlCmd.SelectCommand.Parameters["@tFreq"].Value = FreqEnd * 1000000;


            SqlCmd.SelectCommand.Parameters.Add("@nPage", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@nPage"].Value = 200;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            DataTable tbH = DS.Tables[0];
            DataTable tbD = DS.Tables[1];

         
            for (int i = 0; i < tbD.Rows.Count; i++)
            {
                retList.Add(new Scan() {
                    ScanID = cConvert.ToInt(tbD.Rows[i]["ScanID"]),
                    EquipID = cConvert.ToInt(tbD.Rows[i]["PoiID"]), 
                    EquipName = tbD.Rows[i]["Station"].ToString(),
                    DataType = tbD.Rows[i]["DataTypeText"].ToString(),
                    DateTime = string.Format("{0:dd/MM/yyyy HH:mm}", tbD.Rows[i]["DtBegin"]),
                    FreqStart = cConvert.ToDouble(tbD.Rows[i]["fFreq"]),
                    FreqEnd = cConvert.ToDouble(tbD.Rows[i]["tFreq"])
                
                });
            }


            return retList;
        }


        [WebMethod]
        public List<ScanValue> GetScanData(int ScanID)
        {
            var retList = new List<ScanValue>();

            DataTable tbS = getScanDet(ScanID);
            DataTable tbD = getScanData(ScanID);


            for (int i = 0; i < tbD.Rows.Count; i++)
            {
                if (tbS.Rows[0]["DataType"].ToString() == "O")
                {
                    retList.Add(new ScanValue()
                    {
                        Freq = cConvert.ToDouble(tbD.Rows[i]["Freq"]),
                        OccMax = cConvert.ToDouble(tbD.Rows[i]["OccMax"]),
                        OccAvg = cConvert.ToDouble(tbD.Rows[i]["OccAvg"])
                    });
                }
                else
                {
                    retList.Add(new ScanValue()
                    {
                        Freq = cConvert.ToDouble(tbD.Rows[i]["Freq"]),
                        Signal = cConvert.ToDouble(tbD.Rows[i]["Signal"])
                    });
                       
                }
               
            }


            return retList;
        }


        ///
        private DataTable getScanDet(int ScanID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spScan_Get", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value = ScanID;



            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            return DS.Tables[0];
        }

        private DataTable getScanData(int ScanID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spScan_GetData", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value = ScanID;


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();


            return DS.Tables[0];
        }
    }
}
