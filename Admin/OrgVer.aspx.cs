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

namespace EBMSMap.Web.Admin
{
    public partial class OrgVer : System.Web.UI.Page
    {
        public int retID;
        public DataTable tbU;
        List<MInput> mInputs = new List<MInput>();
        protected void Page_Load(object sender, EventArgs e)
        {
            cUsr.CheckAuth("A");
            mInputs.Add(new MInput() { HtmlInput = Name, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Ver, DBType = MInput.DataType.String });
           
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["VerID"] != null)
                {
                    DataSet DS = MData.GetDataAdm("spOrgVer_Get", "VerID", Request.QueryString["VerID"], mInputs);
                }
            }
        }



    }
}