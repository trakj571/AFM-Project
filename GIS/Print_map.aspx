<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Print_map.aspx.cs" Inherits="EBMSMap30.Print_map" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
     <!--#include file="_Inc/Title.asp"-->
     <link rel="stylesheet" href="libs/style.css" />
     <link rel="stylesheet" href="libs/leaflet-0.6.4/leaflet.css" />
     <!--[if lte IE 8]>
         <link rel="stylesheet" href="libs/leaflet-0.6.4/leaflet.ie.css" />
     <![endif]-->
     <script src="libs/jquery.js"></script>
     <style>
        #printMap {overflow:hidden;position:relative}
        #print_but_div {text-align:right;margin-top:20px}
        #print_but {width:80px;height:30px}
        @media screen {
          #print_but_div {display:block}
        }
        @media print{
          #print_but_div {display:none}
        }

        
     </style>
     <script language=javascript>
         $(document).ready(function () {
             if (window.opener) {
                 $("#printMap").html(window.opener.getMapHtml() + "");
                 $("#maptoolctl").hide();
                 $("#maptypectl").hide();
                 $(".leaflet-control-zoom").hide();
                 $("#printMap").css("width", window.opener.$("#map").width() + "px");
                 $("#printMap").css("height", window.opener.$("#map").height() + "px");
                 $("#print_but_div").css("width", $("#printMap").width() + "px");
             }
         });
     </script>
</head>
<body>
<br />
<table width=100%>
<tr><td align=center>
<table style='border:1px solid #777'><tr valign=top><td style='padding-left:50px;height:60px'><!--img src='../images/printmap/hd_L.jpg' width=500 height=60 /--></td><td align=right style='padding-right:50px;'><!--img src='../images/printmap/hd_r.png' width=100 /--></td></tr>
<tr><td colspan=2 style='padding-left:60px;padding-right:60px;padding-bottom:70px;'><div id=printMap style='border:1px solid #777'></div></td></tr>
</table>
</td></tr>
<tr><td align=center>
<div id=print_but_div>
<input id=print_but type=button onclick="print()" value=" Print " />
</div>
</td></tr>
</table>

</body>
</html>
