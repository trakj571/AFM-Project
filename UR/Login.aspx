<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="EBMSMap30.UR.Login" %>

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
				<div class="afms-field afms-field_input">
					<input type="text" id="UserName" runat=server>
					<span class="bar"></span>
					<label for="">Username</label>
				</div>
                <asp:RequiredFieldValidator ID=rUserName ControlToValidate=UserName ForeColor=Red ErrorMessage="*" runat=server Display=Dynamic></asp:RequiredFieldValidator>
	
			</div>
			<div class="col-md-12">
				<div class="afms-field afms-field_input">
					<input type="password" id="Password" runat=server>
					<span class="bar"></span>
					<label for="">Password</label>
				</div>
                <asp:RequiredFieldValidator ID=rPassword ControlToValidate=Password ForeColor=Red ErrorMessage="*" runat=server Display=Dynamic></asp:RequiredFieldValidator>
	
			</div>
			<div class="col-md-12">
                <asp:Label ID=Rst Text="" runat=server Font-Size=Small></asp:Label>	
			
				<input type="submit" value="Login" class="afms-btn afms-btn-primary" runat=server onserverclick="bLogin_ServerClick" />
				<a href="../UR/FgtPwd.aspx">Forgot Password?</a>
			</div>
		</div>
	</div>
    </form>
</body>

</html>
