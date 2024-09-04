using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.Security;
using System.Configuration;

namespace EBMSMap30.UR
{
    public partial class NoReg : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string user = "0,G,";
            user += "," + ConfigurationManager.AppSettings["DBName"] + ":noreg:JS";

            System.Web.Security.FormsAuthentication.SetAuthCookie(user, false);
            Response.Redirect("../Search.aspx");

        }
    }
}