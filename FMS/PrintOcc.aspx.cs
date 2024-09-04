using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using NPOI.HSSF.UserModel;
using NPOI.HPSF;
using NPOI.POIFS.FileSystem;
using NPOI.HSSF.Util;
using EBMSMap30;
using System.Drawing;
using NPOI.SS.UserModel;
using System.Drawing.Imaging;

namespace AFMProj.FMS
{
    public partial class PrintOcc : System.Web.UI.Page
    {
        public DataTable tbD,tbF;

        protected void Page_Load(object sender, EventArgs e)
        {
            FileStream fs = new FileStream(Server.MapPath("report") + @"\occ.xls", FileMode.Open, FileAccess.ReadWrite);
            HSSFWorkbook hssfworkbook = new HSSFWorkbook(fs);

            HSSFSheet sheet = (HSSFSheet)hssfworkbook.GetSheetAt(0);

            fs.Close();

            GetInfo();

            sheet.GetRow(1).GetCell(2).SetCellValue(string.Format("สำนักงาน กสทช. {0}", tbD.Rows[0]["OrgName"]));
            if(string.Format("{0:HH:mm}",tbD.Rows[0]["DtBegin"])!="00:00")
                sheet.GetRow(2).GetCell(2).SetCellValue(string.Format("ประจำวันที่ {0:dd MMMM yyyy} เวลา {1:HH:mm}", tbD.Rows[0]["DtBegin"], tbD.Rows[0]["DtBegin"]));
            else
                sheet.GetRow(2).GetCell(2).SetCellValue(string.Format("ประจำวันที่ {0:dd MMMM yyyy}", tbD.Rows[0]["DtBegin"]));

            sheet.GetRow(4).GetCell(0).SetCellValue(string.Format("ย่านความถี่  {0:0.0000} - {1:0.0000} MHz   จำนวน  {2:#,##0}  ช่องความถี่ ความกว้างช่องความถี่  {3:#,##0.0}kHz", tbD.Rows[0]["fFreq"], tbD.Rows[0]["tFreq"], tbD.Rows[0]["nCh"], tbD.Rows[0]["ChSp"]));

            for (int i = 1; i < tbF.Rows.Count; i++)
            {
                InsertRows(ref sheet, 9, 1);
            }
            //
            int irow = 9;
            for (int i = 0; i < tbF.Rows.Count; i++)
            {
                sheet.GetRow(i + 9).GetCell(0).SetCellValue(string.Format("{0}", i + 1));
                sheet.GetRow(i + 9).GetCell(1).SetCellValue(string.Format("{0:0.0000} MHz", tbF.Rows[i]["Freq"]));
                sheet.GetRow(i + 9).GetCell(2).SetCellValue(string.Format("{0:0.00}", tbF.Rows[i]["OccAvg"]));
                sheet.GetRow(i + 9).GetCell(3).SetCellValue(string.Format("{0}", tbF.Rows[i]["HostName"].ToString() != "" ? tbF.Rows[i]["HostName"].ToString() : "ตรวจสอบไม่พบในฐานข้อมูลผู้ครอบครอง"));
                sheet.GetRow(i + 9).GetCell(4).SetCellValue(string.Format("{0}", tbF.Rows[i]["Remark"]));
                irow++;
            }

            sheet.GetRow(irow + 3).GetCell(0).SetCellValue(string.Format(" - พบการใช้งาน จำนวน {0:#,##0} ช่องความถี่", tbF.Rows.Count));
            sheet.GetRow(irow + 4).GetCell(0).SetCellValue(string.Format(" - ไม่พบการใช้งาน จำนวน {0:#,##0} ช่องความถี่", cConvert.ToInt(tbD.Rows[0]["nCh"]) - tbF.Rows.Count));



            //sheet.GetRow(irow + 5 + 13).GetCell(2).SetCellValue("(" + tbD.Rows[0]["UserName"].ToString() + ")");
            //sheet.GetRow(irow + 5 + 16).GetCell(2).SetCellValue("(" + tbD.Rows[0]["AuthName"].ToString() + ")");
            if (tbD.Rows[0]["PatCode"].ToString() != "")
                sheet.GetRow(irow + 4 + 11).GetCell(2).SetCellValue(string.Format("ตำแหน่ง {0:0.000000}, {1:0.000000} ({2})", tbD.Rows[0]["Lat"], tbD.Rows[0]["Lng"], tbD.Rows[0]["Location"]));

            InsertSign(tbD.Rows[0]["UID"], irow + 4 + 12, hssfworkbook);


            sheet.GetRow(irow + 4 + 13).GetCell(2).SetCellValue("(" + tbD.Rows[0]["UserName"].ToString() + ")");
            //sheet.GetRow(irow + 5 + 15).GetCell(2).SetCellValue(MData.UsrSignR(tbD.Rows[0]["AuthID"]));
            InsertSign(tbD.Rows[0]["AuthID"], irow + 4 + 15, hssfworkbook);
            sheet.GetRow(irow + 4 + 16).GetCell(2).SetCellValue("(" + tbD.Rows[0]["AuthName"].ToString() + ")");
            //sheet.GetRow(irow + 4 + 17).GetCell(2).SetCellValue("ผู้อำนวยการสำนักงาน กสทช. " + tbD.Rows[0]["OrgName"]);
            sheet.GetRow(irow + 4 + 17).GetCell(2).SetCellValue(tbD.Rows[0]["AuthRank"].ToString());

            //
            sheet.ForceFormulaRecalculation = true;
            MemoryStream ms = new MemoryStream();
            hssfworkbook.Write(ms);

            Response.Clear();
            Response.ContentType = "application/vnd.ms-excel";
            Response.AddHeader("Content-Disposition", string.Format("attachment;filename=Reporting_{0}.xls", Request["ScanID"]));

            Response.BinaryWrite(ms.GetBuffer());
            ms.Close();
            Response.End();
        }

        static void InsertRows(ref HSSFSheet sheet1, int fromRowIndex, int rowCount)
        {
            sheet1.ShiftRows(fromRowIndex, sheet1.LastRowNum, rowCount, true, false, true);

            for (int rowIndex = fromRowIndex; rowIndex < fromRowIndex + rowCount; rowIndex++)
            {
                var rowSource = sheet1.GetRow(rowIndex + rowCount);
                var rowInsert = sheet1.CreateRow(rowIndex);
                rowInsert.Height = rowSource.Height;
                for (int colIndex = 0; colIndex < rowSource.LastCellNum; colIndex++)
                {
                    var cellSource = rowSource.GetCell(colIndex);
                    var cellInsert = rowInsert.CreateCell(colIndex);
                    if (cellSource != null)
                    {
                        cellInsert.CellStyle = cellSource.CellStyle;
                    }
                }
            }
        }


        private void GetInfo()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[fms].[spScan_Rep]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@AuthID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AuthID"].Value = cConvert.ToInt(Request["AuthID"]);

            SqlCmd.SelectCommand.Parameters.Add("@ScanID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@ScanID"].Value = Request["ScanID"];

            SqlCmd.SelectCommand.Parameters.Add("@FtID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@FtID"].Value = cConvert.ToInt(Request["FtID"]);

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tbD = DS.Tables[0];
            tbF = DS.Tables[1];

            string freqs = "";
            for (int i = 0; i < tbF.Rows.Count; i++)
            {
                if (i > 0)
                    freqs += ",";

                freqs += tbF.Rows[i]["Freq"].ToString();
            }
            var tbH = GetHost(freqs);
            for (int i = 0; i < tbF.Rows.Count; i++)
            {
                tbF.Rows[i]["HostName"] = tbH.Rows[i]["HostName"].ToString();
            }

        }
        private DataTable GetHost(string freqs)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["NBTCDC"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[fms].[spHostGets]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@Freqs", SqlDbType.VarChar, freqs.Length + 1);
            SqlCmd.SelectCommand.Parameters["@Freqs"].Value = freqs;



            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            return DS.Tables[0];
        }

        static void InsertSign(object UID, int row, HSSFWorkbook hssfworkbook)
        {
            try
            {
                byte[] data = MData.UsrSignR(UID);

                int imgWidth = 768; // only initial if not known
                int imgHeight = 45; // only initial if not known


                var img = new Bitmap(new MemoryStream(data));


                var newBm = new Bitmap(imgWidth, imgHeight);
                var g = Graphics.FromImage(newBm);
                g.DrawImage(img, new Rectangle((imgWidth - img.Width / img.Height * 45) / 2, 0, img.Width / img.Height * 45, 45),
                    new Rectangle(0, 0, img.Width, img.Height), GraphicsUnit.Pixel);

                MemoryStream bms = new MemoryStream();
                newBm.Save(bms, ImageFormat.Png);
                data = bms.ToArray();



                int pictureIndex = hssfworkbook.AddPicture(data, PictureType.PNG);
                ICreationHelper helper = hssfworkbook.GetCreationHelper();
                IDrawing drawing = hssfworkbook.GetSheetAt(0).CreateDrawingPatriarch();
                IClientAnchor anchor = helper.CreateClientAnchor();
                anchor.Col1 = 2;
                anchor.Col2 = 5;
                anchor.Row1 = row;//0 index based row
                IPicture picture = drawing.CreatePicture(anchor, pictureIndex);
                picture.Resize(1.0);
            }
            catch (Exception)
            {

            }
        }
    }
}