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
    public partial class CType : System.Web.UI.Page
    {
        public static int pCGID_F = 4;
        public int retID;
        public String DSymbol = "";
        public DataTable tbC;
        List<MInput> mInputs = new List<MInput>();
        protected void Page_Load(object sender, EventArgs e)
        {
            cUsr.CheckAuth("A");
            mInputs.Add(new MInput() { HtmlInput = Name, DBType = MInput.DataType.String }); 
            mInputs.Add(new MInput() { HtmlInput = Detail, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsActive, DBType = MInput.DataType.Check });
            mInputs.Add(new MInput() { HtmlInput = CHSpace, DBType = MInput.DataType.Int });
            mInputs.Add(new MInput() { HtmlInput = RadioProp, DBType = MInput.DataType.Int });

           
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["TypeID"] != null)
                {
                    LoadCType();
                }
            }
        }

        private void LoadCType()
        {
            DataSet DS = MData.GetDataAdm("spCon_GetType", "TypeID", Request.QueryString["TypeID"], mInputs);
            DataTable tbD = DS.Tables[0];
            tbC = DS.Tables[1];

            //UGID.Value = JSData.Join(DS.Tables[1], "UGID");
            //OrgID.Value = JSData.Join(DS.Tables[2], "OrgID");   

            int poitype = cConvert.ToInt(tbD.Rows[0]["poiType"]);
            if (poitype == 1) PoiType.Text = "Point ";
            if (poitype == 2) PoiType.Text = "Line ";
            if (poitype == 3) PoiType.Text = "Polygon ";
            if (poitype == 4) PoiType.Text = "Circle ";

            DSymbol = @"Files/Symbol/" + Comm.GetFilesPath(tbD.Rows[0]["typeid"], "png").Replace("\\", "/");

            if (File.Exists(Server.MapPath("../") + DSymbol))
                DSymbol = "../" + DSymbol + "?r=" + Comm.RandPwd(6);
            else
                DSymbol = "../Files/Symbol/blue.png";

        }
        protected void SaveOrder_ServerClick(object sender, EventArgs e)
        {
            if (ColIDs.Value=="")
                return;
            string[] colIDs =ColIDs.Value.Split(',');
            string[] orders = Orders.Value.Split(',');

            for (int k = 0; k < colIDs.Length; k += 5)
            {
                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
                SqlDataAdapter SqlCmd = new SqlDataAdapter("[spCon_OrderCols]", SqlConn);
                SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

                SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

                SqlCmd.SelectCommand.Parameters.Add("@TypeID", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@TypeID"].Value = Request.QueryString["typeid"];


                for (int i = 0; i < 5 && k + i < colIDs.Length; i++)
                {
                    if (colIDs[k + i].Trim() == "")
                        continue;

                    SqlCmd.SelectCommand.Parameters.Add("@ColID" + (i + 1), SqlDbType.Int);
                    SqlCmd.SelectCommand.Parameters["@ColID" + (i + 1)].Value = colIDs[k + i];

                    SqlCmd.SelectCommand.Parameters.Add("@iOrder" + (i + 1), SqlDbType.SmallInt);
                    SqlCmd.SelectCommand.Parameters["@iOrder" + (i + 1)].Value = orders[k + i];
                }
                DataSet DS = new DataSet();
                SqlCmd.Fill(DS);
                SqlConn.Close();

                retID = 1;
                LoadCType();
            }
        }

        
    }
}