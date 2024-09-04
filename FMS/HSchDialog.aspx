<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HSchDialog.aspx.cs" Inherits="AFMProj.FMS.HSchDialog" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
   <style>/*#FormSch {display:none}*/</style>
    <script language=javascript>
        $(function () {
            <%if(tbH!=null){ %>
                  $('#searchSection').collapse();
                  $('.afms-btn-editscanning').show();
                  $('.afms-btn-editsearch').show();
                  $('.afms-btn-hidesearch').hide();
                   $('#FormSch').show();
            <%}%>
             $('#FormSch').show();
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

        function selItem(id){
            parent.$("#HID").val(id);
            parent.loadItem();
            parent.closeDialog();
        }
    </script>
</head>
<body class="body-no-bg">
	<div class="container">
        <form id=FormSch runat=server>
		<div class=row>

			<div class="col-md-12">
				<div class="afms-content">
					<div class="afms-page-title is-online">
						ค้นหาผู้ใช้คลื่นความถี่
					</div>
                <button class="afms-btn afms-btn-primary afms-btn-editsearch" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">แก้ไขการค้นหา</button>
					<button class="afms-btn afms-btn-hidesearch" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">ซ่อน</button>

				<div class="collapse in" id="searchSection">
					
					<div class="row">
						<div class="col-md-3">
							<div class="afms-field afms-field_input">
								<label>ชื่อ</label>
								<input id=Name runat=server type="text">
								<span class="bar"></span>
							</div>
                            </div>
						<div class="col-md-3">
							<div class="afms-field afms-field_input">
								<label>โทรศัพท์</label>
								<input id=TelNo runat=server type="text">
								<span class="bar"></span>
							</div>
						</div>
						<div class="col-md-3">
							<div class="afms-field afms-field_input">
								<label>เลขที่ผู้เสียภาษี</label>
								<input id=TaxID runat=server type="text">
								<span class="bar"></span>
							</div>
						</div>
						<div class="col-md-12 text-center">
							<a href="javascript:schData()" class="afms-btn afms-btn-primary"><i class="afms-ic_search"></i> ค้นหา</a>
						</div>
					</div>

					</div>
				</div>

				 <%if(tbH!=null){ %>
				<div class="afms-content" style="margin-top: 20px;">
					ผลการค้นหา : <%=tbH.Rows[0]["nTotal"] %> รายการ
                      <%if(tbD.Rows.Count>0){ %>
					<div class="afms-sec-table">
						<table class="table table-condensed text-center afms-table-responsive">
							<thead>
								<tr>
									<th style="width: 60px">ลำดับ</th>
									<th>ชื่อหน่วยงาน</th>
									<th>ที่อยู่</th>
									<th style="width: 100px">เบอร์ติดต่อ</th>
								</tr>
							</thead>
							<tbody>
                            <%for(int i=0;i<tbD.Rows.Count;i++){ %>
								<tr>
									<td data-th="ลำดับ"><%=GetNo(i) %></td>
									<td data-th="ชื่อหน่วยงาน"><a href="javascript:selItem('<%=tbD.Rows[i]["HID"] %>')"><%=tbD.Rows[i]["Name"] %></a></td>
									<td data-th="ที่อยู่"><%=tbD.Rows[i]["AdrNo"] %> <%=tbD.Rows[i]["Road"] %> <%=tbD.Rows[i]["Tambol"] %> <%=tbD.Rows[i]["Amphoe"] %> <%=tbD.Rows[i]["Province"] %></td>
									<td data-th="เบอร์ติดต่อ"><%=tbD.Rows[i]["Telno"] %></td>
								</tr>
								<%} %>
							</tbody>
						</table>
					</div>
                    <!--#include file="../_inc/Page.asp"-->

                        <%} %>
					<%} %>

					
				</div>
			</div>
		</div>
        </form>
		<div class="afms-push"></div>
	</div>
</body>

</html>
