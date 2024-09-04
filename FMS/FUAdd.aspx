<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FUAdd.aspx.cs" Inherits="AFMProj.FMS.FUAdd" %>
<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
     <script language=javascript>
        $(function(){
            $("a[rel=FSch]").addClass("is-active");
            setTimeout(function () { 
                setPageFno();
                //loadItem(1);
                loadItemStn();
            },300);
        });
         function loadItem(a) {
             $("#HDet").load("data/dHDet.ashx?hid=" + $("#HID").val());
             if (!a)
                 ValidatorValidate(window.rHID);
         }

         function loadItemStn(del) {
             if (del)
                 del = "&StnID=" + del;
             loadItemData("DivStn", "data/dFStn.ashx?FuID=<%=Request["FuID"] %>&Tmpkey=" + $("#TmpKey").val() + "&r=" + rid(), del);
         }

         function editItemStn(itemID, fno) {
             openDialog("mFDBStn.aspx?FuID=<%=Request["FuID"] %>&TmpKey=" + $("#TmpKey").val() + "&StnID=" + itemID + "&r=" + rid() + (fno ? "" : "&fno=add"));
         }
         function loadItemData(div, url, del) {
             if (_fno != "add" && _fno != "edit")
                 url += "&det=1";
             if (del) {
                 url += del;
                 swal({
                     title: 'ต้องการลบข้อมูลนี้',
                     text: "หากลบแล้วจะไม่สามารถกู้คืนได้",
                     type: 'warning',
                     showCancelButton: true,
                     cancelButtonClass: 'btn btn-outline-secondary',
                     cancelButtonText: 'ยกเลิก',
                     confirmButtonClass: 'btn btn-primary',
                     confirmButtonText: 'ลบ',
                     focusConfirm: false,
                     reverseButtons: true
                 }).then(function (result) {
                     if (result.value) {
                         loadItemData2(div, url);
                     }
                 }
                 );
             }
             else {
                 loadItemData2(div, url);
             }
         }

         function loadItemData2(div, url) {
             // window.open(url);
             $("#" + div).load(url, {},
                 function () {

                 });
         }

         var _fno = '';
         function setPageFno() {
             if (_fno != "add" && _fno != "edit") {
                 $(".x-det").show();
                 $(".x-add").hide();
                 //$(".mrta-title span").html("");
                 $(".form-group").each(function () {
                     var f = $(this);
                     var t = "";
                     //if(f.find("select").prop("id")) alert(f.html());

                     if (f.find("textarea").prop("id")) { t = f.find("textarea").val(); f.find("textarea").hide(); }
                     else if (f.find("input").prop("id") && f.find("input").prop("type") == "text") { t = f.find("input").val(); f.find("input").hide(); }
                     else if (f.find("select").prop("id")) {
                         t = f.find("select option:selected").text(); f.find(".bootstrap-select").hide();
                         f.find("select").removeClass("selectpicker");
                         f.find("select").hide();
                     }

                     if (t == "(กรุณาเลือก)") t = "";
                     if (t == "กรุณาเลือก") t = "";
                     t = t.replace("กรุณาเลือก", "");
                     f.append('<p>' + t + '&nbsp;</p>');


                 });
                 $("input[type=checkbox]").attr("onclick", "return false");
                 $("input[type=radio]").attr("onclick", "return false");

             } else {
                 $(".x-add").show();
                 $(".x-det").hide();
                 // $(".mrta-title span").html(_fno == "edit"?"แก้ไขข้อมูล":"เพิ่มข้อมูล");
             }
             //setIsAdd();
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
				<li>ฐานข้อมูลความถี่</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../FMS/Menu.asp"-->
			
               <form id=Form1 runat=server method="post">
		
			<div class="col-md-12">
				<div class="afms-content content-readonly">
					<div class="afms-page-title is-online">
						ฐานข้อมูลการจัดสรรคลื่นความถี่
					</div>
					
					<div class="row">
						<div class="col-md-12">
							<h5 class="title-form" style="margin-top: 0"><i class="afms-ic_play"></i> รายละเอียดย่านความถี่</h5>
						</div>
						 <div class="row">
                            <div class="col-12 col-md-6 col-lg-3">
                                <div class="afms-field afms-field_select">
                                    <label>ย่านความถี่</label><br />
                                    <asp:Label ID="FBand" runat="server"></asp:Label>
                                </div>
                            </div>

                            <div class="col-12 col-md-6 col-lg-3">
                                <div class="afms-field afms-field_select">
                                    <label>ย่านความถี่ (MHz)</label><br />
                                    <asp:Label ID="FBand2" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="col-12 col-md-6 col-lg-3">
                                <div class="afms-field afms-field_select">
                                    <label>ความถี่รับ (MHz)</label><br />
                                    <asp:Label ID="FMHz" runat="server"></asp:Label>
                                 </div>
                            </div>
                            <div class="col-12 col-md-6 col-lg-3">
                                <div class="afms-field afms-field_select">
                                    <label>ความถี่ส่ง (MHz)</label><br />
                                    <asp:Label ID="FMHz2" runat="server"></asp:Label>
                                </div>
                            </div>

                            <div class="col-12 col-md-6 col-lg-3">
                                <div class="afms-field afms-field_select">
                                    <label>BandWidth (kHz)</label><br />
                                    <asp:Label ID="BandWidth" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>
					</div>

					<div class="row">
						<div class="col-md-12">
							<h5 class="title-form"><i class="afms-ic_play"></i> รายละเอียดผู้ใช้คลื่นความถี่</h5>
						</div>
                        <input type=hidden id=HID runat=server />
                        <div id=HDet>
						
                        </div>
					

					
					</div>
                    <%if(Grp=="2"){ %>
                        <div class="row">
                            <div class="col-12 col-md-6 col-lg-6">
                                <div class="form-group">
                                    <label>ผู้ให้ใช้คลื่นความถี่ร่วม</label>
                                    <select id="HID2" runat="server" class="selectpicker" data-live-search="true">
                                        <option value="">ตัวเลือก</option>
                                        <option value="">ตัวเลือก</option>
                                        <option value="">ตัวเลือก</option>
                                        <option value="">ตัวเลือก</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <%} %>

                    <div class="row">
                            <div class="col-12 col-md-6 col-lg-6">
                                <div class="form-group afms-field afms-field_select">
                                    <label>กิจการวิทยุคมนาคม</label>
                                    <select id="ActivityID" runat="server" class="selectpicker" data-live-search="true">
                                        <option value="">ตัวเลือก</option>
                                        <option value="">ตัวเลือก</option>
                                        <option value="">ตัวเลือก</option>
                                        <option value="">ตัวเลือก</option>
                                    </select>
                                </div>
                            </div>

                            <div class="col-12 col-md-6 col-lg-6">
                                <div class="form-group afms-field afms-field_select">
                                    <label>การนำไปใช้งาน</label>
                                    <select id="UsesID" runat="server" class="selectpicker" data-live-search="true">
                                        <option value="">ตัวเลือก</option>
                                        <option value="">ตัวเลือก</option>
                                        <option value="">ตัวเลือก</option>
                                        <option value="">ตัวเลือก</option>
                                    </select>
                                </div>
                            </div>
                            </div>
                    <div class="row">
                            <div class="col-12 col-md-6 col-lg-4">
                                <div class="form-group afms-field afms-field_select">
                                    <label>ค่าตอบแทนคลื่นความถี่</label>
                                    <input type="text" id="Fee" runat="server" class="form-control">
                                </div>
                            </div>
                            <div class="col-12 col-md-6 col-lg-6">
                                <div class="form-group afms-field afms-field_select">
                                    <label>มติที่ประชุม/FON</label>
                                    <input type="text" id="Fon" runat="server" class="form-control">
                                </div>
                            </div>
                            <div class="col-12 col-md-6 col-lg-3">
                                <div class="form-group afms-field afms-field_select">
                                    <label>หนังสืออนุญาตที่</label>
                                    <input type="text" id="LicNo" runat="server" class="form-control">
                                </div>
                            </div>
                            <div class="col-12 col-md-6 col-lg-3">
                                <div class="form-group afms-field afms-field_select">
                                    <label>วันที่อนุญาต</label>
                                    <div class="form-datepicker x-add">
                                     <input id="DtIssu" type="text" runat="server" class="form-control datepicker">
                                   </div>
                                </div>
                            </div>
                            <div class="col-12 col-md-6 col-lg-3">
                                <div class="form-group afms-field afms-field_select">
                                    <label>สิ้นสุดการอนุญาต</label>
                                     <div class="form-datepicker x-add">
                                    <input id="DtExp" type="text" runat="server" class="form-control datepicker">
                                         </div>
                                </div>
                            </div>
                            <div class="col-12 col-md-6 col-lg-3">
                                <div class="form-group afms-field afms-field_select">
                                    <label>ระยะเวลาการอนุญาต</label>
                                    <select id="Yr" runat="server" class="selectpicker">
                                        <option value="">กรุณาเลือก</option>
                                        <option value="5 ปี">5 ปี</option>
                                        <option value="6 เดือน">6 เดือน</option>
                                    </select>
                                    <input id="Yrx" type="hidden" runat="server" class="form-control">
                                </div>
                            </div>
                            <div class="col-12 col-md-6 col-lg-4">
                                <div class="form-group afms-field afms-field_select">
                                    <label>เตือนให้ขอขยายเวลาใช้ความถี่ล่าสุด</label>
                                     <div class="form-datepicker x-add">
                                    <input id="DtNF" type="text" runat="server" class="form-control datepicker">
                                         </div>
                                </div>
                            </div>
                            <div class="col-12 col-md-6 col-lg-3">
                                <div class="form-group afms-field afms-field_select">
                                    <label>รายงานล่าสุด</label>
                                     <div class="form-datepicker x-add">
                                    <input id="DtRep" type="text" runat="server" class="form-control datepicker">
                                         </div>
                                </div>
                            </div>
                            <div class="col-12 col-md-6 col-lg-3">
                                <div class="form-group afms-field afms-field_select">
                                    <label>สถานะปัจจุบัน</label>
                                    <select id="Status" runat="server" class="selectpicker">
                                        <option value="">กรุณาเลือก</option>
                                        <option value="A">ใช้</option>
                                        <option value="E">สิ้นสุด</option>
                                        <option value="C">ยกเลิก</option>
                                        <option value="X">สงวน</option>
                                         <option value="R">ขอคืน</option>
                                         <option value="W">รอการ Update</option>
                                    </select>
                                </div>
                            </div>
                        </div>


                    <div class="row">
						<div class="col-md-12">
							<h5 class="title-form" style="margin-top: 0"><i class="afms-ic_play"></i> รายละเอียดการใช้งาน</h5>
						</div>

                        <div class="col-md-12 afms-sec-table" style="overflow-x:auto">
                  		  <div id="DivStn">
                                </div>
                            </div>
                        <div style="text-align:center">
                        <a href='javascript:editItemStn(0,"")' class="IsFMSEdit afms-btn afms-btn-secondary"><i class="afms-ic_edit"></i>เพิ่ม</a>
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

