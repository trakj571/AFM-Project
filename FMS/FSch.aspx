<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FSch.aspx.cs" Inherits="AFMProj.FMS.FSch" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <style>#FormSch {display:none}</style>
    <script language=javascript>
        $(function(){
            $("a[rel=FSch]").addClass("is-active");
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
				<li><a href="">FMS</a> <span class="afms-ic_next"></span></li>
				<li>ฐานข้อมูลการจัดสรรคลื่นความถี่</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../FMS/Menu.asp"-->
			<form id=FormSch runat=server>

			<div class="col-md-12">
				<div class="afms-content">
					<div class="afms-page-title is-online">
						ค้นหาฐานข้อมูลการจัดสรรคลื่นความถี่
					</div>
					<button class="afms-btn afms-btn-primary afms-btn-editsearch" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">แก้ไขการค้นหา</button>
					<button class="afms-btn afms-btn-hidesearch" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">ซ่อน</button>

					<div class="collapse in" id="searchSection">
						<div class="row">
							<div class="col-md-3">
								<div class="afms-field afms-field_select">
									<label>ย่านความถี่</label>
									<select id="FBand" runat="server" data-live-search="true">
                                    <option value="">ทั้งหมด</option>
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
								<div class="afms-field afms-field_select">
									<label>คลื่นความถี่ (MHz)</label>
									<input type=text id="FMHz" runat="server" />
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-3">
								<div class="afms-field afms-field_select">
									<label>ถึงความถี่ (MHz)</label>
									<input type=text id="FMHz2" runat="server" />
								
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-3">
								<div class="afms-field afms-field_select">
									<label>Bandwidth (kHz)</label>
									<input type=text id="BandWidth" runat="server" />
								
									<span class="bar"></span>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-4">
								<div class="afms-field afms-field_input">
									<label>ผู้ใช้คลื่นความถี่</label>
									<input id="Host" runat=server type="text">
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_input">
									<label>ผู้ให้ใช้คลื่นความถี่ร่วม</label>
									<input id=Name runat=server type="text">
									<span class="bar"></span>
								</div>
							</div>

							<div class="col-md-4">
								<div class="afms-field afms-field_input">
									<label>รายละเอียดเพิ่มเติม</label>
									<input id=Detail runat=server type="text">
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_select">
									<label>กิจการ</label>
									<select id=ActivityID runat=server data-live-search="true">
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
									<label>การนำไปใช้</label>
									<select id=UsesID runat=server data-live-search="true">
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
                                    <label>สถานะปัจจุบัน</label>
                                    <select id="Status" runat="server" class="selectpicker">
                                        <option value="">กรุณาเลือก</option>
                                        <option value="A">ใช้</option>
                                        <option value="E">สิ้นสุด</option>
                                        <option value="C">ยกเลิก</option>
                                        <option value="X">สงวน</option>
                                         <option value="R">ขอคืน</option>
                                         <option value="W">รอการ Update</option>
                                    </select>
                                </div>
								 </div>
							<div class="col-md-12 text-center">
								<button onclick="schData()" class="afms-btn afms-btn-primary" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection"><i class="afms-ic_search"></i> ค้นหา</button>
							</div>
						</div>
					</div>
				</div>

				<%if(tbH!=null){ %>
				<div class="afms-content print-content" style="margin-top: 20px;">
					ผลการค้นหา : <%=tbH.Rows[0]["nTotal"] %> รายการ
					  <%if(tbD.Rows.Count>0){ %>
				        <div class="afms-sec-table">
                  		<table class="table table-condensed text-center afms-table-responsive" style="min-width: 1100px;">
							<thead>
								<tr>
									<th style="width: 60px">ลำดับ</th>
									<th style="width: 100px">ย่านความถี่</th>
									<th style="width: 100px">คลื่นความถี่ (MHz)</th>
									<th style="width: 100px">Bandwidth (KHz)</th>
									 <th style="">ผู้ใช้คลื่นความถี่</th>
                                     <th style="">ผู้ให้ใช้คลื่นความถี่</th>
                                     <th style="">กิจการ</th>
									<th>การนำไปใช้งาน</th>
									<th style="">สถานะปัจจุบัน</th>
                                    <th style="">วันที่อนุมัติ</th>
									<th class='no-print-page' style="width: 100px"></th>
								</tr>
							</thead>
							<tbody>
                             <%for(int i=0;i<tbD.Rows.Count;i++){ %>
							
								<tr>
									<td data-th="ลำดับ"><%=GetNo(i) %></td>
									<td data-th="ย่านความถี่"><%=tbD.Rows[i]["FBand"] %></td>
									<td data-th="คลื่นความถี่ (MHz)"><%=tbD.Rows[i]["FMHz"] %></td>
									<td data-th="Bandwidth (KHz)"><%=tbD.Rows[i]["BandWidth"] %></td>
									<td data-th="ผู้ใช้คลื่นความถี่">
										<span><%=tbD.Rows[i]["Name1"] %></span>
									</td>
									<td data-th="ผู้ให้ใช้คลื่นความถี่">
										<span><%=tbD.Rows[i]["Name2"] %></span>
									</td>
									<td data-th="กิจการ">
										<span><%=tbD.Rows[i]["Activity"] %></span>
									</td>
									<td data-th="การนำไปใช้งาน">
										<span><%=tbD.Rows[i]["Uses"] %></span>
									</td>
									  <td data-title="สถานะปัจจุบัน"><%=tbD.Rows[i]["Status"] %></td>
                                     <td data-title="วันที่อนุมัติ"><%=string.Format("{0:dd/MM/yyyy}",tbD.Rows[i]["DtIssu"]) %></td>
                                 

									<td  class='no-print-page'>
											<a class="afms-btn afms-ic_view"  href='FDet.aspx<%=getDetURL("fdid="+tbD.Rows[i]["Fdid"]) %>'></a>
										<!--<a class="IsFMSEdit afms-btn afms-ic_edit" href='FAdd.aspx?Fdid=<%=tbD.Rows[i]["Fdid"] %>'></a>
										<a class="IsFMSEdit afms-btn afms-ic_delete" href="javascript:delItem('fms.spFDBAdd','FDID','<%=tbD.Rows[i]["Fdid"] %>',1)"></a>
										-->	
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
					</div>
                        <%} %>
					<%} %>
					
				</div>
			</div>
            </form>
		</div>

		<div class="afms-push"></div>
	</div>

	<!--#include file="../_inc/Ft.asp"-->
</body>

</html>
