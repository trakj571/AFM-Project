<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CTmpl.aspx.cs" Inherits="EBMSMap.Web.Admin.CTmpl" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <!--#include file="../_inc/title.A.asp"-->
    <script language=javascript>
        $(function(){
           $("#TplList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetTemplates(Request["TplID"]) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
               location = "CTmpl.aspx?tplid="+data.node.id;
            }).bind("ready.jstree", function (e, data) {
                
             
            });

         

            <%if(Request["TplID"]==null){ %>
                $(".nbtc-sec-content").hide();
                $(".nbtc-sec-right").hide();
            <%} %>

            updateRow();
        });

        
        var to = false;
        function search(t) {
            if(to) { clearTimeout(to); }
            to = setTimeout(function () {
              $('#TplList').jstree(true).search(t);
            }, 250);
          
        }

        function addField(colid) {
            openDialog('CFieldT.aspx?colid=' + colid + "&tplid=<%=Request["TplID"] %>");
            }

            var _ncols = <%=tbC==null?0:tbC.Rows.Count %>;;

            function updateRow() {
                for (var i = 0; i < _ncols; i++) {
                    $("#tr" + i + " .no").html((i + 1) + "");
                    if (i == 0)
                        $("#tr" + i + " .btn").html("<img src='../img/spc.gif' width=16 height=16 /><a href='javascript:swapTR(" + i + ",1)'> <img src='../img/arrow_down.png' /></a>");
                    else if (i == _ncols - 1)
                        $("#tr" + i + " .btn").html("<a href='javascript:swapTR(" + i + ",-1)'><img src='../img/arrow_up.png' /></a>&nbsp;<img src='../img/spc.gif' width=16 height=16 />");
                    else
                        $("#tr" + i + " .btn").html("<a href='javascript:swapTR(" + i + ",-1)'><img src='../img/arrow_up.png' /></a>&nbsp;<a href='javascript:swapTR(" + i + ",1)'><img src='../img/arrow_down.png' /></a>");
                }

                var ors = [];
                var ids = [];
                for (var i = 0; i < _ncols; i++) {
                    ors.push(i + 1);
                    ids.push($("#tr" + i + " .colid").attr("value"));
                }
                $("#Orders").val(ors.join(','));
                $("#ColIDs").val(ids.join(','));
            }
            function swapTR(r, x) {
                var r2 = r + x;
                var tmp = $("#tr" + r).html();
                $("#tr" + r).html($("#tr" + r2).html());
                $("#tr" + r2).html(tmp);

                updateRow();
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
				<li><a href="#">Content</a> <i class="nbtc-ic_next"></i></li>
				<li>Template</li>
			</ul>
            <!--#include file="../_inc/Usr.asp"-->
			<a href="CTmplAdd.aspx" class="nbtc-btn nbtc-btn-secondary">Add Template</a>
		</div>

		<div class="nbtc-col nbtc-group-col3">
			<div class="nbtc-sec-left nbtc-col1">
				<div class="nbtc-sec-search">
					<div class="nbtc-field nbtc-field_input has-right-icon">      
				      <input id=txtSch type=txt onkeyup="search(this.value)" />
				      <span class="bar"></span>
				      <label>ค้นหา</label>
				      <i class="nbtc-ic_search"></i>
				    </div>

				    <div class="nbtc-search-listx" style='background:#eee;padding:10px;'>
				        <div id=TplList style="height:100%;background:Transparent"></div>
				    </div>
				</div>
			</div>
            <form id=Form1 runat=server>
            <div id=hiddenDiv>
            <input type=hidden id="UGID" runat=server />
            <input type=hidden id="OrgID" runat=server />
            <input type=hidden id="ColIDs" runat=server />
            <input type=hidden id="Orders" runat=server />
           </div>
            <div class="nbtc-sec-center nbtc-col2">
				<div class="nbtc-sec-content content-readonly">
					<h2>Template</h2>
					<div class="nbtc-content-options">
						<a href='CTmplAdd.aspx?tplid=<%=Request["TplID"] %>' class="nbtc-btn nbtc-ic_edit"></a>
						<a href="javascript:delItem('spCon_AddTpl','TplID','<%=Request["TplID"] %>')" class="nbtc-btn nbtc-btn-delete nbtc-ic_delete"></a>
					</div>
				
                	<div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">Template Name</p>
								<p><asp:Label id=Name runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                   
					</div>

                     

                        <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">Template Detail</p>
								<p><asp:Label id=Detail runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                        
					
                   </div>
					
                          <div class="nbtc-row">
						<div class="nbtc-col4">
							<div class="nbtc-field nbtc-field_checkbox">
								<label>
									<input id=IsActive type="checkbox" runat=server onclick="return false;" />
									<span class="box"></span>
									<span class="nbtc-ic_check"></span>
									Active
								</label>
							</div>
						</div>
						<div class="clear"></div>
					</div>  

                    


               	<h2>Field detail</h2>
					<table class="nbtc-table">
						<thead>
							<tr>
								<th>No.</th>
								<th>Field Name</th>
								<th>Label</th>
								<th>Header</th>
                                <th>Require</th>
								<th>Search</th>
                                <th></th>
							</tr>
						</thead>
						<tbody>
							<%
                                if(tbC!=null){
                                    for (int i = 0; i < tbC.Rows.Count; i++)
                                    {
                                        Response.Write("<tr id='tr" + i + "'>");
                                        Response.Write("<td class='no'>" + (i + 1) + "</td>");
                                        Response.Write("<td><a href='javascript:addField(\"" + tbC.Rows[i]["ColID"] + "\")'>" + tbC.Rows[i]["dataname"] + "</a><input class=colid type=hidden value='" + tbC.Rows[i]["ColID"] + "' /></td>");
                                        Response.Write("<td>" + tbC.Rows[i]["label"] + "</td>");
                                        Response.Write("<td>" + (tbC.Rows[i]["isHeader"].ToString()=="Y"?"Yes":"") + "</td>");
                                        Response.Write("<td>" + (tbC.Rows[i]["isRequire"].ToString()=="Y"?"Yes":"") + "</td>");
                                        Response.Write("<td>" + (tbC.Rows[i]["isSearch"].ToString() == "Y" ? "Yes" : "") + "</td>");
                                        Response.Write("<td class='btn'></td>");
                                        Response.Write("</tr>");
                                    }
                                }
                             %>
                            
								
							
						</tbody>
					</table>
                    <br />
                    <input type=button class="nbtc-btn nbtc-btn-secondary" value='+Add Field' onclick="addField(0)" />
				    <input type=submit class="nbtc-btn nbtc-btn-secondary" runat=server onserverclick="SaveOrder_ServerClick" value='บันทึก' />
                	<hr />


					<div class="nbtc-group-btn">
						<a href='CTmplAdd.aspx?tplid=<%=Request["TplID"] %>' class="nbtc-btn nbtc-btn-primary">แก้ไข</a>
						<a href="javascript:delItem('spCon_AddTpl','TplID','<%=Request["TplID"] %>')" class="nbtc-btn nbtc-btn-secondary nbtc-btn-delete">ลบ</a>
					</div>
				</div>
			</div>
            </form>

			<div class="nbtc-sec-right nbtc-col1">
				


			</div>
		</div>

		<div class="push"></div>
	</div>

         <!--#include file="../_Inc/Ft.A.asp"-->
         <script language=javascript>
                msgbox_save(<%=retID %>,"CTmpl.aspx?tplid=<%=Request["TplID"] %>");
        
            </script>

</body>
</html>
