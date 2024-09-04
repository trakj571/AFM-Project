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
    public class dHDet : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            DataSet DS = MData.GetData("fms.spHostGet", "hid", context.Request.QueryString["hid"], new List<MInput>());
            WriteData(context, DS.Tables[0]);     

        }

        private void WriteData(HttpContext context,DataTable tbD)
        {
            context.Response.Write("<div class=\"col-md-12\">");
			context.Response.Write("<label>ผู้ใช้คลื่นความถี่</label>");
			context.Response.Write("<p>"+tbD.Rows[0]["Name"]+"</p>");
			context.Response.Write("</div>");
			context.Response.Write("<div class=\"col-md-12\">");
			context.Response.Write("<label>ที่อยู่</label>");
            context.Response.Write("<p>" + tbD.Rows[0]["AdrNo"] + " " + tbD.Rows[0]["Road"] + " " + tbD.Rows[0]["Tambol"] + " " + tbD.Rows[0]["Amphoe"] + " " + tbD.Rows[0]["Province"] + "</p>");
			context.Response.Write("</div>");
			context.Response.Write("<div class=\"col-md-12\">");
            context.Response.Write("<label>โทรศัพท์</label>");
            context.Response.Write("<p>" + tbD.Rows[0]["TelNo"] + "</p>");
			context.Response.Write("</div>");
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