<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChgPwd.aspx.cs" Inherits="EBMSMap30.UR.ChgPwd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <!--#include file="../_Inc/Title.asp"-->
    <!--#include file="../_Inc/_libs.1.asp"-->
    <style>
        body{overflow:hidden}
        #form1 input[type=text],#form1 input[type=password]  {width:150px;}
        #form1 input[type=submit]{width:80px;height:30px;}
        #form1 input[type=button]{width:80px;height:30px;}
    </style>
</head>
<body>
    <%
        if (UID < 0 && UID!=-2)
        {
            Response.Write("<script language=javascript>alert('ชื่อล็อกอินไม่ถูกต้อง');</script>");
        }
     %>
    <form id="form1" runat="server">
    <div>
    <table width=100% bgcolor=#cccccc cellspacing=1 style='height:300px'>
           <tr bgcolor=#EC1B23><td align=center height=30><big style='color:White;font-size:18px'>เปลี่ยนรหัสผ่าน </big></td></tr>
        <tr bgcolor=#eedddd><td align=center valign=top><br /><br />
      
        <%if(UID>0){%>
			<br />
            <big style='color:Green'>ระบบทำการเปลี่ยนรหัสผ่านเรียบร้อยแล้ว</big> 
            <br /><br /><br />
            <input id=bClose type=button value="ปิด" onclick='parent.$.fancybox.close()' />
	        
	    <%}else{%>
            <%if(UID<0){%>
            <big style='color:Red'>คุณกรอกรหัสผ่านเดิมไม่ถูกต้อง</big> 
            <br /><br />
            <%}%>
            <table>
           <tr valign=baseline><td align=right>รหัสผ่านเดิม :<span style='color:red'>*</span> </td>
            <td align=left><input id=OPwd runat=server type=password  maxlength=20 /><br />
             <asp:RequiredFieldValidator Font-Size=9 id="rOPwd" ForeColor="Red" ControlToValidate=OPwd ErrorMessage="* โปรดกรอกรหัสผ่านเดิม" Runat=server Display=Dynamic></asp:RequiredFieldValidator>
        	</td></tr>

            <tr valign=baseline><td align=right>รหัสผ่านใหม่ :<span style='color:red'>*</span></td>
             <td align=left><input id=Pwd runat=server type=password  maxlength=20 /><br />
             <asp:RequiredFieldValidator Font-Size=9 id="rPwd" ForeColor="Red" ControlToValidate=Pwd ErrorMessage="* โปรดกรอกรหัสผ่านใหม่" Runat=server Display=Dynamic></asp:RequiredFieldValidator>
        	<asp:RegularExpressionValidator Font-Size=9 id="ePwd" ForeColor="Red" runat="server" ErrorMessage="* โปรดระบุเป็น A-Z,a-z,0-9 <br />ความยาว 5-20 ตัวอักษร"  Display=Dynamic ControlToValidate="Pwd" ValidationExpression="^([a-zA-Z0-9]{5,10})$"></asp:RegularExpressionValidator>

            <div style='color:blue'>(A-Z,a-z,0-9 ความยาว 5-10 ตัวอักษร)</div></td></tr>
            <tr valign=baseline><td align=right>ยืนยันรหัสผ่านใหม่  :<span style='color:red'>*</span></td>
             <td align=left><input id=CPwd runat=server type=password  maxlength=20 /><br />
             <asp:RequiredFieldValidator Font-Size=9 id="rCPwd" ForeColor="Red" ControlToValidate=CPwd ErrorMessage="* โปรดยืนยันรหัสผ่านใหม่" Runat=server Display=Dynamic></asp:RequiredFieldValidator>
	        <asp:CompareValidator Font-Size=9 id=cCPwd ForeColor="Red" ControlToValidate=CPwd ControlToCompare=Pwd Runat=server Display=Dynamic ErrorMessage="* ยืนยันรหัสผ่านไม่ถูกต้อง"></asp:CompareValidator>
	
           </td></tr>
            </table>

             <br /> <br />
            <input id=bSave type=submit value="ตกลง" runat=server onserverclick="bSave_Click" />
             <input id=bCancel type=button value="ยกเลิก" onclick='parent.$.fancybox.close()' />
           <%}%>  
       
        </td></tr>
    </table>
    </div>
    </form>
</body>
</html>
