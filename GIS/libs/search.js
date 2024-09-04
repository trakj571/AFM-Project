function doSch() {

    if (document.getElementById("sch_type_l") && document.getElementById("sch_type_l").checked) {
        return doSchL();
    }
    clearLandPOI(0);
    $("#div_sch_body").hide();
    $("#div_header_sch_disp").removeClass("disp_down");
    $("#div_header_sch_disp").addClass("disp_up");
    $("#div_rst").show();
    $("#div_rst_body").show();
    $("#div_header_rst_disp").removeClass("disp_up");
    $("#div_header_rst_disp").addClass("disp_down");

    $("#tabLand_result").html(loading);
    $("#tabLand_result").html(loading);
    $("#tabLand_result").show();
    $("#div_rst").show();

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

    $.ajax({
        type: 'POST',
        //url: "data/dLandSch.ashx",
        url: "data/dPoiSch.ashx",
        data: {
            keyword: escape($("#sDetail").val()),
            lat: map.getCenter().lat,
            lng: map.getCenter().lng,
            lyids: chkLayers.join(',')
        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            if (data.result == "ERR") {

            } else if (data.result == "OK") {
                displayLandResult(data.datas);
                //alert(data.datas.length);
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            var t = "<div style='text-align:center'>ข้อมูลผิดพลาด </div>";
            $("#tabLand_result").html(t);
            $("#tabLand_result").show();
        }
    });

    return false;
}
function schByClick(t) {
    $(".su").hide();
    $(".sc").hide();
    $(t).show();
}
function sch_disp_click() {
    $("#div_sch_body").show()
    $("#div_rst_body").hide();
    $("#div_det_body").hide()
    if ($("#div_header_sch_disp").hasClass("disp_up")) {
        $("#div_header_sch_disp").removeClass("disp_up");
        $("#div_header_sch_disp").addClass("disp_down");
    }
    if ($("#div_header_rst_disp").hasClass("disp_down")) {
        $("#div_header_rst_disp").removeClass("disp_down");
        $("#div_header_rst_disp").addClass("disp_up");
    }
    if ($("#div_header_det_disp").hasClass("disp_down")) {
        $("#div_header_det_disp").removeClass("disp_down");
        $("#div_header_det_disp").addClass("disp_up");
    }
}
function rst_disp_click() {
    $("#div_sch_body").hide()
    $("#div_rst_body").show();
    if ($("#div_header_rst_disp").hasClass("disp_up")) {
        $("#div_header_rst_disp").removeClass("disp_up");
        $("#div_header_rst_disp").addClass("disp_down");
    }
    if ($("#div_header_sch_disp").hasClass("disp_down")) {
        $("#div_header_sch_disp").removeClass("disp_down");
        $("#div_header_sch_disp").addClass("disp_up");
    }
    if ($("#div_header_det_disp").hasClass("disp_down")) {
        $("#div_header_det_disp").removeClass("disp_down");
        $("#div_header_det_disp").addClass("disp_up");
    }
}
function dispSchType(type) {
    $(".div_sch_type").hide();
    $("#div_sch_type_" + type).show();
    if (type == 'l' && !schObject) {
        var c = map.getCenter();
        $("#Loc_l").val(degreeFormat(c.lat) + "," + degreeFormat(c.lng));
        $("#Radius_l").val("500");

    }
}

function doSchL() {
    var err = "";
    if (document.getElementById("Loc_l").value == "")
        err += '* โปรดกรอกตำแหน่ง<br />';

    var latlngs = document.getElementById("Loc_l").value.split(',');
    if (latlngs.length != 2)
        err += '* โปรดกรอกตำแหน่ง (Lat,Long)';
    var lat = parseFloat(latlngs[0]);
    var lng = parseFloat(latlngs[1]);
    if (lat < -90 || lat > 90 || lng < -180 || lng > 180)
        err += '* ตำแหน่งไม่ถูกต้อง';

    if (document.getElementById("Radius_l").value == "")
        err += '* โปรดกรอกรัศมี<br />';

    if (isNaN(document.getElementById("Radius_l").value))
        err += '* โปรดกรอกรัศมี เป็นตัวเลข (1-50000)<br />';
    var r = parseFloat(document.getElementById("Radius_l").value);
    if (r < 1 || r > 50000)
        err += '* โปรดกรอกรัศมี เป็นตัวเลข (1-50000)<br />';

    $("#error_l").html(err);
    if (err != '') {

        return false;
    }
    clearLandPOI(0);
    $("#div_sch_body").hide();
    $("#div_header_sch_disp").removeClass("disp_down");
    $("#div_header_sch_disp").addClass("disp_up");
    $("#div_rst").show();
    $("#div_rst_body").show();
    $("#div_header_rst_disp").removeClass("disp_up");
    $("#div_header_rst_disp").addClass("disp_down");
    $("#div_rst").show();
    $("#tabLand_result").html(loading);
    $("#tabLand_result").show();

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
    //window.open("data/dPOISchG.ashx?lat="+lat+"&lng="+lng+"&r="+r+"&lyids="+ chkLayers.join(','));
    $.ajax({
        type: 'POST',
        url: "data/dPOISchG.ashx",
        data: {
            lat: lat,
            lng: lng,
            r: r,
            lyids: chkLayers.join(',')
        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            if (data.result == "ERR") {

            } else if (data.result == "OK") {
               // alert(data.datas.length);
                schObject = E$.circle([lat, lng], r, { color: "#0c0", weight: 3, opacity: 0.7, fillColor: "#0c0", fillOpacity: 0, clickable: false });
                schObject.addTo(map);
                displayLandResult(data.datas);
                map.fitBounds(schObject.getBounds());
                //alert(data.datas.length);
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            var t = "<div style='text-align:center'>ข้อมูลผิดพลาด </div>";
            $("#tabLand_result").html(t);
            $("#tabLand_result").show();
        }
    });

    return false;
}
function resetSchL() {
    

    if (document.getElementById("sch_type_l") && document.getElementById("sch_type_l").checked) {
        clearLandPOI();
        dispSchType('l');
    } else {
        clearLandPOI(0);
    }
   // 

}
function dispAdvSch() {
    $("#tabSch_advkeyword").val($("#tabSch_keyword").val());
    $(".easysch").hide();
    $(".advsch").show();
    if ($("#tabSch_advkeyword").val().length >= 2) {
        $("#tabSch_bAdvSch").removeAttr("disabled");
    }
}

function chgPwd() {
    $.fancybox('../UR/ChgPwd.aspx', {
        'width': 400,
        'height': 300,
        'type': 'iframe',
        'autoScale': false,
        'transitionIn': 'none',
        'transitionOut': 'none'
    });
}



///
function schInit() {    
    //window.open("data/dPBckList.ashx");
    $.ajax({
        type: 'POST',
        url: "data/dPBckList.ashx",
        data: {

        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            for (var i = 0; i < data.length; i++) {
                if (data[i].equtype == "STR")
                    $("#sCamera").append("<option value='" + data[i].value + "'>" + data[i].text + "</option>");
                /*if (data[i].equtype == "GPS") {
                    $("#sGPS").append("<option value='" + data[i].poiid + "'>" + data[i].text + "</option>");
                    $("#eGPS").append("<option value='" + data[i].poiid + "'>" + data[i].text + "</option>");
                }*/
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });
    loadGPSFLayer();

    $(".inputdate").removeAttr("readonly");
    $(".inputdate").removeAttr("onclick");
    $(".inputdate").bind('change', function () {
        var val = $(this).val();
        if (val.length == 8 || val.length == 10) {
            if (val.length == 8) {
                $(this).val(val.substring(0, 2) + "/" + val.substring(2, 4) + "/" + val.substring(4, 8));
                val = $(this).val();
            }
            if (self.gfPop && gfPop.fParseDate(val))
                return;
        }
        alert("กรอกวันที่ วัน/เดิอน/ปี เช่น 04102555 หรือ 04/10/2555");
        $(this).val("");
    })
}

function setSType(val) {
    if (val == "G") {
        $(".stypeG").show();
        $(".stypeS").hide();

    }
    if (val == "S") {
        $(".stypeS").show();
        $(".stypeG").hide();

    }
}
function formatDD(n) {
    return n > 9 ? "" + n : "0" + n;
}

function setSFilter(t,val) {
    if (val == "1") {
        var d = new Date();
        $("#"+t+"FDt").val(formatDD(d.getDate()) + "/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543));
        $("#" + t + "TDt").val(formatDD(d.getDate()) + "/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543));
        $("#" + t + "FHr").val(formatDD(d.getHours() - 1));
        $("#" + t + "FMn").val(formatDD(d.getMinutes()));
        $("#" + t + "THr").val(formatDD(d.getHours()));
        $("#" + t + "TMn").val(formatDD(d.getMinutes()));
    }
    if (val == "2") {
        var d1 = new Date();
        var d = new Date(Date.now() + 864e5);
        $("#" + t + "FDt").val(formatDD(d1.getDate()) + "/" + formatDD(d1.getMonth() + 1) + "/" + (d1.getFullYear() + 543));
        $("#" + t + "TDt").val(formatDD(d.getDate()) + "/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543));
        $("#" + t + "FHr").val("00");
        $("#" + t + "FMn").val("00");
        $("#" + t + "THr").val("00");
        $("#" + t + "TMn").val("00");
    }
    if (val == "3") {
        var d = new Date(Date.now());
        var d1 = new Date(Date.now() - 864e5);
        $("#" + t + "FDt").val(formatDD(d1.getDate()) + "/" + formatDD(d1.getMonth() + 1) + "/" + (d1.getFullYear() + 543));
        $("#" + t + "TDt").val(formatDD(d.getDate()) + "/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543));
        $("#" + t + "FHr").val("00");
        $("#" + t + "FMn").val("00");
        $("#" + t + "THr").val("00");
        $("#" + t + "TMn").val("00");
    }
    if (val == "4") {
        var d = new Date(Date.now() - 864e5);
        var d1 = new Date(Date.now() - 864e5 * 2);
        $("#" + t + "FDt").val(formatDD(d1.getDate()) + "/" + formatDD(d1.getMonth() + 1) + "/" + (d1.getFullYear() + 543));
        $("#" + t + "TDt").val(formatDD(d.getDate()) + "/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543));
        $("#" + t + "FHr").val("00");
        $("#" + t + "FMn").val("00");
        $("#" + t + "THr").val("00");
        $("#" + t + "TMn").val("00");
    }
    if (val == "5") {
        var d = new Date(Date.now() - 864e5);
        var d1 = new Date(Date.now() - 864e5 * 3);
        $("#" + t + "FDt").val(formatDD(d1.getDate()) + "/" + formatDD(d1.getMonth() + 1) + "/" + (d1.getFullYear() + 543));
        $("#" + t + "TDt").val(formatDD(d.getDate()) + "/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543));
        $("#" + t + "FHr").val("00");
        $("#" + t + "FMn").val("00");
        $("#" + t + "THr").val("00");
        $("#" + t + "TMn").val("00");
    }
    if (val == "6") {
        var curr = new Date();
        var d1 = new Date(curr.setDate(curr.getDate() - curr.getDay()));
        var d = new Date(Date.now());
        $("#" + t + "FDt").val(formatDD(d1.getDate()) + "/" + formatDD(d1.getMonth() + 1) + "/" + (d1.getFullYear() + 543));
        $("#" + t + "TDt").val(formatDD(d.getDate()) + "/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543));
        $("#" + t + "FHr").val("00");
        $("#" + t + "FMn").val("00");
        $("#" + t + "THr").val("00");
        $("#" + t + "TMn").val("00");
    }
    if (val == "7") {
        var curr = new Date();
        var d = new Date(curr.setDate(curr.getDate() - curr.getDay()));
        var d1 = new Date(curr.setDate(curr.getDate() - curr.getDay() - 7));

        $("#" + t + "FDt").val(formatDD(d1.getDate()) + "/" + formatDD(d1.getMonth() + 1) + "/" + (d1.getFullYear() + 543));
        $("#" + t + "TDt").val(formatDD(d.getDate()) + "/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543));
        $("#" + t + "FHr").val("00");
        $("#" + t + "FMn").val("00");
        $("#" + t + "THr").val("00");
        $("#" + t + "TMn").val("00");
    }
    if (val == "8") {
        var d = new Date(Date.now());
        $("#" + t + "FDt").val("01/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543));
        $("#" + t + "TDt").val(formatDD(d.getDate()) + "/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543));
        $("#" + t + "FHr").val("00");
        $("#" + t + "FMn").val("00");
        $("#" + t + "THr").val("00");
        $("#" + t + "TMn").val("00");
    }
    if (val == "9") {
        var curr = new Date();
        var d = new Date(curr.getFullYear(), curr.getMonth(), 1);
        var d1 = new Date(d.setDate(d.getDate() - 1));
        d = new Date();
        $("#" + t + "FDt").val("01/" + formatDD(d1.getMonth() + 1) + "/" + (d1.getFullYear() + 543));
        $("#" + t + "TDt").val("01/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543));
        $("#" + t + "FHr").val("00");
        $("#" + t + "FMn").val("00");
        $("#" + t + "THr").val("00");
        $("#" + t + "TMn").val("00");
    }
}

////


function doSchPBck() {
    $("#tabSch_result").html(loading);
    $("#tabSch_result").show();
    clearSchPOI(1);


    //window.open("data/dPBckSch.ashx?stream=" + $("#sCamera").val() + "&a=" + $("#sFDt").val() + " " + $("#sFTm").val() + "&b=" + $("#sTDt").val() + " " + $("#sTTm").val());
    if ($("#sType").val() == "S") {
        $.ajax({
            type: 'GET',
            url: "data/dPBckSch.ashx",
            data: {
                s: $("#sCamera").val(),
                a: $("#sFDt").val() + " " + $("#sFHr").val() + ":" + $("#sFMn").val(),
                b: $("#sTDt").val() + " " + $("#sTHr").val() + ":" + $("#sTMn").val()

            },
            cache: false,
            dataType: 'json',
            success: function (data) {
                if (data.result == "ERR") {

                } else if (data.result == "OK") {
                    displaySchPBck(data.datas);
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {

            }
        });
    }
    if ($("#sType").val() == "G") {
        $.ajax({
            type: 'GET',
            url: "data/dGPSBckSch.ashx",
            data: {
                ly1: $("#Layer1P").val(),
                ly2: $("#Layer2P").val(),
                s: $("#GpsPoiP").val(),
                d1: $("#sFDt").val(),
                t1: $("#sFHr").val() + ":" + $("#sFMn").val(),
                d2: $("#sTDt").val(),
                t2: $("#sTHr").val() + ":" + $("#sTMn").val()
            },
            cache: false,
            dataType: 'json',
            success: function (data) {
                if (data.result == "ERR") {
                    
                } else if (data.result == "OK") {
                    displayGPSHis(data.datas);
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {

            }
        });
    }
}
function displaySchPBck(pois) {
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
        poi.PoiType = 1;
        poi.PoiID = poi.Key;

        var latlng = poi.Points.split(',');
        t += "<a href=\"javascript:selectPoi('sch','" + poi.Key + "',1)\">";
        t += "<img src='" + poi.Icon + "' class='icon_small' align='absbottom' />";
        t += " " + poi.Name + "</a>";



        var marker = createMarker(poi);
        if (!marker) continue;
        marker.on('click', function (e) {
            selectPoi('sch', e.target.poiid);
        });
        if (poi.Points != "")
            marker.addTo(map);
        else
            marker.isHide = 1;

        poiArray_SchTab.push(marker);
    }
    $("#tabSch_result").html(t);
    $("#tabSch_result").show();
}


//

function displayGPSHis(pois) {

    var t = "";
    schPOI_datas = pois;
    if (pois.length > 0) {
    //t += " พบ " + pois.length + " รายการ ";
    } else {
    t += "<div style='text-align:center'>ไม่พบข้อมูล </div>";

    }
    poiArray_SchTab = [];
    t += "<table  width=100% cellspacing=0><tr bgcolor=#eeeeee><td  width=10%></td><td width=30%>&nbsp;เวลา</td><td width=30%>พาหนะ</td><td  width=30%>ข้อมูล</td></tr>";
        
    for (var i = 0; i < pois.length; i++) {
        var poi = pois[i];
        poi.PoiType = poi.EvTypeID==0?2:1;
        poi.PoiID = poi.Key;
        if (poi.PoiType == 2) {
            poi.LineColor = "800000CC";
            poi.LineOpacity = 80;
            poi.LineWidth = 3;
            poi.HideDot = 1;
        }
        var heading = poi.Heading;
        t += "<tr class=evhover onclick=\"selectPoi('sch','" + poi.Key + "',1);switchMode();\">";
        t += "<td><img src='"+poi.Icon+"' width=14 /></td>";
        t += "<td>" + poi.DtAdd + " " + poi.TmAdd + "</td>";
        t += "<td>" + poi.Name + "</td>";
        t += "<td>" + poi.EvName + "</td>";
        t += "</tr>";
        poi.Heading = 0;
         var marker = createMarker(poi);
         if (!marker) continue;

         poi.Heading = heading;
         marker.bindPopup(eventContent(poi));
         marker.on('click', function (e) {
             selectPoi('sch', e.target.poiid);
         });
        if (poi.Points != "")
            marker.addTo(map);
        else
            marker.isHide = 1;

        poiArray_SchTab.push(marker);
        
    }
    t += "</table>";
    $("#tabSch_result").html(t);
    $("#tabSch_result").show();
}
var __poi_Gps_His;
function dispHisGSPDet(key) {
    var keys = key.split('_');
    var logid1 = keys[2];
    var logid2 = keys[3];
    var poiid = keys[0].substring(1);
    if (playhisIns) {
        clearTimeout(playhisIns);
    }
    if (playhisMarker) map.removeLayer(playhisMarker);
    
    if (logid1 == logid2) {
        return;
    }
    $.ajax({
        type: 'POST',
        url: "data/dPoiGPSHis.ashx",
        data: {
            poiid: poiid,
            logid1: logid1,
            logid2: logid2
        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            if (data.result == "ERR") {

            } else if (data.result == "OK") {
                var poi = data.datas;
                __poi_Gps_His = poi;

                var t = "&nbsp;GPS Fleet ID : " + poi.Name;
                //t += pageGpsInfo(poi.Page, poi.nPage);
                t += "<table cellspacing=0 class=tbgpsdet><tr><th width=140>เวลา(ตำแหน่ง)</th><th width=140>เวลา(เซิร์ฟเวอร์)</th><th width=100>ละติจูด</th><th width=100>ลองติจูด</th><th width=80>ระดับความสูง</th><th width=80>มุมองศา</th><th width=80>ความเร็ว</th><th>Parameters</th></tr>";
                for (var i = 0; i < poi.Datas.length; i++) {
                    t += "<tr>";
                    t += "<td>" + poi.Datas[i].DtC + " " + poi.Datas[i].TmC + "</td>";
                    t += "<td>" + poi.Datas[i].DtS + " " + poi.Datas[i].TmS + "</td>";
                    t += "<td>" + poi.Datas[i].Lat.toFixed(6) + "</td>";
                    t += "<td>" + poi.Datas[i].Lng.toFixed(6) + "</td>";
                    t += "<td>" + poi.Datas[i].Alt + "</td>";
                    t += "<td>" + poi.Datas[i].Heading + "</td>";
                    t += "<td>" + poi.Datas[i].Speed + "</td>";
                    t += "<td></td>";
                    t += "</tr>";
                }
                t += "</table>";
                //t += pageGpsInfo(poi.Page, poi.nPage);
                $("#gps-data_content").html(t);

                var cur_GPS_LogID = 0;
                if (poi.Datas.length > 0) cur_GPS_LogID = poi.Datas[0].LogID;

                if (poi.Datas.length > 0) last_GPS_LogID = poi.Datas[0].LogID;
                t = "<div style='margin-top:2px'>&nbsp;GPS Fleet ID : " + poi.Name;
                t += "<div style='float:right' id=hisInfo></div>";
               
                t += "<select id=gphType onchange='loadHisGraph()'><option value='S'>ความเร็ว</option><option value='A'>ความสูง</option></select>";
                t += "&nbsp; &nbsp; <a href='javascript:playGpsHis()'><img id=iplay src='images/play.png' width=16 align=absbottom title='play' /></a> ";
                t += "<a href='javascript:pauseGpsHis()'><img id=ipause src='images/pauseg.png' width=16 align=absbottom title='pause' /></a> ";
                t += "<a href='javascript:stopGpsHis()'><img id=istop src='images/stopg.png' width=16 align=absbottom  title='stop' /></a>";
                t += "&nbsp; <select id=playX onchange=''><option value='1'>x1</option><option value='2'>x2</option><option value='3'>x3</option><option value='4'>x4</option><option value='5'>x5</option><option value='6'>x6</option></select>";
                t += "</div>"; //t += pageGpsInfo(poi.Page, poi.nPage);
                
                t += "<div id=gps-graph-container style='height:130px;width:" + ($("#los-disp").width() - 20) + "px'></div>";
                $("#gps-graph_content").html(t);

                loadHisGraph();
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });
}

function loadHisGraph() {
    var tms = [];
    var speeds = [];
    var alts = [];
    var poi = __poi_Gps_His;
    var latlngs = [];
    var tk = Math.round(poi.Datas.length / 10);
    if (tk == 0) tk = 1;
    for (var i = 0; i < poi.Datas.length; i++) {
        tms.push(poi.Datas[i].TmC);
        //tms.push(i + "/" + tk);
        speeds.push(poi.Datas[i].Speed);
        alts.push(poi.Datas[i].Alt);
        latlngs.push([poi.Datas[i].Lat, poi.Datas[i].Lng]);
    }
    hischart = $('#gps-graph-container').highcharts({
        chart: {
            type: 'spline'
        },
        title: {
            text: ''
        },
        subtitle: {
            text: ''
        },
        xAxis: {
            tickInterval: tk,
            categories: tms,
            crosshair: true
        },
        yAxis: {
            min: 0,
            title: {
                text: $("#gphType").val() == "A" ? 'ความสูง(ม.)' : 'ความเร็ว(กม./ชม.)'
            }
        },
        tooltip: {
            formatter: function () {
                return '' + poi.Datas[this.point.x].DtC + " " + this.key + ' : ' + this.y + ($("#gphType").val() == "A" ? 'ม.' : 'กม./ชม.');
            }
        },
        plotOptions: {
            series: {
                animation: false,
                marker: {
                    enabled: false
                },
                point: {
                    events: {
                        mouseOver: function (e) {
                            //alert(this.x+""); 
                            if (!toolObject2)
                                toolObject2 = E$.marker(latlngs[this.x], { icon:
                                E$.icon({ iconUrl: "images/icons/x.png", iconAnchor: [6, 6] }),
                                    clickable: false
                                }).addTo(map);
                            else {
                                toolObject2.setLatLng(latlngs[this.x]);
                            }
                        },
                        mouseOut: function (e) {
                            if (toolObject2) {
                                map.removeLayer(toolObject2);
                                toolObject2 = null;
                            }
                        },
                        click: function (e) {
                            map.panTo(latlngs[this.x]);
                            __poi_Gps_His_i = this.x;
                        }
                    }
                }
            },
            line: {

            }

        },
        series: [
            {
                showInLegend: false,
                data: $("#gphType").val() == "A" ? alts : speeds
            }
            ]
    });
       
}

var playhisMarker;
var __poi_Gps_His_i;
var playhisIns
var ispausehisMarker = false;
var initDelay = 1000;

function playGpsHis(){
    if (ispausehisMarker) {
        ispausehisMarker = false;
        movehisMarker();

        $("#iplay").prop("src", "images/playg.png");
        $("#ipause").prop("src", "images/pause.png");
        $("#istop").prop("src", "images/stop.png");
        return;
    }
    if (playhisMarker) map.removeLayer(playhisMarker);
    if (!__poi_Gps_His.Datas || __poi_Gps_His.Datas.length == 0) return;

    $("#iplay").prop("src", "images/playg.png");
    $("#ipause").prop("src", "images/pause.png");
    $("#istop").prop("src", "images/stop.png");

    ispausehisMarker = false;
    var poi = __poi_Gps_His.Datas[0];
    __poi_Gps_His_i = 0;
    playhisMarker = E$.marker(new E$.LatLng(poi.Lat, poi.Lng), { icon: E$.icon({ iconUrl: "images/posArr.png", className: 'poiIcon', iconAnchor: [16, 16] }), title: "" });
    playhisMarker.setRotationAngle(poi.Heading);
    playhisMarker.addTo(map);

    var chart = $("#gps-graph-container").highcharts();
    chart.series[0].data[__poi_Gps_His_i].setState('hover');
    $("#hisInfo").html(poi.DtC + " " + poi.TmC + " ความเร็ว:" + poi.Speed + " ความสูง: " + poi.Alt + "&nbsp;");

    playhisIns = setTimeout(function () {
        movehisMarker();
    }, initDelay/parseInt($("#playX").val()));
}

function movehisMarker() {
    if (!playhisMarker) return;
    if (ispausehisMarker) return;
    __poi_Gps_His_i++;
    if (__poi_Gps_His_i >= __poi_Gps_His.Datas.length) {
        $("#iplay").prop("src", "images/play.png");
        $("#ipause").prop("src", "images/pauseg.png");
        $("#istop").prop("src", "images/stopg.png");
        return;
    }
    var poi = __poi_Gps_His.Datas[__poi_Gps_His_i];
    playhisMarker.setLatLng(new E$.LatLng(poi.Lat, poi.Lng));
    map.setView([poi.Lat, poi.Lng], map.getZoom());
    playhisMarker.setRotationAngle(poi.Heading);

    var chart = $("#gps-graph-container").highcharts();
    chart.series[0].data[__poi_Gps_His_i-1].setState('');
    chart.series[0].data[__poi_Gps_His_i].setState('hover');
    $("#hisInfo").html(poi.DtC + " " + poi.TmC + " ความเร็ว:" + poi.Speed + " ความสูง: " + poi.Alt + "&nbsp;");

    playhisIns = setTimeout(function () {
        movehisMarker();
    }, initDelay / parseInt($("#playX").val()));
}

function pauseGpsHis() {
    ispausehisMarker = true;
    $("#iplay").prop("src", "images/play.png");
    $("#ipause").prop("src", "images/pauseg.png");
    $("#istop").prop("src", "images/stopg.png");
}
function stopGpsHis() {
    if (playhisIns) {
        clearTimeout(playhisIns);
    }
    $("#iplay").prop("src", "images/play.png");
    $("#ipause").prop("src", "images/pauseg.png");
    $("#istop").prop("src", "images/stopg.png");
}

////
var __layersGPSF_datas;
function loadGPSFLayer() {
    //window.open('../Rep/data/dlayer.ashx');
    $.ajax({
        type: 'POST',
        url: "../Rep/data/dlayer.ashx",
        data: {

        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            __layersGPSF_datas = data;
            setLayer1x('E');
            setLayer2x('E');
            setGpsPOIx('E');

            setLayer1x('P');
            setLayer2x('P');
            setGpsPOIx('P');
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });
}
function setLayer1x(id) {
    if (!id) id = "";
    var _datas = __layersGPSF_datas;
    $("#Layer1"+id).html("");
    $("#Layer1" + id).append("<option value='0'>ทั้งหมด</option>");
    for (var i = 0; i < _datas.length; i++) {
        $("#Layer1"+id).append("<option value='" + _datas[i].LyID + "'>" + _datas[i].Name + "</option>");
    }
    setLayer2x(id)
}
function setLayer2x(id) {
    if (!id) id = "";
    var _datas = __layersGPSF_datas;
    $("#Layer2"+id).html("");
    if ($("#Layer1"+id).val() == "0") {
        $("#Layer2"+id).append("<option value='0'>ทั้งหมด</option>");
        $("#Layer2" + id).prop("disabled", true);
        setGpsPOIx(id);
        return;
    }
    $("#Layer2" + id).prop("disabled", false);
    for (var i = 0; i < _datas.length; i++) {
        if (_datas[i].LyID == $("#Layer1" + id).val()) {
            $("#Layer2" + id).append("<option value='0'>ทั้งหมด</option>");
            for (var j = 0; j < _datas[i].children.length; j++) {
                if (_datas[i].children[j].Type != "Layer") continue;
                $("#Layer2" + id).append("<option value='" + _datas[i].children[j].LyID + "'>" + _datas[i].children[j].Name +"</option>");
            }
        }
    }
    setGpsPOIx(id);
}
function setGpsPOIx(id) {
    if (!id) id = "";
    var _datas = __layersGPSF_datas;
    $("#GpsPoi"+id).html("");
    if ($("#Layer2" + id).val() == "0") {
        $("#GpsPoi" + id).append("<option value='0'>ทั้งหมด</option>");
        $("#GpsPoi" + id).prop("disabled", true);
        return;
    }
    $("#GpsPoi" + id).prop("disabled", false);
    for (var i = 0; i < _datas.length; i++) {
        if (_datas[i].LyID == $("#Layer1" + id).val()) {
            for (var j = 0; j < _datas[i].children.length; j++) {
                if (_datas[i].children[j].Type != "Layer") continue;
                if (_datas[i].children[j].LyID == $("#Layer2" + id).val()) {
                    $("#GpsPoi" + id).append("<option value='0'>ทั้งหมด</option>");
                    if (_datas[i].children[j].children) {
                        for (var k = 0; k < _datas[i].children[j].children.length; k++) {
                            if (_datas[i].children[j].children[k].Type != "POI") continue;
                            $("#GpsPoi" + id).append("<option value='" + _datas[i].children[j].children[k].PoiID + "'>" + _datas[i].children[j].children[k].Name + "(" + _datas[i].children[j].children[k].RegNo + ")</option>");
                        }
                    }
                }
            }
        }
    }
}