
<%if(Tools.Value!="0"){ %>
<!--div>
    เลือกตำแหน่งปัจจุบัน <a href='javascript:$("#iMap")[0].contentWindow.getLocation()'><img src='../GIS/_Inc/icon/svg/ic_location.svg' width=24 align=absbottom /></a> 
     หรือ ค้นหาสถานที่ <input id=GoeKw type=text style='font-size:12px;width:130px;border-bottom:2px solid #c00'> 
     <a href='javascript:$("#iMap")[0].contentWindow.flyto(document.getElementById("GoeKw").value)' >ค้นหา</a>

     <%if (Lat.Value != "")
       { %>
            &nbsp; <a href='javascript:javascript:$("#iMap")[0].contentWindow.dirto()' >ขอเส้นทาง</a>
     <%} %>
      <%if (Request["sysgrp"] == "ar" || Request["sysgrp"] == "ann")
       { %>
            &nbsp; <a href='javascript:javascript:$("#iMap")[0].contentWindow.near("<%=Request["sysgrp"]%>")' >สนามสอบที่ใกล้ที่สุด</a>
     <%} %>
     <span id=loading style='display:none'><img src='../GIS/images/loading.gif' width=16 /></span>
  </!--div-->
  <%} %>


                   
<iframe id=iMap name=iMap src="../GIS/EMap.aspx?mode=0&lat=<%=Lat.Value %>&lng=<%=Lng.Value %>&tools=<%=Tools.Value %>" width=100% height=<%=Tools.Value=="1"?"500":"460" %> frameborder=0></iframe>

