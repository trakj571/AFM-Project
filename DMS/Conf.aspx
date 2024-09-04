<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Conf.aspx.cs" Inherits="AFMProj.DMS.Conf" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
   <style>
       .tborder {width:80%}
        .tborder, .tborder th, .tborder td {padding:2px;}
       .tborder th {background:#eee;text-align:center}
       .u {padding:0 10px 0 10px}
       .u input{text-align:center;border-bottom:1px double #777}
   </style>
    <script language=javascript>
        <%if(tbF!=null){ %>
         var jF = <%=cConvert.ToJSON(tbF) %>;
       
       
        <%} %>
         $(function () {
            msgbox_save(<%=retID %>,"reload-parent");
            <%if(tbF!=null){ %>
                renderFreq();
            <%} %>
        });

        function renderFreq(){
            $("#nFreq").val(jF.length+"");
            var t="<table class=tborder>";
            t+="<tr><th>No.</th><th>Frequency Start(MHz)</th><th>Frequency Stop(MHz)</th><th width=50></th></tr>";
            for(var i=0;i<jF.length;i++){
                t+=("<tr align=center>");
                t+=("<td>"+(i+1)+"</td>");
                t+=("<td class=u><input class='inputfreq' type=text id='fFreq" + i + "'  name='fFreq" + i + "' value='"+jF[i].fFreq+"' /></td>");
                t+=("<td class=u><input class='inputfreq' type=text id='tFreq" + i + "'  name='tFreq" + i + "' value='" + jF[i].tFreq + "' /></td>");
                t+=("<td><a href='javascript:delFreq("+i+")'><i class=\"afms-ic_delete\"></i>ลบ</a></td>");
                        
               t+=("</tr>");
            }
                
            t+="</table>";
            $("#divFreq").html(t);
            $(".inputfreq").change(function () {
                ValidatorValidate(window.cFreq);
            });
            
        }

        function delFreq(x){
            updateFreq();
            jF.splice(x,1);
            renderFreq();
            ValidatorValidate(window.cFreq);
        }
        function addFreq(){
            updateFreq();
            jF.push({fFreq:'',tFreq:''});
            renderFreq();
            
        }
        function updateFreq(){
            for(var i=0;i<jF.length;i++){
               jF[i].fFreq = $("#fFreq" + i).val();
               jF[i].tFreq = $("#tFreq" + i).val();
           }
        }
    </script>

    <script language=javascript>
        function checkFreq(sender, args) {
            updateFreq();
            for (var i = 0; i < jF.length; i++) {
                if (isNaN(jF[i].fFreq) || isNaN(jF[i].tFreq)) {
                        args.IsValid = false;
                     return;
                }
            }
            
            args.IsValid = true;
        }
      
    </script>
    <script language=C# runat=server>
	    void CheckFreqSrv(object sender,ServerValidateEventArgs args){
            args.IsValid = true;
	    }
    </script>

</head>
<body class="body-no-bg">
	<div class="container">
        <form id=FormAdd runat=server>
    	<div class=row ">
        <table><tr valign=top><td>
    		<div class="col-md-2">
					<div class="afms-field afms-field_input">
						<label>Occupancy (%)</label>
						<input id=Occ runat=server type="text">
						<span class="bar"></span>
					</div>
                    <div class=valid>
                        <asp:RangeValidator ID=rngOcc runat=server ForeColor=Red ControlToValidate=Occ Type=Double MinimumValue=-1000 MaximumValue=1000  Display=Dynamic>* กรุณากรอกเป็นตัวเลข</asp:RangeValidator>
                    </div>
					
                    </div>
                    </td><td>
					<div class="col-md-2">
						<div class="afms-field afms-field_input">
							<label>Field Strangth (dBuV/m)</label>
							<input id=FStr runat=server type="text">
							<span class="bar"></span>
						</div>
                        <div class=valid>
                            <asp:RangeValidator ID=rngFStr runat=server ForeColor=Red ControlToValidate=FStr Type=Double MinimumValue=-1000 MaximumValue=1000  Display=Dynamic>* กรุณากรอกเป็นตัวเลข</asp:RangeValidator>
                        </div>
					
					</div>
					</td></tr></table>
					</div>
       	<br />
        <div class="row">
            <div class="col-md-12>
            
             <p class="afms-field-title">Frequency Exception </p>
                <input type="hidden" id=nFreq name=nFreq value='0' />
               <div id=divFreq></div>

               <asp:CustomValidator ID="cFreq"  ForeColor="Red" Runat=server Display=Dynamic EnableClientScript=True ClientValidationFunction=checkFreq OnServerValidate="CheckFreqSrv">* กรุณากรอกความถี่เป็นตัวเลข<br /></asp:CustomValidator>
				<br />
                <a href='javascript:addFreq()' class='afms-btn afms-btn-secondary'><i class="afms-ic_plus"></i>เพิ่ม</a>				       
              </div>
              </div>


              <div class="row">
						<div class="col-md-12">
							<div class="afms-group-btn text-center">
								<input id="Submit1" type="submit" class="afms-btn afms-btn-primary" value="บันทึก" style='width:auto' onserverclick="bSave_ServerClick" runat=server /> &nbsp; 
								<input id="bClose" type="button" class="afms-btn afms-btn-secondary" value="ปิด" style='width:auto' onclick="parent.closeDialog()"  />
								
							</div>
						</div>
					</div>
				</div>
                           
    
        </form>
		<div class="afms-push"></div>
	</div>
</body>

</html>
