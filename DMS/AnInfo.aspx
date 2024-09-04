<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AnInfo.aspx.cs" Inherits="AFMProj.DMS.AnInfo" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    
    <style>
       .tborder {width:60%}
       .tborder, .tborder th, .tborder td {padding:2px;}
       .tborder th {background:#eee;text-align:center}
       .u {padding:0 10px 0 10px}
       .u input{text-align:center;border-bottom:1px double #777}
   </style>

    <script src="../_Inc/js/highstock.js"></script>
   
    <script language=javascript>
        var scanID = '<%=Request["scanID"] %>';
        $(function () {
            $("a[rel=AInfo]").addClass("is-active");
            // readSensor();
           <%if(tbS.Rows[0]["EquType"].ToString()=="MOB"){ %>
                dispChartM(scanID,'fre-container');
            <%}else if(tbS.Rows[0]["DataType"].ToString()=="O" || tbS.Rows[0]["DataType"].ToString()=="R"){ %>
		        dispChartDO(scanID,'fre-container',<%=tbS.Rows[0]["nData"] %>);
            <%}else{ %>
                dispChartD(scanID,'fre-container');
            <%} %>
        });

       function printC(){
            window.open("PrintChart.aspx");
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

       function editConf(){
            openDialog("Conf.aspx?poiid=<%=tbS.Rows[0]["PoiID"] %>");
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
				<li>Frequency Monitoring</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../DMS/Menu.asp"-->
			

			<div class="col-md-12">
				<div class="afms-content afms-content-1" id="station<%=tbS.Rows[0]["PoiID"] %>">
					<div class="row">
						<div class="col-md-12">
							<div class="collapse in content-readonly" id="searchSection">
						<div class="row">
							
							     <div class="col-md-3 col-sm-6">
									<div class="afms-field afms-field_input">
                                    	<p class="afms-field-title">Equipment</p>
							            <p><asp:label id=Station runat=server></asp:label></p>
                                	</div>
								</div>

                                <div class="col-md-3 col-sm-6">
									<div class="afms-field afms-field_input">
                                    	<p class="afms-field-title">Date</p>
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
							</div>
								<div class="row">
								<div class="col-md-3 col-sm-6">
									<div class="afms-field afms-field_input">
                                        <p class="afms-field-title">Channel Space</p>
							            <p><asp:label id=ChSpText runat=server></asp:label></p>
                                        
									</div>
								</div>
								<div class="col-md-3 col-sm-6">
									<div class="afms-field afms-field_input">
                                        <p class="afms-field-title">Data Type</p>
							            <p><asp:label id=DataType runat=server></asp:label></p>
                                        
									</div>
								</div>

								
							

												
						</div>
					</div>
						</div>					
					</div>
				</div>

                <br />

                <!--Exception-->
                <div class="afms-content afms-content-1">
					<div class="row">
						<div class="col-md-12">
							<div class="collapse in content-readonly" id="Div1">
						<div class="row">
							
							    <div class="col-md-3 col-sm-6">
									<div class="afms-field afms-field_input">
                                    	<p class="afms-field-title">Occupancy (%)</p>
							            <p><asp:label id=Occ runat=server></asp:label></p>
                                	</div>
								</div>

                                <div class="col-md-3 col-sm-6">
									<div class="afms-field afms-field_input">
                                    	<p class="afms-field-title">Field Strangth (dBuV/m)</p>
							            <p><asp:label id=FStr runat=server></asp:label></p>
                                	</div>
								</div>
					   </div>
                       <br />
                        <div class="row">
                            <div class="col-md-12">
                            <div class="afms-field afms-field_input">
                               <p class="afms-field-title">Frequency Exception </p>
                               </div>

                                <table class=tborder>
                                <tr><th>No.</th><th>Frequency Start</th><th>Frequency Stop</th><th width=50></th></tr>
                                <%
                                    for (int i = 0; i < tbF.Rows.Count; i++)
                                    {
                                        Response.Write("<tr align=center>");
                                        Response.Write("<td>"+(i+1)+"</td>");
                                        Response.Write("<td>"+tbF.Rows[i]["fFreq"]+"</td>");
                                        Response.Write("<td>" + tbF.Rows[i]["tFreq"] + "</td>");
                                        Response.Write("</tr>");
                                    }
                               %>
                
                                </table>

                            </div>
                            </div>


                            <div class="col-md-12 afms-group-btn text-center no-print-content">
                                         <a href="javascript:editConf()" class="afms-btn afms-btn-secondary">
								        <i class="afms-ic_edit"></i> แก้ไข
							        </a>
                                    </div>	
					    </div>
						</div>					
					</div>
				</div>

				<div class="afms-content afms-content-2" style="margin-top: 20px;">

					<div class="row">
						<div class="col-md-12">
							<div class="row">
								
								<div class="col-md-12 afms-frequency-monitor">
									<div id="fre-container" style="height: 400px; min-width: 310px"></div>
								</div>

								<div class="col-md-12 afms-group-btn text-center no-print-content">
                                  
                                    <%if(tbS.Rows[0]["EquType"].ToString()=="RMT" && tbS.Rows[0]["DataType"].ToString()=="F"){%>
									<a href="AnEvent.aspx?scanid=<%=tbS.Rows[0]["scanid"] %>" class="afms-btn afms-btn-secondary">EVENT(<%=tbS.Rows[0]["nEvent"] %>)</a>
									<a href="AnOcc.aspx?scanid=<%=tbS.Rows[0]["scanid"] %>" class="afms-btn afms-btn-secondary">Occupancy vs Channel</a>
									<a href="AnFStr.aspx?scanid=<%=tbS.Rows[0]["scanid"] %>" class="afms-btn afms-btn-secondary">Field Strangth vs Channel</a>
								    <%} %>
                                    <br /><br />
                                      <a href="javascript:delItem('dms.spDMSScanDel','scanid','<%=tbS.Rows[0]["scanid"] %>')" class="afms-btn afms-btn-secondary">
								        <i class="afms-ic_delete"></i> ลบข้อมูล
							        </a>
                                       <a href="AnInfoEdit.aspx?scanid=<%=tbS.Rows[0]["scanid"] %>" class="afms-btn afms-btn-secondary">
								        <i class="afms-ic_edit"></i> แก้ไข
							        </a>

                                    <a href="AnInfo.aspx?scanid=<%=tbS.Rows[0]["scanid"] %>&export=xls" target=_blank class="afms-btn afms-btn-secondary">
								        <i class="afms-ic_download"></i> Export to Excel
							        </a>
							        <a href="javascript:printC()" class="afms-btn afms-btn-secondary">
								        <i class="afms-ic_print"></i> พิมพ์
							        </a>
                                    <%if(tbS.Rows[0]["DataType"].ToString()=="O" || tbS.Rows[0]["DataType"].ToString()=="R"){ %>
                                      <a href="javascript:printOcc()" class="afms-btn afms-btn-secondary">
								        <i class="afms-ic_print"></i> รายงาน
							        </a>
                                    <%} %>
                                </div>
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
