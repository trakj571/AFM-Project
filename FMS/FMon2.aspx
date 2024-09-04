<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FMon2.aspx.cs" Inherits="AFMProj.FMS.FMon2" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <script src="../_Inc/js/highstock.js"></script>
    <script type="text/javascript" src="../gis/libs/flowplayer/flowplayer-3.2.13.min.js"></script>
    <script type="text/javascript" src="../gis/libs/flowplayer/flowplayer.ipad-3.2.13.min.js"></script>	
    <style>
        #searchSection {display:none}
        #schd-button,#schd-button-M {display:none}
    </style>
     <script language=javascript>
         var poiid = '<%=Request["PoiID"] %>';
         var stream = "";
        
         function do_import() {
             location = "AImp.aspx?poiid=" + poiid;
         }
         function startPlugIn() {
             location = "afmplugin://<%=Request["PoiID"] %>@<%=cUsr.Token%>@<%=Request.Url.Host == "localhost" ? "local" : ""%>";
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
			
            <%
                if (Request["poiid"] == null)
                {
                    if (tbSTN.Rows.Count == 0)
                        Response.Redirect("FSch.aspx");

                    Response.Redirect("FMon.aspx?poiid=" + tbSTN.Rows[tbSTN.Rows.Count - 1]["PoiID"]);

                }
                else
                {
                    for (int i = 0; i < tbSTN.Rows.Count; i++)
                    {
                        if (tbSTN.Rows[i]["PoiID"].ToString() == Request["poiid"])
                            drSTN = tbSTN.Rows[i];
                    }
                    if (drSTN == null)
                        Response.Redirect("../DashB");
                } %>

			<%if (drSTN["IsOnline"].ToString()=="Online" && drSTN["IsLock"].ToString()=="Unlock"){ %>
			<script>
				 $(function () {
             		 setTimeout(function () {
						 startPlugIn();
					 }, 500);
				 });
            </script>
			<%} %>
			<div class="col-md-12">
            <div id="audio"></div>
            	<div class="afms-content" id="station<%=drSTN["PoiID"] %>">
					<div class="afms-page-title"><i class="afms-ic_record"></i><%=drSTN["Name"] %>
						<div class="pull-right">Operate by: <span class="OprName"></span><br /> Time to operate: <span class="OprTime"></span> <i class="is-lock"></i></div>
					</div>
					<div class="afms-station-shortstatus" data-toggle="modal" data-target="#fullStatus">
						Sensor Monitor : <span class="text-com">Communication : <span class="3G"></span></span> | <span class="text-ups">UPS : <span class="UPSPc"></span>% [<span class="UPSTime"></span> Min Left]</span> | <span class="text-scan">Scanner : <span class="SCN"></span></span> | <span class="text-power">Power : Plug</span> | <span class="text-sensor">Environment : <span class='TempStat'></span></span>
						
					</div>
					<div class="text-right">

						<a href="FMon2File.aspx?poiid=<%=drSTN["PoiID"] %>" class="afms-btn afms-btn-secondary"><i class="afms-ic_file"></i>File Manager</a>
						 &nbsp; <button type="button" onclick="do_import()" class="afms-btn afms-btn-primary">Import</button>
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
											<div class="panel panel-default afms-station-status panel-power" style="height: 205px;display:none">
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
															<p><b>Network :</b> <span class='NET'>-</span></p>
														</div>
														<div class="col-md-6 col-sm-6">
															<p><b>GPS :</b> <span class='GPS'>-</span></p>
														</div>
													</div>
												</div>
											</div>
											<div class="panel panel-default afms-station-status panel-ups">
												<div class="panel-heading">UPS : <span class='UPSPc'>-</span>%</div>
												<div class="panel-body">
													<p><b>Time to operate :</b> <span class='UPSTime'>-</span> Minutes</p>
												</div>
											</div>

										</div>
										<div class="col-md-6 col-sm-6">
											
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

					

				

                <br />
                <div id="searchSection" style="border:1px solid #777;width:100%;height:150px;text-align:center;padding:20px">
					Please operate by use AFM Plug-In.<br /> If Plug-In do not Start <a href='javascript:startPlugIn()'>Click here</a>
					<br />
					<br />
					Download <a href='../PlugIn/AFMPlugin.exe'> AFM Plug-in</a> 
					<br />

					<%if (drSTN["EquType"].ToString() == "STN")
                        {%>
						Download <a href='http://afm.nbtc.go.th/AFM/Files/Download/Doc31.exe'>Anydesk Installation</a> 
					<%}else{ %>
						Download <a href='../PlugIn/jre-8u271-windows-i586.exe'>Java Runtime Environment (JRE)</a> 
					<%} %>
                </div>
					</div>
			</div>
		</div>

		<div class="afms-push"></div>
	</div>

	<!--#include file="../_inc/Ft.asp"-->
</body>

</html>
