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

namespace AFMProj.FMS
{
    public partial class HDet : System.Web.UI.Page
    {
        public string PATCode = "000000";
        public int retID = 0;
        List<MInput> mInputs = new List<MInput>();

        protected void Page_Load(object sender, EventArgs e)
        {
           

            mInputs.Add(new MInput() { HtmlInput = Name, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = TelNo, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = TaxID, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = AdrNo, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Road, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = PostCode, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Province, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Amphoe, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Tambol, DBType = MInput.DataType.String });


            if (!Page.IsPostBack)
            {
                if (Request.QueryString["hid"] != null)
                {
                   DataSet DS = MDataDC.GetData("fms.spHostGet", "hid", Request.QueryString["hid"], mInputs);
                    PATCode = DS.Tables[0].Rows[0]["PatCode"].ToString();
                    if (PATCode.Length < 6)
                        PATCode = PATCode.PadRight(6).Replace(" ", "0");

                    if (Request["export"] != null)
                    {
                        List<string> columns = new List<string>();
                        columns.Add("Name:ชื่อหน่วยงาน");
                        columns.Add("AdrNo:เลขที่");
                        columns.Add("Road:ถนน");
                        columns.Add("Tambol:ตำบล");
                        columns.Add("Amphoe:อำเภอ");
                        columns.Add("Province:จังหวัด");
                        columns.Add("PostCode:รหัสไปรษณีย์");
                        columns.Add("TelNo:เบอร์ติดต่อ");
                      
                        Export.ToFile(DS.Tables[0], columns, "", "");
                    }

                }
                else
                {
                    Response.Redirect("HSch.aspx");

                }
            }



        }

        
    }
}