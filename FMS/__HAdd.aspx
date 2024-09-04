<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="__HAdd.aspx.cs" Inherits="AFMProj.FMS.HAdd" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <script language=javascript src="../_inc/js/dpv2.js"></script>
    <script language=javascript src="../_inc/js/pvscp2.js"></script>
   
    <script language=javascript>
        $(function(){
            $("a[rel=HAdd]").addClass("is-active");
            //$('.afms-field_select select').selectpicker();
            setProv2('sProv2', '<%=PATCode.Substring(0,2) %>');
            setAumphur2('sAumphur2', '<%=PATCode.Substring(0,2) %>', '<%=PATCode.Substring(0,4) %>');
            setTumbon2('sTumbon2', '<%=PATCode.Substring(0,4) %>', '<%=PATCode.Substring(0,6) %>');

             //$('.afms-field_select select').selectpicker();
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
				<li>ฐานข้อมูลผู้ครอบครอง</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../FMS/Menu.asp"-->
			
            <form id=Form1 runat=server method=post>
			<div class="col-md-12">
				<div class="afms-content">
					<div class="afms-page-title">
						เพิ่มฐานข้อมูลผู้ครอบครอง
					</div>
					<button class="afms-btn afms-btn-primary afms-btn-editsearch" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">เพิ่ม</button>
					<button class="afms-btn afms-btn-hidesearch" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">ซ่อน</button>
					<div class="collapse in" id="searchSection">
						<div class="row">
							<div class="col-md-12">
								<div class="afms-field afms-field_input">
									<label>ชื่อหน่วยงาน</label>
									<input id=Name runat=server type="text">
									<span class="bar"></span>
								</div>
                                <div class=valid><asp:RequiredFieldValidator ID=rName ControlToValidate=Name runat=server Display=Dynamic>*</asp:RequiredFieldValidator></div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_input">
									<label>เลขที่</label>
									<input id=AdrNo runat=server type="text">
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_input">
									<label>ถนน</label>
									<input id=Road runat=server type="text">
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_select">
									<label>จังหวัด</label>
									<select id=sProv2  runat=server onchange="setAumphur2('sAumphur2',this.value,'0')" data-live-search="true">
                                        <option value="0">=== เลือก ===</option>
                                    </select>
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_select">
									<label>อำเภอ</label>
									<select id=sAumphur2 runat=server  disabled=disabled onchange="setTumbon2('sTumbon2',this.value,'0')" data-live-search="true">
                                        <option value="0">=== เลือก ===</option>
                                    </select>
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_select">
									<label>ตำบล</label>
									<select id=sTumbon2 runat=server disabled=disabled data-live-search="true">
                                        <option value="0">=== เลือก ===</option>
                                    </select>
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_select">
									<label>รหัสไปรษณีย์</label>
									<input id=PostCode runat=server type="text">
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_input">
									<label>เบอร์โทรติดต่อ</label>
									<input id=TelNo runat=server type="text">
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-4">
                                <div class="afms-field afms-field_input">
                                    <label>เลขที่ผู้เสียภาษี</label>
									<input type=text id="TaxID" runat="server" placeholder="13 หลัก" maxlength="13" />
									<span class="bar"></span>
                                </div>
                            </div>

							<div class="col-md-12 text-center">
								<input type=submit id=bSave runat=server class="afms-btn afms-btn-primary" value="บันทึก" style='width:auto' onserverclick="bSave_ServerClick" />
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
