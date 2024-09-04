<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AnChkFq.aspx.cs" Inherits="AFMProj.DMS.AnChkFq" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <script language=javascript>
        $(function () {

            

            $("a[rel=AnChkFq]").addClass("is-active");

            updateSubSelect('RegID', 'AreaID', '<%=AreaID.Value %>');
            updateSubSelect('AreaID', 'PoiID', '<%=PoiID.Value %>');
            $("#RegID").change(function () {
                updateSubSelect(this.id, 'AreaID');
                updateSubSelect('AreaID', 'PoiID');
            });
            $("#AreaID").change(function () {
                updateSubSelect(this.id, 'PoiID');
            });
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

        function playRec(datapath,playlist){
            var lg = $(this).lightGallery({
                    width: '400px',
                    height: '300px',
                    dynamic: true,
                    mode: 'lg-fade',
                    addClass: 'fixed-size',
                    counter: false,
                    download: false,
                    startClass: '',
                    enableSwipe: false,
                    enableDrag: false,
                    closable: false,
                    dynamicEl: [{
                        "iframe":true,
                        "src": "PlayRec2.aspx?datapath="+datapath+"&playlist="+playlist,
                     }]
                });
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
                <li>ตรวจสอบการใช้ความถี่</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../DMS/Menu.asp"-->
			 <form id=FormSch runat=server>

			<div class="col-md-12">
				<div class="afms-content">
					<div class="afms-page-title">
						การค้นหาการครอบครองความถี่ แยกความถี่
					</div>
					<button class="afms-btn afms-btn-primary afms-btn-editsearch" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">แก้ไขการค้นหา</button>
					<button class="afms-btn afms-btn-hidesearch" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">ซ่อน</button>

					<div class="collapse in" id="searchSection">
						<div class="row">
							<div class="col-md-3">
								<div class="afms-field afms-field_select">
									<label>ภาค</label>
									<select id=RegID runat=server>
										<option>Option 1</option>
										<option>Option 2</option>
										<option>Option 3</option>
										<option>Option 4</option>
										<option>Option 5</option>
									</select>
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-3">
								<div class="afms-field afms-field_select">
									<label>เขต</label>
									<select id=AreaID runat=server>
										<option>Option 1</option>
										<option>Option 2</option>
										<option>Option 3</option>
										<option>Option 4</option>
										<option>Option 5</option>
									</select>
									<span class="bar"></span>
									<div style='display:none'> <select id=AreaID_raw runat=server></select></div>
								</div>
							</div>
						
							<div class="col-md-4">
								<div class="afms-field afms-field_select">
									<label>Equipment</label>
									<select id=PoiID runat=server data-live-search="true">
										<option>Option 1</option>
										<option>Option 2</option>
										<option>Option 3</option>
										<option>Option 4</option>
										<option>Option 5</option>
									</select>
									<span class="bar"></span>
									<div style='display:none'> <select id=PoiID_raw runat=server></select></div>
								</div>
							</div>
							</div>
						<div class="row">
                          <div class="col-md-3">
								<div class="afms-field afms-field_input">
									<label>คลื่นความถี่ (MHz)</label>
									<input type=text id=fFreq runat=server />
									<span class="bar"></span>
								</div>
							</div>
                            <div class="col-md-3">
								<div class="afms-field afms-field_input">
									<label>ถึงความถี่ (MHz)</label>
									<input type=text id=tFreq runat=server />
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
										<th>
                                ความถี่
                            </th>
                            <th>
                                % Occupancy

                            </th>
                             <th>
                                วันที่ตรวจสอบ
                            </th>
                            <th>
                               สำนักงาน กสทช เขต
                            </th>
                            <th>
                                อุปกรณ์
                            </th>
                            <th>
                                หน่วยงานผู้ใช้คลื่น
                            </th>
                                       
									</tr>
								</thead>
								<tbody>
                                <%for(int i=0;i<tbD.Rows.Count;i++){ %>
									<tr>
										<td data-th="ลำดับ"><%=GetNo(i) %></td>
										 <td data-th="ความถี่(MHz)"><%=string.Format("{0:0.0000}",tbD.Rows[i]["Freq"]) %></td>
										<td data-th="% Occupancy"><%=string.Format("{0:0.00}",tbD.Rows[i]["Occ"]) %></td>
										<td data-th="วันที่ตรวจสอบ"><%=string.Format("{0:dd/MM/yyyy}",tbD.Rows[i]["DtBegin"]) %></td>
									  <td data-th="สำนักงาน กสทช เขต"><%=tbD.Rows[i]["Area"] %></td>
                                       <td data-th="อุปกรณ์"><%=tbD.Rows[i]["Equip"] %></td>
										<td data-th="หน่วยงานผู้ใช้คลื่น"><%=tbD.Rows[i]["HostName"] %></td>
                                     
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
