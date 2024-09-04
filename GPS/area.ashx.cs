using EBMSMap30;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace AFMProj.GPS
{
    /// <summary>
    /// Summary description for area
    /// </summary>
    public class area : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            var dr = GetStations(-99,context.Request["afm"]);
            context.Response.Write("{\"User\":\"");
            if (dr.Length > 0)  {
                var path = dr[0]["FTPPath"].ToString().Split('\\');
                if(path.Length>1)
                context.Response.Write(path[1]);
            }
            context.Response.Write("\"}");
        }

        private DataRow[] GetStations(int UID,string UUID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD30"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spEquip_Gets]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = UID;

            SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
            SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

            SqlCmd.SelectCommand.Parameters.Add("@EquType", SqlDbType.VarChar, 50);
            SqlCmd.SelectCommand.Parameters["@EquType"].Value = "STN+STN2";

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            return DS.Tables[0].Select("UUID='" + UUID + "'");
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