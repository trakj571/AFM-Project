using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.IO;
using System.Net;

namespace EBMSMap30
{
    public class MInput
    {
        public enum DataType {String,Int,Double,DateTime,Check}
        public object HtmlInput { get; set; }
        public DataType DBType { get; set; }
        public string Format { get; set; }
    }
    public class MData
    {
        private static string cConn="EBMSMapD";
        public static void AddSqlCmd(SqlDataAdapter SqlCmd, List<MInput> mInputs)
        {
            foreach (var minput in mInputs)
            {
                string value = "";
                string clientid = "";
                if (minput.HtmlInput is HtmlInputText)
                {
                    value = ((HtmlInputText)minput.HtmlInput).Value;
                    clientid = ((HtmlInputText)minput.HtmlInput).ClientID;
                }
                if (minput.HtmlInput is HtmlInputHidden)
                {
                    value = ((HtmlInputHidden)minput.HtmlInput).Value;
                    clientid = ((HtmlInputHidden)minput.HtmlInput).ClientID;
                }
                if (minput.HtmlInput is HtmlSelect)
                {
                    value = ((HtmlSelect)minput.HtmlInput).Value;
                    clientid = ((HtmlSelect)minput.HtmlInput).ClientID;
                }
                if (minput.HtmlInput is HtmlTextArea)
                {
                    value = ((HtmlTextArea)minput.HtmlInput).Value;
                    clientid = ((HtmlTextArea)minput.HtmlInput).ClientID;
                }
                if (minput.HtmlInput is HtmlInputCheckBox)
                {
                    value = ((HtmlInputCheckBox)minput.HtmlInput).Value;
                    clientid = ((HtmlInputCheckBox)minput.HtmlInput).ClientID;
                }
                ////
                if (minput.DBType == MInput.DataType.Int)
                {
                    SqlCmd.SelectCommand.Parameters.Add("@" + clientid, SqlDbType.Int);
                    SqlCmd.SelectCommand.Parameters["@" + clientid].Value = cConvert.ToInt(value);

                }
                if (minput.DBType == MInput.DataType.Double)
                {
                    SqlCmd.SelectCommand.Parameters.Add("@" + clientid, SqlDbType.Float);
                    SqlCmd.SelectCommand.Parameters["@" + clientid].Value = cConvert.ToDouble(value);
                }
                if (minput.DBType == MInput.DataType.DateTime)
                {
                    SqlCmd.SelectCommand.Parameters.Add("@" + clientid, SqlDbType.SmallDateTime);
                    SqlCmd.SelectCommand.Parameters["@" + clientid].Value = cConvert.ConvertToDateTH(value);
                }

                if (minput.DBType == MInput.DataType.String)
                {
                    SqlCmd.SelectCommand.Parameters.Add("@" + clientid, SqlDbType.NVarChar, value.Length + 1);
                    SqlCmd.SelectCommand.Parameters["@" + clientid].Value = value;
                }

                if (minput.DBType == MInput.DataType.Check)
                {
                    bool ischecked = ((HtmlInputCheckBox)minput.HtmlInput).Checked;

                    SqlCmd.SelectCommand.Parameters.Add("@" + clientid, SqlDbType.NVarChar, 1);
                    SqlCmd.SelectCommand.Parameters["@" + clientid].Value = ischecked?"Y":"N";
                }
            }
        }
        public static void SetQSValue(List<MInput> mInputs)
        {
            foreach (var minput in mInputs)
            {
                if (minput.HtmlInput is HtmlInputText)
                {
                    string val = cText.StrFromUTF8(HttpContext.Current.Request.QueryString[((HtmlInputText)minput.HtmlInput).ClientID]);

                    if (minput.DBType == MInput.DataType.Int)
                    {
                        if (minput.Format != null && minput.Format != "")
                            val = string.Format("{0:" + minput.Format + "}", cConvert.ToInt(val));
                        else
                            val = cConvert.ToInt(val).ToString();

                    }
                    ((HtmlInputText)minput.HtmlInput).Value = val;
                }

                if (minput.HtmlInput is HtmlInputHidden)
                {
                    string val = cText.StrFromUTF8(HttpContext.Current.Request.QueryString[((HtmlInputHidden)minput.HtmlInput).ClientID]);
                    if (minput.DBType == MInput.DataType.Int)
                        val = cConvert.ToInt(val).ToString();
                    ((HtmlInputHidden)minput.HtmlInput).Value = val;
                }
                if (minput.HtmlInput is HtmlSelect)
                {
                    string val = cText.StrFromUTF8(HttpContext.Current.Request.QueryString[((HtmlSelect)minput.HtmlInput).ClientID]);
                    if (minput.DBType == MInput.DataType.Int)
                        val = cConvert.ToInt(val).ToString();
                    ((HtmlSelect)minput.HtmlInput).Value = val;
                }
                if (minput.HtmlInput is HtmlTextArea)
                {
                    string val = cText.StrFromUTF8(HttpContext.Current.Request.QueryString[((HtmlTextArea)minput.HtmlInput).ClientID]);
                    if (minput.DBType == MInput.DataType.Int)
                        val = cConvert.ToInt(val).ToString();
                    ((HtmlTextArea)minput.HtmlInput).Value = val;
                }

            }
        }
        public static DataSet GetDataAdm(String spName,object id,object value, List<MInput> mInputs)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cConn]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter(spName, SqlConn);

            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@" + id, SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@" + id].Value = cConvert.ToInt(value);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            DataTable tb = DS.Tables[0];
            foreach (var minput in mInputs)
            {
                if (minput.HtmlInput is HtmlInputText)
                {
                    if (minput.DBType == MInput.DataType.DateTime)
                        ((HtmlInputText)minput.HtmlInput).Value = string.Format(new System.Globalization.CultureInfo("th-TH"), "{0:dd/MM/yyyy}", tb.Rows[0][((HtmlInputText)minput.HtmlInput).ClientID]);
                    else if (minput.Format!=null && minput.Format!="" )
                        ((HtmlInputText)minput.HtmlInput).Value = string.Format("{0:"+minput.Format+"}", tb.Rows[0][((HtmlInputText)minput.HtmlInput).ClientID]);
                    else
                        ((HtmlInputText)minput.HtmlInput).Value = tb.Rows[0][((HtmlInputText)minput.HtmlInput).ClientID].ToString();
                }
                if (minput.HtmlInput is Label)
                {
                    if (minput.DBType == MInput.DataType.DateTime)
                        ((Label)minput.HtmlInput).Text = string.Format(new System.Globalization.CultureInfo("th-TH"), "{0:dd/MM/yyyy}&nbsp;", tb.Rows[0][((Label)minput.HtmlInput).ClientID]);
                    else if (minput.Format != null && minput.Format != "")
                        ((Label)minput.HtmlInput).Text = string.Format("{0:" + minput.Format + "}&nbsp;", tb.Rows[0][((Label)minput.HtmlInput).ClientID]);
                    else
                        ((Label)minput.HtmlInput).Text = tb.Rows[0][((Label)minput.HtmlInput).ClientID].ToString()+"&nbsp;";
                }
                if (minput.HtmlInput is HtmlInputHidden)
                {
                    ((HtmlInputHidden)minput.HtmlInput).Value = tb.Rows[0][((HtmlInputHidden)minput.HtmlInput).ClientID].ToString();
                }
                if (minput.HtmlInput is HtmlSelect)
                {
                    ((HtmlSelect)minput.HtmlInput).Value = tb.Rows[0][((HtmlSelect)minput.HtmlInput).ClientID].ToString();
                }
                if (minput.HtmlInput is HtmlTextArea)
                {
                    ((HtmlTextArea)minput.HtmlInput).Value = tb.Rows[0][((HtmlTextArea)minput.HtmlInput).ClientID].ToString();
                }
                if (minput.HtmlInput is HtmlInputCheckBox)
                {
                    ((HtmlInputCheckBox)minput.HtmlInput).Checked = tb.Rows[0][((HtmlInputCheckBox)minput.HtmlInput).ClientID].ToString() == "Y";
                }
            }

            return DS;
        }
        public static DataSet GetData(String spName, object id, object value, List<MInput> mInputs)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cConn]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter(spName, SqlConn);

            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@" + id, SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@" + id].Value = cConvert.ToInt(value);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            DataTable tb = DS.Tables[0];
            if (tb.Rows.Count > 0)
            {
                foreach (var minput in mInputs)
                {
                    if (minput.HtmlInput is HtmlInputText)
                    {
                        if (minput.DBType == MInput.DataType.DateTime)
                            ((HtmlInputText)minput.HtmlInput).Value = string.Format(new System.Globalization.CultureInfo("th-TH"), "{0:dd/MM/yyyy}", tb.Rows[0][((HtmlInputText)minput.HtmlInput).ClientID]);
                        else if (minput.Format != null && minput.Format != "")
                            ((HtmlInputText)minput.HtmlInput).Value = string.Format("{0:" + minput.Format + "}", tb.Rows[0][((HtmlInputText)minput.HtmlInput).ClientID]);
                        else
                            ((HtmlInputText)minput.HtmlInput).Value = tb.Rows[0][((HtmlInputText)minput.HtmlInput).ClientID].ToString();
                    }
                    if (minput.HtmlInput is Label)
                    {
                        if (minput.DBType == MInput.DataType.DateTime)
                            ((Label)minput.HtmlInput).Text = string.Format(new System.Globalization.CultureInfo("th-TH"), "{0:dd/MM/yyyy}&nbsp;", tb.Rows[0][((Label)minput.HtmlInput).ClientID]);
                        else if (minput.Format != null && minput.Format != "")
                            ((Label)minput.HtmlInput).Text = string.Format("{0:" + minput.Format + "}&nbsp;", tb.Rows[0][((Label)minput.HtmlInput).ClientID]);
                        else
                            ((Label)minput.HtmlInput).Text = tb.Rows[0][((Label)minput.HtmlInput).ClientID].ToString() + "&nbsp;";
                    }
                    if (minput.HtmlInput is HtmlInputHidden)
                    {
                        ((HtmlInputHidden)minput.HtmlInput).Value = tb.Rows[0][((HtmlInputHidden)minput.HtmlInput).ClientID].ToString();
                    }
                    if (minput.HtmlInput is HtmlSelect)
                    {
                        ((HtmlSelect)minput.HtmlInput).Value = tb.Rows[0][((HtmlSelect)minput.HtmlInput).ClientID].ToString();
                    }
                    if (minput.HtmlInput is HtmlTextArea)
                    {
                        ((HtmlTextArea)minput.HtmlInput).Value = tb.Rows[0][((HtmlTextArea)minput.HtmlInput).ClientID].ToString();
                    }
                }
            }
            return DS;
        }
        public static void DelData(String spName, object id, object del)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cConn]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter(spName, SqlConn);

            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@" + id, SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@" + id].Value = "-" + del;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
        }


        public static void GetUItems(HtmlSelect select, String table)
        {
            GetUItems(select, table, select.ID, "Name");
        }
        public static void GetUItems(HtmlSelect select, String table, String id)
        {
            GetUItems(select, table, id, "Name");
        }

        public static void GetUItems(HtmlSelect select, String table, String id, string Col)
        {
            try
            {
                string[] ids = id.Split(',');
                string[] cols = Col.Split(',');
                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cConn]);
                SqlDataAdapter SqlCmd = new SqlDataAdapter("[dbo].[spUD_Get]", SqlConn);
                SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

                SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@UID"].Value = 1;

                SqlCmd.SelectCommand.Parameters.Add("@Table", SqlDbType.VarChar, 20);
                SqlCmd.SelectCommand.Parameters["@Table"].Value = table;

                SqlCmd.SelectCommand.Parameters.Add("@xIDName", SqlDbType.VarChar, 20);
                SqlCmd.SelectCommand.Parameters["@xIDName"].Value = ids[ids.Length - 1]; ;

                SqlCmd.SelectCommand.Parameters.Add("@nPage", SqlDbType.Int);
                SqlCmd.SelectCommand.Parameters["@nPage"].Value = 10000;

                DataSet DS = new DataSet();
                SqlCmd.Fill(DS);
                SqlConn.Close();

                select.Items.Clear();
                select.Items.Add(new ListItem("= เลือก =", "0"));

                for (int i = 0; i < DS.Tables[1].Rows.Count; i++)
                {
                    string val = "";
                    for (int j = 0; j < ids.Length; j++)
                    {
                        if (j > 0) val += ",";
                        val += DS.Tables[1].Rows[i][ids[j]];
                    }
                    var text = "";
                    for (int j = 0; j < cols.Length; j++)
                    {
                        if (j > 0) text += " ";
                        text += DS.Tables[1].Rows[i][cols[j]];
                    }

                    select.Items.Add(new ListItem(text, val));
                }
            }
            catch (Exception ex) {
                //cUtils.Log("error", ex.Message + " " + table + " " + ConfigurationManager.AppSettings[cConn]);
            }
        }


        ////

        public static string GetSaveFileUrl(object id)
        {
            string fileid = string.Format("{0:000000000}", id);
            return fileid.Substring(0, 3) + @"/" + fileid.Substring(3, 3) + @"/" + fileid.Substring(6, 3);
        }

        public static void SaveFileData(HtmlInputFile File1, string Path, object id)
        {
            SaveFileData(File1, Path, id, "");
        }
        public static void SaveFileData(HtmlInputFile File1, string Path, object id, string imgno)
        {
            if (File1.PostedFile.ContentLength == 0) return;


            string fileExt = File1.PostedFile.FileName.Substring(File1.PostedFile.FileName.LastIndexOf(".") + 1);
            string fileid = string.Format("{0:000000000}", id);
            FileInfo fi = new FileInfo(HttpContext.Current.Server.MapPath("../Files") + @"\" + Path + @"\" + fileid.Substring(0, 3) + @"\" + fileid.Substring(3, 3) + @"\" + fileid.Substring(6, 3) + imgno + "." + fileExt);


            if (!fi.Directory.Exists)
                fi.Directory.Create();

            File1.PostedFile.SaveAs(fi.FullName);


        }

        public static byte[] UsrSignR(object uid)
        {
            var url = ConfigurationManager.AppSettings["ISO_Files_URL"] + "/Usr/Sign/" + GetSaveFileUrl(uid) + ".png";
            using (WebClient wc = new WebClient())
            {
                try
                {
                    var data = wc.DownloadData(url);
                    return data;
                }
                catch (Exception) {
                   // HttpContext.Current.Response.Write(url);
                   // HttpContext.Current.Response.End();
                }
            }

            return null;
        }

        public static string UsrSign(object uid)
        {
            var url = ConfigurationManager.AppSettings["ISO_Files_URL"] + "/Usr/Sign/" + GetSaveFileUrl(uid) + ".png";
            using (WebClient wc = new WebClient())
            {
                try
                {
                    var data = wc.DownloadData(url);
                    return "<img src='" + ConfigurationManager.AppSettings["ISO_Files_URL"] + "/Usr/Sign/" + GetSaveFileUrl(uid) + ".png?" + Comm.RandPwd(10) + "' style='height:50px;' />";
                }
                catch (Exception) { }
            }
            return "<img src='../img/spc.gif?" + uid + "' style='height:50px;' />";
        }
    }
}