<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AImp.aspx.cs" Inherits="AFMProj.FMS.AImp" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <script src="../_Inc/js/highstock.js"></script>
    <script type="text/javascript" src="../gis/libs/flowplayer/flowplayer-3.2.13.min.js"></script>
    <script type="text/javascript" src="../gis/libs/flowplayer/flowplayer.ipad-3.2.13.min.js"></script>	
    <link rel="stylesheet" href="../_inc/css/bootstrap-timepicker.css">
    <script src="../_inc/js/bootstrap-timepicker.js"></script>
    <style>
        table, th, td {
            border: 1px solid black;
        } 
        td {padding:3px}
        #bDownload{display:none}
        #col-DataType{display:none}
        .afms-field_timepicker {
    border-bottom: 1px solid #7c8a9d;
    position: relative;
}

    .afms-field_timepicker label {
        color: #922d35;
        font-weight: 500;
        display: block;
    }

    .afms-field_timepicker i {
        position: absolute;
        bottom: 6px;
        left: -3px;
        font-size: 24px;
        color: #555555;
    }

    .afms-field_timepicker input {
        padding-left: 30px;
    }


    .bootstrap-timepicker-widget {
        border-radius: 0;
        -webkit-border-radius: 0;
        -moz-border-radius: 0;
        -ms-border-radius: 0;
        -o-border-radius: 0;
        padding: 0 !important;
        min-width: 120px;
    }
    .bootstrap-timepicker-widget td {
        border:0!important;
    }
    .bootstrap-timepicker-widget input {
        border-radius: 0;
        -webkit-border-radius: 0;
        -moz-border-radius: 0;
        -ms-border-radius: 0;
        -o-border-radius: 0;
        width: 36px !important;
        height: 36px;
    }

       .bootstrap-timepicker-widget input:hover {
            border: 1px solid #ed1c24;
        }

    .bootstrap-timepicker-widget a {
        padding: 0 !important;
        font-size: 20px;
        border: 0 !important;
        background-color: #ffffff !important;
    }

    </style>
     <script src="../_inc/js/dpv2.js"></script>
    <script src="../_inc/js/pvscp2.js?d=1"></script>
     <script language=javascript>
         var poiid = '<%=Request["PoiID"] %>';
         $(function () {
             $('.afms-field_timepicker input').timepicker({
                 'defaultTime': false,
                 'showMeridian': false,
                 'icons': {
                     'up': 'afms-ic_up',
                     'down': 'afms-ic_down'
                 }
             });
         });

         function removeChar(txt) {
             var numb = txt.match(/\d/g);
             return numb.join("");
             
         }
         $(function () {
             msgbox_save(<%=retID %>,"AnInfo.aspx?scanid=<%=retID %>");
             <%if(retID==-99){ %>
             swal({
                 title: 'รูปแบบไฟล์ข้อมูลไม่ถูกต้อง โปรดตรวจสอบ',
                 text: "",
                 type: 'warning',
                 showCancelButton: false,
                 confirmButtonText: 'ตกลง',
                 confirmButtonClass: 'nbtc-btn nbtc-btn-primary'
             });
             <%} %>

             setPATZ('000000');
             getLoc();
             $("#DtBegin,#TmBegin").change(function () {
                 getLoc();

             });
             $("#File1").change(function () {
                 try {
                     var fn = $(this).val();
                     fn = fn.substring(fn.lastIndexOf('\\') + 1).split('.')[0];
                     //137-174MHz_21-03-18_02'30'01
                     var f1 = fn.split('_');
                     $("#fFreq").val(removeChar(f1[0].split('-')[0]));
                     $("#tFreq").val(removeChar((f1[0].split('-')[1]).replace('MHz', '').split(' ')[0]));
                     var f2 = f1[1].split('-');
                     var f3 = f1[2].split("'");
                 var d = new Date(Date.UTC(parseInt('20' + f2[0]), parseInt(f2[1])-1, f2[2], f3[0], f3[1], 0, 0));

                     //alert(d);


                 $("#DtBegin").val(d.getDate() + '/' + (d.getMonth()+1) + '/' + (d.getFullYear() + 543));
                 $("#TmBegin").val(d.getHours() + ':' + d.getMinutes());
                     getLoc();

                 } catch {
                     //alert('error');
                 }
                
             });
             

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

                     data += "["+cConvert.ToDouble(tbC.Rows[i]["Freq"])+","+cConvert.ToDouble(tbC.Rows[i]["OccAvg"])+"]";
                     data2 += "["+cConvert.ToDouble(tbC.Rows[i]["Freq"])+","+cConvert.ToDouble(tbC.Rows[i]["Signal"])+"]";

                    //       data += "["+cConvert.ToDouble(tbC.Rows[i]["Freq"])+","+cConvert.ToDouble(tbC.Rows[i]["Signal"])+"]";
               }
               data +="]";
               data2 +="]";
            %>
             $("#bDownload").show();
             $("#bDownload").click(function () {
                 window.open('<%=fileName %>');
             });
             chartImpO();
             //chartImpF();
               
             <%} %>
         });

         function getLoc() {
             if ($("#DtBegin").val() == "") return;
             $.ajax({
                 type: 'POST',
                 url: "data/dScanLoc.ashx",
                 data: {
                     poiid: poiid,
                     DtScan: $("#DtBegin").val() + " " + $("#TmBegin").val()
                 },
                 cache: false,
                 dataType: 'json',
                 success: function (data) {
                     $("#Lat").val(data[0].Lat);
                     $("#Lng").val(data[0].Lng);
                     $("#PatCode").val(data[0].PatCode+"");
                     setPATZ(data[0].PatCode+"");
                 },
                 error: function (XMLHttpRequest, textStatus, errorThrown) {

                 }

             });

         }

         function setPATZ(patcode) {
             setProv2('sProv2', patcode.substring(0,2));
             setAumphur2('sAumphur2', patcode.substring(0, 2), patcode.substring(0, 4));
             setTumbon2('sTumbon2', patcode.substring(0, 4), patcode.substring(0, 6));

         }
         
         function chartImpO(){
            var dataSeries = [];
            dataSeries.push({
                    name: 'Occupancy',
                    data: <%=data %>,
                    tooltip: {
                            valueDecimals: 2
                        }
                    });
             dataSeries.push({
                 name: 'Signal',
                 data: <%=data2 %>,
                 tooltip: {
                     valueDecimals: 2
                 }
             });
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
                yAxis: { title: { text: "Occupancy (%) / Signal (dBuV/m)"} },
                xAxis: { title: { text: "Frequency (MHz)" }, labels: { formatter: function () { return (this.value / 1000000.0).toFixed(4); } } },
                tooltip: { formatter: function () {
                    var s = '<b>' + (this.x / 1000000.0).toFixed(4) + 'MHz</b>';

                    $.each(this.points, function (i, point) {
                        s += '<br/>' + point.series.name + ': ' +
                                        point.y + '';
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
            window.open('samples/'+s+'-o.csv');
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
				<li>Import</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../FMS/Menu.asp"-->
			
            <%
              if (Request["poiid"] == null)
              {
                  if(tbSTN.Rows.Count> 0)
                    Response.Redirect("DImp.aspx?poiid=" + tbSTN.Rows[tbSTN.Rows.Count - 1]["PoiID"]);

              }
              else
              {
                  for (int i = 0; i < tbSTN.Rows.Count; i++)
                  {
                      if (tbSTN.Rows[i]["PoiID"].ToString() == Request["poiid"])
                          drSTN = tbSTN.Rows[i];
                  }
             } 
             
             if(drSTN!=null){
             %>
			
            <script type="text/javascript">
                var brand = '<%=drSTN["SampleFile"] %>';

                $(function () {
                    if (brand == "470.1" || brand == "470.2" || brand == "470.3") {
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
                });

                $(document).ready(function () {
                    $('#loader').hide();
                    $('form').submit(function () {
                        <%if (drSTN["SampleFile"].ToString() == "STN") {%>

                        if ($("#fFreq").val() != "" && $("#tFreq").val() != "" && !isNaN($("#fFreq").val()) && !isNaN($("#tFreq").val()) &&
                            parseFloat($("#fFreq").val()) > 0 && parseFloat($("#tFreq").val()) > 0 && parseFloat($("#fFreq").val()) < 100000 && parseFloat($("#tFreq").val()) < 100000)
                            $('#loader').show();
                                <%}
                            else { %>
                        if ($("#File1").val() != "" && $("#fFreq").val() != "" && $("#tFreq").val() != "" && !isNaN($("#fFreq").val()) && !isNaN($("#tFreq").val()) &&
                            parseFloat($("#fFreq").val()) > 0 && parseFloat($("#tFreq").val()) > 0 && parseFloat($("#fFreq").val()) < 100000 && parseFloat($("#tFreq").val()) < 100000)
                                    $('#loader').show();
                        });


                        <%}%>
                });




            </script>
            <%} %>

            <form id=DImp runat=server>
            <input type="hidden" runat="server" id="TmpKey" />
                <input type="hidden" runat="server" id="PatCode" />
            <div class="col-md-12">
                <div class="afms-content" id="station">
                    <%if(drSTN!=null){ %>
                   
					<div class="afms-page-title"><i class="afms-ic_record"></i>
                    <%=drSTN["LayerName"] %> - 
                    <%=drSTN["Name"] %>
			        (<%=drSTN["TypeName"] %>)
                    </div>

                    <div class="row">
                            <div class="col-md-2">
                                <div class="afms-field afms-field_datepicker">
                                    <label>Start Date</label>
                                    <input id="DtBegin" runat="server" type="text" placeholder="DD/MM/YYYY" />
                                    <span class="bar"></span>
                                    <i class="afms-ic_date"></i>
                                </div>
                            </div>
                        <div class="col-md-2">
                                <div class="afms-field afms-field_timepicker">
                                    <label>Time</label>
                                    <input id="TmBegin" runat="server" type="text" name="" placeholder="00:00" />
                                    <span class="bar"></span>
                                    <i class="afms-ic_time"></i>
                                </div>
                            </div>

                        <div class="col-md-1 col-sm-6">
                                    <div class="afms-field afms-field_select">
                                        <label for="">Hr</label>
                                        <select id="nHr" runat="server">
                                        </select>
                                        <span class="bar"></span>
                                    </div>
                                </div>
                                <div class="col-md-1 col-sm-6">
                                    <div class="afms-field afms-field_select">
                                        <label for="">: Min</label>
                                        <select id="nMin" runat="server">
                                        </select>
                                        <span class="bar"></span>
                                    </div>
                                </div>
                                <div class="col-md-1 col-sm-6">
                                    <div class="afms-field afms-field_select">
                                        <label for="">: Sec</label>
                                        <select id="nSec" runat="server">
                                        </select>
                                        <span class="bar"></span>
                                    </div>
                                </div>

                        <div class="col-md-2" style="display:none">
                                <div class="afms-field afms-field_datepicker">
                                    <label>Stop Date</label>
                                    <input id="DtEnd" runat="server" type="text" placeholder="DD/MM/YYYY" />
                                    <span class="bar"></span>
                                    <i class="afms-ic_date"></i>
                                </div>
                            </div>
                        <div class="col-md-2"  style="display:none">
                                <div class="afms-field afms-field_timepicker">
                                    <label>Time</label>
                                    <input id="TmEnd" runat="server" type="text" name="" placeholder="00:00" />
                                    <span class="bar"></span>
                                    <i class="afms-ic_time"></i>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <div class="afms-field afms-field_input">
                                    <label>Start Frequency  (MHz)</label>
                                    <input type="text" id="fFreq" runat="server" />
                                    <span class="bar"></span>

                                </div>
                                <div class="valid">
                                     <asp:RequiredFieldValidator ID=rfFreq ControlToValidate=fFreq runat=server Display=Dynamic>* กรุณาระบุความถี่ (MHz)</asp:RequiredFieldValidator>
                                    <asp:RangeValidator ID="rngfFreq" ControlToValidate="fFreq" Type="Double" MinimumValue="0" MaximumValue="100000" runat="server" Display="Dynamic">* กรุณาระบุเป็นตัวเลข</asp:RangeValidator>
                                </div>
                        </div>

                        <div class="col-md-3">
                            <div class="afms-field afms-field_input">
                                <label>Stop Frequency  (MHz)</label>
                                <input type="text" id="tFreq" runat="server" />
                                <span class="bar"></span>
                            </div>
                            <div class="valid">
                                <asp:RequiredFieldValidator ID=rtFreq ControlToValidate=tFreq runat=server Display=Dynamic>* กรุณาระบุความถี่ (MHz)</asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="rngtFreq" ControlToValidate="tFreq" Type="Double" MinimumValue="0" MaximumValue="100000" runat="server" Display="Dynamic">* กรุณาระบุเป็นตัวเลข</asp:RangeValidator>
                                </div>
                    </div>
                    <div class="col-md-3">
                        <div class="afms-field afms-field_select">
                            <label>Channel Space</label>
                            <select id="ChSp" runat="server"> 
                                <option value="10000">10.0 kHz</option>
                                <option value="12500" selected="selected">12.5 kHz</option>
                                <option value="25000">25.0 kHz</option>
                                 <option value="50000">50.0 kHz</option>
                                <option value="100000">100.0 kHz</option>
                                <option value="200000">200.0 kHz</option>
                                <option value="250000">250.0 kHz</option>
                                <option value="1000000">1.0 MHz</option>
                                <option value="7000000">7.0 MHz</option>
                                <option value="8000000">8.0 MHz</option>
                            </select>
                            <span class="bar"></span>
                        </div>
                    </div>
                </div>

                     <div class="row">
                            <div class="col-md-2">
                                <div class="afms-field afms-field_input">
                                    <label>Lat</label>
                                    <input type="text" id="Lat" runat="server" />
                                    <span class="bar"></span>

                                </div>
                                <div class="valid">
                                    <asp:RangeValidator ID="rngLat" ControlToValidate="Lat" Type="Double" MinimumValue="-90" MaximumValue="90" runat="server" Display="Dynamic">* กรุณาระบุเป็นตัวเลข Lat</asp:RangeValidator>
                                </div>
                        </div>
                         <div class="col-md-2">
                                <div class="afms-field afms-field_input">
                                    <label>Long</label>
                                    <input type="text" id="Lng" runat="server" />
                                    <span class="bar"></span>

                                </div>
                                <div class="valid">
                                    <asp:RangeValidator ID="rngLng" ControlToValidate="Lng" Type="Double" MinimumValue="-180" MaximumValue="180" runat="server" Display="Dynamic">* กรุณาระบุเป็นตัวเลข Lat</asp:RangeValidator>
                                </div>
                        </div>

                          <div class="col-md-2">
								<div class="afms-field afms-field_select">
									<label>จังหวัด</label>
                                    
									<select id=sProv2  runat=server onchange="setAumphur2('sAumphur2',this.value,'0')" data-live-search="true">
                                        <option value="0">=== เลือก ===</option>
                                    </select>
                                    <div id="sProvText"></div>
								</div>
							</div>
							<div class="col-md-2">
								<div class="afms-field afms-field_select">
									<label>อำเภอ</label>
									<select id=sAumphur2 runat=server  disabled=disabled onchange="setTumbon2('sTumbon2',this.value,'0')" data-live-search="true">
                                        <option value="0">=== เลือก ===</option>
                                    </select>
                                     <div id="sAumphurText"></div>
								</div>
							</div>
							<div class="col-md-2">
								<div class="afms-field afms-field_select">
									<label>ตำบล</label>

									<select id=sTumbon2 runat=server disabled=disabled data-live-search="true">
                                        <option value="0">=== เลือก ===</option>
                                    </select>
                                    <div id="sTumbonText"></div>
									
								</div>
							</div>
                         </div>
                    <%if (Request.QueryString["file"] == null)
                        {
                           %>
                    <div class="row">
						<div class="col-md-4">
							<div class="afms-field afms-field_select">
								<label>Import File (.csv)</label>
								<input id=File1 runat=server type=file />
								<span class="bar"></span>
							</div>
                           <div class=valid><asp:RequiredFieldValidator ID=rFile1 ControlToValidate=File1 runat=server Display=Dynamic>* โปรด Import File</asp:RequiredFieldValidator></div>
					
						</div>

                         <div class="col-md-4">
							<div class="afms-field" style='text-align:center'>
                                <label></label><br />
                                
								<a href='javascript:downloadSample("activity")'>Sample File</a>
								
							</div>
						</div>

                         </div>
                    <%}%>
                                                               
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


