using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;

namespace EBMSMap30.data
{
    /// <summary>
    /// Summary description for gProv
    /// </summary>
    public class gProv : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string filename = context.Server.MapPath("../libs/dpv2.js");
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapS"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spBound_GetPv2]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            string text = "";
            text += "var AM2=new Array();var TB2=new Array();var VL2=new Array();var PV2='";
            ArrayList ar = new ArrayList();
            for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
            {
                ar.Add(DS.Tables[0].Rows[i]["Code"].ToString());
                ar.Add(DS.Tables[0].Rows[i]["Name_T"].ToString());
            }
            text += Concat(ar, ",") + "';";

            for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
            {
               
                ar.Clear();
                text += "AM2['" + DS.Tables[0].Rows[i]["Code"] + "']='";
                DataRow[] dr = DS.Tables[1].Select("Code like '" + DS.Tables[0].Rows[i]["Code"] + "%'");
                for (int j = 0; j < dr.Length; j++)
                {
                    ar.Add(dr[j]["Code"].ToString());
                    ar.Add(dr[j]["Name_T"].ToString());
                }
                text += Concat(ar, ",") + "';";
            }

            for (int i = 0; i < DS.Tables[1].Rows.Count; i++)
            {
                ar.Clear();
                text += "TB2['" + DS.Tables[1].Rows[i]["Code"] + "']='";
                DataRow[] dr = DS.Tables[2].Select("Code like '" + DS.Tables[1].Rows[i]["Code"] + "%'");
                for (int j = 0; j < dr.Length; j++)
                {
                    ar.Add(dr[j]["Code"].ToString());
                    ar.Add(dr[j]["Name_T"].ToString());
                }
                text += Concat(ar, ",") + "';";
            }
            /*
            for (int i = 0; i < DS.Tables[2].Rows.Count; i++)
            {
                ar.Clear();
                text += "VL['" + DS.Tables[2].Rows[i]["Tam_Code"] + "']='";
                DataRow[] dr = DS.Tables[3].Select("Vill_Code like '" + DS.Tables[2].Rows[i]["Tam_Code"] + "%'");
                for (int j = 0; j < dr.Length; j++)
                {
                    ar.Add(dr[j]["Vill_Code"].ToString());
                    ar.Add(dr[j]["Vill_Name"].ToString());
                }
                text += Concat(ar, ",") + "';";
            }
            

            text += "var CTY='";
            ar.Clear();
            for (int i = 0; i < DS.Tables[3].Rows.Count; i++)
            {
                ar.Add(DS.Tables[3].Rows[i]["TypeID"].ToString());
                ar.Add(DS.Tables[3].Rows[i]["Name"].ToString());
            }
            
            text += Concat(ar, ",") + "';";
             * */
            FileStream fs = new FileStream(filename, FileMode.Create, FileAccess.ReadWrite);
            StreamWriter w = new StreamWriter(fs, Encoding.Unicode);

            w.BaseStream.Seek(0, SeekOrigin.End);
            w.Write(text);
            w.Flush();
            w.Close();
        }

        public static string Concat(ICollection items, string delimiter)
        {
            bool first = true;

            StringBuilder sb = new StringBuilder();
            foreach (object item in items)
            {
                if (item == null)
                    continue;

                if (!first)
                {
                    sb.Append(delimiter);
                }
                else
                {
                    first = false;
                }
                sb.Append(item);
            }
            return sb.ToString();
        }

    



        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}