var poiArray_SchTab = [];
var poiArray_LayerTab=[];
var selectedPoi = null;
var boundPolygon = null;
var dotArray = [];
var loading = "<div style='text-align:center;margin-top:40px'><img src='images/loading.gif' /></div>";
var selectPoiID_afterload = 0;
var isEditPoiPos = false;
var schPOI_datas;
var backupPoiLLs = null;
function setLayerPanel() {
    $(".css-tabs:first").tabs(".css-panes:first > div");
}
function doSchPOI() {
    $("#tabSch_result").html(loading);
    $("#tabSch_result").show();
    clearSchPOI(1);
    $.ajax({
        type: 'POST',
        url: "data/dPoiSch.ashx",
        data: {
            keyword: escape($("#tabSch_keyword").val()),
            lat: map.getCenter().lat,
            lng: map.getCenter().lng
        },
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
            selectPoi('sch',e.target.poiid);
        });
        marker.addTo(map);
        poiArray_SchTab.push(marker);
    }
    $("#tabSch_result").html(t);
    $("#tabSch_result").show();

    
   
}

function clearSchPOI(onsch) {
    if (!onsch) {
        $("#tabSch_result").html("");
        $("#tabSch_result").hide();
        $("#tabSch_keyword").val("");
    }
    for (var i = 0; i < poiArray_SchTab.length; i++) {
        map.removeLayer(poiArray_SchTab[i]);
    }
    for (var i = 0; i < dotArray.length; i++) {
        map.removeLayer(dotArray[i]);
    }
}

function selectPoi(tab, poiid, pan) {
    if (isEditPoiPos) return;
    if (selectedPoi) {
        if (selectedPoi.poitype == 1) {
            selectedPoi.setIcon(E$.icon({ iconUrl: selectedPoi.icon, className: 'poiIcon', iconAnchor: [16, 16] }));
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
        array = poiArray_LayerTab
    for (var i = 0; i < array.length; i++) {
        var object = array[i];
        if (object.poiid == poiid) {
            showPoiDetail(poiid,tab);
            selectedPoi = object;

            if (selectedPoi.poitype == 1) {
                selectedPoi.setIcon(E$.icon({ iconUrl: selectedPoi.icon, className: 'selectIcon', iconAnchor: [16, 16] }));
                if (pan)
                    map.setView(selectedPoi.getLatLng(), 16);
            }
            else if (selectedPoi.poitype == 4) {
                dotArray = [];
                var latlng = selectedPoi.getLatLng();
                var rll = calCirPoint(latlng,selectedPoi.getRadius());
                for (var i = 0; i < rll.length; i++) {
                    var dot = E$.marker(rll[i], { icon: E$.divIcon({ className: 'dot-icon' }) });
                    dot.idx = i;
                    dotArray.push(dot);
                    dot.addTo(map);
                }
                if (pan)
                    map.fitBounds(selectedPoi.getBounds());
            }
            else {
                dotArray = [];
                var latlngs = selectedPoi.getLatLngs();
                for (var i = 0; i < latlngs.length; i++) {
                    var dot = E$.marker(latlngs[i], { icon: E$.divIcon({ className: 'dot-icon' }) });
                    dot.idx = i;
                    dotArray.push(dot);
                    dot.addTo(map);
                }
                if (pan)
                    map.fitBounds(selectedPoi.getBounds());
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
        var latlng = poi.Points.split(',');
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
    if (poi.PoiType == 4) {
        var latlng = poi.Points.split(',');
        var color = "#" + poi.LineColor.substring(2);
        var fillcolor = "#" + poi.FillColor.substring(2);
        var opacity = poi.LineOpacity / 100.0;
        var fillopacity = poi.FillOpacity / 100.0;
        var circle = E$.circle(new E$.LatLng(latlng[1], latlng[0]), poi.Radius, { color: color, weight: poi.LineWidth, opacity: opacity, fillColor: fillcolor, fillOpacity: fillopacity });
        circle.poitype = poi.PoiType;
        circle.poiid = poi.PoiID;
        
        return circle;
        
    }
}



///poidet

function showPoiDetail(poiid, tab) {
    $("#info").show();
    $("#info_content").html(loading);
    $("#info_content").show();
    $("#info_content2").hide();
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
   
    var t = "<table bgcolor=#cccccc cellspacing=1 cellpadding=4  width='99%'>";
    t += dispPoiCol(data);
    t += "</table>";

    for (var i = 0; i < data.POIForms.length; i++) {
        t += "<br /><b>" + data.POIForms[i].Name+"</b>";
        t += "<table bgcolor=#cccccc cellspacing=1 cellpadding=4  width='99%' style='margin-top:5px'>";
        t += dispPoiCol(data.POIForms[i]);
        t += "</table>";
    }
    var latlngs = data.Points.split(',')

    t += "<div style='float:right;margin:20px 0 20px 0'>";
    t += "<input type=button value='Edit Content' onclick=\"editPoiContent("+data.PoiID+","+data.PoiType+",["+latlngs[1]+","+latlngs[0]+"],'"+tab+"')\" /> ";
    t += "<input type=button value='Edit Postion' onclick=\"editPoiPosition(" + data.PoiID + "," + data.PoiType + ",[" + latlngs[1] + "," + latlngs[0] + "],'" + tab + "')\"/>";
    t += "</div><br style=clear:both>";
    
    $("#info_content").html(t);
    
    t = "<table>";
    for (var i = 0; i < latlngs.length; i+=2) {
        t += "<tr><td>&nbsp;Lat</td><td><input type=text id='poiPos" + (i / 2) + "_Lat' style='width:75px' value='" + degreeFormat(latlngs[i + 1]) + "' onkeyup=\"checkValidLL(this.id,-90,90)\" /></td><td>&nbsp;Long</td><td><input type=text id='poiPos" + (i / 2) + "_Lng' style='width:75px' value='" + degreeFormat(latlngs[i]) + "' onkeyup=\"checkValidLL(this.id,-180,180)\" /></td></tr>";
    }
    if (data.PoiType == "4") {
        t += "<tr><td>&nbsp;Radius</td><td><input type=text id='poiPos_Radius' style='width:75px' value='" + data.Radius.toFixed(0) + "' onkeyup=\"checkValidLL(this.id,0,1000000000)\" /> </td><td>m.</td></tr>";
    }
    t += "</table>";
    
    $("#info_position").html(t);
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

function checkValidLL(c, v1, v2) {
    var v = $("#" + c).val();
    if (isNaN(v) || v < v1 || v > v2) {
        alert("Invalid data input");
    } else {
        if (selectedPoi.poitype == 1) {
            var LL = [$("#poiPos0_Lat").val(), $("#poiPos0_Lng").val()];
            selectedPoi.setLatLng(LL);
        }
        if (selectedPoi.poitype == 2 || selectedPoi.poitype == 3) {
            var LLS = [];
            var lls = selectedPoi.getLatLngs();
            for (var i = 0; i < lls.length; i++) {
                var LL = new E$.LatLng($("#poiPos" + i + "_Lat").val(), $("#poiPos" + i + "_Lng").val());
                LLS.push(LL);
                dotArray[i].setLatLng(LL);
            }
            selectedPoi.setLatLngs(LLS);
        }
        if (selectedPoi.poitype == 4) {
            var LL = [$("#poiPos0_Lat").val(), $("#poiPos0_Lng").val()];
            selectedPoi.setLatLng(LL);
            var rll = calCirPoint(selectedPoi.getLatLng(), selectedPoi.getRadius());
            for (var j = 0; j < rll.length; j++) {
                dotArray[j].setLatLng(rll[j]);
            }
        }
    }
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


function editPoiPosition() {
    
    $("#bSave_Pos").removeAttr("disabled");
    $("#iLoad_Pos").hide();
    $("#info_content2").show();
    $("#info_content").hide();
    isEditPoiPos = true;
    backupPoiPosition();

    if (selectedPoi.poitype == 1) {
        selectedPoi.dragging.enable();
        selectedPoi.on("drag", function (e) {
            var latlng = e.target.getLatLng();
            $("#poiPos0_Lat").val(degreeFormat(latlng.lat));
            $("#poiPos0_Lng").val(degreeFormat(latlng.lng));
        });
    }
    if (selectedPoi.poitype == 2 || selectedPoi.poitype == 3) {
        for (var i = 0; i < dotArray.length; i++) {
            dotArray[i].dragging.enable();
            dotArray[i].on("drag", function (e) {
                var latlng = e.target.getLatLng();
                $("#poiPos" + e.target.idx + "_Lat").val(degreeFormat(latlng.lat));
                $("#poiPos" + e.target.idx + "_Lng").val(degreeFormat(latlng.lng));
                var latlngs = selectedPoi.getLatLngs();
                latlngs[e.target.idx] = latlng;
                selectedPoi.setLatLngs(latlngs);
            });
        }

    }
    if (selectedPoi.poitype == 4) {
        $("#poiPos_r_tr").show();
         for (var i = 0; i < dotArray.length; i++) {
            dotArray[i].dragging.enable();
            dotArray[i].on("drag", function (e) {
                var latlng = e.target.getLatLng();
                if (e.target.idx == 0) {
                    $("#poiPos" + e.target.idx + "_Lat").val(degreeFormat(latlng.lat));
                    $("#poiPos" + e.target.idx + "_Lng").val(degreeFormat(latlng.lng));
                    selectedPoi.setLatLng(latlng);

                    var rll = calCirPoint(latlng, selectedPoi.getRadius());
                    for (var j = 1; j < rll.length; j++) {
                        dotArray[j].setLatLng(rll[j]);
                    }
                } else {
                    var newr = latlng.distanceTo(selectedPoi.getLatLng());
                    selectedPoi.setRadius(newr);
                    var rll = calCirPoint(selectedPoi.getLatLng(), newr);
                    for (var j = 1; j < rll.length; j++) {
                        dotArray[j].setLatLng(rll[j]);
                    }
                    $("#poiPos_Radius").val(newr.toFixed(0));
                }
            });
        }
        
    }
}

function cancelEditPos(isres) {
    $("#info_content").show();
    $("#info_content2").hide();
    if (selectedPoi.poitype == 1) {
        selectedPoi.dragging.disable();
        selectedPoi.off("drag");
    }
    if (selectedPoi.poitype == 2 || selectedPoi.poitype == 3) {
        for (var i = 0; i < dotArray.length; i++) {
            dotArray[i].dragging.disable();
            dotArray[i].off("drag");
        }
    }
    if (selectedPoi.poitype == 4) {
        for (var i = 0; i < dotArray.length; i++) {
            dotArray[i].dragging.disable();
            dotArray[i].off("drag");
        }
    }
    isEditPoiPos = false;
    if (isres)
        restorePoiPosition();
}

function saveEditPos() {
    $("#iLoad_Pos").show();
    $("#bSave_Pos").attr("disabled", "disabled");
    var points = "";
    var area = 0;
    var distance = 0;
    var radius = 0;
    var poiid = selectedPoi.poiid;
    if (selectedPoi.poitype == 1 || selectedPoi.poitype == 4) {
        points = selectedPoi.getLatLng().lng+","+selectedPoi.getLatLng().lat;
        if (selectedPoi.poitype == 4) {
            radius = selectedPoi.getRadius();
            area = Math.PI * radius * radius;
        }
    } else {
        var lls = selectedPoi.getLatLngs();
        for(var i=0;i<lls.length;i++){
            if(i>0) points+=",";
             points += lls[i].lng + "," + lls[i].lat;
         }
         if (selectedPoi.poitype == 2) {
             distance = calDist(lls);
         }
         if (selectedPoi.poitype == 3) {
             distaareance = calArea(lls);
         }
    }
    $.ajax({
        type: 'POST',
        url: "data/dPoiPos.ashx",
        data: {
            poiid: poiid,
            points: points,
            distance:distance,
            area:area,
            radius:radius
        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            if (data.result == "ERR") {
                alert("Edit Positioin Error");
            } else if (data.result == "OK") {
                cancelEditPos();
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            alert("Edit Positioin Error");
        }
    });
}

function backupPoiPosition() {
    if (selectedPoi.poitype == 1 || selectedPoi.poitype == 4) {
        backupPoiLLs = selectedPoi.getLatLng();
        if (selectedPoi.poitype == 4)
            backupPoiLLs.radius = selectedPoi.getRadius();
    } else {
        backupPoiLLs = selectedPoi.getLatLngs();
    }
}
function restorePoiPosition() {
    if (selectedPoi.poitype == 1 || selectedPoi.poitype == 4) {
        selectedPoi.setLatLng(backupPoiLLs);
        if (selectedPoi.poitype == 4) {
            selectedPoi.setRadius(backupPoiLLs.radius);
            var rll = calCirPoint(backupPoiLLs, selectedPoi.getRadius());
            for (var j = 0; j < rll.length; j++) {
                dotArray[j].setLatLng(rll[j]);
            }
        }
    } else {
        selectedPoi.setLatLngs(backupPoiLLs);
        var lls = backupPoiLLs;
        for (var i = 0; i < lls.length; i++) {
            dotArray[i].setLatLng(lls[i]);
        }
    }
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
                    return "data/dgislayer.ashx";
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
                    chkLayers.push(this.id.replace("li_node_id","").replace(/-/g, ':'));
                } else if (unchked) {
                    
                }
            }
        });
        //alert(chkLayers.join(','));
        if (gisTile)
            map.removeLayer(gisTile);
        url = "Wms/gwc.aspx?layers="+chkLayers.join(',')+"&z={z}&x={x}&y={y}";
        gisTile = E$.tileLayer(url, {maxZoom: 19});
        map.addLayer(gisTile);
    });
}


//layer Tab
var _selected_LyID='0';
function setLayerTab() {
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

function explandInputTreeGrp(grpid) {$('element:visible')
    if ($("#inputTreeGrp" + grpid).css("display") != "none") {
        $("#inputTreeGrp" + grpid).slideUp();
        $("#inputTreeGrp" + grpid + "_icon").attr("src", "images/icons/tree-close.png");
    } else {
        $("#inputTreeGrp" + grpid).slideDown();
        $("#inputTreeGrp" + grpid + "_icon").attr("src", "images/icons/tree-open.png");
    }
}