<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrgAdd.aspx.cs" Inherits="EBMSMap.Web.Admin.OrgAdd" %>

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
            $("#UnderOrgList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetUnderOrgs(pOrgID.Value) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                
                $("#pOrgID").val(data.node.id);
                
            }).bind("loaded.jstree", function (e, data) {
                $("#UnderOrgList #<%=Request["OrgID"] %>").hide();
			});
			$("#VerID").change(function () {
                $("#ProvLists > div").hide();
				$("#ProvList" + $(this).val()).show();
			});

            <%for (int i = 0; i < VerID.Items.Count; i++)
                            { %>

            $("#ProvList<%=VerID.Items[i].Value%>").jstree({
                'core': { 'data': <%=EBMSMap.Web.JSData.GetAreas("") %> },
                "checkbox": {
                    "keep_selected_style": false,
                    "tie_selection": false,
                    "three_state": false

                },
                "plugins": ["search", "checkbox"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {

            }).bind("ready.jstree", function (e, data) {
              
                 var orgids = ('<%=ProvIDs(VerID.Items[i].Value) %>').split(',');
                 for (var i = 0; i < orgids.length; i++) {
                     $("#ProvList<%=VerID.Items[i].Value%>").jstree().check_node(orgids[i]);
                 }
			});

            $("#ProvList<%=VerID.Items[i].Value%>").on("check_node.jstree", function (e, data) {
                updateProv();
            }).on("uncheck_node.jstree", function (e, data) {
                updateProv();
			});

			<%}%>


        });

		function updateProv() {
            var chks = [];
			<%for (int i = 0; i < VerID.Items.Count; i++){ %>
        
				var tree = $('#ProvList<%=VerID.Items[i].Value%>').jstree("get_checked", true);
				chks = [];
				$.each(tree, function() {
				   chks.push(this.id.replace("li_",""));
				});
				$("#ProvIDs<%=VerID.Items[i].Value%>").val(chks.join(','));
				//alert($("#ProvIDs<%=VerID.Items[i].Value%>").val());
			<%}%>
        }

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
            <form id=Form1 runat=server onsubmit="retriveLatLon()">
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
				<div class="nbtc-sec-content">
					<h2>Add Organization</h2>
					
					<div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_input">
								<input type="text"  id=Name runat=server>
								<span class="bar"></span>
								<label>Organization Name</label>
							</div>
                              <asp:RequiredFieldValidator ID=rName ControlToValidate=Name runat=server ErrorMessage="*<br /><br />" ForeColor=Red Display=Dynamic></asp:RequiredFieldValidator>
							
						</div>

						<div class="clear"></div>
					</div>

					<div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_input">
								<input type="text" id=OrgCode runat=server>
								<span class="bar"></span>
								<label>Organization ID</label>
							</div>
						</div>

						<div class="clear"></div>
					</div>

					<div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_textarea">
								<textarea data-autoresize  id=Detail runat=server></textarea>
								<span class="bar"></span>
								<label>Organization Detail</label>
							</div>
						</div>

						<div class="clear"></div>
					</div>

                    <div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_textarea">
								<textarea id=Address runat=server style="height:60px"></textarea>
								<span class="bar"></span>
								<label>ที่อยู่</label>
							</div>
						</div>

						<div class="clear"></div>
					</div>


                    <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_input">
								<input type="text" id=TelNo runat=server>
								<span class="bar"></span>
								<label>โทรศัพท์</label>
							</div>
						</div>
					</div>

                    <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_input">
								<input type="text" id=FaxNo runat=server>
								<span class="bar"></span>
								<label>โทรสาร</label>
							</div>
						</div>

						<div class="clear"></div>
					</div>

                    <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_input">
								<input type="text" id=Email runat=server>
								<span class="bar"></span>
								<label>Email</label>
							</div>
						</div>
					</div>

                    <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_input">
								<input type="text" id=WebSite runat=server>
								<span class="bar"></span>
								<label>WebSite</label>
							</div>
						</div>

						<div class="clear"></div>
					</div>
                    <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_input">
								<input type="text" id=AuthName runat=server>
								<span class="bar"></span>
								<label>ผู้อำนวยการ</label>
							</div>
						</div>

						<div class="clear"></div>
					</div>
                    <div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">Under Organization</p>
                             	<p><div id=UnderOrgList></div></p>
							</div>
						</div>

						<div class="clear"></div>
                        </div>
                     <br />
                     <div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_checkbox">
								<label>
									<input id="IsRegView" type="checkbox" runat="server" />
									<span class="box"></span>
									<span class="nbtc-ic_check"></span>
									ดูข้อมูลระดับภาค
								</label>
							</div>
						</div>
						<div class="clear"></div>
					</div>
                         <div class="nbtc-row">
						<div class="nbtc-col1">
						<input type=hidden id=Lat runat=server value="" />
                        <input type=hidden id=Lng runat=server value="" />

                    <!--#include file="../GIS/EMapEdit.asp"-->
                    </div>

						<div class="clear"></div>
                        </div>

					<div class="nbtc-group-btn">
						<input type=submit id=bSave value='บันทึก' runat=server onserverclick=bSave_ServerClick class="nbtc-btn nbtc-btn-primary" />
						<input type=reset id=bReset value='ล้าง' runat=server class="nbtc-btn nbtc-btn-secondary" />
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
        <div class="push"></div>
	</div>

         <!--#include file="../_Inc/Ft.A.asp"-->


          <script language=javascript>
                msgbox_save(<%=retID %>,"Org.aspx?orgid=<%=retID %>");
        
            </script>
</body>
</html>
