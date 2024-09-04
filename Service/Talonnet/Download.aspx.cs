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
    public class WebClientWithTimeout : WebClient
    {
        protected override WebRequest GetWebRequest(Uri address)
        {
            WebRequest wr = base.GetWebRequest(address);
            wr.Timeout = 180 * 60 * 1000; // timeout in milliseconds (ms)
            return wr;
        }
    }

    public partial class Download : System.Web.UI.Page
    {

        class FileList
        {
            public string Name { get; set; }
            public long Size { get; set; }
        }


        protected void Page_Load(object sender, EventArgs e)
        {
           
            Response.ClearContent();
            var cer = new NetworkCredential("talonnet", "Thailand5*");
            List<FileList> files = new List<FileList>();
            try
            {
                string url = Request["url"];
                ListFtpDirectory(url.Substring(0, url.IndexOf("/",7)), cer, files, "");
                for( int i = 0; i < files.Count; i++)
                {
                    string fname = url.Substring(url.IndexOf("/", 7)+1);
                    if (fname==files[i].Name)
                        DownloadFilePc(Request["url"], files[i].Size,Request["tmpkey"], files[i].Name);
                }
                
            }
            catch (Exception ex)
            {

            }

            
            Response.End();
        }

        private void DownloadFilePc(string url,long fileSize,string tmpkey,string filename) {
           var cer = new NetworkCredential("talonnet", "Thailand5*");
            FtpWebRequest request = (FtpWebRequest)WebRequest.Create(url);
            request.Credentials = cer;
            request = (FtpWebRequest)WebRequest.Create(url);
            request.Credentials = cer;
            request.Timeout = 180 * 60 * 1000;
            request.Method = WebRequestMethods.Ftp.DownloadFile;
            using (FtpWebResponse responseFileDownload = (FtpWebResponse)request.GetResponse())
            using (Stream responseStream = responseFileDownload.GetResponseStream())
            using (MemoryStream ms = new MemoryStream())
            {

                int Length = 2048;
                Byte[] buffer = new Byte[Length];
                int bytesRead = responseStream.Read(buffer, 0, Length);
                int bytes = 0;

                while (bytesRead > 0)
                {
                    ms.Write(buffer, 0, bytesRead);
                    bytesRead = responseStream.Read(buffer, 0, Length);
                    bytes += bytesRead;// don't forget to increment bytesRead !
                    int totalSize = (int)(fileSize) / 1000; // Kbytes
                    string pc = (bytes / 1000) * 100 / totalSize+"";
                    //cUtils.Log("download", url + " " + pc);
                    Cache.Insert(tmpkey+"_"+ filename, pc, null, DateTime.Now.AddHours(1), TimeSpan.Zero);
                }
               
                Response.BinaryWrite(ms.ToArray());
                Cache.Remove(tmpkey + "_" + filename);
            }
        }
        private void DownloadFile(string url)
        {
            try
            {
                url = url.Replace("$", "'");
                using (WebClientWithTimeout client = new WebClientWithTimeout())
                {
                    var cer = new NetworkCredential("talonnet", "Thailand5*");
                    client.Credentials = cer;
                    var data = client.DownloadData(url);
                    string filename = url.Substring(url.LastIndexOf("/") + 1);

                    Response.ClearContent();
                    Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", filename));

                    Response.BinaryWrite(data);
                }
            }
            catch (Exception)
            {
            
            }
        }

        void ListFtpDirectory(string url, NetworkCredential credentials, List<FileList> files, string dir)
        {

            WebRequest listRequest = WebRequest.Create(url);
            listRequest.Method = WebRequestMethods.Ftp.ListDirectoryDetails;
            listRequest.Credentials = credentials;
            listRequest.Timeout = 5000;

            List<string> lines = new List<string>();

            using (WebResponse listResponse = listRequest.GetResponse())
            using (Stream listStream = listResponse.GetResponseStream())
            using (StreamReader listReader = new StreamReader(listStream))
            {
                while (!listReader.EndOfStream)
                {
                    string line = listReader.ReadLine();
                    lines.Add(line);
                }
            }

            string pattern =
                    @"^([\w-]+)\s+(\d+)\s+(\w+)\s+(\w+)\s+(\d+)\s+" +
                    @"(\w+\s+\d+\s+\d+|\w+\s+\d+\s+\d+:\d+)\s+(.+)$";
            Regex regex = new Regex(pattern);
            IFormatProvider culture = CultureInfo.GetCultureInfo("en-us");
            string[] hourMinFormats =
                new[] { "MMM dd HH:mm", "MMM dd H:mm", "MMM d HH:mm", "MMM d H:mm" };
            string[] yearFormats =
                new[] { "MMM dd yyyy", "MMM d yyyy" };


            foreach (string line in lines)
            {
                string[] tokens =
                    line.Split(new[] { ' ' }, 9, StringSplitOptions.RemoveEmptyEntries);
                string name = tokens[8];
                string permissions = tokens[0];

                if (permissions[0] == 'd')
                {

                    string fileUrl = url + "/" + name;
                    ListFtpDirectory(fileUrl + "/", credentials, files, name);
                }
                else
                {
                    Match match = regex.Match(line);
                    string permission = match.Groups[1].Value;
                    int inode = int.Parse(match.Groups[2].Value, culture);
                    string owner = match.Groups[3].Value;
                    string group = match.Groups[4].Value;
                    long size = long.Parse(match.Groups[5].Value, culture);
                    DateTime modified;
                    string s = Regex.Replace(match.Groups[6].Value, @"\s+", " ");
                    if (s.IndexOf(':') >= 0)
                    {
                        modified = DateTime.ParseExact(s, hourMinFormats, culture, DateTimeStyles.None);
                    }
                    else
                    {
                        modified = DateTime.ParseExact(s, yearFormats, culture, DateTimeStyles.None);
                    }

                    var filelist = new FileList();

                    if (dir == "")
                        filelist.Name = name;
                    else
                        filelist.Name = dir + "/" + name;

                    filelist.Size = size;

                    files.Add(filelist);
                }
            }

        }
    }
}