<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Logout.aspx.cs" Inherits="EBMSMap30.UR.Logout" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script language=javascript>
        //
        if ((location.href + "").indexOf("192.168.27.11") > -1)
            document.location.href = "http://192.168.27.12/Port/UR/Logout.aspx";
        else if ((location.href + "").indexOf("192.168.27.12") > -1)
            document.location.href = "http://192.168.27.11/Port/UR/Login.aspx";
        else
            document.location.href = "../UR/Login.aspx";
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
