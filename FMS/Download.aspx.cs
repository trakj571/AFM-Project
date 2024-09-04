using System;
using System.Collections.Generic;
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
using System.IO;
using ICSharpCode.SharpZipLib.Zip;
using ICSharpCode.SharpZipLib.Checksums;

namespace AFMProj.FMS
{
    public partial class Download : System.Web.UI.Page
    {
        public DataTable tbD;
        public string StreamURL;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (cConvert.ToInt(Request["ScanID"]) > 0)
            {
                GetData();
            }
         }
        private void GetData()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spScan_Get", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value = Request["ScanID"];


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbD = DS.Tables[0];
            if (tbD.Rows.Count > 0)
            {
                int n = EBMSMap30.cConvert.ToInt(tbD.Rows[0]["VoicePart"]);
                FileInfo[] fis = new FileInfo[n + 1];
                for (int i = 0; i <= n; i++)
                {
                    string file = Server.MapPath("../") + "Files/FTPAFM2/" + tbD.Rows[0]["POIID"] + "/Voice/" + tbD.Rows[0]["VoiceFile"] + (i > 0 ? "-^" + string.Format("{0:000}", i) : "") + ".wav";
                    fis[i] = new FileInfo(file);
                }
                CreateZip(fis, tbD.Rows[0]["VoiceFile"]+".zip");
            }
        }

        public void CreateZip(FileInfo[] stackFiles,string FileZip)
        {
            try
            {
                MemoryStream ms = new MemoryStream();
                Crc32 crc = new Crc32();
                ZipOutputStream zipOutput = new ZipOutputStream(ms);
                zipOutput.SetLevel(6); // 0 - store only to 9 - means best compression


                int index = 0;
                foreach (FileInfo fi in stackFiles)
                {
                    ++index;

                    FileStream fs = File.OpenRead(fi.FullName);

                    byte[] buffer = new byte[fs.Length];
                    fs.Read(buffer, 0, buffer.Length);

                    //Create the right arborescence within the archive
                    string stFileName = fi.Name;
                    ZipEntry entry = new ZipEntry(stFileName);

                    entry.DateTime = DateTime.Now;

                    // set Size and the crc, because the information
                    // about the size and crc should be stored in the header
                    // if it is not set it is automatically written in the footer.
                    // (in this case size == crc == -1 in the header)
                    // Some ZIP programs have problems with zip files that don't store
                    // the size and crc in the header.
                    entry.Size = fs.Length;
                    fs.Close();

                    crc.Reset();
                    crc.Update(buffer);

                    entry.Crc = crc.Value;

                    zipOutput.PutNextEntry(entry);

                    zipOutput.Write(buffer, 0, buffer.Length);
                }
                zipOutput.Finish();
                zipOutput.Close();
                zipOutput = null;

                Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", FileZip));
                Response.BinaryWrite(ms.ToArray());
                Response.End();
            }
            catch (Exception)
            {
                
            }
        }
    }
}