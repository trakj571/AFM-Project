<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BData.aspx.cs" Inherits="EBMSMap.Web.SysCfg.BData" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <!--#include file="../_inc/title.A.asp"-->
     <script language=javascript>
        var _table = '<%=Request["table"] %>';
        var _selid = '<%=Request["selid"] %>';
        var _pselid = '<%=Request["pselid"] %>';
        var _pid = '<%=Request["pid"] %>';
        var _page = '<%=tbH.Rows[0]["page"]%>';
        var _kw = '<%=Request.QueryString["kw"]%>';
        $(document).ready(function () {
            $("#Kw").val(_kw);
            $("#Kw").onEnter(function () {
                searchKw();
            });
        });
        function searchKw() {
            location = "BData.aspx?table=" + _table + "&selid=" + _selid + "&kw=" + escape($("#Kw").val());
        }
        function selItem(id) {
            parent.$("#"+_selid).val(id);
            parent.$.fancybox.close();
        }
        function editItem1(id) {
            openDialog("BDataAdd.aspx?table="+_table+"&selid="+_selid+"&id="+id);
        }
        function delItem1(id, name) {
            swal({
              title: 'ต้องการลบข้อมูลนี้',
              text: "หากลบแล้วจะไม่สามารถกู้คืนได้",
              type: 'warning',
              showCancelButton: true,
              confirmButtonText: 'ลบ',
              cancelButtonText: 'ยกลิก',
              confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
              cancelButtonClass: 'nbtc-btn nbtc-btn-secondary',
            }).then(function () {
              $.ajax({
               type: 'POST',
               url: "data/delItem2.ashx",
               data: { table:_table,del:id,selid:_selid },
               cache: false,
               dataType: 'json',
               success: function (data) {
                   if(data.result=="OK"){
                       swal({
                        title: 'ลบข้อมูลสำเร็จ',
                        text: "ข้อมูลถูกลบแล้ว",
                        type: 'success',
                        confirmButtonText: 'ตกลง',
                        confirmButtonClass: 'nbtc-btn nbtc-btn-primary'
                      }).then(function () {
                        location.href = location.href;
                    });
                  }else{
                      swal({
                        title: 'ลบข้อมูลไม่สำเร็จ',
                        type: 'error',
                        confirmButtonText: 'ตกลง',
                        confirmButtonClass: 'nbtc-btn nbtc-btn-primary'
                      });
                  }
               },
               error: function (XMLHttpRequest, textStatus, errorThrown) {

               }
           });
              
       });
       }
    </script>

   
    
</head>
<body class="nbtc-admin">
	<div class="nbtc-container nbtc-config">
		<!--#include file="../_inc/hd.A.asp"-->

		<div class="nbtc-sec-breadcrumb">
			<ul>
				<li><a href=""><i class="nbtc-ic_home"></i></a> <i class="nbtc-ic_next"></i></li>
				<li><a href="">System Config</a> <i class="nbtc-ic_next"></i></li>
				<li>ข้อมูลพื้นฐาน</li>
			</ul>
            <!--#include file="../_inc/Usr.asp"-->
		</div>

		<div class="nbtc-col nbtc-group-col1">
			<div class="nbtc-sec-center nbtc-col4">
				<div class="nbtc-sec-content">

					<h2 class="text-center">ข้อมูลพื้นฐาน</h2>
                    
                    <div class="nbtc-group-btn" style='float:left'>
                         <a href="BData.aspx?table=tbRBW&selid=RBWID" class="nbtc-btn nbtc-btn-secondary" style="width: auto; max-width: inherit; padding: 10px 15px !important;"><%=getTableTH("tbRBW")%></a>
					 	
                    </div>
                    <div class="clear"></div>

					<div class="nbtc-config-title">
						<div class="nbtc-field nbtc-field_checkbox">
							<label>
								<%=LabelName %>
							</label>
						</div>
					</div>

					<table class="nbtc-table nbtc-table-responsive">
						<thead>
							<tr>
								<th style="width: 50px">ลำดับ</th>
								<th>รหัส</th>
								<th><%=LabelName%></th>
                                <th>Detail</th>
								<th></th>
                           </tr>
						</thead>
						<tbody>
                        <%for (int i = 0; i < tbD.Rows.Count; i++)
                          { %>
							<tr>
								<td data-th=""><%=GetNo(i) %></td>
								<td data-th=""><%=tbD.Rows[i]["code"]%></td>
								<td data-th=""><%=tbD.Rows[i]["name"]%></td>
								<td data-th=""><%=tbD.Rows[i]["Detail"]%></td>
								<td data-th=""><a href="javascript:editItem1('<%=tbD.Rows[i][Request["selid"]] %>')" class="nbtc-ic_edit"></a>
									    			<a href="javascript:delItem1('<%=tbD.Rows[i][Request["selid"]] %>')" class="nbtc-btn-delete nbtc-ic_delete"></a></td>
                               	</tr>
							<%} %>
						</tbody>
					</table>

                    <div style='float:left'>
                    <!--#include file="../_inc/Page.asp"-->

                    </div>
					<div class="nbtc-group-btn">
                         <button onclick="editItem1('0')" class="nbtc-btn nbtc-btn-secondary" style="width: auto; max-width: inherit; padding: 10px 15px !important;">เพิ่มข้อมูล</button>
					</div>
					<div class="clear"></div>

					


					
           
		</div>

	    <div class="push"></div>
	</div>

         <!--#include file="../_Inc/Ft.A.asp"-->


</body>
</html>
