using EBMSMap30;
using Microsoft.SqlServer.Server;
using NPOI.OpenXmlFormats.Dml.Chart;
using Org.BouncyCastle.Bcpg.OpenPgp;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AFMProj.Service.Talonnet
{
    public partial class GETStat : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
           
            Response.ClearContent();
            if (Cache[Request["cname"]] != null)
                Response.Write(Cache[Request["cname"]].ToString());
            else
                Response.Write("0");
            Response.End();
        }

    }
}