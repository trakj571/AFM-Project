<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DImp.aspx.cs" Inherits="AFMProj.FMS.DImp" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <script src="../_Inc/js/highstock.js"></script>
    <script type="text/javascript" src="../gis/libs/flowplayer/flowplayer-3.2.13.min.js"></script>
    <script type="text/javascript" src="../gis/libs/flowplayer/flowplayer.ipad-3.2.13.min.js"></script>	
    <style>
        table, th, td {
            border: 1px solid black;
        } 
        td {padding:3px}
        #bDownload{display:none}
        #col-DataType{display:none}
    </style>
     <script language=javascript>
         var poiid = '<%=Request["PoiID"] %>';
         $(document).ready(function() 
        {
            $('#loader').hide();

            $('form').submit(function() 
            {
                if($("#File1").val()!="")
                    $('#loader').show();
            }) 
        })

         $(function () {
             msgbox_save(<%=retID %>,"AnInfo.aspx?scanid=<%=retID %>");
             <%if(retID==-99){ %>
                 swal({
                  title: 'รูปแบบไฟล์ข้อมูลไม่ถูกต้อง โปรดตรวจสอบ <%=Error%>',
                  text: "",
                  type: 'warning',
                  showCancelButton: false,
                  confirmButtonText: 'ตกลง',
                  confirmButtonClass: 'nbtc-btn nbtc-btn-primary'
                });
             <%} %>
             
             



            <%
             string data = "[]";
             string data2 ="[]";

            if(tbC!=null){ 
               data = "[";
               data2 = "[";
               for(int i=0;i<tbC.Rows.Count;i++){
                    if(i>0) {
                        data+=",";
                         data2+=",";
                    }
                    if(tbF.Rows[0]["EquType"].ToString()=="MOB"){
                        
                            data += "["+cConvert.ToDouble(tbC.Rows[i]["Bearing"])+","+cConvert.ToDouble(tbC.Rows[i]["Signal"])+"]";
                            data2 += "["+cConvert.ToDouble(tbC.Rows[i]["Bearing"])+","+cConvert.ToDouble(tbC.Rows[i]["Qt"])+"]";
                        
                    }else{
                        if(DataType.Value=="O"){
                            data += "["+cConvert.ToDouble(tbC.Rows[i]["Freq"])+","+cConvert.ToDouble(tbC.Rows[i]["OccAvg"])+"]";
                            data2 += "["+cConvert.ToDouble(tbC.Rows[i]["Freq"])+","+cConvert.ToDouble(tbC.Rows[i]["OccMax"])+"]";
                        }else{
                            data += "["+cConvert.ToDouble(tbC.Rows[i]["Freq"])+","+cConvert.ToDouble(tbC.Rows[i]["Signal"])+"]";
                        }
                    }
               }
               data +="]";
               data2 +="]";
            %>
             $("#bDownload").show();
             $("#bDownload").click(function(){
                window.open('<%=fileName %>');
             });
             
                 <%if(tbF.Rows[0]["EquType"].ToString()=="MOB"){ %>
                    chartImpFMB();
                <%}else if(DataType.Value=="O"){ %>
                    chartImpO();
                 <%}else{ %>
                    chartImpF();
                 <%} %>
             <%} %>
         });


         function chartImpF(){
            Highcharts.stockChart("fre-container", {
                 credits: { enabled: false },
                 chart: {
                     backgroundColor: "#eeeeee"
                 },
                 navigator: {
                      xAxis: { labels: { formatter: function () { return(this.value / 1000000.0).toFixed(4); } } }
                 },

                 rangeSelector: {
                     selected: 1,
                     enabled: false

                 },
                 yAxis: { title: { text: "Signal (dBuV/m)"} },
                 xAxis: { title: { text: "Frequency (MHz)" }, labels: { formatter: function () { return (this.value / 1000000.0).toFixed(4); } } },
                        tooltip: { formatter: function () {
                            var s = '<b>' + (this.x/1000000.0).toFixed(4) + 'MHz</b>';

                            $.each(this.points, function (i, point) {
                                s += '<br/>' + point.series.name + ': ' +
                                                (point.y).toFixed(2) + 'dBm';
                            });

                            return s;
                        }
                 },
                 title: {
                     text: ''
                 },

                 series: [{
                     name: 'Signal',
                     data: <%=data %>,
                     tooltip: {
                         valueDecimals: 4
                     },
                     point: {
                         events: {
                             click: function () {
                                
                             }
                         }
                     }


                 }]
             });
         }

         function chartImpFMB(){
            Highcharts.stockChart("fre-container", {
                 credits: { enabled: false },
                 chart: {
                     backgroundColor: "#eeeeee"
                 },
                 navigator: {
                      xAxis: { labels: { formatter: function () { return(this.value).toFixed(0); } } }
                 },

                 rangeSelector: {
                     selected: 1,
                     enabled: false

                 },
                 yAxis: { title: { text: "Signal (dBuV/m)"} },
                 xAxis: { title: { text: "Bearing(Deg)" }, labels: { formatter: function () { return (this.value).toFixed(0); } } },
                        tooltip: { formatter: function () {
                            var s = '<b>' + (this.x).toFixed(0) + 'Deg</b>';

                            $.each(this.points, function (i, point) {
                                s += '<br/>' + point.series.name + ': ' +
                                                point.y + 'dBm';
                            });

                            return s;
                        }
                 },
                 title: {
                     text: ''
                 },

                 series: [{
                     name: 'Signal',
                     data: <%=data %>,
                     tooltip: {
                             valueDecimals: 4
                         }
                     },
                     {
                         name: 'Quality',
                         data: <%=data2 %>,
                         tooltip: {
                             valueDecimals: 2
                         }
                     }
                    ]
             });
         }

         function chartImpO(){
            var dataSeries = [];
            dataSeries.push({
                    name: 'Occupancy Avg',
                    data: <%=data %>,
                    tooltip: {
                            valueDecimals: 2
                        }
                    });

            if(brand=="470.1"){
                 dataSeries.push({
                         name: 'Occupancy Max',
                         data: <%=data2 %>,
                         tooltip: {
                             valueDecimals: 2
                         }
                     });
           }

            Highcharts.stockChart("fre-container", {
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

                series: dataSeries
            });
         }

         function downloadSample(s){
            window.open('samples/'+s+'-'+$("#DataType").val()+'.csv');
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
				<li>Import</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../DMS/Menu.asp"-->
			
            <%
                if (Request["poiid"] == null)
                {
                    if (tbSTN.Rows.Count > 0)
                        Response.Redirect("DImp.aspx?poiid=" + tbSTN.Rows[tbSTN.Rows.Count - 1]["PoiID"]);

                }
                else
                {
                    for (int i = 0; i < tbSTN.Rows.Count; i++)
                    {
                        if (tbSTN.Rows[i]["PoiID"].ToString() == Request["poiid"])
                        {
                            drSTN = tbSTN.Rows[i];
                            if (drSTN["TypeName"].ToString() == "RLX-810")
                            {
                                Response.Redirect("../FMS/AImp.aspx?poiid=" + Request["poiid"]);
                            }
                        }
                    }
                }
                if(drSTN!=null){
             %>
			
            <script type="text/javascript">
                var brand = '<%=drSTN["SampleFile"] %>';

                $(function () {
                    if (brand == "470.1" || brand == "470.2" || brand == "470.2O" || brand == "470.3") {
                        $("#col-DataType").show();
                        if (brand != "470.2") {
                            
                        }
                        $("#DataType").val("O");
                        $("#DataType").selectpicker("refresh");
                    }
                    if (brand == "470.OTH") {
                        $("#DataType").val("O");
                        $("#DataType").selectpicker("refresh");
                    }

                    if (brand == "470.RNS-BK") {
                        $("#DataType").val("O");
                        $(".col-ChSp").show();
                    }
                });
            </script>
            <%} %>

            <form id=DImp runat=server>
            <input type="hidden" runat="server" id="TmpKey" />
            <div class="col-md-12">
                <div class="afms-content" id="station">
                    <%if(drSTN!=null){ %>
                   
					<div class="afms-page-title"><i class="afms-ic_record"></i>
                    <%=drSTN["LayerName"] %> - 
                    <%=drSTN["Name"] %>
			        (<%=drSTN["TypeName"] %>)
                    </div>


                    <div class="row">
						
                        <div id="col-DataType" class="col-md-4">
							<div class="afms-field afms-field_select">
								<label>Data Type</label>
								<select id="DataType" runat="server">
									<option value="F" selected>Field Strength</option>
									<option value="O">Occupancy</option>
                                    <option value="R">Occupancy Report</option>
							    </select>
								<span class="bar"></span>
							</div>
						</div>
                    

                        <div class="col-md-4">
							<div class="afms-field afms-field_select">
								<label>Import File (.csv)</label>
								<input id=File1 runat=server type=file />
								<span class="bar"></span>
							</div>
                           <div class=valid><asp:RequiredFieldValidator ID=rFile1 ControlToValidate=File1 runat=server Display=Dynamic>* โปรด Import File</asp:RequiredFieldValidator></div>
					
						</div>
                        <div class="col-md-3 col-ChSp" style="display:none">
                        <div class="afms-field afms-field_select">
                            <label>Channel Space</label>
                            <select id="ChSp" runat="server">
                                <option value="12500">12.5 kHz</option>
                                <option value="25000">25.0 kHz</option>
                                <option value="200000">200.0 kHz</option>
                                <option value="250000">250.0 kHz</option>
                                <option value="1000000">1.0 MHz</option>
                                <option value="2000000">2.0 MHz</option>
                                <option value="5000000">5.0 MHz</option>
                                <option value="7000000">7.0 MHz</option>
                                <option value="8000000">8.0 MHz</option>
                            </select>
                            <span class="bar"></span>
                        </div>
                    </div>
                         <div class="col-md-4">
							<div class="afms-field" style='text-align:center'>
                                <label></label><br />
                                
								<a href='javascript:downloadSample("<%=drSTN["SampleFile"] %>")'>Sample File</a>
								
							</div>
						</div>

                         </div>

                      <div class="row">
					
                         <div class="col-md-12">
                            <div class="afms-group-btn text-center">
								<input id="bPreview" type="submit" class="afms-btn afms-btn-secondary" value="Preview" style='width:auto' onserverclick="bPreview_ServerClick" runat=server />
								<input id="bDownload" type=button value="Download" runat=server class="afms-btn afms-btn-secondary" style='width:auto'  />
							</div>
						</div>

                         <div class="col-md-12" style='text-align:center'>
                            <br />
                            <div id="loader"><img src='../_inc/css/throbber.gif' width=50 /> <span>Processing...</span></div>
                        </div>
                        </div>

                        <div class="row">
					
                         <div class="col-md-12">
                         <%if(tbMD1!=null){
                                Response.Write("<table width='100%'>");
                                Response.Write("<tr>");
                                Response.Write("<td style='background:#eee'>Date</td>");
                                Response.Write("<td style='background:#eee'>Start Frequency (MHz)</td>");
                                Response.Write("<td style='background:#eee'>Stop Frequency (MHz)</td>");
                                Response.Write("<td style='background:#eee'>Channel Space</td>");
                               Response.Write("</tr>");
                               Response.Write("<tr>");
                                Response.Write("<td align=center>"+string.Format("{0:dd/MM/yyyy HH:mm}",tbMD1.Rows[0]["DtBegin"])+"</td>");
                                Response.Write("<td align=center>"+ string.Format("{0:0.00}", cConvert.ToDouble(tbMD1.Rows[0]["fFreq"]) / 1e6)+"</td>");
                                Response.Write("<td align=center>"+ string.Format("{0:0.00}", cConvert.ToDouble(tbMD1.Rows[0]["tFreq"]) / 1e6)+"</td>");
                                Response.Write("<td align=center>"+ string.Format("{0:0.00}kHz", cConvert.ToDouble(tbMD1.Rows[0]["ChSp"]) / 1e3)+"</td>");
                                Response.Write("</tr>");
                                Response.Write("</table>");
                                

                                
                          %>

                          <div class="col-md-12 afms-frequency-monitor">
									    <div id="fre-container" style="height: 400px; min-width: 310px"></div>
								    </div>

                                
                            
                            <div class="row">
					
                         <div class="col-md-12">
                            <div class="afms-group-btn text-center">
								<input id="bSave" type="submit" class="afms-btn afms-btn-primary" causesvalidation=false value="บันทึก" style='width:100px' onserverclick="bSave_ServerClick" runat=server />
								
							</div>
                            
						</div>
                       
                        </div>

                        <%} %>
                         </div>
                         </div>

                         
                    <%} %>
           
           </div>
           

            </div>

            </form>
            </div>
		


		<div class="afms-push"></div>
	</div>

	<!--#include file="../_inc/Ft.asp"-->
</body>

</html>
