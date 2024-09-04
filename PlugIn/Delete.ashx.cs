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
    public class Delete : IHttpHandler
    {
        public class WebClientWithTimeout : WebClient
        {
            protected override WebRequest GetWebRequest(Uri address)
            {
                WebRequest wr = base.GetWebRequest(address);
                wr.Timeout = 30 * 60 * 1000; // timeout in milliseconds (ms)
                return wr;
            }
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
                    if (dr[0]["EquType"].ToString() == "STN")
                    {
                        string[] paths = dr[0]["FTPPath"].ToString().Split('\\');
                        //string file = ConfigurationManager.AppSettings["FTPAFM1Dir"] + @"\" + dr[0]["FTPPath"].ToString() + @"\" + (context.Request["file"]).Replace("*", "'");
                        var url = "ftp://afm.nbtc.go.th/" + paths[2]+"/"+paths[3] + @"/" + (context.Request["file"]).Replace("*", "'");
                        try
                        {
                            url = url.Replace("\\", "/");
                            //File.Delete(file);
                            DeleteFileAFM(url, paths[1]);
                            cUtils.Log("afm2ftp", "Delete " + url + " -> done");


                        }
                        catch (Exception ex)
                        {
                            cUtils.Log("afm2ftp", "Delete " + url + " -> " + ex.ToString());

                        }
                    }
                    else
                    {
                        string file = ("/" + context.Request["file"]).Replace("*", "'");
                        string url = "ftp://" + dr[0]["FTPAdr"] + "/" + file;
                        DeleteFile(cConvert.ToInt(dr[0]["PoiID"]), url);
                    }

                }

                context.Response.Write("{}");
            }
        }

        private DataRow[] GetStations(int UID, string PoiID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spEquip_Gets]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = UID;

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = cConvert.ToInt(PoiID);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@EquType", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@EquType"].Value = "STN+STN2";

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            return DS.Tables[0].Select("PoiID=" + PoiID);
        }

        private void DeleteFileAFM(string url,string Usr)
        {
            url = url.Replace("*", "'");
            FtpWebRequest request = (FtpWebRequest)WebRequest.Create(new Uri(url));
            request.Credentials = new NetworkCredential(Usr, "nbtc2018");

            request.Method = WebRequestMethods.Ftp.DeleteFile;
            FtpWebResponse response = (FtpWebResponse)request.GetResponse();
            response.Close();
        }
        private void DeleteFile(int PoiID, string url)
        {
            try
            {
                url = ConfigurationManager.AppSettings["FTP_AFM2_URL"] + "/Delete.aspx?url=" + url;


                using (WebClientWithTimeout client = new WebClientWithTimeout())
                {
                    client.DownloadData(url);
                    cUtils.Log("afm2ftp", url + " -> done");

                }
            }
            catch (Exception ex)
            {
                cUtils.Log("afm2ftp", url + " -> " + ex);
            }
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