<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HDet.aspx.cs" Inherits="AFMProj.FMS.HDet" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
     <script language=javascript src="../_inc/js/dpv2.js"></script>
    <script language=javascript src="../_inc/js/pvscp2.js"></script>
   
    <script language=javascript>
        $(function(){
            $("a[rel=HSch]").addClass("is-active");

            setProv2('sProv2', '<%=PATCode.Substring(0,2) %>');
            setAumphur2('sAumphur2', '<%=PATCode.Substring(0,2) %>', '<%=PATCode.Substring(0,4) %>');
            setTumbon2('sTumbon2', '<%=PATCode.Substring(0,4) %>', '<%=PATCode.Substring(0,6) %>');


             msgbox_save(<%=retID %>,"HDet.aspx?hid=<%=retID %>");

        });
    </script>
</head>
<body>
	<div class="afms-sec-container">
		<!--#include file="../_inc/Hd.asp"-->

		<div class="afms-sec-breadcrumb">
			<ul>
				<li><a href="" class="afms-ic_home"></a> <span class="afms-ic_next"></span></li>
				<li><a href="">FMS</a> <span class="afms-ic_next"></span></li>
				<li>ฐานข้อมูลผู้ได้รับการจัดสรรคลื่นความถี่</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../FMS/Menu.asp"-->
			
            <form id=Form1 runat=server method=post>
			<div class="col-md-12">
				<div class="afms-content content-readonly print-content">
					<div class="afms-page-title">
						ข้อมูลผู้ได้รับการจัดสรรคลื่นความถี่
					</div>
					<div class="collapse in tbResult" id="searchSection">
						<div class="row">
							<div class="col-md-12">
								<div class="afms-field afms-field_input">
									<p class="afms-field-title">ชื่อหน่วยงาน</p>
									<p><asp:label id=Name runat=server></asp:label>
								</div>
                          </div>
							<div class="col-md-4">
								<div class="afms-field afms-field_input">
								    <p class="afms-field-title">เลขที่</p>
									<p><asp:label id=AdrNo runat=server></asp:label></p>
								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_input">
									<p class="afms-field-title">ถนน</p>
									<p><asp:label id=Road runat=server></asp:label></p>
								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_select">
                                    <p class="afms-field-title">จังหวัด</p>
									<p><asp:label id=Province runat=server></asp:label></p>

								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_select">
                                <p class="afms-field-title">อำเภอ</p>
									<p><asp:label id=Amphoe runat=server></asp:label></p>
									
								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_select">
                                <p class="afms-field-title">ตำบล</p>
									<p><asp:label id=Tambol runat=server></asp:label></p>
									
								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_select">
                                <p class="afms-field-title">รหัสไปรษณีย์</p>
									<p><asp:label id=PostCode runat=server></asp:label></p>
								
								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_input">
                                <p class="afms-field-title">เบอร์โทรติดต่อ</p>
									<p><asp:label id=TelNo runat=server></asp:label></p>
								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_input">
                                <p class="afms-field-title">เลขที่ผู้เสียภาษี</p>
									<p><asp:label id=TaxID runat=server></asp:label></p>
								</div>
							</div>
							<div class="col-md-12 text-center no-print-page">
                                <a href='HSch.aspx<%=getBackURL("hid") %>' class="afms-btn afms-btn-secondary"><i class="afms-ic_back"></i>กลับ</a>
						        <!--<a href='HAdd.aspx?hid=<%=Request["Hid"] %>' class="IsFMSEdit afms-btn afms-btn-secondary"><i class="afms-ic_edit"></i>แก้ไข</a>
						        <a href="javascript:delItem('fms.spHostAdd','HID','<%=Request["Hid"] %>')" class="IsFMSEdit afms-btn afms-btn-secondary"><i class="afms-ic_delete"></i>ลบ</a>
                                -->
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
