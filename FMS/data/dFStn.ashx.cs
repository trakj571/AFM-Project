using EBMSMap30;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

namespace AFMProj.FMS.data
{
    /// <summary>
    /// Summary description for dFStn
    /// </summary>
    public class dFStn : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            if (cConvert.ToInt(context.Request["StnID"]) > 0)
                MData.DelData("fms.spFDBStnAdd", "StnID",context.Request["StnID"]);

            if (cConvert.ToInt(context.Request["FuID"]) > 0 || context.Request["TmpKey"] != "")
                GetDet(context);
        }

        private void GetDet(HttpContext context)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["NBTCDC"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[fms].[spFDBStnGet]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;


            SqlCmd.SelectCommand.Parameters.Add("@FuID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@FuID"].Value = cConvert.ToInt(context.Request["FuID"]);

            SqlCmd.SelectCommand.Parameters.Add("@TmpKey", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@TmpKey"].Value = context.Request["TmpKey"];


            SqlCmd.SelectCommand.Parameters.Add("@nPage", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@nPage"].Value = 10000;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            DataTable tbD = DS.Tables[1];

            StringBuilder sb = new StringBuilder();


            sb.Append("<table class=\"table m-0\">");
            sb.Append("<thead>");
            sb.Append("<tr>");
            sb.Append("<th scope=\"col\" style=\"width: 60px\">ลำดับ</th>");
            sb.Append("<th scope=\"col\">ชื่อสถานี</th>");
            sb.Append("<th scope=\"col\" style=\"width: 200px\">ที่อยู่</th>");
            sb.Append("<th scope=\"col\">กำลังส่ง</th>");
            sb.Append("<th scope=\"col\">ความสูงของเสา(ม.)</th>");
            sb.Append("<th scope=\"col\">พิกัด</th>");

            sb.Append("<th scope=\"col\" style=\"width: 100px\"></th>");
            sb.Append("</tr>");
            sb.Append("</thead>");

            sb.Append("<tbody>");
            for (int i = 0; i < tbD.Rows.Count; i++)
            {
                sb.Append("<tr>");
                sb.Append("<td data-title=\"ลำดับ\">" + (i + 1) + "</td>");
                sb.Append("<td data-title=\"ชื่อสถานี\">" + tbD.Rows[i]["StName"] + "</td>");
                sb.Append("<td data-title=\"ที่อยู่\">" + tbD.Rows[i]["AdrNo"] + "</td>");
                sb.Append("<td data-title=\"กำลังส่ง\">" + tbD.Rows[i]["PW"] + tbD.Rows[i]["PWUnit"] + "</td>");
                sb.Append("<td data-title=\"ความสูงของเสา(ม.)\">" + tbD.Rows[i]["H"] + "</td>");
                sb.Append("<td data-title=\"พิกัด\">" + tbD.Rows[i]["Lat"] + "," + tbD.Rows[i]["Lng"] + "</td>");
                sb.Append("<td align=center>");

                if (context.Request["det"] == null)
                {
                    sb.Append("<a class='nbtcdc-btn nbtcdc-btn--icon nbtcdc-ic--edit-3 mr-2' href=\"#\" onclick=\"editItemStn(" + tbD.Rows[i]["StnID"] + ")\"></a> &nbsp;");
                    sb.Append("<a class='nbtcdc-btn nbtcdc-btn--icon nbtcdc-ic--trash-2 mr-2' href=\"javascript:loadItemStn(" + tbD.Rows[i]["StnID"] + ")\"></a>");

                }
                else
                {
                    sb.Append(" <a class=\"afms-btn afms-ic_view\"  href=\"javascript:editItemStn(" + tbD.Rows[i]["StnID"] + ",'det')\"></a>");

                }
                sb.Append("</td>");
                sb.Append("</tr>");

            }

            sb.Append("<tr><td class=\"mrta-table--no\">&nbsp;</td><td colspan=10></td></tr>");
            sb.Append("</tbody>");
            sb.Append("</table>");


            context.Response.Write(sb.ToString());
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