<%@ Page Language="C#" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <input type=hidden id=Lat runat=server />
    <input type=hidden id=Lng runat=server />
    <input type=hidden id=Tools runat=server value="1" />
    <!--#include file="../GIS/EMapView.asp"-->
    </div>
    </form>


    <iframe id=iMap name=iMap src="../GIS/EMap.aspx?mode=0&lat=13.75&lng=100.5" width=800 height=500 frameborder=0></iframe>
</body>
</html>