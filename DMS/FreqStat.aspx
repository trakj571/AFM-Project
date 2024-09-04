<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FreqStat.aspx.cs" Inherits="AFMProj.DMS.FreqStat" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <script language=javascript>
        $(function(){
            $("a[rel=FreqStat]").addClass("is-active");
       
         <%if(tbT!=null){ %>
                $('#searchSection').collapse();
                  $('.afms-btn-editscanning').show();
                  $('.afms-btn-editsearch').show();
                  $('.afms-btn-hidesearch').hide();
                  $('#FormSch').show();
            <%}else{ %>
                $('#FormSch').show();
            <%} %>


            $("#Level").change(function(){
                levelChange();
            });
            
            $("#THIDDiv").show();
            levelChange();
         });

         function levelChange(){
             $("#ProvIDDiv").hide();
                $("#LyID2Div").hide();
                $("#LyID1Div").hide();
                $("#THIDDiv").hide();

                var val = $("#Level").val();
                if(val=="1") $("#ProvIDDiv").show();
                else if(val=="2") $("#LyID2Div").show();
                else if(val=="3") $("#LyID1Div").show();
                else if(val=="4") $("#THIDDiv").show();
         }
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

        function viewChart(){
            window.open("FreqStatChart.aspx"+location.search);
        }
         function viewMap(){
            window.open("FreqStatMap.aspx"+location.search);
        }
    </script>
    <style>
        #ProvIDDiv,#LyID2Div,#LyID1Div,#THIDDiv{display:none}
    </style>
     <style>
        .tborder, .tborder th, .tborder td {padding:2px;border:1px double #777}
       .tborder th {background:#eee;text-align:center}
       .u {padding:0 10px 0 10px}
       .u input{text-align:center;border-bottom:1px double #777}
   </style>
</head>
<body>
	<div class="afms-sec-container">
		<!--#include file="../_inc/Hd.asp"-->

		<div class="afms-sec-breadcrumb">
			<ul>
				<li><a href="" class="afms-ic_home"></a> <span class="afms-ic_next"></span></li>
				<li><a href="">DMS</a> <span class="afms-ic_next"></span></li>
				<li>การวิเคราะห์การครอบครองความถี่ <span class="afms-ic_next"></span></li>
                <li>สถิติการครอบครองความถี่</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../DMS/Menu.asp"-->
			 <form id=FormSch runat=server>

			<div class="col-md-12">
				<div class="afms-content">
					<div class="afms-page-title">
						สถิติการครอบครองความถี่
					</div>
					<button class="afms-btn afms-btn-primary afms-btn-editsearch" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">แก้ไขการค้นหา</button>
					<button class="afms-btn afms-btn-hidesearch" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">ซ่อน</button>

					<div class="collapse in" id="searchSection">
						<div class="row">
							<div class="col-md-3">
								<div class="afms-field afms-field_select">
									<label>ระดับ</label>
									<select id=Level runat=server>
                                       <option value='1'>จังหวัด</option>
                                       <option value='2'>เขต</option>
                                       <option value='3'>ภาค</option>
                                       <option value='4' selected>ประเทศ</option>
									</select>
									<span class="bar"></span>
								</div>
							</div>
                             <div id="THIDDiv" class="col-md-3">
							<div class="afms-field afms-field_select">
								<label>&nbsp;</label>
                               <select id="THID" runat="server">
									<option value="" selected>= ทั้งหมด =</option>
							    </select>
                                <span class="bar"></span>
                             </div>
                             </div>

                              <div id="ProvIDDiv" class="col-md-3">
							<div class="afms-field afms-field_select">
								<label>&nbsp;</label>
                            
								<select id="ProvID" runat="server">
									<option value="" selected>= ทั้งหมด =</option>
							    </select>
                                <span class="bar"></span>
                                </div>
                                </div>

                                 <div id="LyID1Div" class="col-md-3">
							<div class="afms-field afms-field_select">
								<label>&nbsp;</label>
                            
                                <select id="LyID1" runat="server">
									<option value="" selected>= ทั้งหมด =</option>
							    </select>
                                <span class="bar"></span>
                                </div>
                                </div>

                            <div id="LyID2Div" class="col-md-3">
							<div class="afms-field afms-field_select">
								<label>&nbsp;</label>
                            
                                 <select id="LyID2" runat="server">
									<option value="" selected>= ทั้งหมด4 =</option>
							    </select>
                                </div>
                                
								<span class="bar"></span>
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
				 <%if(tbT!=null){ %>
				<div class="afms-content print-content" style="margin-top: 20px;">
                	<div class="row">
						<div class="col-md-12">
				
				     	<div class="afms-sec-table">
							<table class='tborder' style='min-width:<%=tbT.Columns.Count*100 %>px'>
								<thead>
									<tr>
										<th rowspan=3 style='min-width:200px'>พื้นที่</th>
										 <%for(int i=1;i<tbT.Columns.Count;i++){ %>
                                            <th><%=i %></th>
                                         <%} %>
								    </tr>
                                    <tr>
										 <%for(int i=0;i<tbF.Rows.Count;i++){ %>
                                            <th><%=string.Format("{0}-{1} MHz",tbF.Rows[i]["fFreq"],tbF.Rows[i]["tFreq"]) %></th>
                                         <%} %>
								    </tr>
									<tr>
										 <%for(int i=0;i<tbF.Rows.Count;i++){ %>
                                            <th><%=string.Format("{0}",tbF.Rows[i]["nch"]) %></th>
                                         <%} %>
								    </tr>
								</thead>
								<tbody>
                                <%for(int i=0;i<tbT.Rows.Count;i++){ %>
									<tr>
										<td data-th="พื้นที่" style='text-align:left'><%=tbT.Rows[i]["Area"] %></td>
                                         <%for(int j=0;j<tbF.Rows.Count;j++){ %>
                                            <td style='text-align:center' data-th="<%=string.Format("{0}-{1} MHz",tbF.Rows[j]["fFreq"],tbF.Rows[j]["tFreq"]) %>"><%=tbT.Rows[i]["Freq"+tbF.Rows[j]["FtID"]] %></td>
                                         <%} %>
									</tr>
                                    <%} %>
								</tbody>
							</table>
						</div>

                        <div class="col-md-12 text-center">
							<a href="javascript:exportXls()" class="afms-btn afms-btn-secondary">
								<i class="afms-ic_download"></i> Export to Excel
							</a>
							<a href="javascript:viewChart()" class="afms-btn afms-btn-secondary">
								 กราฟ
							</a>
                            <a href="javascript:viewMap()" class="afms-btn afms-btn-secondary">
								 แผนที่
							</a>
						</div>

                        
                       
                      
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
