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
    public partial class CGrp : System.Web.UI.Page
    {
        public int retID;
        List<MInput> mInputs = new List<MInput>();
        protected void Page_Load(object sender, EventArgs e)
        {
            cUsr.CheckAuth("A");
            mInputs.Add(new MInput() { HtmlInput = Name, DBType = MInput.DataType.String }); 
            mInputs.Add(new MInput() { HtmlInput = Detail, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsActive, DBType = MInput.DataType.Check });
           
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["CGID"] != null)
                {
                    DataSet DS = MData.GetDataAdm("spCon_GetGrp", "CGID", Request.QueryString["CGID"], mInputs);
                    UGID.Value = JSData.Join(DS.Tables[1], "UGID");
                    OrgID.Value = JSData.Join(DS.Tables[2], "OrgID");     
                }
            }
        }


        
    }
}