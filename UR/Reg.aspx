<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reg.aspx.cs" Inherits="EBMSMap30.UR.Reg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <!--#include file="../_Inc/Title.asp"-->
    <!--#include file="../_Inc/_libs.1.asp"-->
    <style>
        body{overflow-x:hidden}
        #form1 input[type=text],#form1 input[type=password]  {width:150px;}
        #form1 input[type=submit]{width:80px;height:30px;}
        #form1 input[type=button]{width:80px;height:30px;}
    </style>
     <style type="text/css">
        select,
        option {
             white-space: pre;
        }
    </style>
    <script language=javascript>
        function schDlg(url) {
            $.fancybox(url, {
                'width': 400,
                'height': 400,
                'autoScale': false,
                'transitionIn': 'none',
                'transitionOut': 'none',
                'type': 'iframe'
            });
        }   
        function closefancyBox() {
            if (parent) {
                parent.postMessage("closefancybox", "*");
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <table width=100% bgcolor=#cccccc cellspacing=1 style='height:500px'>
        <tr bgcolor=#1E7DD9><td align=center height=30><big style='color:White;font-size:18px'>ลงทะเบียนใหม่</big></td></tr>
        <tr bgcolor=#A1C1E3><td align=center valign=top><br /><br />

        <%
		    if(UID==-3){
                Response.Write("<script language=javascript>alert('รหัสพนักงาน " + Login.Value + " มีอยู่แล้วในระบบ โปรดใช้รหัสพนักงานอื่น')</" + "script>");	
		    }
		    else if(UID==-4){
				    Response.Write("<script language=javascript>alert('อีเมล์ "+Email.Value+" มีอยู่แล้วในระบบ โปรดใช้อีเมล์อื่น')</"+"script>");	
		    }
	    %>



        <table  cellpadding=5>
        
        <tr valign=baseline><td align=right>ชื่อ-นามสกุล :<span style='color:red'>*</span></td>
            <td align=left><input id=FLName runat=server type=text maxlength=100 /><br />
               <asp:RequiredFieldValidator Font-Size=9 id=rFLName ForeColor="Red" ControlToValidate=FLName ErrorMessage="* โปรดกรอกชื่อ-นามสกุล" Runat=server Display=Dynamic></asp:RequiredFieldValidator>
		    </td></tr>
        <tr valign=baseline><td align=right>อีเมล์ :<span style='color:red'>*</span> </td>
            <td align=left><input id=Email runat=server type=text  maxlength=80 /><br />
            <asp:RequiredFieldValidator Font-Size=9 id="rEmail" ForeColor="Red" ControlToValidate=Email ErrorMessage="* โปรดกรอกอีเมล์" Runat=server Display=Dynamic></asp:RequiredFieldValidator>
	        <asp:RegularExpressionValidator Font-Size=9 id=eEmail ForeColor="Red" ControlToValidate=Email Runat=server Display=Dynamic ErrorMessage="* อีเมล์ไม่ถูกต้อง" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
	
            </td></tr>
             <tr valign=baseline><td align=right>เบอร์โทรศัพท์ : &nbsp; </td>
            <td align=left><input id=TelNo runat=server type=text  maxlength=50 /></td></tr>

        <tr valign=baseline><td align=right>ตำแหน่ง : &nbsp; </td>
            <td align=left><input id=Rank runat=server type=text  maxlength=50 /></td></tr>

           
             <tr valign=baseline><td align=right>หน่วยงาน : &nbsp; </td>
            <td align=left><select id=DivID runat=server style='width:150px'></select>  &nbsp; <!--a href="javascript:schDlg('DivSch.aspx');" ><img src='../images/search.png' /></a--><br /><br />
             <asp:RequiredFieldValidator Font-Size=9 id="rDivID" ForeColor="Red" ControlToValidate=DivID InitialValue="0" ErrorMessage="* โปรดเลือกหน่วยงาน" Runat=server Display=Dynamic></asp:RequiredFieldValidator>
	       </td></tr>
        
        <tr valign=baseline><td align=right>รหัสพนักงาน :<span style='color:red'>*</span> </td>
            <td align=left><input id=Login runat=server type=text  maxlength=20 /><br />
             <asp:RequiredFieldValidator Font-Size=9 id="rLogin" ForeColor="Red" ControlToValidate=Login ErrorMessage="* โปรดกรอกชื่อล็อกอิน" Runat=server Display=Dynamic></asp:RequiredFieldValidator>
        	<asp:RegularExpressionValidator Font-Size=9 id="eLogin" ForeColor="Red" runat="server" ErrorMessage="* โปรดระบุเป็น A-Z,a-z,0-9 <br />ความยาว 5-20 ตัวอักษร"  Display=Dynamic ControlToValidate="Login" ValidationExpression="^([a-zA-Z0-9]{5,10})$"></asp:RegularExpressionValidator>

            <div style='color:blue'>(A-Z,a-z,0-9 ความยาว 5-10 ตัวอักษร) </div></td></tr>
        <tr valign=baseline><td align=right>รหัสผ่าน :<span style='color:red'>*</span></td>
             <td align=left><input id=Pwd runat=server type=password  maxlength=20 /><br />
             <asp:RequiredFieldValidator Font-Size=9 id="rPwd" ForeColor="Red" ControlToValidate=Pwd ErrorMessage="* โปรดกรอกรหัสผ่าน" Runat=server Display=Dynamic></asp:RequiredFieldValidator>
        	<asp:RegularExpressionValidator Font-Size=9 id="ePwd" ForeColor="Red" runat="server" ErrorMessage="* โปรดระบุเป็น A-Z,a-z,0-9 <br />ความยาว 5-20 ตัวอักษร"  Display=Dynamic ControlToValidate="Pwd" ValidationExpression="^([a-zA-Z0-9]{5,10})$"></asp:RegularExpressionValidator>

            <div style='color:blue'>(A-Z,a-z,0-9 ความยาว 5-10 ตัวอักษร)</div></td></tr>
        <tr valign=baseline><td align=right>ยืนยันรหัสผ่าน  :<span style='color:red'>*</span></td>
         <td align=left><input id=CPwd runat=server type=password  maxlength=20 /><br />
         <asp:RequiredFieldValidator Font-Size=9 id="rCPwd" ForeColor="Red" ControlToValidate=CPwd ErrorMessage="* โปรดยืนยันรหัสผ่าน" Runat=server Display=Dynamic></asp:RequiredFieldValidator>
	    <asp:CompareValidator Font-Size=9 id=cCPwd ForeColor="Red" ControlToValidate=CPwd ControlToCompare=Pwd Runat=server Display=Dynamic ErrorMessage="* ยืนยันรหัสผ่านไม่ถูกต้อง"></asp:CompareValidator>
	
           </td></tr>
      <tr valign=baseline><td align=right>คำถามกันลืม :<span style='color:red'>*</span> </td>
            <td align=left><input id=FgtQ runat=server type=text  maxlength=50 /><br />
                   <asp:RequiredFieldValidator Font-Size=9 id=rFgtQ ForeColor="Red" ControlToValidate=FgtQ ErrorMessage="* โปรดกรอกคำถามกันลืม" Runat=server Display=Dynamic></asp:RequiredFieldValidator>
		    </td></tr>

            <tr valign=baseline><td align=right>คำตอบ :<span style='color:red'>*</span> </td>
            <td align=left><input id=FgtA runat=server type=text  maxlength=50 /><br />
                   <asp:RequiredFieldValidator Font-Size=9 id=rFgtA ForeColor="Red" ControlToValidate=FgtA ErrorMessage="* โปรดกรอกคำตอบ" Runat=server Display=Dynamic></asp:RequiredFieldValidator>
		 </td></tr>
        </table>
        <br />
        <input id=bSave type=submit value="บันทึกข้อมูล" runat=server onserverclick="bSave_Click" />
        <input id=bCancel type=button value="ยกเลิก" onclick='closefancyBox()' />
        <br />
        <br />
        <br />
        </td></tr>
    </table>
    </div>
    </form>
</body>
</html>
