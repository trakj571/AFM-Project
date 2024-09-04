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
    public class uToken : IHttpHandler
    {
        DataSet DS = new DataSet();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            var uIdentity = GetIdentity(cUsr.Token);

            ReturnSet returnSet = new ReturnSet();
            returnSet.result = "OK";
            returnSet.datas = uIdentity;
            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            context.Response.Write(jSearializer.Serialize(returnSet));
        }

        public TokenIdentity GetIdentity(string Token)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spUR_Token]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(Token);

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            if (Convert.ToInt32(DS.Tables[0].Rows[0]["UID"]) == -110)
            {
                TokenIdentity identity = new TokenIdentity();
                identity.IsVerify = true;
                identity.UID = Convert.ToInt32(DS.Tables[0].Rows[0]["UID"]);
                identity.UserName = DS.Tables[0].Rows[0]["FName"] + " " + DS.Tables[0].Rows[0]["LName"];
                identity.Grp = DS.Tables[0].Rows[0]["Grp"].ToString();
                identity.WLv = Convert.ToDouble(DS.Tables[0].Rows[0]["WLv"]);

               
                return identity;
            }

            return new TokenIdentity() { IsVerify = false };
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        public class TokenIdentity
        {
            public bool IsVerify { get; set; }
            public int UID { get; set; }
            public string UserName { get; set; }
            public string Grp { get; set; }
            public double WLv { get; set; }
        }
    }
}