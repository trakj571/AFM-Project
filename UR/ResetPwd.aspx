<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ResetPwd.aspx.cs" Inherits="EBMSMap30.UR.ResetPwd" %>

<!DOCTYPE html>

<html>
<head>
    

    <title></title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="format-detection" content="telephone=no">
	<link href="https://fonts.googleapis.com/css?family=Kanit:300,400,500,600&amp;subset=thai" rel="stylesheet">
	<link rel="stylesheet" href="../_inc/css/normalize.css">
	<link rel="stylesheet" href="../_inc/css/reset.css">
	<link rel="stylesheet" href="../_inc/css/bootstrap.css">
	<link rel="stylesheet" href="../_inc/css/style.css">
	<link rel="stylesheet" href="../_inc/css/responsive.css">

    <script src="../_inc/js/jquery-3.2.0.min.js"></script>
    <script src="../_inc/js/bootstrap.js"></script>
    <script src="../_inc/js/function.js"></script>
    

   
</head>

<body class="afms-page-login">
<form id="form1" runat="server">
	<div class="afms-sec-header">
		<img src="../img/logo.png">
		<div class="afms-header-text">
			<h1><span>NBTC AUTOMATIC FREQUENCY</span> MONITORING SYSTEM</h1>
			<h2>สำนักงานคณะกรรมการกิจการกระจายเสียง กิจการโทรทัศน์ และกิจการโทรคมนาคมแห่งชาติ</h2>
		</div>
	</div>
	
	<div class="afms-sec-login">
		<div class="row">
			<div class="col-md-12">
            <h3>Reset Password</h3>
            <br />
            <br />
            <%if (retCode == 1)
                   { %>
                 เปลี่ยนรหัสผ่านเรียบร้อยแล้ว  กลับหน้าหลัก <a href='Login.aspx'>Login</a> 
                <br />

                 <%}else if(retCode<0){ %>

                 * ข้อมูลผิดพลาด กรุณาลองอีกครั้ง <a href='FgtPwd.aspx'>ลืมรหัสผ่าน</a>
                 <br />
            <br />
                 <%}%>
                 </div>
                  <%if (retCode == 0){%>
                 <div class="col-md-12">
				    <div class="afms-field afms-field_input">
						<input id=Pwd type=password  runat=server placeholder="">
							    <span class="bar"></span>
                                
								<label>รหัสผ่านใหม่</label>
                        	</div>
                             <asp:RequiredFieldValidator id=rPwd1 ForeColor="Red" ControlToValidate="Pwd" ErrorMessage="* โปรดกรอกรหัสผ่าน<br /><br />" Runat=server Display=Dynamic></asp:RequiredFieldValidator>
                             </div>
                            
                             <div class="col-md-12">
				  
                            <div class="afms-field afms-field_input">
				
                           <input id=CPwd type=password  runat=server placeholder="">
							    <span class="bar"></span>
                                
								<label>กรอกรหัสผ่านอีกครั้ง</label>
                        	</div>
                           <asp:RequiredFieldValidator id="rCPwdR" ForeColor="Red" ControlToValidate=CPwd ErrorMessage="* โปรดกรอกรหัสผ่านใหม่ให้ตรงกัน<br /><br />" Runat=server Display=Dynamic></asp:RequiredFieldValidator>
	                    <asp:CompareValidator id=cCPwdR ForeColor="Red" ControlToValidate=CPwd ControlToCompare=Pwd Runat=server Display=Dynamic ErrorMessage="* โปรดกรอกรหัสผ่านใหม่ให้ตรงกัน<br /><br />"></asp:CompareValidator>
	                   </div>
                       
                                    <%} %>
			</div>

			<%if (retCode == 0)
     {%>
			<div class="col-md-12">
                <asp:Label ID=Rst Text="" runat=server Font-Size=Small></asp:Label>	
			
				<input id="bConfirm" type="submit" value="Confirm" class="afms-btn afms-btn-primary" runat=server onserverclick="bConfirm_ServerClick" />
			</div>
            <%} %>

             <div class="col-md-12">
            <a href="../UR/Login.aspx">กลับหน้าหลัก</a>
            </div>
		</div>
	    </form>
</body>

</html>
