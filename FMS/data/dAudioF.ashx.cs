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
    public class dAudioF : IHttpHandler
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
                ExecDB(context);
                if (context.Request["RadMode"] != null)
                {
                    ExecStn(context, tbE.Rows[i]["UUID"].ToString(), "Mode", context.Request["RadMode"]);
                    ExecStn(context, tbE.Rows[i]["UUID"].ToString(), "DDC1", context.Request["DDC1"]);
                    ExecStn(context, tbE.Rows[i]["UUID"].ToString(), "DDC2", context.Request["DDC2"]);
                    ExecStn(context, tbE.Rows[i]["UUID"].ToString(), "DemFilterBandwidth", context.Request["DFBw"]);
                }
                ExecStn(context, tbE.Rows[i]["UUID"].ToString(), "Frequency", context.Request["Freq"]);

                context.Response.Write("{\"result\":\"OK\"}");
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

        private void ExecDB(HttpContext context)
        {
            int nSec = cConvert.ToInt(context.Request["nHr"]) * 3600 + cConvert.ToInt(context.Request["nMin"]) * 60 + cConvert.ToInt(context.Request["nSec"]);
           
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spScan_Mann", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = context.Request["PoiID"];

            SqlCmd.SelectCommand.Parameters.Add("@Freq", SqlDbType.BigInt);
            SqlCmd.SelectCommand.Parameters["@Freq"].Value = context.Request["Freq"];

            SqlCmd.SelectCommand.Parameters.Add("@nSec", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@nSec"].Value = nSec;

          
            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            
            //context.Response.Write("{\"result\":\"OK\"}");

        }

        private void ExecStn(HttpContext context,string UUID,string Name,string Value)
        {
            ServicePointManager.ServerCertificateValidationCallback += new System.Net.Security.RemoteCertificateValidationCallback(ValidateRemoteCertificate);

            using (var w = new WebClient())
            {
                var json_data = string.Empty;
                string url = "https://lmtr.nbtc.go.th/afm/1.01/" + UUID + "/service/set.php";
                string parms = "name="+Name+"&value=" + Value;
               
                // attempt to download JSON data as a string
                try
                {
                    w.Headers[HttpRequestHeader.ContentType] = "application/x-www-form-urlencoded";
                    json_data = w.UploadString(url, parms);
                    cUtils.Log("audio", url + " " + parms+" -> "+json_data);
                }
                catch (Exception ex)
                {
                    cUtils.Log("audio", url + " " + parms + " -> " + ex);
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