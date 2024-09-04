<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AnInfo.aspx.cs" Inherits="AFMProj.FMS.AnInfo" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <script src="../_Inc/js/highstock.js"></script>
   
    <script language=javascript>
        var scanID = '<%=Request["scanID"] %>';
        $(function () {
            $("a[rel=AInfo]").addClass("is-active");
           // readSensor();
            dispChart(scanID,'fre-container');
        });

        function do_import() {
            location = "AImp.aspx?poiid=<%=tbS.Rows[0]["PoiID"] %>";
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
				<li>Frequency Monitoring</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../FMS/Menu.asp"-->
			

			<div class="col-md-12">
				<div class="afms-content" id="station<%=tbS.Rows[0]["PoiID"] %>">
					<div class="afms-page-title"><i class="afms-ic_record"></i><%=tbS.Rows[0]["Station"] %>
						<div class="pull-right">Time to operate: <span class="OprTime">-</span> <i class="is-lock"></i></div>
					</div>
					<div class="afms-station-shortstatus" data-toggle="modal" data-target="#fullStatus">
						Sensor Monitor : <span class="text-com">Communication : <span class="3G"></span></span> | <span class="text-ups">UPS : <span class="UPSPc"></span>% [<span class="UPSTime"></span> Min Left]</span> | <span class="text-scan">Scanner : <span class="SCN"></span></span> | <span class="text-power">Power : Plug</span> | <span class="text-sensor">Environment : <span class='TempStat'></span></span>
					</div>

					<div class="modal fade" id="fullStatus" tabindex="-1" role="dialog" aria-labelledby="fullStatusLabel">
						<div class="modal-dialog" role="document">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close afms-ic_close" data-dismiss="modal" aria-label="Close"></button>
									<h4 class="modal-title" id="fullStatusLabel">Sensor Monitor</h4>
								</div>
								<div class="modal-body">
									<div class="row">
										<div class="col-md-6 col-sm-6">
											<div class="panel panel-default afms-station-status panel-power" style="height: 205px">
												<div class="panel-heading">Power meter : Plug</div>
												<div class="panel-body">
													<p><b>Voltage :</b> <span class='Voltage'>-</span> Volt</p>
													<p><b>Current :</b> <span class='Current'>-</span> Amp</p>
													<p><b>Frequency :</b> <span class='Frequency'>-</span> Hz</p>
													<p><b>Positive Active Energy :</b> <span class='PAE'>-</span></p>
												</div>
											</div>

											<div class="panel panel-default afms-station-status panel-com">
												<div class="panel-heading">Communication</div>
												<div class="panel-body">
													<div class="row">
														<div class="col-md-6 col-sm-6">
															<p><b>3G :</b> <span class='3G'>-</span></p>
															<p><b>LAN :</b> <span class='LAN'>-</span></p>
															<p><b>WAN :</b> <span class='WAN'>-</span></p>
														</div>
														<div class="col-md-6 col-sm-6">
															<p><b>GPS :</b> <span class='GPS'>-</span></p>
														</div>
													</div>
												</div>
											</div>
										</div>
										<div class="col-md-6 col-sm-6">
											<div class="panel panel-default afms-station-status panel-ups">
												<div class="panel-heading">UPS : <span class='UPSPc'>-</span>%</div>
												<div class="panel-body">
													<p><b>Time to operate :</b> <span class='UPSTime'>-</span> Minutes</p>
												</div>
											</div>

											<div class="panel panel-default afms-station-status panel-scaner">
												<div class="panel-heading">Scanner : <span class='AtennaStat'></span></div>
												<div class="panel-body">
													<p><b>Antenna :</b> <span class='Atenna'></span></p>
												</div>
											</div>

											<div class="panel panel-default afms-station-status panel-sensor">
												<div class="panel-heading">Environment : <span class='TempStat'></span></div>
												<div class="panel-body">
													<p><b>Humidity :</b> <span class='Humidity'>-</span>%</p>
													<p><b>Temp :</b> <span class='Temp'>-</span> Celcius</p>
													<p><b>Security :</b> <span class='Security'>Door Close</span></p>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="text-right">
						<a href="FMon2File.aspx?poiid=<%=tbS.Rows[0]["PoiID"] %>" class="afms-btn afms-btn-secondary"><i class="afms-ic_file"></i>File Manager</a>
						   &nbsp; <button type="button" onclick="do_import()" class="afms-btn afms-btn-primary">Import</button>
                        </div>

					<div class="row">
						<div class="col-md-12">
							<div class="collapse in content-readonly" id="searchSection">
						<div class="row">
							<div class="col-md-12">
								<div class="afms-field afms-field_radio radio-toggle">
								    	<p class="afms-field-title">Mode : Automatic</p>
						        </div>
							</div>
							
							<div class="afma-mode_auto">
								<div class="col-md-3 col-sm-6">
									<div class="afms-field afms-field_input">
                                    	<p class="afms-field-title">Start Frequency (MHz)</p>
							            <p><asp:label id=fFreq runat=server></asp:label></p>
                                	</div>
								</div>
								<div class="col-md-3 col-sm-6">
									<div class="afms-field afms-field_input">
                                        <p class="afms-field-title">Stop Frequency (MHz)</p>
							            <p><asp:label id=tFreq runat=server></asp:label></p>
                            		</div>
								</div>
								<div class="col-md-3 col-sm-6">
									<div class="afms-field afms-field_input">
                                        <p class="afms-field-title">Channel Space</p>
							            <p><asp:label id=ChSp runat=server></asp:label></p>
                                       
									</div>
								</div>
								<div class="col-md-3 col-sm-6">
									<div class="afms-field afms-field_input">
                                        <p class="afms-field-title">Duration</p>
							            <p><asp:label id=nSec runat=server></asp:label></p>
									</div>
								</div>
							
                            <div class="col-md-3 col-sm-6">
									<div class="afms-field afms-field_input">
                                        <p class="afms-field-title">Threshold (dBm)</p>
							            <p><asp:label id=Threshold runat=server></asp:label></p>
									</div>
								</div>

								
							</div>	

												
						</div>
					</div>
						</div>					
					</div>
				</div>

				<div class="afms-content" style="margin-top: 20px;">

					<div class="row">
						<div class="col-md-12">
							<div class="row">
								
								<div class="col-md-12 afms-frequency-monitor">
									<div id="fre-container" style="height: 400px; min-width: 310px"></div>
								</div>

								<div class="col-md-10 afms-group-btn text-center">
									<!--a href="AnEvent.aspx?scanid=<%=tbS.Rows[0]["scanid"] %>" class="afms-btn afms-btn-secondary">EVENT(<%=tbS.Rows[0]["nEvent"] %>)</!--a-->
									<a href="AnOcc.aspx?scanid=<%=tbS.Rows[0]["scanid"] %>" class="afms-btn afms-btn-secondary">Occupancy vs Channel</a>
									<a href="AnFStr.aspx?scanid=<%=tbS.Rows[0]["scanid"] %>" class="afms-btn afms-btn-secondary">Field Strangth vs Channel</a>
									  <a href="AnInfoEdit.aspx?scanid=<%=tbS.Rows[0]["scanid"] %>" class="afms-btn afms-btn-secondary">
								        <i class="afms-ic_edit"></i> แก้ไข
							        </a>
								</div>
								<div class="col-md-2 afms-group-btn text-right">
									<button type="button" onclick="javascript:delItem('fms.spScan_Del','ScanID','<%=tbS.Rows[0]["ScanID"] %>',false,false,'AnChk.aspx')" class="afms-btn afms-btn-primary">Delete</button>
									</div>
							</div>
							
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
