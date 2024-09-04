<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="AFMProj.DashB.Default" %>
<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
     <script src="../_Inc/js/highstock.js"></script>
  
    <script language=javascript>
        $(function () {
           readSensor();
       
        });
        function readSensor() {
            $.ajax({
                type: 'POST',
                url: "data/dsensor.ashx",
                data: {

                },
                cache: false,
                dataType: 'json',
                success: function (data) {
                    setData(data);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }

            });

            setTimeout(function(){
                readSensor();
            },15*1000);
        }

        function setData(data) {
             for(var i=0;i<data.length;i++){
                 var d = data[i];
                 $("#station" + d.PoiID + " .panel-power").addClass("panel-success");
                 $("#station" + d.PoiID + " .panel-com").addClass("panel-success");

                $("#station" + d.PoiID + " .Voltage").html(d.Voltage);
                $("#station" + d.PoiID + " .Current").html(d.Current);
                $("#station" + d.PoiID + " .Frequency").html(d.Frequency);
                $("#station" + d.PoiID + " .PAE").html(d.PAE);

                $("#station" + d.PoiID + " .UPSPc").html(d.UPSPc);
                $("#station" + d.PoiID + " .UPSTime").html(d.UPSTime);

                $("#station" + d.PoiID + " .Temp").html(d.Temp);
                $("#station" + d.PoiID + " .Humidity").html(d.Humidity);
                $("#station" + d.PoiID + " .TempStat").html(d.TempStat);
                if (d.TempStat == "Warning" || d.TempStat == "Critical" || d.InPut == 1) {
                    $("#station" + d.PoiID + " .panel-sensor").addClass("panel-danger");
                } else {
                    $("#station" + d.PoiID + " .panel-sensor").addClass("panel-success");
                }
               
                var led = d.StatusLED;
                if (d.UPSPc>25) {
                    $("#station" + d.PoiID + " .panel-ups").addClass("panel-success");
                } else {
                    $("#station" + d.PoiID + " .panel-ups").addClass("panel-danger");
                }
                if (d.SCN=="OK") {
                    $("#station" + d.PoiID + " .panel-scaner").addClass("panel-success");
                } else {
                    $("#station" + d.PoiID + " .panel-scaner").removeClass("panel-success");
                }

                $("#station" + d.PoiID + " .GPS").html(d.GPS);
                $("#station" + d.PoiID + " .3G").html(d.f3G);
                $("#station" + d.PoiID + " .WAN").html(d.WAN);
                $("#station" + d.PoiID + " .LAN").html(d.LAN);
                $("#station" + d.PoiID + " .Atenna").html(d.ATTN);
                if (d.ATTN != "-") {
                    $("#station" + d.PoiID + " .AtennaStat").html("Online");
                } else {
                    $("#station" + d.PoiID + " .AtennaStat").html("Offline");
                }
                $("#station" + d.PoiID + " .Security").html(d.Security);

                $("#headingStation" + d.PoiID + " .OprTime").html(d.OprTime);
                $("#station" + d.PoiID + " .OprName").html(d.OprName);
                if (d.IsOnline == "Online") {
                    $("#panelStation" + d.PoiID).addClass("is-online");
                    $("#station" + d.PoiID + " .NET").html("OK");
                } else {
                    $("#panelStation" + d.PoiID).removeClass("is-online");
                }
                if (d.IsLock == "Unlock") {
                    $("#panelStation" + d.PoiID + " .is-lock").removeClass("afms-ic_lock");
                    $("#panelStation" + d.PoiID + " .is-lock").addClass("afms-ic_unlock");
                } else {
                    $("#panelStation" + d.PoiID + " .is-lock").removeClass("afms-ic_unlock");
                    $("#panelStation" + d.PoiID + " .is-lock").addClass("afms-ic_lock");
                }

           }
        }


        
    </script>
</head>
<body>
	<div class="afms-sec-container afms-page-dashboard">
		<!--#include file="../_inc/Hd.asp"-->

		
        <div class="afms-sec-breadcrumb">
			Dashboard  
		</div>

		<div class="row afms-sec-content">
			<div class="col-md-12">
            <div class="panel-group afms-sec-stationlist" id="LyID0" role="tablist" aria-multiselectable="true">
				
             <%
             bool isl1in = true;
             bool isl2in = true;
             for(int l0=0;l0<tbL.Rows.Count;l0++){ 
                if(cConvert.ToInt(tbL.Rows[l0]["pLyID"])>0)
                    continue;
                int pLyID0 = cConvert.ToInt(tbL.Rows[l0]["LyID"]);
                for(int l1=0;l1<tbL.Rows.Count;l1++){ 
                    if(cConvert.ToInt(tbL.Rows[l1]["pLyID"])!=pLyID0)
                        continue;
             %>


             <div class="panel panel-default afms-stationlist-box is-nostatus afms-sec-zonelist">
						<div class="panel-heading" role="tab" id="headingSector">
							<h4 class="panel-title">
								<a role="button" data-toggle="collapse" data-parent="#station" href="#sector<%=tbL.Rows[l1]["LyID"] %>" aria-expanded="true" aria-controls="collapseOne">
									<div class="pull-left station-name"><i class="afms-ic_record"></i><%=tbL.Rows[l1]["Name"] %></div>
								</a>
							</h4>
						</div>
						<div id="sector<%=tbL.Rows[l1]["LyID"] %>" class="panel-collapse collapse <%=isl1in?"in":"" %>" role="tabpanel" aria-labelledby="headingSector">
							<div class="panel-body">
								<div class="" role="tablist" aria-multiselectable="true">
									 <%
                                        isl1in = false;
                                        int pLyID1 = cConvert.ToInt(tbL.Rows[l1]["LyID"]);
                                        for(int l2=0;l2<tbL.Rows.Count;l2++){ 
                                            if(cConvert.ToInt(tbL.Rows[l2]["pLyID"])!=pLyID1)
                                                continue;
                                     %>
									<div class="panel panel-default afms-sec-arealist">
										<div class="panel-heading" role="tab" id="headingArea12">
											<h4 class="panel-title">
												<a class="collapsed" role="button" data-toggle="collapse" data-parent="#sector<%=tbL.Rows[l1]["LyID"] %>" href="#area<%=tbL.Rows[l2]["LyID"] %>" aria-expanded="false" aria-controls="area12">
													<%=tbL.Rows[l2]["Name"] %>
												</a>
											</h4>
										</div>
										<div id="area<%=tbL.Rows[l2]["LyID"] %>" class="panel-collapse collapse <%=isl2in?"in":"" %>" role="tabpanel" aria-labelledby="headingArea12">
											<div class="panel-body">
												 <%
                                                 isl2in = false;
                                                 for(int i=0;i<tbE.Rows.Count;i++){ %>
                                                    <%
                                                     if(cConvert.ToInt(tbL.Rows[l2]["LyID"])!=cConvert.ToInt(tbE.Rows[i]["LyID"]))
                                                            continue;

                                                    if(tbE.Rows[i]["ScanID"].ToString()!=""){ %>
                                                        <script>
                                                            $(function () {
                                                                <%if(tbE.Rows[i]["EquType"].ToString()=="STN" || tbE.Rows[i]["EquType"].ToString()=="STN2"){%>
                                                                    dispChart('<%=tbE.Rows[i]["ScanID"] %>', 'fre-container<%=tbE.Rows[i]["PoiID"] %>');
                                                                <%} %>
                                                                <%else if(tbE.Rows[i]["EquType"].ToString()=="MOB"){%>
                                                                    dispChartM('<%=tbE.Rows[i]["ScanID"] %>', 'fre-container<%=tbE.Rows[i]["PoiID"] %>');
                                                                <%} %>
                                                                <%else if(tbE.Rows[i]["DataType"].ToString()=="O"){%>
                                                                    dispChartDO('<%=tbE.Rows[i]["ScanID"] %>', 'fre-container<%=tbE.Rows[i]["PoiID"] %>');
                                                                <%} %>
                                                                 <%else{%>
                                                                    dispChartD('<%=tbE.Rows[i]["ScanID"] %>', 'fre-container<%=tbE.Rows[i]["PoiID"] %>');
                                                                <%} %>
                                                            });
                                                        </script>
                                                    <%} %>

                                              

				                                    <div class="" role="tablist" aria-multiselectable="true">
												    <div class="panel panel-default afms-sec-subarealist" id="panelStation<%=tbE.Rows[i]["PoiID"] %>">
						                                    <div class="panel-heading" role="tab" id="headingStation<%=tbE.Rows[i]["PoiID"] %>">
							                                    <h4 class="panel-title">
								                                    <a role="button" class="clearfix" data-toggle="collapse" data-parent="#station" href="#station<%=tbE.Rows[i]["PoiID"] %>" aria-expanded="true" aria-controls="collapseOne">
									                                    <div class="pull-left station-name"><i class="afms-ic_record"></i>
                                                                        
                                                                        <%if(tbE.Rows[i]["EquType"].ToString()=="STN" || tbE.Rows[i]["EquType"].ToString()=="STN2"){ %>
                                                                            <i class="afms-ic_afm"></i>AFM : 
                                                                        <%} %>
                                                                         <%if(tbE.Rows[i]["EquType"].ToString()=="RMT"){ %>
                                                                            <i class="afms-ic_remote"></i>Remote Station : 
                                                                        <%} %>
                                                                         <%if(tbE.Rows[i]["EquType"].ToString()=="MOB"){ %>
                                                                            <i class="afms-ic_mobile"></i>Mobile Station : 
                                                                        <%} %>
                                                                         <%if(tbE.Rows[i]["EquType"].ToString()=="HND"){ %>
                                                                            <i class="afms-ic_handheld"></i>Handheld : 
                                                                        <%} %>
                                                                        
                                                                        <span><%=tbE.Rows[i]["Name"] %></span>
                                                                        </div>
									                                    <div class="pull-right station-operatetime">Time to Operate: <span class="OprTime">-</span>
									                                    <i class="is-lock" data-toggle="tooltip" data-placement="bottom"></i>
								                                    </div>
								                                    </a>
							                                    </h4>
						                                    </div>

						                                    <div id="station<%=tbE.Rows[i]["PoiID"] %>" class="panel-collapse collapse <%=(i==0?"in":"") %>" role="tabpanel" aria-labelledby="headingStation<%=tbE.Rows[i]["PoiID"] %>">
							                                    <div class="panel-body">
								                                    <div class="row">
									                                    <%if(tbE.Rows[i]["EquType"].ToString()=="STN" || tbE.Rows[i]["EquType"].ToString()=="STN2"){ %> 
                                                                        <div class="col-md-6 col-sm-6 col-xs-12"><b>Mode :</b> Automatic</div>
									                                    <div class="col-md-6 col-sm-6 col-xs-12 text-right"><b>Control by :</b> <span class="OprName">-</span></div>
                                                                        <%} %>
									                                    <div class="col-md-12">
										                                    <div class="row">
											                                    <div class="col-md-6">
												                                    <h3>Spectrum</h3>	
												                                    <div class="afms-frequency-box">
													                                    <div id="fre-container<%=tbE.Rows[i]["PoiID"] %>" style="background:#eee;height: 400px; min-width: 210px"></div>
													                                    <!--div class="afms-frequency-no">
														                                    <button class="afms-btn afms-btn-primary afms-btn-play afms-ic_play"></button> 222.25 MHz <span>(Scanning...)</span>
													                                    </div-->
												                                    </div>
											                                    </div>
                                                                                <%if(tbE.Rows[i]["EquType"].ToString()=="STN" || tbE.Rows[i]["EquType"].ToString()=="STN2"){ %>
											                                    <div class="col-md-6">
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
                                                                                            <div class="panel panel-default afms-station-status panel-com" style="margin-top:32px!important">
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
																                                    <p><b>Security :</b> <span class='Security'></span></p>
															                                    </div>
														                                    </div>
													                                    </div>
												                                    </div>
											                                    </div>
                                                                                <%}else if(cConvert.ToInt(tbE.Rows[i]["ScanID"])>0){ %>

                                                                                <div class="col-md-6">
												                                    <div class="row">
													                                    <div class="col-md-6 col-sm-6">
														                                    <div class="panel panel-default afms-station-status panel-power" style="height: 205px">
															                                    <div class="panel-heading">Infomation</div>
															                                    <div class="panel-body">
																                                    <p><b>Date :</b> <span><%=string.Format("{0:dd/MM/yyyy HH:mm}", tbE.Rows[i]["DtBegin"]) %></span></p>
																                                    <p><b>Start Frequency :</b> <span><%=string.Format("{0:0.00}MHz", cConvert.ToDouble(tbE.Rows[i]["fFreq"]) / 1e6) %></span></p>
																                                    <p><b>Stop Frequency :</b> <span><%=string.Format("{0:0.00}MHz", cConvert.ToDouble(tbE.Rows[i]["tFreq"]) / 1e6) %></span></p>
																                                    <p><b>Channel Space :</b> <span><%=string.Format("{0:0.0}kHz", cConvert.ToDouble(tbE.Rows[i]["ChSp"]) / 1e3) %></span></p>
															                                    </div>
														                                    </div>

														                                   
													                                    </div>
													                                    
												                                    </div>
											                                    </div>
                                                                                <%} %>

										                                    </div>
									                                    </div>
								                                    </div>
							                                    </div>
						                                    </div>
					                                    </div>
                                                        </div>
                                                             <%} %>
											</div>
										</div>
									</div>

                                    <%} %>
								</div>
								
							</div>
						</div>
					</div>

                <%} %>
		    <%} %>
            </div>
           
                   
				
			</div>
		</div>
		

		
		<div class="afms-push"></div>
	</div>

	<!--#include file="../_inc/Ft.asp"-->
</body>

</html>

