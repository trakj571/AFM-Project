<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="mFreqTB.aspx.cs" Inherits="AFMProj.DMS.mFreqTB" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
   <style>/*#FormSch {display:none}*/</style>
    <script language=javascript>
        $(function () {
           msgbox_save(<%=retID %>,"reload-parent");
        });


    </script>
</head>
<body class="body-no-bg">
	<div class="container">
        <form id=FormSch runat=server>
		<div class=row ">

			<div class="col-md-12">
				<div class="afms-content">
					<div class="afms-page-title is-online">
						ย่านความถี่
					</div>
              
					
					<div class="row">
                    <table width='100%'>
                    <tr><td>
						<div class="col-md-12">
							<div class="afms-field afms-field_input">
								<label>ความถี่เริ่มต้น (MHz)</label>
								<input id=fFreq runat=server type="text">
								<span class="bar"></span>
							</div>
                            <asp:RequiredFieldValidator ID=rfFreq ControlToValidate=fFreq InitialValue="" runat=server ErrorMessage="*<br /><br />" ForeColor=Red Display=Dynamic></asp:RequiredFieldValidator>
                            <asp:RangeValidator ID=rngfFreq ControlToValidate=fFreq Type=Double MinimumValue=0 MaximumValue=10000 runat=server ErrorMessage="*โปรดกรอกตัวเลข<br /><br />" ForeColor=Red Display=Dynamic></asp:RangeValidator>
                                            
                        </div>
                        </td><td>
						<div class="col-md-12">
							<div class="afms-field afms-field_input">
								<label>ความถี่สิ้นสุด (MHz)</label>
								<input id=tFreq runat=server type="text">
								<span class="bar"></span>
							</div>
                                  <asp:RequiredFieldValidator ID=rtFreq ControlToValidate=tFreq InitialValue="" runat=server ErrorMessage="*<br /><br />" ForeColor=Red Display=Dynamic></asp:RequiredFieldValidator>
                            <asp:RangeValidator ID=rngtFreq ControlToValidate=tFreq Type=Double MinimumValue=0 MaximumValue=10000 runat=server ErrorMessage="*โปรดกรอกตัวเลข<br /><br />" ForeColor=Red Display=Dynamic></asp:RangeValidator>
                     
						</div>
						</div>
                </td></tr>
                
                <tr><td>
						<div class="col-md-12">
							<div class="afms-field afms-field_input">
								<label>Channel Spacing/BW</label>
								<input id=ChSp runat=server type="text">
								<span class="bar"></span>
							</div>
                        </div>
                        </td><td>
						<div class="col-md-12">
							<div class="afms-field afms-field_input">
								<label>จำนวนช่องความถี่</label>
								<input id=nCh runat=server type="text">
								<span class="bar"></span>
							</div>
						</div>
						</div>
                </td></tr>

                </table>
					
					<div class="row">
						<div class="col-md-12 text-center">
                        <br />
                            <input type=submit id=bSave runat=server class="afms-btn afms-btn-primary" style='width:auto' value="บันทึก" onserverclick="bSave_ServerClick" />
							<a href="javascript:closeDialog()" class="afms-btn afms-btn-secondary"><i class="afms-ic_close"></i> ปิด</a>
						</div>
					</div>

					
				</div>

				 

					
				</div>
			</div>
		</div>
        </form>
		<div class="afms-push"></div>
	</div>
</body>

</html>
