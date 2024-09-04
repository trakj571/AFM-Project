<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EMap.aspx.cs" Inherits="EBMSMap30.EMap" %>
<!DOCTYPE html>
<html>
<head>
	<title></title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="format-detection" content="telephone=no">
	<link href="https://fonts.googleapis.com/css?family=Kanit:300,400,500,600&amp;subset=thai" rel="stylesheet">
	<link rel="stylesheet" href="_inc/icon/style.css">
	<link rel="stylesheet" href="_inc/css/normalize.css">
	<link rel="stylesheet" href="_inc/css/reset.css">
	<link rel="stylesheet" href="_inc/css/bootstrap.css">
	<link rel="stylesheet" href="_inc/css/bootstrap-touchspin.css">
	<link rel="stylesheet" href="_inc/css/bootstrap-select.css">
	<link rel="stylesheet" href="_inc/css/sweetalert2.css">
	<link rel="stylesheet" href="_inc/css/style.css">
	<link rel="stylesheet" href="_inc/css/responsive.css">
    <script src="_inc/js/jquery-3.2.0.min.js"></script>
    <script src="_inc/js/bootstrap.js"></script>
    <script src="_inc/js/bootstrap-touchspin.js"></script>
    <script src="_inc/js/bootstrap-select.js"></script>
    
    <script src="_inc/js/sweetalert2.js"></script>
    <script src="_inc/js/function.1.js"></script>
    <script src="libs/pCop.js"></script>
    <style>
        .afms-sec-maptools {border-top:1px solid #000;border-right:1px solid #000}
    </style>
    <script language=javascript>
       var _layerArr = null;
       var _gisLayerArr = null;

       // window.open("data/gGeocode.ashx?kw=" + encodeURIComponent("คลองสามวา"));
        function getLocation() {
            $("#bToolLoc").click();
        }
        function flyto(address) {
            parent.$("#loading").show();
            $.ajax({
                type: 'GET',
                url: "http://talonnet.co.th/Oss2/GIS/data/gpGeocode.ashx?kw="+ escape(address),
                data: {
                    
                },
                cache: false,
                dataType: 'jsonp',
                jsonpCallback: 'jGeoCCallBack',
                success: function (data) {
                    if (data.status == "OK") {
                        iMap.map.setView([data.results[0].geometry.location.lat, data.results[0].geometry.location.lng], 15);
                    }
                    parent.$("#loading").hide();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }
                
            });
        }

        function getDir(lat,lng,dlat,dlng){
            if(dlat=="") return;
            parent.$("#loading").show();
            //window.open("http://talonnet.co.th/Oss2/GIS/data/gpDirection.ashx?origin="+lat+","+ lng+"&destination="+dlat+","+ dlng);
            $.ajax({
                type: 'GET',
                url: "http://talonnet.co.th/Oss2/GIS/data/gpDirection.ashx?origin="+lat+","+ lng+"&destination="+dlat+","+ dlng,
                data: {
                    
                },
                cache: false,
                dataType: 'jsonp',
                jsonpCallback: 'jDirCallBack',
               
                success: function (data) {
                    $("#bToolLoc").click();
                    if (data.status == "OK") {
                        iMap.showDirection(data);
                        var html="";
                        html += "<h4>"+data.routes[0].summary;
                        for(var i=0;i<data.routes.length;i++){
                            for(var j=0;j<data.routes[i].legs.length;j++){
                                html += "<br />"+data.routes[i].legs[j].distance.text+" ("+data.routes[i].legs[j].duration.text+")";
                                html += "</h4><br /><table>";
                                for(var k=0;k<data.routes[i].legs[j].steps.length;k++){
                                    html+="<tr><td style='border-top:1px solid #ccc;min-height:40px'>"+data.routes[i].legs[j].steps[k].html_instructions+"</td></tr>";
                                }
                                html += "</table>";
                            }
                        }
                        openInfo(html);
                    }
                     parent.$("#loading").hide();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }

            });
        }

      
        function showDir(position,dlat,dlng) {
            var lat = position.coords.latitude;
            var lng = position.coords.longitude;
             var dlat = "<%=Request["Lat"] %>";
            var dlng = "<%=Request["Lng"] %>";
            iMap.map.setView([lat, lng], iMap.map.getZoom());
           
             //window.open("data/gDirection.ashx?origin="+lat+","+ lng+"&destination="+dlat+","+ dlng);
            
            getDir(lat,lng,dlat,dlng);
            
        }

        var _sysgrp='';
        function showNear(position) {
            var lat = position.coords.latitude;
            var lng = position.coords.longitude;
            iMap.map.setView([lat, lng], iMap.map.getZoom());
           
             //window.open("data/gNear.ashx?lat="+lat+"&lng="+ lng+"&sysgrp="+_sysgrp);
            
            $("#loading").show();
            
            $.ajax({
                type: 'POST',
                url: "data/gNear.ashx",
                data: {
                    lat:lat,
                    lng:lng,
                    sysgrp:_sysgrp
                },
                cache: false,
                dataType: 'json',
                success: function (data) {
                    $("#bToolLoc").click();
                    if(data.length>0){
                        getDir(lat,lng,data[0].Lat,data[0].Lng,2);
                        iMap.displayGMarker(data[0].Lat,data[0].Lng,data[0].Name,data[0].URL);
                    }
                    $("#loading").hide();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }

            });
            
        }

        function dirto() {
         
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(showDir);
            } else {
                alert("Geolocation is not supported by this browser.");
            }
        }

        function near(sysgrp) {
            _sysgrp=sysgrp;
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(showNear);
            } else {
                alert("Geolocation is not supported by this browser.");
            }
        }

        function getERSJson(){
            return parent.getERSJson();
        }

        $(function(){
            var tools= '<%=Request["Tools"] %>';
            if(tools=="0"){
                $("#afms-sec-maptools").hide();
                $(".afms-sec-map").css("padding-top","0px");
                $("#mapDiv").css("border","none");
            }
        });
    </script>

</head>
<body style="overflow: hidden;">
   <div class="afms-sec-container afms-page-cop">
   	<div class="afms-sec-content is-active">
			<div class="afms-sec-map">
				<div id="afms-sec-maptools" class="afms-sec-maptools">
					<ul>
						<li>
							<button id=bToolPan class="afms-ic_move" data-toggle="tooltip" data-placement="top" title="เลื่อน"></button>
						</li>
						<li>
							<button id=bToolZoom class="afms-ic_zoom" data-toggle="tooltip" data-placement="top" title="ขยาย"></button>
						</li>
						<li>
							<button id=bToolmDist class="afms-ic_measure_distance" data-toggle="tooltip" data-placement="top" title="วัดระยะทาง"></button>
						</li>
						<li>
							<button id=bToolmArea class="afms-ic_measure_area" data-toggle="tooltip" data-placement="top" title="วัดพื้นที่"></button>
						</li>
						<li>
							<button id=bToolmCir class="afms-ic_measure_circle" data-toggle="tooltip" data-placement="top" title="วัดพื้นที่วงกลม"></button>
						</li>
						<li>
							<button id=bToolLOS class="afms-ic_linear_elevation" data-toggle="tooltip" data-placement="top" title="วัดระดับความสูงเชิงเส้น"></button>
						</li>
						<li>
							<button id=bToolAOS class="afms-ic_measure_circleheight" data-toggle="tooltip" data-placement="top" title="วัดระดับความสูงรูปวงกลม"></button>
						</li>
						<li>
							<button id=bToolHst class="afms-ic_measure_areaheight" data-toggle="tooltip" data-placement="top" title="หาจุดที่สูงที่ดินในพื้นที่"></button>
						</li>
						<li>
							<button id=bToolDim class="afms-ic_brightness" data-toggle="tooltip" data-placement="top" title="ลดแสงในหน้าจอ"></button>
						</li>
						<li>
							<button id=bToolClr class="afms-ic_close_tools" data-toggle="tooltip" data-placement="top" title="ปิดเครื่องมือ"></button>
						</li>
						<li>
							<button id=bToolInfo class="afms-ic_check_locationheight" data-toggle="tooltip" data-placement="top" title="ตรวจสอบตำแหน่งและความสูง"></button>
						</li>
						<li>
							<button id=bToolLoc class="afms-ic_location" data-toggle="tooltip" data-placement="top" title="หาตำแหน่งของตัวเอง"></button>
						</li>
						<li>
							<button id=bToolGoto class="afms-ic_gotolocation" data-toggle="tooltip" data-placement="top" title="เลื่อนไปยังตำแหน่งที่ต้องการ"></button>
						</li>
						<li>
							<button id=bTool3D class="afms-ic_3d" data-toggle="tooltip" data-placement="top" title="แสดงแผนที่แบบ 3 มิติ"></button>
						</li>
						<li>
							<button id=bToolPrn class="afms-ic_print" data-toggle="tooltip" data-placement="top" title="พิมพ์"></button>
						</li>
						<li>
							<button id=bToolSet class="afms-ic_setting" data-toggle="tooltip" data-placement="top" title="ตั้งค่า"></button>
						</li>
						<li style='display:none'>
							<button id=bToolFuSc class="afms-ic_fullscreen" data-toggle="tooltip" data-placement="top" title="ขยายหน้าจอ"></button>
						</li>
						<li>
							<button id=bToolRep class="afms-ic_report" data-toggle="tooltip" data-placement="top" title="รายงาน"></button>
						</li>
						<li class="maptype">
							<div class="afms-field afms-field_select">
								<select id=maptype_src onchange="$('#mapFrame')[0].contentWindow.setMapTypeToMap(this.value)">
									
								</select>
							</div>
						</li>
						<li>
							<p><span id="posbar"></span></p>
						</li>
					</ul>
				</div>

				

				
				<div class="afms-sec-mapevent">
					<div class="afms-mapevent-title">
						Event Viewer
						<button class="afms-btn afms-btn-close afms-ic_close"></button>
					</div>
					<div class="afms-wrapper">
						<div id="mapevent-content" class="afms-mapevent-content">
							
						</div>

						<div class="afms-mapevent-title hidden-lg hidden-md hidden-sm">
							Information
						</div>
						<div class="afms-mapevent-content hidden-lg hidden-md hidden-sm" style="padding-top: 5px;">
							<div class=info_tab></div>
						</div>
						
						
					</div>
					<div class="afms-sec-mapstreet hidden-lg hidden-md">						
					</div>
				</div>

				<div class="afms-sec-mapinfo">
					<div class="afms-mapinfo-title">
						Information
						<button class="afms-btn afms-btn-close afms-ic_close"></button>
					</div>
					<div class="afms-wrapper">
						<div class="afms-mapinfo-content">
                            <div class=info_tab></div>
						
						</div>
					</div>
				</div>

				<div class="afms-sec-mapstreet">	
					<button class="afms-btn afms-btn-close afms-ic_close"></button>		
                    
                   <iframe id="stViewFrame" width="100%" height="100%" frameborder="0" style="border:0"
                        src="StView.aspx" allowfullscreen></iframe>
                        
                        			
				</div>

				

				

				

				<div id="mapDiv" style="width:100%;height:100%;border:1px solid #000">
                    <iframe id="mapFrame" src="Map.aspx?mode=<%=Request["mode"]%>&lat=<%=Request["lat"]%>&lng=<%=Request["lng"]%>&lyids=<%=Request["lyids"]%>" width=100% height=100%></iframe>
                </div>


				

			</div>
		</div>
	</div>
    <iframe id="stViewFrame" width=1 height=1></iframe>
	
</body>

</html>


<script>
    $(function () {
        $('[data-toggle="tooltip"]').tooltip({
            container: 'body',
            trigger: 'hover'
        });
        $('.afms-field_spinner input').TouchSpin({
            min: 0,
            max: 1000,
            step: 0.01,
            decimals: 2,
            boostat: 5,
            buttondown_class: "afms-btn afms-btn-minus afms-ic_minus",
            buttonup_class: "afms-btn afms-btn-plus afms-ic_plus"
        });
        $('.afms-field_select select').selectpicker({
            container: 'body'
        });
        /*alert( window.innerHeight + ' & ' + $('.afms-sec-header').height() + ' = ' + $('.afms-sec-sidebar').innerHeight())*/

    });
</script>