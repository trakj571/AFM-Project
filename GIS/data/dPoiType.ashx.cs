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
    public class dPoiType : IHttpHandler
    {
        DataSet DS = new DataSet();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            ExecDB(context);
            WriteJS(context);
        }

        private void ExecDB(HttpContext context)
        {
            if (!cUsr.VerifyToken(cUsr.Token))
            {
                context.Response.Write(cUtils.getJSON_ERR("403"));
                context.Response.End();
                return;
            }
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spPOI_CType]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@Place", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Place"].Value = HttpContext.Current.Request.QueryString["place"];

            SqlCmd.Fill(DS);
            SqlConn.Close();

        }

        private void WriteJS(HttpContext context)
        {
            List<GroupSet> grps = new List<GroupSet>();

            for (int i = 0; i < DS.Tables[0].Rows.Count; i++)
            {
                GroupSet grp = new GroupSet();
                grp.GrpID = Convert.ToInt32(DS.Tables[0].Rows[i]["CGID"]);
                grp.Name = DS.Tables[0].Rows[i]["Name"].ToString();
                DataRow[] dr = DS.Tables[1].Select("pCGID=" + grp.GrpID);
                grp.Children = new List<TypeSet>();
                for (int j = 0; j < dr.Length; j++)
                {
                    grp.Children.Add(new TypeSet()
                    {
                        TypeID = Convert.ToInt32(dr[j]["TypeID"]),
                        Name = dr[j]["Name"].ToString(),
                        PoiType = Convert.ToInt32(dr[j]["PoiType"]),
                        Icon = cUtils.IconUrl(dr[j]["TypeID"], "*", cUsr.Token)
                    });
                }
                grps.Add(grp);

            }

            ReturnSet returnSet = new ReturnSet();
            returnSet.result = "OK";
            returnSet.datas = grps;
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