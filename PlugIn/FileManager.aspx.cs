using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using EBMSMap30;
using System.Net;
using System.Text.RegularExpressions;

namespace AFMProj.PlugIn
{
    public class FileList
    {
        public string Name { get; set; }
        public string Size { get; set; }
        public string Date { get; set; }
        public string Type { get; set; }
    }
    public partial class FileManager : System.Web.UI.Page
    {
        public List<FileList> files = new List<FileList>();
        public string IPAdr = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            var id = cUsr.GetIdentity(Request["token"]);
            id.IsVerify = true;
            if (id.IsVerify)
            {
                var dr = GetStations(id.UID, Request["PoiID"]);
                if (dr.Length > 0)
                {
                    var cer = new NetworkCredential("talonnet", "Thailand5*");

                    try
                    {
                        IPAdr = dr[0]["FTPAdr"].ToString();
                        ListFtpDirectory("ftp://" + dr[0]["FTPAdr"], cer, files, "");

                    }
                    catch (Exception ex)
                    {

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

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            return DS.Tables[0].Select("PoiID=" + PoiID);
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

    }
}