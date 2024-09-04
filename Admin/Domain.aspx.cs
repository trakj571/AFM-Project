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
    public partial class Domain : System.Web.UI.Page
    {
        public int retID;
        public DataTable tbDL;
        List<MInput> mInputs = new List<MInput>();
        protected void Page_Load(object sender, EventArgs e)
        {
            cUsr.CheckAuth("A");

            mInputs.Add(new MInput() { HtmlInput = Name, DBType = MInput.DataType.String }); 
            mInputs.Add(new MInput() { HtmlInput = Detail, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Key, DBType = MInput.DataType.String });
            //mInputs.Add(new MInput() { HtmlInput = CustKey, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsActive, DBType = MInput.DataType.Check });
            //mInputs.Add(new MInput() { HtmlInput = LyIDs, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsCRM, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsRep, DBType = MInput.DataType.String });

            if (!Page.IsPostBack)
            {
                if (Request.QueryString["DmID"] != null)
                {
                    DataSet DS = MData.GetDataAdm("spUR_GetDomain", "DmID", Request.QueryString["DmID"], mInputs);
                    tbDL = DS.Tables[0];
                    var tbLy = DS.Tables[1];
                    LyIDs.Value = "";
                    for (int i = 0; i < tbLy.Rows.Count; i++)
                    {
                        if (i > 0) LyIDs.Value += ",";
                        LyIDs.Value += tbLy.Rows[i]["LyID"].ToString();

                    }
                }
            }
        }


        
    }
}