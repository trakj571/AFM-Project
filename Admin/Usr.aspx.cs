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
using Org.BouncyCastle.Asn1.Ocsp;

namespace EBMSMap.Web.Admin
{
    public partial class Usr : System.Web.UI.Page
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

                if (Request.QueryString["export"] == "xls")
                {
                    DataSet DS = MData.GetDataAdm("spUR_Get", "UID","0", new List<MInput>());
                    string kw = Request.QueryString["kw"];
                    var tbD = DS.Tables[0].Select("Login+'('+FName+' '+LName+')' like '%"+kw+"%'").CopyToDataTable();
                    List<string> columns = new List<string>();
                    columns.Add("Login:ชื่อผู้ใช้งาน");
                    columns.Add("FName:ชือ");
                    columns.Add("LName:นามสกุล");
                    columns.Add("Rank:ตำแหน่ง");
                    columns.Add("TelNo:หมายเลขโทรศัพท์");
                    columns.Add("Email:อีเมล");
                    columns.Add("OrgName:หน่วยงาน");
                    columns.Add("UGName:กลุ่มผู้ใช้งาน");
            
                    Export.ToFile(tbD, columns, "", "");
                }
            }
        }


    }
}