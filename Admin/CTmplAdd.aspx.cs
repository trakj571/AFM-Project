﻿using System;
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
    public partial class CTmplAdd : System.Web.UI.Page
    {
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
           
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["TplID"] != null)
                {
                    DataSet DS = MData.GetDataAdm("spCon_GetTpl", "TplID", Request.QueryString["TplID"], mInputs);
                    DataTable tbD = DS.Tables[0];
                    tbC = DS.Tables[1];

                    //UGID.Value = JSData.Join(DS.Tables[1], "UGID");
                    //OrgID.Value = JSData.Join(DS.Tables[2], "OrgID");   



                  
                }
            }
        }

        protected void bSave_ServerClick(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spCon_AddTpl", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@TplID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@TplID"].Value = Request.QueryString["TplID"];



            MData.AddSqlCmd(SqlCmd, mInputs);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            retID = Convert.ToInt32(DS.Tables[0].Rows[0]["retID"]);


            


        }
    }
}