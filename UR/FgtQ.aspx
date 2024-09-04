<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FgtQ.aspx.cs" Inherits="EBMSMap30.UR.FgtQ" %>

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
    <script language=javascript>
        function closefancyBox() {
            if (parent) {
                parent.postMessage("closefancybox", "*");
            }
        }
    </script>
</head>
<body>
    <%
        if (UID < 0 && UID!=-2)
        {
            Response.Write("<script language=javascript>alert('คำตอบไม่ถูกต้อง');</script>");
        }
     %>
    <form id="form1" runat="server">
    <div>
    <table width=100% bgcolor=#cccccc cellspacing=1 style='height:300px'>
         <tr bgcolor=#EC1B23><td align=center height=30><big style='color:White;font-size:18px'>ลืมรหัสผ่าน </big></td></tr>
        <tr bgcolor=#eedddd><td align=center valign=top><br /><br />
        <%if(UID>0||UID==-2){%>
			<br />
            <big style='color:Blue'>ระบบทำการส่งรหัสผ่านใหม่ไปยังอีเมล์ของคุณเรียบร้อยแล้ว <br />(<%=dtFgt%>)</big> 
            <br /><br /><br />
            <input id=bClose type=button value="ปิด" onclick='closefancyBox()' />
	        
	    <%}else{%>
            <table>
           <tr valign=baseline><td align=right>รหัสผู้ใช้ : &nbsp; </td>
            <td align=left><asp:label id=lbLogin runat=server Font-Bold=true ></asp:label></td></tr>
           
            <tr valign=baseline><td align=right>คำถาม : &nbsp; </td>
            <td align=left><asp:label id=lbFgtQ runat=server  Font-Bold=true></asp:label><br />
            </td></tr>
            <tr valign=baseline><td align=right>คำตอบ :<span style='color:red'>*</span> </td>
            <td align=left><input id=FgtA runat=server type=text  maxlength=50 /><br />
            </td></tr>
            </table>

             <br /> <br />
            <input id=bSave type=submit value="ตกลง" runat=server onserverclick="bSave_Click" />
             <input id=bCancel type=button value="ยกเลิก" onclick='closefancyBox()' />
           <%}%>  
       
        </td></tr>
    </table>
    </div>
    </form>
</body>
</html>
