using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text.RegularExpressions;

namespace EBMSMap30
{
    public class cText
    {
        static public string StrFromUTF8(string text)
        {
            if (text == null)
                return null;

            Regex rx = new Regex(@"%[uU]([0-9A-Fa-f]{4})");
            string result = text;
            result = rx.Replace(result, delegate(Match match)
            {
                return ((char)Int32.Parse(match.Value.Substring(2), System.Globalization.NumberStyles.HexNumber)).ToString();
            });

            rx = new Regex(@"%([0-9A-Fa-f]{2})");
            result = rx.Replace(result, delegate(Match match)
            {
                return ((char)Int32.Parse(match.Value.Substring(1), System.Globalization.NumberStyles.HexNumber)).ToString();
            });
            return result;
        }
        static public string StrToJSONHex(object txtIn)
        {
            char[] x = txtIn.ToString().ToCharArray();
            string txtOut = "";

            for (int i = 0; i < x.Length; i++)
            {
                int a = x[i];
                Regex pattern = new Regex("[^A-Za-z0-9 .,%_!$^?+*()|/-]");
                if (!pattern.IsMatch("" + x[i]))
                {

                    txtOut += x[i];
                    continue;
                }
                string s = a.ToString("X4");
                txtOut += "\\u" + s;
            }
            return txtOut;
        }

        static public string ReplaceBr(object txtIn)
        {
            return txtIn.ToString().Replace("\r\n", "<br />");
        }
    }
}