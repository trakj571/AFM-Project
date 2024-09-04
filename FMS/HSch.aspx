<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HSch.aspx.cs" Inherits="AFMProj.FMS.HSch" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <style>#FormSch {display:none}</style>
    <script language=javascript>
        $(function () {
            $("a[rel=HSch]").addClass("is-active");
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
				<li><a href="">FMS</a> <span class="afms-ic_next"></span></li>
				<li>ฐานข้อมูลผู้ได้รับการจัดสรรคลื่นความถี่</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../FMS/Menu.asp"-->
			
			<div class="col-md-12">
                <form id=FormSch runat=server>

				<div class="afms-content">
					<div class="afms-page-title is-online">
						ค้นหาฐานข้อมูลผู้ได้รับการจัดสรรคลื่นความถี่
					</div>
					<button class="afms-btn afms-btn-primary afms-btn-editsearch" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">แก้ไขการค้นหา</button>
					<button class="afms-btn afms-btn-hidesearch" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">ซ่อน</button>

					<div class="collapse" id="searchSection">
						<div class="row">
							<div class="col-md-3">
								<div class="afms-field afms-field_select">
									<label>ย่านความถี่</label>
									<select id=FBand runat=server data-live-search="true">
										<option value="">ทั้งหมด</option>
									<option value="LF">LF</option>
									<option value="MF">MF</option>
									<option value="HF">HF</option>
									<option value="VHF">VHF</option>
									<option value="UHF">UHF</option>
                                    <option value="SHF">SHF</option>
									</select>
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-3">
								<div class="afms-field afms-field_select">
									<label>คลื่นความถี่ (MHz)</label>
									<input type=text id="FMHz" runat="server" />
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-3">
								<div class="afms-field afms-field_select">
									<label>คู่คลื่นความถี่ (MHz)</label>
									<input type=text id="FMHz2" runat="server" />
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-3">
                                <div class="afms-field afms-field_input">
                                    <label>เลขที่ผู้เสียภาษี</label>
									<input type=text id="TaxID" runat="server" placeholder="13 หลัก" maxlength="13" />
									<span class="bar"></span>
                                </div>
                            </div>
						</div>
						<div class="row">
							<div class="col-md-4"  style='display:none'>
								<div class="afms-field afms-field_datepicker">
									<label>วันที่อนุญาต</label>
									<input id=DtIssu runat=server type="text" name="" placeholder="00/00/0000">
									<span class="bar"></span>
									<i class="afms-ic_date"></i>
								</div>
							</div>
							<div class="col-md-4"  style='display:none'>
								<div class="afms-field afms-field_datepicker">
									<label>วันสิ้นสุดการอนุญาต</label>
									<input id=DtExp runat=server type="text" name="" placeholder="00/00/0000">
									<span class="bar"></span>
									<i class="afms-ic_date"></i>
								</div>
							</div>
							<div class="col-md-6">
								<div class="afms-field afms-field_input">
									<label>ผู้ใช้คลื่นความถี่</label>
									<input id=Name runat=server type="text">
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-6">
								<div class="afms-field afms-field_input">
									<label>รายละเอียดเพิ่มเติม</label>
									<input id=Detail runat=server type="text">
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-6">
								<div class="afms-field afms-field_select">
									<label>กิจกรรม</label>
									<select id=ActivityID runat=server data-live-search="true">
										<option>Option 1</option>
										<option>Option 2</option>
										<option>Option 3</option>
										<option>Option 4</option>
										<option>Option 5</option>
									</select>
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-6">
								<div class="afms-field afms-field_select">
									<label>การนำไปใช้</label>
									<select id=UsesID runat=server data-live-search="true">
										<option>Option 1</option>
										<option>Option 2</option>
										<option>Option 3</option>
										<option>Option 4</option>
										<option>Option 5</option>
									</select>
									<span class="bar"></span>
								</div>
							</div>
							<div class="col-md-12 text-center">
								<button onclick="schData()" class="afms-btn afms-btn-primary" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection"><i class="afms-ic_search"></i> ค้นหา</button>
							</div>
						</div>
					</div>
				</div>
                </form>
                <%if(tbH!=null){ %>
				<div class="afms-content print-content" style="margin-top: 20px;">
					ผลการค้นหา : <%=tbH.Rows[0]["nTotal"] %> รายการ
                      <%if(tbD.Rows.Count>0){ %>
					<div class="afms-sec-table">
						<table class="table table-condensed text-center afms-table-responsive" style="min-width: 1100px">
							<thead>
								<tr>
									<th style="width: 60px">ลำดับ</th>
									<th>ชื่อหน่วยงาน</th>
									<th>ที่อยู่</th>
									<th style="width: 100px">เบอร์ติดต่อ</th>
									<th>กิจการวิทยุคมนาคม</th>
									<th>การนำไปใช้งาน</th>
									<th  class='no-print-page' style="width: 100px"></th>
								</tr>
							</thead>
							<tbody>
                            <%for(int i=0;i<tbD.Rows.Count;i++){ %>
								<tr>
									<td data-th="ลำดับ"><%=GetNo(i) %></td>
									<td data-th="ชื่อหน่วยงาน"><%=tbD.Rows[i]["Name"] %></td>
									<td data-th="ที่อยู่"><%=tbD.Rows[i]["AdrNo"] %> <%=tbD.Rows[i]["Road"] %> <%=tbD.Rows[i]["Tambol"] %> <%=tbD.Rows[i]["Amphoe"] %> <%=tbD.Rows[i]["Province"] %></td>
									<td data-th="เบอร์ติดต่อ"><%=tbD.Rows[i]["Telno"] %></td>
									<td data-th="กิจการวิทยุคมนาคม"><%=tbD.Rows[i]["Activity"] %></td>
									<td data-th="การนำไปใช้งาน"><%=tbD.Rows[i]["Uses"] %></td>
									<td class='no-print-page'>
										<a class="afms-btn afms-ic_view"  href='HDet.aspx<%=getDetURL("hid="+tbD.Rows[i]["Hid"]) %>'></a>
										<!--<a class="IsFMSEdit afms-btn afms-ic_edit" href='HAdd.aspx?hid=<%=tbD.Rows[i]["Hid"] %>'></a>
										<a class="IsFMSEdit afms-btn afms-ic_delete" href="javascript:delItem('fms.spHostAdd','HID','<%=tbD.Rows[i]["Hid"] %>',1)"></a>-->
									</td>
								</tr>
								<%} %>
							</tbody>
						</table>
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
					<%} %>
				</div>
			</div>

            
		</div>

		<div class="afms-push"></div>
	</div>

	<!--#include file="../_inc/Ft.asp"-->
</body>

</html>
