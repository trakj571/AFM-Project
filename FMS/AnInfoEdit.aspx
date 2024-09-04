<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AnInfoEdit.aspx.cs" Inherits="AFMProj.FMS.AnInfoEdit" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    
    <style>
       .tborder, .tborder th, .tborder td {border:1px solid #ccc;padding:4px;}
       .tborder th {background:#eee;text-align:center}
       .u {padding:0 10px 0 10px}
       .u input{text-align:center;border-bottom:1px double #777}
   </style>

    <script src="../_Inc/js/highstock.js"></script>
   
    <script language=javascript>
        var scanID = '<%=Request["scanID"] %>';
        var isall = '<%=Request["all"] %>';
        $(function () {
            $("a[rel=AInfo]").addClass("is-active");
            // readSensor();
            if (isall == 1)
                $("#checkedAll").prop("checked", true);
            $("#checkedAll").click(function () {
                filterLoc();
            });
            $("#FreqRange").change(function () {

                filterLoc();
            });

            msgbox_save(<%=retID %>, "AnOcc.aspx?scanid=" + scanID + ($("#checkedAll").prop("checked") ? "&all=1" : "") + "&ftid=" + $("#FreqRange").val());
        });


        function filterLoc() {
            if ($("#checkedAll").prop("checked"))
                location = "AnOcc.aspx?scanid=" + scanID + "&all=1&ftid=" + $("#FreqRange").val() + "#occtb";
            else
                location = "AnOcc.aspx?scanid=" + scanID + "&ftid=" + $("#FreqRange").val() + "#occtb"
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
				<div class="afms-content afms-content-1" id="station<%=tbS.Rows[0]["PoiID"] %>">
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
				</div>

                <br />

                <!--Exception-->
                <div class="afms-content afms-content-1">
                <form id=FrmEdit runat=server>
                    <div class="row">
                        <div class="col-md-3 print-content">
                         <div class="afms-field afms-field_checkbox">
                                            <label style="margin-top:0px!important;font-weight:bold">
                                                <input name="checkedAll" type="checkbox" id="checkedAll" value="1" />
                                                <div class="box"></div>
                                                <div class="check afms-ic_check"></div>
                                                ALL Frequency
                                            </label>
                                        </div>
                            </div>
                        <div class="col-md-4 print-content">
                         <div class="afms-field afms-field_select">
                                       	<label>ช่วงความถี่</label>
									<select id=FreqRange runat=server data-live-search="true"></select>
                                        </div>
                            </div>
                    </div>

					<div class="row">
                                <table class=tborder>
                                <tr><th>No.</th><th>Frequency</th>
                                       <th>Signal</th>
                                       <th>Occupancy</th>
                               </tr>
                                    <%
                                    for (int i = 0; i < tbD.Rows.Count; i++)
                                    {
                                        Response.Write("<tr align=center>");
                                        Response.Write("<td>"+(i+1)+"</td>");
                                        Response.Write("<td><input type=text id='Freq"+tbD.Rows[i]["ScanDID"]+"'  name='Freq"+tbD.Rows[i]["ScanDID"]+"' value='"+tbD.Rows[i]["Freq"]+"' /></td>");
                                         Response.Write("<td><input type=text id='Signal"+tbD.Rows[i]["ScanDID"]+"'  name='Signal"+tbD.Rows[i]["ScanDID"]+"' value='"+tbD.Rows[i]["Signal"]+"' /></td>");
                                          
                                        Response.Write("<td><input type=text id='OccAvg"+tbD.Rows[i]["ScanDID"]+"'  name='OccAvg"+tbD.Rows[i]["ScanDID"]+"' value='"+tbD.Rows[i]["OccAvg"]+"' /></td>");
                                      
                                      Response.Write("</tr>");
                                    }
                                    
                               %>
                
                                </table>

                            </div>

                            <div class="row">
                            <div class="col-md-12 afms-group-btn text-center no-print-content">
                                 <a href="AnInfo.aspx?scanid=<%=tbS.Rows[0]["scanid"] %>" class="afms-btn afms-btn-secondary">
								         กลับ
							        </a>&nbsp;

                                  	<input id="Submit1" type="submit" class="afms-btn afms-btn-primary" value="บันทึก" style='width:auto' onserverclick="bSave_ServerClick" runat=server /> &nbsp; 
							


                                </div>
                                </div>

                                </form>
                            </div>


				</div>
                
				
			</div>
		</div>

		<div class="afms-push"></div>
	</div>

	<!--#include file="../_inc/Ft.asp"-->
</body>

</html>
