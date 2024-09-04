<%@ Import NameSpace ="System.Data" %>
<%@ Import NameSpace="System.Data.SqlClient" %>
<%@ Import NameSpace="System.Configuration" %>
<%@ Import NameSpace="System.Web.Script.Serialization" %>


<script language="c#" runat="server">


protected void Page_Load(object sender, EventArgs e)
{
   
    SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
    SqlDataAdapter SqlCmd = new SqlDataAdapter("dms.spSvcRomote", SqlConn);
    SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

    SqlCmd.SelectCommand.Parameters.Add("@Key", SqlDbType.VarChar,50);
    SqlCmd.SelectCommand.Parameters["@Key"].Value = Request["ServiceKey"];
        
    DataSet DS = new DataSet();
    SqlCmd.Fill(DS);
    SqlConn.Close();
    Response.ClearContent();
    Response.Write(EBMSMap30.cConvert.ToJSON(DS.Tables[0]));
    Response.End();

    
    

}
</script>