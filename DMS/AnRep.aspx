<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AnRep.aspx.cs" Inherits="AFMProj.DMS.AnRep" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <script language=javascript>
        $(function(){
            $("a[rel=AnRep]").addClass("is-active");
       
         <%if(tbH!=null){ %>
                $('#searchSection').collapse();
                  $('.afms-btn-editscanning').show();
                  $('.afms-btn-editsearch').show();
                  $('.afms-btn-hidesearch').hide();
                  $('#FormSch').show();
            <%}else{ %>
                $('#FormSch').show();
            <%} %>
         });
        function schData() {
            var parms = []
            $("#FormSch select").each(function () {
                parms.push(this.id + "=" + this.value);
            });
            $("#FormSch input[type=text]").each(function () {
                parms.push(this.id + "=" + escape(this.value));
            });
            location = location.toString().replace(location.search, "") + "?" + parms.join('&');
        }

    </script>
</head>
<body>
	<div class="afms-sec-container">
		<!--#include file="../_inc/Hd.asp"-->

		<div class="afms-sec-breadcrumb">
			<ul>
				<li><a href="" class="afms-ic_home"></a> <span class="afms-ic_next"></span></li>
				<li><a href="">DMS</a> <span class="afms-ic_next"></span></li>
				<li>การวิเคราะห์ข้อมูล <span class="afms-ic_next"></span></li>
                <li>รายงานการตรวจสอบ</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../DMS/Menu.asp"-->
			 <form id=FormSch runat=server>

			<div class="col-md-12">
				<div class="afms-content">
					<div class="afms-page-title">
						รายงานการตรวจสอบ
					</div>
					<button class="afms-btn afms-btn-primary afms-btn-editsearch" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">แก้ไขการค้นหา</button>
					<button class="afms-btn afms-btn-hidesearch" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">ซ่อน</button>

					<div class="collapse in" id="searchSection">
						<div class="row">
							<div class="col-md-3">
								<div class="afms-field afms-field_select">
									<label>สำนักงานเขต</label>
									<select id=OffID runat=server>
                                        <option value="0" selected>= ทั้งหมด =</option>
										<option value="1">เขต 11 (กรุงเทพมหานคร)</option>
                                        <option value="2">เขต 22 (อุบลราชธานี)</option>
                                        <option value="3">เขต 31 (ลำปาง)</option>
                                        <option value="4">เขต 41 (สงขลา)</option>
                                        <option value="5">เขต 12 (จันทบุรี)</option>
                                        <option value="6">เขต 21 (ขอนแก่น)</option>
                                        <option value="7">เขต 23 (นครราชสีมา)</option>
                                        <option value="8">เขต 24 (อุดรธานี)</option>
                                        <option value="9">เขต 32 (เชียงใหม่)</option>
                                        <option value="10">เขต 33 (พิษณุโลก)</option>
                                        <option value="11">เขต 42 (ภูเก็ต)</option>
                                        <option value="12">เขต 43 (นครศรีธรรมราช)</option>
                                        <option value="13">เขต 44 (สุราษฎร์ธานี)</option>
                                        <option value="14">เขต 45 (ชุมพร)</option>
                                        <option value="15">เขต 13 (สุพรรณบุรี)</option>
                                        <option value="16">เขต 14 (ปราจีนบุรี)</option>
                                        <option value="17">เขต 34 (เชียงราย)</option>
                                        <option value="18">เขต 15 (อ่างทอง)</option>
                                        <option value="19">เขต 16 (ราชบุรี)</option>
                                        <option value="21">เขต 35 (นครสวรรค์)</option>
									</select>
									<span class="bar"></span>
								</div>
							</div>
                             <div id="col-DataType" class="col-md-3">
							<div class="afms-field afms-field_select">
								<label>ประเภทการตรวจสอบ</label>
								<select id="TypeID" runat="server">
									<option value="0" selected>= ทั้งหมด =</option>
									<option value="1">การตรวจสอบตามแผน</option>
									<option value="2">การตรวจสอบเรื่องร้องเรียน</option>
                                    <option value="3">การตรวจสอบ สถานีวิทยุโทรทัศน์ </option>
                                    <option value="4">การตรวจสอบ ร้านค้าเครื่องวิทยุคมนาคม</option>
							    </select>
								<span class="bar"></span>
							</div>
						</div>

							<div class="col-md-3">
								    <div class="afms-field afms-field_datepicker">
									    <label>ช่วงเวลาจาก</label>
									    <input id=fDt runat=server type="text" placeholder="DD/MM/YYYY">
									    <span class="bar"></span>
									    <i class="afms-ic_date"></i>
								    </div>
							    </div>
							    <div class="col-md-3">
								    <div class="afms-field afms-field_datepicker">
									    <label>ถึง</label>
									    <input id=tDt runat=server type="text" placeholder="DD/MM/YYYY">
									    <span class="bar"></span>
									    <i class="afms-ic_date"></i>
								    </div>
							    </div>
                            </div>
                            <div class="row">
							    <div class="col-md-3">
								<div class="afms-field afms-field_input">
									<label>สถานี</label>
									<input type=text id=SName runat=server />
									<span class="bar"></span>
								</div>
							</div>

						 <div class="col-md-6">
								<div class="afms-field afms-field_input">
									<label>ที่อยู่</label>
									<input type=text id=SAdr runat=server />
									<span class="bar"></span>
								</div>
							</div>
							     </div>

                            
                         
                            
                             <div class="row">
							
							<div class="col-md-12 text-center">
								<a href="javascript:schData()"  class="afms-btn afms-btn-primary"><i class="afms-ic_search"></i> ค้นหา</a>
							</div>
						</div>
					</div>
				</div>
				 <%if(tbH!=null){ %>
				<div class="afms-content print-content" style="margin-top: 20px;">
                	<div class="row">
						<div class="col-md-12">
				
					    ผลการค้นหา : <%=tbH.Rows[0]["nTotal"] %> รายการ
					  <%if(tbD.Rows.Count>0){ %>
						<div class="afms-sec-table">
							<table class="table table-condensed text-center afms-table-responsive">
								<thead>
									<tr>
										<th style="width: 60px">ลำดับ</th>
										<th>วันตรวจสอบ</th>
										<th>สำนักงาน กสทช. เขต</th>
                                        <th>ชื่อสถานี</th>
                                     	<th>ความถี่(MHz)</th>
										<th>ผลการตรวจสอบ</th>

										 <th class="no-print-page"  style="width: 60px">ข้อมูล</th>
                                       
									</tr>
								</thead>
								<tbody>
                                <%for(int i=0;i<tbD.Rows.Count;i++){ %>
									<tr>
										<td data-th="ลำดับ"><%=GetNo(i) %></td>
										<td data-th="วัน-เวลา"><%=string.Format("{0:dd/MM/yyyy}",tbD.Rows[i]["INSP_DATEF"]) %></td>
								      <td data-th="สำนักงาน กสทช. เขต"><%=tbD.Rows[i]["Office_Name"] %></td>
                                           <td data-th="ชื่อสถานี"><%=tbD.Rows[i]["S_Name"] %></td>
                                   
										<td data-th="ความถี่(MHz)"><%=string.Format("{0:0.0000}",tbD.Rows[i]["Freq"]) %></td>
                                        <td data-th="ผลการตรวจสอบ"><%=tbD.Rows[i]["INSP_DESC"] %></td>

                                    
										    <td class="no-print-page">
											    <a target=_blank href="AnRepDet.aspx?typeid=<%=tbD.Rows[i]["TypeID"] %>&s_id=<%=tbD.Rows[i]["S_ID"] %>" class="afms-btn afms-btn-view afms-ic_view"></a>
										    </td>
                                     
									</tr>
                                    <%} %>
								</tbody>
							</table>
						</div>

                        <!--#include file="../_inc/Page.asp"-->
						
                        <div class="row no-print-page">
						<div class="col-md-12 text-center">
							<a href="javascript:exportXls()" class="afms-btn afms-btn-secondary">
								<i class="afms-ic_download"></i> Export to Excel
							</a>
							<a href="javascript:printPage()" class="afms-btn afms-btn-secondary">
								<i class="afms-ic_print"></i> พิมพ์
							</a>
						</div>
                       
                        <%} %>
                         </div>
					</div>
					<%} %>
                    

						
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
