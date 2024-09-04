using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using EBMSMap30;
using System.Net;
using System.Security.Cryptography.X509Certificates;

namespace AFMProj.FMS.data
{
    /// <summary>
    /// Summary description for dScanBegin
    /// </summary>
    public class dInfo : IHttpHandler
    {
        private static bool ValidateRemoteCertificate(object sender, X509Certificate certificate, X509Chain chain, System.Net.Security.SslPolicyErrors policyErrors)
        {
            return true;
        }
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            DataTable tbE = GetEqu();
            for (int i = 0; i < tbE.Rows.Count; i++)
            {
                if (tbE.Rows[i]["PoiID"].ToString() != context.Request["PoiID"]) continue;
                ExecDB(context, tbE.Rows[i]["UUID"].ToString());
            }

            
            context.Response.End();
        }
        private DataTable GetEqu()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spEquip_Get", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            return DS.Tables[1];
        }

        private void ExecDB(HttpContext context,string UUID)
        {
            ServicePointManager.ServerCertificateValidationCallback += new System.Net.Security.RemoteCertificateValidationCallback(ValidateRemoteCertificate);

            using (var w = new WebClient())
            {
                var json_data = string.Empty;
                string url = "https://lmtr.nbtc.go.th/afm/1.01/" + UUID + "/service/info.php";
                
                // attempt to download JSON data as a string
                try
                {
                    json_data = w.DownloadString(url);
                    context.Response.Write(json_data);
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.ToString());
                }
                // if string with JSON data is not empty, deserialize it to clas
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