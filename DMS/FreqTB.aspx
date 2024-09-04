<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FreqTB.aspx.cs" Inherits="AFMProj.DMS.FreqTB" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <script language=javascript>
        $(function(){
            $("a[rel=FreqTB]").addClass("is-active");

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

        function editItem(id) {
            openDialog("mFreqtB.aspx?ftid=" + id + "&yr="+$("#Yr").val()+"&r=" + rid());
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
				<li>การวิเคราะห์การครอบครองความถี่ <span class="afms-ic_next"></span></li>
                <li>ตารางการตรวจสอบคลื่นความถี่</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../DMS/Menu.asp"-->
			 <form id=FormSch runat=server>

			<div class="col-md-12">
				<div class="afms-content">
					<div class="afms-page-title">
						ตารางการตรวจสอบคลื่นความถี่
					</div>
					
					<div class="collapse in" id="searchSection">
						<div class="row">
							<div class="col-md-3">
								<div class="afms-field afms-field_select">
									<label>ปี</label>
									<select id=Yr runat=server onchange="schData()">
                                       
									</select>
									<span class="bar"></span>
								</div>
							</div>
                            
                            </div>
                    	</div>
				</div>
				 <%if(tbH!=null){ %>
				<div class="afms-content print-content" style="margin-top: 20px;">
                	<div class="row">
						<div class="col-md-12">

                        <div class="col-md-12 text-right">
								<a href="javascript:editItem('0')" class="afms-btn afms-btn-secondary">
								<i class="afms-ic_plus"></i> เพิ่ม
							</a>
						</div>

                        </div>
                        </div>
                    <div class="row">
						<div class="col-md-12">
                        
					   <%=tbH.Rows[0]["nTotal"] %> รายการ
				     
                     <%if(tbD.Rows.Count>0){ %>

						<div class="afms-sec-table">
							<table class="table table-condensed text-center afms-table-responsive">
								<thead>
									<tr>
										<th style="width: 60px">ลำดับ</th>
										<th>ย่านความถี่เริ่มต้น (MHz)</th>
										 <th>สิ้นสุด (MHz)</th>
                                     	<th>Channel Spacing/BW</th>
										<th>จำนวนช่องความถี่</th>
                                        <th  class='no-print-page' style="width: 100px"></th>
                         		</tr>
								</thead>
								<tbody>
                                <%for(int i=0;i<tbD.Rows.Count;i++){ %>
									<tr>
										<td data-th="ลำดับ"><%=GetNo(i) %></td>
									     <td data-th="ย่านความถี่เริ่มต้น (MHz)"><%=string.Format("{0:0.000}",tbD.Rows[i]["fFreq"]) %></td>
                                         <td data-th="สิ้นสุด (MHz)"><%=string.Format("{0:0.000}",tbD.Rows[i]["tFreq"]) %></td>
                                    	<td data-th="Channel Spacing/BW"><%=string.Format("{0:0.000}",tbD.Rows[i]["ChSp"])%></td>
								        <td data-th="จำนวนช่องความถี่"><%=tbD.Rows[i]["nCh"] %></td>
                                        <td class='no-print-page'>
										<a class="IsDMSEdit afms-btn afms-ic_edit" href="javascript:editItem('<%=tbD.Rows[i]["FtID"] %>')"></a>
										<a class="IsDMSEdit afms-btn afms-ic_delete" href="javascript:delItem('dms.spFreqTBAdd','FtID','<%=tbD.Rows[i]["FtID"] %>',1)"></a>
									</td>
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
