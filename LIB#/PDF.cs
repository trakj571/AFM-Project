
using System;
using System.Collections.Generic;
using System.IO;
using System.Data;
using System.Globalization;
using System.Text;
using System.Web;

namespace EBMSMap30
{
    public class TahomaFontFactoryImp : iTextSharp.text.FontFactoryImp
    {
        public override iTextSharp.text.Font GetFont(string fontname, string encoding, Boolean embedded, float size, int style, iTextSharp.text.BaseColor color, Boolean cached)
        {
            //return defaultFont;
            iTextSharp.text.pdf.BaseFont tahoma = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\WINDOWS\Fonts\tahoma.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            return new iTextSharp.text.Font(tahoma, size, style, color);
        }
    }

    public class PDF
    {
        public PDF()
        {

        }

        public string CreateTable(DataTable dt, List<String> columns, string title1, string title2)
        {
            StringBuilder sb = new StringBuilder();
            if (title1 != "")
                sb.Append("<div style='text-align:center;font-size:10pt'>" + title1 + "</div>");
            if (title2 != "")
                sb.Append("<div style='text-align:center;font-size:10pt'>" + title2 + "</div>");

            sb.Append("<br><table border=1 style='border-collapse:collapse;width:100%;'><tr>");
            sb.Append("<td style='border:1px solid #000;font-size:10pt'>ลำดับ</td>");
            for (int j = 0; j < columns.Count; j++)
            {
                String columnName = columns[j].Split(':')[1];
                sb.Append("<td style='border:1px solid #000;font-size:10pt'>" + columnName + "</td>");
            }
            sb.Append("</tr>");

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                sb.Append("<tr><td style='border:1px solid #000;font-size:10pt'>"+(i+1)+"</td>");
                for (int j = 0; j < columns.Count; j++)
                {
                    String columnName = columns[j].Split(':')[0];
                    if (dt.Columns[columnName].DataType == typeof(Decimal))
                    {
                        sb.Append("<td style='border:1px solid #000;font-size:10pt'>" + string.Format("{0:0.00}", dt.Rows[i][columnName]) + "</td>");
                    }
                    else if (dt.Columns[columnName].DataType == typeof(DateTime))
                    {
                        sb.Append("<td style='border:1px solid #000;font-size:10pt'>" + string.Format("{0:dd/MM/yyyy HH:mm:ss}", dt.Rows[i][columnName]) + "</td>");
                    }
                    else
                    {
                        sb.Append("<td style='border:1px solid #000;font-size:10pt'>" + string.Format("{0:0}", dt.Rows[i][columnName]) + "</td>");
                    }
                }
                sb.Append("</tr>");
            }
            sb.Append("</table>");
            return sb.ToString();
        }


        public string CreateTableDet(DataTable dt, List<String> columns, string title1, string title2)
        {
            StringBuilder sb = new StringBuilder();
            if (title1 != "")
                sb.Append("<div style='text-align:center;font-size:10pt'>" + title1 + "</div>");
            if (title2 != "")
                sb.Append("<div style='text-align:center;font-size:10pt'>" + title2 + "</div>");

            sb.Append("<br><table border=1 style='border-collapse:collapse;width:100%;'><tr>");
            for (int j = 0; j < columns.Count; j++)
            {
                String columnName = columns[j].Split(':')[1];
                sb.Append("<tr>");
                sb.Append("<td style='border:1px solid #aaa;font-size:12pt;padding:5px;width:200px'>" + columnName + "</td>");
                String column = columns[j].Split(':')[0];
                if (dt.Columns[column].DataType == typeof(Decimal))
                {
                    sb.Append("<td style='border:1px solid #aaa;font-size:12pt;padding:5px'>" + string.Format("{0:0.00}", dt.Rows[0][column]) + "</td>");
                }
                else if (dt.Columns[column].DataType == typeof(DateTime))
                {
                    sb.Append("<td style='border:1px solid #aaa;font-size:12pt;padding:5px'>" + string.Format("{0:dd/MM/yyyy HH:mm:ss}", dt.Rows[0][column]) + "</td>");
                }
                if (dt.Columns[column].DataType == typeof(double))
                {
                    sb.Append("<td style='border:1px solid #aaa;font-size:12pt;padding:5px'>" + string.Format("{0:0.0000}", dt.Rows[0][column]) + "</td>");
                }
                else
                {
                    sb.Append("<td style='border:1px solid #aaa;font-size:12pt;padding:5px'>" + string.Format("{0:0}", dt.Rows[0][column]) + "</td>");
                }
                sb.Append("</tr>");
            }
            sb.Append("</tr>");

            sb.Append("</table>");
            return sb.ToString();
        }

        public void GeneratePDF(string path, string fileName, bool download, string text)
        {
            var document = new iTextSharp.text.Document();
            if (!(iTextSharp.text.FontFactory.FontImp is TahomaFontFactoryImp))
                iTextSharp.text.FontFactory.FontImp = new TahomaFontFactoryImp();

            try
            {
                if (download)
                {
                    iTextSharp.text.pdf.PdfWriter.GetInstance(document, HttpContext.Current.Response.OutputStream);
                }
                else
                {
                    iTextSharp.text.pdf.PdfWriter.GetInstance(document, new FileStream(path + fileName, FileMode.Create));
                }

                // generates the grid first
                StringBuilder strB = new StringBuilder();
                document.Open();

                strB.Append(text);


                iTextSharp.text.html.simpleparser.StyleSheet style = new iTextSharp.text.html.simpleparser.StyleSheet();

                // now read the Grid html one by one and add into the document object
                using (TextReader sReader = new StringReader(strB.ToString()))
                {
                    List<iTextSharp.text.IElement> list = iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(sReader, style);
                    foreach (iTextSharp.text.IElement elm in list)
                    {
                        document.Add(elm);
                    }
                }
                document.Close();
            }
            catch (Exception ex)
            {
                
            }

        }
    }
}