using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using EBMSMap30;
using System.Net;
using System.Web.Script.Serialization;

namespace AFMProj.FMS
{
    public partial class PlayRec2 : System.Web.UI.Page
    {
        public DataTable tbD;
        public string StreamURL;
        protected void Page_Load(object sender, EventArgs e)
        {
            StreamURL = "http://lmtr.nbtc.go.th" + Request["datapath"] + Request["playlist"];
        }

       

    }
}