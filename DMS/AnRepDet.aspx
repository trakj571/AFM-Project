<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AnRepDet.aspx.cs" Inherits="AFMProj.FMS.AnRepDet" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
      <script language=javascript src="../_inc/js/dpv2.js"></script>
    <script language=javascript src="../_inc/js/pvscp2.js"></script>
   
    <script language=javascript>
        $(function(){
            $("a[rel=AnRep]").addClass("is-active");
        });

        function repPrint() {
            <%if(Request["TypeID"]=="4") {%>
                window.open("../ISOForm/F04.aspx?typeid=<%=Request["TypeID"] %>&s_id=<%=Request["s_id"] %>");
            <%}else{ %>
                window.open("../ISOForm/F01.aspx?typeid=<%=Request["TypeID"] %>&s_id=<%=Request["s_id"] %>");
            <%} %>
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
				<li>รายงานการตรวจสอบ</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../DMS/Menu.asp"-->
			
               <form id=Form1 runat=server method=post>
		
			<div class="col-md-12">
				<div class="afms-content content-readonly print-content">
					<div class="afms-page-title is-online">
						รายงานการตรวจสอบ
					</div>
					<div class="row">
                    <%
                       
                       for (int i = 0; i < ColsData.Length; i += 2)
                        {
                            Response.Write("<div class=\"col-md-4\">");
							Response.Write("<div class=\"afms-field afms-field_select\">");
                            Response.Write("<p class=\"afms-field-title\">"+ColsData[i+1]+"</p>");
                            Response.Write("<!--p>"+tbD.Rows[0][ColsData[i]]+"</p-->");
                            if (tbD.Columns[ColsData[i]].DataType == typeof(DateTime))
                               Response.Write("<p>"+string.Format("{0:dd/MM/yyyy}", tbD.Rows[0][ColsData[i]]));
                            else
                                Response.Write("<p>"+tbD.Rows[0][ColsData[i]]+"</p>");

							Response.Write("</div>");
						    Response.Write("</div>");
                        }
                        
                        if(cConvert.ToInt(Request["typeid"])==4){
                            Lat.Value = tbD.Rows[0]["CURRENT_LAT"].ToString();
                            Lng.Value = tbD.Rows[0]["CURRENT_LONG"].ToString();
                        }else{
                            Lat.Value = tbD.Rows[0]["LATITUDE"].ToString();
                            Lng.Value = tbD.Rows[0]["LONGITUDE"].ToString();
                        }
                     %>
					
						
						
						
					</div>
                    <%if(tbS!=null){ %>
                    <br /><br />

                    <div class="row">
                   <div class="col-md-3">
								<div class="afms-field afms-field_input">
									<label>ผลการตรวจสอบ</label>
									</div>
							</div>
					</div>
                     <div class="row">
                     <div class="col-md-12">
                     <div class="afms-sec-table" style='min-height:80px'>
							<table class="table table-condensed text-center afms-table-responsive" >
								<thead>
									<tr>
										<th style="width: 60px">ลำดับ</th>
										<th>Equipment</th>
                                        <th>DataType</th>
                                     	<th>วัน-เวลา</th>
										<th>ความถี่เริ่มต้น(MHz)</th>
									    <th>ความถี่สิ้นสุด(MHz)</th>
										 <th class="no-print-page"  style="width: 60px">ข้อมูล</th>
                                       
									</tr>
								</thead>
								<tbody>
                                <%for(int i=0;i<tbS.Rows.Count;i++){ %>
									<tr>
										<td data-th="ลำดับ"><%=(i+1) %></td>
										<td data-th="Equipment"><%=tbS.Rows[i]["Station"] %></td>
                                      <td data-th="Data Type"><%=tbS.Rows[i]["DataTypeText"] %></td>
                                      
										<td data-th="วัน-เวลา"><%=string.Format("{0:dd/MM/yyyy HH:mm}",tbS.Rows[i]["DtBegin"]) %></td>
									    <td data-th="ความถี่เริ่มต้น(MHz)"><%=string.Format("{0:0.0000}",tbS.Rows[i]["fFreq"]) %></td>
                                       <td data-th="ความถี่สิ้นสุด(MHz)"><%=string.Format("{0:0.0000}",tbS.Rows[i]["tFreq"]) %></td>
                                    
										    <td class="no-print-page">
											    <a href="AnInfo.aspx?scanid=<%=tbS.Rows[i]["ScanID"] %>" class="afms-btn afms-btn-view afms-ic_view"></a>
										    </td>
                                     
									</tr>
                                    <%} %>
								</tbody>
							</table>
						</div>
                     </div>
                     </div>
                     <%} %>
					<div class="row" style="margin-top: 20px">
						<div class="col-md-12 no-print-page">
					      
                       <input type=hidden id=Lat runat=server value="" />
                       <input type=hidden id=Lng runat=server value="" />
                       <input type=hidden id=Tools runat=server value="1" />
                       <!--#include file="../GIS/EMapView.asp"-->
                            
                    	</div>
					</div>

					<div class="row no-print-page">
						<div class="col-md-12">
							<div class="afms-group-btn text-center">
						        <a href="javascript:exportXls()" class="afms-btn afms-btn-secondary"><i class="afms-ic_download"></i>Export</a>
                               <a href="javascript:exportPrint()" class="afms-btn afms-btn-secondary"><i class="afms-ic_print"></i>พิมพ์</a>
                               <a href="javascript:repPrint()" class="afms-btn afms-btn-secondary"><i class="afms-ic_print"></i>พิมพ์รายงาน</a>
					      </div>
						</div>
					</div>
				</div>
			</div>

            </form>
		</div>

		<div class="afms-push"></div>
	</div>

	<!--#include file="../_inc/Ft.asp"-->
</body>

</html>