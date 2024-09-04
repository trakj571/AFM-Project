using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace EBMSMap30
{
    public class Export
    {
         
        public static void ToFile(DataTable tbD, List<String> columns,string title1,string title2)
        {
            HttpContext context = HttpContext.Current;
            context.Response.Clear();
            if (context.Request.QueryString["export"] == "print")
            {
                PDF pdf = new PDF();
                context.Response.Write("<html><head><style>@media print {.no-print {display:none}}</style></head>");
                context.Response.Write("<body style='font-family:tahoma'><table width=100%><tr><td align=center><table><tr><td width=1000 align=left>" + pdf.CreateTableDet(tbD, columns, title1, title2) + "</td></tr></table></td></tr></table></body>");
                context.Response.Write("<script>window.print()</script></html>");
            }
            else if (context.Request.QueryString["export"] == "xls")
            {
                context.Response.ContentType = "application/vnd.ms-excel";
                context.Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", context.Request.FilePath.Replace(".aspx", "") + "_Export.xls"));
                Excel excel = new Excel();
                excel.AddSheet(tbD, "Sheet1", columns);
                context.Response.BinaryWrite(excel.GetBuffer());
            }
            else if (context.Request.QueryString["export"] == "doc")
            {
                PDF pdf = new PDF();
                context.Response.ContentType = "application/vnd.ms-word";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                HttpContext.Current.Response.Charset = "UTF-8";
                context.Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", context.Request.FilePath.Replace(".aspx", "") + "_Export.doc"));
                context.Response.Write(pdf.CreateTable(tbD, columns, title1, title2));
            }
            else if (context.Request.QueryString["export"] == "pdf")
            {
                PDF pdf = new PDF();
                context.Response.ContentType = "application/pdf";
                context.Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", context.Request.FilePath.Replace(".aspx", "") + "_Export.pdf"));
                pdf.GeneratePDF("", "", true, pdf.CreateTable(tbD, columns, title1, title2));


                context.Response.Flush();

            }

            context.Response.End();
        }
    }
}