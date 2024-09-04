<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FreqStatChart.aspx.cs" Inherits="AFMProj.DMS.FreqStatChart" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <script src="../_Inc/js/highstock.js"></script>
    <script language=javascript>

        $(function () {
            $("a[rel=FreqStat]").addClass("is-active");
            dispChart();
        });



         function dispChart() {
             if($("#ChartType").val()=="bar"){
                $("#container").css("height","800px");
                //$("#container").css("width","");
            }else{
                $("#container").css("height","500px");
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
                    for(int i=0;i<tbF.Rows.Count;i++){
                        if(i>0)  Response.Write(",");
                        Response.Write(string.Format("'{0}-{1} MHz'",tbF.Rows[i]["fFreq"],tbF.Rows[i]["tFreq"]));
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
                    <%for(int k=0;k<tbT.Rows.Count;k++){ %>
                    <%if(k>0) Response.Write(",");  %>
                    {
                     name: '<%=tbT.Rows[k]["Area"] %>',
                     data: [
                        <%for(int i=0;i<tbF.Rows.Count;i++){
                            if(i>0)  Response.Write(",");
                                Response.Write(string.Format("{0}",cConvert.ToInt(tbT.Rows[k]["Freq"+tbF.Rows[i]["FtID"]])));
                            } %>
                         ]
                        }
                    <%} %>
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
				<li><a href="">DMS</a> <span class="afms-ic_next"></span></li>
				<li>การวิเคราะห์การครอบครองความถี่ <span class="afms-ic_next"></span></li>
                <li>สถิติการครอบครองความถี่</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../DMS/Menu.asp"-->
			 <form id=FormSch runat=server>

			<div class="col-md-12">
				<div class="afms-content">
					<div class="afms-page-title">
						สถิติการครอบครองความถี่
                       
					</div>

                    <div>
                        <select id=ChartType onchange=dispChart()>
                                       <option value='bar'>กราฟแนวนอน</option>
                                       <option value='column'>กราฟแนวตั้ง</option>
                             			</select>
                                        </div>
                                        <br />
                    <div id="container" style='height:800px'></div>

					</div>

                    </div>
                    
            </form>
		</div>
        
		<div class="afms-push"></div>
	</div>

	<!--#include file="../_inc/Ft.asp"-->
</body>

</html>
