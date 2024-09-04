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
	<link rel="stylesheet" href="../_inc/css/responsive.css">
    <script src="../_inc/js/jquery-3.2.0.min.js"></script>
    <script src="../_inc/js/bootstrap.js"></script>
    <script src="../_inc/js/bootstrap-touchspin.js"></script>
    <script src="../_inc/js/bootstrap-select.js"></script>
    <script src="../_inc/js/sweetalert2.js"></script>
    <script src="../_inc/js/function.js"></script>

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
				<li><a href="">DASHBOARD</a></li>
				<li><a href="" class="is-active">COP</a></li>
				<li><a href="">FMS</a></li>
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
					<li class="active"><a href="#station" aria-controls="station" role="tab" data-toggle="tab">Station</a></li>
					<li><a href="#event" aria-controls="event" role="tab" data-toggle="tab">Event</a></li>
					<li><a href="#layer" aria-controls="layer" role="tab" data-toggle="tab">Layer</a></li>
					<li><a href="#history" aria-controls="history" role="tab" data-toggle="tab">History</a></li>
				</ul>

				<div class="tab-content">
					<div role="tabpanel" class="tab-pane active" id="station">
						<div class="col-md-12">
							<table class="table">
								<tr>
									<td style="width: 25px">
										<i class="afms-ic_lock"></i>
									</td>
									<td style="padding-left: 15px;">
										<i class="afms-ic_record afms-status is-online"></i>Station
									</td>
									<td style="width: 97px; min-width: 97px">
										<button class="afms-btn afms-btn-display afms-ic_view" data-toggle="tooltip" data-placement="top" title="Display"></button>
										<button class="afms-btn afms-ic_focus" data-toggle="tooltip" data-placement="top" title="Focus"></button>
										<a class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></a>
									</td>
								</tr>
								<tr>
									<td style="width: 25px">
										<i class="afms-ic_lock"></i>
									</td>
									<td style="padding-left: 15px;">
										<i class="afms-ic_record afms-status is-online"></i>Station
									</td>
									<td style="width: 97px; min-width: 97px">
										<button class="afms-btn afms-ic_view" data-toggle="tooltip" data-placement="top" title="Display"></button>
										<button class="afms-btn afms-ic_focus" data-toggle="tooltip" data-placement="top" title="Focus"></button>
										<button class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></button>
									</td>
								</tr>
								<tr>
									<td style="width: 25px">
										<i class="afms-ic_unlock"></i>
									</td>
									<td style="padding-left: 15px;">
										<i class="afms-ic_record afms-status is-offline"></i>Station
									</td>
									<td style="width: 97px; min-width: 97px">
										<button class="afms-btn afms-ic_view" data-toggle="tooltip" data-placement="top" title="Display"></button>
										<button class="afms-btn afms-ic_focus" data-toggle="tooltip" data-placement="top" title="Focus"></button>
										<button class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></button>
									</td>
								</tr>
								<tr>
									<td style="width: 25px">
										<i class="afms-ic_unlock"></i>
									</td>
									<td style="padding-left: 15px;">
										<i class="afms-ic_record afms-status is-offline"></i>Station
									</td>
									<td style="width: 97px; min-width: 97px">
										<button class="afms-btn afms-ic_view" data-toggle="tooltip" data-placement="top" title="Display"></button>
										<button class="afms-btn afms-ic_focus" data-toggle="tooltip" data-placement="top" title="Focus"></button>
										<button class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></button>
									</td>
								</tr>
								<tr>
									<td style="width: 25px">
										<i class="afms-ic_unlock"></i>
									</td>
									<td style="padding-left: 15px;">
										<i class="afms-ic_record afms-status is-offline"></i>Station
									</td>
									<td style="width: 97px; min-width: 97px">
										<button class="afms-btn afms-ic_view" data-toggle="tooltip" data-placement="top" title="Display"></button>
										<button class="afms-btn afms-ic_focus" data-toggle="tooltip" data-placement="top" title="Focus"></button>
										<button class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></button>
									</td>
								</tr>
								<tr>
									<td style="width: 25px">
										<i class="afms-ic_unlock"></i>
									</td>
									<td style="padding-left: 15px;">
										<i class="afms-ic_record afms-status is-offline"></i>Station
									</td>
									<td style="width: 97px; min-width: 97px">
										<button class="afms-btn afms-ic_view" data-toggle="tooltip" data-placement="top" title="Display"></button>
										<button class="afms-btn afms-ic_focus" data-toggle="tooltip" data-placement="top" title="Focus"></button>
										<button class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></button>
									</td>
								</tr>
								<tr>
									<td style="width: 25px">
										<i class="afms-ic_unlock"></i>
									</td>
									<td style="padding-left: 15px;">
										<i class="afms-ic_record afms-status is-offline"></i>Station
									</td>
									<td style="width: 97px; min-width: 97px">
										<button class="afms-btn afms-ic_view" data-toggle="tooltip" data-placement="top" title="Display"></button>
										<button class="afms-btn afms-ic_focus" data-toggle="tooltip" data-placement="top" title="Focus"></button>
										<button class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></button>
									</td>
								</tr>
								<tr>
									<td style="width: 25px">
										<i class="afms-ic_unlock"></i>
									</td>
									<td style="padding-left: 15px;">
										<i class="afms-ic_record afms-status is-offline"></i>Station
									</td>
									<td style="width: 97px; min-width: 97px">
										<button class="afms-btn afms-ic_view" data-toggle="tooltip" data-placement="top" title="Display"></button>
										<button class="afms-btn afms-ic_focus" data-toggle="tooltip" data-placement="top" title="Focus"></button>
										<button class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></button>
									</td>
								</tr>
								<tr>
									<td style="width: 25px">
										<i class="afms-ic_unlock"></i>
									</td>
									<td style="padding-left: 15px;">
										<i class="afms-ic_record afms-status is-offline"></i>Station
									</td>
									<td style="width: 97px; min-width: 97px">
										<button class="afms-btn afms-ic_view" data-toggle="tooltip" data-placement="top" title="Display"></button>
										<button class="afms-btn afms-ic_focus" data-toggle="tooltip" data-placement="top" title="Focus"></button>
										<button class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></button>
									</td>
								</tr>
								<tr>
									<td style="width: 25px">
										<i class="afms-ic_unlock"></i>
									</td>
									<td style="padding-left: 15px;">
										<i class="afms-ic_record afms-status is-offline"></i>Station
									</td>
									<td style="width: 97px; min-width: 97px">
										<button class="afms-btn afms-ic_view" data-toggle="tooltip" data-placement="top" title="Display"></button>
										<button class="afms-btn afms-ic_focus" data-toggle="tooltip" data-placement="top" title="Focus"></button>
										<button class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></button>
									</td>
								</tr>
								<tr>
									<td style="width: 25px">
										<i class="afms-ic_unlock"></i>
									</td>
									<td style="padding-left: 15px;">
										<i class="afms-ic_record afms-status is-offline"></i>Station
									</td>
									<td style="width: 97px; min-width: 97px">
										<button class="afms-btn afms-ic_view" data-toggle="tooltip" data-placement="top" title="Display"></button>
										<button class="afms-btn afms-ic_focus" data-toggle="tooltip" data-placement="top" title="Focus"></button>
										<button class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></button>
									</td>
								</tr>
								<tr>
									<td style="width: 25px">
										<i class="afms-ic_unlock"></i>
									</td>
									<td style="padding-left: 15px;">
										<i class="afms-ic_record afms-status is-offline"></i>Station
									</td>
									<td style="width: 97px; min-width: 97px">
										<button class="afms-btn afms-ic_view" data-toggle="tooltip" data-placement="top" title="Display"></button>
										<button class="afms-btn afms-ic_focus" data-toggle="tooltip" data-placement="top" title="Focus"></button>
										<button class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></button>
									</td>
								</tr>
								<tr>
									<td style="width: 25px">
										<i class="afms-ic_unlock"></i>
									</td>
									<td style="padding-left: 15px;">
										<i class="afms-ic_record afms-status is-offline"></i>Station
									</td>
									<td style="width: 97px; min-width: 97px">
										<button class="afms-btn afms-ic_view" data-toggle="tooltip" data-placement="top" title="Display"></button>
										<button class="afms-btn afms-ic_focus" data-toggle="tooltip" data-placement="top" title="Focus"></button>
										<button class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></button>
									</td>
								</tr>
								<tr>
									<td style="width: 25px">
										<i class="afms-ic_unlock"></i>
									</td>
									<td style="padding-left: 15px;">
										<i class="afms-ic_record afms-status is-offline"></i>Station
									</td>
									<td style="width: 97px; min-width: 97px">
										<button class="afms-btn afms-ic_view" data-toggle="tooltip" data-placement="top" title="Display"></button>
										<button class="afms-btn afms-ic_focus" data-toggle="tooltip" data-placement="top" title="Focus"></button>
										<button class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></button>
									</td>
								</tr>
								<tr>
									<td style="width: 25px">
										<i class="afms-ic_unlock"></i>
									</td>
									<td style="padding-left: 15px;">
										<i class="afms-ic_record afms-status is-offline"></i>Station
									</td>
									<td style="width: 97px; min-width: 97px">
										<button class="afms-btn afms-ic_view" data-toggle="tooltip" data-placement="top" title="Display"></button>
										<button class="afms-btn afms-ic_focus" data-toggle="tooltip" data-placement="top" title="Focus"></button>
										<button class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></button>
									</td>
								</tr>
								<tr>
									<td style="width: 25px">
										<i class="afms-ic_unlock"></i>
									</td>
									<td style="padding-left: 15px;">
										<i class="afms-ic_record afms-status is-offline"></i>Station
									</td>
									<td style="width: 97px; min-width: 97px">
										<button class="afms-btn afms-ic_view" data-toggle="tooltip" data-placement="top" title="Display"></button>
										<button class="afms-btn afms-ic_focus" data-toggle="tooltip" data-placement="top" title="Focus"></button>
										<button class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></button>
									</td>
								</tr>
								<tr>
									<td style="width: 25px">
										<i class="afms-ic_unlock"></i>
									</td>
									<td style="padding-left: 15px;">
										<i class="afms-ic_record afms-status is-offline"></i>Station
									</td>
									<td style="width: 97px; min-width: 97px">
										<button class="afms-btn afms-ic_view" data-toggle="tooltip" data-placement="top" title="Display"></button>
										<button class="afms-btn afms-ic_focus" data-toggle="tooltip" data-placement="top" title="Focus"></button>
										<button class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></button>
									</td>
								</tr>
								<tr>
									<td style="width: 25px">
										<i class="afms-ic_unlock"></i>
									</td>
									<td style="padding-left: 15px;">
										<i class="afms-ic_record afms-status is-offline"></i>Station
									</td>
									<td style="width: 97px; min-width: 97px">
										<button class="afms-btn afms-ic_view" data-toggle="tooltip" data-placement="top" title="Display"></button>
										<button class="afms-btn afms-ic_focus" data-toggle="tooltip" data-placement="top" title="Focus"></button>
										<button class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></button>
									</td>
								</tr>
							</table>
						</div>
					</div>
					<div role="tabpanel" class="tab-pane" id="event">
						<div class="col-md-12">
							<div class="afms-field afms-field_select">
								<label>Station</label>
								<select>
									<option>Option 1</option>
									<option>Option 2</option>
									<option>Option 3</option>
									<option>Option 4</option>
									<option>Option 5</option>
								</select>
								<span class="bar"></span>
							</div>
						</div>

						<div class="col-md-12">
							<div class="afms-field afms-field_select">
								<label>Group</label>
								<select>
									<option>Option 1</option>
									<option>Option 2</option>
									<option>Option 3</option>
									<option>Option 4</option>
									<option>Option 5</option>
								</select>
								<span class="bar"></span>
							</div>
						</div>

						<div class="col-md-12">
							<div class="afms-field afms-field_select">
								<label>Event</label>
								<select>
									<option>Option 1</option>
									<option>Option 2</option>
									<option>Option 3</option>
									<option>Option 4</option>
									<option>Option 5</option>
								</select>
								<span class="bar"></span>
							</div>
						</div>

						<div class="col-md-12">
							<table class="table">
								<thead>
									<tr>
										<th>Datetime</th>
										<th>Station</th>
										<th>Event</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>10/10/2559 10:00</td>
										<td>Station - 1</td>
										<td>105.5 DB Not Found</td>
									</tr>
									<tr>
										<td>10/10/2559 10:00</td>
										<td>Station - 1</td>
										<td>105.5 DB Not Found</td>
									</tr>
									<tr>
										<td>10/10/2559 10:00</td>
										<td>Station - 1</td>
										<td>105.5 DB Not Found</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div role="tabpanel" class="tab-pane" id="layer">
						<div class="col-md-12">
							<ul class="nav nav-tabs" role="tablist" style="margin-top: 10px;">
								<li class="active"><a href="#vector" aria-controls="vector" role="tab" data-toggle="tab">Vector</a></li>
								<li><a href="#raster" aria-controls="raster" role="tab" data-toggle="tab">Raster</a></li>
							</ul>
							<div class="tab-content">
								<div role="tabpanel" class="tab-pane active" id="vector">
									<div class="afms-field afms-field_radio">
										<label class="radio-inline radio-searchtype_detail">
											<input type="radio" id="searchtype_detail" name="searchtype" value="ค้นหารายละเอียด" checked="">
											<div class="box"></div>
											<div class="check"></div>
											ค้นหารายละเอียด
										</label>

										<label class="radio-inline radio-searchtype_direction">
											<input type="radio" id="searchtype_direction" name="searchtype" value="ค้นหาจากตำแหน่ง">
											<div class="box"></div>
											<div class="check"></div>
											ค้นหาจากตำแหน่ง
										</label>
									</div>

									<div class="afms-searchtype_detail">
										<div class="afms-field afms-field_input">
											<label>รายละเอียด</label>
											<input type="text">
											<span class="bar"></span>
										</div>
									</div>

									<div class="afms-searchtype_direction" style="display: none;">
										<div class="afms-field afms-field_input">
											<label>ตำแหน่ง</label>
											<input type="text">
											<span class="bar"></span>
										</div>
										<div class="afms-field afms-field_input">
											<label>รัศมี</label>
											<input type="text">
											<span class="bar"></span>
										</div>
										<div class="afms-radius"></div>
									</div>

									<div class="afms-field afms-field_checkbox">
										<p>ชั้นข้อมูล</p>
										<label class="radio-inline">
											<input type="checkbox" id="layer_1" name="layer" value="option1">
											<div class="box"></div>
											<div class="check"><i class="afms-ic_check"></i></div>
											ขอบเขตการปกครอง
										</label>

										<label class="radio-inline">
											<input type="checkbox" id="layer_2" name="layer" value="option2">
											<div class="box"></div>
											<div class="check"><i class="afms-ic_check"></i></div>
											สำนักงาน กสทช
										</label>

										<label class="radio-inline">
											<input type="checkbox" id="layer_3" name="layer" value="option2">
											<div class="box"></div>
											<div class="check"><i class="afms-ic_check"></i></div>
											สถานีวิทยุชุมชน
										</label>
									</div>

									<div class="text-center">
										<button class="afms-btn afms-btn-secondary afms-btn-search">
											<i class="afms-ic_search"></i> ค้นหา
										</button>
									</div>

									<div class="afms-sec-searchlist">
										<p>ผลการค้นหา : 3 รายการ</p>
										<ul>
											<li>สำนักงาน กสทช. เขต 1</li>
											<li>สำนักงาน กสทช. เขต 2</li>
											<li>สำนักงาน กสทช. เขต 3</li>
										</ul>
									</div>
								</div>
								<div role="tabpanel" class="tab-pane" id="raster">
									<div class="afms-field afms-field_checkbox">
										<p>ชั้นข้อมูล</p>
										<label class="radio-inline">
											<input type="checkbox" id="layer_1" name="layer" value="option1">
											<div class="box"></div>
											<div class="check"><i class="afms-ic_check"></i></div>
											ขอบเขตการปกครอง
										</label>

										<label class="radio-inline">
											<input type="checkbox" id="layer_2" name="layer" value="option2">
											<div class="box"></div>
											<div class="check"><i class="afms-ic_check"></i></div>
											สำนักงาน กสทช
										</label>

										<label class="radio-inline">
											<input type="checkbox" id="layer_3" name="layer" value="option2">
											<div class="box"></div>
											<div class="check"><i class="afms-ic_check"></i></div>
											สถานีวิทยุชุมชน
										</label>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div role="tabpanel" class="tab-pane" id="history">
						<div class="col-md-12">
							<div class="afms-field afms-field_select">
								<label>Station</label>
								<select>
									<option>Option 1</option>
									<option>Option 2</option>
									<option>Option 3</option>
									<option>Option 4</option>
									<option>Option 5</option>
								</select>
								<span class="bar"></span>
							</div>

							<div class="afms-field afms-field_select">
								<label>Group</label>
								<select>
									<option>Option 1</option>
									<option>Option 2</option>
									<option>Option 3</option>
									<option>Option 4</option>
									<option>Option 5</option>
								</select>
								<span class="bar"></span>
							</div>

							<div class="afms-field afms-field_select">
								<label>Event</label>
								<select>
									<option>Option 1</option>
									<option>Option 2</option>
									<option>Option 3</option>
									<option>Option 4</option>
									<option>Option 5</option>
								</select>
								<span class="bar"></span>
							</div>

							<div class="afms-field afms-field_datepicker">
								<label>เริ่ม</label>
								<input type="text" name="" placeholder="00/00/0000">
								<span class="bar"></span>
								<i class="afms-ic_date"></i>
							</div>

							<div class="afms-field afms-field_datepicker">
								<label>สิ้นสุด</label>
								<input type="text" name="" placeholder="00/00/0000">
								<span class="bar"></span>
								<i class="afms-ic_date"></i>
							</div>

							<div class="text-center">
								<button class="afms-btn afms-btn-secondary afms-btn-search">
									<i class="afms-ic_search"></i> ค้นหา
								</button>
							</div>

							<div class="afms-sec-searchlist">
								<p>ผลการค้นหา : 3 รายการ</p>
								<ul>
									<li>สำนักงาน กสทช. เขต 1</li>
									<li>สำนักงาน กสทช. เขต 2</li>
									<li>สำนักงาน กสทช. เขต 3</li>
								</ul>
							</div>
						</div>


					</div>
				</div>

				<button class="afms-btn afms-btn-hide afms-ic_prev"></button>
			</div>



            <!-----------MAP-------------->
			<div class="afms-sec-map">
            <div class='afms-mappanel' style='position: absolute;width:100%; height: 100%;margin-top:60px;'> 
            <iframe id="mapFrame" src="Map.aspx" width=100% height=100%></iframe>
            
            </div>
				
               <div class="afms-ic_mappin">
					
				</div>
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
						<li>
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
						<div class="afms-mapevent-content">
							<table class="table">
								<thead>
									<tr>
										<th>Datetime</th>
										<th>Station</th>
										<th>Event</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>10/10/2559 10:00</td>
										<td>Station - 1</td>
										<td>105.5 DB Not Found</td>
									</tr>
									<tr>
										<td>10/10/2559 10:00</td>
										<td>Station - 1</td>
										<td>105.5 DB Not Found</td>
									</tr>
									<tr>
										<td>10/10/2559 10:00</td>
										<td>Station - 1</td>
										<td>105.5 DB Not Found</td>
									</tr>
								</tbody>
							</table>
						</div>

						<div class="afms-mapevent-title hidden-lg hidden-md hidden-sm">
							Information
						</div>
						<div class="afms-mapevent-content hidden-lg hidden-md hidden-sm" style="padding-top: 5px;">
							<div class="afms-field">
								<label for="">Name</label>
								<p>Station - 1</p>
							</div>

							<div class="afms-chart"></div>
							<div class="text-center afms-frequency-no">
								<button class="afms-btn afms-btn-primary afms-btn-play afms-ic_play"></button> 222.25 MHz <span>(Scanning...)</span>
							</div>
						</div>
						
						<div class="afms-sec-mapsensor">
							<div class="afms-mapsensor-title">
								Sensor Monitor
							</div>
							<div class="afms-mapsensor-content">
								<div class="row">
									<div class="afms-mapsensor-box">
										<div class="panel panel-default afms-station-status panel-success">
											<div class="panel-heading">Communication</div>
											<div class="panel-body">
												<p><b>3G :</b> OK</p>
												<p><b>GPS :</b> FIX</p>
											</div>
										</div>
									</div>
									<div class="afms-mapsensor-box">
										<div class="panel panel-default afms-station-status panel-success">
											<div class="panel-heading">UPS : 25%</div>
											<div class="panel-body">
												<p>30 Minute</p>
											</div>
										</div>
									</div>
									<div class="afms-mapsensor-box">
										<div class="panel panel-default afms-station-status panel-success">
											<div class="panel-heading">Scanner : Online</div>
											<div class="panel-body">
												<p><b>Atenna :</b> AX71</p>
											</div>
										</div>
									</div>
									<div class="afms-mapsensor-box">
										<div class="panel panel-default afms-station-status panel-danger">
											<div class="panel-heading">Environment</div>
											<div class="panel-body">
												<p><b>Humidity :</b> 30%</p>
												<p><b>Temp :</b> 45°C</p>
											</div>
										</div>
									</div>
									<div class="afms-mapsensor-box">
										<div class="panel panel-default afms-station-status panel-success">
											<div class="panel-heading">Power meter : Plug</div>
											<div class="panel-body">
												<p><b>Voltage :</b> 227.94 V</p>
												<p><b>Current :</b> 0.06A</p>
												<p><b>Freq :</b> 48.85 Hz Active Fn</p>
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
							<div class="afms-field">
								<label for="">Name</label>
								<p>Station - 1</p>
							</div>

							<div class="afms-chart"></div>
							<div class="text-center afms-frequency-no">
								<button class="afms-btn afms-btn-primary afms-btn-play afms-ic_play"></button> 222.25 MHz <span>(Scanning...)</span>
							</div>
						</div>
					</div>
				</div>

				<div class="afms-sec-mapstreet">	
					<button class="afms-btn afms-btn-close afms-ic_close"></button>		
                    
                    			
				</div>

				<div class="afms-sec-mapsensor">
					<div class="afms-mapsensor-title">
						Sensor Monitor
						<button class="afms-btn afms-btn-close afms-ic_close"></button>
					</div>
					<div class="afms-mapsensor-content">
						<div class="row">
							<div class="afms-mapsensor-box">
								<div class="panel panel-default afms-station-status panel-success">
									<div class="panel-heading">Communication</div>
									<div class="panel-body">
										<p><b>3G :</b> OK</p>
										<p><b>GPS :</b> FIX</p>
									</div>
								</div>
							</div>
							<div class="afms-mapsensor-box">
								<div class="panel panel-default afms-station-status panel-success">
									<div class="panel-heading">UPS : 25%</div>
									<div class="panel-body">
										<p>30 Minute</p>
									</div>
								</div>
							</div>
							<div class="afms-mapsensor-box">
								<div class="panel panel-default afms-station-status panel-success">
									<div class="panel-heading">Scanner : Online</div>
									<div class="panel-body">
										<p><b>Atenna :</b> AX71</p>
									</div>
								</div>
							</div>
							<div class="afms-mapsensor-box">
								<div class="panel panel-default afms-station-status panel-danger">
									<div class="panel-heading">Environment</div>
									<div class="panel-body">
										<p><b>Humidity :</b> 30%</p>
										<p><b>Temp :</b> 45°C</p>
									</div>
								</div>
							</div>
							<div class="afms-mapsensor-box">
								<div class="panel panel-default afms-station-status panel-success">
									<div class="panel-heading">Power meter : Plug</div>
									<div class="panel-body">
										<p><b>Voltage :</b> 227.94 V</p>
										<p><b>Current :</b> 0.06A</p>
										<p><b>Freq :</b> 48.85 Hz Active Fn</p>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

                fdsafdsf
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
			<li><a href="">DASHBOARD</a></li>
			<li><a href="" class="is-active">COP</a></li>
			<li><a href="">FMS</a></li>
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