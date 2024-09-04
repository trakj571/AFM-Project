var poiArray_SchTab = [];
var poiArray_LandTab = [];
var poiArray_LayerTab = [];
var poiArray_PlaceTab = [];
var poiArray_Track = [];
var poiArray_View = [];
var selectedPoi = null;
var boundPolygon = null;
var dotArray = [];
var loading = "<div style='text-align:center;margin-top:40px'><img src='images/loading.gif' /></div>";
var selectPoiID_afterload = 0;
var schPOI_datas, landPOI_datas;
var schObject = null;
var isEditPoiPos = false;
var backupPoiLLs = null;

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
    //if (!adv && $("#tabSch_keyword").val().length < 2) return;
    //if (adv && $("#tabSch_advkeyword").val().length < 2) return;
    $("#tabSch_result").html(loading);
    $("#tabSch_result").show();
    clearSchPOI(1);


    $.ajax({
        type: 'POST',
        url: "data/dPoiSch.ashx",
        data: {
            keyword: "",
            lat: map.getCenter().lat,
            lng: map.getCenter().lng,
            lyids: $("#sCamera").val()
        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            if (data.result == "ERR") {

            } else if (data.result == "OK") {
                displaySchResult(data.datas);
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
    landPOI_datas = pois;
    var t = "";
    poiArray_LandTab = [];
    if (pois.length > 0) {
        t += "<p>พบ " + pois.length + " รายการ</p>";
    } else {
        t += "<p>ไม่พบข้อมูล </p>";
    }
    t += "<ul>";
    for (var i = 0; i < pois.length; i++) {
        var poi = pois[i];
        var latlng = poi.Points.split(',');
        t += "<li><a href=\"javascript:selectPoi('land'," + poi.PoiID + ",1)\">";
        if (poi.PoiType == 1) {
            t += "<img src='" + poi.Icon + "' class='icon_small' align='absbottom' />";
        } else if (poi.PoiType == 2) {
            t += "<img src='images/icons/b_line.png' class='icon_small' align='absbottom' />";
        } else if (poi.PoiType == 3) {
            t += "<img src='images/icons/b_shape.png' class='icon_small' align='absbottom' />";
        } else if (poi.PoiType == 4) {
            t += "<img src='images/icons/b_cir.png' class='icon_small' align='absbottom' />";
        }
        t += " " + poi.Name + "</a></li>";
        var marker = createMarker(poi);
        if (!marker) continue;
        marker.on('click', function (e) {
            selectPoi('land', e.target.poiid);
        });
        marker.addTo(map);
        poiArray_LandTab.push(marker);
    }
    t += "</ul>";
    parent.$("#tabLayer_result").html(t);
   
    //loadGISDef(getChkLayers());
   
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
    poiArray_LandTab = [];
    loadGISDef(getChkLayers());
}

function clearSchPOI(onsch) {
    if (!onsch) {
        $("#tabLayer_result").html("");
    }
    for (var i = 0; i < poiArray_SchTab.length; i++) {
        map.removeLayer(poiArray_SchTab[i]);
    }
    for (var i = 0; i < dotArray.length; i++) {
        map.removeLayer(dotArray[i]);
    }
    hideInfoTab();
    playVideo("");
    if (playhisMarker)
        map.removeLayer(playhisMarker);
    if (playhisIns) 
        clearTimeout(playhisIns);
    closePOIInfo();
}

function hideInfoTab() {
    //parent.$('.afms-sec-mapinfo').removeClass('is-active');
    parent.$('.afms-sec-mapevent , .afms-sec-mapinfo , .afms-sec-mapstreet , .afms-sec-mapsensor').removeClass('is-active');
    
   /*
    $("#info_tab").html("");
    //$("#info1").hide();
    if($("#def_tab").html()==""){
        //$("#info").hide();
    } else {
        $("#info2").click();
    }*/
}
function selectPoi(tab, poiid, pan, noinfo) {
    if (isEditPoiPos) return;
    if (selectedPoi) {
       
        if (selectedPoi.poitype == 1) {
            selectedPoi.setIcon(E$.icon({ iconUrl: selectedPoi.icon, className: 'poiIcon', iconAnchor: selectedPoi.options.icon.options.iconAnchor, popupAnchor: selectedPoi.options.icon.options.popupAnchor }));
        }
        else {
            if (selectedPoi.poitype == 2) {
                selectedPoi.setStyle({ color: selectedPoi.color });

            }
            if (selectedPoi.poitype == 3) {
                if (selectedPoi.gtype == 2)
                    selectedPoi.setStyle(selectedPoi.old_style);
                else
                    selectedPoi.setStyle({ fillColor: selectedPoi.fillColor, color: selectedPoi.color });

            }
            for (var i = 0; i < dotArray.length; i++) {
                map.removeLayer(dotArray[i]);
            }
            selectedPoi.bindLabel(selectedPoi.title);
        }
    }
    if (typeof (onSelectPOI) != "undefined") {
        onSelectPOI(poiid);
    }
    var array = null;
    if (tab == 'sch')
        array = poiArray_SchTab;
    if (tab == 'layer')
        array = poiArray_LayerTab;
    if (tab == 'land')
        array = poiArray_LandTab;
    if (tab == 'added')
        array = poiArray_Added;
    if (tab == 'place')
        array = poiArray_PlaceTab;

    
    for (var i = 0; i < array.length; i++) {
        var object = array[i];
        //alert(object.poiid + " " + poiid);
        if (object.poiid == poiid) {
            if (!noinfo)
               showPoiDetail(poiid, tab);
            selectedPoi = object;
            if (selectedPoi.poitype == 1) {
                selectedPoi.setIcon(E$.icon({ iconUrl: selectedPoi.icon, className: 'selectIcon', iconAnchor: selectedPoi.options.icon.options.iconAnchor, popupAnchor: selectedPoi.options.icon.options.popupAnchor }));
                object.openPopup();
                if (selectedPoi.equType != "STN") {
                    if (pan && selectedPoi.getLatLng()) {
                        map.setView(selectedPoi.getLatLng(), 16);
                    }
                }

            } else if (selectedPoi.poitype == 4) {
                selectedPoi.unbindLabel();
                dotArray = [];
                var latlng = selectedPoi.getLatLng();
                var rll = calCirPoint(latlng, selectedPoi.getRadius());
                for (var i = 0; i < rll.length; i++) {
                    var dot = E$.marker(rll[i], { icon: E$.divIcon({ className: 'dot-icon' }) });
                    dot.idx = i;
                    dotArray.push(dot);
                    dot.addTo(map);
                }
                if (pan) {
                    map.fitBounds(selectedPoi.getBounds(), { padding: [100, 100] });
                }
            }
            else {
                selectedPoi.unbindLabel();
                if (selectedPoi.poitype == 3) {
                    if (selectedPoi.gtype == 2) {
                        selectedPoi.old_style = selectedPoi.options.style;
                        var new_style = {
                            color: '#ff0000',
                            fillColor: '#ff0000'

                        }
                        selectedPoi.setStyle(new_style);

                    } else {
                        selectedPoi.color = selectedPoi.options.color;
                        selectedPoi.fillColor = selectedPoi.options.fillColor;
                        selectedPoi.setStyle({ fillColor: '#ff0000', color: '#ff0000' });
                        selectedPoi.bringToFront();
                    }
                }
                if (selectedPoi.poitype == 2) {
                    selectedPoi.color = selectedPoi.options.color;
                    selectedPoi.setStyle({ color: '#ff0000' });
                    selectedPoi.bringToFront();

                }
                //alert(selectedPoi.poitype + " " + selectedPoi.gtype);
                if (!selectedPoi.hidedot) {
                    dotArray = [];
                    var latlngs;
                    if (selectedPoi.poitype == 3 && selectedPoi.gtype == 2) {
                        latlngs = selectedPoi.latlngs;
                    }
                    else
                        latlngs = selectedPoi.getLatLngs();

                    for (var i = 0; i < latlngs.length; i++) {
                        var dot = E$.marker(latlngs[i], { icon: E$.divIcon({ className: 'dot-icon' }) });
                        dot.idx = i;
                        dotArray.push(dot);
                        dot.addTo(map);
                    }
                }
                if (pan) {
                    map.fitBounds(selectedPoi.getBounds(), { padding: [100, 100] });
                }
            }
            return;
        }
    }

}

function createMarker(poi) {
    var title = poi.Name;
    var titles = title.split('-');

    if (poi.PoiType == 1) {
        var ELatLng = null;
        if (poi.Points != "") {
            var latlng = poi.Points.split(',');
            ELatLng= new E$.LatLng(latlng[1], latlng[0])
        }
        var marker = E$.marker(ELatLng, { icon: E$.icon({ iconUrl: poi.Icon, className: 'poiIcon', iconAnchor: [16, poi.EquType=="GPS"?16:32],popupAnchor: [0, -32]}), title: title });
        marker.poitype = poi.PoiType;
        marker.icon = poi.Icon;
        marker.poiid = poi.PoiID;
        marker.setRotationAngle(poi.Heading);
        marker.equType = poi.EquType;
        if (poi.EquType == "GPS") {
            marker.bindLabel(title, { noHide: true, className: "label-gps", offset: [20, 0] });

            var latlng = poi.Points.split(',');
            var latlngs = [];
            for (var i = 0; i < latlng.length && latlng.length > 1; i += 2) {
                latlngs.push(new E$.LatLng(latlng[i + 1], latlng[i]));
            }
            var color = "#00FF00" ;
            var weight = 3;
            var opacity = 0.5;
            var polyline = E$.polyline(latlngs, { color: color, weight: weight, opacity: opacity, title: title });
            polyline.poitype = 2;
            polyline.icon = poi.Icon;
            polyline.poiid = poi.PoiID;
            marker.gpsline = polyline;
        }
        if (poi.Radius > 0) {
            var circle = E$.circle(new E$.LatLng(latlng[1], latlng[0]), poi.Radius, { color: '#0000FF', weight: 2, opacity: 0.8, fillColor: '#0000FF', fillOpacity: 0.3 });
            marker.circle = circle;
        }
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
        var polyline = E$.polyline(latlngs, { color: color, weight: poi.LineWidth, opacity: opacity, title: title });
        polyline.bindLabel(title);
        polyline.poitype = poi.PoiType;
        polyline.icon = poi.Icon;
        polyline.poiid = poi.PoiID;
        polyline.title = title;
        polyline.hidedot = poi.HideDot;
        return polyline;
    }
    if (poi.PoiType == 3) {
        var latlngmp = [];
        var latlng$ = poi.Points.split('$');
        var latlngs1 = [];
            
        for(var k=0;k<latlng$.length;k++){
            var latlngs = [];
            var latlng = latlng$[k].split(',');
            for (var i = 0; i < latlng.length; i += 2) {
                if (latlng$.length > 1) {
                    latlngs.push([latlng[i], latlng[i + 1]]);
                    if(k==0)
                        latlngs1.push(new E$.LatLng(latlng[i + 1], latlng[i]));
                } else {
                    latlngs.push(new E$.LatLng(latlng[i + 1], latlng[i]));
                }
            }
            latlngmp.push(latlngs);
        }
        var color = "#" + poi.LineColor.substring(2);
        var fillcolor = "#" + poi.FillColor.substring(2);
        var opacity = poi.LineOpacity / 100.0;
        var fillopacity = poi.FillOpacity / 100.0;
        
        var polygon;
        if(latlng$.length==1){
            polygon = E$.polygon(latlngs, { color: color, weight: poi.LineWidth, opacity: opacity, fillColor: fillcolor, fillOpacity: fillopacity});
            polygon.gtype = 1;
        }else{
            var mp = {
                "type": "Feature",
                "geometry": {
                    "type": "MultiPolygon",
                    "coordinates": [latlngmp]
      
                },
                "properties": {
                    "name": "MultiPolygon",
                    "style": {
                        color: color,
                        opacity: opacity,
                        fillColor: fillcolor,
                        fillOpacity: fillopacity,
                        weight:poi.LineWidth
                    }
                }
            };

           polygon = new E$.GeoJSON(mp, {
                style: function (feature) {
                    return feature.properties.style
                }
            });
            polygon.gtype = 2;
            polygon.latlngs = latlngs1;
        }
        polygon.bindLabel(title);
        polygon.poitype = poi.PoiType;
        polygon.icon = poi.Icon;
        polygon.poiid = poi.PoiID;
        polygon.title = title;
        return polygon;
    }
    if (poi.PoiType == 4) {
        var latlng = poi.Points.split(',');
        var color = "#" + poi.LineColor.substring(2);
        var fillcolor = "#" + poi.FillColor.substring(2);
        var opacity = poi.LineOpacity / 100.0;
        var fillopacity = poi.FillOpacity / 100.0;
        var circle = E$.circle(new E$.LatLng(latlng[1], latlng[0]), poi.Radius, { color: color, weight: poi.LineWidth, opacity: opacity, fillColor: fillcolor, fillOpacity: fillopacity, title: title });
        circle.bindLabel(title);
        circle.poitype = poi.PoiType;
        circle.poiid = poi.PoiID;
        circle.title = title;
        return circle;

    }
}



///poidet

function showPoiDetail(poiid, tab,iscreatemarker) {
    if (mMode == "") {
        $("#info").show();
        $("#info1").show();
        $("#info1").click();
        $("#info_tab").html(loading);
        $("#info-min").hide();

    } else {
        $("#info-min").show();
    }
    parent.openInfo(loading, "");
   
    //window.open("data/dPoiDet.ashx?poiid=" + poiid);
    $.ajax({
        type: 'POST',
        url: "data/dPoiDet.ashx",
        data: {
            poiid: poiid,
            rmt_lyids:rmt_lyids,
            typeid: 0
        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            if (data.result == "ERR") {

            } else if (data.result == "OK") {
                displayPoiDetail(data.datas, tab, poiid, iscreatemarker);
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });
    if (tab == "layer" || tab == "event") {
        syncPoiGPSDet(poiid);
    }
    else if(tab == "sch"){
        dispHisGSPDet(poiid);
    }
}

function displayPoiDetail(data, tab, poiid, iscreatemarker) {
    if (iscreatemarker) {
        event_marker = createMarker(data);
        if (!event_marker) return;
        event_marker.on('click', function (e) {
            selectPoi('added', e.target.poiid);
        });
        event_marker.addTo(map);
        poiArray_Added.push(event_marker)
        map.setView(event_marker.getLatLng(), 16);

    }
    if (data.EquType == "GPS") {
       // $("#los-disp").show();
       // $("#los-t-1").show();
       // $("#los-t-2").show();
       // $("#los-t-1").click();
    }
    
    if (rmt_lyids != "") {
        parent.openInfo(data.FreqStat, data.EquType);
        return;
    }

    var t = "";
    t += "<div id=poidet_d1>";
    t += "<table bgcolor=#cccccc cellspacing=1 cellpadding=4 style='margin:5px'  width='97%'>";
    t += dispPoiCol(data, tab, poiid);
    t += "</table>";

    for (var i = 0; i < data.POIForms.length; i++) {
        t += "<br /><b>" + data.POIForms[i].Name + "</b>";
        t += "<table bgcolor=#cccccc cellspacing=1 cellpadding=4  width='99%' style='margin-top:5px'>";
        t += dispPoiCol(data.POIForms[i], tab, poiid);
        t += "</table>";
    }
    //t += "</table>";
    
    t += "</div>";
    t += "<div id=poidet_d2 style='display:none'>";
    t += "</div>";

    var te = "";
    if (data.EquType == "") {
        var latlngs = data.Points.split(',')
        t += "<table width='100%'><tr><td style='padding:2px;'><input style='font-size:12px' type=button value='KMZ Export' onclick=\"window.open('Kmz/export.aspx?poiid=" + data.PoiID+"')\" /></td> ";
        t += "<td style='padding:2px;'><input style='font-size:12px' type=button value='Edit Content' onclick=\"iMap.editPoiContent(" + data.PoiID + "," + data.PoiType + ",[" + latlngs[1] + "," + latlngs[0] + "],'" + tab + "')\" /></td>";
        t += "<td style='padding:2px;'><input style='font-size:12px' type=button value='Edit Postion' onclick=\"iMap.editPoiPosition(" + data.PoiID + "," + data.PoiType + ",[" + latlngs[1] + "," + latlngs[0] + "],'" + tab + "')\"/></td>";
        t += "</tr></table><br style=clear:both>";
      
        te = "<table>";
        for (var i = 0; i < latlngs.length; i += 2) {
            te += "<tr><td>&nbsp;Lat</td><td><input type=text id='poiPos" + (i / 2) + "_Lat' style='width:75px' value='" + degreeFormat(latlngs[i + 1]) + "' onkeyup=\"checkValidLL(this.id,-90,90)\" /></td><td>&nbsp;Long</td><td><input type=text id='poiPos" + (i / 2) + "_Lng' style='width:75px' value='" + degreeFormat(latlngs[i]) + "' onkeyup=\"iMap.checkValidLL(this.id,-180,180)\" /></td></tr>";
        }
        if (data.PoiType == "4") {
            te += "<tr><td>&nbsp;Radius</td><td><input type=text id='poiPos_Radius' style='width:75px' value='" + data.Radius.toFixed(0) + "' onkeyup=\"checkValidLL(this.id,0,1000000000)\" /> </td><td>m.</td></tr>";
        }
        te += "</table>";
        te += "<table width='100%'><tr><td style='padding:2px;'><img id=iLoad_Pos src='images/loading.gif' width=20 align=absbottom style='display:none' /></td><td style='padding:2px;'><input style='font-size:12px'  id=bSave_Pos type=button value='Save' onclick='iMap.saveEditPos()' /></td><td style='padding:2px;'><input style='font-size:12px'  type=button value='Cancel' onclick='iMap.cancelEditPos(1)' /></td></tr></table>";
    }
    var html = "<div id='info_content1'>" + t + "</div><div id='info_content2' style='display:none'>" + te + "<div id='info_position' style='display:none'></div></div>";

    parent.openInfo(html, data.EquType);
    parent.iStView.setCenter(data.Lat, data.Lng);
    if (data.EquType == "STN") {
        parent.loadEventInfo(poiid);
    }
                               
   
}
function dispPoiCol(data, tab, poiid) {
    var t = "";
    var isMoreDet = false;
    var isPlayVideo = false;
    for (var i = 0; i < data.POICols.length; i++) {
        var poiCol = data.POICols[i];
        if(poiCol.IsHide){
            if (poiCol.InputType == "L" && poiCol.DataName == "WEB_Link") {
                if (!isPlayVideo) {
                    isPlayVideo = true;
                    if (tab == "sch")
                        playBackVideo(poiCol.Data, data.PointHis, poiid);
                    else

                        playVideo(poiCol.Data, poiid);
                }
            }
            continue;
        }
        t += "<tr bgcolor=#ffffff><td width=100%><b>" + poiCol.Label + "</b></td></tr><tr><td width=100%>";
        if (poiCol.InputType == "T") {
            t += poiCol.Data;
        }
        else if (poiCol.InputType == "S") {
            if (poiCol.Options) {
                for (var j = 0; j < poiCol.Options.length; j++) {
                    if (poiCol.Options[j].Value.toUpperCase() + "" == poiCol.Data.toUpperCase() + "") {
                        t += poiCol.Options[j].Text;
                        break;
                    }
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
                        t += "<a href='javascript:playVideo(\"" + datas[2] + "\")'>" + datas[1] + "</a>";
                        if (!isPlayVideo) {
                            isPlayVideo = true;
                            playVideo(datas[2], poiid);
                        }
                    }
                }
            }
        }

        t += " <b>" + poiCol.Unit + "</b><br /><br /></td></tr>";
    }

   
    if (!isPlayVideo) {
        playVideo("");
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
                        data_pie = data.datas;
                        var t = "";
                        t += "<div style='padding:8px;margin:4px;background:#4D91DA;color:#fff;text-align:center'>";
                        t += "<a id=poidetyr_a1 style='color:#fff' href='javascript:dispDetYr(2545)'>ปี พ.ศ. 2545</a> | ";
                        t += "<a id=poidetyr_a2 style='color:#fff' href='javascript:dispDetYr(2554)'>ปี พ.ศ. 2554</a> | ";
                        t += "<a id=poidetyr_a3 style='color:#fff' href='javascript:dispDetYr(0)'>ในอนาคต</a>";
                        t += "</div><div id=poi_det_chart style='text-align:center;width:100%;height:300px'></div>";
                        t += "<div style='text-align:right'>* สัดส่วนโดยประมาณ &nbsp;</div>";
                        t += "<div id=data_frm style='color:#777'></div><br />";
                        $("#poidet_d2").html(t);

                        dispDetYr(0);
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
    if (yr == 2545) {
        iyr = 1;
        $("#data_frm").html("&nbsp;ที่มา : กรมพัฒนาที่ดิน");
    }
    else if (yr == 2554) {
        iyr = 2;
        $("#data_frm").html("&nbsp;ที่มา : กรมพัฒนาที่ดิน");
    } else {
        $("#data_frm").html("&nbsp;ที่มา : สำนักงานโยธาธิการและผังเมือง จังหวัดสมุทรปราการ");
    }
    $('#poi_det_chart').highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            //margin: [10, 0, 0, 0],
            spacingBottom: 0,
            spacingLeft: 0,
            spacingRight: 0

        },
        title: {
            text: t
        },
        tooltip: {
            //pointFormat: (iyr == 0 ? 'Block ที่ <br /><span style="font-size:9px">คลิกเพื่อดูรายละเอียดข้อกำหนด</span>' : '{point.percentage:.1f}%')
            formatter: function () {
                if (iyr == 0)
                    return 'Block ที่ ' + this.point.name + '<br /><span style="font-size:9px">คลิกเพื่อดูรายละเอียดข้อกำหนด</span>';
                else
                    return this.point.name;

            }

        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                //size: '30%',

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
                        if (yr == 0)
                            window.open("LUse/LUseTB.aspx?code=" + escape(this.code));
                    }
                }
            }

        }]
    });

}
function editPoiContent(poiid, poitype, popCenter, tab) {
   
    var content = "<iframe id=addPOIFrame width=300 height=300 frameborder=0 src='data/addpoi.aspx?poitype=" + poitype + "&poiid=" + poiid + "&typeid=0&lyid=0&tab="+tab+"' />";
    var offset = -10;
    if (poitype == 1)
        offset = -16;
    setTimeout(function () {
        infoPopup = E$.popup({ offset: [0, offset], autoPanPadding: [10, 80], closeOnClick: false });
        infoPopup.setLatLng(popCenter);
        infoPopup.setContent(content);
        infoPopup.openOn(map);

        closePOIInfo();
    }, 200);
}

function editPoiPosition() {
    if (selectedPoi.poitype == 3 && selectedPoi.gtype == 2)
        return;
    setWindowSize();

    parent.$("#bSave_Pos").removeAttr("disabled");
    parent.$("#iLoad_Pos").hide();
    parent.$("#info_content2").show();
    parent.$("#info_content1").hide();
    isEditPoiPos = true;
    backupPoiPosition();

    if (selectedPoi.poitype == 1) {
        selectedPoi.dragging.enable();
        selectedPoi.on("drag", function (e) {
            var latlng = e.target.getLatLng();
            parent.$("#poiPos0_Lat").val(degreeFormat(latlng.lat));
            parent.$("#poiPos0_Lng").val(degreeFormat(latlng.lng));
        });
    }
    if (selectedPoi.poitype == 2 || (selectedPoi.poitype == 3 && selectedPoi.gtype==1)) {
        /*dotArray = [];
        var latlngs = selectedPoi.getLatLngs();
        for (var i = 0; i < latlngs.length; i++) {
            var dot = E$.marker(latlngs[i], { icon: E$.divIcon({ className: 'dot-icon' }) });
            dot.idx = i;
            dotArray.push(dot);
            dot.addTo(map);
        }*/
        for (var i = 0; i < dotArray.length; i++) {
            dotArray[i].dragging.enable();
            dotArray[i].on("drag", function (e) {
                var latlng = e.target.getLatLng();
                parent.$("#poiPos" + e.target.idx + "_Lat").val(degreeFormat(latlng.lat));
                parent.$("#poiPos" + e.target.idx + "_Lng").val(degreeFormat(latlng.lng));
                var latlngs = selectedPoi.getLatLngs();
                latlngs[e.target.idx] = latlng;
                selectedPoi.setLatLngs(latlngs);
            });
        }

    }
    if (selectedPoi.poitype == 4) {
        parent.$("#poiPos_r_tr").show();
        for (var i = 0; i < dotArray.length; i++) {
            dotArray[i].dragging.enable();
            dotArray[i].on("drag", function (e) {
                var latlng = e.target.getLatLng();
                if (e.target.idx == 0) {
                    parent.$("#poiPos" + e.target.idx + "_Lat").val(degreeFormat(latlng.lat));
                    parent.$("#poiPos" + e.target.idx + "_Lng").val(degreeFormat(latlng.lng));
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
                    parent.$("#poiPos_Radius").val(newr.toFixed(0));
                }
            });
        }

    }
}

function cancelEditPos(isres) {
    parent.$("#info_content1").show();
    parent.$("#info_content2").hide();
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
    parent.$("#iLoad_Pos").show();
    parent.$("#bSave_Pos").attr("disabled", "disabled");
    var points = "";
    var area = 0;
    var distance = 0;
    var radius = 0;
    var poiid = selectedPoi.poiid;
    var poitype = selectedPoi.poitype;
    if (poitype == 1 || poitype == 4) {
        points = selectedPoi.getLatLng().lng + "," + selectedPoi.getLatLng().lat;
        if (selectedPoi.poitype == 4) {
            radius = selectedPoi.getRadius();
            area = Math.PI * radius * radius;
        }
    } else {
        var lls = selectedPoi.getLatLngs();
        for (var i = 0; i < lls.length; i++) {
            if (i > 0) points += ",";
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
            poitype:poitype,
            points: points,
            distance: distance,
            area: area,
            radius: radius
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
var boundPolygon = null;
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
    var opacity = 0.8;
    var fillopacity = 0.05;
    var polygon = E$.multiPolygon(latlngs, { color: color, weight: 2, opacity: opacity, fillColor: fillcolor, fillOpacity: fillopacity,clickable:false });
    boundPolygon = polygon;

    polygon.addTo(map);
    map.fitBounds(polygon.getBounds());
}

function clrBoundTab() {
    if (boundPolygon) {
        map.removeLayer(boundPolygon);
        boundPolygon = null;
    }
}
//gis Tab
var gisTile = null;
function setGISLayerTab() {
   /* $("#gislayerTree").jstree({
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
        if (data.rslt.obj.attr("id").indexOf("li_node_id_cat") > -1)
            return;
        if ($('#gislayerTree').jstree("is_checked", "#" + data.rslt.obj.attr("id")))
            $('#gislayerTree').jstree("uncheck_node", "#" + data.rslt.obj.attr("id"));
        else
            $('#gislayerTree').jstree("check_node", "#" + data.rslt.obj.attr("id"));
    }).bind("change_state.jstree", function (e, data) {

        loadGISTileLayer();

    });
    */
}

function loadGISTileLayer() {
    if (gisTile)
        map.removeLayer(gisTile);

    var layers = getChkLayers();
    url = "wms/gwc.aspx?layers=" + layers + "&z={z}&x={x}&y={y}";
    gisTile = E$.tileLayer(url, { maxZoom: 20, tms: true });
    map.addLayer(gisTile);
    //alert(url);
    //loadGISDef(layers);
}
function getChkLayers() {
    var chkLayers = [];
    var tree = parent.$('#gisLayerTree').jstree("get_checked", true);
    $.each(tree, function () {
        var gisly=parent._gisLayerArr;
        var id = this.id.replace("li_", "");
        for (var i = 0; i < gisly.length; i++) {
            if (id == gisly[i].id) {
                chkLayers.push(gisly[i].source);
            }
        }
    });
    return chkLayers.join(',');
}
function loadGISDef(layers) {
   
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
    var t = "<table cellspacing=1 cellpadding=4 style='margin-top:10px'  width='99%'>";
    var isdef = false;     
    for (var i = 0; i < data.length; i++) {
        var datai = data[i].d;
        if (datai.length > 0) {
            isdef = true;
            t += "<tr bgcolor=#ffffff><td colspan=2><b>" + data[i].n + "</b></td></tr>";
            for (var j = 0; j < datai.length; j++) {
                var dataj = datai[j];
                t += "<tr bgcolor=#ffffff><td width=60 align=right>";

                if (dataj.c.substring(0, 1) == "%")
                    t += "<div style='width:40px;height:3px;background:#" + dataj.c.substring(1, 7) + ";'></div>";
                else if (dataj.c.substring(0, 1) == "#")
                    t += "<div style='width:40px;height:20px;opacity:0.5;background:" + dataj.c + ";" + (dataj.c == "#FFFFFF" ? "border:1px solid #777" : "") + "'></div>";
                else if (dataj.c.substring(0, 1) == "!")
                    t += "ที่มา :";
                else
                    t += "<div style='width:40px;height:20px;background:url(files/gisdef/" + dataj.c + ".png) no-repeat'></div>";

             
                t += "</td><td>" + dataj.t + "</td></tr>";
            }
        } else {
            if (data[i].ty == "0" || data[i].ty == "") continue;
            isdef = true;
            t += "<tr bgcolor=#ffffff><td width=60 align=center>";

            if(data[i].ty=="3")
                t += "<div style='width:40px;height:20px;border:1px solid #" + data[i].cl + "'><div style='width:40px;height:20px;background:#" + data[i].cf + ";opacity:0.5;'></div></div>";
            if(data[i].ty=="2")
                t+="<div style='width:40px;height:3px;background:#" + data[i].cl + ";'></div>";
            if (data[i].ty == "1")
                t += "<img src='../files/gisdef/icons/" + data[i].l + ".png' />";
           
            t += "</td><td><b>" + data[i].n + "</b></td></tr>";
           
        }
    }
    t += "</table>";

    $("#def_tab").html(t);

    if (data.length > 0 && isdef) {
        $("#info").show();
        $("#info2").click();
        $("#info2").show();
    } else {
        $("#def_tab").html("");
        $("#info2").hide();
        /*if ($("#info_tab").html().trim() == "") {
            //$("#info").hide();
        } else {
            $("#info1").click();
        }*/
        return;
    }
}

//layer Tab
var _selected_LyID='0';
function setLayerTab() {
   /* $("#layerTree").jstree({
        "json_data": {
            "ajax": {
                "url": function (node) {
                    return "data/dlayer.ashx?equ=1"; ;
                },
                "data": function (n) {
                    return n;
                },
                "cache": false
            }
        },
        "plugins": ["themes", "json_data", "ui", "checkbox"],
        "themes": { "icons": false }
    }).bind("loaded.jstree", function (e, data) {
        $('#layerTree').jstree("open_all");
        statEquipment();
    }).bind("select_node.jstree", function (e, data) {
        if (data.rslt.obj.attr("equtype") == "GPS") {
            _selected_LyID = data.rslt.obj.data("id");
        } else {
            if ($('#layerTree').jstree("is_checked", "#" + data.rslt.obj.attr("id")))
                $('#layerTree').jstree("uncheck_node", "#" + data.rslt.obj.attr("id"));
            else
                $('#layerTree').jstree("check_node", "#" + data.rslt.obj.attr("id"));

            _selected_LyID = data.rslt.obj.data("id");
        }

    }).bind("change_state.jstree", function (e, data) {
        if (data.args[1] == false) {
            var poiid = $(data.rslt).attr('id').replace('li_node_id_e', '');
            selectPoiID_afterload = poiid;
            //$('#layerTree').jstree("select_node", "#li_node_id" + lyid);
        }
        loadPoifromLayers();

    });*/
}




function clearLayerPOI() {
    for (var i = 0; i < poiArray_LayerTab.length; i++) {
        map.removeLayer(poiArray_LayerTab[i]);
        if(poiArray_LayerTab[i].gpsline)
            map.removeLayer(poiArray_LayerTab[i].gpsline);
    }
    for (var i = 0; i < dotArray.length; i++) {
        map.removeLayer(dotArray[i]);
    }
    dotArray = [];
    poiArray_LayerTab = [];

    $("#info_tab").html("");
    playVideo("");
}

//Place Tab
var _selected_Place_LyID = '0';
function searchPlace(t) {
    $("#placeTree").jstree("search", t);
}
function setPlaceTab() {
    $("#placeTree").jstree({
        "json_data": {
            "ajax": {
                "url": function (node) {
                    return "data/dlayer.ashx?equ=1&place=1"; ;
                },
                "data": function (n) {
                    return n;
                },
                "cache": false
            }
        },
        "plugins": ["themes", "json_data", "ui", "checkbox", "search", "adv_search", "types"],
        "search": { show_only_matches: true },
        "types": {
            "types": {
                "type1": {
                    "icon": {
                        "image": "images/pin.png"
                    }
                },
                "type2": {
                    "icon": {
                        "image": "images/line.png"
                    }
                },
                "type3": {
                    "icon": {
                        "image": "images/polygon.png"
                    }
                },
                "type4": {
                    "icon": {
                        "image": "images/cir.png"
                    }
                }
            }
        }
    }).bind("loaded.jstree", function (e, data) {
        $('#placeTree').jstree("open_all");
        for (var i = 0; i < placechkLayers.length; i++) {
            $('#placeTree').jstree("check_node", "#li_node_id_e" + placechkLayers[i]);
        }
        $("#placeTree").bind("change_state.jstree", function (e, data) {
            if (data.args[1] == false) {
                var poiid = $(data.rslt).attr('id').replace('li_node_id_e', '');
                selectPoiID_afterload = poiid;
            }
            loadPoifromPlaces();

        });
        loadPoifromPlaces();
    }).bind("select_node.jstree", function (e, data) {
        if ($('#placeTree').jstree("is_checked", "#" + data.rslt.obj.attr("id")))
            $('#placeTree').jstree("uncheck_node", "#" + data.rslt.obj.attr("id"));
        else
            $('#placeTree').jstree("check_node", "#" + data.rslt.obj.attr("id"));

        _selected_Place_LyID = data.rslt.obj.data("id");

    })
}

var placechkLayers=[];
function loadPoifromPlaces() {
    placechkLayers = [];
    $("#placeTree li").each(function () {
        if (this.id.indexOf('li_node_id') > -1) {
            var undet = $("#" + this.id + ".jstree-undetermined").length != 0;
            var chked = $("#" + this.id + ".jstree-checked").length != 0;
            var unchked = $("#" + this.id + ".jstree-unchecked").length != 0;
            if (undet) {

            } else if (chked) {
                if (this.id.indexOf("li_node_id_e") > -1) {
                    placechkLayers.push(this.id.replace("li_node_id_e", "").replace(/-/g, ':'));
                }
            } else if (unchked) {

            }
        }
    });
    if (placechkLayers.length == 0) {
        closePOIInfo();
        $("#bExpKmz").prop("disabled", true);
    } else {
        $("#bExpKmz").prop("disabled", false);
    }
    $("#placeLoading").show();
    //window.open("data/dPoiGets.ashx?lyids=" + chkLayers.join(','));
    $.ajax({
        type: 'POST',
        url: "data/dPoiGets.ashx",
        data: {
            lyids: placechkLayers.join(',')
        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            if (data.result == "ERR") {

            } else if (data.result == "OK") {
                displayPlacesResult(data.datas);
                $("#placeLoading").hide();
            }


        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });
}
function displayPlacesResult(pois) {
    clearPlacesPOI();
    for (var i = 0; i < pois.length; i++) {
        var poi = pois[i];
       if (_selected_Place_LyID == poi.LyID) {
            selectPoiID_afterload = poi.PoiID;
        }

        var marker = createMarker(poi);
        if (!marker) continue;
        marker.on('click', function (e) {
            selectPoi('place', e.target.poiid);
        });

        if (poi.Points != "") {
            marker.addTo(map);
            if(marker.circle)
                marker.circle.addTo(map);
        } else {
            marker.isHide = true;
        }

        poiArray_PlaceTab.push(marker);
    }
    
    if (selectPoiID_afterload > 0) {
        selectPoi('place', selectPoiID_afterload, 1, 0);
        selectPoiID_afterload = 0;
    }
}

function clearPlacesPOI() {
    for (var i = 0; i < poiArray_PlaceTab.length; i++) {
        map.removeLayer(poiArray_PlaceTab[i]);
     }
    for (var i = 0; i < dotArray.length; i++) {
        map.removeLayer(dotArray[i]);
    }
    dotArray = [];
    poiArray_PlaceTab = [];

    $("#info_tab").html("");
}

function exportPlaceKmz() {
    window.open("Kmz/Export.aspx?poiid=" + placechkLayers.join(','));
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
            t += "<img src='" + child.Icon + "' align=absbottom width=24 /><div>";
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


function closePOIInfo() {
    
    //$("#info_tab").html("");
    //$("#info1").hide();
    //$("#info_tab").hide();
    /*if ($("#def_tab").html().trim() == "") {
        $("#info").hide();
    }*/
    //parent.$('.afms-sec-mapinfo').removeClass('is-active');
    parent.$('.afms-sec-mapinfo , .afms-sec-mapstreet').removeClass('is-active');
    parent.$('.afms-sec-mapevent , .afms-sec-mapsensor').removeClass('is-active');
    $("#los-disp").hide();
    $("#los-t-1").hide();
    $("#los-t-2").hide();
    setWindowSize();
}


