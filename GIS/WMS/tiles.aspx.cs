using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

namespace SMPProj.WMS
{
    public partial class tiles : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string layers = Request.QueryString["layers"];
            int z = Convert.ToInt32(Request.QueryString["z"]);
            int x = Convert.ToInt32(Request.QueryString["x"]);
            int y = Convert.ToInt32(Request.QueryString["y"]);

            String fileName = String.Format(@"{0}\Tiles\{1}\{2}\{3}_{4}\{5}_{6}.png",ConfigurationManager.AppSettings["EBMSData"], layers, z, x / 64, y / 64, x, y);
            if (Request.QueryString["f"] != null)
            {
                if (Request.QueryString["f"] == "MT")
                {
                    int ymax = 1 << z;
                    y = ymax - y - 1;
                    fileName = String.Format(@"{0}\Tiles\{1}\{2}\{3}\{4}.png",ConfigurationManager.AppSettings["EBMSData"], layers, z, x, y);
                }
                else if (Request.QueryString["f"] == "GM")
                {
                    fileName = String.Format(@"{0}\Tiles\{1}\Z{2}\{3}_{4}.png",ConfigurationManager.AppSettings["EBMSData"], layers, z, y, x);
                }
            }


            Response.ClearContent();
            Response.ContentType = "image/Png";

            if (System.IO.File.Exists(fileName))
                Response.WriteFile(fileName);
            else if (Request.QueryString["f"] == "GM")
                Response.WriteFile(ConfigurationManager.AppSettings["EBMSData"]+@"\Tiles\Blank.png");
        }
    }
}