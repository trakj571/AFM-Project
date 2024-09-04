<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="maps.aspx.cs" Inherits="EBMSMap30.libs.maps" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Configuration" %>
<% if (tbD.Rows.Count == 0){ %>
    alert("Invalid Access Key");
    $(document).ready(function () {
        $("body").html("");
    });
<%}else{ %>
var geo_server = "<%=ConfigurationManager.AppSettings["GeoServerURL"] %>";
var gis_server = "<%=ConfigurationManager.AppSettings["GISServerURL"] %>";
var ebms_token = "<%=EBMSMap30.cUsr.Token%>";

$("head").append('<script type="text/javascript" src="libs/leaflet-0.7.7/leaflet-src.js"></script>');
$("head").append('<script src="libs/Bing.js"></script>');
$("head").append('<script src="libs/utm.js"></script>');
$("head").append('<script src="libs/mapunit.js"></script>');
$("head").append('<script src="libs/maptools.js"></script>');
$("head").append('<script src="libs/mapui<%=Request.QueryString["m"] %>.js"></script>');
$("head").append('<script src="libs/maplayer.js"></script>');
$("head").append('<script src="libs/cop.js"></script>');
$("head").append('<script src="libs/leaflet-minimap/Control.MiniMap.js"></script>');
$("head").append('<script src="libs/leaflet-label/leaflet.label-src.js"></script>');
$("head").append('<script src="libs/leaflet.rotatedMarker/leaflet.rotatedMarker.js"></script>');
$("head").append('<script src="libs/search.js?v=1.1"></script>');

 $(document).ready(function () {
    <% if (tbD.Rows[0]["isGG"].ToString() == "Y"){ %>
        parent.$("#maptype_src").append("<option value='Google Streets'>Google Streets</option>");
        parent.$("#maptype_src").append("<option value='Google Satellite'>Google Satellite</option>");
        parent.$("#maptype_src").append("<option value='Google Hybrid'>Google Hybrid</option>");
    <%}if (tbD.Rows[0]["isOSM"].ToString() == "Y"){ %>
      parent.$("#maptype_src").append("<option value='OSM Map'>OSM Map</option>");
    
   <%}if (tbD.Rows[0]["isBG"].ToString() == "Y"){ %>
        parent.$("#maptype_src").append("<option value='Bing Road'>Bing Road</option>");
        parent.$("#maptype_src").append("<option value='Bing Arial'>Bing Arial</option>");
        parent.$("#maptype_src").append("<option value='Bing Hybrid'>Bing Hybrid</option>");

     <%} %>
    
        parent.$('#maptype_src').selectpicker('refresh');

    <%
        /*DataRow[] dr = tbL.Select("LyID=1");
        if(dr.Length==0){
             Response.Write("$('#t1').remove();");
             Response.Write("$('#tabSch').remove();");
       }
       
       DataRow[] dr3 = tbL.Select("LyID=2");
        if(dr3.Length==0){
             Response.Write("$('#t3').remove();");
             Response.Write("$('#tabSchPlace').remove();");
        }*/
     %>
      initMap();
 });
<%}%>




