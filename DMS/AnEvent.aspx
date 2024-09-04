<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AnEvent.aspx.cs" Inherits="AFMProj.DMS.AnEvent" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <script language=javascript>
        $(function(){
            $("a[rel=AnChk]").addClass("is-active");
        });
    </script>
</head>
<body>
	<div class="afms-sec-container">
		<!--#include file="../_inc/Hd.asp"-->

		<div class="afms-sec-breadcrumb">
			<ul>
				<li><a href="" class="afms-ic_home"></a> <span class="afms-ic_next"></span></li>
				<li><a href="">DMS</a> <span class="afms-ic_next"></span></li>
				<li>การวิเคราะห์ข้อมูล <span class="afms-ic_next"></span></li>
                <li>ตรวจสอบการใช้ความถี่</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../DMS/Menu.asp"-->
			

			<div class="col-md-12">
				<div class="afms-content">
					<div class="afms-page-title">
						รายงานตรวจสอบพบความถี่
					</div>
                     <%if(tbH!=null){ %>
					<div class="print-content">
						<div class="afms-filter-table">
							<div class="col-md-5">ผลการตรวจสอบพบ : <%=tbH.Rows[0]["nTotal"] %> รายการ (Event)</div>
							<!--div class="col-md-4 text-right text-bold">แสดงข้อมูล :</div>
							<div class="col-md-3">
								<div class="afms-field afms-field_select">
									<select>
										<option>ทั้งหมด</option>
										<option>Option 2</option>
										<option>Option 3</option>
										<option>Option 4</option>
										<option>Option 5</option>
									</select>
								</div>
							</div-->
						</div>
                         <%if (tbD.Rows.Count > 0)
                           { %>
						<div class="col-md-12">
                        
							<div class="afms-sec-table">
								<table class="table table-condensed text-center afms-table-responsive">
									<thead>
										<tr>
											<th style="width: 60px">ลำดับ</th>
											<th>Scanner</th>
											<th>วัน-เวลา ที่ตรวจพบ</th>
											<th>ความถี่ (MHz)</th>
                                            <th>ความแรงสัญญาณ(dBm)</th>
											<th>ผู้ครอบครองความถี่</th>
										</tr>
									</thead>
									<tbody>
                                        <%for(int i=0;i<tbD.Rows.Count;i++) {%>
										<tr>
											<td data-th="ลำดับ"><%=GetNo(i) %></td>
											<td data-th="Scanner"><%=tbD.Rows[i]["Station"] %></td>
											<td data-th="วัน-เวลา ที่ตรวจพบ"><%=string.Format("{0:dd/MM/yyyy HH:mm}",tbD.Rows[i]["Dt"]) %></td>
											<td data-th="ความถี่ (MHz)"><%=string.Format("{0:0.00}",tbD.Rows[i]["Freq"]) %></td>
											<td data-th="ความแรงสัญญาณ(dBm)"><%=string.Format("{0:0.00}",tbD.Rows[i]["Signal"]) %></td>
											<td data-th="ผู้ครอบครองความถี่"><%=tbD.Rows[i]["HostName"] %></td>
										</tr>
									    <%} %>
									</tbody>
								</table>
							</div>
                            
						</div>

						<!--#include file="../_inc/Page.asp"-->
						
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

						<%} %>
					</div>

                    <%} %>
				</div>
			</div>
		</div>
        

		<div class="afms-push"></div>
	</div>

	<!--#include file="../_inc/Ft.asp"-->
</body>

</html>
