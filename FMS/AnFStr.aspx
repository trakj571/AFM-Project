<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AnFStr.aspx.cs" Inherits="AFMProj.FMS.AnFStr" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <script src="../_Inc/js/highstock.js"></script>
   

    <script language=javascript>
        <%
            Response.Write("var dataMx = [],dataAv = [];");
            for(int i=0;i<tbF.Rows.Count;i++){
                 Response.Write("dataMx.push(["+tbF.Rows[i]["Freq"]+","+tbF.Rows[i]["dBuVmx"]+"]);");
                 Response.Write("dataAv.push(["+tbF.Rows[i]["Freq"]+","+tbF.Rows[i]["dBuVav"]+"]);");
            }
           
        
         %>
        

        $(function(){
            $("a[rel=AnChk]").addClass("is-active");
            dispChart('fre-container');
        });

        function dispChart(div) {
            Highcharts.stockChart(div, {
                credits: { enabled: false },
                chart: {
                    backgroundColor: "#eeeeee"
                },
                legend : {enabled: true},
                navigator: {
                    xAxis: { labels: { formatter: function () { return (this.value / 1000000.0).toFixed(2); } } }
                },

                rangeSelector: {
                    selected: 1,
                    enabled: false

                },
                yAxis: { title: { text: "Field Strength (dBuV/m)"} },
                xAxis: { title: { text: "Frequency (MHz)" }, labels: { formatter: function () { return (this.value / 1000000.0).toFixed(2); } } },
                tooltip: { formatter: function () {
                    var s = '<b>' + (this.x / 1000000.0).toFixed(2) + 'MHz</b>';

                    $.each(this.points, function (i, point) {
                        s += '<br/>' + point.series.name + ': ' +
                                        point.y + ' dBuV/m';
                    });

                    return s;
                }
                },
                title: {
                    text: ''
                },

                series: [{
                    name: 'Maximum Field Strength',
                    data: dataMx,
                    tooltip: {
                        valueDecimals: 2
                    },
                    point: {
                        events: {
                            click: function () {
                                // this.category
                                //setManual(this.category);
                            }
                        }
                    }
                },
                {
                    name: 'Average Field Strength',
                    data: dataAv,
                    tooltip: {
                        valueDecimals: 2
                    },
                    point: {
                        events: {
                            click: function () {
                                // this.category
                                //setManual(this.category);
                            }
                        }
                    }
                }
                
                ]
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
			

			<div class="col-md-12">
				<div class="afms-content">
					<div class="afms-page-title">
						Field Strength vs Channel
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="collapse in content-readonly" id="searchSection">
						<div class="row">
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
							            <p><asp:label id=ChSpText runat=server></asp:label></p>
                                        <div style='display:none'>
										<select id=ChSp runat=server>
                                            <option value="12500">12.5 kHz</option>
                                            <option value="25000" selected>25 kHz</option>
                                           <option value="7000000">7 MHz</option>
                                        </select>
                                          <script language=javascript>
                                              $(function () {
                                                  $("#ChSpText").html($("#ChSp option:selected").text());
                                              });
                                          </script>
                                         </div>
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
						 <div class="col-md-12 afms-frequency-monitor">
									<div id="fre-container" style="height: 400px; min-width: 310px"></div>
								</div>
                        
						<div class="col-md-12 print-content">
							<div class="afms-sec-table">
								<table class="table table-condensed text-center afms-table-responsive">
									<thead>
										<tr>
											<th style="width: 60px">ลำดับ</th>
											<th>Frequency (MHz)</th>
											<th>Maximum Field Strength (dBuV/m)</th>
											<th>Average Field Strength (dBuV/m)</th>
										</tr>
									</thead>
									<tbody>
                                    <%for (int i = 0; i < tbF.Rows.Count; i++)
                                      { %>
										<tr>
											<td data-th="ลำดับ"><%=(i + 1)%></td>
											<td data-th="Frequency (MHz)"><%=string.Format("{0:0.0000}", tbF.Rows[i]["FreqMHz"])%></td>
										    <td data-th="Maximum Field Strength (dBuV/m)"><%=string.Format("{0:0.000}", tbF.Rows[i]["dBuVmx"])%></td>
											<td data-th="Average Field Strength (dBuV/m)"><%=string.Format("{0:0.000}", tbF.Rows[i]["dBuVav"])%></td>
										</tr>
									<%} %>	
									</tbody>
								</table>
							</div>
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
						
					</div>
				</div>
			</div>
		</div>

		<div class="afms-push"></div>
	</div>

	<!--#include file="../_inc/Ft.asp"-->
</body>

</html>
