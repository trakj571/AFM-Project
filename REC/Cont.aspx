<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Cont.aspx.cs" Inherits="AFMProj.REC.Cont" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <script language=javascript>
        $(function(){
            $("a[rel=AnChk]").addClass("is-active");
       
        
         });
       
    </script>
</head>
<body>
	<div class="afms-sec-container">
		<!--#include file="../_inc/Hd.asp"-->

		
		<div class="afms-sec-breadcrumb">
			<ul>
				<li><a href="" class="afms-ic_home"></a> <span class="afms-ic_next"></span></li>
				<li><a href="">Radio Function</a> <span class="afms-ic_next"></span></li>
				<!-- <li><a href="">Frequency Database</a> <span class="afms-ic_next"></span></li>
				<li><a href="">การวิเคราะห์ข้อมูล</a> <span class="afms-ic_next"></span></li> -->
				<li>Control Mode</li>
			</ul>
		</div>

		<div class="row afms-sec-content">

			<div class="afms-sec-sidebarbox">
				<div class="collapse in" id="sidebarSection">
					<div class="afms-sec-sidebar">
						<ul>
							<li>
								<div class="d-flex justify-content-between align-items-center">
									<div>Station-1</div>
									<div>
										<div class="fm-field-switchtoggle switchtoggle-lockopen">
											<input type="checkbox">
											<label>Toggle</label>
										</div>
									</div>
								</div>
							</li>
							<li>
								<div class="d-flex justify-content-between align-items-center">
									<div>Station-1</div>
									<div>
										<div class="fm-field-switchtoggle switchtoggle-lockopen">
											<input type="checkbox">
											<label>Toggle</label>
										</div>
									</div>
								</div>
							</li>
							<li>
								<div class="d-flex justify-content-between align-items-center">
									<div>Station-1</div>
									<div>
										<div class="fm-field-switchtoggle switchtoggle-lockopen">
											<input type="checkbox">
											<label>Toggle</label>
										</div>
									</div>
								</div>
							</li>
							<li>
								<div class="d-flex justify-content-between align-items-center">
									<div>Station-1</div>
									<div>
										<div class="fm-field-switchtoggle switchtoggle-lockopen">
											<input type="checkbox">
											<label>Toggle</label>
										</div>
									</div>
								</div>
							</li>
							<li>
								<div class="d-flex justify-content-between align-items-center">
									<div>Station-1</div>
									<div>
										<div class="fm-field-switchtoggle switchtoggle-lockopen">
											<input type="checkbox">
											<label>Toggle</label>
										</div>
									</div>
								</div>
							</li>
						</ul>
						<button class="afms-btn afms-btn-hide afms-ic_prev hidden-sm hidden-xs"></button>
					</div>
				</div>
				<button class="afms-btn afms-btn-hide hidden-md hidden-lg" role="button" data-toggle="collapse" href="#sidebarSection" aria-expanded="false" aria-controls="sidebarSection"></button>
			</div>

			<div class="col-md-12">
					<div class="d-flex justify-content-between flex-wrap">
							<div class="afms-page-title">
								Radio Function : Control Mode
							</div>
							<div>
									<button class="afms-btn fm-btn--primary">Live</button>
									<button class="afms-btn">Control</button>
									<button class="afms-btn">Play Back</button>
							</div>
						</div>
				<div class="afms-content" style="margin-top: 20px">
					<div class="d-flex justify-content-between align-items-center">
						<h2>Station-1</h2>
						<div>
							<div class="fm-field-switchtoggle switchtoggle-lockopen">
								<input type="checkbox">
								<label>Toggle</label>
							</div>
						</div>
					</div>
					<p style="margin-top: 15px">Monitoring : Communication OK | TEMP : 40 C | HUMI : 70 | GPS : OK [Location : LAT :13.25648 LONG : 100.32546]</p>

					<div class="panel">
						<div class="d-flex justify-content-between align-items-center panel-heading flex-wrap">
							<div class="d-flex align-items-center">
								<div class="fm-field-switchtoggle switchtoggle-onoff">
									<input type="checkbox">
									<label>Toggle</label>
								</div>
								<h2>Station-1</h2>
							</div>
							<div>Time : 15/04/2562 10.35</div>
						</div>
						<div class="panel-body">
							<div class="d-flex flex-wrap fm-ch--group">
								<div class="fm-ch--item">
									<div class="fm-ch--title"><i class="afms-ic_volume"></i>CH3</div>
									<div class="fm-ch--info bg-green">
										<div>88</div>
										<div>MHz</div>
									</div>
								</div>
								<div class="fm-ch--item">
									<div class="fm-ch--title">CH3</div>
									<div class="fm-ch--info bg-green">
										<div>88</div>
										<div>MHz</div>
									</div>
								</div>
								<div class="fm-ch--item">
									<div class="fm-ch--title">CH3</div>
									<div class="fm-ch--info bg-red">
										<div>88</div>
										<div>MHz</div>
									</div>
								</div>
								<div class="fm-ch--item">
									<div class="fm-ch--title">CH3</div>
									<div class="fm-ch--info bg-green">
										<div>88</div>
										<div>MHz</div>
									</div>
								</div>
								<div class="fm-ch--item">
									<div class="fm-ch--title">CH3</div>
									<div class="fm-ch--info bg-red">
										<div>88</div>
										<div>MHz</div>
									</div>
								</div>
								<div class="fm-ch--item">
									<div class="fm-ch--title">CH3</div>
									<div class="fm-ch--info bg-green">
										<div>88</div>
										<div>MHz</div>
									</div>
								</div>
								<div class="fm-ch--item">
									<div class="fm-ch--title">CH3</div>
									<div class="fm-ch--info bg-red">
										<div>88</div>
										<div>MHz</div>
									</div>
								</div>
								<div class="fm-ch--item">
									<div class="fm-ch--title">CH3</div>
									<div class="fm-ch--info bg-green">
										<div>88</div>
										<div>MHz</div>
									</div>
								</div>
								<div class="fm-ch--item">
									<div class="fm-ch--title">CH3</div>
									<div class="fm-ch--info bg-red">
										<div>88</div>
										<div>MHz</div>
									</div>
								</div>
								<div class="fm-ch--item">
									<div class="fm-ch--title">CH3</div>
									<div class="fm-ch--info bg-green">
										<div>88</div>
										<div>MHz</div>
									</div>
								</div>
								<div class="fm-ch--item">
									<div class="fm-ch--title">CH3</div>
									<div class="fm-ch--info bg-red">
										<div>88</div>
										<div>MHz</div>
									</div>
								</div>
								<div class="fm-ch--item">
									<div class="fm-ch--title">CH3</div>
									<div class="fm-ch--info bg-green">
										<div>88</div>
										<div>MHz</div>
									</div>
								</div>
								<div class="fm-ch--item">
									<div class="fm-ch--title">CH3</div>
									<div class="fm-ch--info bg-red">
										<div>88</div>
										<div>MHz</div>
									</div>
								</div>
								<div class="fm-ch--item">
									<div class="fm-ch--title">CH3</div>
									<div class="fm-ch--info bg-green">
										<div>88</div>
										<div>MHz</div>
									</div>
								</div>
								<div class="fm-ch--item">
									<div class="fm-ch--title">CH3</div>
									<div class="fm-ch--info bg-red">
										<div>88</div>
										<div>MHz</div>
									</div>
								</div>
								<div class="fm-ch--item">
									<div class="fm-ch--title">CH3</div>
									<div class="fm-ch--info bg-green">
										<div>88</div>
										<div>MHz</div>
									</div>
								</div>
							</div>
						</div>
					</div>

					<div class="fm-graph" style="margin-top: 20px;"></div>

					<div class="row" style="margin-top: 20px;">
						<div class="col-md-12 text-right">
							<button class="afms-btn afms-btn-primary">
								Scanning
							</button>
						</div>
					</div>

					<!-- <div class="collapse in" id="searchSection">
						<div class="row">
							<div class="col-md-4">
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
							<div class="col-md-4">
								<div class="afms-field afms-field_select">
									<label>คลื่นความถี่ (MHz)</label>
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
							<div class="col-md-4">
								<div class="afms-field afms-field_select">
									<label>Bandwidth</label>
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
						</div>
						<div class="row">
							<div class="col-md-4">
								<div class="afms-field afms-field_datetimepicker">
									<label>ช่วงเวลาจาก</label>
									<input type="text" name="" placeholder="00/00/0000 00:00">
									<span class="bar"></span>
									<i class="afms-ic_date"></i>
								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_datetimepicker">
									<label>ถึง</label>
									<input type="text" name="" placeholder="00/00/0000 00:00">
									<span class="bar"></span>
									<i class="afms-ic_date"></i>
								</div>
							</div>
							<div class="col-md-12 text-center">
								<button class="afms-btn afms-btn-primary afms-btn-search" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection"><i class="afms-ic_search"></i> ค้นหา</button>
							</div>
						</div>
					</div> -->
				</div>

				<div class="afms-content" style="margin-top: 20px;">
					<div class="">
						<div class="afms-sec-table">
							<table class="table table-condensed text-center afms-table-responsive" style="margin-top: 0">
								<thead>
									<tr>
										<th style="width: 60px">No</th>
										<th>Frequency (MHz)</th>
										<th>Station name</th>
										<th>Address</th>
										<th style="width: 100px;">License</th>
										<th style="width: 100px;">Expire Date</th>
										<th style="width: 100px;">Set to CH</th>
										<th style="width: 70px">Time</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td data-th="No"></td>
										<td data-th="Frequency (MHz)"></td>
										<td data-th="Station name"></td>
										<td data-th="Address"></td>
										<td data-th="License"></td>
										<td data-th="Expire Date"></td>
										<td data-th="Set to CH">
											<div class="afms-field afms-field_select">
												<select>
													<option>Option 1</option>
													<option>Option 2</option>
													<option>Option 3</option>
													<option>Option 4</option>
													<option>Option 5</option>
												</select>
												<span class="bar"></span>
											</div>
										</td>
										<td data-th="Time">
											<i class="afms-ic_date"></i>
										</td>
									</tr>
									<tr>
										<td data-th="No"></td>
										<td data-th="Frequency (MHz)"></td>
										<td data-th="Station name"></td>
										<td data-th="Address"></td>
										<td data-th="License"></td>
										<td data-th="Expire Date"></td>
										<td data-th="Set to CH">
											<div class="afms-field afms-field_select">
												<select>
													<option>Option 1</option>
													<option>Option 2</option>
													<option>Option 3</option>
													<option>Option 4</option>
													<option>Option 5</option>
												</select>
												<span class="bar"></span>
											</div>
										</td>
										<td data-th="Time">
											<i class="afms-ic_date"></i>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>

        
		<div class="afms-push"></div>
	</div>

	<!--#include file="../_inc/Ft.asp"-->
</body>

</html>
