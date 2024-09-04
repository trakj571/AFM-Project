using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace EBMSMap30
{
    public class cUsr
    {
        public static bool VerifyToken(string Token)
        {
            EBMSIdentity identity = GetIdentity(Token);
            if (!identity.IsVerify)
            {
                HttpContext.Current.Response.StatusCode = 403;
                HttpContext.Current.Response.Status = "403 Access Denied";
                HttpContext.Current.Response.End();

                return false;
            }
            return true;
        }
        public static EBMSIdentity GetIdentity(string Token)
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
            if (Convert.ToInt32(DS.Tables[0].Rows[0]["UID"]) > 0)
            {
                EBMSIdentity identity = new EBMSIdentity();
                identity.IsVerify = true;
                identity.UID = Convert.ToInt32(DS.Tables[0].Rows[0]["UID"]);
                identity.UserName = DS.Tables[0].Rows[0]["FName"] + " " + DS.Tables[0].Rows[0]["LName"];
                identity.Grp = DS.Tables[0].Rows[0]["Grp"].ToString();
                identity.IsPOI = DS.Tables[0].Rows[0]["IsPOI"].ToString() == "Y";
                identity.IsAdv = DS.Tables[0].Rows[0]["IsAdv"].ToString() == "Y";
                identity.IsAdd = DS.Tables[0].Rows[0]["IsAdd"].ToString() == "Y";
                identity.IsEdit = DS.Tables[0].Rows[0]["IsEdit"].ToString() == "Y";
                identity.IsDel = DS.Tables[0].Rows[0]["IsDel"].ToString() == "Y";
               
                if (identity.IsPOI)
                {
                    identity.IsPin = DS.Tables[0].Rows[0]["IsDropPin"].ToString() == "Y";
                    identity.IsLine = DS.Tables[0].Rows[0]["IsLine"].ToString() == "Y";
                    identity.IsShape = DS.Tables[0].Rows[0]["IsShape"].ToString() == "Y";
                    identity.IsCircle = DS.Tables[0].Rows[0]["IsCircle"].ToString() == "Y";
                }
                else
                {
                    identity.IsPin = false;
                    identity.IsLine = false;
                    identity.IsCircle = false;
                    identity.IsShape = false;
                }
                identity.Permission = DS.Tables[1].Rows[0];
                return identity;
            }

            return new EBMSIdentity() { IsVerify = false };
        }

        public static void CheckLogin()
        {
            System.Web.HttpContext context = System.Web.HttpContext.Current;
            if (UID == 0)
            {
                string returnurl = context.Request.ServerVariables["Url"];
                if (context.Request.ServerVariables["Query_String"] != null && context.Request.ServerVariables["Query_String"] != "")
                    returnurl += "?" + context.Request.ServerVariables["Query_String"];

                context.Response.Redirect("../UR/Login.aspx?returnurl=" + returnurl);
            }
        }

        public static string Identity
        {
            get
            {
                System.Web.HttpContext context = System.Web.HttpContext.Current;
                return context.User.Identity.Name;
            }
        }

        public static int UID
        {
            get
            {
                if (Identity != "")
                {
                    if(Identity.Split(',')[0]=="USR")
                        return int.Parse(Identity.Split(',')[1]);
                }
               return 0;
            }
        }
        public static int InsID
        {
            get
            {
                if (Identity != "")
                {
                    if (Identity.Split(',')[0] == "INS")
                        return int.Parse(Identity.Split(',')[1]);
                }
                return 0;
            }
        }
        public static int PsID
        {
            get
            {
                if (Identity != "")
                {
                    if (Identity.Split(',')[0] == "PS")
                        return int.Parse(Identity.Split(',')[1]);
                }
                return 0;
            }
        }
        public static string Grp
        {
            get
            {
                if (Identity != "")
                {
                    return Identity.Split(',')[2];
                }
                else
                {
                    return "";
                }
            }
        }



        public static string FullName
        {
            get
            {
                if (Identity != "")
                {
                    return Identity.Split(',')[3];
                }
                else
                {
                    return "";
                }
            }
        }

        public static string Token
        {
            get
            {
                if (Identity != "")
                {
                    return Identity.Split(',')[4];
                }
                else
                {
                    return "";
                }
            }
        }

        public static void CheckAuth(string grp)
        {

            if (UID == 0)
            {
                System.Web.HttpContext.Current.Response.Redirect("../UR/Login.aspx");
            }
            else if (Grp != grp)
            {
                if (Grp == "A")
                {
                    System.Web.HttpContext.Current.Response.Redirect("../Admin/Default.aspx");
                }
                if (Grp == "U")
                {
                    System.Web.HttpContext.Current.Response.Redirect("../Default.aspx");
                }
            }
        }

        public static void CheckPermission(string Perms)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(Token)]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spUR_INFO]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@UID"].Value = UID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();

            if (DS.Tables[1].Columns.Contains(Perms) &&
                DS.Tables[1].Rows.Count > 0 && DS.Tables[1].Rows[0][Perms].ToString()=="Y")
            {
                return;
            }

            System.Web.HttpContext.Current.Response.Redirect("../Default.aspx");
        }
    }


    public class EBMSIdentity
    {
        public bool IsVerify { get; set; }
        public int UID { get; set; }
        public string UserName { get; set; }
        public string Grp { get; set; }
        public bool IsPOI { get; set; }
        public bool IsAdv { get; set; }
        public bool IsAdd { get; set; }
        public bool IsEdit { get; set; }
        public bool IsDel { get; set; }
        public bool IsPin { get; set; }
        public bool IsLine { get; set; }
        public bool IsShape { get; set; }
        public bool IsCircle { get; set; }
        public DataRow Permission { get; set; }
    }

    
}