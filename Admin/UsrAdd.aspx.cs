using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using EBMSMap30;
using System.IO;
using System.Drawing;
using System.Net;
using System.Security.Cryptography.X509Certificates;

namespace EBMSMap.Web.Admin
{
    public partial class UsrAdd : System.Web.UI.Page
    {
        public int retID;
        List<MInput> mInputs = new List<MInput>();
        public String DSign = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            cUsr.CheckAuth("A");
            mInputs.Add(new MInput() { HtmlInput = UType, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Login, DBType = MInput.DataType.String });

            mInputs.Add(new MInput() { HtmlInput = FName, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = LName, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Rank, DBType = MInput.DataType.String });

            mInputs.Add(new MInput() { HtmlInput = TelNo, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Email, DBType = MInput.DataType.String });

            mInputs.Add(new MInput() { HtmlInput = OrgID, DBType = MInput.DataType.Int });
            mInputs.Add(new MInput() { HtmlInput = UGID, DBType = MInput.DataType.Int });

            mInputs.Add(new MInput() { HtmlInput = IsActive, DBType = MInput.DataType.Check });

            mInputs.Add(new MInput() { HtmlInput = IsAuthChk, DBType = MInput.DataType.Check });
            mInputs.Add(new MInput() { HtmlInput = IsAuthApv, DBType = MInput.DataType.Check });
            mInputs.Add(new MInput() { HtmlInput = IsAuthAct, DBType = MInput.DataType.Check });
            mInputs.Add(new MInput() { HtmlInput = IsAuthDir, DBType = MInput.DataType.Check });
            mInputs.Add(new MInput() { HtmlInput = IsEQMain, DBType = MInput.DataType.Check });

            if (!Page.IsPostBack)
            {
                if (Request.QueryString["UID"] != null)
                {
                    DataSet DS = MData.GetDataAdm("spUR_Get", "UID", Request.QueryString["UID"], mInputs);
                    DataTable tbD = DS.Tables[0];
                    DSign = MData.UsrSign(tbD.Rows[0]["UID"]);
                }
            }
        }

        public static bool ValidateRemoteCertificate(object sender, X509Certificate certificate, X509Chain chain, System.Net.Security.SslPolicyErrors policyErrors)
        {
            return true;
        }
        protected void bSave_ServerClick(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spUR_Add", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = Request.QueryString["uid"];

            MData.AddSqlCmd(SqlCmd, mInputs);

            cRc4 _rc4 = new cRc4();
            if (Request.Form["Pwd"] != "")
            {
                SqlCmd.SelectCommand.Parameters.Add("@Pwd", SqlDbType.NVarChar, 40);
                SqlCmd.SelectCommand.Parameters["@Pwd"].Value = _rc4.EnDeCrypt(Request.Form["Pwd"], Request.Form["Pwd"]); ;
            }

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            retID = Convert.ToInt32(DS.Tables[0].Rows[0]["retID"]);

            if (File1.PostedFile.ContentLength > 0)
            {
                try
                {
                    string fileExt = "png";
                    string fileid = string.Format("{0:000000000}", retID);

                    FileInfo fi = new FileInfo(HttpContext.Current.Server.MapPath("../Files") + @"\Usr\Sign\" + fileid.Substring(0, 3) + @"\" + fileid.Substring(3, 3) + @"\" + fileid.Substring(6, 3) + "." + fileExt);


                    if (!fi.Directory.Exists)
                        fi.Directory.Create();

                    Bitmap bm = new Bitmap(File1.PostedFile.InputStream);
                    bm.Save(fi.FullName, System.Drawing.Imaging.ImageFormat.Png);
                    bm.Dispose();

                    if (ConfigurationManager.AppSettings["ISO_Files_UPL"] == "")
                        return;

                    var url = ConfigurationManager.AppSettings["ISO_Files_UPL"] + @"?file=Usr\Sign\" + fileid.Substring(0, 3) + @"\" + fileid.Substring(3, 3) + @"\" + fileid.Substring(6, 3) + "." + fileExt;
                    ServicePointManager.ServerCertificateValidationCallback += new System.Net.Security.RemoteCertificateValidationCallback(ValidateRemoteCertificate);

                    using (WebClient wc = new WebClient())
                    {
                        try
                        {
                            var data = wc.UploadFile(url, fi.FullName);
                            cUtils.Log("upload", fi.FullName + " -> OK");
                        }

                        catch (Exception ex)
                        {
                            cUtils.Log("upload", fi.FullName + " -> " + ex.Message);
                        }
                    }
                }
                catch (Exception ex)
                {
                }

            }
        }
    }
}