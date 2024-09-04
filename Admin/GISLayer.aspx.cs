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

namespace EBMSMap.Web.Admin
{
    public partial class GISLayer : System.Web.UI.Page
    {
        public int retID;
        public String DSymbol = "";
        List<MInput> mInputs = new List<MInput>();
        protected void Page_Load(object sender, EventArgs e)
        {
            cUsr.CheckAuth("A");
            mInputs.Add(new MInput() { HtmlInput = Name, DBType = MInput.DataType.String }); 
            mInputs.Add(new MInput() { HtmlInput = Detail, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Source, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsActive, DBType = MInput.DataType.Check });
           
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["LyID"] != null)
                {
                    DataSet DS = MData.GetDataAdm("spLyrGIS_Get", "LyID", Request.QueryString["LyID"], mInputs);

                    DataTable tbD = DS.Tables[0];

                    DSymbol = @"Files/GISLayer/" + Comm.GetFilesPath(tbD.Rows[0]["LyID"], "png").Replace("\\", "/");

                    if (File.Exists(Server.MapPath("../") + DSymbol))
                        DSymbol = "../" + DSymbol + "?r=" + Comm.RandPwd(6);
                    else
                        DSymbol = "../Files/GISLayer/default.png";

                }
            }
        }


        
    }
}