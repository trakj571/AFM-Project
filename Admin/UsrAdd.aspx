<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UsrAdd.aspx.cs" Inherits="EBMSMap.Web.Admin.UsrAdd" %>

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
            });
            $("#OrgList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetOrgs(OrgID.Value) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                $("#OrgID").val(data.node.id);
            });

            $('.nbtc-field_select select').selectpicker();
            $('.nbtc-field_datepicker input').datepicker({
                orientation: "bottom left"
            });
            UTYpeChange();
        });

        function UTYpeChange(){
            if($("#UType").val()=="NBTC")
                $(".pwd").hide();
            else
                $(".pwd").show();
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
				</div>
			</div>
            <form id=Form1 runat=server>
            <input id=OrgID runat=server type=hidden />
            <input id=UGID runat=server type=hidden />
			<div class="nbtc-sec-center nbtc-col2">
				<div class="nbtc-sec-content">
					<h2>Add User</h2>
					
					<div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<select id=UType runat=server onchange=UTYpeChange()>
									<option value="NBTC">NBTC</option>
                                    <option value="Other">OTHER</option>
								</select>
								<span class="bar"></span>
								<label>ประเภท</label>
							</div>
						</div>

						<div class="clear"></div>
					</div>
                    <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_input">
                            
								<input id=Login type="text" runat=server>
							    <span class="bar"></span>
                                
								<label>ชื่อผู้ใช้(Login)
                                
                                </label>
                        	</div>
                            <asp:RequiredFieldValidator ID=rLogin ControlToValidate=Login runat=server ErrorMessage="*<br /><br />" ForeColor=Red Display=Dynamic></asp:RequiredFieldValidator>
							<asp:RegularExpressionValidator Enabled=false Font-Size=9 id="eLogin" ForeColor="Red" runat="server" ErrorMessage="* โปรดระบุเป็น A-Z,a-z,0-9 ความยาว 4-10 ตัวอักษร<br /><br />"  Display=Dynamic ControlToValidate="Login" ValidationExpression="^([a-zA-Z0-9]{4,10})$"></asp:RegularExpressionValidator>

						</div>

						<div class="nbtc-col2 pwd">
							<div class="nbtc-field nbtc-field_input">
								<input id=Pwd type="text" runat=server placeholder="********">
								<span class="bar"></span>
								<label>รหัสผ่าน</label>
								
							</div>
                            <asp:CustomValidator ID="rPwd"  ForeColor="Red" Runat=server Display=Dynamic ErrorMessage="*<br /><br />" EnableClientScript=True ClientValidationFunction=CheckPwd OnServerValidate="CheckPwdSrv"></asp:CustomValidator>
                            <asp:RegularExpressionValidator Font-Size=9 id="ePwdR" ForeColor="Red" runat="server" ErrorMessage="* โปรดระบุเป็น A-Z,a-z,0-9,ตัวอักขระพิเศษ ความยาว 4-10 ตัวอักษร<br /><br />"  Display=Dynamic ControlToValidate="Pwd" ValidationExpression="^([a-zA-Z0-9.*$@$!%*#?&]{4,11})$"></asp:RegularExpressionValidator>

						</div>

						<div class="clear"></div>
                        </div>
					
					

					<div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_input">
								<input id=FName type="text" runat=server>
								<span class="bar"></span>
								<label>ชื่อ</label>
							</div>
                               <asp:RequiredFieldValidator ID=rFName ControlToValidate=FName runat=server ErrorMessage="*<br /><br />" ForeColor=Red Display=Dynamic></asp:RequiredFieldValidator>
						
						</div>

						
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_input">
								<input id=LName type="text" runat=server>
								<span class="bar"></span>
								<label>นามสกุล</label>
							</div>
                                    <asp:RequiredFieldValidator ID=rLName ControlToValidate=LName runat=server ErrorMessage="*<br /><br />" ForeColor=Red Display=Dynamic></asp:RequiredFieldValidator>
						
						</div>

						

						<div class="clear"></div>
					</div>
                    <div class="nbtc-row">
						<div class="nbtc-col1">
							<div class="nbtc-field nbtc-field_input">
								<input id=Rank type="text" runat=server>
								<span class="bar"></span>
								<label>ตำแหน่ง</label>
							</div>
						</div>
                        <div class="clear"></div>
					</div>
					<div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_input">
								<input id=TelNo type="text" runat=server>
								<span class="bar"></span>
								<label>เบอร์โทรศัพท์</label>
							</div>
						</div>
                        <div class="clear"></div>
					</div>
                    <div class="nbtc-row">
					
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_input">
								<input id=Email type="text" runat=server>
								<span class="bar"></span>
								<label>E-mail</label>
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
                    <div class="content-readonly">
                    <div class="nbtc-field nbtc-field_select">
                    <p class=nbtc-field-title>ส่วนการปฏิบัติงาน</p>
                   </div>
                   </div>
                    <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_checkbox">
								<label>
									<input id=IsAuthChk type="checkbox" runat=server />
									<span class="box"></span>
									<span class="nbtc-ic_check"></span>
									ผู้ปฏิบัติงาน/ผู้ตรวจสอบ
								</label>
							</div>
                            
							<div class="nbtc-field nbtc-field_checkbox">
								<label>
									<input id=IsAuthApv type="checkbox" runat=server />
									<span class="box"></span>
									<span class="nbtc-ic_check"></span>
									หัวหน้าผู้ตรวจสอบ
								</label>
							</div>
						
							<div class="nbtc-field nbtc-field_checkbox">
								<label>
									<input id=IsAuthAct type="checkbox" runat=server />
									<span class="box"></span>
									<span class="nbtc-ic_check"></span>
									รักษาการ
								</label>
							</div>
						
							<div class="nbtc-field nbtc-field_checkbox">
								<label>
									<input id=IsAuthDir type="checkbox" runat=server />
									<span class="box"></span>
									<span class="nbtc-ic_check"></span>
									ผู้อำนวยการ
								</label>
							</div>
						</div>
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_checkbox">
								<label>
									<input id=IsEQMain type="checkbox" runat=server />
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
                       
							<input id="File1" type="file" runat="server" style='width:80%' />
                               <span class="bar"></span>
								<label></label>
							</div>

				            
                           
                             
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
