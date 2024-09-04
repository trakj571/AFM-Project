<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Org.aspx.cs" Inherits="EBMSMap.Web.Admin.Org" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <!--#include file="../_inc/title.A.asp"-->
    <script language=javascript>
        $(function(){
           $("#OrgList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetOrgs(Request["OrgID"]) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                location = "Org.aspx?orgid="+data.node.id;
			});
            $("#VerID").change(function () {
                $("#ProvLists > div").hide();
                $("#ProvList" + $(this).val()).show();
            });
              <%for (int i = 0; i < VerID.Items.Count; i++)
                            { %>

            $("#ProvList<%=VerID.Items[i].Value%>").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetAreas("") %> },
                "checkbox" : {
	              "keep_selected_style" : false,
                  "tie_selection" : false,
                  "three_state": false

                },
                "plugins": ["search","checkbox"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
               
             }).bind("ready.jstree", function (e, data) {
                $('#ProvList<%=VerID.Items[i].Value%> li').each( function() {
                    $("#ProvList<%=VerID.Items[i].Value%>").jstree().disable_node(this.id);
                });
                var orgids = ('<%=ProvIDs(i) %>').split(',');
                for(var i=0;i<orgids.length;i++){
                    $("#ProvList<%=VerID.Items[i].Value%>").jstree().check_node(orgids[i]);
                }
            });
			<%}%>
            <%if(Request["OrgID"]==null){ %>
                $(".nbtc-sec-content").hide();
                $(".nbtc-sec-right").hide();
            <%} %>
        });


        
         
        
        var to = false;
        function search(t) {
            if(to) { clearTimeout(to); }
            to = setTimeout(function () {
              $('#OrgList').jstree(true).search(t);
            }, 250);
          
        }
    </script>

    
</head>
<body class="nbtc-admin">
	<div class="nbtc-container">
		<!--#include file="../_inc/hd.A.asp"-->

		<div class="nbtc-sec-breadcrumb">
			<ul>
				<li><a href=""><i class="nbtc-ic_home"></i></a> <i class="nbtc-ic_next"></i></li>
				<li><a href="">Admin Tools</a> <i class="nbtc-ic_next"></i></li>
				<li><a href="">Account</a> <i class="nbtc-ic_next"></i></li>
				<li>Organization</li>
			</ul>
            <!--#include file="../_inc/Usr.asp"-->
			<a href="OrgAdd.aspx" class="nbtc-btn nbtc-btn-secondary">Add Organization</a>
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
				        <div id=OrgList style="height:100%;background:Transparent"></div>
				    </div>
				</div>
			</div>
            <form id=Form1 runat=server>
            <input id=pOrgID runat=server type=hidden />
            <input id=ProvIDs1 runat=server type=hidden />
			<input id=ProvIDs2 runat=server type=hidden />
            <input id=ProvIDs3 runat=server type=hidden />
			<input id=ProvIDs4 runat=server type=hidden />
			<input id=ProvIDs5 runat=server type=hidden />
			<input id=ProvIDs6 runat=server type=hidden />
			<input id=ProvIDs7 runat=server type=hidden />
			<input id=ProvIDs8 runat=server type=hidden />
			<input id=ProvIDs9 runat=server type=hidden />
			<input id=ProvIDs10 runat=server type=hidden />

            <div class="nbtc-sec-center nbtc-col2">
				<div class="nbtc-sec-content content-readonly">
					<h2>Organization</h2>
					<div class="nbtc-content-options">
						<a href='OrgAdd.aspx?orgid=<%=Request["OrgID"] %>' class="nbtc-btn nbtc-ic_edit"></a>
						<a href="javascript:delItem('spOrg_Add','OrgID','<%=Request["OrgID"] %>')" class="nbtc-btn nbtc-btn-delete nbtc-ic_delete"></a>
					</div>
				
                	<div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">Organization Name</p>
								<p><asp:Label id=Name runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                   
					</div>

                     <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">Organization ID</p>
								<p><asp:Label id=OrgCode runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                        </div>

                        <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">Organization Detail</p>
								<p><asp:Label id=Detail runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                        </div>
					
                         <div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_textarea">
								<p class="nbtc-field-title">ที่อยู่</p>
								<p><asp:Label id=Address runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                        </div>

                        <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_textarea">
								<p class="nbtc-field-title">โทรศัพท์</p>
								<p><asp:Label id=TelNo runat=server></asp:Label></p>
							</div>
						</div>

						</div>
                        <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">โทรสาร</p>
								<p><asp:Label id=FaxNo runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                        </div>
                        <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">Email</p>
								<p><asp:Label id=Email runat=server></asp:Label></p>
							</div>
						</div>

						</div>
                        <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">WebSite</p>
								<p><asp:Label id=WebSite runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                        </div>
                         <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">ผู้อำนวยการ</p>
								<p><asp:Label id=AuthName runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                        </div>
                         <!--div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">พื้นที่ความรับผิดชอบ</p>
								<p><asp:Label id=AreaList runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                        </!--div-->
                     <br />
                     <div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_checkbox">
								<label>
									<input id="IsRegView" type="checkbox" runat="server" onclick="return false;" />
									<span class="box"></span>
									<span class="nbtc-ic_check"></span>
									ดูข้อมูลระดับภาค
								</label>
							</div>
						</div>
						<div class="clear"></div>
					</div>

                        <br />
                        <div class="nbtc-row">
						<div class="nbtc-col1">
                        <input id=Lat type=hidden runat=server />
                        <input id=Lng type=hidden runat=server />
                        <input type=hidden id=Tools runat=server value="1" />
                      <!--#include file="../GIS/EMapView.asp"-->
                        </div>

						<div class="clear"></div>
                        </div>
					<div class="nbtc-group-btn">
						<a href='OrgAdd.aspx?orgid=<%=Request["OrgID"] %>' class="nbtc-btn nbtc-btn-primary">แก้ไข</a>
						<a href="javascript:delItem('spOrg_Add','OrgID','<%=Request["OrgID"] %>')" class="nbtc-btn nbtc-btn-secondary nbtc-btn-delete">ลบ</a>
					</div>
				</div>
			</div>
            </form>

			<div class="nbtc-sec-right nbtc-col1">
				<div class="nbtc-sec-grouppolicy">
					<h2>User</h2>
					<table class="nbtc-table">
						<thead>
							<tr>
								<th>No.</th>
								<th>Name</th>
								<th>Group</th>
								<th>Act.</th>
							</tr>
						</thead>
						<tbody>
							<%
                                if(tbU!=null){
                                    for (int i = 0; i < tbU.Rows.Count; i++)
                                    {
                                        Response.Write("<tr>");
                                        Response.Write("<td>"+(i+1)+"</td>");
                                        Response.Write("<td>" + tbU.Rows[i]["Login"] + "<!--(" + tbU.Rows[i]["FName"] + " " + tbU.Rows[i]["LName"] + ")-->" + "</td>");
                                        Response.Write("<td>" + tbU.Rows[i]["Grp"] + "</td>");
                                        Response.Write("<td>" + tbU.Rows[i]["IsActive"] + "</td>");
                                        Response.Write("</tr>");
                                    }
                                }
                             %>
                            
								
							
						</tbody>
					</table>
				</div>

                <div class="nbtc-sec-grouppolicy">
					<h2>พื้นที่ความรับผิดชอบ</h2>
					<select id="VerID" runat="server" style="width:100%">
                        
                    </select>
                    <div id="ProvLists" class="nbtc-search-listx" style='background:#eee;padding:10px;'>
				        <%for (int i = 0; i < VerID.Items.Count; i++)
                            { %>
								<div id="ProvList<%=VerID.Items[i].Value %>" style="height:100%;background:Transparent;<%=(i<VerID.Items.Count-1?"display:none":"")%>"></div>
						<%} %>
				    </div>
                    </div>
			</div>
		</div>
        <div class="push"></div>
	</div>

         <!--#include file="../_Inc/Ft.A.asp"-->


          <script language=javascript>
                msgbox_save(<%=retID %>,"Usr.aspx?uid=<%=retID %>");
        
            </script>
</body>
</html>
