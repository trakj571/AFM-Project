<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PrintChart.aspx.cs" Inherits="AFMProj.DMS.PrintChart" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!--#include file="../_inc/Title.asp"-->
    <script type="text/javascript">
        $(function () {
            if (window.opener) {

                $("#printContent").html(window.opener.$(".afms-content-1").html() + "");
                $("#printContent").append(window.opener.$(".afms-content-2").html() + "");
            }
        });
    
    </script>

    <style>
        @media print 
        {
            .no-print {display:none}
        }
        
                    .no-print-content {display:none}
        
      
     </style>

</head>
<body style='background:#fff'>
    <div style='width:100%'>
 
<div style='width:900px;margin:10px auto'>
    <h3>Data Monitoring System</h3>
    <br />
    <div id=printContent>
    
    </div>

    <div style='text-align:center' class=no-print>
    <br />
     <a href="javascript:window.print()" class="afms-btn afms-btn-secondary">
								        <i class="afms-ic_print"></i> พิมพ์
							        </a>
                                    <br />
    </div>
   </div>
   </div>
</body>
</html>
