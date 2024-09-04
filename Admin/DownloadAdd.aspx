<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DownloadAdd.aspx.cs" Inherits="EBMSMap.Web.Admin.DownloadAdd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <!--#include file="../_inc/title.A.asp"-->
    <script language=javascript>
        $(function(){
           $("#DlList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetDownloads(Request["DlID"]) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                location = "Download.aspx?dlid="+data.node.id;
            });
            
        });

        
       var to = false;
        function search(t) {
            if(to) { clearTimeout(to); }
            to = setTimeout(function () {
              $('#DlList').jstree(true).search(t);
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
				<li><a href="#">Account</a> <i class="nbtc-ic_next"></i></li>
				<li>Download</li>
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
				        <div id=DlList style="height:100%;background:Transparent"></div>
				    </div>
				</div>
			</div>
            <form id=Form1 runat=server>
            <input id=pOrgID runat=server type=hidden />
            
            <div class="nbtc-sec-center nbtc-col2">
				<div class="nbtc-sec-content">
					<h2>Add Download</h2>
					<div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_select">
								<select id="SysGrp" runat="server">
									<option value="">กรุณาเลือก</option>
									<option value="FMR">FMR</option>
									<option value="AFM">AFM</option>
									<option value="DMS">DMS</option>
										<option value="GPS">GPS</option>
									<option value="VSS">VSS</option>
									<option value="OPER">OPER</option>
									<option value="PUB-INFO">PUB-INFO</option>
									<option value="R-Visulization & OPER Mobile">R-Visulization & OPER Mobile</option>
								</select>
								<span class="bar"></span>
								<label>ระบบ</label>
							</div>
						</div>

						<div class="clear"></div>
					</div>
					<div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_input">
								<input type="text"  id=Name runat=server>
								<span class="bar"></span>
								<label>ชื่อเอกสาร</label>
							</div>
                              <asp:RequiredFieldValidator ID=rName ControlToValidate=Name runat=server ErrorMessage="*<br /><br />" ForeColor=Red Display=Dynamic></asp:RequiredFieldValidator>
							
						</div>

						<div class="clear"></div>
					</div>

					<div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_input">
								<input type="text" id=DocType runat=server>
								<span class="bar"></span>
								<label>ประเภทเอกสาร</label>
							</div>
						</div>

						<div class="clear"></div>
					</div>

					<div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_input">
								<input type="file" id=File1 runat=server>
								<span class="bar"></span>
								<label>เอกสาร</label>
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

			<div class="nbtc-sec-right nbtc-col1">
			
			</div>
		</div>
        <div class="push"></div>
	</div>

         <!--#include file="../_Inc/Ft.A.asp"-->


          <script language=javascript>
                msgbox_save(<%=retID %>,"Download.aspx?dlid=<%=retID %>");
        
            </script>
</body>
</html>
