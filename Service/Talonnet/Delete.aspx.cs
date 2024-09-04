using EBMSMap30;
using Microsoft.SqlServer.Server;
using NPOI.OpenXmlFormats.Dml.Chart;
using Org.BouncyCastle.Bcpg.OpenPgp;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AFMProj.Service.Talonnet
{
 
    public partial class Delete : System.Web.UI.Page
    {

        class FileList
        {
            public string Name { get; set; }
            public long Size { get; set; }
        }


        protected void Page_Load(object sender, EventArgs e)
        {
           
            Response.ClearContent();
            try
            {
                DeleteFile(Request["url"]);
                Response.Write("Deleted");
                cUtils.Log("afm2ftp", Request["url"] + " Done.");
            }
            catch (Exception ex)
            {
                Response.Write("Error");
                cUtils.Log("afm2ftp", Request["url"] + " " + ex.ToString());
            }

            
            Response.End();
        }

        private void DeleteFile(string url)
        {
            url = url.Replace("*", "'");
            FtpWebRequest request = (FtpWebRequest)WebRequest.Create(new Uri(url));
            request.Credentials = new NetworkCredential("talonnet", "Thailand5*");

            request.Method = WebRequestMethods.Ftp.DeleteFile;
            FtpWebResponse response = (FtpWebResponse)request.GetResponse();
            response.Close();
        }

    }
}