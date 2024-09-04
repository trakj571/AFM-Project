<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Cop.aspx.cs" Inherits="EBMSMap30.Cop" %>
<!DOCTYPE html>
<html>
<head>
	<title></title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="format-detection" content="telephone=no">
	<link href="https://fonts.googleapis.com/css?family=Kanit:300,400,500,600&amp;subset=thai" rel="stylesheet">
	<link rel="stylesheet" href="../_inc/icon/style.css">
	<link rel="stylesheet" href="../_inc/css/normalize.css">
	<link rel="stylesheet" href="../_inc/css/reset.css">
	<link rel="stylesheet" href="../_inc/css/bootstrap.css">
	<link rel="stylesheet" href="../_inc/css/bootstrap-touchspin.css">
	<link rel="stylesheet" href="../_inc/css/bootstrap-select.css">
	<link rel="stylesheet" href="../_inc/css/sweetalert2.css">
	<link rel="stylesheet" href="../_inc/css/style.css">
     <link rel="stylesheet" href="../_inc/css/jstree.css">
	
	<link rel="stylesheet" href="../_inc/css/responsive.css">
    <script src="../_inc/js/jquery-3.2.0.min.js"></script>
    <script src="../_inc/js/bootstrap.js"></script>
    <script src="../_inc/js/bootstrap-touchspin.js"></script>
    <script src="../_inc/js/bootstrap-select.js"></script>
    
    <script src="../_inc/js/sweetalert2.js"></script>
    <script src="../_inc/js/function.cop.js"></script>
    <script src="libs/pCop.js?v=1.1"></script>
    <script type="text/javascript" src="../_inc.a/js/jstree.min.js"></script>
   <link rel="stylesheet" href="../_inc.a/css/jstree.css">
	<script src="../_inc/js/bluebird.min.js"></script>
     <script type="text/javascript" src="../_inc/js/bootstrap-datetimepicker.js"></script>
    <link rel="stylesheet" href="../_inc/css/bootstrap-datetimepicker.css">
    <style>
        .fade {opacity:0.3;}
		 #gisLayerTree a,#layerTree a {font-size:11px!important}
    </style>

     <script language=javascript src="../_inc/js/dpv2.js?v=1.1"></script>
    <script language=javascript src="../_inc/js/pvscp2.js?v=1.1"></script>
   

   <script language=javascript>
       var _layerArr = <%=GetLayers("0") %>;
       var _gisLayerArr = <%=GetGISLayers("0") %>;

       $(function(){
            $('.afms-field_datetimepicker input').datetimepicker({
                    orientation: "bottom left",
                    format: "dd/mm/yyyy hh:ii",
                    autoclose: true
                });

                //$(window).resize(function () {
                 //   $("body").css("height",($(window).height()-100)+"px");
                //});
                //setToTop();


                setProv2('sProv2', '00');
                setAumphur2('sAumphur2', '00', '0000');
                setTumbon2('sTumbon2', '0000', '000000');

           updateSubSelect('sReg2', 'sArea2', '0');

           $("#sReg2").change(function () {
               updateSubSelect(this.id, 'sArea2');
           });
       });

       function setToTop(){
            setTimeout(function(){
                window.scrollTo(0, 0);
                setToTop();
            },100);
       }
       function updateSubSelect(ctlid, subid, selected) {
           var val = $("#" + ctlid).val();
           $("#" + subid).prop("disabled", true);
           $("#" + subid).html("<option value='0'>=== เลือก ===</option>");
           $("#" + subid + "_raw > option").each(function () {
               var vals = this.value.split(',');
               if (vals[0] != "0" && vals[0] == val) {
                   var valx = vals[1];

                   $("#" + subid).append("<option value='" + valx + "' " + (selected && selected == valx ? " selected" : "") + ">" + this.text + "</option>");
                   $("#" + subid).prop("disabled", false);
               }
           });
           $("#" + subid).selectpicker('refresh');
       }
   </script>

</head>
<body style="overflow: hidden;">
	<div class="afms-sec-container afms-page-cop">
		<div class="afms-sec-header">
			<img src="../img/logo_s.png" srcset="../img/logo@2x.png 2x">
			<div class="afms-header-text">
				<h1><span>NBTC AUTOMATIC FREQUENCY</span> MONITORING SYSTEM</h1>
				<h2>สำนักงานคณะกรรมการกิจการกระจายเสียง กิจการโทรทัศน์ และกิจการโทรคมนาคมแห่งชาติ</h2>
			</div>

			<ul class="afms-sec-menu hidden-sm hidden-xs">
				<li><a href="../DASHB">DASHBOARD</a></li>
				<li><a href="../GIS/Cop.aspx" class="is-active">COP</a></li>
				<li><a href="../FMS">FMS</a></li>
                <li><a href="../DMS">DMS</a></li>
				<li class="afms-menu-user">
				<img src="../img/user.png" alt="" class="img-circle">
				<%=EBMSMap30.cUsr.FullName%>
				<a href="../UR/Logout.aspx" class="afms-ic_exit"></a></li>
			</ul>

			<button class="afms-btn afms-btn-menu afms-btn-secondary afms-ic_menu hidden-md hidden-lg"></button>
		</div>

		<div class="afms-sec-content">
			<div class="afms-sec-sidebar">
				<ul class="nav nav-tabs" role="tablist">
                    <%if(uIdentity.Permission["IsCopEquipment"].ToString()=="Y") {%>
					<li class="active"><a href="#station" aria-controls="station" role="tab" data-toggle="tab">Equip.</a></li>
                    <%} %>
					<li><a href="#event" aria-controls="event" role="tab" data-toggle="tab">Event</a></li>
					<li><a href="#layer" aria-controls="layer" role="tab" data-toggle="tab">Layer</a></li>
					<li><a href="#history" aria-controls="history" role="tab" data-toggle="tab">History</a></li>
                    <li><a href="#route" aria-controls="route" role="tab" data-toggle="tab">Route</a></li>
				</ul>

				<div class="tab-content">
					 <%if(uIdentity.Permission["IsCopEquipment"].ToString()=="Y") {%>
					<div role="tabpanel" class="tab-pane active" id="station">
						<div id=tb_Station class="col-md-12">
						</div>
					</div>
                    <%} %>
					<div role="tabpanel" class="tab-pane" id="event">
						<div class="col-md-12">
							<div class="afms-field afms-field_select">
								<label>Equipment</label>
								<select id=eStation onchange="syncEvent();">
									<option value=''>..ทั้งหมด..</option>
								</select>
								<span class="bar"></span>
							</div>
						</div>

						<div class="col-md-12">
							<div class="afms-field afms-field_select">
								<label>Event</label>
								<select id=eEvent style='width:150px'  onchange="syncEvent();">
                                    <option value='0'>..ทั้งหมด..</option>
                                    <option value='1'>พบในฐานข้อมูล</option>  
                                    <option value='2'>ไม่พบในฐานข้อมูล</option>  
                                    

                                 </select>
								<span class="bar"></span>
							</div>
						</div>

						<div id=tb_Event class="col-md-12">
							
						</div>
					</div>
					<div role="tabpanel" class="tab-pane" id="layer">
						<div class="col-md-12">
							<ul class="nav nav-tabs" role="tablist" style="margin-top: 10px;">
								<li class="active"><a href="#vector" aria-controls="vector" role="tab" data-toggle="tab">ค้นหาจากฐานข้อมูล</a></li>
								<li><a href="#raster" aria-controls="raster" role="tab" data-toggle="tab">แสดงชั้นข้อมูล</a></li>
							</ul>
							<div class="tab-content">
								<div role="tabpanel" class="tab-pane active" id="vector">
									<div class="afms-field afms-field_radio">
										<label class="radio-inline radio-searchtype_detail">
											<input type="radio" id="sch_type_d" name="searchtype" value="ค้นหารายละเอียด" checked="">
											<div class="box"></div>
											<div class="check"></div>
											ค้นหารายละเอียด
										</label>

										<label class="radio-inline radio-searchtype_direction">
											<input type="radio" id="sch_type_l" name="searchtype" value="ค้นหาจากตำแหน่ง" onclick="dispSchType('l')">
											<div class="box"></div>
											<div class="check"></div>
											ค้นหาจากตำแหน่ง
										</label>
									</div>

									<div class="afms-searchtype_detail">
										<div class="afms-field afms-field_input">
											<label>รายละเอียด</label>
											<input id=sDetail type="text">
											<span class="bar"></span>
										</div>
										 <div class="afms-field afms-field_select">
                                            <label>ภาค</label>
                                            <select id="sReg2" runat="server" onchange="" data-live-search="true">
                                                <option value="0">=== เลือก ===</option>
                                            </select>
                                            <span class="bar"></span>
                                        </div>
                                        <div class="afms-field afms-field_select">
                                            <label>เขต</label>
                                            <select id="sArea2" runat="server" onchange="" data-live-search="true">
                                                <option value="0">=== เลือก ===</option>
                                            </select>
                                            <span class="bar"></span>
                                            <div style="display:none">
                                                 <select id="sArea2_raw" runat="server" onchange="" data-live-search="true">
                                                <option value="0">=== เลือก ===</option>
                                            </select>
                                            </div>
                                        </div>
                                       <div class="afms-field afms-field_select">
									        <label>จังหวัด</label>
									        <select id=sProv2  runat=server onchange="setAumphur2('sAumphur2',this.value,'0')" data-live-search="true">
                                                <option value="0">=== เลือก ===</option>
                                            </select>
									        <span class="bar"></span>
								        </div>

                                        <div class="afms-field afms-field_select">
									        <label>อำเภอ</label>
									        <select id=sAumphur2 runat=server  disabled=disabled onchange="setTumbon2('sTumbon2',this.value,'0')" data-live-search="true">
                                                <option value="0">=== เลือก ===</option>
                                            </select>
									        <span class="bar"></span>
								        </div>
                                        <div class="afms-field afms-field_select">
									        <label>ตำบล</label>
									        <select id=sTumbon2 runat=server disabled=disabled data-live-search="true">
                                                <option value="0">=== เลือก ===</option>
                                            </select>
									        <span class="bar"></span>
								        </div>
									</div>

									<div class="afms-searchtype_direction" style="display: none;">
										<div class="afms-field afms-field_input">
											<label>ตำแหน่ง</label>
											<input id=Loc_l type="text">
											<span class="bar"></span>
										</div>
										<div class="afms-field afms-field_input">
											<label>รัศมี</label>
											<input id=Radius_l type="text">
											<span class="bar"></span>
										</div>
										<!--div class="afms-radius" onclick="iMap.bCirSch_click()"></div-->
									</div>

									<div class="afms-field afms-field_checkbox">
										<p>ชั้นข้อมูล</p>
										<div id=layerTree></div>
									</div>

									<div class="text-center">
										<button class="afms-btn afms-btn-secondary afms-btn-search" onclick="doSch()">
											<i class="afms-ic_search"></i> ค้นหา
										</button>
                                        <button class="afms-btn afms-btn-secondary afms-btn-search" onclick="clearLandPOI()">
											 ล้าง
										</button>
                                        <button id=exportPOIBtn class="afms-btn afms-btn-secondary afms-btn-search" onclick="exportLandPOI()" style='display:none'>
											 Export
										</button>
									</div>


									<div id="tabLayer_result" class="afms-sec-searchlist">
										
									</div>
								</div>


								<div role="tabpanel" class="tab-pane" id="raster">
									<div class="afms-field afms-field_checkbox">
										<p>ชั้นข้อมูล</p>
										<div id="gisLayerTree"></div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div role="tabpanel" class="tab-pane" id="history">
						<div class="col-md-12">
							<div class="afms-field afms-field_select">
								<label>Station</label>
								<select id="sStation">
									<option value=''>..ทั้งหมด..</option>
								</select>
								<span class="bar"></span>
							</div>

							

							<div class="afms-field afms-field_select">
								<label>Event</label>
								<select id=sEvent>
                                   <option value='0'>..ทั้งหมด..</option>
                                    <option value='1'>พบในฐานข้อมูล</option>  
                                    <option value='2'>ไม่พบในฐานข้อมูล</option>  
                                 </select>
								<span class="bar"></span>
							</div>

                            <div class="afms-field afms-field_select">
								<label>Filter</label>
                            <select id=sFilter style='width:150px' onchange="setSFilter('s',this.value)">
                                <option value='1'>ชั่วโมงที่แล้ว</option>
                                <option value='2' selected>วันนี้</option>
                                <option value='3'>เมื่อวาน</option>
                                <option value='4'>2 วันก่อน</option>
                                <option value='5'>3 วันก่อน</option>
                                <option value='6'>สัปดาห์นี้</option>
                                <option value='7'>สัปดาห์ก่อน</option>
                                <option value='8'>เดือนนี้</option>
                                <option value='9'>เดือนก่อน</option>
               
                                </select>

                            <span class="bar"></span>
							</div>

							<div class="afms-field afms-field_datetimepicker">
								<label>เริ่ม</label>
								<input id="sFDt" type="text" name="" value='<%=string.Format(new System.Globalization.CultureInfo("th-TH"),"{0:dd/MM/yyyy} 00:00",DateTime.Now) %>'>
								<span class="bar"></span>
								<i class="afms-ic_date"></i>
                          </div>

							<div class="afms-field afms-field_datetimepicker">
								<label>สิ้นสุด</label>
								<input id="sTDt" type="text" name="" value='<%=string.Format(new System.Globalization.CultureInfo("th-TH"),"{0:dd/MM/yyyy} 00:00",DateTime.Now.AddDays(1)) %>'>
								<span class="bar"></span>
								<i class="afms-ic_date"></i>
                                 </div>
							

							<div class="text-center">
								<button class="afms-btn afms-btn-secondary afms-btn-search" onclick="doSchPBck()">
									<i class="afms-ic_search"></i> ค้นหา
								</button>
							</div>

							<div id="tabSch_result" class="afms-sec-searchlist">
								
							</div>
						</div>


					</div>
                    <div role="tabpanel" class="tab-pane" id="route">
						<div class="col-md-12">
							<div class="afms-search-route">							
								<div class="afms-field afms-field_input afms-route-start">
									<i class="afms-ic_start"></i>
									<input id="DirFrm" type="text" placeholder="จุดเริ่มต้น - คลิกที่แผนที่">
									<span class="bar"></span>
									<i class="afms-ic_waypoint"></i>
									<button class="afms-btn afms-btn-search">
										<i class="afms-ic_search"></i>
									</button>
								</div>
								<div class="afms-search-route-start-autocomplete" style="display: none;">
									<ul></ul>
								</div>
								
								<div class="afms-field afms-field_input afms-route-destination">
									<i class="afms-ic_destination"></i>
									<input id="DirTo"  type="text" placeholder="จุดสิ้นสุด - คลิกที่แผนที่">
									<span class="bar"></span>
									<button class="afms-btn afms-btn-search">
										<i class="afms-ic_search"></i>
									</button>
								</div>
								<button onclick=iMap.swapRoute() class="afms-btn afms-btn-swaproute">
									<i class="afms-ic_swap"></i>
								</button>
                                <div class="afms-search-route-destination-autocomplete" style="display: none;">
									<ul></ul>
								</div>
                                 <div style='text-align:right;margin-bottom:15px'><a id=DirSch href='javascript:void(0)'>ค้นหาเส้นทาง</a> <a id=DirClr href='javascript:void(0)'>ล้าง</a></div>
								
							</div>

							<div class="afms-route-detail" style="display: none;">
								
							</div>

							
						</div>
					</div>
				
                </div>

				<button class="afms-btn afms-btn-hide afms-ic_prev"></button>
			</div>

			<div class="afms-sec-map">
				<div id="afms-sec-maptools" class="afms-sec-maptools">
					<ul>
                        <%if(!IsMobile()){%>
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
							<button id=bToolmDist2 style="background:url(images/dist2.png)" data-toggle="tooltip" data-placement="top" title="วัดระยะทาง 2 จุด"></button>
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
                        <li style='display:none'>
							<button id=bToolRep class="afms-ic_report" data-toggle="tooltip" data-placement="top" title="รายงาน"></button>
						</li>
						<li>
							<button id=bToolDF style="background:url(images/df.png)" data-toggle="tooltip" data-placement="top" title="DF"></button>
						</li>
                        <%}%>

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
						
						<div class="afms-sec-mapsensor">
							<div class="afms-mapsensor-title">
								Sensor Monitor
							</div>
							<div class="afms-mapsensor-content">
								<div class="row">
									<div class="afms-mapsensor-box">
										<div class="panel panel-default afms-station-status panel-com">
											<div class="panel-heading">Communication</div>
											<div class="panel-body">
												<p><b>3G :</b> <span class='3G'>-</span></p>
												<p><b>GPS :</b> <span class='GPS'>-</span></p>
											</div>
										</div>
									</div>
									<div class="afms-mapsensor-box">
										<div class="panel panel-default afms-station-status panel-ups">
											<div class="panel-heading">UPS : <span class='UPSPc'>-</span>%</div>
											<div class="panel-body">
												<p><span class='UPSTime'>-</span> Minute</p>
											</div>
										</div>
									</div>
									<div class="afms-mapsensor-box">
										<div class="panel panel-default afms-station-status panel-scaner">
											<div class="panel-heading">Scanner : <span class='AtennaStat'></span></div>
											<div class="panel-body">
												<p><b>Antenna :</b> <span class='Atenna'></span></p>
											</div>
										</div>
									</div>
									<div class="afms-mapsensor-box">
										<div class="panel panel-default afms-station-status panel-sensor">
											<div class="panel-heading">Environment</div>
											<div class="panel-body">
												<p><b>Humidity :</b> <span class='Humidity'>-</span>%</p>
												<p><b>Temp :</b> <span class='Temp'>-</span>°C</p>
											</div>
										</div>
									</div>
									<div class="afms-mapsensor-box">
										<div class="panel panel-default afms-station-status panel-power">
											<div class="panel-heading">Power meter : Plug</div>
											<div class="panel-body">
												<p><b>Voltage :</b> <span class='Voltage'>-</span>V</p>
												<p><b>Current :</b> <span class='Current'>-</span>A</p>
												<p><b>Freq :</b> <span class='Frequency'>-</span>Hz</p>
											</div>
										</div>
									</div>
								</div>
							</div>
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

				<div id="mapsensor" class="afms-sec-mapsensor">
					<div class="afms-mapsensor-title">
						Sensor Monitor
						<button class="afms-btn afms-btn-close afms-ic_close"></button>
					</div>
					<div class="afms-mapsensor-content">
								<div class="row">
									<div class="afms-mapsensor-box">
										<div rel="panel" class="panel panel-default afms-station-status panel-com">
											<div class="panel-heading">Communication</div>
											<div class="panel-body">
												<p><b>Network :</b> <span class='NET'>-</span></p>
												<p><b>GPS :</b> <span class='GPS'>-</span></p>
											</div>
										</div>
									</div>
									<div class="afms-mapsensor-box">
										<div rel="panel" class="panel panel-default afms-station-status panel-ups">
											<div class="panel-heading">UPS : <span class='UPSPc'>-</span>%</div>
											<div class="panel-body">
												<p><span class='UPSTime'>-</span> Minute</p>
											</div>
										</div>
									</div>
									<div class="afms-mapsensor-box">
										<div rel="panel" class="panel panel-default afms-station-status panel-scaner">
											<div class="panel-heading">Scanner : <span class='AtennaStat'></span></div>
											<div class="panel-body">
												<p><b>Antenna :</b> <span class='Atenna'></span></p>
											</div>
										</div>
									</div>
									<div class="afms-mapsensor-box">
										<div rel="panel" class="panel panel-default afms-station-status panel-sensor">
											<div class="panel-heading">Environment</div>
											<div class="panel-body">
												<p><b>Humidity :</b> <span class='Humidity'>-</span>%</p>
												<p><b>Temp :</b> <span class='Temp'>-</span>°C</p>
											</div>
										</div>
									</div>
									
								</div>
							</div>
				</div>

                <div style="width:100%;height:100%;">
                    <iframe id="mapFrame" src="Map.aspx" width=100% height=100%></iframe>
                </div>
				

			</div>
		</div>
	</div>

	<div class="afms-sec-menumobile hidden-md">
		<ul class="afms-sec-menu">
			<li class="afms-menu-user">
				<div class="col-sm-4 col-xs-4" style="padding-right: 10px">
					<img src="../img/user.png" alt="" class="img-circle">
				</div>
				<div class="col-sm-8 col-xs-8" style="padding: 10px 0;">
					<%=EBMSMap30.cUsr.FullName%>
					<a href="../UR/Logout.aspx" class="col-sm-12 col-xs-12">
						<i class="afms-ic_exit"></i> ออกจากระบบ
					</a>
				</div>
			</li>
			<li class="clearfix" style="padding: 0"></li>
			<li><a href="../DashB">DASHBOARD</a></li>
			<li><a href="Cop.aspx" class="is-active">COP</a></li>
			<li><a href="../FMS">FMS</a></li>
            <li><a href="../DMS">DMS</a></li>
            <li><a href="../DASHB/Download.aspx">Download</a></li>
		</ul>
	</div>
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