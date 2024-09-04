<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Usr.aspx.cs" Inherits="EBMSMap.Web.Admin.Usr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <!--#include file="../_inc/title.A.asp"-->
    <script language=javascript>
        $(function(){
           
           $("#UserList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetUsers(Request["UID"]) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                location = "Usr.aspx?uid="+data.node.id;
            });
            
            $("#GrpList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetUGrps(UGID.Value) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                $("#UGID").val(data.node.id);
            }).bind("ready.jstree", function (e, data) {
                $('#GrpList li').each( function() {
                    $("#GrpList").jstree().disable_node(this.id);
                })
         
            });

            $("#OrgList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetOrgs(OrgID.Value) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                $("#OrgID").val(data.node.id);
             }).bind("ready.jstree", function (e, data) {
                $('#OrgList li').each( function() {
                    $("#OrgList").jstree().disable_node(this.id);
                })
         
            });

            $('.nbtc-field_select select').selectpicker();
            $('.nbtc-field_datepicker input').datepicker({
                orientation: "bottom left"
            });
            UTYpeChange();
            <%if(Request["UID"]==null){ %>
                $(".nbtc-sec-content").hide();
                $(".nbtc-sec-right").hide();
            <%} %>


            //$("#IsActive").prop("disabled",true);
        });

        function UTYpeChange(){
            if($("#UType").val()=="NBTC")
                $(".pwd").hide();
            else
                $(".pwd").show();
        }

        var to = false;
        function search(t) {
            if(to) { clearTimeout(to); }
            to = setTimeout(function () {
              $('#UserList').jstree(true).search(t);
            }, 250);
          
        }

    </script>

    <script language=C# runat=server>
	void CheckPwdSrv(object sender,ServerValidateEventArgs args){
        if (Request["uid"] == null)
        {
            if (Request.Form["UType"] != "NBTC" && Request.Form["Pwd"] == "")
                args.IsValid = false;
            else
                args.IsValid = true;
        }
        else
        {
            args.IsValid = true;
        }
	}
    
    </script>
    <script language=javascript>

        function CheckPwd(sender, args) {
           <%if(Request["uid"]==null){ %>
           if($("#UType").val()!="NBTC" && $("#Pwd").val()=="")
                args.IsValid = false;
            else
                args.IsValid = true;
            <%}else{ %>
                args.IsValid = true;
            <%} %>
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
				<li>User</li>
			</ul>
            <!--#include file="../_inc/Usr.asp"-->
			<a href="UsrAdd.aspx" class="nbtc-btn nbtc-btn-secondary">Add User</a>
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
				        <div id=UserList style="height:100%;background:Transparent"></div>
				    </div>
					<div style='padding:20px;width:100%;' class="text-right">
						<button onclick="exportXls($('#txtSch').val())">Export</button>
					</div>
				</div>
			</div>
            <form id=Form1 runat=server>
            <input id=OrgID runat=server type=hidden />
            <input id=UGID runat=server type=hidden />
			<div class="nbtc-sec-center nbtc-col2">
				<div class="nbtc-sec-content content-readonly">
					<h2>รายละเอียดผู้ใช้ </h2>
					<div class="nbtc-content-options">
						<a href='UsrAdd.aspx?uid=<%=Request["UID"] %>' class="nbtc-btn nbtc-ic_edit"></a>
						<a href="javascript:delItem('spUR_Add','UID','<%=Request["UID"] %>')" class="nbtc-btn nbtc-btn-delete nbtc-ic_delete"></a>
					</div>
				
                	<div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">ประเภท</p>
								<p><asp:Label id=UType runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                   
					</div>

                     <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">ชื่อผู้ใช้(Login)</p>
								<p><asp:Label id=Login runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                        </div>
					

					
				

					<div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_input">
								<p class="nbtc-field-title">ชื่อ</p>
								<p><asp:Label id=FName runat=server></asp:Label></p>
							</div>
						</div>

						

						
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_input">
								<p class="nbtc-field-title">นามสกุล</p>
								<p><asp:Label id=LName runat=server></asp:Label></p>
							</div>
						</div>

						
						<div class="clear"></div>
					</div>
                    <div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_input">
								<p class="nbtc-field-title">ตำแหน่ง</p>
								<p><asp:Label id=Rank runat=server></asp:Label></p>
							</div>
						</div>
                        <div class="clear"></div>
					</div>
					<div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_input">
								<p class="nbtc-field-title">เบอร์โทรศัพท์</p>
								<p><asp:Label id=TelNo runat=server></asp:Label></p>
							</div>
						</div>
                        <div class="clear"></div>
					</div>

					<div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_input">
								<p class="nbtc-field-title">E-mail</p>
								<p><asp:Label id=Email runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
					
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

                    <div class="content-readonly">
                    <div class="nbtc-field nbtc-field_select">
                    <p class=nbtc-field-title>ส่วนการปฏิบัติงาน</p>
                   </div>
                   </div>
                    <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_checkbox">
								<label>
									<input id=IsAuthChk type="checkbox" runat=server onclick="return false;" />
									<span class="box"></span>
									<span class="nbtc-ic_check"></span>
									ผู้ปฏิบัติงาน/ผู้ตรวจสอบ
								</label>
							</div>
                            
							<div class="nbtc-field nbtc-field_checkbox">
								<label>
									<input id=IsAuthApv type="checkbox" runat=server onclick="return false;" />
									<span class="box"></span>
									<span class="nbtc-ic_check"></span>
									หัวหน้าผู้ตรวจสอบ
								</label>
							</div>
						
							<div class="nbtc-field nbtc-field_checkbox">
								<label>
									<input id=IsAuthAct type="checkbox" runat=server onclick="return false;" />
									<span class="box"></span>
									<span class="nbtc-ic_check"></span>
									รักษาการ
								</label>
							</div>
						
							<div class="nbtc-field nbtc-field_checkbox">
								<label>
									<input id=IsAuthDir type="checkbox" runat=server onclick="return false;" />
									<span class="box"></span>
									<span class="nbtc-ic_check"></span>
									ผู้อำนวยการ
								</label>
							</div>
						</div>

						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_checkbox">
								<label>
									<input id=IsEQMain type="checkbox" runat=server onclick="return false;" />
									<span class="box"></span>
									<span class="nbtc-ic_check"></span>
									ส่วนงานซ่อม
								</label>
							</div>
							</div>

						<div class="clear"></div>
					</div>
					 <div class="nbtc-row">
						<div class="nbtc-field nbtc-field_select">
                               <p class="nbtc-field-title">ลายเซ็น</p>
                            <div style="padding:10px;">
                                        <%=DSign %>
				 </div>
                               </div>
					</div>
					<div class="nbtc-group-btn">
						<a href='UsrAdd.aspx?uid=<%=Request["UID"] %>' class="nbtc-btn nbtc-btn-primary">แก้ไข</a>
						<a href="javascript:delItem('spUR_Add','UID','<%=Request["UID"] %>')" class="nbtc-btn nbtc-btn-secondary nbtc-btn-delete">ลบ</a>
					</div>
				</div>
			</div>
            </form>

			<div class="nbtc-sec-right nbtc-col1">
				<div class="nbtc-sec-grouppolicy">
					<h2>Group Policy</h2>
					<div id=GrpList class="nbtc-content">
						
					</div>
				</div>


				<div class="nbtc-sec-org">
					<h2>ORG</h2>
					<div id=OrgList class="nbtc-content">
						
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
