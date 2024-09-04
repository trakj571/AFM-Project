using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AFMProj.Service.Talonnet
{
    public partial class GETList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var cer = new NetworkCredential("talonnet", "Thailand5*");
            var files = GetFiles(Request["path"],cer);

            Response.ClearContent();
            for (int i = 0; i < files.Length; i++) {
                if (i > 0) Response.Write(",");
                Response.Write(files[i]);
            }
            Response.End();
        }
        private string[] GetFiles(string path, NetworkCredential Credentials)
        {
            try
            {
                List<string> files = new List<string>();
                ListFtpDirectory(path, Credentials, files, "");
                return files.ToArray();
            }
            catch (Exception ex)
            {

            }
            return new string[0];
        }
        void ListFtpDirectory(string url, NetworkCredential credentials, List<string> files,string dir)
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

            foreach (string line in lines)
            {
                string[] tokens =
                    line.Split(new[] { ' ' }, 9, StringSplitOptions.RemoveEmptyEntries);
                string name = tokens[8];
                string permissions = tokens[0];

                if (permissions[0] == 'd')
                {
                  
                    string fileUrl = url +"/"+ name;
                    ListFtpDirectory(fileUrl + "/", credentials,files,name);
                }
                else
                {
                    if(dir=="")
                        files.Add(name);
                    else
                        files.Add(dir+"/"+name);
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
                
            }
            return new string[0];
        }
    }
}