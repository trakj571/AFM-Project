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

namespace EBMSMap.Web.Admin
{
    public partial class CTypeAdd : System.Web.UI.Page
    {
        public int retID;
        public String DSymbol = "";
        public DataTable tbC;
        List<MInput> mInputs = new List<MInput>();
        public bool IsFreq = false;
       
        protected void Page_Load(object sender, EventArgs e)
        {
            cUsr.CheckAuth("A");
            mInputs.Add(new MInput() { HtmlInput = Name, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Detail, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsActive, DBType = MInput.DataType.Check });
            mInputs.Add(new MInput() { HtmlInput = PoiType, DBType = MInput.DataType.Int });
            mInputs.Add(new MInput() { HtmlInput = pCGID, DBType = MInput.DataType.Int });

            mInputs.Add(new MInput() { HtmlInput = CHSpace, DBType = MInput.DataType.Int });
            mInputs.Add(new MInput() { HtmlInput = RadioProp, DBType = MInput.DataType.Int });

            if (!Page.IsPostBack)
            {
                if (Request.QueryString["TypeID"] != null)
                {
                    DataSet DS = MData.GetDataAdm("spCon_GetType", "TypeID", Request.QueryString["TypeID"], mInputs);
                    DataTable tbD = DS.Tables[0];
                    tbC = DS.Tables[1];

                    if (cConvert.ToInt(tbD.Rows[0]["pCGID"]) == CType.pCGID_F)
                        IsFreq = true;

                    //UGID.Value = JSData.Join(DS.Tables[1], "UGID");
                    //OrgID.Value = JSData.Join(DS.Tables[2], "OrgID");   



                    DSymbol = @"Files/Symbol/" + Comm.GetFilesPath(tbD.Rows[0]["typeid"], "png").Replace("\\", "/");

                    if (File.Exists(Server.MapPath("../") + DSymbol))
                        DSymbol = "../" + DSymbol + "?r=" + Comm.RandPwd(6);
                    else
                        DSymbol = "../Files/Symbol/blue.png";

                }
            }
        }

        protected void bSave_ServerClick(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spCon_AddType", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@TypeID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@TypeID"].Value = Request.QueryString["TypeID"];



            MData.AddSqlCmd(SqlCmd, mInputs);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            retID = Convert.ToInt32(DS.Tables[0].Rows[0]["retID"]);


            if (Symbol.PostedFile.ContentLength > 0)
            {
                try
                {
                    string r = Comm.RandPwd(6) + "-" + Comm.RandPwd(4);
                    string path = "Files\\Symbol\\" + Comm.GetFilesPath(retID, "png");
                    FileInfo fi = new FileInfo(Server.MapPath("../") + "\\" + path);

                    if (!fi.Directory.Exists)
                        fi.Directory.Create();

                    Bitmap bm0 = new Bitmap(Symbol.PostedFile.InputStream);
                    Bitmap bm = new Bitmap(bm0, 32, 32);
                    bm.Save(fi.FullName, System.Drawing.Imaging.ImageFormat.Png);
                    bm.Dispose();
                    bm0.Dispose();
                }
                catch (Exception ex)
                {
                }

            }


        }
    }
}