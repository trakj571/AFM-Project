<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GISLayerAdd.aspx.cs" Inherits="EBMSMap.Web.Admin.GISLayerAdd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <!--#include file="../_inc/title.A.asp"-->
    <script language=javascript>
        $(function(){
           $("#LayerList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetGISLayers(Request["LyID"]) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                location = "GISLayer.aspx?lyid="+data.node.id;
            });

          
            


             $("#UnderLayerList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetUnderGISLayers(pLyID.Value) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                
                $("#pLyID").val(data.node.id);
                
            }).bind("loaded.jstree", function (e, data) {
                $("#UnderLayerList #<%=Request["LyID"] %>").hide();
            });

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
            <input type=hidden id="UGIDs" runat=server />
            <input type=hidden id="OrgIDs" runat=server />
           </div>
            <div class="nbtc-sec-center nbtc-col2">
				<div class="nbtc-sec-content">
					<h2>Add GIS Layer</h2>
					<input id=pLyID runat=server type=hidden />
            
          		
					<div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_input">
								<input type="text"  id=Name runat=server>
								<span class="bar"></span>
								<label>Layer Name</label>
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
								<label>Layer Detail</label>
							</div>
						</div>

						<div class="clear"></div>
					</div>

                    <div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_input">
								<input type="text" id=Source runat=server>
								<span class="bar"></span>
								<label>Source</label>
							</div>
						</div>

						<div class="clear"></div>
					</div>
					 <div class="nbtc-row">
                       <div class="nbtc-col1">
                           <div style="padding:20px;">
                                        <img id="imgSymbol"  src='<%=DSymbol %>' width="32" height="32" />
                             </div>
                       	<div class="nbtc-field nbtc-field_input">
                            <input id="Symbol" type="file" runat="server" style='width:80%' />
                               <span class="bar"></span>
								<label>Icon</label>

                           
                               </div>
                           </div>
                    </div>
                    <div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">Under Layer</p>
                             	<p><div id=UnderLayerList></div></p>
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



				</div>
			</div>
            </form>

			

		<div class="push"></div>
	</div>

         <!--#include file="../_Inc/Ft.A.asp"-->
         <script language=javascript>
                msgbox_save(<%=retID %>,"GISLayer.aspx?lyid=<%=retID %>");
        
            </script>

</body>
</html>
