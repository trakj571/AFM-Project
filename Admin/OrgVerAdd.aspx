<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrgVerAdd.aspx.cs" Inherits="EBMSMap.Web.Admin.OrgVerAdd" %>

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
            <input id=ProvIDs runat=server type=hidden />
            <div class="nbtc-sec-center nbtc-col2">
				<div class="nbtc-sec-content">
					<h2>Add Organization Version</h2>
					<div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_input">
								<input type="text" id=Ver runat=server>
								<span class="bar"></span>
								<label>Version</label>
							</div>
						</div>

						<div class="clear"></div>
					</div>
					<div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_input">
								<input type="text"  id=Name runat=server>
								<span class="bar"></span>
								<label>Version Name</label>
							</div>
                              <asp:RequiredFieldValidator ID=rName ControlToValidate=Name runat=server ErrorMessage="*<br /><br />" ForeColor=Red Display=Dynamic></asp:RequiredFieldValidator>
							
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

			
        <div class="push"></div>
	</div>

         <!--#include file="../_Inc/Ft.A.asp"-->


          <script language=javascript>
                msgbox_save(<%=retID %>,"OrgVer.aspx?verid=<%=retID %>");
        
            </script>
</body>
</html>
