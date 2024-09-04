
<script language=javascript>
    function alertLoc() {
        retriveLatLon();
        alert(document.getElementById("Lat").value + "," + document.getElementById("Lng").value);
    }
    function retriveLatLon() {
        var iframe = document.getElementById("iMap");
        var center = iframe.contentWindow.iMap.map.getCenter();
        if (center) {
            document.getElementById("Lat").value = center.lat;
            document.getElementById("Lng").value = center.lng;
        }
    }
   
</script>

<div>
    <!--เลือกตำแหน่งปัจจุบัน <a href='javascript:$("#iMap")[0].contentWindow.getLocation()'><img src='../GIS/_Inc/icon/svg/ic_location.svg' width=24 align=absbottom /></a> 
     หรือ ค้นหาสถานที่ <input id=GoeKw type=text style='font-size:12px;width:160px;border-bottom:2px solid #c00'> 
     <a href='javascript:$("#iMap")[0].contentWindow.flyto(document.getElementById("GoeKw").value)' >ค้นหา</a>
     <span id=loading style='display:none'><img src='../GIS/images/loading.gif' width=16 /></span>
    -->
  </div>
<iframe id=iMap name=iMap src="../GIS/EMap.aspx?mode=1&lat=<%=Lat.Value %>&lng=<%=Lng.Value %>" width=100% height=500></iframe>

