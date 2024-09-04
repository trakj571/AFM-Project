<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CTypeAdd.aspx.cs" Inherits="EBMSMap.Web.Admin.CTypeAdd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <!--#include file="../_inc/title.A.asp"-->
    <script language=javascript>
        $(function(){
           $("#TypeList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetCTypes(Request["TypeID"]) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                if(data.node.id.substring(0,1)=="G")
                    return;
                location = "CType.aspx?typeid="+data.node.id;
            }).bind("ready.jstree", function (e, data) {
                $('#TypeList li').each( function() {
                    if(this.id.substring(0,1)=="G")
                        $("#TypeList").jstree().disable_node(this.id);
                })
             
            });

          $("#TmpList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetTemplates("") %> }
               
            }).bind("select_node.jstree", function (e, data) {
                $("#OrgID").val(data.node.id);
             }).bind("ready.jstree", function (e, data) {
                
            });

            
            $("#UnderGrpList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetCGrps(pCGID.Value) %> }
                
            }).bind("select_node.jstree", function (e, data) {
                $("#pCGID").val(data.node.id);
            }).bind("ready.jstree", function (e, data) {
                
            });

        });

        
        var to = false;
        function search(t) {
            if(to) { clearTimeout(to); }
            to = setTimeout(function () {
              $('#TypeList').jstree(true).search(t);
            }, 250);
          
        }

        function addField(colid) {
            openDialog('CField.aspx?colid=' + colid + "&typeid=<%=Request["TypeID"] %>");
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
				<li>Add Type</li>
			</ul>
            <!--#include file="../_inc/Usr.asp"-->
			<a href="CTypeAdd.aspx" class="nbtc-btn nbtc-btn-secondary">Add Type</a>
		</div>
          <form id=Form1 runat=server>
           
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
				        <div id=TypeList style="height:100%;background:Transparent"></div>
				    </div>
				</div>
			</div>
           <div id=hiddenDiv style='display:none'>
            <input type=text id="pCGID" runat=server value="0" />
           </div>
            <div class="nbtc-sec-center nbtc-col2">
				<div class="nbtc-sec-content">
					<h2>Add Type</h2>
					
				
                	<div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_input">
								<input type="text"  id=Name runat=server>
								<span class="bar"></span>
								<label>Type Name</label>
							</div>
                              <asp:RequiredFieldValidator ID=rName ControlToValidate=Name runat=server ErrorMessage="*<br /><br />" ForeColor=Red Display=Dynamic></asp:RequiredFieldValidator>
							
						</div>

						<div class="clear"></div>
                   
					</div>

                     

                        <div class="nbtc-row">
							<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_textarea">
								<textarea data-autoresize  id=Detail runat=server></textarea>
								<span class="bar"></span>
								<label>Type Detail</label>
							</div>
						</div>

						<div class="clear"></div>
                        </div>
					
                    <div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_select">
								<select id=PoiType runat=server>
                                    <option value=1>Point</option>
                                    <option value=2>Line</option>
                                    <option value=3>Polygon</option>
                                    <option value=4>Circle</option>
                                </select>
								<span class="bar"></span>
								<label>Type of Data</label>
							</div>
						</div>

						<div class="clear"></div>
                   
					</div>
					
                    <%if (IsFreq)
                      { %>
                    <div class="nbtc-row">
							<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_input">
						    <input type="text"  id=CHSpace runat=server><span class="bar"></span>
								<label>CH Space (kHz)</label>
							</div>
						</div>

							<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_input">
						    <input type="text"  id=RadioProp runat=server><span class="bar"></span>
								<label>Radio of Prop. (km)</label>
							</div>
						</div>

						<div class="clear"></div>
                        </div>
                        <%} %>
                    
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

                    <div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">Under Group</p>
                             	<p><div id=UnderGrpList></div></p>
							</div>
						</div>
                         <asp:RequiredFieldValidator ID=rpCGID ControlToValidate=pCGID InitialValue="0" runat=server ErrorMessage="*<br /><br />" ForeColor=Red Display=Dynamic></asp:RequiredFieldValidator>
							
						<div class="clear"></div>
                        </div>


               	
                   


					<div class="nbtc-group-btn">
						<input type=submit id=bSave value='บันทึก' runat=server onserverclick=bSave_ServerClick class="nbtc-btn nbtc-btn-primary" />
						<input type=reset id=bReset value='ล้าง' runat=server class="nbtc-btn nbtc-btn-secondary" />
					</div>
				</div>
			</div>
           

			<div class="nbtc-sec-right nbtc-col1">
				<div class="nbtc-sec-grouppolicy">
					<h2>Symbol</h2>
					<div style='text-align:center'><br /><img id=imgSymbol  src='<%=DSymbol %>' width=32 height=32 /><br /></div>
                    <br />
                    <input id=Symbol type=file runat=server style='width:80%' />
				</div>


				<div class="nbtc-sec-org">
					<h2>Template</h2>
					<div id=TmpList class="nbtc-content">
						
					</div>
				</div>
			</div>
		</div>
         </form>
		<div class="push"></div>
	</div>

         <!--#include file="../_Inc/Ft.A.asp"-->
         <script language=javascript>
                msgbox_save(<%=retID %>,"CType.aspx?typeid=<%=retID %>");
        
            </script>

</body>
</html>
