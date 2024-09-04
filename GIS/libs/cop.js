function playVideo(src, poiid) {
    // playBackVideo(src);
    //return;



    if (src != '') {
        if (!__poiStat) return;

        for (var i = 0; i < __poiStat.length; i++) {
            var poi = __poiStat[i];
            if (poi.PoiID != poiid)
                continue;
            if (!poi.IsOnline) {
                return;
            }
        }

        // src='rtmp://www.ebmsapp.com:8088/flvplayback'
        $("#videostream").show();
        setWindowSize();
        setTimeout(function () {
            /*var v = '<video src="' + src + '" id="video1" controls="controls" autoplay width=' + $("#videostream_content").width() + ' height=' + $("#videostream_content").height() + '></video>';
            $("#videostream_content").html(v);

            $('#video1').on('timeupdate', function () {
            document.title = document.getElementById('video1').currentTime + "s";
            });
            */
            var v = '<a href="' + src + '"   style="display:block;width:' + $("#videostream_content").width() + 'px;height:' + $("#videostream_content").height() + 'px;"  id="player"></a>';
            $("#videostream_content").html(v);

            //flowplayer("player", "libs/flowplayer/flowplayer-3.2.18.swf");


            var srcs = src.split('/');
            var curl = '', url = '';
            for (var i = 0; i < srcs.length; i++) {
                if (i == srcs.length - 1)
                    url = srcs[i];
                else if (i == 0)
                    curl = srcs[i];
                else
                    curl += "/" + srcs[i];
            }
            flowplayer("player", "libs/flowplayer/flowplayer-3.2.18.swf", {
                clip: {
                    url: url,
                    netConnectionUrl: curl,
                    live: true,
                    //autoPlay: false,
                    //autoBuffering: true,
                    bufferLength: 0,
                    //fadeInSpeed: 0,
                    //fadeOutSpeed: 0,
                    provider: 'influxis'

                },

                onBeforeResume: function () {
                    this.stop();
                    this.play();
                    return false;
                },

                plugins: {
                    controls: {
                        url: "libs/flowplayer/flowplayer.controls-3.2.16.swf",
                        play: true
                    },
                    influxis: {
                        url: "libs/flowplayer/flowplayer.rtmp-3.2.13.swf",
                        inBufferSeek: false
                    }

                }
            });

        }, 100);
    } else {
        $("#videostream_content").html("");
        $("#videostream").hide();
        setWindowSize();
    }

}

var __pointHis = null;
var __playBackTimeout = null;
var __playBackPoiID = null;
var __poiStat = null;
var __maxLogID = 0;

function playBackVideo(src, pointHis, poiid) {
    if (src != '') {
        __pointHis = pointHis;
        __playBackPoiID = poiid;
        $("#videostream").show();
        setWindowSize();
        setTimeout(function () {
            var v = '<div id="flashls_vod" style="display:block;width:' + $("#videostream_content").width() + 'px;height:' + $("#videostream_content").height() + 'px;"></div>';
            $("#videostream_content").html(v);

            $f("flashls_vod", "libs/flowplayer/flowplayer-3.2.18.swf", {
                plugins: {
                    flashls: {
                        // load the flashls plugin
                        url: "libs/flowplayer/flashlsFlowPlayer-0.3.5.swf"
                    }
                },

                clip: {
                    url: src,
                    provider: "flashls",
                    urlResolvers: "flashls",

                    scaling: "fit"
                },

                // bright canvas for light video
                canvas: {
                    backgroundGradient: "none",
                    backgroundColor: "#ffffff"
                }
            }).ipad();

            syncPlayBack();


        }, 100);
    } else {
        $("#videostream_content").html("");
        $("#videostream").hide();
        setWindowSize();
    }

}

function syncPlayBack() {
    if (!__pointHis) {
        //clearTimeout(__playBackTimeout);
        return;
    }

    var sec = $f("flashls_vod").getTime();
    if (!sec) sec = 0;
    for (var i = 0; i < __pointHis.length; i++) {
        var ph = __pointHis[i];
        if (ph.Sec >= sec) {
            for (var j = 0; j < poiArray_SchTab.length; j++) {
                var marker = poiArray_SchTab[j];
                if (marker.poiid == __playBackPoiID) {
                    marker.setLatLng(new E$.LatLng(ph.Lat, ph.Lng));
                    map.setView([ph.Lat, ph.Lng], map.getZoom());
                    if (marker.isHide) {
                        marker.isHide = 0;
                        marker.addTo(map);
                    }

                    break;
                }
            }
            break;
        }
    }

    setTimeout(function () {
        syncPlayBack();
    }, 3 * 1000);
}

function syncEquipment() {
    var chkLayers = poiArray_View;
    //chkLayers.push(5);
    $.ajax({
        type: 'POST',
        url: "data/dPoiGets.ashx",
        data: {
            lyids: chkLayers.join(','),
            maxlogid: __maxLogID
        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            if (data.result == "ERR") {

            } else if (data.result == "OK") {
                var pois = data.datas;
                for (var i = 0; i < pois.length; i++) {
                    var poi = pois[i];
                    if (poi.Point == "") continue;
                    for (var j = 0; j < poiArray_LayerTab.length; j++) {
                        var marker = poiArray_LayerTab[j];
                        if (marker.poiid == poi.PoiID) {
                            if (poi.Points != "") {
                                var latlng = poi.Points.split(',');
                                marker.setLatLng(new E$.LatLng(latlng[1], latlng[0]));
                                
                                //if(!parent.iStView)
                                  //  parent.iStView = parent.$('stViewFrame')[0].contentWindow;

                                parent.iStView.setCenter(parseFloat(latlng[1]), parseFloat(latlng[0]));
                                /*
                                marker.setRotationAngle(poi.Heading);
                                if (marker.isHide) {
                                marker.isHide = 0;
                                marker.addTo(map);
                                }*/
                            }
                        }
                    }
                }
                fitToTrackPoi();
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });

    statEquipment();
    syncSensors();
    syncEvent();
      
    setTimeout(function () {
        syncEquipment();
    }, 10 * 1000);
}

$(function () {
    parent.$(".afms-mapsensor-content span").hide();
    parent.$("div[rel=panel]").removeClass("panel-success");
    parent.$("div[rel=panel]").removeClass("panel-danger");


    syncEquipment();

    
});

function fitToTrackPoi() {
    if (poiArray_Track.length == 0) return;
    var bound = [];
    for (var i = 0; i < poiArray_Track.length; i++) {
        var poi = poiArray_Track[i];
        for (var j = 0; j < poiArray_LayerTab.length; j++) {
            var marker = poiArray_LayerTab[j];
            if (!marker.isHide && marker.poiid == poi) {
                bound.push(marker.getLatLng());
            }
        }
    }
    if (bound.length > 0)
        map.fitBounds(L.latLngBounds(bound));
}

function arrayContains(a, obj) {
    for (var i = 0; i < a.length; i++) {
        if (a[i] === obj) {
            return true;
        }
    }
    return false;
}

function chkTrackClick(id, chk) {
    chk = arrayContains(poiArray_Track, id);
    if (!chk) {
        poiArray_Track.push(id);
        $('#layerTree').jstree("check_node", "#li_node_id_e" + id);
    } else {
        for (var i = poiArray_Track.length - 1; i >= 0; i--) {
            if (poiArray_Track[i] === id) {
                poiArray_Track.splice(i, 1);
            }
        }
    }
    if (!chk) {
        $("#gps_track_id_e" + id).attr("src", "images/chkboxc.png");
    } else {
        $("#gps_track_id_e" + id).attr("src", "images/chkbox.png");
    }

    fitToTrackPoi();
}
function statEquipment() {
    $.ajax({
        type: 'POST',
        url: "data/dEquip2.ashx",
        data: {

        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            //alert(trackPoiID);
            if (data.result == "ERR") {

            } else if (data.result == "OK") {
                var players = data.datas;
                __poiStat = [] //pois;

                var h = "<div id=HEquip style='margin-top:5px;padding:10px 5px 10px 5px;background:#eee'><a id=aSTN href=javascript:selEq('STN') style='color:#000;'>AFM</a>&nbsp;&nbsp;";
                h += "<a id=aRMT href=javascript:selEq('RMT') style='color:#000;'>Remote</a>&nbsp;&nbsp;";
                h += "<a id=aMOB href=javascript:selEq('MOB') style='color:#000;'>Mobile</a>&nbsp;&nbsp;";
                h += "<a id=aHND href=javascript:selEq('HND') style='color:#000;'>Handheld</a>&nbsp;&nbsp;";
                h += "<a id=aGPS href=javascript:selEq('GPS') style='color:#000;'>GPS</a></div>";

                var t = h + "<table class='table'>";
                var opt = "";

                for (var k = 0; k < players.length; k++) {
                    t += "<tr class='equip_pLayer' rel='" + players[k].LyID +"'><td colspan=3 style='padding:3px!important;'>" + players[k].Name + "</td></tr>";

                    for (var j = 0; j < players[k].Layers.length; j++) {

                        t += "<tr class='equip_Layer' rel='" + players[k].Layers[j].LyID +"'><td colspan=3 style='padding:3px 3px 3px 20px!important;'>" + players[k].Layers[j].Name + "</td></tr>";

                        for (var i = 0; i < players[k].Layers[j].Pois.length; i++) {
                            var poi = players[k].Layers[j].Pois[i];
                            //alert(poi.Name);
                            __poiStat.push(poi);
                            t += '<tr class="eqt eqt_' + poi.EquType + ' ilyid_' + poi.LyID + ' iplyid_' + players[k].LyID +'">';
                            t += '<td style="width: 65px;padding-left:40px">';
                            t += '<i class="' + (poi.IsLock == "Lock" ? "afms-ic_lock" : "afms-ic_unlock") + '"></i>';
                            t += '</td>';
                            t += '<td style="padding-left: 15px;">';
                            t += '<i class="afms-ic_record afms-status ' + (poi.IsOnline == "Online" ? "is-online" : "") + '"></i>' + poi.Name;
                            t += '</td>';
                            t += '<td style="width: 97px; min-width: 97px">';
                            t += '<button id="bView' + poi.PoiID + '" class="afms-btn afms-ic_view ' + (arrayContains(poiArray_View, poi.PoiID) ? '' : 'fade') + '" data-toggle="tooltip" data-placement="top" title="Display" onclick="iMap.click_ViewStn(' + poi.PoiID + ')"></button>';
                            t += '<button id="bFocus' + poi.PoiID + '"  class="afms-btn afms-ic_focus ' + (arrayContains(poiArray_Track, poi.PoiID) ? '' : 'fade') + '" data-toggle="tooltip" data-placement="top" title="Focus" onclick="iMap.click_FocusStn(' + poi.PoiID + ')"></button>';
                            if (poi.EquType == "STN" || poi.EquType == "STN2")
                                t += '<a class="afms-btn afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control" href="../FMS/FMon.aspx?poiid=' + poi.PoiID + '" target="_blank"></a>';
                            t += '</td>';
                            t += '</tr>';

                            if (poi.EquType != "GPS")
                                opt += "<option value='" + poi.PoiID + "'>" + poi.Name + "</option>";
                        }
                    }
                }
                
                
                parent.$("#tb_Station").html(t + "</table>");
                if (!isinitStnSel) {
                    opt = "<option value=''>..ทั้งหมด..</option>" + opt;
                    parent.$("#eStation").html(opt);
                    parent.$("#eStation").selectpicker('refresh');

                    parent.$("#sStation").html(opt);
                    parent.$("#sStation").selectpicker('refresh');
                    isinitStnSel = true;
                }
               
                parent.selEq();
                fitToTrackPoi();
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });
}


function click_ViewStn(poiid) {
    var chk = arrayContains(poiArray_View, poiid);
    if (!chk) {
        poiArray_View.push(poiid);
        parent.$("#bView" + poiid).removeClass("fade");

    } else {
        for (var i = poiArray_View.length - 1; i >= 0; i--) {
            if (poiArray_View[i] === poiid) {
                poiArray_View.splice(i, 1);
            }
        }
        parent.$("#bView" + poiid).addClass("fade");
        if (arrayContains(poiArray_Track, poiid)) {
            for (var i = poiArray_Track.length - 1; i >= 0; i--) {
                if (poiArray_Track[i] === poiid) {
                    poiArray_Track.splice(i, 1);
                }
            }
            parent.$("#bFocus" + poiid).addClass("fade");
        }
        closePOIInfo();
    }

    selectPoiID_afterload = poiid;
    loadPoifromLayers();
}
function click_FocusStn(poiid) {
    var chk = arrayContains(poiArray_Track, poiid);
    if (!chk) {
        poiArray_Track.push(poiid);
        poiArray_View.push(poiid);
        parent.$("#bView" + poiid).removeClass("fade");
        parent.$("#bFocus" + poiid).removeClass("fade");
        selectPoiID_afterload = poiid;
        loadPoifromLayers();

    } else {
        for (var i = poiArray_Track.length - 1; i >= 0; i--) {
            if (poiArray_Track[i] === poiid) {
                poiArray_Track.splice(i, 1);
            }
        }
        parent.$("#bFocus" + poiid).addClass("fade");
    }
   

    fitToTrackPoi();

    
}

function loadPoifromLayers() {
    var chkLayers = poiArray_View;
   
    if (chkLayers.length == 0) {
        closePOIInfo();
    }
    $("#layerLoading").show();
    //window.open("data/dPoiGets.ashx?lyids=" + chkLayers.join(','));
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
                $("#layerLoading").hide();
            }


        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });
}
function displayLayerResult(pois) {
    clearLayerPOI();
    syncSensors();
    for (var i = 0; i < pois.length; i++) {
        var poi = pois[i];
        /*if (_selected_LyID == poi.LyID) {
        selectPoiID_afterload = poi.PoiID;
        }*/


        var marker = createMarker(poi);
        if (!marker) continue;
        marker.on('click', function (e) {
            //console.log("click");
            selectPoi('layer', e.target.poiid);
        });

        if (poi.Points != "") {
            marker.addTo(map);
            if (marker.gpsline) {
                marker.gpsline.addTo(map);
            }
        } else {
            marker.isHide = true;
        }

        poiArray_LayerTab.push(marker);
    }
    if (selectPoiID_afterload > 0) {
        selectPoi('layer', selectPoiID_afterload, 1, 0);
        selectPoiID_afterload = 0;
        parent.$(".afms-mapsensor-content span").hide();
        parent.$("div[rel=panel]").removeClass("panel-success");
        parent.$("div[rel=panel]").removeClass("panel-danger");

        //syncSensors();
    }
    fitToTrackPoi();
}

////
function sentOTA(poiid) {
    $.fancybox('OTAConfig.aspx?poiid=' + poiid, {
        'width': 370,
        'height': 300,
        'autoScale': false,
        'transitionIn': 'none',
        'transitionOut': 'none',
        'type': 'iframe'
    });

}
var last_GPS_LogID = 0;
function pageGpsInfo(p, n) {
    var t = "";
    t += "<div style='float:right'>";
    if (p > 1)
        t += "<a href='javascript:setPageGps(" + (p - 1) + ")'>&lt;</a>";
    else
        t += "<span style='color:#ccc'>&lt;</span>";
    t += " page " + p + "/" + n + " ";
    if (p < n)
        t += "<a href='javascript:setPageGps(" + (p + 1) + ")'>&gt;</a>";
    else
        t += "<span style='color:#ccc'>&gt;</a>";
    t += "&nbsp;</div>";

    return t;
}
function setPageGps(page) {
    syncPoiGPSDet(null, page);
}
var __poi_Gps_Cur;
var __page = 1;
function syncPoiGPSDet(poiid, page) {
   

}
function loadCurGraph() {
   
}
//


//Event Tab
var lastEvID = -1;
var EventPOI_datas;
var isinitStnSel=false;

function syncEvent() {
   // window.open("data/dEvent.ashx?s=" + parent.$("#eStation").val() + "&ev=" + parent.$("#eEvent").val());
    $.ajax({
        type: 'POST',
        url: "data/dEvent.ashx",
        data: {
            evid: lastEvID,
            s: parent.$("#eStation").val(),
            ev: parent.$("#eEvent").val()
        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            if (data.result == "ERR") {

            } else if (data.result == "OK") {
                displayEvResult(data.datas);
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });
}
function displayEvResult(pois) {
    EventPOI_datas = pois;
    var t = "";
    if (pois.length > 0) {
        //t += " พบ " + pois.length + " รายการ ";
        t += "<table class='table'><thead><tr><th>Scanner</th><th>วันเวลาที่ตรวจพบ</th><th>ความถี่</th><th>ความแรง</th><th>ผู้ครอบครอง</th></tr></thead><tbody>";
        for (var i = 0; i < pois.length; i++) {
            var poi = pois[i];
            if (poi.rType == "A") {
                var content = "";
                content += "Station : " + poi.Staion + "<br>";
                content += "ความถี่  :" + poi.Freq + "<br>";
                content += "ความแรง  :" + poi.Signal + "<br>";
                content += "ผู้ครอบครอง  :" + poi.HostName + "<br>";
                content += "Location : " + poi.Lat + "," + poi.Lng + "<br>";
                content += "Time : " + poi.DtAdd + " " + poi.TmAdd + "";
                /*
                $.msgBox({ title: "Alert", content: content, type: "alert",
                    buttons: [{ value: "Show event" }, { value: "Close"}],
                    success: function (result) {
                        if (result == "Show event")
                            showEvent(poi.EvID);

                    }
                });*/
                continue;
            }
            if (poi.rType == "M") {
                lastEvID = poi.EvID;
                continue;
            }
            t += "<tr onclick='showEvent(" + poi.EvID + ")'>";
            t += "<td>" + poi.Station + "</td>";
            t += "<td>" + poi.DtAdd + " " + poi.TmAdd + "</td>";
            t += "<td>" + poi.Freq + "</td>";
            t += "<td>" + poi.Signal + "</td>";
            t += "<td>" + poi.HostName + "</td>";
            t += "</tr>";
        }
        t += "</tbody></table>";
    } else {
        t += "<div style='text-align:center'>ไม่พบข้อมูล </div>";
    }
    parent.$("#tb_Event").html(t);

}

function showEvent(evid) {
    if (!EventPOI_datas) return;
    switchMode();
    for (var i = 0; i < EventPOI_datas.length; i++) {
        var poi = EventPOI_datas[i];
        if (poi.EvID == evid) {
            //showPoiDetail(poi.PoiID, "event");
            setTimeout(function () {
                var popCenter = [poi.Lat, poi.Lng];
                map.panTo(popCenter);
                infoPopup = E$.popup({ autoPanPadding: [80, 80], closeOnClick: false });
                infoPopup.setLatLng(popCenter);
                infoPopup.setContent(eventContent(poi));
                infoPopup.on("close", function (e) {
                    resetMeasure();
                });
                infoPopup.openOn(map);
            }, 200);

            return;
        }
    }
}

function eventContent(poi) {
    var content = "<table width=250>";
    content += "<tr><td style='font-weight:bold'>Station:</td><td>" + poi.Station + "</td></tr>";
    content += "<tr><td style='font-weight:bold'>ความถี่:</td><td>" + poi.Freq + "MHz</td></tr>";
    content += "<tr><td style='font-weight:bold'>ความแรง:</td><td>" + poi.Signal + "dBm</td></tr>";
    content += "<tr><td style='font-weight:bold'>ผู้ครอบครอง:</td><td><a href=\"javascript:parent.gotoHost('" + poi.EvPoiID+"')\">" + poi.HostName + "</a></td></tr>";
    content += "<tr><td style='font-weight:bold'>ตำแหน่ง:</td><td>" + poi.Lat + "," + poi.Lng + "</td></tr>";
    content += "<tr><td style='font-weight:bold'>เวลา:</td><td>" + poi.DtAdd + " " + poi.TmAdd + "</td></tr>";
    content += "</table>";

    return content;

}

function openPopUp(poi,t) {
    setTimeout(function () {
        var popCenter = [poi.Lat, poi.Lng];
        map.panTo(popCenter);
        infoPopup = E$.popup({ autoPanPadding: [80, 80], closeOnClick: false });
        infoPopup.setLatLng(popCenter);
        infoPopup.setContent(t);
        infoPopup.on("close", function (e) {
            resetMeasure();
        });
        infoPopup.openOn(map);
    }, 200);
}

function openPopUpLL(popCenter, t) {
    setTimeout(function () {
        map.panTo(popCenter);
        infoPopup = E$.popup({ autoPanPadding: [80, 80], closeOnClick: false });
        infoPopup.setLatLng(popCenter);
        infoPopup.setContent(t);
        infoPopup.on("close", function (e) {
            resetMeasure();
        });
        infoPopup.openOn(map);
    }, 200);
}
////



function createHisPoi(poi) {
    poi.PoiType = poi.EvTypeID == 0 ? 2 : 1;
    poi.PoiID = poi.Key;
    var marker = createMarker(poi);
    if (!marker) return;
    marker.on('click', function (e) {
        selectPoi('sch', e.target.poiid);
    });
    if (poi.Points != "")
        marker.addTo(map);
    else
        marker.isHide = 1;

    poiArray_SchTab.push(marker);

}

///
function syncSensors() {
    $.ajax({
        type: 'POST',
        url: "../DashB/data/dsensor.ashx",
        data: {

        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            setSensorsData(data);
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }

    });
}

function setSensorsData(data) {
    //return;
    if (!selectedPoi || selectedPoi.isHide) return;
    for (var i = 0; i < data.length; i++) {
        var d = data[i];

        if (d.PoiID != selectedPoi.poiid)
            continue;

        parent.$(".afms-sec-mapsensor .Voltage").html(d.Voltage);
        parent.$(".afms-sec-mapsensor .Current").html(d.Current);
        parent.$(".afms-sec-mapsensor .Frequency").html(d.Frequency);
        parent.$(".afms-sec-mapsensor .PAE").html(d.PAE);

        parent.$(".afms-sec-mapsensor .UPSPc").html(d.UPSPc);
        parent.$(".afms-sec-mapsensor .UPSTime").html(d.UPSTime);

        parent.$(".afms-sec-mapsensor .Temp").html(d.Temp);
        parent.$(".afms-sec-mapsensor .Humidity").html(d.Humidity);
        //$("#station" + d.PoiID + " .TempStat").html(d.TempStat);
        if (d.TempStat == "Warning" || d.TempStat == "Critical" || d.InPut == 1) {
            parent.$(".afms-sec-mapsensor .panel-sensor").addClass("panel-danger");
        } else {
            parent.$(".afms-sec-mapsensor .panel-sensor").addClass("panel-success");
        }
        var led = d.StatusLED;
        if (d.UPSPc > 25) {
            parent.$(".afms-sec-mapsensor .panel-ups").addClass("panel-success");
        } else {
            parent.$(".afms-sec-mapsensor .panel-ups").addClass("panel-danger");
        }
        if (d.SCN == "OK") {
            parent.$(".afms-sec-mapsensor .panel-scaner").addClass("panel-success");
        } else {
            parent.$(".afms-sec-mapsensor .panel-scaner").removeClass("panel-success");
        }
        if (d.Voltage != "0") {
            parent.$(".afms-sec-mapsensor .panel-power").addClass("panel-success");
        }
        if (d.GPS == "OK" && (d.IsOnline == "Online")) {
            parent.$(".afms-sec-mapsensor .panel-com").addClass("panel-success");
        } 

        if (d.IsOnline == "Online") {
            parent.$(".afms-sec-mapsensor .NET").html("OK");
        }

        parent.$(".afms-sec-mapsensor .GPS").html(d.GPS);
        parent.$(".afms-sec-mapsensor .3G").html(d.f3G);
        parent.$(".afms-sec-mapsensor .WAN").html(d.WAN);
        parent.$(".afms-sec-mapsensor .LAN").html(d.LAN);
        parent.$(".afms-sec-mapsensor .Atenna").html(d.ATTN);
        parent.$(".afms-sec-mapsensor .Security").html(d.Security);
      
        if (d.ATTN != "-") {
            parent.$(".afms-sec-mapsensor .AtennaStat").html("Online");
        } else {
            parent.$(".afms-sec-mapsensor .AtennaStat").html("Offline");
        }
        parent.$(".afms-mapsensor-content span").show();
    }

}


////

function showEventMarker(PoiID) {
    if (event_marker)
        map.removeLayer(event_marker);

    showPoiDetail(PoiID,null,true);
    
}

///


function addPoiIDs(lyids) {
    //alert(lyids);
    //window.open("data/dPoiLyGets.ashx?lyids=" + lyids);
    $.ajax({
        type: 'POST',
        url: "data/dPoiLyGets.ashx",
        data: {
            lyids: lyids.split('@')[0]
        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            if (data.result == "ERR") {

            } else if (data.result == "OK") {
                displayPlacesResult(data.datas);
            }


        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });
}