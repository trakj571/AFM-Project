<table width=90%><tr><td align=left>
User : <%=EBMSMap.Web.cUsr.FullName%><br><br>

<%if(EBMSMap.Web.cUsr.Grp=="A"){%>
&raquo; <a href='../Admin/ListUsr.aspx'>List User</a><br>
&raquo; <a href='../Admin/ListOrg.aspx'>Oranization & Project</a><br>
&raquo; <a href='../Admin/ListTPL.aspx'>Templete</a><br>
&raquo; <a href='../Report/'>Report</a><br>
&raquo; <a href='../Admin/Log.aspx'>Activity Logs</a><br>
<!--&raquo; <a href='../Report'>Report</a><br>
&raquo; <a href='../UR/ChgPwd.aspx'>Change Password</a><br-->
&raquo; <a href='../UR/Logout.aspx'>Log out</a>

<%}%>
</td></tr></table>