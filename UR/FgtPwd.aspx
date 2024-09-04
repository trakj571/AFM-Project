<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FgtPwd.aspx.cs" Inherits="EBMSMap30.UR.FgtPwd" %>

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
      <link rel="stylesheet" href="../_inc/css/sweetalert2.css">
   
    <script src="../_inc/js/jquery-3.2.0.min.js"></script>
    <script src="../_inc/js/bootstrap.js"></script>
    <script src="../_inc/js/function.js"></script>
    
    <script type="text/javascript" src="../_inc/js/core.js"></script>
    <script type="text/javascript" src="../_inc/js/sweetalert2.js"></script>

    <script language=javascript>
        $(function () {
            $(document).on('click', '.fgtSms', function () {
                location = "../UR/OTPPwd.aspx?u=" + $("#UserName").val();
                swal.clickCancel();

            });
            $(document).on('click', '.fgtEmail', function () {
                location = "../UR/FgtPwd.aspx?u=" + $("#UserName").val();
                swal.clickCancel();
            });
        });

        function fgtSelType() {
            swal({
                title: 'OTP',
                html: "กรุณาเลือกชนิดของการส่ง One Time Password" +
                "<br><br>" +
                '<button type="button" role="button" tabindex="0" class="fgtSms afms-btn afms-btn-secondary">' + 'SMS' + '</button> &nbsp; ' +
                '<button type="button" role="button" tabindex="0" class="fgtEmail afms-btn afms-btn-secondary">' + 'Email' + '</button>',
                showCancelButton: false,
                showConfirmButton: false
            });

            return false
        }
    
    </script>
   
</head>

<body class="afms-page-login">
<form id="form1" runat="server" onsubmit="return fgtSelType()">
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
            <h3>Forgot Password</h3>
            <br />
            <br />
            <%if (retCode == 1)
                   { %>
                 ขณะนี้ระบบส่ง E-mail ให้คุณเรียบร้อยแล้ว<br />
                 กรุณาตรวจสอบอีเมลในกล่อง Inbox ของคุณ (หากยังไม่พบในทันที กรุณารอสักครู่) จากนั้นให้คลิก Link ที่ได้รับ เพื่อทำการกรอกรหัสผ่านใหม่<br />
                 <br />
                 รอเกิน 5 นาทีแล้ว ? แต่ยังไม่ได้รับ E-mail กรุณาลองอีกครั้ง <a href='FgtPwd.aspx'>Forgot Password?</a> <br />
            <br />

                 <%}else if(retCode<0){
                     if (retCode == -2)
                   { %>
                   * User AD ไม่สามารถแก้ไขได้
                    <%}else{ %>

                    * ไม่พบอีเมลในระบบ โปรดติดต่อเจ้าหน้าที่
                    <%} %>
                 <br />
            <br />
                 <%}else{ %>

				<div class="afms-field afms-field_input">
					<input type="text" id="UserName" runat=server>
					<span class="bar"></span>
					<label for="">Username</label>
				</div>
                <asp:RequiredFieldValidator ID=rUserName ControlToValidate=UserName ForeColor=Red ErrorMessage="*" runat=server Display=Dynamic></asp:RequiredFieldValidator>
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
	</div>
    </form>
</body>

</html>
