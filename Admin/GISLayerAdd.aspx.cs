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
    public partial class GISLayerAdd : System.Web.UI.Page
    {
        public int retID;
        List<MInput> mInputs = new List<MInput>();
        public String DSymbol = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            cUsr.CheckAuth("A");
            mInputs.Add(new MInput() { HtmlInput = Name, DBType = MInput.DataType.String }); 
            mInputs.Add(new MInput() { HtmlInput = Detail, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = Source, DBType = MInput.DataType.String });
            mInputs.Add(new MInput() { HtmlInput = IsActive, DBType = MInput.DataType.Check });
            mInputs.Add(new MInput() { HtmlInput = pLyID, DBType = MInput.DataType.Int });
           
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


        protected void bSave_ServerClick(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spLyrGIS_Add", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@LyID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@LyID"].Value = Request.QueryString["LyID"];

          
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
                    string path = "Files\\GISLayer\\" + Comm.GetFilesPath(retID, "png");
                    FileInfo fi = new FileInfo(Server.MapPath("../") + "\\" + path);

                    if (!fi.Directory.Exists)
                        fi.Directory.Create();

                    Bitmap bm0 = new Bitmap(Symbol.PostedFile.InputStream);
                    Bitmap bm = new Bitmap(bm0, 64, 64);
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