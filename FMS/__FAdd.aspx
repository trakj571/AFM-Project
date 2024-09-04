<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="__FAdd.aspx.cs" Inherits="AFMProj.FMS.FAdd" %>
<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
      <script language=javascript src="../_inc/js/dpv2.js"></script>
    <script language=javascript src="../_inc/js/pvscp2.js"></script>
   
    <script language=javascript>
        $(function(){
            $("a[rel=FAdd]").addClass("is-active");

            setProv2('sProv2', '<%=PATCode.Substring(0,2) %>');
            setAumphur2('sAumphur2', '<%=PATCode.Substring(0,2) %>', '<%=PATCode.Substring(0,4) %>');
            setTumbon2('sTumbon2', '<%=PATCode.Substring(0,4) %>', '<%=PATCode.Substring(0,6) %>');

            loadItem();
             //$('.afms-field_select select').selectpicker();
             msgbox_save(<%=retID %>,"FDet.aspx?fdid=<%=retID %>");
        });

        function openHost(){
            openDialog("HSchDialog.aspx");
        }

        function loadItem(){
            $("#HDet").load("data/dHDet.ashx?hid="+$("#HID").val());
        }
    </script>
</head>
<body>
	<div class="afms-sec-container">
		<!--#include file="../_inc/Hd.asp"-->

		<div class="afms-sec-breadcrumb">
			<ul>
				<li><a href="" class="afms-ic_home"></a> <span class="afms-ic_next"></span></li>
				<li><a href="">FMS</a> <span class="afms-ic_next"></span></li>
				<li>ฐานข้อมูลความถี่</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../FMS/Menu.asp"-->
			
               <form id=Form1 runat=server method=post onsubmit="retriveLatLon()">
		
			<div class="col-md-12">
				<div class="afms-content">
					<div class="afms-page-title is-online">
						ฐานข้อมูลความถี่
					</div>
					
					<div class="row">
						<div class="col-md-12">
							<h5 class="title-form" style="margin-top: 0"><i class="afms-ic_play"></i> รายละเอียดย่านความถี่</h5>
						</div>
						<div class="col-md-3">
							<div class="afms-field afms-field_select">
								<label>ความถี่ย่าน</label>
								<select id="FBand" runat="server" data-live-search="true">
									<option value="LF">LF</option>
									<option value="MF">MF</option>
									<option value="HF">HF</option>
									<option value="VHF">VHF</option>
									<option value="UHF">UHF</option>
                                    <option value="SHF">SHF</option>
								</select>
								<span class="bar"></span>
							</div>
						</div>
						<div class="col-md-3">
							<div class="afms-field afms-field_input">
								<label>ย่านความถี่ (MHz)</label>
								<input type=text id="FBand2" runat="server" />
									
								<span class="bar"></span>
							</div>
						</div>
						<div class="col-md-3">
							<div class="afms-field afms-field_select">
								<label>คลื่นความถี่ (MHz)</label>
								<input type=text id="FMHz" runat="server" />
								<span class="bar"></span>
							</div>
						</div>
						<div class="col-md-3">
							<div class="afms-field afms-field_select">
								<label>คู่คลื่นความถี่ (MHz)</label>
								<input type=text id="FMHz2" runat="server" />
								<span class="bar"></span>
							</div>
						</div>
						<div class="col-md-3">
							<div class="afms-field afms-field_select">
								<label>Brandwidth (kHz)</label>
								<input type=text id="BandWidth" runat="server" />
								
								<span class="bar"></span>
							</div>
						</div>
					</div>

					<div class="row">
						<div class="col-md-12">
							<h5 class="title-form"><i class="afms-ic_play"></i> รายละเอียดผู้ครอบครอง</h5>
						</div>
                        <input type=hidden id=HID runat=server />
                        <div id=HDet>
						
                        </div>
						<div class="col-md-12 text-center" style="margin-bottom: 30px;">	
							<a href="javascript:openHost()" class="afms-btn afms-btn-secondary">
								<i class="afms-ic_search"></i> ค้นหาผู้ใช้คลื่นความถี่
							</a>
						</div>

						

						<div class="col-md-4">
							<div class="afms-field afms-field_select">
								<label>ค่าตอบแทนคลื่นความถี่</label>
								<input type=text id="Fee" runat="server" />
								
								<span class="bar"></span>
							</div>
						</div>
						<div class="col-md-4">
							<div class="afms-field afms-field_input">
								<label>มติที่ประชุม/FON</label>
								<input type="text" id=Fon runat=server>
								<span class="bar"></span>
							</div>
						</div>
						<div class="col-md-4">
							<div class="afms-field afms-field_input">
								<label>หนังสืออนุญาตที่</label>
								<input type="text" id="LicNo" runat="server">
								<span class="bar"></span>
							</div>
						</div>
						<div class="col-md-4">
							<div class="afms-field afms-field_datepicker">
								<label>วันที่อนุญาต</label>
								<input id=DtIssu type="text" runat="server" placeholder="00/00/0000">
								<span class="bar"></span>
								<i class="afms-ic_date"></i>
							</div>
						</div>
						<div class="col-md-4">
							<div class="afms-field afms-field_datepicker">
								<label>สิ้นสุดการอนุญาต</label>
								<input id=DtExp type="text" runat="server" placeholder="00/00/0000">
								<span class="bar"></span>
								<i class="afms-ic_date"></i>
							</div>
						</div>
						<div class="col-md-4">
							<div class="afms-field afms-field_input">
								<label>ระยะเวลาการอนุญาต (ปี)</label>
								<input id=Yr type="text" runat=server>
								<span class="bar"></span>
							</div>
						</div>
						<div class="col-md-4">
							<div class="afms-field afms-field_datepicker">
								<label>เตือนให้ขอขยายเวลาใช้ความถี่ล่าสุด</label>
								<input id=DtNF type="text" runat="server" placeholder="00/00/0000">
								<span class="bar"></span>
								<i class="afms-ic_date"></i>
							</div>
						</div>
						<div class="col-md-4">
							<div class="afms-field afms-field_datepicker">
								<label>รายงานล่าสุด</label>
								<input id=DtRep type="text" runat="server" placeholder="00/00/0000">
								<span class="bar"></span>
								<i class="afms-ic_date"></i>
							</div>
						</div>
						<div class="col-md-4 has-btn-plus">
							<div class="afms-field afms-field_select">
								<label>สถานะปัจจุบัน</label>
								<select id="StatID" runat="server" data-live-search="true">
									<option value="">== เลือก ==</option>
									<option value="A">ใช้</option>
									<option value="E">สิ้นสุด</option>
									<option value="C">ยกเลิก</option>
									<option value="X">สงวน</option>
								</select>
								<span class="bar"></span>
							</div>
							<!--button class="afms-btn afms-btn-primary afms-ic_plus"></button-->
						</div>
					</div>

					<div class="row">
						<div class="col-md-12">
							<h5 class="title-form"><i class="afms-ic_play"></i> รายละเอียดการใช้ความถี่</h5>
						</div>

						<div class="col-md-4">
							<div class="afms-field afms-field_select">
								<label>กิจการวิทยุคมนาคม</label>
								<select id="ActivityID" runat="server" data-live-search="true">
									<option value="1">Option 1</option>
									<option value="2">Option 2</option>
									<option value="3">Option 3</option>
									<option value="4">Option 4</option>
									<option value="5">Option 5</option>
								</select>
								<span class="bar"></span>
							</div>
						</div>
						<div class="col-md-4">
							<div class="afms-field afms-field_select">
								<label>การนำไปใช้งาน</label>
								<select  id="UsesID" runat="server" data-live-search="true">
									<option value="1">Option 1</option>
									<option value="2">Option 2</option>
									<option value="3">Option 3</option>
									<option value="4">Option 4</option>
									<option value="5">Option 5</option>
								</select>
								<span class="bar"></span>
							</div>
						</div>
						<div class="col-md-4">
							<div class="afms-field afms-field_select">
								<label>ผู้ใช้คลื่นความถี่ร่วม</label>
								<select id="HID2" runat="server" data-live-search="true">
									<option value="1">Option 1</option>
									<option value="2">Option 2</option>
									<option value="3">Option 3</option>
									<option value="4">Option 4</option>
									<option value="5">Option 5</option>
								</select>
								<span class="bar"></span>
							</div>
						</div>
					</div>

					<div class="row" style="margin-top: 20px">
						<div class="col-md-4">
							<div class="afms-field afms-field_input">
								<label>กำลังส่ง (KW)</label>
								<input id="PW" runat="server" type="text">
								<span class="bar"></span>
							</div>
						</div>
						<div class="col-md-4">
							<div class="afms-field afms-field_input">
								<label>ความสูงของเสา (ม.)</label>
								<input id="H" runat="server" type="text">
								<span class="bar"></span>
							</div>
						</div>
						<div class="clearfix"></div>
						<div class="col-md-4">
							<div class="afms-field afms-field_input">
								<label>ชื่อสถานี</label>
								<input id="StName" runat="server" type="text">
								<span class="bar"></span>
							</div>
						</div>
						<div class="col-md-4">
							<div class="afms-field afms-field_input">
								<label>ชื่อผู้ประกอบการ</label>
								<input id="CoName" runat="server" type="text">
								<span class="bar"></span>
							</div>
						</div>
						<div class="clearfix"></div>
						<div class="col-md-4">
							<div class="afms-field afms-field_input">
								<label>ที่อยู่</label>
								<input id="AdrNo" runat="server" type="text">
								<span class="bar"></span>
							</div>
						</div>
						<div class="col-md-4">
							<div class="afms-field afms-field_input">
								<label>ถนน</label>
								<input id="Road" runat="server" type="text">
								<span class="bar"></span>
							</div>
						</div>
						<div class="col-md-4">
							<div class="afms-field afms-field_select">
								<label>จังหวัด</label>
									<select id=sProv2  runat=server onchange="setAumphur2('sAumphur2',this.value,'0')" data-live-search="true">
                                        <option value="0">=== เลือก ===</option>
                                    </select>
								<span class="bar"></span>
							</div>
						</div>
						<div class="col-md-4">
							<div class="afms-field afms-field_select">
								<label>อำเภอ</label>
									<select id=sAumphur2 runat=server  disabled=disabled onchange="setTumbon2('sTumbon2',this.value,'0')" data-live-search="true">
                                        <option value="0">=== เลือก ===</option>
                                    </select>
								<span class="bar"></span>
							</div>
						</div>
						<div class="col-md-4">
							<div class="afms-field afms-field_select">
								<label>ตำบล</label>
									<select id=sTumbon2 runat=server disabled=disabled data-live-search="true">
                                        <option value="0">=== เลือก ===</option>
                                    </select>
								<span class="bar"></span>
							</div>
						</div>
					</div>

					<div class="row">
						<div class="col-md-4">
							<div class="afms-field afms-field_input">
								<label>ที่ตั้ง</label>
								<input id=Location runat=server type="text">
								<span class="bar"></span>
							</div>
						</div>
                        </div>

                        <div class="row" style="margin-top: 20px">
					
						<div class="col-md-12">
					      
                       <input type=hidden id=Lat runat=server value="" />
                       <input type=hidden id=Lng runat=server value="" />
                      
                       <!--#include file="../GIS/EMapEdit.asp"-->
                            
                    	</div>
					</div>
                    </div>
					<div class="row">
						<div class="col-md-12">
							<div class="afms-group-btn text-center">
								<input id="Submit1" type="submit" class="afms-btn afms-btn-secondary" value="บันทึก" style='width:auto' onserverclick="bSave_ServerClick" runat=server />
								
							</div>
						</div>
					</div>
				</div>
			</div>

            </form>
		</div>

		<div class="afms-push"></div>
	</div>

	<!--#include file="../_inc/Ft.asp"-->
</body>

</html>

