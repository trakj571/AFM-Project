<%@ Import NameSpace ="System.Data" %>
<%@ Import NameSpace="System.Data.SqlClient" %>
<%@ Import NameSpace="System.Configuration" %>
<%@ Import NameSpace="System.Web.Script.Serialization" %>

<script language="C#" runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        Response.ClearContent();
        try
        {
            string input;
            using (var reader = new System.IO.StreamReader(Request.InputStream))
            {
                input = reader.ReadToEnd();
            }

            string log = Request.Url.ToString() + " - >";
            foreach (string name in Request.Form)
            {
                log += name + " = " + Request.Form[name] + " ";
            }
            Log("Input", log + " "+input);


            //input = "{ \"mac\": \"94:83:c4:04:05:bc\", \"status\": true, \"utc_date\": \"2020-08-21\", \"utc_time\": \"03:11:51\", \"north_latitude\": \"1355.566040N\", \"east_longitude\": \"10039.710938E\", \"sea_height\": \"4.100000\", \"geoid_height\": \"-27.600000\", \"data\": \"$GNVTG,,T,,M,0.005,N,0.008,K,A*30\r\n$GNGGA,031150.00,1355.56602,N,10039.71107,E,1,12,0.60,4.1,M,-27.6,M,,*64\r\n$GNGSA,A,3,195,09,19,24,17,28,193,02,05,194,06,,1.27,0.60,1.12,1*31\r\n$GNGSA,A,3,10,06,09,04,23,13,03,07,08,28,16,14,1.27,0.60,1.12,4*09\r\n$GPGSV,4,1,13,02,41,316,35,05,48,211,36,06,37,009,15,09,15,084,17,0*61\r\n$GPGSV,4,2,13,12,22,321,,13,04,193,,17,39,068,41,19,44,043,46,0*65\r\n$GPGSV,4,3,13,24,09,262,27,28,34,153,28,193,45,085,41,194,24,153,28,0*69\r\n$GPGSV,4,4,13,195,46,066,38,0*63\r\n$GBGSV,4,1,16,01,37,105,31,02,65,232,29,03,71,141,34,04,22,097,31,0*71\r\n$GBGSV,4,2,16,05,40,255,27,06,23,150,30,07,56,159,31,08,42,003,29,0*7D\r\n$GBGSV,4,3,16,09,17,175,14,10,77,200,14,13,50,328,33,14,14,043,34,0*76\r\n$GBGSV,4,4,16,16,22,159,31,23,21,182,22,27,27,325,31,28,39,028,42,0*7B\r\n$GNGLL,1355.56602,N,10039.71107,E,031150.00,A,A*7F\r\n$GNRMC,031151.00,A,1355.56599,N,10039.71108,E,0.021,,210820,,,A,V*19\r\n$GNVTG,,T,,M,0.021,N,0.039,K,A*34\r\n$GNGGA,031151.00,1355.56599,N,10039.71108,E,1,12,0.60,4.1,M,-27.6,M,,*6B\r\n$GNGSA,A,3,195,09,19,24,17,28,193,02,05,194,06,,1.27,0.60,1.12,1*31\r\n$GNGSA,A,3,10,06,09,04,23,13,03,07,08,28,16,14,1.27,0.60,1.12,4*09\r\n$GPGSV,4,1,13,02,41,316,35,05,48,211,37,06,37,009,14,09,15,084,17,0*61\r\n$GPGSV,4,2,13,12,22,321,,13,04,193,,17,39,068,41,19,44,043,46,0*65\r\n$GPGSV,4,3,13,24,09,262,26,28,34,153,28,193,45,085,41,194,24,153,28,0*68\r\n$GPGSV,4,4,13,195,46,066,38,0*63\r\n$GBGSV,4,1,16,01,37,105,31,02,65,232,30,03,71,141,33,04,22,097,31,0*7E\r\n$GBGSV,4,2,16,05,40,255,27,06,23,150,30,07,56,159,31,08,42,003,29,0*7D\r\n$GBGSV,4,3,16,09,17,175,14,10,77,200,11,13,50,328,33,14,14,043,34,0*73\r\n$GBGSV,4,4,16,16,22,159,32,23,21,182,22,27,27,325,32,28,39,028,42,0*7B\r\n$GNGLL,1355.56599,N,10039.71108,E,031151.00,A,A*70\r\n\" }";
            var jsonser = new JavaScriptSerializer();
            var json = (Dictionary<string,object>)jsonser.DeserializeObject(input);
            double Lat=0, Lng=0,Alt=0;
            try
            {
                if (json.ContainsKey("north_latitude"))
                {
                    Lat = ConvertLL(json["north_latitude"].ToString().Replace("N", ""));
                    Lng = ConvertLL(json["east_longitude"].ToString().Replace("E", ""));
                    Alt = EBMSMap30.cConvert.ToDouble(json["sea_height"]);
                }
                else if (json.ContainsKey("latitude"))
                {
                    Lat = ConvertLL(json["latitude"].ToString().Replace("N", ""));
                    Lng = ConvertLL(json["longitude"].ToString().Replace("E", ""));
                    Alt = EBMSMap30.cConvert.ToDouble(json["altitude"]);
                }
                else if (json.ContainsKey("latitude_degree"))
                {
                    Lat = ConvertLL(json["latitude_degree"].ToString() + json["latitude_minute"].ToString());
                    Lng = ConvertLL(json["longitude_degree"].ToString() + json["longitude_minute"].ToString());
                    Alt = EBMSMap30.cConvert.ToDouble(json["altitude"]);
                }
                if (Lat > 0)
                    AddLog(json["mac"].ToString(), Lat, Lng, Alt);
                else
                    Log("Input", "Invalid format");
            }
            catch (Exception ex)
            {

                Log("Input", ex + "");
            }

        }
        catch (Exception ex)
        {
            Log("Input", ex + "");
        }
        Response.Write("OK");
        Response.End();
    }
    private double ConvertLL(string l)
    {
        var ls = l.Split('.');
        return EBMSMap30.cConvert.ToDouble(ls[0].Substring(0, ls[0].Length - 2)) + EBMSMap30.cConvert.ToDouble(ls[0].Substring(ls[0].Length - 2)+"."+ls[1]) / 60.0;
    }
    private void AddLog(string Mac,double Lat,double Lng,double ELv)
    {
        SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
        SqlDataAdapter SqlCmd = new SqlDataAdapter("[fms].[spGPS_AddLog_Mac]", SqlConn);
        SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

        SqlCmd.SelectCommand.Parameters.Add("@Mac", SqlDbType.VarChar,50);
        SqlCmd.SelectCommand.Parameters["@Mac"].Value = Mac;

        SqlCmd.SelectCommand.Parameters.Add("@Lat", SqlDbType.Float);
        SqlCmd.SelectCommand.Parameters["@Lat"].Value = Lat;

        SqlCmd.SelectCommand.Parameters.Add("@Lng", SqlDbType.Float);
        SqlCmd.SelectCommand.Parameters["@Lng"].Value = Lng;

        SqlCmd.SelectCommand.Parameters.Add("@ELv", SqlDbType.Float);
        SqlCmd.SelectCommand.Parameters["@ELv"].Value = @ELv;

        DataSet DS = new DataSet();
        SqlCmd.Fill(DS);
        SqlConn.Close();
    }
    public void Log(string cate, string text)
    {
        try
        {
            string fileName = Server.MapPath("") + @"\Log" + @"\" + cate + @"\" + string.Format(new System.Globalization.CultureInfo("en-US"), "{0:yyyy/MM/dd}", DateTime.Now) + ".txt";
            fileName = fileName.Replace("/", "\\");
            string FileDir = fileName.Substring(0, fileName.LastIndexOf("\\"));

            if (!System.IO.Directory.Exists(FileDir)) System.IO.Directory.CreateDirectory(FileDir);

            using (System.IO.StreamWriter sw = new System.IO.StreamWriter(fileName, true, System.Text.Encoding.GetEncoding(874)))
            {
                sw.WriteLine(DateTime.Now + " " + text);
            }
        }
        catch (Exception)
        {
            //Response.Write(ex.ToString());
        }
    }

</script>