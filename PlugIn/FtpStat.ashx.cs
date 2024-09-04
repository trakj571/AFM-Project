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
    public class FtpStat : IHttpHandler
    {
       
        public void ProcessRequest(HttpContext context)
        {
            context.Response.Write("{\"i\":\""+context.Request["i"]+"\",\"pc\":\"" + GetStatus(context.Request["cname"].Replace("$", "'")) + "\"}");
           
        }

        private string GetStatus(string cname)
        {
            string pc = "";
            try
            {
                //string url = "http://talonnet.co.th/AFM/Service/Talonnet/GetStat.aspx?cname=" + cname;
                string url = ConfigurationManager.AppSettings["FTP_AFM2_URL"] + "/GetStat.aspx?cname=" + cname;


                using (WebClient client = new WebClient())
                {
                    pc = client.DownloadString(url);
                }

            }
            catch (Exception ex)
            {
                pc = "Error";
            }
            return pc;
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