using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using EBMSMap30;
using System.Resources;
using Org.BouncyCastle.Asn1.Ocsp;
using System.Net;
using NPOI.SS.Formula.Functions;
using System.IO;
using System.Text.RegularExpressions;

namespace AFMProj.PlugIn
{
    /// <summary>
    /// Summary description for Download
    /// </summary>
    public class Upload : IHttpHandler
    {
        public class WebClientWithTimeout : WebClient
        {
            protected override WebRequest GetWebRequest(Uri address)
            {
                WebRequest wr = base.GetWebRequest(address);
                wr.Timeout = 180 * 60 * 1000; // timeout in milliseconds (ms)
                return wr;
            }
        }


        public int GetWavFileDuration(string fileName)
        {
            int nSec = 0;
            /*try
            {
                WaveFileReader wf = new WaveFileReader(fileName);
                nSec = (int)Math.Round(wf.TotalTime.TotalSeconds);
            }
            catch (Exception ex)
            {

            }
            */
            if (nSec == 0)
            {
                FileInfo fi = new FileInfo(fileName);

                nSec = (int)(fi.Length / (48000 * 2 * 16 / 8));
            }

            return nSec;
        }
        EBMSIdentity id;
        public void ProcessRequest(HttpContext context)
        {
            id = cUsr.GetIdentity(context.Request["token"]);
            id.IsVerify = true;
            if (id.IsVerify)
            {
                var dr = GetStations(id.UID, context.Request["PoiID"]);
                if (dr.Length > 0)
                {
                    string file = ("/" + context.Request["file"]).Replace("*", "'");
                    string url = "ftp://" + dr[0]["FTPAdr"] + "" + file;
                    string filename = file.Substring(file.LastIndexOf("/") + 1);

                    if (file.EndsWith(".csv"))
                         DownloadFile(cConvert.ToInt(dr[0]["PoiID"]), url, ConfigurationManager.AppSettings["AFM2Dir"] + @"\" + dr[0]["PoiID"] + @"\Logger\" + file);

                   if (file.EndsWith(".wav"))
                        DownloadFile(cConvert.ToInt(dr[0]["PoiID"]), url, ConfigurationManager.AppSettings["AFM2Dir"] + @"\" + dr[0]["PoiID"] + @"\Voice\" + file);

                    if (!(file.Length < 2 || file.EndsWith(".wwv") || file.EndsWith(".wav")))
                        DownloadFileFTP(cConvert.ToInt(dr[0]["PoiID"]), "ftp://" + dr[0]["FTPAdr"].ToString() + ":21/" + file, ConfigurationManager.AppSettings["FTPAFM2Dir"] + @"\" + dr[0]["Dir"] + @"\" + file);
                    
                }
            }

            context.Response.Write("{}");
           
        }

        private DataRow[] GetStations(int UID, string PoiID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spEquip_Get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            
            SqlCmd.SelectCommand.Parameters.Add("@EquType", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@EquType"].Value = "STN2";

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            return DS.Tables[1].Select("PoiID=" + PoiID);
        }

        private void DownloadFileFTP(int PoiID, string url, string path)
        {
            try
            {
                url = ConfigurationManager.AppSettings["FTP_AFM2_URL"] + "/Download.aspx?url=" + url + "&tmpkey=" + HttpContext.Current.Request["tmpkey"];


                FileInfo fi = new FileInfo(path.Replace("/", "\\"));
                if (!fi.Directory.Exists) fi.Directory.Create();

                //if (fi.Exists)
                //  return;

                Console.WriteLine("Download " + url);

                using (WebClientWithTimeout client = new WebClientWithTimeout())
                {
                    client.DownloadFile(url, fi.FullName);
                    //Log.Write("afm2ftp", url + " -> done (ftp)");

                }

            }
            catch (Exception ex)
            {
                //Log.Write("afm2ftp", url + " -> " + ex);
            }
        }
        private void DownloadFile(int PoiID, string url, string path)
        {
            try
            {
                //url = "http://talonnet.co.th/AFM/Service/Talonnet/Download.aspx?url=" + url + "&tmpkey=" + HttpContext.Current.Request["tmpkey"];
                url = ConfigurationManager.AppSettings["FTP_AFM2_URL"] + "/Download.aspx?url=" + url + "&tmpkey=" + HttpContext.Current.Request["tmpkey"];


                FileInfo fi = new FileInfo(path);
                if (!fi.Directory.Exists) fi.Directory.Create();

                //if (fi.Exists)
                  //  return;

                Console.WriteLine("Download " + url);

                using (WebClientWithTimeout client = new WebClientWithTimeout())
                {
                    client.DownloadFile(url, fi.FullName);
                    //Log.Write("afm2ftp", url + " -> done");

                }
                string tmpkey = Comm.RandPwd(10) + string.Format("-{0:yyMMddHHmmss}", DateTime.Now);
                //if (path.EndsWith(".csv"))
                  //  ProcessFile(PoiID, "F", fi, tmpkey);
                if (path.EndsWith(".wav"))
                    SaveVoiceFile(PoiID, fi.Name, this.GetWavFileDuration(fi.FullName));

            }
            catch (Exception ex)
            {
                //Log.Write("afm2ftp", url + " -> " + ex);
            }
        }

        private void ProcessFile(int PoiID, string DataType, FileInfo fi, string TmpKey)
        {

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spDMSFileAdd", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = id.UID;

            SqlCmd.SelectCommand.Parameters.Add("@TmpKey", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@TmpKey"].Value = TmpKey;

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = PoiID;

            SqlCmd.SelectCommand.Parameters.Add("@DataType", SqlDbType.Char, 1);
            SqlCmd.SelectCommand.Parameters["@DataType"].Value = DataType;


            SqlCmd.SelectCommand.Parameters.Add("@FileName", SqlDbType.VarChar, 100);
            SqlCmd.SelectCommand.Parameters["@FileName"].Value = fi.Name;

            string fileExt = fi.Name.Substring(fi.Name.LastIndexOf(".") + 1).ToLower();

            SqlCmd.SelectCommand.Parameters.Add("@FileExt", SqlDbType.VarChar, 20);
            SqlCmd.SelectCommand.Parameters["@FileExt"].Value = fileExt;


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            int retAID = Convert.ToInt32(DS.Tables[0].Rows[0]["retID"]);

            if (retAID > 0)
            {
                if (fileExt == "csv" || fileExt == "spa")
                {
                    ProcessCSV(fi, DS.Tables[0].Rows[0]["retID"], fileExt);
                }
            }

            int retID = SaveFMSFile(PoiID, TmpKey);
            //Log.Write("afm2FTP", "ProcessFile Done " + fi.FullName + " " + PoiID + " " + TmpKey + " -> " + retID);
        }

        private int SaveFMSFile(int PoiID, string TmpKey)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.[spFMSFileSave]", SqlConn);
            SqlCmd.SelectCommand.CommandTimeout = 1800;
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = id.UID;

            SqlCmd.SelectCommand.Parameters.Add("@TmpKey", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@TmpKey"].Value = TmpKey;

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = PoiID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            return Convert.ToInt32(DS.Tables[0].Rows[0]["retID"]);
        }

        private void PutData(CSVData data, string cs, string f)
        {
            if (cs == "A") data.A = f;
            if (cs == "B") data.B = f;
            if (cs == "C") data.C = f;
            if (cs == "D") data.D = f;
            if (cs == "E") data.E = f;
            if (cs == "F") data.F = f;
            if (cs == "G") data.G = f;
            if (cs == "H") data.H = f;
            if (cs == "I") data.I = f;
            if (cs == "J") data.J = f;
            if (cs == "K") data.K = f;

            if (cs == "L") data.L = f;
            if (cs == "M") data.M = f;
            if (cs == "N") data.N = f;
            if (cs == "O") data.O = f;
            if (cs == "P") data.P = f;
            if (cs == "Q") data.Q = f;
            if (cs == "R") data.R = f;
            if (cs == "S") data.S = f;
            if (cs == "T") data.T = f;
            if (cs == "U") data.U = f;
            if (cs == "V") data.V = f;
            if (cs == "W") data.W = f;
            if (cs == "X") data.X = f;
            if (cs == "Y") data.Y = f;
            if (cs == "Z") data.Z = f;

        }
        private void InsertCSV(CSVDatas csvDatas)
        {
            using (IDataReader reader = csvDatas.GetDataReader())
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]))
            using (SqlBulkCopy bcp = new SqlBulkCopy(conn))
            {
                conn.Open();
                bcp.BulkCopyTimeout = 30 * 60;
                bcp.DestinationTableName = "AFM_LOG.dbo.tbDMS_CSV";
                bcp.WriteToServer(reader);
            }

        }
        private void ClrAFCCSV(object fID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spDMS_CSVClr", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@fID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@fID"].Value = fID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

        }

        private void ProcessCSV(FileInfo fi, object id, string FileExt)
        {
            ClrAFCCSV(id);

            //if (!fi.Exists) return;

            Regex CSVParser = new Regex(",(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))");
            //var csvtexts = File.ReadAllLines(fi.FullName);

            string C = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM,AN,AO,AP,AQ,AR,AS,AT,AU,AV,AW,AX,AY,AZ";
            string[] Cs = C.Split(',');
            int rownum = 0;
            var csvDatas = new CSVDatas();
            //for (int i = 0; i < csvtexts.Length; i++)
            int i = 0;
            bool issep2 = false;
            foreach (string line in File.ReadLines(fi.FullName))
            {
                //Console.WriteLine(i + "/" + csvtexts.Length);
                string m_line = line;
                if (m_line.Trim() == "sep=^")
                {
                    issep2 = true;
                    continue;
                }
                if (issep2)
                {
                    m_line = m_line.Replace("^", ",");
                }
                i++;
                rownum++;


                CSVData data = new CSVData();
                data.fID = cConvert.ToInt(id);
                data.rowNum = rownum;

                string[] Fields = CSVParser.Split(m_line);
                for (int j = 0; j < Fields.Length; j++)
                {
                    string f = Fields[j].Replace("\"", "");
                    PutData(data, Cs[j], f);

                }
                csvDatas.Add(data);

                if (i % 1000000 == 0)
                {
                    InsertCSV(csvDatas);
                    csvDatas.Clear();
                }
            }
            InsertCSV(csvDatas);
        }


        //[fms].[spFMSVoiceSave]
        private void SaveVoiceFile(int PoiID, string VoiceFile, int nSec)
        {
            if (VoiceFile.Split('-').Length < 3)
                return;

            int VoicePart = 0;

            string[] part = VoiceFile.Split('^');
            if (part.Length > 1)
                VoicePart = cConvert.ToInt(part[1].Replace(".wav", "").Trim());

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.[spFMSVoiceSave]", SqlConn);
            SqlCmd.SelectCommand.CommandTimeout = 1800;
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = id.UID;

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = PoiID;

            SqlCmd.SelectCommand.Parameters.Add("@nSec", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@nSec"].Value = nSec;

            SqlCmd.SelectCommand.Parameters.Add("@VoiceFile", SqlDbType.NVarChar, 100);
            SqlCmd.SelectCommand.Parameters["@VoiceFile"].Value = VoiceFile.Replace(".wav", "").Replace("-^", "^").Split('^')[0];

            SqlCmd.SelectCommand.Parameters.Add("@VoicePart", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@VoicePart"].Value = VoicePart;

            SqlCmd.SelectCommand.Parameters.Add("@DtBegin", SqlDbType.SmallDateTime);
            SqlCmd.SelectCommand.Parameters["@DtBegin"].Value = ConvertTime(VoiceFile);

            SqlCmd.SelectCommand.Parameters.Add("@Freq", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@Freq"].Value = ConvertFreq(VoiceFile);


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

        }

        private DateTime ConvertTime(string dt)
        {
            //2020-02-14-12.06.20.145
            //scheduler-95.5MHz_20-08-25_01'50'38-^001
            //scheduler-95.5MHz_20-08-25_01'50'38
            dt = dt.Replace(".wav", "");
            dt = dt.Replace("_", "-");
            dt = dt.Replace("'", "-");

            var dts = dt.Split('-');

            return new DateTime(Convert.ToInt32("20" + dts[2]), Convert.ToInt32(dts[3]), Convert.ToInt32(dts[4]),
                Convert.ToInt32(dts[5]), Convert.ToInt32(dts[6]), Convert.ToInt32(dts[7])).ToLocalTime();
        }

        private double ConvertFreq(string fq)
        {
            //2020-02-14-12.06.20.145
            //scheduler-95.5MHz_20-08-25_01'50'38-^001
            //scheduler-95.5MHz_20-08-25_01'50'38
            fq = fq.Replace(".wav", "");
            fq = fq.Replace("_", "-");
            fq = fq.Replace("'", "-");

            var fqs = fq.Split('-');
            if (fqs[1].EndsWith("MHz"))
                return cConvert.ToDouble(fqs[1].Replace("MHz", "")) * 1e6;

            if (fqs[1].EndsWith("kHz"))
                return cConvert.ToDouble(fqs[1].Replace("kHz", "")) * 1e3;

            return cConvert.ToDouble(fqs[1]);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}