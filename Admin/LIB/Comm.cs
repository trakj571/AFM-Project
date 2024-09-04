using System;

namespace EBMSMap.Web
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
		
		public static object ConvertToMoney(string val)
		{
			try
			{
				return Decimal.Parse(val!=""?val:"0");
			}
			catch(Exception){}
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
	}
 
}
