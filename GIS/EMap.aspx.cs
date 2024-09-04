using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text.RegularExpressions;
using EBMSMap.Web;

namespace EBMSMap30
{
    public partial class EMap : System.Web.UI.Page
    {
        public EBMSIdentity uIdentity;
        public DataTable tbDoc;
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        
        public string IsDisabled(int poitype)
        {
            switch (poitype)
            {
                case 1: if (!uIdentity.IsPin) return " disabled class='but-disabled'"; break;
                case 2: if (!uIdentity.IsLine) return " disabled class='but-disabled'"; break;
                case 3: if (!uIdentity.IsShape) return " disabled class='but-disabled'"; break;
                case 4: if (!uIdentity.IsCircle) return " disabled class='but-disabled'"; break;
            }
            return "";
        }

        
        
    }
}