<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="F01.aspx.cs" Inherits="AFMProj.ISOForm.F01" %>

<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
	<title>รายงานการตรวจสอบมาตรฐานทางเทคนิคของการแพร่คลื่นวิทยุ</title>

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

<body class="A4"  onload="window.print()">

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
						<p>รายงานการตรวจสอบมาตรฐานทางเทคนิคของการแพร่คลื่นวิทยุ</p>
						<p>สำนักงาน กสทช. เขต<span class="blank" style="width: 200px"><label id=OFFICE_NAME runat=server></label></span></p>
					</td>
				</tr>
			</tbody>
		</table>

		<div class="row mb-5">
			<div class="col-xs-3">
				<b>แหล่งที่มาในการตรวจสอบ</b>
			</div>
			<div class="col-xs-9">
				<div class="checkbox">
					<input id=TypeID1 runat=server type="checkbox" name="" onclick="return false">
					<label>ตรวจสอบตามแผน</label>
				</div>
                <div class="checkbox">
					<input id=TypeID2 runat=server type="checkbox" name="" onclick="return false">
					<label>เรื่องร้องเรียน</label>
				</div>
				<div class="checkbox last">
					<input id=TypeID3 runat=server type="checkbox" name="" onclick="return false">
					<label>ติดตามผลการแก้ไข ตามเลขที่หนังสือ<span class="blank" style="width: 200px"></span></label>
				</div>
			</div>
		</div>

		<table class="table table-bordered mb-0">
			<tbody>
				<tr>
					<th style="width: 150px">ชื่อสถานีที่ตรวจสอบ</th>
					<td colspan="2"><label id=S_NAME runat=server></label></td>
				</tr>
				<tr>
					<th>ประเภทสถานี</th>
					<td colspan="2"><label id=ST_TYPE_ID runat=server></label></td>
				</tr>
				<tr>
					<th>ความถี่ (MHz)</th>
					<td colspan="2"><label id=FREQUENCY runat=server></label></td>
				</tr>
				<tr>
					<th>ประเภทหน่วยงาน</th>
					<td colspan="2">
						<div class="checkbox">
							<input type="checkbox" name="departmentType">
							<label>หน่วยงานรัฐ (ระบุชื่อ)<span class="blank" style="width: 462px"></span></label>
						</div>
						<div class="checkbox">
							<input type="checkbox" name="departmentType">
							<label>เอกชน  (ระบุชื่อ)<span class="blank" style="width: 489px"></span></label>
						</div>
						<div class="checkbox last">
							<input type="checkbox" name="departmentType">
							<label>อื่นๆ (โปรดระบุ)<span class="blank" style="width: 487px"></span></label>
						</div>
					</td>
				</tr>
				<tr>
					<th>ผู้ประสานงาน</th>
					<td style="width: 287.5px"><label id=COORDINATOR_NAME runat=server></label></td>
					<td>โทร. <label id=COORDINATOR_TEL runat=server></label></td>
				</tr>
				<tr>
					<th>สถานะ</th>
					<td colspan="2">
						<div class="checkbox">
							<input id=Status1 runat=server onclick="return false" type="checkbox" name="departmentType">
							<label>ได้รับใบอนุญาตทดลองประกอบกิจการ เลขที่<span class="blank" style="width: 286px"><label id=LICENSENO1 runat=server></label></span></label>
						</div>
						<div class="checkbox">
							<input id=Status2 runat=server onclick="return false" type="checkbox" name="departmentType">
							<label>ได้รับใบอนุญาตประกอบกิจการวิทยุกระจายเสียงและโทรทัศน์ เลขที่<span class="blank" style="width: 158px"><label id=LICENSENO2 runat=server></label></span></label>
						</div>
						<div class="checkbox last">
							<input id=Status3 runat=server onclick="return false" type="checkbox" name="departmentType">
							<label>ได้รับใบอนุญาตประกอบกิจการโทรคมนาคม/วิทยุคมนาคม เลขที่<span class="blank" style="width: 172px"><label id=LICENSENO3 runat=server></label></span></label>
						</div>
					</td>
					<tr>
						<th>ที่ตั้ง</th>
						<td colspan="2"><label id=ADDRESS runat=server></label></td>
					</tr>
				</tr>
			</tbody>
		</table>
		<table class="table table-bordered mb-0" style="margin-top: -1px">
			<tbody>
				<tr>
					<th style="width: 150px">พิกัดที่ตั้ง</th>
					<th class="table-col-bg" style="width: 80px">Latitude</th>
					<td><label id=LATITUDE runat=server></label></td>
					<th class="table-col-bg" style="width: 80px">Longitude</th>
					<td><label id=LONGITUDE runat=server></label></td>
				</tr>
				<tr>
					<th>ความสูงจากระดับน้ำทะเล</th>
					<td colspan="4"></td>
				</tr>
			</tbody>
		</table>
		<table class="table table-bordered mb-0" style="margin-top: -1px">
			<tbody>
				<tr>
					<th class="table-col-bg" colspan="6">รายละเอียดของสถานี</th>
				</tr>
				<tr>
					<th class="ve-m text-center" style="width: 127px">ความถี่ที่วัดได้ (MHz)</th>
					<th class="ve-m text-center" style="width: 117px">ชนิดสายอากาศ</th>
					<th class="ve-m text-center" style="width: 127px">ชนิดสายนำสัญญาณ</th>
					<th class="ve-m text-center" style="width: 127px">กำลังส่ง<br>(วัตต์)/(PSA/ERP)</th>
					<th class="ve-m text-center" style="width: 128px">อัตราขยายสายอากาศ<br>(dBi)/(dBd)</th>
					<th class="ve-m text-center" style="width: 128px">ความสูงสายอากาศ<br>(เมตร)</th>
				</tr>
				<tr>
					<td><label id=FREQ_MEAS runat=server></label></td>
					<td><label id=AERIALTYPE_ID runat=server></label></td>
					<td><label id=AERIALLINE_TYPE runat=server></label></td>
					<td><label id=EMISSION runat=server></label></td>
					<td><label id=FREQ_GAIN runat=server></label></td>
					<td><label id=AERIALLINE_HEIGHT runat=server></label></td>
				</tr>
				<tr>
					<th class="table-col-bg" colspan="6">รายละเอียดการแพร่คลื่นความถี่ (โปรดระบุค่าพารามิเตอร์ที่ตรวจสอบ)</th>
				</tr>
				<tr>
					<td colspan="6" style="height: 204px"><label id=INSP_DESC runat=server></label></td>
				</tr>
			</tbody>
		</table>
		<table class="table table-bordered mb-10" style="margin-top: -1px">
			<tbody>
				<tr>
					<th style="width: 150px">ความเห็นผู้ตรวจ</td>
					<td colspan="5"><label id=INSP_COMMENT runat=server></label></td>
				</tr>
				<tr>
					<th>เครื่องมือวัด</th>
					<td colspan="5"><label id=INSP_MACHINE runat=server></label></td>
				</tr>
				<tr>
					<th>วันที่ตรวจสอบ</th>
					<td colspan="5"><label id=INSP_DATEF runat=server></label></td>
				</tr>
			</tbody>
		</table>

		<table class="table table-bordered">
			<tbody>
				<tr>
					<th style="width: 150px">วันที่รายงาน</th>
					<td colspan="2"><label id=REPORT_DATEF runat=server></label></td>
				</tr>
				<tr>
					<th style="width: 150px" rowspan="4">ผู้ตรวจสอบ</th>
					<td class="text-center pt-15" style="width: 302px">(<span class="blank" style="width: 250px"><label id=INSP_NAME1 runat=server></label></span>)</td>
					<td class="text-center pt-15">(<span class="blank" style="width: 250px"><label id=INSP_NAME2 runat=server></label></span>)</td>
				</tr>
				<tr>
					<td class="text-center">ตำแหน่ง: <span class="blank" style="width: 230px"><label id=INSP_POSITION1 runat=server></label></span></td>
					<td class="text-center">ตำแหน่ง: <span class="blank" style="width: 230px"><label id=INSP_POSITION2 runat=server></label></span></td>
				</tr>
				<tr>
					<td class="text-center pt-15">(<span class="blank" style="width: 250px"><label id=INSP_NAME3 runat=server></label></span>)</td>
					<td class="text-center pt-15">(<span class="blank" style="width: 250px"><label id=INSP_NAME4 runat=server></label></span>)</td>
				</tr>
				<tr>
					<td class="text-center">ตำแหน่ง: <span class="blank" style="width: 230px"><label id=INSP_POSITION3 runat=server></label></span></td>
					<td class="text-center">ตำแหน่ง: <span class="blank" style="width: 230px"><label id=INSP_POSITION4 runat=server></label></span></td>
				</tr>
				<tr>
					<th style="width: 150px">ผู้อนุมัติ</th>
					<td class="text-center pt-15" colspan="2">
						<p>(<span class="blank" style="width: 250px"><label id=DIRECTOR runat=server></label></span>)</p>
						<p><label id=APPROVE_POSITION runat=server></label></p>
						<p>วันที่<span class="blank" style="width: 200px"></span></p>
					</td>
				</tr>
			</tbody>
		</table>
	</section>

	<section class="sheet padding-5mm">
		<table class="table table-bordered isof-heading">
			<tbody>
				<tr>
					<td>
						<img src="img/logo.png" class="img-responsive center-block">
					</td>
					<td class="text-center">
						<p>รายงานการตรวจสอบมาตรฐานทางเทคนิคของการแพร่คลื่นวิทยุ</p>
						<p>สำนักงาน กสทช. เขต<span class="blank" style="width: 200px"></span></p>
					</td>
				</tr>
			</tbody>
		</table>

		<table class="table table-bordered">
			<tbody>
				<tr>
					<th style="width: 150px"><u>ผลการตรวจสอบ</u></th>
					<td colspan="3">
						<p>ชื่อสถานี: <span class="blank" style="width: 538px"></span></p>
						<p>ที่อยู่: <span class="blank" style="width: 558px"></span></p>
					</td>
				</tr>
				<tr>
					<td colspan="4" style="height: 888px"></td>
				</tr>
				<tr>
					<td rowspan="2">
						<p>ผู้ตรวจสอบ</p>
						<p>สำนักงาน กสทช.</p>
						<p>เขต<span class="blank" style="width: 114px"></span></p>
					</td>
					<td class="ve-m" style="width: 250px">ชื่อ-นามสกุล<span class="blank" style="width: 171px"></span></td>
					<td class="ve-m"></td>
					<td rowspan="2" style="width: 190px">
						<p>ทำการตรวจสอบ</p>
						<p>วันที่<span class="blank" style="width: 151px"></span></p>
					</td>
				</tr>
				<tr>
					<td class="ve-m" style="width: 250px">ชื่อ-นามสกุล<span class="blank" style="width: 171px"></span></td>
					<td class="ve-m"></td>
				</tr>
			</tbody>
		</table>
	</section>

	<section class="sheet padding-5mm">
		<table class="table table-bordered isof-heading">
			<tbody>
				<tr>
					<td>
						<img src="img/logo.png" class="img-responsive center-block">
					</td>
					<td class="text-center">
						<p>รายงานการตรวจสอบมาตรฐานทางเทคนิคของการแพร่คลื่นวิทยุ</p>
						<p>สำนักงาน กสทช. เขต<span class="blank" style="width: 200px"></span></p>
					</td>
				</tr>
			</tbody>
		</table>

		<table class="table table-bordered">
			<tbody>
				<tr>
					<th style="width: 150px"><u>แผนที่มุมกว้าง</u></th>
					<td colspan="3">
						<p>ชื่อสถานี: <span class="blank" style="width: 538px"></span></p>
						<p>ที่อยู่: <span class="blank" style="width: 558px"></span></p>
					</td>
				</tr>
				<tr>
					<td colspan="4" style="height: 888px"></td>
				</tr>
				<tr>
					<td rowspan="2">
						<p>ผู้ตรวจสอบ</p>
						<p>สำนักงาน กสทช.</p>
						<p>เขต<span class="blank" style="width: 114px"></span></p>
					</td>
					<td class="ve-m" style="width: 250px">ชื่อ-นามสกุล<span class="blank" style="width: 171px"></span></td>
					<td class="ve-m"></td>
					<td rowspan="2" style="width: 190px">
						<p>ทำการตรวจสอบ</p>
						<p>วันที่<span class="blank" style="width: 151px"></span></p>
					</td>
				</tr>
				<tr>
					<td class="ve-m" style="width: 250px">ชื่อ-นามสกุล<span class="blank" style="width: 171px"></span></td>
					<td class="ve-m"></td>
				</tr>
			</tbody>
		</table>
	</section>

	<section class="sheet padding-5mm">
		<table class="table table-bordered isof-heading">
			<tbody>
				<tr>
					<td>
						<img src="img/logo.png" class="img-responsive center-block">
					</td>
					<td class="text-center">
						<p>รายงานการตรวจสอบมาตรฐานทางเทคนิคของการแพร่คลื่นวิทยุ</p>
						<p>สำนักงาน กสทช. เขต<span class="blank" style="width: 200px"></span></p>
					</td>
				</tr>
			</tbody>
		</table>

		<table class="table table-bordered">
			<tbody>
				<tr>
					<th style="width: 150px"><u>แผนที่มุมแคบ</u></th>
					<td colspan="3">
						<p>ชื่อสถานี: <span class="blank" style="width: 538px"></span></p>
						<p>ที่อยู่: <span class="blank" style="width: 558px"></span></p>
					</td>
				</tr>
				<tr>
					<td colspan="4" style="height: 888px"></td>
				</tr>
				<tr>
					<td rowspan="2">
						<p>ผู้ตรวจสอบ</p>
						<p>สำนักงาน กสทช.</p>
						<p>เขต<span class="blank" style="width: 114px"></span></p>
					</td>
					<td class="ve-m" style="width: 250px">ชื่อ-นามสกุล<span class="blank" style="width: 171px"></span></td>
					<td class="ve-m"></td>
					<td rowspan="2" style="width: 190px">
						<p>ทำการตรวจสอบ</p>
						<p>วันที่<span class="blank" style="width: 151px"></span></p>
					</td>
				</tr>
				<tr>
					<td class="ve-m" style="width: 250px">ชื่อ-นามสกุล<span class="blank" style="width: 171px"></span></td>
					<td class="ve-m"></td>
				</tr>
			</tbody>
		</table>
	</section>

	<section class="sheet padding-5mm">
		<table class="table table-bordered isof-heading">
			<tbody>
				<tr>
					<td>
						<img src="img/logo.png" class="img-responsive center-block">
					</td>
					<td class="text-center">
						<p>รายงานการตรวจสอบมาตรฐานทางเทคนิคของการแพร่คลื่นวิทยุ</p>
						<p>สำนักงาน กสทช. เขต<span class="blank" style="width: 200px"></span></p>
					</td>
				</tr>
			</tbody>
		</table>

		<table class="table table-bordered">
			<tbody>
				<tr>
					<th style="width: 150px"><u>ภาพถ่าย</u></th>
					<td colspan="3">
						<p>ชื่อสถานี: <span class="blank" style="width: 538px"></span></p>
						<p>ที่อยู่: <span class="blank" style="width: 558px"></span></p>
					</td>
				</tr>
				<tr>
					<td colspan="4" style="height: 888px"></td>
				</tr>
				<tr>
					<td rowspan="2">
						<p>ผู้ตรวจสอบ</p>
						<p>สำนักงาน กสทช.</p>
						<p>เขต<span class="blank" style="width: 114px"></span></p>
					</td>
					<td class="ve-m" style="width: 250px">ชื่อ-นามสกุล<span class="blank" style="width: 171px"></span></td>
					<td class="ve-m"></td>
					<td rowspan="2" style="width: 190px">
						<p>ทำการตรวจสอบ</p>
						<p>วันที่<span class="blank" style="width: 151px"></span></p>
					</td>
				</tr>
				<tr>
					<td class="ve-m" style="width: 250px">ชื่อ-นามสกุล<span class="blank" style="width: 171px"></span></td>
					<td class="ve-m"></td>
				</tr>
			</tbody>
		</table>
	</section>
</body>

</html>