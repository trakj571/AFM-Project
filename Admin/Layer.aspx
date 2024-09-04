﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Layer.aspx.cs" Inherits="EBMSMap.Web.Admin.Layer" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <!--#include file="../_inc/title.A.asp"-->
    <script language=javascript>
        $(function(){
           $("#LayerList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetLayers(Request["LyID"]) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                location = "Layer.aspx?lyid="+data.node.id;
            });

          
            $("#GrpList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetUGrps("") %> },
                "checkbox" : {
	              "keep_selected_style" : false,
                  "tie_selection" : false
                },
                "plugins": ["search","checkbox"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                $("#UGID").val(data.node.id);
            }).bind("ready.jstree", function (e, data) {
                $('#GrpList li').each( function() {
                    $("#GrpList").jstree().disable_node(this.id);
                })
                var ugids = ('<%=UGID.Value %>').split(',');
                for(var i=0;i<ugids.length;i++){
                    $("#GrpList").jstree().check_node(ugids[i]);
                }
            });

            $("#OrgList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetOrgs("") %> },
                "checkbox" : {
	              "keep_selected_style" : false,
                  "tie_selection" : false,
                  "three_state": false

                },
                "plugins": ["search","checkbox"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                $("#OrgID").val(data.node.id);
             }).bind("ready.jstree", function (e, data) {
                $('#OrgList li').each( function() {
                    $("#OrgList").jstree().disable_node(this.id);
                });
                var orgids = ('<%=OrgID.Value %>').split(',');
                for(var i=0;i<orgids.length;i++){
                    $("#OrgList").jstree().check_node(orgids[i]);
                }
			 });


            $("#TypeList").jstree({
                'core': { 'data': <%=EBMSMap.Web.JSData.GetCTypes(TypeID.Value) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
               

            }).bind("ready.jstree", function (e, data) {
                $('#TypeList li').each(function () {
                    $("#TypeList").jstree().disable_node(this.id);
                })

            });

            <%if(Request["LyID"]==null){ %>
                $(".nbtc-sec-content").hide();
                $(".nbtc-sec-right").hide();
            <%} %>
        });

        
        var to = false;
        function search(t) {
            if(to) { clearTimeout(to); }
            to = setTimeout(function () {
              $('#LayerList').jstree(true).search(t);
            }, 250);
          
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
				<li><a href="#">Layer</a> <i class="nbtc-ic_next"></i></li>
				<li>Layer</li>
			</ul>
            <!--#include file="../_inc/Usr.asp"-->
			<a href="LayerAdd.aspx" class="nbtc-btn nbtc-btn-secondary">Add Layer</a>
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
				        <div id=LayerList style="height:100%;background:Transparent"></div>
				    </div>
				</div>
			</div>
            <form id=Form1 runat=server>
            <div id=hiddenDiv>
            <input type=hidden id="UGID" runat=server />
            <input type=hidden id="OrgID" runat=server />
				<input type=hidden id="TypeID" runat=server />
           </div>
            <div class="nbtc-sec-center nbtc-col2">
				<div class="nbtc-sec-content content-readonly">
					<h2>Layer</h2>
					<div class="nbtc-content-options">
						<a href='LayerAdd.aspx?lyid=<%=Request["LyID"] %>' class="nbtc-btn nbtc-ic_edit"></a>
						<a href="javascript:delItem('spLyr_Add','LyID','<%=Request["LyID"] %>')" class="nbtc-btn nbtc-btn-delete nbtc-ic_delete"></a>
					</div>
				
                	<div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">Layer Name</p>
								<p><asp:Label id=Name runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                   
					</div>

                     

                        <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">Layer Detail</p>
								<p><asp:Label id=Detail runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                        </div>
					
                    <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">Source</p>
								<p><asp:Label id=Source runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                        </div>
					 <div class="nbtc-row">
                       <div class="nbtc-col1">
                          
                       	<div class="nbtc-field nbtc-field_select">
                               <p class="nbtc-field-title">Icon</p>
                            <div style="padding:10px;">
                                        <img id=imgSymbol  src='<%=DSymbol %>' width=32 height=32 />
               </div>
                               </div>
                           </div>
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

					<div class="nbtc-group-btn">
						<a href='LayerAdd.aspx?lyid=<%=Request["LyID"] %>' class="nbtc-btn nbtc-btn-primary">แก้ไข</a>
						<a href="javascript:delItem('spLyr_Add','LyID','<%=Request["LyID"] %>')" class="nbtc-btn nbtc-btn-secondary nbtc-btn-delete">ลบ</a>
					</div>
				</div>
			</div>
            </form>

			<div class="nbtc-sec-right nbtc-col1">
				<div class="nbtc-sec-grouppolicy">
					<h2>Group</h2>
					<div id=GrpList class="nbtc-content">
						
					</div>
				</div>


				<div class="nbtc-sec-org">
					<h2>ORG</h2>
					<div id=OrgList class="nbtc-content">
						
					</div>
				</div>
				<div class="nbtc-sec-type">
                    <a href="javascript:clearTypeID()" style="float:right">Clear</a>
					<h2>Content Type</h2> 
					<div id=TypeList class="nbtc-content">
						
					</div>
				</div>
			</div>
		</div>

		<div class="push"></div>
	</div>

         <!--#include file="../_Inc/Ft.A.asp"-->


</body>
</html>