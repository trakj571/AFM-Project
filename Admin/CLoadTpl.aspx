<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CLoadTpl.aspx.cs" Inherits="EBMSMap.Web.Admin.CLoadTpl" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <!--#include file="../_inc/title.A.asp"-->
    <script language=javascript>
     
        
    
    </script>
</head>
<body style='overflow-x:hidden'>
	<div class="nbtc-container nbtc-config">
    <form id="form1" runat="server">
    <div class="nbtc-modal">
			<div class="modal-dialog">
				<div class="modal-content content-readonly">
                <div class="nbtc-modal-header"> Template Detail</div>
									
                                    
                       <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">Template Name</p>
								<p><asp:Label id=Name runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                   
					</div>

                     

                        <div class="nbtc-row">
						<div class="nbtc-col2">
							<div class="nbtc-field nbtc-field_select">
								<p class="nbtc-field-title">Template Detail</p>
								<p><asp:Label id=Detail runat=server></asp:Label></p>
							</div>
						</div>

						<div class="clear"></div>
                        </div>

                              <h4>Field detail</h4>
					<table class="nbtc-table">
						<thead>
							<tr>
								<th>No.</th>
								<th>Field Name</th>
								<th>Label</th>
								<th>Header</th>
                                <th>Require</th>
								<th>Search</th>
                                <th></th>
							</tr>
						</thead>
						<tbody>
							<%
                                if(tbC!=null){
                                    for (int i = 0; i < tbC.Rows.Count; i++)
                                    {
                                        Response.Write("<tr id='tr" + i + "'>");
                                        Response.Write("<td class='no'>" + (i + 1) + "</td>");
                                        Response.Write("<td>" + tbC.Rows[i]["dataname"] + "<input class=colid type=hidden value='" + tbC.Rows[i]["ColID"] + "' /></td>");
                                        Response.Write("<td>" + tbC.Rows[i]["label"] + "</td>");
                                        Response.Write("<td>" + (tbC.Rows[i]["isHeader"].ToString()=="Y"?"Yes":"") + "</td>");
                                        Response.Write("<td>" + (tbC.Rows[i]["isRequire"].ToString()=="Y"?"Yes":"") + "</td>");
                                        Response.Write("<td>" + (tbC.Rows[i]["isSearch"].ToString() == "Y" ? "Yes" : "") + "</td>");
                                        Response.Write("<td class='btn'></td>");
                                        Response.Write("</tr>");
                                    }
                                }
                             %>
                            
								
							
						</tbody>
					</table>     

						<div class="nbtc-group-btn">
                        <input type=submit id=bSave value='นำไปใช้' runat=server onserverclick=bAdd_ServerClick class="nbtc-btn nbtc-btn-primary" />
						    <a href="javascript:closeDialog()" class="nbtc-btn nbtc-btn-secondary">ยกเลิก</a>
						</div>
						<div class="clear"></div>
					</div>
				</div>
			</div>
		</div>
    </form>
    </div>
    <script language=javascript>
        msgbox_save(<%=retID %>,"reload-parent");
    </script>

            <!--#include file="../_inc/Ft.P.asp"-->
</body>
</html>
