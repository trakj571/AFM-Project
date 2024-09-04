using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EBMSMap30;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace AFMProj.GIS
{
    public partial class ExportPOI : System.Web.UI.Page
    {
        DataTable tb;
        protected void Page_Load(object sender, EventArgs e)
        {
            List<string> columns = new List<string>();
            columns.Add("LICENSENO:ใบอนุญาต");
            columns.Add("DtLic:ลงวันที่:dd/MM/yyyy");
            columns.Add("OrgName:ชื่อผู้ประกอบการ");
            columns.Add("Name:ชื่อสถานี");
            columns.Add("Freq:ความถี่");
            columns.Add("Amphoe:อำเภอ");
            columns.Add("Prov:จังหวัด");
            columns.Add("Status:สถานะการออกอากาศ");
            columns.Add("Lat1:สถานี lat");
            columns.Add("Lng1:สถานี long");

            columns.Add("StaLoc:ที่ตั้ง");
            columns.Add("StnCode:รหัสสถานี");
            columns.Add("CoopNa:ผู้ประสานงาน");
            columns.Add("CoopTel:โทรศัพท์");
            columns.Add("Height:ความสูงจากระดับน้ำทะเล(เมตร)");
            columns.Add("Aerial_Type:ชนิดสายอากาศ");
            columns.Add("Aerial_DBI:อัตราขยายสายอากาศ(DBI)");
            columns.Add("Aerial_Pow:กำลังส่ง(วัตต์)");
            columns.Add("Aerial_Hg:ความสูงเสาอากาศ(เมตร)");
            columns.Add("FreqMhz_M:ความถี่ที่วัดได้");
            columns.Add("DataSrc:แหล่งข้อมูล");



            if (cConvert.ToDouble(Request["r"]) > 0)
            {
                SchG();
                tb.Columns.Add("cDist");
                double lat = Convert.ToDouble(Request["lat"]);
                double lng = Convert.ToDouble(Request["lng"]);
           
                DT2.Point c = new DT2.Point(){X=lng,Y=lat};
                for (int i = 0; i < tb.Rows.Count; i++)
                {
                    tb.Rows[i]["cDist"] = string.Format("{0:#,##0.000}",cMath.DistVincenty(c,
                        new DT2.Point(){X=cConvert.ToDouble(tb.Rows[i]["Lng1"]), Y=cConvert.ToDouble(tb.Rows[i]["Lat1"])})/1000.0);
                          
                }
                columns.Add("cDist:ระยะห่างจาก Center (km)");
            }
            else
            {
                Sch();
            }
            
            Export.ToFile(tb, columns, "", "");
        }
        private void Sch()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spPOI_Sch]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            string[] keywords = cText.StrFromUTF8(Request["keyword"]).Split(' ');
            for (int i = 0; i < keywords.Length; i++)
            {

                SqlCmd.SelectCommand.Parameters.Add("@kw" + (i + 1), SqlDbType.VarChar, 30);
                SqlCmd.SelectCommand.Parameters["@kw" + (i + 1)].Value = keywords[i];
            }

            SqlCmd.SelectCommand.Parameters.Add("@Lat", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lat"].Value = Request["lat"];

            SqlCmd.SelectCommand.Parameters.Add("@Lng", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lng"].Value = Request["lng"];

            SqlCmd.SelectCommand.Parameters.Add("@Code", SqlDbType.VarChar, 20);
            SqlCmd.SelectCommand.Parameters["@Code"].Value = Request["code"];

            SqlCmd.SelectCommand.Parameters.Add("@TypeID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@TypeID"].Value = Request["typeid"];

            SqlCmd.SelectCommand.Parameters.Add("@LyIDs", SqlDbType.VarChar, Request["lyids"].Length + 1);
            SqlCmd.SelectCommand.Parameters["@LyIDs"].Value = Request["lyids"];

            SqlCmd.SelectCommand.Parameters.Add("@IsExport", SqlDbType.VarChar, 20);
            SqlCmd.SelectCommand.Parameters["@IsExport"].Value = "Y";

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tb = DS.Tables[0];
        }
        private void SchG()
        {
            double lat = Convert.ToDouble(Request["lat"]);
            double lng = Convert.ToDouble(Request["lng"]);
            double r = Convert.ToDouble(Request["r"]);
            double lat1 = double.MaxValue;
            double lat2 = double.MinValue;
            double lng1 = double.MaxValue;
            double lng2 = double.MinValue;

            DT2.Point c = new DT2.Point(){X=lng,Y=lat};
            for (int i = 0; i < 360; i+=90)
            {
                DT2.Point p = cMath.PointAtR(i, c, r);
                lat1 = Math.Min(lat1, p.Y);
                lat2 = Math.Max(lat2, p.Y);
                lng1 = Math.Min(lng1, p.X);
                lng2 = Math.Max(lng2, p.X);
            }


            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spPoi_SchG]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@Lat1", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lat1"].Value =  lat1;

            SqlCmd.SelectCommand.Parameters.Add("@Lng1", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lng1"].Value = lng1;

            SqlCmd.SelectCommand.Parameters.Add("@Lat2", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lat2"].Value = lat2;

            SqlCmd.SelectCommand.Parameters.Add("@Lng2", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lng2"].Value = lng2;

            SqlCmd.SelectCommand.Parameters.Add("@LyIDs", SqlDbType.VarChar, Request["lyids"].Length + 1);
            SqlCmd.SelectCommand.Parameters["@LyIDs"].Value = Request["lyids"];

            SqlCmd.SelectCommand.Parameters.Add("@IsExport", SqlDbType.VarChar, 20);
            SqlCmd.SelectCommand.Parameters["@IsExport"].Value = "Y";

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            tb = DS.Tables[0];
          
            for (int i = tb.Rows.Count-1; i>=0; i--)
            {
                double Lat1 = Convert.ToDouble(tb.Rows[i]["Lat1"]);
                double Lng1 = Convert.ToDouble(tb.Rows[i]["Lng1"]);
                double Lat2 = Convert.ToDouble(tb.Rows[i]["Lat2"]);
                double Lng2 = Convert.ToDouble(tb.Rows[i]["Lng2"]);

                DT2.Point p = new DT2.Point() { X = lng, Y = lat };
                DT2.Point p1 = new DT2.Point() { X = Lng1, Y = Lat1 };
                DT2.Point p2 = new DT2.Point() { X = Lng1, Y = Lat2 };
                DT2.Point p3 = new DT2.Point() { X = Lng2, Y = Lat2 };
                DT2.Point p4 = new DT2.Point() { X = Lng2, Y = Lat1 };

                if (cMath.Distance(p, p1) > r &&
                    cMath.Distance(p, p2) > r &&
                    cMath.Distance(p, p3) > r &&
                    cMath.Distance(p, p4) > r)
                {
                    tb.Rows.RemoveAt(i);
                }

                
            }
        
        }
    }
}