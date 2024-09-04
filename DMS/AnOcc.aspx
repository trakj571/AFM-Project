<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AnOcc.aspx.cs" Inherits="AFMProj.DMS.AnOcc" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <script src="../_Inc/js/highstock.js"></script>
    
    <script language=javascript>
         var scanID = '<%=Request["scanID"] %>';
       <%
            Response.Write("var data = [];");
            double fFreq = cConvert.ToDouble(tbS.Rows[0]["fFreq"]);
            double tFreq = cConvert.ToDouble(tbS.Rows[0]["tFreq"]);
            double chSp = cConvert.ToDouble(tbS.Rows[0]["chSp"]);
            for(double f=fFreq;f<=tFreq;f+=chSp){
                Response.Write("data.push(["+f+","+GetValueF(f)+"]);");
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
                    xAxis: { labels: { formatter: function () { return (this.value / 1000000.0).toFixed(4); } } }
                },

                rangeSelector: {
                    selected: 1,
                    enabled: false

                },
                yAxis: { title: { text: "Occupancy (%)"} },
                xAxis: { title: { text: "Frequency (MHz)" }, labels: { formatter: function () { return (this.value / 1000000.0).toFixed(4); } } },
                tooltip: { formatter: function () {
                    var s = '<b>' + (this.x / 1000000.0).toFixed(4) + 'MHz</b>';

                    $.each(this.points, function (i, point) {
                        s += '<br/>' + point.series.name + ': ' +
                                        point.y + ' %';
                    });

                    return s;
                }
                },
                title: {
                    text: ''
                },

                series: [{
                    name: 'Occupancy',
                    data: data,
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

       
        function printOcc(v) {
            if (v) {
                window.open("PrintOcc.aspx?scanid=" + scanID + "&authid=" + $("#AuthID").val());
                $("#apvAuthModal").modal("hide");
            } else {
                $("#apvAuthModal").modal("show");
            }


            //
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
						Occupancy vs Channel
					</div>
					
                    <div class="row">
						<div class="col-md-12">
							<div class="collapse in content-readonly" id="searchSection">
						<div class="row">
							
							<div class="afma-mode_auto">
                                 <div class="col-md-3 col-sm-6">
									<div class="afms-field afms-field_input">
                                    	<p class="afms-field-title">Equipment</p>
							            <p><asp:label id=Station runat=server></asp:label></p>
                                	</div>
								</div>

                                <div class="col-md-3 col-sm-6">
									<div class="afms-field afms-field_input">
                                    	<p class="afms-field-title">Dete</p>
							            <p><asp:label id=DtBegin runat=server></asp:label></p>
                                	</div>
								</div>
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
											<th>Occupancy (%)</th>
										</tr>
									</thead>
									<tbody>
                                    <%for(int i=0;i<tbO.Rows.Count;i++){ %>
										<tr>
											<td data-th="ลำดับ"><%=(i+1) %></td>
											<td data-th="Frequency (MHz)"><%=string.Format("{0:0.00}", tbO.Rows[i]["FreqMHz"])%></td>
											<td data-th="Occupancy (%)"><%=string.Format("{0:0.00}",tbO.Rows[i]["Occ"]) %></td>
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

                             <a href="javascript:printOcc()" class="afms-btn afms-btn-secondary">
								        <i class="afms-ic_print"></i> รายงาน
							        </a>

						</div>
                        </div>
						
					</div>
				</div>
			</div>
		</div>

		<div class="afms-push"></div>
	</div>
	 <div class="modal fade" id="apvAuthModal" tabindex="-1" role="dialog" aria-labelledby="apvAuthModalLabel">
						<div class="modal-dialog" role="document">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close afms-ic_close" data-dismiss="modal" aria-label="Close"></button>
									<h4 class="modal-title" id="fullStatusLabel">ผู้อนุมัติ</h4>
								</div>
								<div class="modal-body">
									<div class="row">

										<div class="col-md-8 col-sm-8">
										               <div class="afms-field afms-field_select">
								            <select id=AuthID runat=server>
                                                <option value="">เลือก</option>

								            </select>
								            <span class="bar"></span>
							            </div>	
                                       
											
                                            </div>
                                        <div class="col-md-2 col-sm-2">
                                        <div style="text-align:center"> <a href="javascript:printOcc(1)" class="afms-btn afms-btn-primary"> ตกลง</a></div>
                                        </div>
											</div>
                                    
                                   
                                    </div>
                                </div>
                            
						</div>
					</div>
	<!--#include file="../_inc/Ft.asp"-->
</body>

</html>
