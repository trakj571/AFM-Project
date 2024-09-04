<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrgVer.aspx.cs" Inherits="EBMSMap.Web.Admin.OrgVer" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <!--#include file="../_inc/title.A.asp"-->
    <script language=javascript>
        $(function(){
           $("#OrgList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetOrgVers(Request["VerID"]) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                location = "OrgVer.aspx?verid="+data.node.id;
            });
            

           

            <%if(Request["verID"]==null){ %>
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
				<li>Organization Version</li>
			</ul>
            <!--#include file="../_inc/Usr.asp"-->
			<a href="OrgVerAdd.aspx" class="nbtc-btn nbtc-btn-secondary">Add Organization Version</a>
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
            <input id=ProvIDs runat=server type=hidden />
            
            <div class="nbtc-sec-center nbtc-col2">
				<div class="nbtc-sec-content content-readonly">
					<h2>Organization Version</h2>
					<div class="nbtc-content-options">
						<a href='OrgVerAdd.aspx?verid=<%=Request["VerID"] %>' class="nbtc-btn nbtc-ic_edit"></a>
						<a href="javascript:delItem('spOrgVer_Add','VerID','<%=Request["VerID"] %>')" class="nbtc-btn nbtc-btn-delete nbtc-ic_delete"></a>
					</div>
				
                	<div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">Version</p>
								<p><asp:Label id=Ver runat=server></asp:Label></p>
							</div>
						</div>
						<div class="clear"></div>
                   
					</div>
					<div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">Version Name</p>
								<p><asp:Label id=Name runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                   
					</div>
					
					<div class="nbtc-group-btn">
						<a href='OrgVerAdd.aspx?verid=<%=Request["verID"] %>' class="nbtc-btn nbtc-btn-primary">แก้ไข</a>
						<a href="javascript:delItem('spOrgVer_Add','verID','<%=Request["verID"] %>')" class="nbtc-btn nbtc-btn-secondary nbtc-btn-delete">ลบ</a>
					</div>
				</div>
			</div>
            </form>

			
		</div>
        <div class="push"></div>
	</div>

         <!--#include file="../_Inc/Ft.A.asp"-->


          <script language=javascript>
                msgbox_save(<%=retID %>,"Usr.aspx?uid=<%=retID %>");
        
            </script>
</body>
</html>
