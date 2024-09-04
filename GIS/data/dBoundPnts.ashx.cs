using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;

namespace EBMSMap30.data
{
    /// <summary>
    /// Summary description for dBoundInfo
    /// </summary>
    public class dBoundPnts : IHttpHandler
    {
        public class Point
        {
            public double X { get; set; }
            public double Y { get; set; }
        }

        DataSet DS = new DataSet();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            ExecDB(context);
            WriteJS(context);
        }

        private void ExecDB(HttpContext context)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapS"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spBound_GetPnts]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Code", SqlDbType.VarChar, 20);
            SqlCmd.SelectCommand.Parameters["@Code"].Value = context.Request["Code"];

            SqlCmd.Fill(DS);
            SqlConn.Close();
         
        }
        private void WriteJS(HttpContext context)
        {
            List<List<Point>> ret = new List<List<Point>>();

            for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
            {
                string[] xys = DS.Tables[0].Rows[i]["Points"].ToString().Split('$');

                foreach (string xy in xys)
                {
                    string[] xy1 = xy.Split(',');
                    List<Point> list = new List<Point>();
                    int n =  xy1.Length / 1000;
                    for (int j = 0; j < xy1.Length; j += 2)
                    {
                        if (j % (n + 2) != 0)
                            continue;
                        try
                        {
                            list.Add(new Point() { X = Convert.ToDouble(xy1[j]), Y = Convert.ToDouble(xy1[j + 1]) });
                        }
                        catch (Exception ex) { }
                    }
                    ret.Add(list);
                }
            }

            ReturnSet returnSet = new ReturnSet();
            returnSet.result = "OK";
            returnSet.datas = ret;
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
    }
}