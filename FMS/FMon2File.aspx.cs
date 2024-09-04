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
using System.Text;
using System.Collections.Specialized;
using System.Web.Script.Serialization;
using System.Linq;

namespace AFMProj.FMS
{
    public class FileList
    {
        public string Name { get; set; }
        public string Size { get; set; }
        public string Date { get; set; }
        public string Type { get; set; }
    }
    public partial class FMon2File : System.Web.UI.Page
    {
        public Object[] files;
        public string IPAdr = "",TmpKey="";
        public string FTPPath,Sort = "-Date";
        public int cPage = 1, pgSize = 20, nTotal;

        protected void Page_Load(object sender, EventArgs e)
        {
            TmpKey = Comm.RandPwd(10) + string.Format("-{0:yyMMddHHmmss}", DateTime.Now);
            var uIdentity = EBMSMap30.cUsr.GetIdentity(EBMSMap30.cUsr.Token);
            if (!uIdentity.IsVerify)
            {
                Response.Redirect("../UR/Logout.aspx");
            }
            if (uIdentity.Permission["IsFMSFMon"].ToString() != "Y")
            {
                if (uIdentity.Permission["IsFMSViewOnly"].ToString() == "Y" || uIdentity.Permission["IsFMSEdit"].ToString() == "Y")
                {
                    Response.Redirect("AnChk.aspx");
                }
                else
                {
                    Response.Redirect("../DashB");
                }
            }

            cPage = cConvert.ToInt(Request["Page"]);
            if (cPage == 0) cPage = 1;

            if(Request["Sort"]!=null)
                Sort = Request["Sort"];
        
            var dr = GetStations(uIdentity.UID, Request["PoiID"]);
            if (dr.Length > 0)
            {
                if (dr[0]["EquType"].ToString() == "STN")
                {
                    FTPPath = dr[0]["FTPPath"].ToString().Replace("\\","/");
                    var files1 = GetAFM1File(dr[0]["FTPPath"].ToString());
                    var json = new JavaScriptSerializer().Serialize(files1);
                    JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
                    files = (Object[])jsSerializer.DeserializeObject(json);
                }
                else
                {

                    var cer = new NetworkCredential("talonnet", "Thailand5*");

                    try
                    {
                        IPAdr = dr[0]["FTPAdr"].ToString();
                        using (WebClient client = new WebClient())
                        {
                            var data = new NameValueCollection();
                            data["path"] = "ftp://" + IPAdr;

                            var response = client.UploadValues(ConfigurationManager.AppSettings["FTP_AFM2_URL"] + "/GETListDet.aspx", "POST", data);

                            var file = Encoding.UTF8.GetString(response);
                            JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
                            files = (Object[])jsSerializer.DeserializeObject(file);
                        }

                    }
                    catch (Exception ex)
                    {

                    }
                }
                files = SortSetUp(files);
                files = PageSetUp(files);
            }
        }

        private Object[] SortSetUp(Object[] m_files)
        {
            var files1 = new List<FileList>();
            for (int i = 0; i < m_files.Length; i++)
            {
                var file = (Dictionary<string, object>)m_files[i];
                var filec = new FileList()
                {
                    Name = file["Name"].ToString(),
                    Size = file["Size"].ToString(),
                    Type=file["Type"].ToString(),
                    Date = file["Date"].ToString()

                };
                files1.Add(filec);
            }
            List<FileList> SortedList;
            
            if(Sort=="Date")
                SortedList = files1.OrderBy(o => cConvert.ConvertToDateTH(o.Date)).ToList();
            else if (Sort == "-Date")
                SortedList = files1.OrderByDescending(o => cConvert.ConvertToDateTH(o.Date)).ToList();
            else if(Sort == "Name")
                SortedList = files1.OrderBy(o => o.Name).ToList();
            else if (Sort == "-Name")
                SortedList = files1.OrderByDescending(o => o.Name).ToList();
            else if (Sort == "Type")
                SortedList = files1.OrderBy(o => o.Type).ToList();
            else if(Sort == "-Type")
                SortedList = files1.OrderByDescending(o => o.Type).ToList();
            else if (Sort == "Size")
                SortedList = files1.OrderBy(o => o.Size.Substring(o.Size.Length - 2) + string.Format("{0:00000000.000}", cConvert.ToDouble(o.Size.Replace("kB", "").Replace("MB", "").Replace("B", "").Trim()))).ToList();
            else if (Sort == "-Size")
                SortedList = files1.OrderByDescending(o => o.Size.Substring(o.Size.Length - 2) + string.Format("{0:00000000.000}",cConvert.ToDouble(o.Size.Replace("kB","").Replace("MB", "").Replace("B", "").Trim()))).ToList();
            else if (Sort == "-Name")
                SortedList = files1.OrderByDescending(o => o.Name).ToList();
            else
                SortedList = files1.OrderBy(o => o.Name).ToList();

            var json = new JavaScriptSerializer().Serialize(SortedList);
            JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
            return (Object[])jsSerializer.DeserializeObject(json);
        }


        private Object[] PageSetUp(Object[] m_files)
        {
            nTotal = m_files.Length;
            var files1 = new List<Object>();
            for (int i = 0; i < m_files.Length; i++)
            {
                var file = (Dictionary<string, object>)m_files[i];
                if (i >= (cPage - 1) * pgSize && i < cPage * pgSize)
                    files1.Add(file);
            }

            var json = new JavaScriptSerializer().Serialize(files1);
            JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
            return (Object[])jsSerializer.DeserializeObject(json);
        }

        protected string GetPageUrl(int page)
        {
            var nameValues = HttpUtility.ParseQueryString(Request.QueryString.ToString());
            //nameValues.Set("page", page.ToString());
            nameValues.Set("page", page.ToString());
            nameValues.Remove("del");
            string pageUrl = Request.Url.AbsolutePath;
            pageUrl = pageUrl + "?" + nameValues.ToString();

            return pageUrl;
        }

        protected string ThSort(string sort)
        {
            string csort = Sort;
            if (csort == sort)
            {
                return "class='sortlink sortup'";
            }
            else if (csort == "-" + sort)
            {
                return "class='sortlink sortdown'";
            }
            return "class='sortlink'";
        }

        protected string SchSort(string sort)
        {
            var nameValues = HttpUtility.ParseQueryString(Request.QueryString.ToString());
            nameValues.Set("page", "1");

            string csort = Sort;
            if (csort == sort)
            {
                nameValues.Set("sort", "-" + sort);
            }
            else
            {
                nameValues.Set("sort", sort);
            }

            string pageUrl = Request.Url.AbsolutePath;
            pageUrl = pageUrl + "?" + nameValues.ToString();

            return pageUrl;


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

        List<FileList> GetAFM1File(string Path) 
        {
            List<FileList> files = new List<FileList>();
            var di = new DirectoryInfo(ConfigurationManager.AppSettings["FTPAFM1Dir"] + @"\" + Path);
            if (!di.Exists)
                di.Create();

            foreach (FileInfo fi in di.GetFiles()) {
                var filelist = new FileList();
                
                filelist.Name = fi.Name;


                filelist.Date = string.Format("{0:dd/MM/yyyy HH:mm}", fi.LastWriteTime);
                var size = fi.Length;
                if (size > 1024 * 1024 * 1024)
                    filelist.Size = string.Format("{0:0.0} GB", size / (1024.0 * 1024.0 * 1024.0));
                else if (size > 1024 * 1024)
                    filelist.Size = string.Format("{0:0.0} MB", size / (1024.0 * 1024.0));
                else if (size > 1024)
                    filelist.Size = string.Format("{0:0.0} kB", size / (1024.0));
                else
                    filelist.Size = string.Format("{0:0} B", size);

                filelist.Type = fi.Extension.Replace(".","");

                files.Add(filelist);
            }

            return files;
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