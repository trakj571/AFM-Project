<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Map.aspx.cs" Inherits="EBMSMap30.GIS.Map" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
   <!--#include file="_Inc/Title.asp"-->
   <!--#include file="_Inc/_libs.adm.asp"-->
   <script src="libs/flowplayer/flowplayer-3.2.13.min.js"></script>
   <script src="libs/flowplayer/flowplayer.ipad-3.2.13.min.js"></script>

   <script src="libs/Polyline.encoded.js"></script>
   <script src="libs/mapdir.js"></script>
   <script src="libs/coptools.js?v=1.1"></script>
<script language=javascript>
    var map;
    var ispoi = <%=uIdentity.IsPOI?"true":"false" %>;
    var mode = '<%=Request["mode"] %>';
    var lat = '<%=Request["lat"] %>';
    var lng = '<%=Request["lng"] %>';
    var rmt_lyids = '<%=Request["lyids"] %>';
    function initMap() {
        //if(parent.$(".afms-sec-maptools"))
               // parent.$(".afms-mappanel").css("margin-top", (parent.$(".afms-sec-maptools").outerHeight()) + "px");
         $(window).resize(function (e) {
              setWindowSize();
             // if(parent.$(".afms-sec-maptools") && parent.$(".afms-sec-maptools").outerHeight())
               // parent.$(".afms-mappanel").css("margin-top", (parent.$(".afms-sec-maptools").outerHeight()) + "px");
         });
        if (window.screen.width > 1000) {
            $("#layout").css("width", (window.screen.width - 5) + "px");
        } else {
            $("#layout").css("width", (1000 - 5) + "px");
        }
        $("#layout").show();
        $("#map_container").show();
        initialPanelWin();
        
        map = E$.map('map', { zoomControl: false });
        if(lat!='')
            map.setView([parseFloat(lat), parseFloat(lng)], 14);
        else
            map.setView([13.75, 100.5], rmt_lyids==""?11:6);

        addMapToolsControl();
        setMapTypeToMap("Google Streets");

        //setLayerPanel();
        setWindowSize();
        //setBoundTab();
        //setGISLayerTab();
        //setLayerTab();
        //setPlaceTab();
        //setEventTab();
        if(ispoi){ 
            //loadInputForm();
        }
        //$(".su").hide();
        //InitDragDrop();
        setTimeout(setWindowSize, 100);
        //schInit();
        //doCheckToken();
         initRoute();
        //map.setView([0.8, 100.9], 8);
        //$("#los-disp").show();
        
        if(mode=="1"){
            var crosshairIcon = L.icon({
                iconUrl: 'images/icons/target.png',
                iconSize:     [32, 32], // size of the icon
                iconAnchor:   [16, 16], // point of the icon which will correspond to marker's location
            });
            var crosshair = new L.marker(map.getCenter(), {icon: crosshairIcon, clickable:false});
            crosshair.addTo(map);

            // Move the crosshair to the center of the map when the user pans
             map.on('move', function(e) {
                 crosshair.setLatLng(map.getCenter());
                 if (parent && parent.parent)
                     parent.parent.setLatLng(map.getCenter().lat, map.getCenter().lng);
             });
            if (parent && parent.parent)
                parent.parent.setLatLng(map.getCenter().lat, map.getCenter().lng);
            map.scrollWheelZoom.disable();
        }

        if(lat!=""){
            var placeIcon = L.icon({
                iconUrl: 'images/icons/marker.png',
                iconSize:     [32, 32], // size of the icon
                iconAnchor:   [16, 32], // point of the icon which will correspond to marker's location
            });
            var place = new L.marker(map.getCenter(), {icon: placeIcon, clickable:false});
            place.addTo(map);

        }


        /*
        var tms_ne = L.tileLayer('http://localhost:8080/geoserver/gwc/service/tms/1.0.0/AFM%3AThaiAirRoute_Line@EPSG:900913@png/{z}/{x}/{y}.png', {
            tms: true
        }).addTo(map);
        */

        if(rmt_lyids!=""){
            addPoiIDs(rmt_lyids);
        }
    }
    var isOTA = "";
    var mMode = "";
    function switchMode(){
       
    }
    function dispDoc(){
        $.fancybox($("#docDiv").html(), {
            'width': 400,
            'height': 300,
            'autoScale': false,
            'transitionIn': 'none',
            'transitionOut': 'none'
        });
    }
     function showDirection(data,dmode){
        if(direction_marker)
            map.removeLayer(direction_marker);
            direction_marker = L.Polyline.fromEncoded(data.routes[0].overview_polyline.points, {
                weight: 4,
                color: '#00f'
            });
            map.addLayer(direction_marker);
            map.fitBounds(direction_marker.getBounds());
    }

     
</script>
</head>
<body style='overflow:hidden'>
<div id=outer_layout>
<div id=layout style='display:none'>
<div id="map_container">
 <div>
 <div id="map"></div>
 <div id="los-disp">
    <div id=los-disp_panel class="css-panes">
    <div id=gps-graph_content class="pscroll3"></div>
    <div id=gps-data_content class="pscroll3"></div>
    <div id=los-disp_content1 class="pscroll3"></div>
    </div>
 </div>
 </div>


  <div id=maptoolctl>
   <%if (!IsMobile())
     {%>
    <table>
    <tr><td><button id=bToolPin title="Drop pin" <%=IsDisabled(1) %>><img src='images/icons/b_pin.png' /></button></td></tr>
     <tr><td><button id=bToolLine title="Line" <%=IsDisabled(2) %>><img src='images/icons/b_line.png' /></button></td></tr>
     <tr><td><button id=bToolShape  title="Shape" <%=IsDisabled(3) %>><img src='images/icons/b_shape.png' /></button></td></tr>
     <tr><td><button id=bToolCir  title="Circle" <%=IsDisabled(4) %>><img src='images/icons/b_cir.png' /></button></td></tr>
     </table>
     <%} %>
    
    

  </div>
</div>
</div>

 <div id="dpi-test" style='width:1in;height:1in;display:none'></div>
 <div id=MsgBox></div>
</body>
</html>