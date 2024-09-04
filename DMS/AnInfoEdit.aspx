<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AnInfoEdit.aspx.cs" Inherits="AFMProj.DMS.AnInfoEdit" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    
    <style>
       .tborder, .tborder th, .tborder td {border:1px solid #ccc;padding:4px;}
       .tborder th {background:#eee;text-align:center}
       .u {padding:0 10px 0 10px}
       .u input{text-align:center;border-bottom:1px double #777}
       .afms-pagination {text-align:left!important}
   </style>

    <script src="../_Inc/js/highstock.js"></script>
   
    <script language=javascript>
        var scanID = '<%=Request["scanID"] %>';
        $(function () {
            $("a[rel=AInfo]").addClass("is-active");
            // readSensor();

             msgbox_save(<%=retID %>,"AnInfo.aspx?scanid="+scanID);
        });

        function schData() {
            var parms = []
            $("#FrmSch select").each(function () {
                parms.push(this.id + "=" + this.value);
            });
            $("#FrmSch input[type=text]").each(function () {
                parms.push(this.id + "=" + escape(this.value));
            });
            location = location.toString().replace(location.search, "") + "?scanid=" + scanID + "&" + parms.join('&');
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
                <div class="afms-content afms-content-1" style="padding-left:50px;">
                    <form id="FrmSch">
                      <div class="row">
                        <div class="col-md-3">
								<div class="afms-field afms-field_input">
									<label>คลื่นความถี่ (MHz)</label>
									<input type=text id=sfFreq value="<%=Request["sfFreq"] %>" />
									<span class="bar"></span>
								</div>
							</div>
                            <div class="col-md-3">
								<div class="afms-field afms-field_input">
									<label>ถึงความถี่ (MHz)</label>
									<input type=text id=stFreq value="<%=Request["stFreq"] %>" />
									<span class="bar"></span>
								</div>
							</div>
                          <div class="col-md-3 text-center">
								<a href="javascript:schData()"  class="afms-btn afms-btn-primary"><i class="afms-ic_search"></i> ค้นหา</a>
							</div>
                    </div>
             </form>
                     <%=tbH.Rows[0]["nTotal"] %> รายการ
                     <form id=FrmEdit runat=server>
					<div class="row">
                                <table class=tborder>
                                <tr><th>No.</th><th>Frequency</th>
                                       <% if(tbS.Rows[0]["DataType"].ToString() == "F"){ %>   
                                       <th>Signal</th>
                                       <%if(tbS.Rows[0]["EquType"].ToString()=="MOB"){%>
                                       <th>Bearing</th>
                                       <th>Quality</th>
                                      <%}}if(tbS.Rows[0]["DataType"].ToString() == "O" || tbS.Rows[0]["DataType"].ToString() == "R"){%>
                                        <th>Occupancy Max.</th>
                                       <th>Occupancy Avg.</th>
                                       <%} %>
                                <%
                                    for (int i = 0; i < tbD.Rows.Count; i++)
                                    {
                                        Response.Write("<tr align=center>");
                                        Response.Write("<td>"+tbD.Rows[i]["ID"]+"</td>");
                                        Response.Write("<td><input type=text id='Freq"+tbD.Rows[i]["ScanDID"]+"'  name='Freq"+tbD.Rows[i]["ScanDID"]+"' value='"+tbD.Rows[i]["Freq"]+"' /></td>");
                                       
                                        if(tbS.Rows[0]["DataType"].ToString() == "F"){
                                            Response.Write("<td><input type=text id='Signal"+tbD.Rows[i]["ScanDID"]+"'  name='Signal"+tbD.Rows[i]["ScanDID"]+"' value='"+tbD.Rows[i]["Signal"]+"' /></td>");
                                            if(tbS.Rows[0]["EquType"].ToString()=="MOB"){
                                                Response.Write("<td><input type=text id='Bearing"+tbD.Rows[i]["ScanDID"]+"'  name='Bearing"+tbD.Rows[i]["ScanDID"]+"' value='"+tbD.Rows[i]["Bearing"]+"' /></td>");
                                                Response.Write("<td><input type=text id='Qt"+tbD.Rows[i]["ScanDID"]+"'  name='Qt"+tbD.Rows[i]["ScanDID"]+"' value='"+tbD.Rows[i]["Qt"]+"' /></td>");
                                            }
                                       }
                                       if(tbS.Rows[0]["DataType"].ToString() == "O" || tbS.Rows[0]["DataType"].ToString() == "R"){
                                         Response.Write("<td><input type=text id='OccMax"+tbD.Rows[i]["ScanDID"]+"'  name='OccMax"+tbD.Rows[i]["ScanDID"]+"' value='"+tbD.Rows[i]["OccMax"]+"' /></td>");
                                         Response.Write("<td><input type=text id='OccAvg"+tbD.Rows[i]["ScanDID"]+"'  name='OccAvg"+tbD.Rows[i]["ScanDID"]+"' value='"+tbD.Rows[i]["OccAvg"]+"' /></td>");
                                       }
                                      Response.Write("</tr>");
                                    }
                                    
                               %>
                
                                </table>
                         <!--#include file="../_inc/Page.asp"-->
                            </div>

                            <div class="row">
                            <div class="col-md-6 afms-group-btn text-center no-print-content">
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
