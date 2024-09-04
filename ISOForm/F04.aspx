<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="F04.aspx.cs" Inherits="AFMProj.ISOForm.F04" %>

<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
	<title>รายงานผลการตรวจสำรองจำหน่ายเครื่องและอุปกรณ์วิทยุคมนาคม</title>

	<!-- Bootstrap -->
	<!-- <link href="css/bootstrap.min.css" rel="stylesheet"> -->

	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/paper-css/0.3.0/paper.css">
	<link rel="stylesheet" href="css/style.css">

	<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

    
</head>

<!-- Set page size here: A5, A4 or A3 -->
<!-- Set also "landscape" if you need -->
<style>
	@page {
		size: A4;
		margin: 0;
	}



	body {
		/* padding: 5mm 0; */
	}

	.sheet {
		margin: 0 auto;
	}

	.sheet.padding-5mm {
		padding: 5mm;
		margin-top: 10px;
		margin-bottom: 10px;
	}

	@media print {
		body {
			-webkit-print-color-adjust: exact !important;
			page-break-after: always;
			/* padding: 0; */
		}
		html,
		body {
			width: auto;
			height: 100vh;
			padding: 0;
		}

		.sheet.padding-5mm {
			padding: 5mm;
			margin-top: 0;
			margin-bottom: 0;
		}
	}
</style>

<!-- Set "A5", "A4" or "A3" for class name -->
<!-- Set also "landscape" if you need -->

<body class="A4" onload="window.print()">

	<!-- Each sheet element should have the class "sheet" -->
	<!-- "padding-**mm" is optional: you can set 10, 15, 20 or 25 -->
	<section class="sheet padding-5mm">
		<table class="table table-bordered isof-heading">
			<tbody>
				<tr>
					<td>
						<img src="img/logo.png" class="img-responsive center-block">
					</td>
					<td class="text-center">
						<p>รายงานผลการตรวจสำรองจำหน่ายเครื่องและอุปกรณ์วิทยุคมนาคม</p>
						<p>สำนักงาน กสทช. เขต<span class="blank" style="width: 200px"><label id=OFFICE_NAME runat=server></label></span></p>
					</td>
				</tr>
			</tbody>
		</table>

		<div class="row mb-5">
			<div class="col-xs-12">
				<p>เรียน <span class="blank" style="width: 200px"></span></p>
				<p class="indent">ตามที่ได้รับมอบหมายให้เดินทางไปตรวจสำรองจำหน่ายเครื่องและอุปกรณ์วิทยุคมนาคม เมื่อวันที่<span class="blank" style="width: 200px"></span> นั้น<br> โดยดำเนินการตรวจในเขตพื้นที่จังหวัด<span class="blank" style="width: 200px"></span>
                 ซึ่งมีบริษัท/ร้านค้า จำนวน<span class="blank" style="width: 100px"></span>ราย <br>
                 แบ่งเป็นผู้จำหน่าย<span class="blank" style="width: 100px"></span>ราย 
                 ผู้ซ่อมแซม<span class="blank" style="width: 100px"></span>ราย ปรากฎผลการตรวจ ดังนี้</p>
			</div>
		</div>

		<table class="table table-bordered">
			<tbody>
				<tr>
					<th class="table-col-bg table-br-tp" style="width: 25px; padding-right: 0">1.</th>
					<th class="table-col-bg" style="width: 130px; border-left-color: transparent !important">ชื่อบริษัท/ห้างร้าน</th>
					<td><label id=S_NAME runat=server></label></td>
					<td style="width: 230px">
						<div class="pull-left pr-10">ประเภท</div>
						<div class="pull-left">
							<div class="checkbox checkbox-inline">
								<input id=S_TYPE1 runat=server type="checkbox" name="">
								<label>ผู้จำหน่าย</label>
							</div>
							<div class="checkbox checkbox-inline">
								<input id=S_TYPE2 runat=server type="checkbox" name="">
								<label>ผู้ซ่อมแซม</label>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<th class="table-col-bg table-br-tp" style="width: 25px; padding-right: 0"></th>
					<th class="table-col-bg">ที่อยู่</th>
					<td colspan="2"><label id=ADDRESS runat=server></label></td>
				</tr>
				<tr>
					<th class="table-col-bg table-br-tp" style="width: 25px; padding-right: 0"></th>
					<th class="table-col-bg">ใบอนุญาตเลขที่</th>
					<td><label id=LICENSENO runat=server></label></td>
					<td>ลงวันที่<span class="blank" style="width: 178px"><label id=LICENSEISSUE runat=server></label></span></td>
				</tr>
				<tr>
					<th class="table-col-bg table-br-tp" style="width: 25px; padding-right: 0"></th>
					<th class="table-col-bg">ผู้นำตรวจ/ตำแหน่ง</th>
					<td colspan="2"></td>
				</tr>
				<tr>
					<th class="table-col-bg table-br-tp" style="width: 25px; padding-right: 0"></th>
					<th class="table-col-bg">วันที่ตรวจ</th>
					<td colspan="2"><label id=INSP_DATEF runat=server></label></td>
				</tr>
				<tr>
					<th class="table-col-bg table-br-tp" style="width: 25px; padding-right: 0"></th>
					<th class="table-col-bg">ผลการตรวจ</th>
					<td colspan="2"><label id=RESULT_DESC runat=server></label></td>
				</tr>
				<tr>
					<th class="table-col-bg table-br-tp" style="width: 25px; padding-right: 0"></th>
					<th class="table-col-bg">ความเห็นของผู้ตรวจ</th>
					<td colspan="2"><label id=COMMENT_DESC runat=server></label></td>
				</tr>
			</tbody>
		</table>

		<table class="table table-bordered">
			<tbody>
				<tr>
					<th style="width: 154px">วันที่รายงาน</th>
					<td colspan="2"><label id=REPORT_DATEF runat=server></label></td>
				</tr>
				<tr>
					<th style="width: 154px">ผู้ตรวจสอบ</th>
					<td class="text-center pt-15" style="width: 300px">
						<p>(<span class="blank" style="width: 250px"><label id=INSP_NAME1 runat=server></label></span>)</p>
						<p>ตำแหน่ง: <span class="blank" style="width: 230px"><label id=INSP_POSITION1 runat=server></label></span></p>
					</td>
					<td class="text-center pt-15" style="width: 300px">
						<p>(<span class="blank" style="width: 250px"><label id=INSP_NAME2 runat=server></label></span>)</p>
						<p>ตำแหน่ง: <span class="blank" style="width: 230px"><label id=INSP_POSITION2 runat=server></label></span></p>
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<b>ข้อพิจารณา</b>
						<div class="row">
							<div class="col-xs-2">
								<div class="checkbox">
									<input type="checkbox" name="">
									<label>เห็นด้วย</label>
								</div>
							</div>
							<div class="col-xs-10">
								<div class="checkbox">
									<input type="checkbox" name="">
									<label><span class="blank" style="width: 200px"></span></label>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-xs-offset-6 col-xs-6 text-center">
								<p>(<span class="blank" style="width: 200px"><label id=DIRECTOR runat=server></label></span>)</p>
								<p>ผู้อำนวยการ สำนักงาน กสทช. เขต</p>
								<p>วันที่<span class="blank" style="width: 120px"><label id=Label13 runat=server></label></span></p>
							</div>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
		<b style="font-size: 11px">หมายเหตุ: แนบแบบบันทึกการตรวจเครื่องวิทยุคมนาคม ส่วนใดๆ  แห่งเครื่องวิทยุคมนาคมและใบอนุญาตวิทยุคมนาคม (สำหรับบริษัท/ห้างร้าน) พร้อมรายงานฉบับนี้</b>

		<table class="table table-bordered mt-10 mb-0">
			<tr>
				<td class="text-center ve-m" style="height: 460px">
                       <input type=hidden id=Lat runat=server value="" />
                       <input type=hidden id=Lng runat=server value="" />
                       <input type=hidden id=Tools runat=server value="0" />

                     <!--#include file="../GIS/EMapView.asp"-->    
                    
                </td>
			</tr>
		</table>
	</section>
</body>

</html>


