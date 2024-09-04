<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="addpoi.aspx.cs" Inherits="EBMSMap30.data.addpoi" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" href="../libs/style.css" />
    <script src="../libs/jquery.js"></script>
    <script src="../libs/jquery.tools.min.js"></script>
    <script src="../libs/cp.js"></script>
    <script src="../libs/mapunit.js"></script>
    <link rel="stylesheet" type="text/css" href="../libs/tabs-no-images.css"/>
    <script type="text/javascript" charset="utf-8" src="../libs/jstree/jquery.jstree.js"></script>
    <style>
        .pscroll {height:220px}
        #poiInfo,#poiContent,#poiInputType,#layerTree {margin:5px}
        #poiContent input[type=text]{width:160px;}
        #poiContent select{width:160px;}
        .unit {width:100px!important;}
        #poiInputType .selected {background:#99DEFD!important;border:1px solid #88CCFF!important}
        #bDelete{color:red;display:none}
    </style>
    <script language=javascript>
        var loading = "<div style='text-align:center;margin-top:40px'><img src='../images/loading.gif' /></div>";
        var poiid = '<%=Request["poiid"]%>';
        var poitype = '<%=Request["poitype"]%>';
        var tab = '<%=Request["tab"]%>'
        var tabs;
        var poidata = null;
        $(document).ready(function () {
            tabs = $(".css-tabs:first").tabs(".css-panes:first > div");
            $("#TypeID").val('<%=Request["typeid"]%>');
            $("#LyID").val('<%=Request["lyid"]%>');

            if (poiid != '0') {
                showPoiDetail(poiid, $("#TypeID").val());
            } else {
                var toolObject = parent.toolObject;
                if (poitype == '1') {
                    var latlng = toolObject.getLatLng();
                    $("#Point").val(degreeFormat(latlng.lng) + ',' + degreeFormat(latlng.lat));
                    $("#t4").hide();
                }
                else if (poitype == '2' || poitype == '3') {
                    var latlngs = toolObject.getLatLngs();
                    var t = "";
                    for (var i = 0; i < latlngs.length; i++) {
                       if (i > 0) {
                            if (latlngs[i].lng == latlngs[i - 1].lng && latlngs[i].lat == latlngs[i - 1].lat)
                                continue;
                        }
                        if (t != "") t += ",";
                        t += degreeFormat(latlngs[i].lng) + ',' + degreeFormat(latlngs[i].lat);
                    }
                    if(poitype == '3')
                        t += ","+degreeFormat(latlngs[0].lng) + ',' + degreeFormat(latlngs[0].lat);

                    $("#Point").val(t);
                    if (poitype == '3') {
                        $("#Area").val(toolObject.area);
                    } else {
                        $("#Distance").val(toolObject.dist);
                        $(".fill").hide();
                    }

                    cp_init('LineColor');
                    cp_init('FillColor');
                }
                else if (poitype == '4') {
                    var latlng = toolObject.getLatLng();
                    $("#Point").val(degreeFormat(latlng.lng) + ',' + degreeFormat(latlng.lat));
                    $("#Radius").val(toolObject.getRadius());
                    $("#Area").val(toolObject.area);


                    cp_init('LineColor');
                    cp_init('FillColor');
                }
                //alert($("#Distance").val() + "/" + $("#Radius").val() + "/" + $("#Area").val());
                loadTypeForm();
                setLayerTab();
                dispPoiInfo(poitype);
            }
        });

        function dispPoiInfo(poitype) {
            var t = "";
            var points = $("#Point").val().split(',');
            t += "<table>";
            for (var i = 0; i < points.length; i+=2) {
                t += "<tr><td width=75>Postion "+((poitype=='2'||poitype=='3')? (i/2 + 1)+"":"") + " </td><td>"+degreeFormat(points[i+1])+" , "+degreeFormat(points[i])+"</td></tr>";
            }
            if (poitype == '2')
                t += "<tr><td width=75>Distance</td><td>" + formatDist($("#Distance").val()) + "</td></tr>";
            if (poitype == '3')
                t += "<tr><td width=75>Area</td><td>" + formatArea($("#Area").val()) + "</td></tr>";
            if (poitype == '4') {
                t += "<tr><td width=75>Redius</td><td>" + formatDist($("#Radius").val()) + "</td></tr>";
                t += "<tr><td width=75>Distance</td><td>" + formatArea($("#Area").val()) + "</td></tr>";
            }

            t += "</table>";
            $("#poiInfo").html(t);
        }

        function loadTypeForm() {
            $("#input_content").html(loading);
            $.ajax({
                type: 'POST',
                url: "../data/dPoiType.ashx?place=1",
                cache: false,
                dataType: 'json',
                success: function (data) {
                    if (data.result == "ERR") {

                    } else if (data.result == "OK") {
                        displayInputForm(data.datas);
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }
            });
        }

        function displayInputForm(data) {
            for (var i = 0; i < data.length; i++) {
                var t = "";
                var isappend = false;
                var grp = data[i];
                t += "<a href=\"javascript:explandInputTreeGrp(" + grp.GrpID + ")\"><img id='inputTreeGrp" + grp.GrpID + "_icon' src='../images/icons/tree-open.png' align=absbottom></a> " + grp.Name + "<br />";
                t += "<div id='inputTreeGrp" + grp.GrpID + "' class=poitype>";
                for (var j = 0; j < grp.Children.length; j++) {
                    var child = grp.Children[j];
                    if (child.PoiType+"" != poitype) continue;
                    isappend = true;
                    if ( $("#TypeID").val() == '0'){
                        $("#TypeID").val(child.TypeID);
                    }
                    
                    t += "<a id='poitype_" + child.TypeID + "' href='javascript:selectPoiType(" + child.TypeID + ",1)'>";
                    t += "<img src='" + child.Icon + "' align=absbottom width=24><div>";
                    t += "<span>" + child.Name + "</span><br />";
                    var spoitype = "";
                    if (child.PoiType == 1)
                        spoitype = "Point";
                    if (child.PoiType == 2)
                        spoitype = "Line";
                    if (child.PoiType == 3)
                        spoitype = "Polygon";
                    if (child.PoiType == 4)
                        spoitype = "Circle";
                    t += "<small>[" + spoitype + "]</small></div>";
                    t += "</a><br style='clear:both' />";
                }
                t += "</div>";
                if(isappend)
                    $("#poiInputType").append(t);
            }
            

            if ( $("#TypeID").val() != '0') {
                selectPoiType($("#TypeID").val());
            }
        }

        function explandInputTreeGrp(grpid) {
            $('element:visible')
            if ($("#inputTreeGrp" + grpid).css("display") != "none") {
                $("#inputTreeGrp" + grpid).slideUp();
                $("#inputTreeGrp" + grpid + "_icon").attr("src", "../images/icons/tree-close.png");
            } else {
                $("#inputTreeGrp" + grpid).slideDown();
                $("#inputTreeGrp" + grpid + "_icon").attr("src", "../images/icons/tree-open.png");
            }
        }

        function selectPoiType(typeid,isclk) {
            $(".poitype a").each(function (i) {
                $("#"+this.id).removeClass("selected");
            });
             $("#TypeID").val(typeid);
            $("#poitype_" + typeid).addClass("selected");
            if (poiid == '0') {
                var qtypeid = '<%=Request["typeid"]%>';
                showPoiDetail(poiid, $("#TypeID").val());
                if (isclk || qtypeid!='0')
                    $('.css-tabs:first a[href="#tab2"]').click();   
            }
        }

        //

        function setLayerTab() {
            $("#layerTree").jstree({
                "json_data": {
                    "ajax": {
                        "url": function (node) {
                            return "../data/dlayer.ashx?place=1"; ;
                        },
                        "data": function (n) {
                            return n;
                        },
                        "cache": false
                    }
                },
                "plugins": ["themes", "json_data", "ui"],
                "themes": { "icons": false }

            }).bind("select_node.jstree", function (e, data) {
                $("#LyID").val(data.rslt.obj.data("id"));
                $('.css-tabs:first a[href="#tab3"]').click(); 
            }).bind("loaded.jstree", function (e, data) {
                $(this).jstree("open_all");
                if ($("#LyID").val() == '0') {
                    //$("#LyID").val($("#layerTree li:first").attr("id").replace("li_node_id", ""));
                }
                $('#layerTree').jstree("select_node", "#li_node_id" + $("#LyID").val());

            });
        }

        // content

        function showPoiDetail(poiid, typeid) {
            $("#poiContent").html(loading);
            $.ajax({
                type: 'POST',
                url: "../data/dPoiDet.ashx",
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
                            loadTypeForm();
                            setLayerTab();
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
                $("#Point").val(data.Points);
                $("#Distance").val(data.Distance);
                $("#Radius").val(data.Radius);
                $("#Area").val(data.Area);
                dispPoiInfo(data.PoiType);
                $('.css-tabs:first a[href="#tab3"]').click();
                $("#t1").hide();

                if (data.PoiType == 1)
                    $("#t4").hide();
                if (data.PoiType == 2)
                    $(".fill").hide();

                
                $("#LineColor").val(data.LineColor);
                $("#FillColor").val(data.FillColor);
                $("#LineWidth").val(data.LineWidth);
                $("#LineOpacity").val(data.LineOpacity / 10 * 10);
                $("#FillOpacity").val(data.FillOpacity / 10 * 10);
                cp_init('LineColor');
                cp_init('FillColor');
                $("#bDelete").show();
            }
            var t = "<table bgcolor=#cccccc cellspacing=1 cellpadding=4>";
            t += dispPoiCol(data);
            t += "</table>";

            for (var i = 0; i < data.POIForms.length; i++) {
                t += "<br /><b>" + data.POIForms[i].Name + "</b>";
                t += "<table bgcolor=#cccccc cellspacing=1 cellpadding=4 style='margin-top:5px'>";
                t += dispPoiCol(data.POIForms[i]);
                t += "</table>";
            }

            $("#poiContent").html(t);
            $("#poiContent input[type=checkbox]").each(function () {
                setDpCol(this.id.replace("ColData_",".dp"),this.checked);
            });
        }

        function dispPoiCol(data) {
            var t = "";
            for (var i = 0; i < data.POICols.length; i++) {
                var poiCol = data.POICols[i];
                if (poiCol.ColID < 0) continue;
                t += "<tr bgcolor=#ffffff class='dp" + poiCol.DpColID + "'><td width=80><b>" + poiCol.Label + "</b></td><td width=180>";
                if (poiCol.InputType == "T") {
                    t += "<input type='text' id='ColData_" + poiCol.ColID + "' name='ColData_" + poiCol.ColID + "' value='" + poiColData(poiCol.Data) + "' " + (poiCol.Unit == "" ? "" : "class=unit") + " />";
                }
                if (poiCol.InputType == "D") {
                    t += "<input type='text' id='ColData_" + poiCol.ColID + "' name='ColData_" + poiCol.ColID + "' value='" + poiColData(poiCol.Data) + "' class=unit maxlength=10 onclick=\"if(self.gfPop)gfPop.fPopCalendar(document.getElementById('ColData_" + poiCol.ColID + "'));return false;\" />";
                    t += "<a href=\"javascript:void(0)\" onclick=\"if(self.gfPop)gfPop.fPopCalendar(document.getElementById('ColData_" + poiCol.ColID + "'));return false;\" ><img class=\"PopcalTrigger\" align=\"absBottom\" src=\"../libs/Calendar/calbtn.gif\" width=\"34\" height=\"22\" border=\"0\" alt=\"\"></a>";

                }
                if (poiCol.InputType == "C") {
                    t += "<input type='checkbox' id='ColData_" + poiCol.ColID + "' name='ColData_" + poiCol.ColID + "' value='Y' " + (poiColData(poiCol.Data) == "Y" ? "checked" : "") + " onclick = \"setDpCol('.dp" + poiCol.ColID + "',this.checked)\"  />";
                }
                else if (poiCol.InputType == "S") {
                    t += "<select id='ColData_" + poiCol.ColID + "' name='ColData_" + poiCol.ColID + "' >";
                    t += "<option value=''";
                    if (poiColData(poiCol.Data) == "") {
                        t += " selected";
                    }
                    t += ">===== เลือก =====</option>";
                    if (poiCol.Options && poiCol.Options.length) {
                        for (var j = 0; j < poiCol.Options.length; j++) {
                            t += "<option value='" + poiCol.Options[j].Value + "'";
                            if (poiColData(poiCol.Data) != "" && poiCol.Options[j].Value == poiColData(poiCol.Data)) {
                                t += " selected";
                            }
                            t += ">" + poiCol.Options[j].Text + "</option>";

                        }
                    }
                    t += "</select>";
                }
                else if (poiCol.InputType == "L") {
                    if (poiColData(poiCol.Data) != "")
                        t += "<input type='text' id='ColData_" + poiCol.ColID + "' name='ColData_" + poiCol.ColID + "' value='" + poiColData(poiCol.Data) + "' " + (poiCol.Unit == "" ? "" : "class=unit") + " />";

                }
                else if (poiCol.InputType == "P") {
                    if (poiColData(poiCol.Data) != "" && poiColData(poiCol.Data) != "N") {
                        t += "<table><tr valign=top><td width=120>";
                        if (poiColData(poiCol.Data) != "")
                            t += "<img src='" + poiCol.Data + "' width=100 />";
                        else
                            t += "<img src='../images/spc.gif' width=100 style='border:1px solid #000' />";
                        t += "</td><td><input type=checkbox id='ColData_D_" + poiCol.ColID + "' name='ColData_" + poiCol.ColID + "' value='1' /><label for='ColData_D_" + poiCol.ColID + "'>Delete</label>";
                        t += "</td></tr></table>";

                    }
                    t += "<input id='ColData_" + poiCol.ColID + "' name='ColData_" + poiCol.ColID + "' type='file' style='width:170px' />";
                }
                else if (poiCol.InputType == "V") {
                    if (poiColData(poiCol.Data) != "") {
                        var datas = poiCol.Data.split('|');
                        if (datas.length == 3) {
                            if (datas[2] != "") {

                                t += "<table><tr valign=top><td width=120>";
                                t += "<a href='" + datas[2] + "' target=_blank>" + datas[1] + "</a>";

                                t += "</td><td><input type=checkbox id='ColData_D_" + poiCol.ColID + "'  name='ColData_" + poiCol.ColID + "' value='1' /><label for='ColData_D_" + poiCol.ColID + "'>Delete</label>";
                                t += "</td></tr></table>";

                            }
                        }
                    }
                    t += "<input id='ColData_" + poiCol.ColID + "' name='ColData_" + poiCol.ColID + "' type='file' style='width:170px' />";
                }

                t += " &nbsp; <b>" + poiCol.Unit + "</b></td></tr>";

            }
            t += "</table>";

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
        function deletePOI() {
            if(!confirm("Delete POI?"))
                return;

            $("body").html(loading);
            $.ajax({
                type: 'POST',
                url: "../data/dPoiDel.ashx",
                data: {
                    poiid: "-"+poiid
                },
                cache: false,
                dataType: 'json',
                success: function (data) {
                    if (data.result == "ERR") {

                    } else if (data.result == "OK") {
                        parent.addPOIDone(-parseInt(poiid), null, tab);
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }
            });
        }

        function checkValid() {
            if ($("#LyID").val() == '0') {
                alert("โปรดเลือก Layer ");
                $('.css-tabs:first a[href="#tab2"]').click(); 
                return false;
            }
            for (var i = 0; i < poidata.POICols.length; i++) {
                var poiCol = poidata.POICols[i];
                if (poiCol.IsRequire && $("#ColData_" + poiCol.ColID).val()=="") {
                    alert("โปรดกรอกข้อมูล " + poiCol.Label);
                    $("#t3").click();
                    return false;
                }
                if (poiCol.DataType == "I" && isNaN($("#ColData_" + poiCol.ColID).val())) {
                    alert("โปรดกรอกข้อมูล " + poiCol.Label+" เป็นตัวเลข");
                    $("#t3").click();
                    return false;
                }
            }
            return true;
        }
    </script>
    
</head>
<body>
    <iframe width=174 height=189 name="gToday:normal:agenda.js" id="gToday:normal:agenda.js" src="../libs/Calendar/ipopeng.htm" scrolling="no" frameborder="0" style="Z-INDEX:999; LEFT:-500px; VISIBILITY:visible; POSITION:absolute; TOP:-500px"></iframe>
    <form id="form1" runat="server" enctype="multipart/form-data" onsubmit="return checkValid()">
    <div>
    <ul class="css-tabs">
  <li><a id="t1" href="#tab1">Type</a></li>
  <li><a id="t2" href="#tab2">Layer</a></li>
  <li><a id="t3" href="#tab3">Content</a></li>
  <li><a id="t4" href="#tab4">Style</a></li>
  <li><a id="t5" href="#tab5">Info</a></li>
</ul>
<!-- panes -->
<div class="css-panes">
  <div class="pscroll">
    <div id=poiInputType></div>
  </div>
 
  <div class="pscroll">
    <div id=layerTree></div>
  </div>
 
 <div class="pscroll">
    <div id=poiContent></div>
  </div>
 
  <div class="pscroll">
    <table style='margin:10px 0 0 10px' cellpadding=4>
    <tr><td width='80'>Line Width</td><td>
        <select id=LineWidth name=LineWidth style='width:120px'>
        <option value=1>1</option>
        <option value=2 selected>2</option>
        <option value=3>3</option>
        <option value=4>4</option>
        <option value=5>5</option>
        <option value=6>6</option>
        <option value=7>7</option>
        <option value=8>8</option>
        </select>
        </td></tr>
        <tr><td>Line Color</td>
        <td><input name="LineColor" type="text" id="LineColor" value="3333ff" /></td></tr>

        <tr><td width='80'>Line Opacity</td><td>
        <select id=LineOpacity name=LineOpacity style='width:120px'>
        <option value=10>10</option>
        <option value=20>20</option>
        <option value=30>30</option>
        <option value=40>40</option>
        <option value=50>50</option>
        <option value=60>60</option>
        <option value=70>70</option>
        <option value=80>80</option>
        <option value=90>90</option>
        <option value=100 selected>100</option>
        </select>
        </td></tr>
        <tr class="fill"><td>Fill Color</td>
        <td><input name="FillColor" type="text" id="FillColor" value="3333ff" /></td></tr>

        <tr class="fill"><td width='80'>Fill Opacity</td><td>
        <select id=FillOpacity name=FillOpacity style='width:120px'>
        <option value=10>10</option>
        <option value=20>20</option>
        <option value=30>30</option>
        <option value=40 selected>40</option>
        <option value=50>50</option>
        <option value=60>60</option>
        <option value=70>70</option>
        <option value=80>80</option>
        <option value=90>90</option>
        <option value=100>100</option>
        </select>
        </td></tr>
        </table>
  </div>
  <div class="pscroll">
    <div id=poiInfo></div>
  </div>
</div>

<div style='margin-top:15px'>
<table width='100%'><tr><td>
<input type=submit id=bSave runat=server value= " Save " onserverclick="bSave_Click" />
<input type=button id=bCancel value= " Cancel " onclick="parent.closeInfoPopup()" />
</td><td align=right>
<input type=button id=bDelete value= " Delete " onclick="deletePOI()" />

</td></tr></table>
<input type=hidden id=LyID name=LyID value="0" />
<input type=hidden id=TypeID name=TypeID value="0" />
<input type=hidden id=Point name=Point value="0,0" />
<input type=hidden id=Distance name=Distance value="0" />
<input type=hidden id=Area name=Area value="0" />
<input type=hidden id=Radius name=Radius value="0" />
</div>
    </div>
    </form>
</body>
</html>
