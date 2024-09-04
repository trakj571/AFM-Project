<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DivSch.aspx.cs" Inherits="EBMSMap30.UR.DivSch" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <!--#include file="../_Inc/Title.asp"-->
    <!--#include file="../_Inc/_libs.1.asp"-->
    <!--#include file="_Page.asp"-->
    <script language=javascript>
        $(document).ready(function () {
            $("#Kw").bind("keypress", {}, function (e) {
                var code = (e.keyCode ? e.keyCode : e.which);
                if (code == 13) {
                    e.preventDefault();
                    location = "DivSch.aspx?kw=" + escape($("#Kw").val());
                }
            });
        });

        function selItem(id) {
            parent.$("#DivID").val(id);
            parent.$.fancybox.close();
        }
        function editItem(id) {
            location = "DivAdd.aspx?divid="+id;
        }
        function delItem(id, name) {
            $.msgBox({ title: "PORT - PMS", content: "ลบข้อมูล '" + name + "'?", type: "confirm", buttons: [{ value: "Yes" }, { value: "No"}],
                success: function (result) {
                    if (result == "Yes") {
                        //parent.$("#RdID").val(id);
                        parent.$("#DivID option[value='"+id+"']").each(function() {
                            $(this).remove();
                        });
                        location = "DivSch.aspx?del=" + id + "&pg=<%=tbH.Rows[0]["page"]%>&kw=<%=Request.QueryString["kw"]%>";
                    }
                }
            }); 
        }
    </script>
    <style>
    .tableDlg  tr:first-child {background:url('../images/content_00_03_bg.png') repeat-x!important;height:30px;}
.tableDlg tr:first-child > td {border-bottom:1px solid #777}
.tableDlg tr:nth-child(even) {background: #EEE}
.tableDlg tr:nth-child(odd) {background: #FFF}
.tableDlg td {padding-left:15px;text-align:left}
.tableDlg a {text-decoration:none}
.hdDlg {font-weight:bold;text-align:center;line-height:35px;background:url('../images/menu_01_06.png');color:White;padding-right:28px}
.pageDlg {margin-top:3px;font-size:12px}
.pageDlg span{color:#777;padding:2px 5px 2px 5px;border: 1px solid #ccc;border-radius: 5px;}
.pageDlg em {color:#777;padding:2px 5px 2px 5px;border: 1px solid #ccc;border-radius: 5px;}
.pageDlg a {text-decoration:none;padding:2px 5px 2px 5px;border: 1px solid #ccc;border-radius: 5px;}
.backDlg {float:left;margin:8px 0 0 8px}
    </style>
</head>
<body>
    <form id="form1" onsubmit="return false">
    <div>
    <div class=hdDlg>หน่วยงาน</div>
    <br />
    <table width=100%><tr><td width=60%>

    <% WritePageLink(); %>
    </td><td align=right><div class=SEARCH><input id=Kw type=text value="<%=Kw %>" placeholder="ค้นหา" /></div></td></tr></table>
    <%
        if (tbH != null)
        {
            Response.Write("<table cellspacing=0 cellpadding=4 width='100%' class=tableDlg>");
            Response.Write("<tr>");
            Response.Write("<td width='30'>ลำดับ</td>");
            Response.Write("<td width='50'>รหัส</td>");
            Response.Write("<td width='150'>ชื่อหน่วยงาน</td>");
           // Response.Write("<td width='100'></td>");
            Response.Write("</tr>");
            int pgSize = Convert.ToInt32(tbH.Rows[0]["pageSize"]);
            int cPage = Convert.ToInt32(tbH.Rows[0]["page"]);
            for (int i = 0; i < tbB.Rows.Count; i++)
            {
                Response.Write("<tr bgcolor=#ffffff>");
                Response.Write("<td>" + (pgSize * (cPage-1)+i + 1) + "</td>");
                Response.Write("<td><a href=\"javascript:selItem('"+tbB.Rows[i]["DivID"]+"')\">" + tbB.Rows[i]["SubCode"] + "</a></td>");
                Response.Write("<td><a href=\"javascript:selItem('"+tbB.Rows[i]["DivID"]+"')\">" + tbB.Rows[i]["Name"] + "</a></td>");
                //Response.Write("<td><a href=\"javascript:editItem('"+tbB.Rows[i]["DivID"]+"')\">แก้ไข</a> &nbsp;<a href=\"javascript:delItem('"+tbB.Rows[i]["DivID"]+"','" + tbB.Rows[i]["Name"].ToString().Replace("'","") + "')\">ลบ</a> </td>");
                Response.Write("</tr>");
            }

           
            Response.Write("</table>");
        }

         %>
         <table width=100%><tr><td width=60%>

    <% WritePageLink(); %>
    </td><td align=right><%=tbH.Rows[0]["nTotal"] %> รายการ&nbsp;</td></tr></table>
    </div>
    </form>
    
</body>
</html>
