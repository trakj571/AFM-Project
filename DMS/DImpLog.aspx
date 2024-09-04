<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DImpLog.aspx.cs" Inherits="AFMProj.DMS.DImpLog" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <script language=javascript>
        $(function(){
            $("a[rel=DImpLog]").addClass("is-active");
       
         <%if(tbH!=null){ %>
                $('#searchSection').collapse();
                  $('.afms-btn-editscanning').show();
                  $('.afms-btn-editsearch').show();
                  $('.afms-btn-hidesearch').hide();
                  $('#FormSch').show();
            <%}else{ %>
                $('#FormSch').show();
            <%} %>
         });
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
                <li>Log การนำเข้าข้อมูล</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../DMS/Menu.asp"-->
			 <form id=FormSch runat=server>

			<div class="col-md-12">
				<div class="afms-content">
					<div class="afms-page-title">
						Log การนำเข้าข้อมูล
					</div>
					<button class="afms-btn afms-btn-primary afms-btn-editsearch" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">แก้ไขการค้นหา</button>
					<button class="afms-btn afms-btn-hidesearch" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">ซ่อน</button>

					<div class="collapse in" id="searchSection">
						<div class="row">
							<div class="col-md-3">
								<div class="afms-field afms-field_select">
									<label>สำนักงานเขต</label>
									<select id=LyID runat=server>
                                       
									</select>
									<span class="bar"></span>
								</div>
							</div>
                             <div id="col-DataType" class="col-md-3">
							<div class="afms-field afms-field_select">
								<label>วิธีการนำเข้าข้อมูล</label>
								<select id="ImpType" runat="server">
									<option value="" selected>= ทั้งหมด =</option>
									<option value="F">FTP</option>
									<option value="W">Web Browser</option>
                   
							    </select>
								<span class="bar"></span>
							</div>
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
				 <%if(tbH!=null){ %>
				<div class="afms-content print-content" style="margin-top: 20px;">
                	<div class="row">
						<div class="col-md-12">
				
					    ผลการค้นหา : <%=tbH.Rows[0]["nTotal"] %> รายการ
					  <%if(tbD.Rows.Count>0){ %>
						<div class="afms-sec-table">
							<table class="table table-condensed text-center afms-table-responsive">
								<thead>
									<tr>
										<th style="width: 60px">ลำดับ</th>
										<th>วิธีการนำเข้าข้อมูล</th>
										 <th>ชื่ออุปกรณ์</th>
                                     	<th>วันเวลาในการนำเข้าข้อมูล</th>
										<th>วันเวลาที่ Scan</th>
										<th>ผลการนำเข้า</th>
                                        <th>หมายเหตุ</th>
								</tr>
								</thead>
								<tbody>
                                <%for(int i=0;i<tbD.Rows.Count;i++){ %>
									<tr>
										<td data-th="ลำดับ"><%=GetNo(i) %></td>
									     <td data-th="วิธีการนำเข้าข้อมูล"><%=tbD.Rows[i]["ImpTypeName"] %></td>
                                         <td data-th="ชื่ออุปกรณ์"><%=tbD.Rows[i]["EquName"] %></td>
                                    	<td data-th="วันเวลาในการนำเข้าข้อมูล"><%=string.Format("{0:dd/MM/yyyy HH:mm:ss}",tbD.Rows[i]["DtLog"]) %></td>
										<td data-th="วัวันเวลาที่ Scan"><%=string.Format("{0:dd/MM/yyyy HH:mm:ss}",tbD.Rows[i]["DtBegin"]) %></td>
								        <td data-th="ผลการนำเข้า"><%=tbD.Rows[i]["ResultName"] %></td>
                                        <td data-th="หมายเหตุ"><%=tbD.Rows[i]["Remark"] %></td>

									</tr>
                                    <%} %>
								</tbody>
							</table>
						</div>

                        <!--#include file="../_inc/Page.asp"-->
						
                        
                       
                        <%} %>
                         </div>
					</div>
					<%} %>
                    

						
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
