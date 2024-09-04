using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EBMSMap30;

namespace OSSProj
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (cUsr.UID > 0)
                Response.Redirect("DashB");
            else
                Response.Redirect("UR/Login.aspx");
        }
    }
}