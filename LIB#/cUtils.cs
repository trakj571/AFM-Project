using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;

namespace EBMSMap30
{
    public class cUtils
    {
        public static string getJSON_ERR(string code)
        {
            string json = "";
            json = "{\"result\":\"ERR\",\"code\":\"" + code + "\"}";
            return json;
        }
        public static string GetToken(string tk)
        {
            var tks = tk.Split(':');
            if (tks.Length > 1)
                return tk.Split(':')[1];
            else
                return "";
        }
        public static string GetDBName(string tk)
        {
            return "EBMSMapD30";// tk.Split(':')[0];
        }
        public static string ImgUrl(int PoiID, int ColID, string Token)
        {
            string spoiid = string.Format("{0:000000000}", PoiID);
            return ConfigurationManager.AppSettings[GetWebURL(Token)] + "/Files/POI/" + spoiid.Substring(0, 3) + "/" + spoiid.Substring(3, 3) + "/" + spoiid.Substring(6, 3) + "_" + ColID + ".jpg";
        }
        public static string IconUrl(object id, object Icon, string Token)
        {
            if (Icon.ToString() == "*" || Icon.ToString() == "")
            {
                string sid = string.Format("{0:000000000}", id);
                return ConfigurationManager.AppSettings[GetWebURL(Token)] + "/Files/Symbol/" + sid.Substring(0, 3) + "/" + sid.Substring(3, 3) + "/" + sid.Substring(6, 3) + ".png";

            }
            else
            {
                return ConfigurationManager.AppSettings[GetWebURL(Token)] + "/Files/Symbol/default/" + Icon + ".png";
            }
        }
        public static string GetWebURL(string tk)
        {
            return GetDBName(tk) + "_URL";
        }
        public static string GetWebDir(string tk)
        {
            return GetDBName(tk) + "_Dir";
        }

        public static void Log(string cate, string text)
        {
            try
            {
                string fileName = ConfigurationManager.AppSettings["EBMSMapD30_DIR"]+@"\Log" + @"\" + cate + @"\" + string.Format(new System.Globalization.CultureInfo("en-US"), "{0:yyyy/MM/dd}", DateTime.Now) + ".txt";
                fileName = fileName.Replace("/", "\\");
                string FileDir = fileName.Substring(0, fileName.LastIndexOf("\\"));

                if (!System.IO.Directory.Exists(FileDir)) System.IO.Directory.CreateDirectory(FileDir);

                using (System.IO.StreamWriter sw = new System.IO.StreamWriter(fileName, true, System.Text.Encoding.GetEncoding(874)))
                {
                    sw.WriteLine(DateTime.Now + " " + text);
                    if (cate == "gps_log")
                    {
                        System.Web.HttpContext context = System.Web.HttpContext.Current;
                        foreach (string key in context.Request.Form.Keys)
                        {
                            sw.WriteLine(key + ": " + context.Request.Form[key]);
                        }
                    }
                }
                
            }
            catch (Exception)
            {
                //Response.Write(ex.ToString());
            }
        }
        public static string ReplaceComma(string input)
        {
            return input.Replace(",", "%2C");
        }
    }
}