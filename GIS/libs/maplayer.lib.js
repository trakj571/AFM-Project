var poiArray_SchTab = [];
var poiArray_LandTab = [];
var poiArray_LayerTab=[];
var selectedPoi = null;
var boundPolygon = null;
var dotArray = [];
var loading = "<div style='text-align:center;margin-top:40px'><img src='images/loading.gif' /></div>";
var selectPoiID_afterload = 0;
var schPOI_datas;
var schObject = null;

function setLayerPanel() {
    $(".css-tabs:first").tabs(".css-panes:first > div");
    $("#info_tabs").tabs("#info_tabs_panel > div");

    $("#tabSch_keyword").bind("keypress", {}, function (e) {
        var code = (e.keyCode ? e.keyCode : e.which);
        if (code == 13) {
            e.preventDefault();
            doSchPOI();
        }
    });

    $("#tabSch_keyword").bind("keyup", {}, function (e) {
        if ($("#tabSch_keyword").val().length < 2) {
            $("#tabSch_bSch").attr("disabled", "disabled");
            return;
        }
        $("#tabSch_bSch").removeAttr("disabled");
    });

    $("#tabSch_advkeyword").bind("keypress", {}, function (e) {
        var code = (e.keyCode ? e.keyCode : e.which);
        if (code == 13) {
            e.preventDefault();
            doSchPOI('adv');
        }
    });

    $("#tabSch_advkeyword").bind("keyup", {}, function (e) {
        if ($("#tabSch_advkeyword").val().length < 2) {
            $("#tabSch_bAdvSch").attr("disabled", "disabled");
            return;
        }
        $("#tabSch_bAdvSch").removeAttr("disabled");
    });
    
}
function doSchPOI(adv) {
    if (!adv && $("#tabSch_keyword").val().length < 2) return;
    if (adv && $("#tabSch_advkeyword").val().length < 2) return;
    $("#tabSch_result").html(loading);
    $("#tabSch_result").show();
    clearSchPOI(1);

    var dparm = {
        keyword: escape($("#tabSch_keyword").val()),
        lat: map.getCenter().lat,
        lng: map.getCenter().lng
    };
    if (adv) {
        var code = '';
        if($("#sTumbon2").val()!='0')
            code = $("#sTumbon2").val();
        else if($("#sAumphur2").val()!='0')
            code = $("#sAumphur2").val();
        else if($("#sProv2").val()!='0')
            code = $("#sProv2").val();

        dparm = {
            keyword: escape($("#tabSch_advkeyword").val()),
            code: code,
            typeid:$("#sTypeId2").val(),
            lat: map.getCenter().lat,
            lng: map.getCenter().lng
        };
    }
    $.ajax({
        type: 'POST',
        url: "data/dPoiSch.ashx",
        data: dparm,
        cache: false,
        dataType: 'json',
        success: function (data) {
            if (data.result == "ERR") {

            } else if (data.result == "OK") {
                displaySchResult(data.datas);
                //addPOIDone(-data.datas[0].PoiID, null, "sch");
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });
}
function displaySchResult(pois) {
    schPOI_datas = pois;
    var t = "";
    if (pois.length > 0) {
        //t += " พบ " + pois.length + " รายการ ";
    } else {
        t += "<div style='text-align:center'>ไม่พบข้อมูล </div>";
    }
    poiArray_SchTab = [];
    for (var i = 0; i < pois.length; i++) {
        var poi = pois[i];
        var latlng = poi.Points.split(',');
        t += "<a href=\"javascript:selectPoi('sch'," + poi.PoiID + ",1)\">";
        if (poi.PoiType == 1)
            t += "<img src='" + poi.Icon + "' class='icon_small' align='absbottom' />";
        else if (poi.PoiType == 2)
            t += "<img src='images/icons/b_line.png' class='icon_small' align='absbottom' />";
        else if (poi.PoiType == 3)
            t += "<img src='images/icons/b_shape.png' class='icon_small' align='absbottom' />";
        else if (poi.PoiType == 4)
            t += "<img src='images/icons/b_cir.png' class='icon_small' align='absbottom' />";

        t += " " + poi.Name + "</a>";
        var marker = createMarker(poi);
        if (!marker) continue;
        marker.on('click', function (e) {
            selectPoi('sch', e.target.poiid);
        });
        marker.addTo(map);
        poiArray_SchTab.push(marker);
    }
    $("#tabSch_result").html(t);
    $("#tabSch_result").show();



}

function displayLandResult(pois) {
    //schPOI_datas = pois;
    var t = "";
    poiArray_LandTab = [];
    if (pois.length > 0) {
        t += " พบ " + pois.length + " รายการ ";
    } else {
        t += "<div style='text-align:center'>ไม่พบข้อมูล </div>";
    }
    for (var i = 0; i < pois.length; i++) {
        var poi = pois[i];
        var latlng = poi.Points.split(',');
        t += "<a href=\"javascript:selectPoi('land'," + poi.PoiID + ",1)\">";
        if (poi.PoiType == 1) {
            t += "<img src='" + poi.Icon + "' class='icon_small' align='absbottom' />";
        } else if (poi.PoiType == 2) {
            t += "<img src='images/icons/b_line.png' class='icon_small' align='absbottom' />";
        } else if (poi.PoiType == 3) {
            t += "<img src='images/icons/b_shape.png' class='icon_small' align='absbottom' />";
        } else if (poi.PoiType == 4) {
            t += "<img src='images/icons/b_cir.png' class='icon_small' align='absbottom' />";
        }
        t += " " + poi.Name + "</a>";
        var marker = createMarker(poi);
        if (!marker) continue;
        marker.on('click', function (e) {
            selectPoi('land', e.target.poiid);
        });
        marker.addTo(map);
        poiArray_LandTab.push(marker);
    }
   
    $("#tabLand_result").html(t);
    $("#tabLand_result").show();

    
   
}
function clearLandPOI() {
    $("#div_rst").hide();
    
    for (var i = 0; i < poiArray_LandTab.length; i++) {
        map.removeLayer(poiArray_LandTab[i]);
    }
    for (var i = 0; i < dotArray.length; i++) {
        map.removeLayer(dotArray[i]);
    }
    hideInfoTab();
    if (schObject) {
        map.removeLayer(schObject);
        schObject = null;
    }
}

function clearSchPOI(onsch) {
    if (!onsch) {
        $("#tabSch_result").html("");
        $("#tabSch_result").hide();
        $("#tabSch_keyword").val("");
        $("#tabSch_bAdvSch").attr("disabled", "disabled");
        $("#tabSch_bSch").attr("disabled", "disabled");
        $("#tabSch_advkeyword").val("");

        setProv2('sProv2', '0');
        setAumphur2('sAumphur2', '0');
        setTumbon2('sTumbon2', '0');
        setTypeId('sTypeId2', '0');

        $(".easysch").show();
        $(".advsch").hide();
    }
    for (var i = 0; i < poiArray_SchTab.length; i++) {
        map.removeLayer(poiArray_SchTab[i]);
    }
    for (var i = 0; i < dotArray.length; i++) {
        map.removeLayer(dotArray[i]);
    }
    hideInfoTab();
}

function hideInfoTab() {
    $("#info_tab").html("");
    $("#info1").hide();
    if($("#def_tab").html()==""){
        $("#info").hide();
    } else {
       
        $("#info2").click();
    }
}
function selectPoi(tab, poiid,pan) {
    if (selectedPoi) {
        if (selectedPoi.poitype == 1) {
            selectedPoi.setIcon(E$.icon({ iconUrl: selectedPoi.icon, className: 'poiIcon', iconAnchor: [16, 16] }));
        }
        if (selectedPoi.poitype == 3) {
            selectedPoi.setStyle({ fillColor: selectedPoi.color, color: selectedPoi.color });
        } else {
            for (var i = 0; i < dotArray.length; i++) {
                map.removeLayer(dotArray[i]);
            }
        }
    }
    var array = null;
    if (tab == 'sch')
        array = poiArray_SchTab;
    if (tab == 'layer')
        array = poiArray_LayerTab;
    if (tab == 'land')
        array = poiArray_LandTab;
    for (var i = 0; i < array.length; i++) {
        var object = array[i];
        if (object.poiid == poiid) {
            showPoiDetail(poiid,tab);
            selectedPoi = object;
            if (selectedPoi.poitype == 1) {
                selectedPoi.setIcon(E$.icon({ iconUrl: selectedPoi.icon, className: 'selectIcon', iconAnchor: [16, 16] }));
                if (pan) {
                    map.setView(selectedPoi.getLatLng(), 16);
                }
            }
            else if (selectedPoi.poitype == 3) {
                selectedPoi.color=selectedPoi.options.color;
                selectedPoi.setStyle({ fillColor: '#f00', color: '#f00'});
                selectedPoi.bringToFront();
                if (pan) {
                    map.fitBounds(selectedPoi.getBounds());
                }
            }
            else {
                dotArray = [];
                var latlngs = selectedPoi.getLatLngs();
                for (var i = 0; i < latlngs.length; i++) {
                    var dot = E$.marker(latlngs[i], { icon: E$.divIcon({ className: 'dot-icon' }) });
                    dotArray.push(dot);
                    dot.addTo(map);
                }
                if (pan) {
                    map.fitBounds(selectedPoi.getBounds());
                }
            }
            return;
        }
    }
   
}

function createMarker(poi) {
    if (poi.PoiType == 1) {
        var latlng = poi.Points.split(',');
        var marker = E$.marker(new E$.LatLng(latlng[1], latlng[0]), { icon: E$.icon({ iconUrl: poi.Icon, className: 'poiIcon', iconAnchor: [16, 16] }) });
        marker.poitype = poi.PoiType;
        marker.icon = poi.Icon;
        marker.poiid = poi.PoiID;
        return marker;
    }
    if (poi.PoiType == 2) {
        var latlng = poi.Points.split(',');
        var latlngs = [];
        for (var i = 0; i < latlng.length; i += 2) {
            latlngs.push(new E$.LatLng(latlng[i + 1], latlng[i]));
        }
        var color = "#" + poi.LineColor.substring(2);
        var weight = poi.LineColor.substring(2);
        var opacity = poi.LineOpacity / 100.0;
        var polyline = E$.polyline(latlngs, { color: color, weight: poi.LineWidth, opacity: opacity });

        polyline.poitype = poi.PoiType;
        polyline.icon = poi.Icon;
        polyline.poiid = poi.PoiID;
        return polyline;
    }
    if (poi.PoiType == 3) {
        var latlng$ = poi.Points.split('$');
        var latlng = latlng$[0].split(',');
        var latlngs = [];
        for (var i = 0; i < latlng.length; i += 2) {
            latlngs.push(new E$.LatLng(latlng[i + 1], latlng[i]));
        }
        var color = "#" + poi.LineColor.substring(2);
        var fillcolor = "#" + poi.FillColor.substring(2);
        var opacity = poi.LineOpacity / 100.0;
        var fillopacity = poi.FillOpacity / 100.0;
        var polygon = E$.polygon(latlngs, { color: color, weight: poi.LineWidth, opacity: opacity, fillColor: fillcolor, fillOpacity: fillopacity });

        polygon.poitype = poi.PoiType;
        polygon.icon = poi.Icon;
        polygon.poiid = poi.PoiID;
        return polygon;
    }
}



///poidet

function showPoiDetail(poiid, tab) {
    $("#info").show();
    $("#info1").show();
    $("#info1").click();
    $("#info_tab").html(loading);
    $.ajax({
        type: 'POST',
        url: "data/dPoiDet.ashx",
        data: {
            poiid: poiid,
            typeid: 0
        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            if (data.result == "ERR") {

            } else if (data.result == "OK") {
                displayPoiDetail(data.datas, tab);
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });
}

function displayPoiDetail(data,tab) {
    //$("#info_content").html(data.Name);
    var t = "";
    if(data.LyID==1)
        t += "<div style='padding:8px 0 4px 8px'><a id=poidet_a1 class=a_det_selected href='javascript:dispDet(1)'>ข้อมูลแปลงที่ดิน</a> &nbsp;<a class=a_det id=poidet_a2 href='javascript:dispDet(2)'>ข้อมูลการใช้ประโยชน์</a></div>";
    t += "<div id=poidet_d1>";
    t += "<table bgcolor=#cccccc cellspacing=1 cellpadding=4 style='margin:5px'  width='97%'>";
    t += dispPoiCol(data);
    t += "</table>";

    for (var i = 0; i < data.POIForms.length; i++) {
        t += "<br /><b>" + data.POIForms[i].Name + "</b>";
        t += "<table bgcolor=#cccccc cellspacing=1 cellpadding=4  width='99%' style='margin-top:5px'>";
        t += dispPoiCol(data.POIForms[i]);
        t += "</table>";
    }
    t += "</table>";
    t += "</div>";
    t += "<div id=poidet_d2 style='display:none'>";
    t += "</div>";
    var poplatlngs = data.Points.split(',');

    t += "<div style='float:right;margin:20px 0 0px 0'>";
   // t += "<input type=button value='Edit Content' onclick=\"editPoiContent("+data.PoiID+","+data.PoiType+",["+poplatlngs[1]+","+poplatlngs[0]+"],'"+tab+"')\" /> ";
    //t += "<input type=button value='Edit Postion' />";
    t += "</div><br style=clear:both>";
    $("#info_tab").html(t);
}
function dispPoiCol(data) {
    var t = "";
    for (var i = 0; i < data.POICols.length; i++) {
        var poiCol = data.POICols[i];
        t += "<tr bgcolor=#ffffff><td width=40%><b>" + poiCol.Label + "</b></td><td width=60%>";
        if (poiCol.InputType == "T") {
            t += poiCol.Data;
        }
        else if (poiCol.InputType == "S") {
            for (var j = 0; j < poiCol.Options.length; j++) {
                if (poiCol.Options[j].Value == poiCol.Data) {
                    t += poiCol.Options[j].Text;
                    break;
                }
            }
        }
        else if (poiCol.InputType == "D") {
            t += poiCol.Data;
        }
        else if (poiCol.InputType == "C") {
            t += "<input type=checkbox " + (poiCol.Data == "Y" ? "checked" : "") + " disabled />";
        }
        else if (poiCol.InputType == "L") {
            t += "<a href='" + poiCol.Data + "' target=_blank>" + poiCol.Data + "</a>";
        }
        else if (poiCol.InputType == "P") {
            if (poiCol.Data != "")
                t += "<a href='" + poiCol.Data + "' target=_blank><img src='" + poiCol.Data + "' width=100% /></a>";
        }
        else if (poiCol.InputType == "V") {
            if (poiCol.Data != "") {
                var datas = poiCol.Data.split('|');
                if (datas.length == 3) {
                    if (datas[2] != "") {
                        t += "<a href='" + datas[2] + "' target=_blank>" + datas[1] + "</a>";
                    }
                }
            }
        }

        t += " <b>" + poiCol.Unit + "</b></td></tr>";

    }
    return t;
}

var data_pie;
function dispDet(a) {
    if (a == 1) {
        $("#poidet_a1").addClass("a_det_selected");
        $("#poidet_a2").removeClass("a_det_selected");
        $("#poidet_d1").show();
        $("#poidet_d2").hide();
    } else {
        $("#poidet_a2").addClass("a_det_selected");
        $("#poidet_a1").removeClass("a_det_selected");
        $("#poidet_d2").show();
        $("#poidet_d1").hide();
        if ($("#poidet_d2").html() == "") {
            $("#poidet_d2").html(loading);
            $.ajax({
                type: 'POST',
                url: "data/dLandUse.ashx",
                data: {
                    poiid: selectedPoi.poiid
                },
                cache: false,
                dataType: 'json',
                success: function (data) {
                    if (data.result == "ERR") {

                    } else if (data.result == "OK") {
                        data_pie=data.datas;
                        var t = "";
                        t += "<div style='padding:8px;margin:4px;background:#4D91DA;color:#fff;text-align:center'>";
                        t += "<a id=poidetyr_a1 style='color:#fff' href='javascript:dispDetYr(2545)'>ปี พ.ศ. 2545</a> | ";
                        t += "<a id=poidetyr_a2 style='color:#fff' href='javascript:dispDetYr(2554)'>ปี พ.ศ. 2554</a> | ";
                        t += "<a id=poidetyr_a3 style='color:#fff' href='javascript:dispDetYr(0)'>ในอนาคต</a>";
                        t += "</div><div id=poi_det_chart style='text-align:center;width:100%;height:300px'></div>";
                        $("#poidet_d2").html(t);

                        dispDetYr(2554);
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }
            });
        }
    }
}

function dispDetYr(yr) {
    var t = "";
    if (yr > 0)
        t += "<big>ข้อมูลการใช้ประโยชน์ ปี พ.ศ. " + yr + "</big>";
    else
        t += "<big>ข้อมูลการใช้ประโยชน์ในอนาคต</big>";
    $("#poi_det_chart").html(t);
    var iyr = 0;
    if (yr == 2545)
        iyr = 1;
    if (yr == 2554)
        iyr = 2;

    $('#poi_det_chart').highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            margin: [10, 0, 0, 0],
            spacingBottom: 0,
            spacingLeft: 0,
            spacingRight: 0

        },
        title: {
            text: t
        },
        tooltip: {
            pointFormat: '{point.percentage:.1f}%'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                size: '60%',

                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    color: '#000000',
                    connectorColor: '#000000',
                    format: '{point.name}<br />{point.percentage:.1f} %'
                }
            }
        },
        series: [{
            type: 'pie',
            name: '&nbsp;',
            data: data_pie[iyr].Area,
            point: {
                events: {
                    click: function (event) {
                        window.open("LUse/LUseTB.aspx?code=" + escape(this.code));
                    }
                }
            }          

        }]
    });

}
function editPoiContent(poiid, poitype, popCenter,tab) {
    var content = "<iframe id=addPOIFrame width=300 height=300 frameborder=0 src='data/addpoi.aspx?poitype=" + poitype + "&poiid=" + poiid + "&typeid=0&lyid=0&tab="+tab+"' />";
    var offset = -10;
    if (poitype == 1)
        offset = -16;
    setTimeout(function () {
        infoPopup = E$.popup({ offset: [0, offset], autoPanPadding: [10, 80], closeOnClick: false });
        infoPopup.setLatLng(popCenter);
        infoPopup.setContent(content);
        infoPopup.openOn(map);
    }, 200);
}

//bound Tab

function setBoundTab() {
    $("#boundaryTree").jstree({
        "json_data": {
            "ajax": {
                "url": function (node) {
                    if (node == -1) {
                        url = "data/dboundinfo.ashx";
                    }
                    else {
                        nodeId = node.attr('id').replace('li_node_id', '');
                        if (nodeId.length == 2)
                            grp = 'A';
                        if (nodeId.length == 4)
                            grp = 'T';
                        url = "data/dboundinfo.ashx?code=" + nodeId + "&grp=" + grp;
                    }

                    return url;
                },
                "data": function (n) {
                    return n;
                }
            }
        },
        "plugins": ["themes", "json_data", "ui"]

    }).bind("select_node.jstree", function (e, data) {
        $.ajax({
            type: 'POST',
            url: "data/dBoundPnts.ashx",
            data: {
                code: data.rslt.obj.data("id")
            },
            cache: false,
            dataType: 'json',
            success: function (data) {
                if (data.result == "ERR") {

                } else if (data.result == "OK") {
                    displayBoundPnts(data.datas);
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {

            }
        });
    });
}

function displayBoundPnts(data) {
    
    if (boundPolygon)
        map.removeLayer(boundPolygon);

    var latlngs=[];
    for (var i = 0; i < data.length; i ++) {
        var data1=data[i];
        var latlngs1=[];
        for (var j = 0; j < data1.length; j ++) {
            latlngs1.push(new E$.LatLng(data1[j].Y, data1[j].X));
        }
        latlngs.push(latlngs1);
    }
    var color = "#00f";
    var fillcolor = "#00f";
    var opacity = 0.5;
    var fillopacity = 0.05;
    var polygon = E$.multiPolygon(latlngs, { color: color, weight: 2, opacity: opacity, fillColor: fillcolor, fillOpacity: fillopacity,clickable:false });
    boundPolygon = polygon;

    polygon.addTo(map);
    map.fitBounds(polygon.getBounds());
}


//gis Tab
var gisTile = null;
function setGISLayerTab() {
    $("#gislayerTree").jstree({
        "json_data": {
            "ajax": {
                "url": function (node) {
                    return "data/dgislayer.ashx"; ;
                },
                "data": function (n) {
                    return n;
                },
                "cache": false
            }
        },
        "plugins": ["themes", "json_data", "ui", "checkbox"],
        "themes": { "icons": false }

    }).bind("select_node.jstree", function (e, data) {
        if ($('#gislayerTree').jstree("is_checked", "#" + data.rslt.obj.attr("id")))
            $('#gislayerTree').jstree("uncheck_node", "#" + data.rslt.obj.attr("id"));
        else
            $('#gislayerTree').jstree("check_node", "#" + data.rslt.obj.attr("id"));
    }).bind("change_state.jstree", function (e, data) {
        var chkLayers = [];
        $("#gislayerTree li").each(function () {
            if (this.id.indexOf('li_node_id') > -1) {
                var undet = $("#" + this.id + ".jstree-undetermined").length != 0;
                var chked = $("#" + this.id + ".jstree-checked").length != 0;
                var unchked = $("#" + this.id + ".jstree-unchecked").length != 0;
                if (undet) {

                } else if (chked) {
                    var nodeid = this.id.replace("li_node_id", "").replace(/-/g, ':');
                    if (nodeid.substring(0, 4) != '_cat')
                        chkLayers.push(nodeid);
                } else if (unchked) {

                }
            }
        });
        //alert(chkLayers.join(','));
        if (gisTile)
            map.removeLayer(gisTile);
        var layers = chkLayers.join(',')
        url = "wms/gwc.aspx?layers=" + layers + "&z={z}&x={x}&y={y}";
        gisTile = E$.tileLayer(url, { maxZoom: 19 });
        map.addLayer(gisTile);

        loadGISDef(layers);

    });
}

function loadGISDef(layers) {
    if ($("#info_tab").html() == "") {
        $("#info1").hide();
    }
    $("#def_tab").html(loading);
    $.ajax({
        type: 'POST',
        url: "data/dGISDef.ashx",
        data: {
            layers: layers
        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            displayGISDef(data);
         },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });
}

function displayGISDef(data) {
    if (data.length > 0) {
        $("#info").show();
        $("#info2").click();
        $("#info2").show();
    } else {
        $("#def_tab").html("");
        $("#info2").hide();
        if ($("#info_tab").html() == "") {
            $("#info").hide();
        } else {
            $("#info1").click();
        }
        return;
    }
   
    var t = "<table cellspacing=1 cellpadding=4 style='margin-top:10px'  width='99%'>";
    for (var i = 0; i < data.length; i++) {
        var datai = data[i].d;
        t += "<tr bgcolor=#ffffff><td colspan=2><b>" + data[i].n + "</b></td></tr>";
        for (var j = 0; j < datai.length; j++) {
            var dataj = datai[j];
            t += "<tr bgcolor=#ffffff><td width=50 align=center>";

            if (data[i].l == "SMPK:PLLU")
                t += "<a href='LUse/LUseTB.aspx?code=" + escape(dataj.code) + "' target=_blank>";
            if(dataj.c.substring(0,1)=="#")
                t += "<div style='width:40px;height:20px;background:" + dataj.c + ";" + (dataj.c=="#FFFFFF"?"border:1px solid #777":"") + "'></div>";
            else
                t += "<div style='width:40px;height:20px;background:url(files/gisdef/" + dataj.c + ".png)'></div>";
            if (data[i].l == "SMPK:PLLU")
                t += "</a>";
            t += "</td><td>" + dataj.t + "</td></tr>";
        }

    }
    t += "</table>";

    $("#def_tab").html(t);
   
}

//layer Tab
var _selected_LyID='0';
function setLayerTab() {
    alert(1);
    $("#layerTree").jstree({
        "json_data": {
            "ajax": {
                "url": function (node) {
                    return "data/dlayer.ashx"; ;
                },
                "data": function (n) {
                    return n;
                },
                "cache": false
            }
        },
        "plugins": ["themes", "json_data", "ui", "checkbox"],
        "themes": { "icons": false }

    }).bind("select_node.jstree", function (e, data) {
        if ($('#layerTree').jstree("is_checked", "#" + data.rslt.obj.attr("id")))
            $('#layerTree').jstree("uncheck_node", "#" + data.rslt.obj.attr("id"));
        else
            $('#layerTree').jstree("check_node", "#" + data.rslt.obj.attr("id"));

        _selected_LyID = data.rslt.obj.data("id");
    }).bind("change_state.jstree", function (e, data) {
        loadPoifromLayers();
    });
    
}

function loadPoifromLayers() {
    var chkLayers = [];
    $("#layerTree li").each(function () {
        if (this.id.indexOf('li_node_id') > -1) {
            var undet = $("#" + this.id + ".jstree-undetermined").length != 0;
            var chked = $("#" + this.id + ".jstree-checked").length != 0;
            var unchked = $("#" + this.id + ".jstree-unchecked").length != 0;
            if (undet) {

            } else if (chked) {
                chkLayers.push(this.id.replace("li_node_id", "").replace(/-/g, ':'));
            } else if (unchked) {

            }
        }
    });
    //alert(chkLayers.join(','));
    $.ajax({
        type: 'POST',
        url: "data/dPoiGets.ashx",
        data: {
            lyids: chkLayers.join(',')
        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            if (data.result == "ERR") {

            } else if (data.result == "OK") {
                displayLayerResult(data.datas);
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });
}
function displayLayerResult(pois) {
    clearLayerPOI();
    for (var i = 0; i < pois.length; i++) {
        var poi = pois[i];
        var marker = createMarker(poi);
        if (!marker) continue;
        marker.on('click', function (e) {
            selectPoi('layer', e.target.poiid);
        });
        marker.addTo(map);
        poiArray_LayerTab.push(marker);
    }
    if (selectPoiID_afterload > 0) {
        selectPoi('layer', selectPoiID_afterload);
        selectPoiID_afterload = 0;
    }
}

function clearLayerPOI() {
    for (var i = 0; i < poiArray_LayerTab.length; i++) {
        map.removeLayer(poiArray_LayerTab[i]);
    }
    for (var i = 0; i < dotArray.length; i++) {
        map.removeLayer(dotArray[i]);
    }
    dotArray = [];
    poiArray_LayerTab = [];
}


//input form
_selected_TypeID = 0;
function loadInputForm() {
    $("#input_content").html(loading);
    $.ajax({
        type: 'POST',
        url: "data/dPoiType.ashx",
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

function clearInputType() {
    $(".poitype a").each(function (i) {
        $("#" + this.id).removeClass("selected");
    });
}
function selectInputType(typeid,poitype){
    _selected_TypeID = typeid;
    clearInputType();
    $("#poitype_" + typeid).addClass("selected");

    if (poitype == '1')
        addToolClick(ToolMode.pin);
    if (poitype == '2')
        addToolClick(ToolMode.line);
    if (poitype == '3')
        addToolClick(ToolMode.shape);
    if (poitype == '4')
        addToolClick(ToolMode.cir);
}
function displayInputForm(data) {
    var t = "";
    for (var i = 0; i < data.length; i++) {
        var grp = data[i];
        t += "<a href=\"javascript:explandInputTreeGrp(" + grp.GrpID + ")\"><img id='inputTreeGrp"+grp.GrpID+"_icon' src='images/icons/tree-open.png' align=absbottom></a> " + grp.Name + "<br />";
        t += "<div id='inputTreeGrp"+grp.GrpID+"' class=poitype>";
        for (var j = 0; j < grp.Children.length; j++) {
            var child = grp.Children[j];
            t += "<a id=poitype_" + child.TypeID + " href='javascript:selectInputType(" + child.TypeID + "," + child.PoiType + ")'>";
            t += "<img src='" + child.Icon + "' align=absbottom width=24><div>";
            t += "<span>" + child.Name + "</span><br />";
            var poitype = "";
            if (child.PoiType == 1)
                poitype = "Point";
            if (child.PoiType == 2)
                poitype = "Line"; 
            if (child.PoiType == 3)
                poitype = "Polygon";
            if (child.PoiType == 4)
                poitype = "Circle";
            t += "<small>[" + poitype + "]</small></div>";
            t += "</a><br style='clear:both' />";
        }
        t += "</div>";
    }
    $("#input_content").html(t);
}

function explandInputTreeGrp(grpid) {
    if ($("#inputTreeGrp" + grpid).css("display") != "none") {
        $("#inputTreeGrp" + grpid).slideUp();
        $("#inputTreeGrp" + grpid + "_icon").attr("src", "images/icons/tree-close.png");
    } else {
        $("#inputTreeGrp" + grpid).slideDown();
        $("#inputTreeGrp" + grpid + "_icon").attr("src", "images/icons/tree-open.png");
    }
}