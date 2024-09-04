using System;
using System.Collections.Generic;

namespace EBMSMap30
{
	/// <summary>
	/// Summary description for cAlert.
	/// </summary>
	public class Comm
	{
		public static void Alert(string text)
		{
			System.Web.HttpContext.Current.Response.Write("<script language=javascript>alert('"+text+"');</script>");
			//System.Web.HttpContext.Current.Response.End();
		}
		
		public static void Alert(string text,string Url)
		{
			System.Web.HttpContext.Current.Response.Write("<script language=javascript>alert('"+text+"');document.location.href='"+Url+"';</script>");
			System.Web.HttpContext.Current.Response.End();
		}
		public static void Alert(object obj,string Url)
		{
			string text="Update Complete";
			if(Convert.ToInt32(obj)<0)
				text="Uppdate Error";

			System.Web.HttpContext.Current.Response.Write("<script language=javascript>alert('"+text+"');document.location.href='"+Url+"';</script>");
			System.Web.HttpContext.Current.Response.End();
		}
		
		public static object ConvertToInt(string val)
		{
			try
			{
				return int.Parse(val!=""?val:"0");
			}
			catch(Exception){}
			return 0;
		}
        public static object ConvertToMoney(string val)
        {
            try
            {
                return Decimal.Parse(val != "" ? val : "0");
            }
            catch (Exception) { }
            return 0;
        }
        public static object ConvertToDouble(string val)
        {
            try
            {
                return Double.Parse(val != "" ? val : "0");
            }
            catch (Exception) { }
            return 0;
        }
		public static object ConvertToDateTH(string dt)
		{
			if(dt!=null && dt!="")
			{
				try
				{
					string[] dts=dt.Split('/');
					DateTime ret= new DateTime(
						int.Parse(dts[2])-543,
						int.Parse(dts[1]),
						int.Parse(dts[0]));

					if(ret>DateTime.Now.AddYears(-100) && ret<DateTime.Now.AddYears(100))
						return ret;
				}
				catch(Exception)
				{}
			}
			return null;
		}

        public static object ConvertToDateTH(string dt,string tm)
        {
            if (dt != null && dt != "")
            {
                try
                {
                    string[] dts = dt.Split('/');
                    string[] tms = tm.Split(':');
                    DateTime ret = new DateTime(
                        int.Parse(dts[2]) - 543,
                        int.Parse(dts[1]),
                        int.Parse(dts[0]),
                        int.Parse(tms[0]),
                        int.Parse(tms[1]),0
                        
                        );

                    if (ret > DateTime.Now.AddYears(-100) && ret < DateTime.Now.AddYears(100))
                        return ret;
                }
                catch (Exception)
                { }
            }
            return null;
        }

        public static double DateTimeToUnixTimestamp(DateTime dateTime)
        {
            return (dateTime - new DateTime(1970, 1, 1).ToLocalTime()).TotalSeconds;
        }

        public static object ConvertToDate(string dt)
        {
            if (dt != null && dt != "")
            {
                try
                {
                    string[] dts = dt.Split('/');
                    DateTime ret = new DateTime(
                        int.Parse(dts[2]),
                        int.Parse(dts[1]),
                        int.Parse(dts[0]));

                    if (ret > DateTime.Now.AddYears(-100) && ret < DateTime.Now.AddYears(100))
                        return ret;
                }
                catch (Exception)
                { }
            }
            return null;
        }

        public static object ConvertToDate(string dt,string tm)
        {
            if (dt != null && dt != "")
            {
                try
                {
                    string[] dts = dt.Split('/');
                    string[] tms = tm.Split(':');
                    DateTime ret = new DateTime(
                        int.Parse(dts[2]),
                        int.Parse(dts[1]),
                        int.Parse(dts[0]),
                         int.Parse(tms[0]),
                        int.Parse(tms[1]),
                        int.Parse(tms[2]));

                    if (ret > DateTime.Now.AddYears(-100) && ret < DateTime.Now.AddYears(100))
                        return ret;
                }
                catch (Exception)
                { }
            }
            return null;
        }
		
		public static string AppendUrl(string url,string qs)
		{
			string[] qss=qs.Split(',');
			for(int i=0;i<qss.Length;i++)
			{
				if(qss[i].IndexOf("=")>-1)
				{
					if(url.IndexOf("?")>-1)
					{
						url=url+"&"+qss[i];
					}
					else
					{
						url=url+"?"+qss[i];
					}
				}
				else if(System.Web.HttpContext.Current.Request.QueryString[qss[i]]!=null)
				{
					if(url.IndexOf("?")>-1)
					{
						url=url+"&"+qss[i]+"="+System.Web.HttpContext.Current.Request.QueryString[qss[i]];
					}
					else
					{
						url=url+"?"+qss[i]+"="+System.Web.HttpContext.Current.Request.QueryString[qss[i]];
					}
				}
				
				
			}
			return url;
		}

        static Random ra = new Random();
        static public string RandPwd(int n)
        {
            
            string plan = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            string pwd = "";
            for (int i = 0; i < n; i++)
            {
                pwd += plan.Substring(ra.Next(plan.Length - 1), 1);
            }
            return pwd;
        }


        static public string GetFilesPath(object id,string ext)
        {
            string sid = string.Format("{0:000000000}", Convert.ToInt32(id));
            return sid.Substring(0, 3) + "\\" + sid.Substring(3, 3) + "\\" + sid.Substring(6, 3) + "." + ext;
        }

        static public string ThaiNum(string n)
        {
            n = n.Replace("1", "ס");
            n = n.Replace("2", "ע");
            n = n.Replace("3", "ף");
            n = n.Replace("4", "פ");
            n = n.Replace("5", "ץ");
            n = n.Replace("6", "צ");
            n = n.Replace("7", "ק");
            n = n.Replace("8", "ר");
            n = n.Replace("9", "ש");
            n = n.Replace("0", "נ");
            n = n.Replace(".ננ", ".-");
            return n;
        }
	}


    public class CSVData
    {
        public int fID { get; set; }
        public int rowNum { get; set; }
        public string A { get; set; }
        public string B { get; set; }
        public string C { get; set; }
        public string D { get; set; }
        public string E { get; set; }
        public string F { get; set; }
        public string G { get; set; }
        public string H { get; set; }
        public string I { get; set; }
        public string J { get; set; }
        public string K { get; set; }
        public string L { get; set; }
        public string M { get; set; }
        public string N { get; set; }
        public string O { get; set; }
        public string P { get; set; }
        public string Q { get; set; }
        public string R { get; set; }
        public string S { get; set; }
        public string T { get; set; }
        public string U { get; set; }
        public string V { get; set; }
        public string W { get; set; }
        public string X { get; set; }
        public string Y { get; set; }
        public string Z { get; set; }
        public DateTime dtAdd { get; set; }
    }

    public class CSVDatas : List<CSVData>
    {

    }
}
