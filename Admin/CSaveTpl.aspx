<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CSaveTpl.aspx.cs" Inherits="EBMSMap.Web.Admin.CSaveTpl" %>

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
				<div class="modal-content">
                <div class="nbtc-modal-header"> Save to Template</div>
									
                                    
                        <div class="nbtc-row">
							<div class="nbtc-col4">
								<div class="nbtc-field nbtc-field_input">
									<input type="text" id=Name runat=server>
									<span class="bar"></span>
									<label>Template Name</label>
								</div>
                                        <asp:RequiredFieldValidator ID=rName ControlToValidate=Name runat=server ErrorMessage="*<br /><br />" ForeColor=Red Display=Dynamic></asp:RequiredFieldValidator>
						
							</div>

										
										

							<div class="clear"></div>
						</div>

                                   

						<div class="nbtc-group-btn">
                        <input type=submit id=bSave value='บันทึก' runat=server onserverclick=bSave_ServerClick class="nbtc-btn nbtc-btn-primary" />
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
