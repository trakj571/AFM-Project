<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="History.aspx.cs" Inherits="EBMSMap.Web.Admin.History" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <!--#include file="../_inc/title.A.asp"-->
    <script language=javascript>
        function SchLogs() {
            location = "History.aspx?u=" + $("#Users").val() + "&fdt=" + $("#FrmDt").val() + "&tdt=" + $("#ToDt").val() + "&act=" + $("#Action").val() +
            "&ugid=" + $("#UGrp").val() + "&orgid=" + $("#Org").val();
        }
        function exportLogs() {
            window.open("HistoryExp.aspx" + location.search);

        }
    </script>

    
</head>
<body class="nbtc-admin">
	<div class="nbtc-container">
		<!--#include file="../_inc/hd.A.asp"-->

		<div class="nbtc-sec-breadcrumb">
			<ul>
				<li><a href="#"><i class="nbtc-ic_home"></i></a> <i class="nbtc-ic_next"></i></li>
				<li><a href="#">Admin Tools</a> <i class="nbtc-ic_next"></i></li>
				<li>History</li>
			</ul>
            <!--#include file="../_inc/Usr.asp"-->
		</div>

		<div class="nbtc-col">
			
			<div class="nbtc-sec-center">
				<div class="nbtc-sec-content nbtc-col4 nbtc-sec-search">
					<h2>ค้นหาประวัติการใช้งาน</h2>
					<div class="nbtc-row">
						<div class="nbtc-col3">
							<div class="nbtc-field nbtc-field_datepicker">
								<input type="text" id="FrmDt" runat=server placeholder="DD/MM/YYYY">
								<span class="bar"></span>
								<label>จาก</label>
								<i class="nbtc-ic_calendar"></i>
							</div>
						</div>

						<div class="nbtc-col3">
							<div class="nbtc-field nbtc-field_datepicker">
								<input type="text"  id="ToDt" runat=server placeholder="DD/MM/YYYY">
								<span class="bar"></span>
								<label>ถึง</label>
								<i class="nbtc-ic_calendar"></i>
							</div>
						</div>

						<div class="nbtc-col3">
							<div class="nbtc-field nbtc-field_select">
								<select id="Users" runat=server>
                                    <option value="0">=== ทั้งหมด ===</option>
                                </select>
								<span class="bar"></span>
								<label>ผู้ใช้</label>
							</div>
						</div>

						<div class="clear"></div>
					</div>
					<div class="nbtc-row">
						<div class="nbtc-col3">
							<div class="nbtc-field nbtc-field_select">
								 <select id="Action" runat=server>
                                    <option value="">=== ทั้งหมด ===</option>
                                    <option value="L">Login</option>
				                    <option value="A">Add</option>
                                    <option value="U">Edit</option>
                                    <option value="D">Delete</option>
		                        </select>
								<span class="bar"></span>
								<label>ระบบงาน</label>
							</div>
						</div>

						<div class="nbtc-col3">
							<div class="nbtc-field nbtc-field_select">
								<select id="UGrp" runat=server></select>
								<span class="bar"></span>
								<label>กลุ่ม</label>
							</div>
						</div>

                        <div class="nbtc-col3">
							<div class="nbtc-field nbtc-field_select">
								<select id="Org" runat=server></select>
								<span class="bar"></span>
								<label>หน่วยงาน</label>
							</div>
						</div>

						<div class="clear"></div>
					</div>

					<a href="javascript:SchLogs()" class="nbtc-btn nbtc-btn-primary">ค้นหา</a>
				</div>

                <%
                if (tbH != null)
                {
                %>
				<div class="nbtc-sec-content nbtc-col4 nbtc-sec-searchresult">
					<h2>ผลการค้นหา : <%=tbH.Rows[0]["nTotal"] %></h2>
					<div class="nbtc-sec-table">
						<table class="nbtc-table nbtc-table-responsive" style="min-width: 800px">
							<thead>
								<tr>
									<th style="width: 200px">วัน/เดือน/ปี</th>
									<th>รายละเอียด</th>
									<th>User</th>
									<th>หมายเหตุ</th>
									<th style="width: 150px">IP Address</th>
									<th style="width: 80px">Status</th>
								</tr>
							</thead>
							<tbody>
                            <%for (int i = 0; i < tbB.Rows.Count; i++)
                              { %>
								<tr>
									<td data-th="วัน/เดือน/ปี"><%=string.Format(new System.Globalization.CultureInfo("th-TH"), "{0:dd-MMM-yyyy HH.mm}", tbB.Rows[i]["DtLog"])%></td>
									<td data-th="รายละเอียด"><%=tbB.Rows[i]["Grps"] + " " + tbB.Rows[i]["TBs"] + " " + tbB.Rows[i]["Descr"] %></td>
									<td data-th="User"><%=tbB.Rows[i]["Usr"] %></td>
									<td data-th="ระบบงาน"><%=tbB.Rows[i]["Remark"]%></td>
									<td data-th="IP Address"><%=tbB.Rows[i]["IPAdr"] %></td>
									<td data-th="Status" class="status-offline"></td>
								</tr>
								<%} %>
							</tbody>
						</table>
					</div>
                    <%string pageUrl = EBMSMap.Web.Comm.AppendUrl("History.aspx", "u,fdt,tdt,act,orgid,ugid"); %>
					<!--#include file="../_inc/Page.asp"-->
				</div>
                <%} %>
			</div>
		</div>

	    <div class="push"></div>
	</div>

         <!--#include file="../_Inc/Ft.A.asp"-->


          
</body>
</html>
