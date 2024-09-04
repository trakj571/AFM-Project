<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PrintPage.aspx.cs" Inherits="AFMProj.Print.PrintPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
      <!--#include file="../_inc/Title.asp"-->
     <script language=javascript>
         $(document).ready(function () {
             if (window.opener) {
                 $("#printPage").html(window.opener.$(".print-content").html() + "");
                 $("a").removeAttr("href");
             }
         });

         function printpage() {
             window.print();
         }
     </script>
     <style>
        @media print {
            .no-print {display:none}
        }
        
        .no-print-page {display:none}
     </style>
</head>
<body style='background:#fff'>
	<div class="container content-readonly">
  <br />
  <br />
  <br />

<table width=100%>
<tr><td align=center>
<table><tr><td width=1000 align=left>
<div id=printPage></div>
</td></tr></table></td></tr>

<tr><td align=center>
<br />
<div class="row no-print">
	<div class="col-md-12 text-center">
		<a onclick="javascript:printpage()" class="afms-btn afms-btn-secondary">
			<i class="afms-ic_print"></i> พิมพ์
		</a>
	</div>
</div>

</td></tr>
</table>
</div>
</body>
</html>
