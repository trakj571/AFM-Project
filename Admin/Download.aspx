<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Download.aspx.cs" Inherits="EBMSMap.Web.Admin.Download" %>

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
            
            <%if(Request["DlID"]==null){ %>
                $(".nbtc-sec-content").hide();
                $(".nbtc-sec-right").hide();
            <%} %>
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
				<li>Download</li>
			</ul>
            <!--#include file="../_inc/Usr.asp"-->
			<a href="DownloadAdd.aspx" class="nbtc-btn nbtc-btn-secondary">Add Download</a>
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
            
            <div class="nbtc-sec-center nbtc-col2">
				<div class="nbtc-sec-content content-readonly">
					<h2>Download</h2>
					<div class="nbtc-content-options">
						<a href='DownloadAdd.aspx?DlID=<%=Request["DlID"] %>' class="nbtc-btn nbtc-ic_edit"></a>
						<a href="javascript:delItem('spDLd_Add','DlID','<%=Request["DlID"] %>')" class="nbtc-btn nbtc-btn-delete nbtc-ic_delete"></a>
					</div>
				<div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">ระบบ</p>
								<p><asp:Label id=SysGrp runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                   
					</div>
                	<div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">ชื่อเอกสาร</p>
								<p><asp:Label id=Name runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                   
					</div>

                     <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">ประเภทเอกสาร</p>
								<p><asp:Label id=DocType runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                        </div>

                        <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">เอกสาร</p>
								<p><%
                                       if (tbDL != null && tbDL.Rows[0]["FileExt"].ToString() != "")
                                           Response.Write("<a href='../Files/Download/Doc" + tbDL.Rows[0]["DlID"] + "." + tbDL.Rows[0]["FileExt"] + "' target=_blank>แสดง</a>");
                                 %></p>
							</div>
						</div>

						<div class="clear"></div>
                        </div>
					

					<div class="nbtc-group-btn">
						<a href='DownloadAdd.aspx?DlID=<%=Request["DlID"] %>' class="nbtc-btn nbtc-btn-primary">แก้ไข</a>
						<a href="javascript:delItem('spDLd_Add','DlID','<%=Request["DlID"] %>')" class="nbtc-btn nbtc-btn-secondary nbtc-btn-delete">ลบ</a>
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
