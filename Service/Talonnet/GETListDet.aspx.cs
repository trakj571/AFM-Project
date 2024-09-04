using EBMSMap30;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AFMProj.Service.Talonnet
{
    public partial class GETListDet : System.Web.UI.Page
    {
        class FileList
        {
            public string Name { get; set; }
            public string Size { get; set; }
            public string Date { get; set; }
            public string Type { get; set; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            var cer = new NetworkCredential("talonnet", "Thailand5*");
           
            Response.ClearContent();
            GetFiles(Request["path"], cer);
            Response.End();
        }
        private void GetFiles(string path, NetworkCredential Credentials)
        {
            List<FileList> files = new List<FileList>();
            try
            {
                ListFtpDirectory(path, Credentials, files, "");
                cUtils.Log("afm2ftp", path + " Done");

            }
            catch (Exception ex)
            {
                cUtils.Log("afm2ftp", path + " " + ex.ToString());
            }

            var json = new JavaScriptSerializer().Serialize(files);
            Response.Write(json);
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
                        modified = DateTime.ParseExact(s, hourMinFormats, culture, DateTimeStyles.None).ToLocalTime();
                    }
                    else
                    {
                        modified = DateTime.ParseExact(s, yearFormats, culture, DateTimeStyles.None).ToLocalTime();
                    }

                    var filelist = new FileList();

                    if (dir == "")
                        filelist.Name = name;
                    else
                        filelist.Name = dir + "/" + name;


                    filelist.Date = string.Format("{0:dd/MM/yyyy HH:mm}", modified);
                    if (size > 1024 * 1024 * 1024)
                        filelist.Size = string.Format("{0:0.0} GB", size / (1024.0 * 1024.0 * 1024.0));
                    else if (size > 1024 * 1024)
                        filelist.Size = string.Format("{0:0.0} MB", size / (1024.0 * 1024.0));
                    else if (size > 1024)
                        filelist.Size = string.Format("{0:0.0} kB", size / (1024.0));
                    else
                        filelist.Size = string.Format("{0:0} B", size);

                    if (name.LastIndexOf(".") > -1)
                        filelist.Type = name.Substring(name.LastIndexOf(".") + 1);

                    files.Add(filelist);
                }
            }

        }

        private string[] GetFiles(string path, NetworkCredential Credentials, SearchOption searchOption)
        {
            try
            {
                var request = (FtpWebRequest)WebRequest.Create(path);
                request.Method = WebRequestMethods.Ftp.ListDirectoryDetails;
                request.Credentials = Credentials;
                List<string> files = new List<string>();
                using (var response = (FtpWebResponse)request.GetResponse())
                {
                    using (var responseStream = response.GetResponseStream())
                    {
                        var reader = new System.IO.StreamReader(responseStream);
                        while (!reader.EndOfStream)
                        {
                            var line = reader.ReadLine();
                            if (string.IsNullOrWhiteSpace(line) == false)
                            {
                                files.Add(line.Substring(line.LastIndexOf(" ") + 1));
                            }
                        }
                    }
                }
                return files.ToArray();
            }
            catch (Exception ex)
            {
                cUtils.Log("afm2ftp", Request["url"] + " " + ex.ToString());
            }
            return new string[0];
        }
    }
}