<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FDet.aspx.cs" Inherits="AFMProj.FMS.FDet" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
      <script language=javascript src="../_inc/js/dpv2.js"></script>
    <script language=javascript src="../_inc/js/pvscp2.js"></script>
   
    <script language=javascript>
        $(function(){
            $("a[rel=FSch]").addClass("is-active");

            loadItem();
             //$('.afms-field_select select').selectpicker();
             msgbox_save(<%=retID %>,"FDet.aspx?fdid=<%=retID %>");
        });

        function openHost(){
            openDialog("HSchDialog.aspx");
        }
        function loadItem(){
           // window.open("data/dHDet.ashx?hid="+$("#HID").val());
            $("#HDet").load("data/dHDet.ashx?hid="+$("#HID").val());
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
				<li>ฐานข้อมูลการจัดสรรคลื่นความถี่</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../FMS/Menu.asp"-->
			
               <form id=Form1 runat=server method=post>
		
			<div class="col-md-12">
				<div class="afms-content content-readonly print-content">
					<div class="afms-page-title is-online">
						ฐานข้อมูลการจัดสรรคลื่นความถี่
					</div>
					
					<div class="row">
						<div class="col-md-12">
							<h5 class="title-form" style="margin-top: 0"><i class="afms-ic_play"></i> รายละเอียดย่านความถี่</h5>
						</div>
						<div class="col-md-3">
							<div class="afms-field afms-field_select">
                                <p class="afms-field-title">ความถี่ย่าน</p>
							    <p><asp:label id=FBand runat=server></asp:label></p>

							</div>
						</div>
						<div class="col-md-3">
							<div class="afms-field afms-field_select">
								<p class="afms-field-title">ย่านความถี่</p>
							    <p><asp:label id=FBand2 runat=server></asp:label></p>
                                
							</div>
						</div>
						<div class="col-md-3">
							<div class="afms-field afms-field_select">
                                <p class="afms-field-title">คลื่นความถี่ (MHz)</p>
							    <p><asp:label id=FMHz runat=server></asp:label></p>

							</div>
						</div>
						<div class="col-md-3">
							<div class="afms-field afms-field_select">
								<p class="afms-field-title">คู่คลื่นความถี่ (MHz)</p>
							    <p><asp:label id=FMHz2 runat=server></asp:label></p>
							</div>
						</div>
						<div class="col-md-3">
							<div class="afms-field afms-field_select">
                                <p class="afms-field-title">Brandwidth (kHz)</p>
							    <p><asp:label id=BandWidth runat=server></asp:label></p>
								
							</div>
						</div>
                        <div class="col-md-3">
                                  <div class="afms-field afms-field_checkbox">
                                            <label style="margin-top:0px!important;font-weight:bold">
                                                <input type="checkbox" id="IsRange" runat="server" disabled="disabled" />
                                                <div class="box"></div>
                                                <div class="check afms-ic_check"></div>
                                                ช่วงความถี่
                                            </label>
                                        </div>
                            </div>
                        
                        <div class="col-md-3" id="divChSp" runat="server">
							<div class="afms-field afms-field_select">
                                <p class="afms-field-title">Channel Space (kHz)</p>
							    <p><asp:label id=ChSp runat=server></asp:label></p>
								
							</div>
						</div>
					</div>

					<div class="row" style="display:none">
						<div class="col-md-12">
							<h5 class="title-form"><i class="afms-ic_play"></i>รายละเอียดผู้ให้ใช้คลื่นความถี่</h5>
						</div>
                        <input type=hidden id=HID runat=server />
                        <div id=HDet>
						
                        </div>
						
                        
						
					</div>
					<div class="row">
						<div class="col-md-12">
							<h5 class="title-form"><i class="afms-ic_play"></i>ผู้ใช้คลื่นความถี่</h5>
						</div>
                        
						<div class="col-md-12 afms-sec-table" style="overflow-x:auto">
                  		<table class="table table-condensed text-center afms-table-responsive">
						
                        <thead>
                            <tr>
                                <th scope="col" class="text-center" style="width: 60px">ลำดับ</th>
                                <th scope="col">ผู้ใช้คลื่นความถี่</th>
                                <th scope="col">กิจการวิทยุคมนาคม</th>
                                <th scope="col">การนำไปใช้งาน</th>
                                <th scope="col">ระยะเวลาอนุญาต</th>
                                <th scope="col">วันที่อนุญาต</th>
                                <th scope="col">วันที่สิ้นสุดการอนุญาต</th>
                                <th scope="col">เตือนให้ขอขยายเวลาใช้ความถี่ล่าสุด</th>
                                 <th scope="col">ค่าตอบแทนคลื่นความถี่</th>
                                <th scope="col">รายงานล่าสุด</th>
                                <th scope="col">มติที่ประชุม/FON</th>
                                <th scope="col">หนังสืออนุญาตที่</th>
                                <th scope="col">สถานะปัจจุบัน</th>
                                <th scope="col" class="text-center">ข้อมูล</th>
                                
                            </tr>
                        </thead>
                        <tbody>
                            <% int cnt = 1;
								for (int i = 0; tbD!=null && i < tbD.Rows.Count; i++)
                            { if (tbD.Rows[i]["Grp"].ToString() != "1") continue;%>
                            <tr>
                                <td data-title="ลำดับ" class="text-center"><%=(cnt++)%></td>
                                <td data-title="ผู้ใช้คลื่นความถี่" class="text-center"><%=tbD.Rows[i]["Name1"] %></td>
                               <td data-title="กิจการวิทยุคมนาคม" class="text-center"><%=tbD.Rows[i]["Activity"] %></td>
                                <td data-title="การนำไปใช้งาน" class="text-center"><%=tbD.Rows[i]["Uses"] %></td>
                                <td data-title="ระยะเวลาอนุญาต" class="text-center"><%=tbD.Rows[i]["Yr"] %></td>
                                <td data-title="วันที่อนุญาต" class="text-center"><%=string.Format("{0:dd/MM/yyyy}",tbD.Rows[i]["DtIssu"]) %></td>
                                <td data-title="วันที่สิ้นสุดการอนุญาต" class="text-center"><%=string.Format("{0:dd/MM/yyyy}",tbD.Rows[i]["DtExp"]) %></td>
                                <td data-title="เตือนให้ขอขยายเวลาใช้ความถี่ล่าสุด" class="text-center"><%=string.Format("{0:dd/MM/yyyy}",tbD.Rows[i]["DtNF"]) %></td>
                                <td data-title="ค่าตอบแทนคลื่นความถี่" class="text-center"><%=string.Format("{0:0.00}",tbD.Rows[i]["Fee"]) %></td>
                                <td data-title="รายงานล่าสุด" class="text-center"><%=string.Format("{0:dd/MM/yyyy}",tbD.Rows[i]["DtRep"]) %></td>
                                <td data-title="มติที่ประชุม/FON" class="text-center"><%=tbD.Rows[i]["FON"] %></td>
                                <td data-title="หนังสืออนุญาตที่" class="text-center"><%=tbD.Rows[i]["LicNo"] %></td>
                                <td data-title="สถานะปัจจุบัน" class="text-center"><%=tbD.Rows[i]["StatusText"] %></td>
                                <td data-title="" class="text-center">
                                    <a class="afms-btn afms-ic_view" target="_blank" href='FUAdd.aspx?fdid=<%=Request["Fdid"] %>&fuid=<%=tbD.Rows[i]["fuid"] %>'></a>

                                </td>
                            </tr>
                            <%} %>
                            <tr>
                                <td>&nbsp;</td>
                                <td colspan="20"></td>
                               
                            </tr>
                        </tbody>
                    </table>
						</div>
						</div>
                        
						<div class="row">
						<div class="col-md-12">
							<h5 class="title-form"><i class="afms-ic_play"></i>ผู้ขอใช้คลื่นความถี่ร่วม</h5>
						</div>
                        
						<div class="col-md-12 afms-sec-table" style="overflow-x:auto">
                  		<table class="table table-condensed text-center afms-table-responsive">
						
                        <thead>
                            <tr>
                                <th scope="col" class="text-center" style="width: 60px">ลำดับ</th>
                                <th scope="col">ผู้ใช้คลื่นความถี่</th>
                                <th scope="col">ผู้ให้ใช้คลื่นความถี่ร่วม</th>
                                <th scope="col">กิจการวิทยุคมนาคม</th>
                                <th scope="col">การนำไปใช้งาน</th>
                                <th scope="col">ระยะเวลาอนุญาต</th>
                                <th scope="col">วันที่อนุญาต</th>
                                <th scope="col">วันที่สิ้นสุดการอนุญาต</th>
                                <th scope="col">เตือนให้ขอขยายเวลาใช้ความถี่ล่าสุด</th>
                                 <th scope="col">ค่าตอบแทนคลื่นความถี่</th>
                                <th scope="col">รายงานล่าสุด</th>
                                <th scope="col">มติที่ประชุม/FON</th>
                                 <th scope="col">หนังสืออนุญาตที่</th>
                                <th scope="col">สถานะปัจจุบัน</th>
                                <th scope="col" class="text-center">ข้อมูล</th>
                                
                            </tr>
                        </thead>
                        <tbody>
                            <%  cnt = 1;
								for (int i = 0; tbD!=null && i < tbD.Rows.Count; i++)
                            { if (tbD.Rows[i]["Grp"].ToString() != "2") continue;%>
                            <tr>
                                <td data-title="ลำดับ" class="text-center"><%=(cnt++)%></td>
                                <td data-title="ผู้ใช้คลื่นความถี่" class="text-center"><%=tbD.Rows[i]["Name1"] %></td>
                                    <td data-title="ผู้ให้ใช้คลื่นความถี่ร่วม" class="text-center"><%=tbD.Rows[i]["Name2"] %></td>
                            <td data-title="กิจการวิทยุคมนาคม" class="text-center"><%=tbD.Rows[i]["Activity"] %></td>
                                <td data-title="การนำไปใช้งาน" class="text-center"><%=tbD.Rows[i]["Uses"] %></td>
                                <td data-title="ระยะเวลาอนุญาต" class="text-center"><%=tbD.Rows[i]["Yr"] %></td>
                                <td data-title="วันที่อนุญาต" class="text-center"><%=string.Format("{0:dd/MM/yyyy}",tbD.Rows[i]["DtIssu"]) %></td>
                                <td data-title="วันที่สิ้นสุดการอนุญาต" class="text-center"><%=string.Format("{0:dd/MM/yyyy}",tbD.Rows[i]["DtExp"]) %></td>
                                <td data-title="เตือนให้ขอขยายเวลาใช้ความถี่ล่าสุด" class="text-center"><%=string.Format("{0:dd/MM/yyyy}",tbD.Rows[i]["DtNF"]) %></td>
                                <td data-title="ค่าตอบแทนคลื่นความถี่" class="text-center"><%=string.Format("{0:0.00}",tbD.Rows[i]["Fee"]) %></td>
                                <td data-title="รายงานล่าสุด" class="text-center"><%=string.Format("{0:dd/MM/yyyy}",tbD.Rows[i]["DtRep"]) %></td>
                                <td data-title="มติที่ประชุม/FON" class="text-center"><%=tbD.Rows[i]["FON"] %></td>
                                <td data-title="หนังสืออนุญาตที่" class="text-center"><%=tbD.Rows[i]["LicNo"] %></td>
                                <td data-title="สถานะปัจจุบัน" class="text-center"><%=tbD.Rows[i]["StatusText"] %></td>
                                <td data-title="" class="text-center">
                                    <a class="afms-btn afms-ic_view" target="_blank" href='FUAdd.aspx?fdid=<%=Request["Fdid"] %>&fuid=<%=tbD.Rows[i]["fuid"] %>'></a>

                                </td>
                            </tr>
                            <%} %>
                            <tr>
                                <td>&nbsp;</td>
                                <td colspan="20"></td>
                               
                            </tr>
                        </tbody>
                    </table>
						</div>
						</div>
				

					<div class="row no-print-page">
						<div class="col-md-12">
							<div class="afms-group-btn text-center">
						      <a href='FSch.aspx<%=getBackURL("fdid") %>' class="afms-btn afms-btn-secondary"><i class="afms-ic_back"></i>กลับ</a>
						       <a href="javascript:exportXls()" class="afms-btn afms-btn-secondary"><i class="afms-ic_download"></i>Export</a>
                               <a href="javascript:exportPrint()" class="afms-btn afms-btn-secondary"><i class="afms-ic_print"></i>พิมพ์</a>
					      	
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