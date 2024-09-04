<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DomainAdd.aspx.cs" Inherits="EBMSMap.Web.Admin.DomainAdd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <!--#include file="../_inc/title.A.asp"-->
    <script language=javascript>
        $(function(){
           $("#DmList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetDomains(Request["DmID"]) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                location = "Domain.aspx?dlid="+data.node.id;
            });


            $("#GisLayerList").jstree({
                'core': { 'data': <%=EBMSMap.Web.JSData.GetGISLayers("") %> },
                "checkbox": {
                    "keep_selected_style": false,
                    "tie_selection": false,
                    "three_state": true

                },
                "plugins": ["search", "checkbox"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                $("#GisLayerList").val(data.node.id);
            }).bind("ready.jstree", function (e, data) {
               
                var svcs = ('<%=LyIDs.Value %>').split(',');
                for (var i = 0; i < svcs.length; i++) {
                    if (isNaN(svcs[i]))
                        continue;
                    $("#GisLayerList").jstree().check_node(svcs[i]);
                }

                $("#GisLayerList").on("check_node.jstree", function (e, data) {
                    updateSvc();
                }).on("uncheck_node.jstree", function (e, data) {
                    updateSvc();
                });

            });

            $("#SvcList").jstree({
                "checkbox": {
                    "keep_selected_style": false,
                    "tie_selection": false,
                },
                "plugins": ["checkbox", "search"],
                "search": { show_only_matches: true }

            }).bind("select_node.jstree", function (e, data) {


            }).bind("ready.jstree", function (e, data) {
                $("#SvcList").jstree("open_all");
                $('#SvcList li').each(function () {
                    if ($("#hiddenDiv #" + this.id.replace("li_", "")).val() == "Y") {
                        $("#SvcList").jstree().check_node(this.id);
                        //$("#CapList").jstree().unselect_node(this.id)
                    }
                    // $("#SvcList").jstree().disable_node(this.id);

                })
                $("#SvcList").on("check_node.jstree", function (e, data) {
                    updateSvc1();
                }).on("uncheck_node.jstree", function (e, data) {
                    updateSvc1();
                });
            });
        });
        function updateSvc() {
            var tree = $('#GisLayerList').jstree("get_checked", true);
            var chks = [];
            $.each(tree, function () {
                chks.push(this.id.replace("li_", ""));
            });
            $("#LyIDs").val(chks.join(','));
           // alert( $("#LyIDs").val());
        }
        function updateSvc1() {
            $("#IsCRM,#IsRep").val("N");
            var tree = $('#SvcList').jstree("get_checked", true);
            $.each(tree, function () {
                $("#hiddenDiv #" + this.id.replace("li_", "")).val("Y");
            });
        }
       var to = false;
        function search(t) {
            if(to) { clearTimeout(to); }
            to = setTimeout(function () {
              $('#DmList').jstree(true).search(t);
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
				<li>Domain</li>
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
				        <div id=DmList style="height:100%;background:Transparent"></div>
				    </div>
				</div>
			</div>
            <form id=Form1 runat=server>
                <div id=hiddenDiv>
                <input type="hidden" id="SvcLG" runat="server" />
                <input type="hidden" id="SvcNBTC" runat="server" />
                <input type="hidden" id="SvcBP" runat="server" />
                <input type="hidden" id="SvcDGA" runat="server" />
                <input type="hidden" id="SvcIEDM" runat="server" />
                     <input type="hidden" id="LyIDs" runat="server" />
                     <input type="hidden" id="IsCRM" runat="server" />
                <input type="hidden" id="IsRep" runat="server" />
                 
            </div>

            <div class="nbtc-sec-center nbtc-col2">
				<div class="nbtc-sec-content">
					<h2>Add Domain</h2>
					
					<div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_input">
								<input type="text"  id=Name runat=server>
								<span class="bar"></span>
								<label>Domain Name</label>
							</div>
                              <asp:RequiredFieldValidator ID=rName ControlToValidate=Name runat=server ErrorMessage="*<br /><br />" ForeColor=Red Display=Dynamic></asp:RequiredFieldValidator>
							
						</div>

						<div class="clear"></div>
					</div>
                    <div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_input">
								<input type="text"  id=Detail runat=server>
								<span class="bar"></span>
								<label>Domain Detail</label>
							</div>
                      		
						</div>

						<div class="clear"></div>
					</div>

					<div class="nbtc-row">
						<div class="nbtc-col4">
							<div class="nbtc-field nbtc-field_checkbox">
								<label>
									<input id=IsActive type="checkbox" runat=server />
									<span class="box"></span>
									<span class="nbtc-ic_check"></span>
									Active
								</label>
							</div>
						</div>
						<div class="clear"></div>
					</div>

                    
					<div class="nbtc-group-btn">
						<input type=submit id=bSave value='บันทึก' runat=server onserverclick=bSave_ServerClick class="nbtc-btn nbtc-btn-primary" />
						<input type=reset id=bReset value='ล้าง' runat=server class="nbtc-btn nbtc-btn-secondary" />
					</div>
                    6


				</div>
			</div>
            </form>

			<div class="nbtc-sec-right nbtc-col1">

                <div class="nbtc-sec-grouppolicy">
                    <h2>Service</h2>
					<div class="nbtc-content" id="SvcList" style="font-size:14px">
						 <ul>
                             <li id="li_IsCRM">CRM</li>
							 <li id="li_IsRep">Report</li>
						</ul>
					</div>
					<br />
					<h2>GISLayer </h2>
					<div class="nbtc-content" id="GisLayerList" style="font-size:14px">
						
					</div>
				</div>


				

				
			</div>
		</div>
        <div class="push"></div>
	</div>

         <!--#include file="../_Inc/Ft.A.asp"-->


          <script language=javascript>
                msgbox_save(<%=retID %>,"Domain.aspx?dmid=<%=retID %>");
        
            </script>
</body>
</html>
