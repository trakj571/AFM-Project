using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using EBMSMap30;
using System.Net;
using System.Xml;
using System.Web.Script.Serialization;

namespace AFMProj.PlugIn
{
    /// <summary>
    /// Summary description for dSensor
    /// </summary>
    public class cAttn : IHttpHandler
    {
        class SData
        {
            public double Voltage { get; set; }
            public double Current { get; set; }
            public double Frequency { get; set; }
            public double PAE { get; set; }
            public double UPSPc { get; set; }
            public double UPSTime { get; set; }
            public string StatusLED { get; set; }
            public double Humidity { get; set; }
            public double Temp { get; set; }
            public string Security { get; set; }
            public double Lat { get; set; }
            public double Lng { get; set; }
            public double Speed { get; set; }
            public double Alt { get; set; }
            public double Heading { get; set; }
            public DateTime DtSensor { get; set; }
            public int InPut { get; set; }
            public int OutPut { get; set; }
            public string TempStat { get; set; }
        }
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            
            ExecCmd(context);
            context.Response.End();
        }
        private void ExecCmd(HttpContext context)
        {
            var id = cUsr.GetIdentity(context.Request["token"]);

            if (!id.IsVerify)
            {
                context.Response.Write("Error");
            }


            string url = "http://202.125.84.53/rms/" + context.Request["uuid"] + "/service/antenna.php?set=" + context.Request["set"];
            //218
            if (context.Request["uuid"] == "218")
            {
                string status = context.Request["set"];
                if (status == "1") status = "0";
                else status = "1";
                url = "http://209.15.109.126/afm/mango/relay.ashx?uuid=" + context.Request["uuid"] + "&pin=1&status=" + status;
            }
                
            try
            {
                using (WebClient wc = new WebClient())
                {
                    string result = wc.DownloadString(url);
                    context.Response.Write(result);
                    ReadSensor(context);
                    cUtils.Log("plugin", url + " " + result);
                }
            }
            catch (Exception ex) {
                context.Response.Write("Error");
                cUtils.Log("plugin", url + " " + ex.Message);
            }
            
        }

        public void ReadSensor(HttpContext context)
        {
            DataTable tbE = GetEqu(context);
            for (int i = 0; i < tbE.Rows.Count; i++)
            {
                if (tbE.Rows[i]["UUID"].ToString() != context.Request["uuid"])
                    continue;

                SData sdata = new SData();
                sdata.StatusLED = "0000000000";
                ReadSensor(tbE.Rows[i]["UUID"].ToString(), sdata);
                ReadUPS(tbE.Rows[i]["UUID"].ToString(), sdata);
                SaveToDB(cConvert.ToInt(tbE.Rows[i]["PoiID"]), sdata);
            }
        }

        private DataTable GetEqu(HttpContext context)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD30"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("spEquip_Gets", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            var id = cUsr.GetIdentity(context.Request["token"]);

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = id.UID;

            SqlCmd.SelectCommand.Parameters.Add("@EquType", SqlDbType.VarChar, 10);
            SqlCmd.SelectCommand.Parameters["@EquType"].Value = "STN+STN2";


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            return DS.Tables[0];
        }
        public static DateTime ConvertToDateTime(string dt)
        {
            try
            {
                string[] dts = dt.Split(' ')[0].Split('/');
                string[] tms = dt.Split(' ')[1].Split(':');
                DateTime ret = new DateTime(
                    int.Parse(dts[2]),
                    int.Parse(dts[1]),
                    int.Parse(dts[0]),
                    int.Parse(tms[0]),
                    int.Parse(tms[1]), int.Parse(tms[2])

                    );

                if (ret > DateTime.Now.AddYears(-100) && ret < DateTime.Now.AddYears(100))
                    return ret;
            }
            catch (Exception)
            { }
            return DateTime.Now;
        }


        private void ReadSensor(string UUID, SData sdata)
        {
           // ServicePointManager.ServerCertificateValidationCallback += new System.Net.Security.RemoteCertificateValidationCallback(Comm.ValidateRemoteCertificate);

            try
            {
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.Load("http://202.125.84.53/rms/service/sensor.php?id=" + UUID);
                sdata.DtSensor = ConvertToDateTime(xmlDoc.DocumentElement.SelectSingleNode("TIME").InnerText);
                XmlNodeList nodeList = xmlDoc.DocumentElement.SelectNodes("//SENSOR");
                foreach (XmlNode node in nodeList)
                {
                    string TYPE = node.SelectSingleNode("TYPE").InnerText;
                    string PIN = node.SelectSingleNode("PIN").InnerText;
                    if (TYPE == "Temperature")
                    {
                        sdata.Temp = cConvert.ToDouble(node.SelectSingleNode("VALUE").InnerText);
                        sdata.TempStat = node.SelectSingleNode("STATUS").InnerText;
                    }
                    if (TYPE == "Humidity")
                        sdata.Humidity = cConvert.ToDouble(node.SelectSingleNode("VALUE").InnerText);
                    if (TYPE == "Input")
                        sdata.InPut = cConvert.ToInt(node.SelectSingleNode("VALUE").InnerText);
                    if (TYPE == "Output" && PIN == "0")
                    {
                        int attn = cConvert.ToInt(node.SelectSingleNode("VALUE").InnerText);
                        if (attn == 1) sdata.StatusLED = sdata.StatusLED.Substring(0, 8) + "10";
                        else if (attn == 0) sdata.StatusLED = sdata.StatusLED.Substring(0, 8) + "01";
                    }
                    if (TYPE == "Output" && PIN == "1")
                    {
                        int scan = cConvert.ToInt(node.SelectSingleNode("VALUE").InnerText);
                        if (scan == 1) sdata.StatusLED = sdata.StatusLED.Substring(0, 2) + "1" + sdata.StatusLED.Substring(3);
                    }
                    if (TYPE == "Output" && PIN == "2")
                    {
                        int rout = cConvert.ToInt(node.SelectSingleNode("VALUE").InnerText);
                        if (rout == 1) sdata.StatusLED = sdata.StatusLED.Substring(0, 1) + "1" + sdata.StatusLED.Substring(2);
                    }
                    if (TYPE == "Output" && PIN == "3")
                    {
                        sdata.OutPut = cConvert.ToInt(node.SelectSingleNode("VALUE").InnerText);
                    }
                }

            }
            catch (Exception ex)
            {
        
            }
        }

        private void ReadUPS(string UUID, SData sdata)
        {
            //ServicePointManager.ServerCertificateValidationCallback += new System.Net.Security.RemoteCertificateValidationCallback(Comm.ValidateRemoteCertificate);

            using (var w = new WebClient())
            {
                var json_data = string.Empty;
                string url = "http://202.125.84.53/rms/" + UUID + "/service/ups.php";
                // attempt to download JSON data as a string
                try
                {
                    json_data = w.DownloadString(url);
                    JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
                    var results = (Object[])jsSerializer.DeserializeObject(json_data);
                    foreach (var obj in results)
                    {
                        var obj1 = (Dictionary<string, object>)(obj);
                        if (obj1["name"].ToString() == "BCHARGE")
                        {
                            sdata.UPSPc = cConvert.ToDouble(obj1["value"].ToString().Replace(" Percent", ""));
                            sdata.StatusLED = "1" + sdata.StatusLED.Substring(1);
                        }
                        if (obj1["name"].ToString() == "TIMELEFT")
                        {
                            sdata.UPSTime = cConvert.ToDouble(obj1["value"].ToString().Replace(" Minutes", ""));
                        }
                    }

                }
                catch (Exception ex)
                {
                }
                // if string with JSON data is not empty, deserialize it to class and return its instance 
            }
        }

        private void SaveToDB(int PoiID, SData sdata)
        {
            //sdata.Lat = 13.783538;
            //sdata.Lng = 100.464166;

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD30"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("fms.spSensorAdd", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;


            SqlCmd.SelectCommand.Parameters.Add("@PoiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@PoiID"].Value = PoiID;

            SqlCmd.SelectCommand.Parameters.Add("@Voltage", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Voltage"].Value = sdata.Voltage;

            SqlCmd.SelectCommand.Parameters.Add("@Current", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Current"].Value = sdata.Current;

            SqlCmd.SelectCommand.Parameters.Add("@Frequency", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Frequency"].Value = sdata.Frequency;

            SqlCmd.SelectCommand.Parameters.Add("@PAE", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@PAE"].Value = sdata.PAE;

            SqlCmd.SelectCommand.Parameters.Add("@UPSPc", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@UPSPc"].Value = sdata.UPSPc;

            SqlCmd.SelectCommand.Parameters.Add("@UPSTime", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@UPSTime"].Value = sdata.UPSTime;

            SqlCmd.SelectCommand.Parameters.Add("@StatusLED", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@StatusLED"].Value = sdata.StatusLED;

            SqlCmd.SelectCommand.Parameters.Add("@Humidity", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Humidity"].Value = sdata.Humidity;

            SqlCmd.SelectCommand.Parameters.Add("@Temp", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Temp"].Value = sdata.Temp;

            SqlCmd.SelectCommand.Parameters.Add("@Security", SqlDbType.NVarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Security"].Value = sdata.Security;

            SqlCmd.SelectCommand.Parameters.Add("@Lat", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lat"].Value = sdata.Lat;

            SqlCmd.SelectCommand.Parameters.Add("@Lng", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Lng"].Value = sdata.Lng;

            SqlCmd.SelectCommand.Parameters.Add("@Speed", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Speed"].Value = sdata.Speed;

            SqlCmd.SelectCommand.Parameters.Add("@Alt", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Alt"].Value = sdata.Alt;

            SqlCmd.SelectCommand.Parameters.Add("@Heading", SqlDbType.Float);
            SqlCmd.SelectCommand.Parameters["@Heading"].Value = sdata.Heading;

            SqlCmd.SelectCommand.Parameters.Add("@InPut", SqlDbType.TinyInt);
            SqlCmd.SelectCommand.Parameters["@InPut"].Value = sdata.InPut;

            SqlCmd.SelectCommand.Parameters.Add("@OutPut", SqlDbType.TinyInt);
            SqlCmd.SelectCommand.Parameters["@OutPut"].Value = sdata.OutPut;

            if (sdata.DtSensor.Year == DateTime.Now.Year)
            {
                SqlCmd.SelectCommand.Parameters.Add("@DtSensor", SqlDbType.DateTime);
                SqlCmd.SelectCommand.Parameters["@DtSensor"].Value = sdata.DtSensor;
            }

            SqlCmd.SelectCommand.Parameters.Add("@TempStat", SqlDbType.NVarChar, 20);
            SqlCmd.SelectCommand.Parameters["@TempStat"].Value = sdata.TempStat;


            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
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