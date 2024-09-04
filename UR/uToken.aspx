<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import NameSpace="System.Data" %>
<%@ Import NameSpace="System.Data.SqlClient" %>
<%@ Import NameSpace="EBMSMap30" %>
<%@ Import NameSpace="System.Configuration" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script lang="C#" runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            var id = cUsr.GetIdentity(Request["token"]);
            
            if (id.IsVerify)
            {
                string user = "USR," + id.UID + "," + id.Grp + "," + id.UserName;
                user += "," + ConfigurationManager.AppSettings["DBName"] + ":" + cUtils.GetToken(Request["token"]) + ":JS";

                
                    System.Web.Security.FormsAuthentication.SetAuthCookie(user, false);
                    if (id.Grp == "A")
                    {
                        Response.Redirect("../Admin");
                    }
                    else
                    {
                        Response.Redirect("../Default.aspx");
                    }
                
            }
        }

      
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
