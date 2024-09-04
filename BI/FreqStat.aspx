<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FreqStat.aspx.cs" Inherits="AFMProj.BI.FreqStat" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.B.asp"-->
      <script src="../_Inc/js/highstock.js"></script>
    <script language=javascript>
        $(function(){
        
            $(function () {
                $('.afms-field_select select').selectpicker();
                $('.afms-field_datepicker input').datepicker({
                    orientation: "bottom left",
                    format: "dd/mm/yyyy",
                    autoclose: true
                });

                $('.afms-field_datetimepicker input').datetimepicker({
                    orientation: "bottom left",
                    format: "dd/mm/yyyy hh:ii",
                    autoclose: true
                });


                $('.afms-field_spinner input').TouchSpin({
                    min: 0,
                    max: 3000,
                    step: 0.01,
                    decimals: 2,
                    boostat: 5,
                    buttondown_class: "afms-btn afms-btn-minus afms-ic_minus",
                    buttonup_class: "afms-btn afms-btn-plus afms-ic_plus"
                });


                
            });

            $("#Level").change(function(){
                levelChange();
            });
            
            $("#THIDDiv").show();
            levelChange();
            dispChart();
         });

         function levelChange(){
             $("#ProvIDDiv").hide();
                $("#LyID2Div").hide();
                $("#LyID1Div").hide();
                $("#THIDDiv").hide();

                var val = $("#Level").val();
                if(val=="1") $("#ProvIDDiv").show();
                else if(val=="2") $("#LyID2Div").show();
                else if(val=="3") $("#LyID1Div").show();
                else if(val=="4") $("#THIDDiv").show();
         }
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

        ///
        function dispChart() {
            if ($("#ChartType").val() == "bar") {
                $("#container").css("height", "800px");
                //$("#container").css("width","");
            } else {
                $("#container").css("height", "500px");
                //$("#container").css("width","");
            }
            Highcharts.chart('container', {
                credits: { enabled: false },
                chart: {
                    type: $("#ChartType").val()
                },
                title: {
                    text: ''
                },
                subtitle: {
                    text: ''
                },
                xAxis: {
                    categories: [
                    <%
                    for(int i=0;i<tbFC.Rows.Count;i++){
                        if(i>0)  Response.Write(",");
                        Response.Write(string.Format("'{0}-{1} MHz'",tbFC.Rows[i]["fFreq"],tbFC.Rows[i]["tFreq"]));
                    } %>
                     ],
                     crosshair: true
                 },
                 yAxis: {
                     min: 0,
                     title: {
                         text: 'ปริมาณการครอบครอง'
                     }
                 },
                 tooltip: {
                     headerFormat: '<table style="margin:0px"><tr><td colspan=2>{point.key}</td></tr>',
                     pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                         '<td style="padding:0"><b>{point.y:.1f}</b></td></tr>',
                     footerFormat: '</table>',
                     shared: true,
                     useHTML: true
                 },
                 plotOptions: {
                     column: {
                         pointPadding: 0.2,
                         borderWidth: 0
                     }
                 },
                 series: [
                    <%for(int k=0;k<tbTC.Rows.Count;k++){ %>
                    <%if(k>0) Response.Write(",");  %>
                     {
                         name: '<%=tbTC.Rows[k]["Area"] %>',
                         data: [
                        <%for(int i=0;i<tbFC.Rows.Count;i++){
                            if(i>0)  Response.Write(",");
                                Response.Write(string.Format("{0}",cConvert.ToInt(tbTC.Rows[k]["Freq"+tbFC.Rows[i]["FtID"]])));
                            } %>
                         ]
                     }
                    <%} %>
                 ]
             });
        }
         
    </script>
    <style>
        #ProvIDDiv,#LyID2Div,#LyID1Div,#THIDDiv{display:none}
    </style>
     <style>
        .tborder, .tborder th, .tborder td {padding:2px;border:1px double #777}
       .tborder th {background:#eee;text-align:center}
       .u {padding:0 10px 0 10px}
       .u input{text-align:center;border-bottom:1px double #777}
   </style>
</head>
<body>
	<div class="afms-sec-container">
		
		<div class="row">
        	 <form id=FormSch runat=server>

			<div class="col-md-12">
				<div class="afms-content">
					<div class="collapse in" id="searchSection">
						<div class="row">
							<div class="col-md-3">
								<div class="afms-field afms-field_select">
									<label>ระดับ</label>
									<select id=Level runat=server>
                                       <option value='1'>จังหวัด</option>
                                       <option value='2'>เขต</option>
                                       <option value='3'>ภาค</option>
                                       <option value='4' selected>ประเทศ</option>
									</select>
									<span class="bar"></span>
								</div>
							</div>
                             <div id="THIDDiv" class="col-md-3">
							<div class="afms-field afms-field_select">
								<label>&nbsp;</label>
                               <select id="THID" runat="server">
									<option value="" selected>= ทั้งหมด =</option>
							    </select>
                                <span class="bar"></span>
                             </div>
                             </div>

                              <div id="ProvIDDiv" class="col-md-3">
							<div class="afms-field afms-field_select">
								<label>&nbsp;</label>
                            
								<select id="ProvID" runat="server">
									<option value="" selected>= ทั้งหมด =</option>
							    </select>
                                <span class="bar"></span>
                                </div>
                                </div>

                                 <div id="LyID1Div" class="col-md-3">
							<div class="afms-field afms-field_select">
								<label>&nbsp;</label>
                            
                                <select id="LyID1" runat="server">
									<option value="" selected>= ทั้งหมด =</option>
							    </select>
                                <span class="bar"></span>
                                </div>
                                </div>

                            <div id="LyID2Div" class="col-md-3">
							<div class="afms-field afms-field_select">
								<label>&nbsp;</label>
                            
                                 <select id="LyID2" runat="server">
									<option value="" selected>= ทั้งหมด4 =</option>
							    </select>
                                </div>
                                
								<span class="bar"></span>
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
				 <%if(tbT!=null){ %>
				<div class="afms-content print-content" style="margin-top: 20px;">
                	<div class="row">
						<div class="col-md-12">
				
				     	<div class="afms-sec-table">
							<table class='tborder' style='min-width:<%=tbT.Columns.Count*100 %>px'>
								<thead>
									<tr>
										<th rowspan=2 style='min-width:200px'>พื้นที่</th>
										 <%for(int i=1;i<tbT.Columns.Count;i++){ %>
                                            <th><%=i %></th>
                                         <%} %>
								    </tr>
                                    <tr>
										 <%for(int i=0;i<tbF.Rows.Count;i++){ %>
                                            <th><%=string.Format("{0}-{1} MHz",tbF.Rows[i]["fFreq"],tbF.Rows[i]["tFreq"]) %></th>
                                         <%} %>
								    </tr>
								</thead>
								<tbody>
                                <%for(int i=0;i<tbT.Rows.Count;i++){ %>
									<tr>
										<td data-th="พื้นที่" style='text-align:left'><%=tbT.Rows[i]["Area"] %></td>
                                         <%for(int j=0;j<tbF.Rows.Count;j++){ %>
                                            <td style='text-align:center' data-th="<%=string.Format("{0}-{1} MHz",tbF.Rows[j]["fFreq"],tbF.Rows[j]["tFreq"]) %>"><%=tbT.Rows[i]["Freq"+tbF.Rows[j]["FtID"]] %></td>
                                         <%} %>
									</tr>
                                    <%} %>
								</tbody>
							</table>
						</div>

                       
                      </div>
					</div>

                        <div>
                        <select id=ChartType onchange=dispChart()>
                                       <option value='bar'>กราฟแนวนอน</option>
                                       <option value='column'>กราฟแนวตั้ง</option>
                             			</select>
                                        </div>
                                        <br />
                    <div id="container" style='height:800px'></div>


					<%} %>
                    

						
					</div>
				</div>
			
            </form>
            </div>
		</div>
        
		<div class="afms-push"></div>
	
	<!--#include file="../_inc/Ft.asp"-->
</body>

</html>
