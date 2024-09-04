using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using EBMSMap30;


namespace AFMProj.FMS.data
{
    /// <summary>
    /// Summary description for dHDet
    /// </summary>
    public class dScanTable : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spScan_Table", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = context.Request["PoiID"];

       
            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            WriteData(context, DS.Tables[0]);     

        }

        private void WriteData(HttpContext context,DataTable tbD)
        {
            context.Response.Write("<table class='table table-condensed text-center afms-table-responsive'>");
            context.Response.Write("<thead><tr><th>No.</th>");
            context.Response.Write("<th>Mode</th>");
            context.Response.Write("<th>Start Time</th>");
            context.Response.Write("<th>Stop Time</th>");
            context.Response.Write("<th>Duration</th>");
            context.Response.Write("<th>Frequency(MHz)</th>");
            context.Response.Write("<th>CH Spacing</th>");
            context.Response.Write("<th>Threshold</th>");
            context.Response.Write("<th>Result</th></tr></thead><tbody>");

            for (int i = 0; i < tbD.Rows.Count; i++)
            {
                context.Response.Write("<tr>");
                context.Response.Write("<td data-th='No.'>" + (i + 1) + "</td>");
                context.Response.Write("<td data-th='Mode'>" + tbD.Rows[i]["ModeName"] + "</td>");
                context.Response.Write("<td data-th='Start Time'>" + string.Format("{0:dd/MM/yyyy HH:mm}", tbD.Rows[i]["DtStart"]) + "</td>");
                context.Response.Write("<td data-th='Stop Time'>" + string.Format("{0:dd/MM/yyyy HH:mm}", tbD.Rows[i]["DtStop"]) + "</td>");
                
                string dur = "";
                int nSec = cConvert.ToInt(tbD.Rows[i]["nSec"]);
                if(nSec/3600>0) dur+= (nSec/3600)+" hr ";
                if (nSec/60 % 60 > 0) dur += (nSec/60 % 60) + " min ";
                if (nSec % 60 > 0) dur += (nSec % 60) + " sec ";

                context.Response.Write("<td data-th='Duration'>" + dur + "</td>");
                if (tbD.Rows[i]["Mode"].ToString() == "M")
                {
                    context.Response.Write("<td data-th='Frequency(MHz)'>" + string.Format("{0:0.00}", tbD.Rows[i]["fFreq"]) + "</td>");
                    context.Response.Write("<td data-th='CH Spacing'></td>");
                    context.Response.Write("<td data-th='Threshold'></td>");
                }
                else
                {
                    context.Response.Write("<td data-th='Frequency(MHz)'>" + string.Format("{0:0.00}-{1:0.00}", tbD.Rows[i]["fFreq"], tbD.Rows[i]["tFreq"]) + "</td>");
                    context.Response.Write("<td data-th='CH Spacing'>" + string.Format("{0:0.0}kHz", tbD.Rows[i]["ChSp"]) + "</td>");
                    context.Response.Write("<td data-th='Threshold'>" + string.Format("{0:0.0}dBm", tbD.Rows[i]["Threshold"]) + "</td>");
             
                }

                context.Response.Write("<td data-th='Result'>" + tbD.Rows[i]["Result"]);
                if (tbD.Rows[i]["IsCancel"].ToString() == "Y")
                {
                    context.Response.Write(" <a href='javascript:cancelScan(" + tbD.Rows[i]["ScanID"] + ")' style='color:red'>Cancel</a>");
                }
                context.Response.Write("</td>");
                context.Response.Write("</tr>");
            }
            context.Response.Write("</tbody></table>");
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