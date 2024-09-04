<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AnChk.aspx.cs" Inherits="AFMProj.FMS.AnChk" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <script language=javascript>
        $(function(){
            $("a[rel=AnChk]").addClass("is-active");

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

		function playRec(datapath, playlist) {
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
						"iframe": true,
                        "src": playlist ? "PlayRec3.aspx?datapath=" + datapath + "&playlist=" + playlist : "PlayRec3.aspx?scanid=" + datapath,
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
				<li><a href="">FMS</a> <span class="afms-ic_next"></span></li>
				<li>การวิเคราะห์ข้อมูล <span class="afms-ic_next"></span></li>
                <li>ตรวจสอบการใช้ความถี่</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../FMS/Menu.asp"-->
			 <form id=FormSch runat=server>

			<div class="col-md-12">
				<div class="afms-content">
					<div class="afms-page-title">
						ตรวจสอบการใช้ความถี่
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
							</div>
						<div class="row">
							<div class="col-md-3">
								<div class="afms-field afms-field_select">
									<label>Station</label>
									<select id=PoiID runat=server>
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
								    <div class="afms-field afms-field_select">
									    <label>Channel Space</label>
									    <select id=ChSp runat=server>
                                                <option value="0">= ทั้งหมด =</option>
                                                <option value="12500">12.5 kHz</option>
                                                <option value="25000">25.0 kHz</option>
                                                <option value="200000">200.0 kHz</option>
                                                <option value="250000">250.0 kHz</option>
                                                <option value="1000000">1.0 MHz</option>
                                                <option value="7000000">7.0 MHz</option>
                                                <option value="8000000">8.0 MHz</option>
                                  	    </select>
									    <span class="bar"></span>
								    </div>
						 </div>
                            <div class="row">
							
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
                            <div class="col-md-3">
								<div class="afms-field afms-field_select">
									<label>Mode</label>
									<select id=Mode runat=server>
                                            <option value="A">Scanning</option>
                                            <option value="M">Listening</option>
                                	</select>
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
										<th>Station</th>
                                        <%if(Mode.Value=="M"){ %>
                                            <th>ความถี่ (MHz)</th>
                                        <%} %>
										<th>วัน-เวลา เริ่มต้น</th>
										<th>วัน-เวลา สิ้นสุด</th>
										<th>Mode</th>
                                        <%if(Mode.Value=="M"){ %>
                                            <th>ระยะเวลา</th>
                                            <th></th>
                                        <%}else{ %>
										    <!--th style="width: 70px;">Event</!--th-->
										    <th class="no-print-page" style="width: 130px;">Field Strength<br>vs Channel</th>
										    <th class="no-print-page"  style="width: 110px;">Occupancy<br>vs Channel</th>
										    <th class="no-print-page"  style="width: 60px">ข้อมูล</th>
                                        <%} %>
									</tr>
								</thead>
								<tbody>
                                <%for(int i=0;i<tbD.Rows.Count;i++){ %>
									<tr>
										<td data-th="ลำดับ"><%=GetNo(i) %></td>
										<td data-th="Station"><%=tbD.Rows[i]["Station"] %></td>
                                        <%if(Mode.Value=="M"){ %>
                                            <td data-th="ความถี่(MHz)"><%=string.Format("{0:0.00}",tbD.Rows[i]["Freq"]) %></td>
                                        <%} %>
										<td data-th="วัน-เวลา เริ่มต้น"><%=string.Format("{0:dd/MM/yyyy HH:mm}",tbD.Rows[i]["DtBegin"]) %></td>
										<td data-th="วัน-เวลา สิ้นสุด"><%=string.Format("{0:dd/MM/yyyy HH:mm}",tbD.Rows[i]["DtEnd"]) %></td>
										<td data-th="Mode"><%=tbD.Rows[i]["ModeName"] %></td>
										
                                        <%if(Mode.Value=="M"){ %>
                                            <td data-th="ระยะเวลา"><%=tbD.Rows[i]["nTime"] %></td>
											<%if (cConvert.ToInt(tbD.Rows[i]["ScanID"]) == 0){ %>
                                             <td data-th="Play">
                                                 <a href="javascript:playRec('<%=tbD.Rows[i]["DataPath"] %>','<%=tbD.Rows[i]["PlayList"] %>')">
												    Play
											    </a>
                                                <a href="http://lmtr.nbtc.go.th/afm/1.01/service/download.php?playlist=<%=tbD.Rows[i]["PlayList"] %>">
												    Download
											    </a>
                                            </td>
										<%} else { %>
											<td data-th="Play">
                                                 <a href="javascript:playRec('<%=tbD.Rows[i]["ScanID"] %>')">
												    Play
											    </a>
                                                <a href="Download.aspx?scanid=<%=tbD.Rows[i]["ScanID"] %>" target="_blank">
												    Download
											    </a>
                                            </td>
										<%} %>
                                        <%}else{ %>
                                            <!--td data-th="Event">
											    <a href="AnEvent.aspx?scanid=<%=tbD.Rows[i]["ScanID"] %>" class="afms-btn afms-btn-showevent">
												    <%=tbD.Rows[i]["nEvent"] %>
											    </a>
										</td-->
										    <td class="no-print-page"  data-th="Field Strength vs Channel">
											    <a href="AnFSTR.aspx?scanid=<%=tbD.Rows[i]["ScanID"] %>" class="afms-btn afms-btn-view afms-ic_view"></a>
										    </td>
										    <td class="no-print-page"  data-th="Occupancy vs Channel">
											    <a href="AnOcc.aspx?scanid=<%=tbD.Rows[i]["ScanID"] %>" class="afms-btn afms-btn-view afms-ic_view"></a>
										    </td>
										    <td class="no-print-page">
											    <a href="AnInfo.aspx?scanid=<%=tbD.Rows[i]["ScanID"] %>" class="afms-btn afms-btn-view afms-ic_view"></a>
										    </td>
                                        <%} %>
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
