<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Equip.aspx.cs" Inherits="EBMSMap.Web.Admin.Equip" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <!--#include file="../_inc/title.A.asp"-->
    <script language=javascript>
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

         

            <%if(Request["PoiID"]==null){ %>
                $(".nbtc-sec-content").hide();
                $(".nbtc-sec-right").hide();

                
            <%}else{ %>
                loadPoiDet('<%=Request["PoiID"]%>');
             <%}%>
        });

        
        var to = false;
        function search(t) {
            if(to) { clearTimeout(to); }
            to = setTimeout(function () {
              $('#EquList').jstree(true).search(t);
            }, 250);
          
        }

        
        
        function loadPoiDet(id) {
        $.getJSON("data/dPOIDet.ashx?poiid=" + id, function (data) {
            var _data = data.datas;

            var t = "";
            t += dispPoiCol(_data);
            

            $("#main-content").html(t);
        });
       
    }

    function dispPoiCol(data) {
        var t = "";
        for (var i = 0; i < data.POICols.length; i++) {
            var poiCol = data.POICols[i];

            t += '<div class="nbtc-row">';
			t += '<div class="nbtc-col2">';
			
           
            if (poiCol.DataName == "PATCode") {
                t += '<div class="nbtc-field">';
			    t += '<p class="nbtc-field-title">'+poiCol.Label+(poiCol.Unit!=''?"("+poiCol.Unit+")":"")+'</p>';
		        t += "<p>"+poiCol.DataText+"</p>";
                 t += '</div>';
            }
            else if (poiCol.InputType == "T") {
                t += '<div class="nbtc-field">';
			    t += '<p class="nbtc-field-title">'+poiCol.Label+(poiCol.Unit!=''?"("+poiCol.Unit+")":"")+'</p>';
		        t += "<p>"+poiCol.Data+"</p>";
                 t += '</div>';
            }
            else if (poiCol.InputType == "S") {
                 t += '<div class="nbtc-field">';
			    t += '<p class="nbtc-field-title">'+poiCol.Label+(poiCol.Unit!=''?"("+poiCol.Unit+")":"")+'</p>';
		    
                if (poiCol.Options) {
                    for (var j = 0; j < poiCol.Options.length; j++) {
                        if (poiCol.Options[j].Value.toUpperCase() + "" == poiCol.Data.toUpperCase() + "") {
                            t += "<p>"+poiCol.Options[j].Text+"</p>";
                            break;
                        }
                    }
                }
                 t += '</div>';
            }
            else if (poiCol.InputType == "D") {
                t += '<div class="nbtc-field">';
			    t += '<p class="nbtc-field-title">'+poiCol.Label+(poiCol.Unit!=''?"("+poiCol.Unit+")":"")+'</p>';
		    
                t += "<p>"+poiCol.Data+"</p>";
                 t += '</div>';
            }
            else if (poiCol.InputType == "C") {
                t += '<div class="nbtc-field nbtc-field_checkbox">';
			    t += "<label><input type=checkbox " + (poiCol.Data == "Y" ? "checked" : "") + " onclick='return false' /><span class='box'></span><span class='nbtc-ic_check'></span>";
                t += poiCol.Label+"</label>";
                 t += '</div>';
            }
            else if (poiCol.InputType == "L") {
                t += '<div class="nbtc-field">';
			    t += '<p class="nbtc-field-title">'+poiCol.Label+(poiCol.Unit!=''?"("+poiCol.Unit+")":"")+'</p>';
		        t += "<p><a href='" + poiCol.Data + "' target=_blank>" + poiCol.Data + "</a></p>";
                 t += '</div>';
            }
            else if (poiCol.InputType == "P") {
                t += '<div class="nbtc-field">';
			    t += '<p class="nbtc-field-title">'+poiCol.Label+(poiCol.Unit!=''?"("+poiCol.Unit+")":"")+'</p>';
		        if (poiCol.Data != "")
                        t += "<p><a href='" + poiCol.Data + "' target=_blank><img src='" + poiCol.Data + "' width=100% /></a></p>";
                 t += '</div>';
            }
            else if (poiCol.InputType == "V") {
                t += '<div class="nbtc-field">';
			    t += '<p class="nbtc-field-title">'+poiCol.Label+(poiCol.Unit!=''?"("+poiCol.Unit+")":"")+'</p>';
		    
                if (poiCol.Data != "") {
                    var datas = poiCol.Data.split('|');
                    if (datas.length == 3) {
                        if (datas[2] != "") {
                            t += "<p><a href='javascript:playVideo(\"" + datas[2] + "\")'>" + datas[1] + "</a></p>";
                        }
                    }
                }
                 t += '</div>';
            }

           
			t += '</div>';
            t += '<div class="clear"></div>';
            t += '</div>';

            
        }
        t += '<div class="nbtc-row">';
        t += '<div class="nbtc-col2">';
        t += '<div class="nbtc-field">';
        t += '<p class="nbtc-field-title">Lat</p>';
        t += "<p>" + data.Lat +"</p>";
        t += '</div>';
        t += '</div>';
        t += '<div class="nbtc-col2">';
        t += '<div class="nbtc-field">';
        t += '<p class="nbtc-field-title">Long</p>';
        t += "<p>" + data.Lng+"</p>";
        t += '</div>';
        t += '</div>';
        t += '<div class="clear"></div>';
        t += '</div>';
        return t;
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
            <form id=Form1 runat=server>
            <div id=hiddenDiv>
           </div>
            <div class="nbtc-sec-center nbtc-col2">
				<div class="nbtc-sec-content content-readonly">
					<h2>Equipment</h2>
					<div class="nbtc-content-options">
						<a href='EquipAdd.aspx?poiid=<%=Request["PoiID"] %>' class="nbtc-btn nbtc-ic_edit"></a>
						<a href="javascript:delItem('spPOI_Del','PoiID','<%=Request["PoiID"] %>')" class="nbtc-btn nbtc-btn-delete nbtc-ic_delete"></a>
					</div>
				
                	<div id=main-content></div>

					<div class="nbtc-group-btn">
						<a href='EquipAdd.aspx?poiid=<%=Request["PoiID"] %>' class="nbtc-btn nbtc-btn-primary">แก้ไข</a>
						<a href="javascript:delItem('spPOI_Del','PoiID','<%=Request["PoiID"] %>')" class="nbtc-btn nbtc-btn-secondary nbtc-btn-delete">ลบ</a>
					</div>


				</div>
			</div>
               
                 <div class="nbtc-sec-center nbtc-col2" style="margin-top:30px;">
				<div class="nbtc-sec-content content-readonly">
                    Status : 
                    <%
                        for (int i = 0; i < tbS.Rows.Count; i++) {
                            if (cConvert.ToInt(tbS.Rows[i]["PoiID"]) != cConvert.ToInt(Request.QueryString["PoiID"]))
                                continue;

                            Response.Write(" <b>" + tbS.Rows[i]["IsOnline"]+"</b>");
                            if (tbS.Rows[i]["IsOnline"].ToString() == "Online")
                            {
                                if (tbS.Rows[i]["IsLock"].ToString() != "Unlock")
                                {
                                    Response.Write(" &nbsp; <b>Lock</b> &nbsp; Operate by : " + tbS.Rows[i]["OprName"] + " &nbsp; <a href='?poiid=" + tbS.Rows[i]["PoiID"] + "&kill=1' class='nbtc-btn nbtc-btn-secondary nbtc-btn-delete'>Kill Process</a>");
                                }
                                else
                                {
                                    Response.Write(" &nbsp; <b>" + tbS.Rows[i]["IsLock"]+"</b>");
                                }
                            }


                        }
                     %>
                    </div>
                     </div>
            </form>

			<div class="nbtc-sec-right nbtc-col1">
				


			</div>
		</div>

		<div class="push"></div>
	</div>

         <!--#include file="../_Inc/Ft.A.asp"-->
         

</body>
</html>
