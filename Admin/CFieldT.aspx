<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CFieldT.aspx.cs" Inherits="EBMSMap.Web.Admin.CFieldT" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <!--#include file="../_inc/title.A.asp"-->
    <script language=javascript>
        function setOption(t) {
            if (t == "S") {
                document.getElementById("Options").disabled = false;
            } else {
                document.getElementById("Options").disabled = true;
            }
        }
        function setIType(d, s) {
            var c = document.getElementById("InputType");
            while (c.options.length > 0) {
                c.options[(c.options.length - 1)] = null;
            }

            if (d == "I" || d == "T") {
                c.options[0] = new Option("Text", "T");
                c.options[0].selected = s == "T";
                c.options[1] = new Option("Select", "S");
                c.options[1].selected = s == "S";
            }
            if (d == "P") {
                c.options[0] = new Option("Picture", "P");
                c.options[0].selected = s == "P";
            }
            if (d == "V") {
                c.options[0] = new Option("Video", "V");
                c.options[0].selected = s == "V";
            }
            if (d == "L") {
                c.options[0] = new Option("Link", "L");
                c.options[0].selected = s == "L";
            }
            if (d == "D") {
                c.options[0] = new Option("Date", "D");
                c.options[0].selected = s == "D";
            }
             if (d == "C") {
                c.options[0] = new Option("Checkbox", "C");
                c.options[0].selected = s == "C";
            }
             $('#InputType').selectpicker('refresh');
        }

        function cfmDel(){
             delItem('spCon_AddCols','ColID','<%=Request["ColID"] %>',true,true);
        }
        $(document).ready(function () {
            setIType(document.getElementById("DataType").value, document.getElementById("InputTypeH").value);
            <%
            if(IsOK){
                Response.Write("msgbox_save(1,'reload-parent');");
            }
         %>
        });
        
    
    </script>
</head>
<body style='overflow-x:hidden'>
	<div class="nbtc-container nbtc-config">
    <form id="form1" runat="server">
    <div class="nbtc-modal">
						<div class="modal-dialog">
							<div class="modal-content">
                            <div class="nbtc-modal-header">Add Field</div>
									
                                    
                                    <div class="nbtc-row">
										<div class="nbtc-col2">
											<div class="nbtc-field nbtc-field_input">
												<input type="text" id=DataName runat=server>
												<span class="bar"></span>
												<label>DataName</label>
											</div>
                                                  <asp:RequiredFieldValidator ID=rDataName ControlToValidate=DataName runat=server ErrorMessage="*<br /><br />" ForeColor=Red Display=Dynamic></asp:RequiredFieldValidator>
						
										</div>

										
										<div class="nbtc-col2">
											<div class="nbtc-field nbtc-field_input">
												<input type="text" id=Label runat=server>
												<span class="bar"></span>
												<label>Label</label>
											</div>
                                                  <asp:RequiredFieldValidator ID=rLabel ControlToValidate=Label runat=server ErrorMessage="*<br /><br />" ForeColor=Red Display=Dynamic></asp:RequiredFieldValidator>
						
										</div>

										<div class="clear"></div>
									</div>

									<div class="nbtc-row">
										<div class="nbtc-col2">
											<div class="nbtc-field nbtc-field_select">
												  <select id=DataType runat=server onchange="setIType(this.value)">
                                                        <option value="T">Text</option>
                                                        <option value="I">Integer</option>
                                                        <option value="D">Date</option>
                                                        <option value="C">Checkbox</option>
                                                        <option value="P">Picture</option>
                                                        <option value="V">Video</option>
                                                        <option value="L">Link</option>
                                                    </select>
												<span class="bar"></span>
												<label>DataType</label>
											</div>
                                               
										</div>

                                        <div class="nbtc-row">
										<div class="nbtc-col2">
											<div class="nbtc-field nbtc-field_select">
												<select id=InputType runat=server onchange="setOption(this.value)">
                                                 <option value="T">Text</option>
                                                <option value="S">Select</option>
                                                <option value="D">Date</option>
                                                <option value="C">Checkbox</option>
                                                <option value="P">Picture</option>
                                                <option value="V">Video</option>
                                                <option value="L">Link</option>
                                                </select>
                                                 <input id=InputTypeH type=hidden runat=server />
                                                
												<span class="bar"></span>
												<label>InputType</label>
											</div>
                                        
										</div>

										<div class="clear"></div>
									</div>

                                   
                                    <div class="nbtc-row">
										<div class="nbtc-col2">
											<div class="nbtc-field nbtc-field_textarea">
												<textarea id=Options runat=server></textarea>
												<span class="bar"></span>
												<label>(Options)</label>
											</div>
                        
										</div>

										
										<div class="nbtc-col2">
											<div class="nbtc-field nbtc-field_input">
												<input type="text" id=Unit runat=server>
												<span class="bar"></span>
												<label>Unit</label>
											</div>
                                        
										</div>

										<div class="clear"></div>
									</div>

                                    <div class="nbtc-row">
										<div class="nbtc-col2">
											<div class="nbtc-field nbtc-field_input">
												<input type="text" id=Maxlength runat=server>
												<span class="bar"></span>
												<label>Maxlength</label>
											</div>
                                            <asp:RangeValidator ID="RangeValidator1" Font-Size=8 runat=server ControlToValidate=MaxLength Display=Dynamic ErrorMessage="*(1-250)<br /><br />" ForeColor=Red Type=Integer MinimumValue=1 MaximumValue=250></asp:RangeValidator>
										</div>

										<div class="nbtc-col2">
											<div class="nbtc-field nbtc-field_select">
												<select id=DpColId runat=server>
                                                    <option value="0">-- Not set--</option>
                                                </select>
												<span class="bar"></span>
												<label>Depend on</label>
											</div>
                                       </div>

										<div class="clear"></div>
									</div>
                                    
                                    <div class="nbtc-row">
										<div class="nbtc-col2">

                                        <div class="nbtc-field nbtc-field_checkbox">
								        <label>
									        <input id=IsHeader type="checkbox" runat=server />
									        <span class="box"></span>
									        <span class="nbtc-ic_check"></span>
									        Header
								        </label>
                                        </div>
                                        </div>
							        </div>
                                    <div class="nbtc-row">
										<div class="nbtc-col2">

                                        <div class="nbtc-field nbtc-field_checkbox">
								        <label>
									        <input id=IsRequire type="checkbox" runat=server />
									        <span class="box"></span>
									        <span class="nbtc-ic_check"></span>
									        Require
								        </label>
							        
                                    </div>
                                   </div>
										<div class="clear"></div>
									</div>


                                     <div class="nbtc-row">
										<div class="nbtc-col2">

                                        <div class="nbtc-field nbtc-field_checkbox">
								        <label>
									        <input id=IsSearch type="checkbox" runat=server />
									        <span class="box"></span>
									        <span class="nbtc-ic_check"></span>
									        Search
								        </label>
                                        </div>
							         </div>

                                     <div class="nbtc-col2">

                                        <div class="nbtc-field nbtc-field_checkbox">
								        <label>
									        <input id=IsHide type="checkbox" runat=server />
									        <span class="box"></span>
									        <span class="nbtc-ic_check"></span>
									        IsHide
								        </label>
                                        </div>
							         </div>

										<div class="clear"></div>
									</div>

									<div class="nbtc-group-btn">
                                         <%if (Request.QueryString["colid"] != "0"){ %>
                                            <input type=button id=bDel value=" ลบ " onclick="cfmDel()" class="nbtc-btn nbtc-btn-secondary" />
                                            <%} %>
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
