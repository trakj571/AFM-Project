<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AnSMon.aspx.cs" Inherits="AFMProj.FMS.AnSMon" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <script language=javascript>
        $(function(){
            $("a[rel=AnSMon]").addClass("is-active");
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
				<li>การวิเคราะห์ข้อมูล <span class="afms-ic_next"></span></li>
                <li>Sensor Monitor</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../FMS/Menu.asp"-->
			
            <form id=FormSch runat=server>
			<div class="col-md-12">
				<div class="afms-content">
					<div class="afms-page-title">
						Sensor Monitor
					</div>
					<button class="afms-btn afms-btn-primary afms-btn-editsearch" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">แก้ไขการค้นหา</button>
					<button class="afms-btn afms-btn-hidesearch" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">ซ่อน</button>

					<div class="collapse in" id="searchSection">
						<div class="row">
							<div class="col-md-4">
								<div class="afms-field afms-field_select">
									<label>Station</label>
									<select id="PoiID" runat="server">
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
								<div class="afms-field afms-field_datepicker">
									<label>ช่วงเวลา</label>
									<input id="fDt" runat="server" type="text" name="" placeholder="00/00/0000">
									<span class="bar"></span>
									<i class="afms-ic_date"></i>
								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_datepicker">
									<label>ถึง</label>
									<input id="tDt" runat="server" type="text" name="" placeholder="00/00/0000">
									<span class="bar"></span>
									<i class="afms-ic_date"></i>
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
                	<div class="row">
						<div class="col-md-12">
				
					    ผลการค้นหา : <%=tbH.Rows[0]["nTotal"] %> รายการ
					  <%if(tbD.Rows.Count>0){ %>

                        	<div class="afms-sec-table">
								<table id="sensorMonitor" class="table table-condensed text-center afms-table-responsive" style="min-width: 1200px">
									<thead>
										<tr>
											<th rowspan="2" style="width: 60px">ลำดับ</th>
											<th rowspan="2" style="width: 120px">Station</th>
											<th rowspan="2" style="width: 150px">Date-Time</th>
											<th colspan="4" style="background-color: #e8e8e8">Communication</th>
											<th colspan="5">Power</th>
											<th colspan="3" style="background-color: #e8e8e8">Environment</th>
										</tr>
                                      <tr>
											<th style="width: 50px">3G</th>
											<th style="width: 50px">LAN</th>
											<th style="width: 50px">WAN</th>
											<th style="width: 50px">GPS</th>
											<th style="width: 50px">UPS</th>
											<th style="width: 80px">Voltage</th>
											<th style="width: 80px">Current</th>
											<th style="width: 100px">Frequency</th>
											<th style="width: 80px">Energy</th>
											<th style="width: 60px">Temp</th>
											<th style="width: 60px">Hum</th>
											<th style="width: 60px">Door</th>
										</tr>
									</thead>
									<tbody>
                                      <%for(int i=0;i<tbD.Rows.Count;i++){ %>
										
										<tr>
											<td data-th="ลำดับ"><%=GetNo(i) %></td>
											<td data-th="Station">
												<span><%=tbD.Rows[i]["Name"] %></span>
											</td>
											<td data-th="Date-Time">
												<span><%=string.Format("{0:dd/MM/yyyy HH:mm}",tbD.Rows[i]["DtLog"]) %></span>
											</td>
											<td class="datath-large" data-th="Communication : 3G"><%=tbD.Rows[i]["f3G"] %></td>
											<td class="datath-large" data-th="Communication : LAN"><%=tbD.Rows[i]["LAN"]%></td>
											<td class="datath-large" data-th="Communication : WAN"><%=tbD.Rows[i]["WAN"]%></td>
											<td class="datath-large" data-th="Communication : GPS"><%=tbD.Rows[i]["GPS"]%></td>
											<td class="datath-large" data-th="Power : UPS"><%=tbD.Rows[i]["UPSPc"]%>%</td>
											<td class="datath-large" data-th="Power : Voltage"><%=tbD.Rows[i]["Voltage"]%></td>
											<td class="datath-large" data-th="Power : Current"><%=tbD.Rows[i]["Current"]%></td>
											<td class="datath-large" data-th="Power : Frequency"><%=tbD.Rows[i]["Frequency"]%></td>
											<td class="datath-large" data-th="Power : Energy"><%=tbD.Rows[i]["PAE"] %></td>
											<td class="datath-large" data-th="Environment : Temp"><%=tbD.Rows[i]["Temp"]%></td>
											<td class="datath-large" data-th="Environment : Humidity"><%=tbD.Rows[i]["Humidity"]%></td>
											<td class="datath-large" data-th="Environment : Door"><%=tbD.Rows[i]["Security"]%></td>
										</tr>
                                        <%} %>
									</tbody>
								</table>
							</div>
                             <!--#include file="../_inc/Page.asp"-->
						</div>

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
				</div>
			</div>
            </form>
		</div>

		<div class="afms-push"></div>
	</div>

	<!--#include file="../_inc/Ft.asp"-->
</body>

</html>
