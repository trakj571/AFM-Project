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

namespace AFMProj.PlugIn
{
    /// <summary>
    /// Summary description for Download
    /// </summary>
    public class Download : IHttpHandler
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



        public void ProcessRequest(HttpContext context)
        {
            var id = cUsr.GetIdentity(context.Request["token"]);
            id.IsVerify = true;
            if (id.IsVerify)
            {
                var dr = GetStations(id.UID, context.Request["PoiID"]);
                if (dr.Length > 0)
                {
                    if (dr[0]["EquType"].ToString() == "STN")
                    {
                        string file =  ConfigurationManager.AppSettings["FTPAFM1Dir"] +@"\"+ dr[0]["FTPPath"].ToString()+@"\" + (context.Request["file"]).Replace("*", "'");
                        context.Response.ClearContent();
                        context.Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", (context.Request["file"]).Replace("*", "'")));
                        context.Response.WriteFile(file);
                        context.Response.Cookies["fileDownload_" + context.Request["PoiID"] + "_" + context.Request["i"]].Value = "true";
                    }
                    else
                    {

                        string file = ("/" + context.Request["file"]).Replace("*", "'");
                        string url = "ftp://" + dr[0]["FTPAdr"] + file;
                        string filename = file.Substring(file.LastIndexOf("/") + 1);

                        context.Response.ClearContent();
                        context.Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", filename));
                        try
                        {
                            using (WebClientWithTimeout client = new WebClientWithTimeout())
                            {
                                //var data = client.DownloadData("http://talonnet.co.th/afm/service/talonnet/download.aspx?url="+url+"&tmpkey="+context.Request["tmpkey"]);
                                var data = client.DownloadData(ConfigurationManager.AppSettings["FTP_AFM2_URL"] + "/download.aspx?url=" + url + "&tmpkey=" + context.Request["tmpkey"]);
                                context.Response.BinaryWrite(data);
                                context.Response.Cookies["fileDownload_" + context.Request["PoiID"] + "_" + context.Request["i"]].Value = "true";
                            }
                        }
                        catch (Exception)
                        {

                        }
                    }
                }
            }

           
        }

        private DataRow[] GetStations(int UID, string PoiID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spEquip_Gets]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = UID;

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@EquType", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@EquType"].Value = "STN+STN2";

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = cConvert.ToInt(PoiID);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            return DS.Tables[0].Select("PoiID=" + PoiID);
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