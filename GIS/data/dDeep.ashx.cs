using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Drawing;
using System.Drawing.Text;
using System.IO;
using System.Drawing.Drawing2D;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace EBMSMap30.data
{
    /// <summary>
    /// Summary description for iLos
    /// </summary>
    public class dDeep : IHttpHandler
    {
        
        public void ProcessRequest(HttpContext context)
        {
            int w = Convert.ToInt32(context.Request.QueryString["w"]);
            int h = Convert.ToInt32(context.Request.QueryString["h"]);
            string[] points = context.Request.QueryString["points"].Split(',');
            string dt = context.Request.QueryString["dt"];

            string cacheName = "dt_Deep" + context.Request.QueryString["points"] + "_" + w + "_" + h + "_" + dt;
            DT2 dt2 = new DT2();

            List<List<DT2.Point>> _Result = null;
            List<DT2.Point> _Points = new List<DT2.Point>();
            for (int i = 0; i < points.Length; i += 2)
            {
                _Points.Add(new DT2.Point() { X = Convert.ToDouble(points[i]), Y = Convert.ToDouble(points[i + 1]) });
            }

            if (context.Cache[cacheName] != null)
            {
                _Result = context.Cache[cacheName] as List<List<DT2.Point>>;
            }
            else
            {
                _Result = dt2.DEEP(_Points, dt);
                context.Cache.Insert(cacheName, _Result, null, DateTime.Now.AddMinutes(5), TimeSpan.Zero);
            }

            List<string> z = new List<string>();
            foreach (var list_pnts in _Result)
            {
                foreach (var pnt in list_pnts)
                {
                    if (pnt.Z < -1e6 || pnt.Z > 1e6)
                        z.Add("-");
                    else
                        z.Add(string.Format("{0:0.00}", pnt.Z));
                }
            }

            ReturnSet2 returnSet = new ReturnSet2();
            returnSet.result = "OK";
            returnSet.datas = z;
            returnSet.dates = getDates();
            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            context.Response.Write(jSearializer.Serialize(returnSet));
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }


        private List<string> getDates()
        {
            var ret = new List<string>();

            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[uLog].[spDeep_GetDt]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
            {
                ret.Add(string.Format(new System.Globalization.CultureInfo("th-TH"), "{0:dd/MM/yyyy}", DS.Tables[0].Rows[i]["Dt"]));
            }

            return ret;
        }
        
        
    }

    public class ReturnSet2
    {
        public string result { get; set; }
        public object datas { get; set; }
        public object dates { get; set; }
    }
}