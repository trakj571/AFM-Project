
using System;
using System.Collections.Generic;
using System.IO;
using System.Data;
using System.Globalization;
using NPOI.HSSF.UserModel;
using NPOI.HPSF;
using NPOI.POIFS.FileSystem;
using NPOI.HSSF.Util;

namespace EBMSMap30
{
    public class Excel
    {
        HSSFWorkbook hssfworkbook;
        public Excel()
        {
            hssfworkbook = new HSSFWorkbook();
        }
        public void AddSheet(DataTable dt,string SheetName ,List<String> columns)
        {
          
            var sheet1 = hssfworkbook.CreateSheet(SheetName);
            var row1 = sheet1.CreateRow(0);
            sheet1.DefaultColumnWidth = 15;

            for (int j = 0; j < columns.Count; j++)
            {
                //var cell = row1.CreateCell(j);
                HSSFCell cell = (HSSFCell)row1.CreateCell(j);
                String columnName = columns[j].Split(':')[1];
                cell.SetCellValue(columnName);

                cell.CellStyle = hssfworkbook.CreateCellStyle();
                cell.CellStyle.FillForegroundColor = HSSFColor.Yellow.Index;
                cell.CellStyle.FillPattern = NPOI.SS.UserModel.FillPattern.SolidForeground;
               
            }


            //loops through data
            //var avgCellFormate = hssfworkbook.CreateDataFormat();
            //var dataFormate = avgCellFormate.GetFormat("0.00");
            var avgCellStyle = hssfworkbook.CreateCellStyle();
            avgCellStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("0.00");


            for (int i = 0; i < dt.Rows.Count; i++)
            {

                var row = sheet1.CreateRow(i + 1);

                for (int j = 0; j < columns.Count; j++)
                {
                    HSSFCell cell = (HSSFCell)row.CreateCell(j);
                    cell.CellStyle.WrapText = true;
                    cell.CellStyle.VerticalAlignment = NPOI.SS.UserModel.VerticalAlignment.Top;
                    String columnName = columns[j].Split(':')[0];
                    string format = "";
                    if (columns[j].Split(':').Length > 2)
                    {
                        format = columns[j].Split(':')[2];
                    }
                    try
                    {
                        if (format != "")
                        {
                            if (format == "0.0000")
                            {
                                try
                                {
                                    cell.SetCellValue(string.Format("{0:" + format + "}", Convert.ToDouble(dt.Rows[i][columnName])));
                                }
                                catch (Exception)
                                {
                                    cell.SetCellValue(string.Format("{0:" + format + "}", dt.Rows[i][columnName]));
                                }
                            }
                            else
                            {
                                cell.SetCellValue(string.Format("{0:" + format + "}", dt.Rows[i][columnName]));
                            }

                        }
                        else if (dt.Columns[columnName].DataType == typeof(System.Decimal))
                        {
                            if (columns[j].Split(':')[1].EndsWith("%"))
                                cell.SetCellValue(dt.Rows[i][columnName] == DBNull.Value ? 0 : Convert.ToDouble(dt.Rows[i][columnName]));
                            else
                                cell.SetCellValue(dt.Rows[i][columnName] == DBNull.Value ? 0 : Convert.ToDouble(dt.Rows[i][columnName]));

                            //cell.SetCellType(NPOI.SS.UserModel.CellType.NUMERIC);
                            cell.CellStyle = avgCellStyle;
                        }
                        else if (dt.Columns[columnName].DataType == typeof(DateTime))
                            cell.SetCellValue(string.Format("{0:dd/MM/yyyy HH:mm:ss}", dt.Rows[i][columnName]));
                        else
                            cell.SetCellValue(dt.Rows[i][columnName].ToString());
                    }
                    catch (Exception) { }
                }
            }
        }

        public byte[] GetBuffer()
        {
            MemoryStream ms = new MemoryStream();
            hssfworkbook.Write(ms);

            return ms.ToArray();
        }


        public static void EditInv()
        {
            FileStream fs = new FileStream(@"E:\PrintInvoice.xls", FileMode.Open, FileAccess.ReadWrite);
            HSSFWorkbook templateWorkbook = new HSSFWorkbook(fs);

            HSSFSheet sheet = (HSSFSheet)templateWorkbook.GetSheetAt(0);
            
            fs.Close();

            sheet.GetRow(5).GetCell(2).SetCellValue("Drago");
            sheet.ForceFormulaRecalculation = true;
            fs = new FileStream(@"E:\PrintInvoice2.xls", FileMode.Create, FileAccess.ReadWrite);
            templateWorkbook.Write(fs);
            fs.Close();
        }
    }
}