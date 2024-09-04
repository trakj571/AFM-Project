using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace EBMSMap30.data
{
    /// <summary>
    /// Summary description for dPoiSch
    /// </summary>
    public class dLandUse : IHttpHandler
    {
        public class Area
        {
            public string name;
            public double y;
            public string code;
            public string color;
        }
        public class LandUseSet
        {
            public int Yr { get; set; }
            public List<Area> Area { get; set; }
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
            
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spLand_Use]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@poiID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@poiID"].Value = context.Request["poiid"];

            SqlCmd.Fill(DS);
            SqlConn.Close();
        }

        private void WriteJS(HttpContext context)
        {

            List<LandUseSet> landuseset = new List<LandUseSet>();

            landuseset.Add(getLandArea(0));
            landuseset.Add(getLandArea(2545));
            landuseset.Add(getLandArea(2554));

            ReturnSet returnSet = new ReturnSet();
            returnSet.result = "OK";
            returnSet.datas = landuseset;
            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            context.Response.Write(jSearializer.Serialize(returnSet));
        }
        private LandUseSet getLandArea(int Yr)
        {
            string layer = "SMPK:PLLU";
            if(Yr==2545)
                layer = "SMPK:LU2545";
            else if (Yr == 2554)
                layer = "SMPK:LU2554";

            LandUseSet landuse = new LandUseSet();
            landuse.Yr = Yr;
            landuse.Area = new List<Area>();
            DataRow[] dr = DS.Tables[0].Select("Yr=" + Yr);
            
            for (int i = 0; i < dr.Length; i++)
            {
                double Area = Convert.ToDouble(dr[i]["Area"]);
                landuse.Area.Add(new Area()
                {
                    code=dr[i]["Code"].ToString(),
                    name = string.Format("{0}<br />({1:#,##0.0} ไร่)",dr[i]["Descr"], Area / 1600),
                    y = Area,
                    color = GetColorFromCode(layer,dr[i]["Code"].ToString())
                });
            }

            return landuse;
        }
        private string GetColorFromCode(string layer,string code)
        {
            DefCL defcl = new DefCL();
            if (defcl.DefSet.ContainsKey(layer))
            {
                string[] defs = defcl.DefSet[layer] as string[];
                for (int i = 0; i < defs.Length; i += 3)
                {
                    string[] codes = defs[i + 2].Split(',');
                    for (int j = 0; j < codes.Length; j++)
                    {
                        if (code.StartsWith(codes[j]))
                        {
                            if (defs[i] == "PLLU1")
                                return "#7030A0";
                            if (defs[i] == "PLLU2")
                                return "#00B050";
                           
                            return defs[i];
                        }
                    }

                }
            }
            return "#cccccc";
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