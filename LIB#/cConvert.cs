using System;
using System.Web.Script.Serialization;
using System.Collections;
using System.Collections.Generic;
using System.Data;

namespace EBMSMap30
{
    /// <summary>
    /// Summary description for cAlert.
    /// </summary>
    public class cConvert
    {
        public static int ToInt(object i)
        {
            try
            {
                return Convert.ToInt32(i);
            }
            catch (Exception)
            {

            }
            return 0;
        }
        public static Decimal ToMoney(object text)
        {
            try
            {
                if (text != null)
                {
                    return Convert.ToDecimal(text);
                }
            }
            catch (Exception) { }
            return 0;
        }
        public static Double ToDouble(object text)
        {
            try
            {
                if (text != null)
                {
                    return Convert.ToDouble(text);
                }
            }
            catch (Exception) { }
            return 0;
        }

        public static object ConvertToDateTH(string dt)
        {
            
            if (dt != null && dt != "")
            {
                try
                {
                    if (dt.Split(' ').Length > 1)
                        return ConvertToDateTH(dt.Split(' ')[0], dt.Split(' ')[1]);
                
                    string[] dts = dt.Split('/');
                    DateTime ret = new DateTime(
                        int.Parse(dts[2]) - 543,
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

        public static object ConvertToDateTH(string dt, string tm)
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
                        int.Parse(tms[1]), 0

                        );

                    if (ret > DateTime.Now.AddYears(-100) && ret < DateTime.Now.AddYears(100))
                        return ret;
                }
                catch (Exception)
                { }
            }
            return null;
        }



        public static object ConvertToDate(string dt)
        {

            if (dt != null && dt != "")
            {
                try
                {
                    if (dt.Split(' ').Length > 1)
                        return ConvertToDate(dt.Split(' ')[0], dt.Split(' ')[1]);

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

        public static object ConvertToDate(string dt, string tm)
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
                        int.Parse(tms[1]), 0

                        );

                    if (ret > DateTime.Now.AddYears(-100) && ret < DateTime.Now.AddYears(100))
                        return ret;
                }
                catch (Exception)
                { }
            }
            return null;
        }

        public static string ToJSON(DataTable table)
        {
            var list = new List<Dictionary<string, object>>();

            foreach (DataRow row in table.Rows)
            {
                var dict = new Dictionary<string, object>();

                foreach (DataColumn col in table.Columns)
                {
                    dict[col.ColumnName] = row[col];
                }
                list.Add(dict);
            }
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            return serializer.Serialize(list);
        }
    }
}
