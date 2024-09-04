<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EquipAdd.aspx.cs" Inherits="EBMSMap.Web.Admin.EquipAdd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <!--#include file="../_inc/title.A.asp"-->

    <script language=javascript src="../_inc/js/dpv2.js"></script>
    <script language=javascript src="../_inc/js/pvscp2.js"></script>

    <style>
        #TypeList,#LayerList {height:250px;overflow:scroll}
    </style>
    <script language=javascript>
        var poiid=<%=cConvert.ToInt(Request["PoiID"]) %>;
        var loading = "<div style='text-align:center'><br /><br /><img src='../img/loading.gif'  /></div>";

        $(function(){
           $("#EquList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetEquips(Request["PoiID"]) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                if(data.node.id.substring(0,1)=="L")
                    return;
               location = "Equip.aspx?poiid="+data.node.id;
            }).bind("ready.jstree", function (e, data) {
                $('#EquList li').each( function() {
                    if(this.id.substring(0,1)=="L")
                        $("#EquList").jstree().disable_node(this.id);
                })
             
            });

         
          $("#TypeList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetCTypes(TypeID.Value) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                if(data.node.id.substring(0,1)=="G")
                    return;
                //location = "CType.aspx?typeid="+data.node.id;
                $("#TypeID").val(data.node.id);
                showPoiDetail(poiid, $("#TypeID").val());

            }).bind("ready.jstree", function (e, data) {
                $('#TypeList li').each( function() {
                    if(this.id.substring(0,1)=="G")
                        $("#TypeList").jstree().disable_node(this.id);
                })
             
            });


            $("#LayerList").jstree({ 'core': { 'data': <%=EBMSMap.Web.JSData.GetLayers(LyID.Value) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                $("#LyID").val(data.node.id);
            });

           
           if(poiid>0){
                showPoiDetail(poiid, $("#TypeID").val());
           }
        });

        
        var to = false;
        function search(t) {
            if(to) { clearTimeout(to); }
            to = setTimeout(function () {
              $('#EquList').jstree(true).search(t);
            }, 250);
          
        }
        ///

        function showPoiDetail(poiid, typeid) {
            $("#poiContent").html(loading);
            $.ajax({
                type: 'POST',
                url: "data/dPoiDet.ashx",
                data: {
                    poiid: poiid,
                    typeid: typeid
                },
                cache: false,
                dataType: 'json',
                success: function (data) {
                    if (data.result == "ERR") {

                    } else if (data.result == "OK") {
                        displayPoiDetail(data.datas);

                        if (poiid != '0') {
                            //loadTypeForm();
                            //setLayerTab();
                        }
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }
            });
        }
        function poiColData(t) {
            return t ? t : "";
        }
        function displayPoiDetail(data) {
            poidata = data;
            if (poiid!="0") {
                $("#TypeID").val(data.TypeID);
                $("#LyID").val(data.LyID);
                setTimeout(function(){
                    $("#TypeList").jstree().select_node(data.TypeID);
                    $("#LayerList").jstree().select_node(data.LyID);
                },500);
            }
            var t = dispPoiCol(data);
            
            for (var i = 0; i < data.POIForms.length; i++) {
                t += "<br /><b>" + data.POIForms[i].Name + "</b>";
                t += dispPoiCol(data.POIForms[i]);
            }

            $("#poiContent").html(t);
            $("#poiContent input[type=checkbox]").each(function () {
                setDpCol(this.id.replace("ColData_",".dp"),this.checked);
            });

            //auto
            if (poiid == 0) {
                for (var i = 0; i < data.POICols.length; i++) {
                    var poiCol = data.POICols[i];
                    if (poiCol.DataName == "Equipment_ID" ||
                        poiCol.DataName == "GPS_Tracking_ID" ||
                        poiCol.DataName == "WEB_Link" ||
                        poiCol.DataName == "MOBILE_Link") {
                            $("#ColData_" + poiCol.ColID).val("(Auto)");
                           // $("#ColData_" + poiCol.ColID).prop("disabled",true);
                   }
                }
            }

             $('#poiContent select').selectpicker();
             $('#poiContent .nbtc-field_datepicker input').datepicker({
                    orientation: "bottom left"
                });

            var PATCode = $("#sProv2").attr("rel")+"000000";
            setProv2('sProv2', PATCode.substring(0,2));
            setAumphur2('sAumphur2', PATCode.substring(0,2), PATCode.substring(0,4));
            setTumbon2('sTumbon2', PATCode.substring(0,4), PATCode.substring(0,6));

        }




        function dispPoiCol(data) {
            var t = "";
            for (var i = 0; i < data.POICols.length; i++) {
                var poiCol = data.POICols[i];
                if (poiCol.ColID < 0) continue;
                t +='<div class="nbtc-row" style="margin-top:20px">';
               
              
                if (poiCol.DataName == "PATCode") {
                    t +='<div class="nbtc-col3">';
                    t +='<div class="nbtc-field nbtc-field_select dp' + poiCol.DpColID + '">';
                    t += "<select data-live-search='true' id='sProv2' name='sProv2'  rel='" + poiColData(poiCol.Data) + "' onchange=\"setAumphur2('sAumphur2',this.value,'0')\">";
                     t += "<option value='0'>=== เลือก ===</option>";
                    t += "</select>";
                    t +='<span class="bar"></span>';
					t +='<label>จังหวัด</label>';
                    t += '</div>';
                    t += '</div>';

                    t +='<div class="nbtc-col3">';
                    t +='<div class="nbtc-field nbtc-field_select dp' + poiCol.DpColID + '">';
                    t += "<select data-live-search='true' id='sAumphur2' name='sAumphur2' disabled=disabled onchange=\"setTumbon2('sTumbon2',this.value,'0')\">";
                      t += "<option value='0'>=== เลือก ===</option>";
                    t += "</select>";
                    t +='<span class="bar"></span>';
					t +='<label>อำเภอ</label>';
                    t += '</div>';
                    t += '</div>';

                    t +='<div class="nbtc-col3">';
                    t +='<div class="nbtc-field nbtc-field_select dp' + poiCol.DpColID + '">';
                    t += "<select data-live-search='true' id='sTumbon2' name='sTumbon2' disabled=disabled >";
                    t += "<option value='0'>=== เลือก ===</option>";
                    t += "</select>";
                    t +='<span class="bar"></span>';
					t +='<label>ตำบล</label>';
                    t += '</div>';
                    t += '</div>';
                }else{
                     t +='<div class="nbtc-col1">';
                     if (poiCol.InputType == "T") {
                        t +='<div class="nbtc-field nbtc-field_input dp' + poiCol.DpColID + '" >';
                        t += "<input type='text' id='ColData_" + poiCol.ColID + "' name='ColData_" + poiCol.ColID + "' value='" + poiColData(poiCol.Data) + "' " + (poiCol.Unit == "" ? "" : "class=unit") + " />";
                        t +='<span class="bar"></span>';
					    t +='<label>'+ poiCol.Label +(poiCol.Unit!=''?' ('+poiCol.Unit+')':'')+'</label>';
                        t += '</div>';
			        }
                    else if (poiCol.InputType == "D") {
                        t +='<div class="nbtc-field nbtc-field_datepicker dp' + poiCol.DpColID + '" >';
                        t += "<input type='text' placeholder='DD/MM/YYYY' id='ColData_" + poiCol.ColID + "' name='ColData_" + poiCol.ColID + "' value='" + poiColData(poiCol.Data) + "' " + (poiCol.Unit == "" ? "" : "class=unit") + " />";
                        t +='<span class="bar"></span>';
					    t +='<label>'+ poiCol.Label +'</label><i class="nbtc-ic_calendar"></i>';
                        t += '</div>';
                    }
                    else if (poiCol.InputType == "C") {
                        t +='<div class="nbtc-field nbtc-field_checkbox dp' + poiCol.DpColID + '" >';
                        t += "<label><input type='checkbox' id='ColData_" + poiCol.ColID + "' name='ColData_" + poiCol.ColID + "' value='Y' " + (poiColData(poiCol.Data) == "Y" ? "checked" : "") + " onclick = \"setDpCol('.dp" + poiCol.ColID + "',this.checked)\"  />";
                        t +='<span class="box"></span><span class="nbtc-ic_check"></span>';
					    t +=''+ poiCol.Label +(poiCol.Unit!=''?' ('+poiCol.Unit+')':'')+'</label>';
                        t += '</div>';

                    }
                    else if (poiCol.InputType == "S") {

                        t +='<div class="nbtc-field nbtc-field_select dp' + poiCol.DpColID + '" >';
                        t += "<select id='ColData_" + poiCol.ColID + "' name='ColData_" + poiCol.ColID + "' value='" + poiColData(poiCol.Data) + "' " + (poiCol.Unit == "" ? "" : "class=unit") + " >";
                        t += "<option value=''";
                        if (poiColData(poiCol.Data) == "") {
                            t += " selected";
                        }
                        t += ">===== เลือก =====</option>";
                        if (poiCol.Options) {
                            for (var j = 0; j < poiCol.Options.length; j++) {
                                t += "<option value='" + poiCol.Options[j].Value + "'";
                                if (poiColData(poiCol.Data) != "" && poiCol.Options[j].Value == poiColData(poiCol.Data)) {
                                    t += " selected";
                                }
                                t += ">" + poiCol.Options[j].Text + "</option>";

                            }
                        }
                        t += "</select>";
                        t +='<span class="bar"></span>';
					    t +='<label>'+ poiCol.Label +'</label>';
                        t += '</div>';
                    }
                    else if (poiCol.InputType == "L") {
                      t +='<div class="nbtc-field nbtc-field_input dp' + poiCol.DpColID + '" >';
                        t += "<input type='text' id='ColData_" + poiCol.ColID + "' name='ColData_" + poiCol.ColID + "' value='" + poiColData(poiCol.Data) + "' " + (poiCol.Unit == "" ? "" : "class=unit") + " />";
                        t +='<span class="bar"></span>';
					    t +='<label>'+ poiCol.Label +'</label>';
                        t += '</div>';
                    }

                    t += '</div>'; 
                  }
                  t += '<div class="clear"></div>';
                  t += '</div>';
            }
            t += '<div class="nbtc-row" style="margin-top:20px">';
            t += '<div class="nbtc-col2">';
            t += '<div class="nbtc-field nbtc-field_input" >';
            t += "<input type='text' id='Point_Lat' name='Point_Lat' value='<%=_PoiDetail.Lat%>' />";
            t += '<span class="bar"></span>';
            t += '<label>Lat</label>';
            t += '</div>';
            t += '</div>';
            t += '<div class="nbtc-col2">';
            t += '<div class="nbtc-field nbtc-field_input" >';
            t += "<input type='text' id='Point_Lat' name='Point_Lng' value='<%=_PoiDetail.Lng%>' />";
            t += '<span class="bar"></span>';
            t += '<label>Long</label>';
            t += '</div>';
            t += '</div>';
            t += '<div class="clear"></div>';
            t += '</div>';
           
          

            return t;
        }
        function setDpCol(tr, chk) {
            if (chk) {
                $(tr).css("color", "black");
                $(tr + " input").removeAttr("disabled");
                $(tr + " select").removeAttr("disabled");
            } else {
                $(tr).css("color", "gray");
                $(tr + " input").attr("disabled", "disabled");
                $(tr + " select").attr("disabled", "disabled");
            }
        }

    
        function msgbox(t){
            swal({
                  title: t,
                  text: "",
                  type: 'warning',
                  confirmButtonText: 'ตกลง',
                  confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                });
        }
        function checkValid() {
            if ($("#TypeID").val() == '0' || $("#TypeID").val() == '') {
                msgbox("โปรดเลือก Type ");
                return false;
            }
             if ($("#LyID").val() == '0' || $("#LyID").val() == '') {
                msgbox("โปรดเลือก Layer ");
                return false;
            }
           for (var i = 0; i < poidata.POICols.length; i++) {
                var poiCol = poidata.POICols[i];
                if (poiCol.IsRequire && $("#ColData_" + poiCol.ColID).val()=="") {
                    msgbox("โปรดกรอกข้อมูล " + poiCol.Label);
                   
                    return false;
                }
                if (poiCol.DataType == "I" && isNaN($("#ColData_" + poiCol.ColID).val())) {
                    msgbox("โปรดกรอกข้อมูล " + poiCol.Label+" เป็นตัวเลข");
                    return false;
                }
            }
            return true;
        }

    </script>

    
</head>
<body class="nbtc-admin">
	<div class="nbtc-container">
		<!--#include file="../_inc/hd.A.asp"-->

		<div class="nbtc-sec-breadcrumb">
			<ul>
				<li><a href="#"><i class="nbtc-ic_home"></i></a> <i class="nbtc-ic_next"></i></li>
				<li><a href="#">Admin Tools</a> <i class="nbtc-ic_next"></i></li>
				<li><a href="#">Content</a> <i class="nbtc-ic_next"></i></li>
				<li>Equipment</li>
			</ul>
            <!--#include file="../_inc/Usr.asp"-->
			<a href="EquipAdd.aspx" class="nbtc-btn nbtc-btn-secondary">Add Equipment</a>
		</div>

		<div class="nbtc-col nbtc-group-col3">
			<div class="nbtc-sec-left nbtc-col1">
				<div class="nbtc-sec-search">
					<div class="nbtc-field nbtc-field_input has-right-icon">      
				      <input id=txtSch type=txt onkeyup="search(this.value)" />
				      <span class="bar"></span>
				      <label>ค้นหา</label>
				      <i class="nbtc-ic_search"></i>
				    </div>

				    <div class="nbtc-search-listx" style='background:#eee;padding:10px;'>
				        <div id=EquList style="height:100%;background:Transparent"></div>
				    </div>
				</div>
			</div>
            <form id=Form1 runat=server enctype="multipart/form-data" onsubmit="return checkValid()">
            <div id=hiddenDiv>
            <input type=hidden id=TypeID runat=server value=0 />
            <input type=hidden id=LyID runat=server value=0 />
            <input type=hidden id=Point name=Point value="0,0" />
            <input type=hidden id=Distance name=Distance value="0" />
            <input type=hidden id=Area name=Area value="0" />
            <input type=hidden id=Radius name=Radius value="0" />
           </div>
            <div class="nbtc-sec-center nbtc-col2">
				<div class="nbtc-sec-content">
					<h2>Equipment</h2>
					
                    <h4>Type</h4>
                    <div id=TypeList></div>
                    <br />

                    <h4>Layer</h4>
                    <div id=LayerList></div>
                    <br />
                    <h4>Content</h4>
                	<div id=main-content>
                    <div id=poiContent>
                    </div>
                    </div>
                    
					<div class="nbtc-group-btn">
						<input type=submit id=bSave value='บันทึก' runat=server onserverclick=bSave_ServerClick class="nbtc-btn nbtc-btn-primary" />
						<input type=reset id=bReset value='ล้าง' runat=server class="nbtc-btn nbtc-btn-secondary" />
					</div>

				</div>
			</div>
            </form>

			<div class="nbtc-sec-right nbtc-col1">
				


			</div>
		</div>

		<div class="push"></div>
	</div>

         <!--#include file="../_Inc/Ft.A.asp"-->
          <script language=javascript>
                msgbox_save(<%=retID %>,"Equip.aspx?poiid=<%=retID %>");
        
            </script>

</body>
</html>
