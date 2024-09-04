using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace SMPProj
{
    public class cOnline
    {
        private const string COUNTER = "session_counter";
        
        public static string GetOnline()
        {
            string ret = "";
            try
            {
                ret = string.Format("{0:#,###}", Convert.ToInt32(HttpContext.Current.Application.Get("session_counter")));
            }
            catch (Exception) { }

            return ret;
        }

        public static void AddOnline()
        {
            try
            {
                HttpContext.Current.Application.Lock();
                if (HttpContext.Current.Application[COUNTER] == null)
                {
                    HttpContext.Current.Application.Set(COUNTER, 0);
                }
                int counter = ((int)HttpContext.Current.Application.Get(COUNTER) + 1);
                HttpContext.Current.Application.Set(COUNTER, counter);
                HttpContext.Current.Application.UnLock();

                Add2DB();
            }
            catch (Exception) { }
        }

        public static void RemoveOnline()
        {
            try
            {
                HttpContext.Current.Application.Lock();
                int counter = ((int)HttpContext.Current.Application.Get(COUNTER) - 1);
                HttpContext.Current.Application.Set(COUNTER, counter);
                HttpContext.Current.Application.UnLock();
            }
            catch (Exception) { }
        }

        private static void Add2DB()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spVS__AddLog]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
        }

        public static DataSet GetVSLog()
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spVS__GetLog]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            return DS;
        }
    }
}