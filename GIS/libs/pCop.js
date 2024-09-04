var loading = "<div style='text-align:center;margin-top:40px'><img src='images/loading.gif' /></div>";
var iMap, iStView;
var headerHeight = 74;
var maptoolsHeight = 1;

$(function () {
    iMap = $('#mapFrame')[0].contentWindow;
    iStView = $('#stViewFrame')[0].contentWindow;
    loadLayerTree();
    maptoolsHeight = $('.afms-sec-maptools').outerHeight() + 1;
    //alert(iStView);
});

function loadLayerTree() {
    if (_layerArr) {
        $("#layerTree").jstree({ 'core': { 'data': _layerArr },
            "checkbox": {
                "keep_selected_style": false,
                "tie_selection": false,
                "three_state": true

            },
            "plugins": ["search", "checkbox"]
        }).bind("select_node.jstree", function (e, data) {

        });
    }
    if (_gisLayerArr) {
        $("#gisLayerTree").jstree({ 'core': { 'data': _gisLayerArr },
            "checkbox": {
                "keep_selected_style": false,
                "tie_selection": false,
                "three_state": true

            },
            "plugins": ["search", "checkbox"]
        }).bind("select_node.jstree", function (e, data) {
            //iMap.loadGISTileLayer();
        }).bind("ready.jstree", function (e, data) {
             $("#gisLayerTree").on("check_node.jstree", function (e, data) {
                iMap.loadGISTileLayer();
            }).on("uncheck_node.jstree", function (e, data) {
                iMap.loadGISTileLayer();
            });
        });
    }
}

function click_Station(equ) {

    if (equ == "STN")
        $('.afms-sec-mapevent , .afms-sec-mapinfo , .afms-sec-mapsensor').addClass('is-active');
    else {
        $('.afms-sec-mapinfo').addClass('is-active');
        $('.afms-sec-mapevent , .afms-sec-mapsensor').removeClass('is-active');
    }
}

function setSize(){
    var windowHeight = $(window).height();
	var windowWidth = $(window).width();

	var headerHeight = $('.afms-page-cop .afms-sec-header').outerHeight() +1;
	var maptoolsHeight = $('.afms-sec-maptools').outerHeight() +1;
	var slidebarWidth = $('.afms-page-cop .afms-sec-sidebar').outerWidth();
	var mapeventWidth = $('.afms-sec-mapevent').outerWidth();

	$('.afms-sec-map').css('padding-top', headerHeight );

	if( $(document).height() > windowHeight ) {
		$('.afms-sec-container').css('margin-bottom', '-34px');
	}

	var getMapHeight = $('.afms-sec-map').height()

	setTimeout(function(){ 
		var mapstoolsHeight = $('.afms-sec-map .afms-sec-maptools').outerHeight() +1;

		$('.afms-sec-mapapp').css({
			'height': getMapHeight - mapstoolsHeight + 10,
			'margin-top': mapstoolsHeight - 10
		})
	}, 0);
		
	$('.afms-page-cop .afms-sec-sidebar').height( windowHeight - headerHeight );
	$('.afms-page-cop .afms-sec-map').height( windowHeight - headerHeight );

		var mapHeight = $('.afms-page-cop .afms-sec-map').outerHeight();

	$('body').height(window.innerHeight);

	var slidebarHeight = $('.afms-page-cop .afms-sec-sidebar').outerHeight() - 42;
	$('.afms-page-cop .afms-sec-sidebar > .tab-content').height( slidebarHeight - 75 );

	$('.afms-sec-mapsensor').width( windowWidth - slidebarWidth - mapeventWidth - 10 );
			
	var mapEventHeight = ( windowHeight - headerHeight - maptoolsHeight ) / 3;
	
	if ( windowHeight < 600 && windowWidth > 800 ) {
		console.log('1) windowHeight < 600 && windowWidth > 800')

		$('.afms-sec-mapevent').css({
			'top': headerHeight + maptoolsHeight - 3,
			'height': windowHeight - headerHeight - maptoolsHeight + 10
		});

		$('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - headerHeight - maptoolsHeight - 240);

	} else if ( windowHeight > 600 && windowWidth > 800 ) {
		console.log('2) windowHeight > 600 && windowWidth > 800')

		$('.afms-sec-mapevent').css({
			'top': headerHeight + maptoolsHeight - 2,
			'height': mapEventHeight
		});
		$('.afms-sec-mapevent .afms-wrapper').css({
			'height': mapEventHeight - 43
		});

		$('.afms-sec-mapinfo').css({
			'top': mapEventHeight + headerHeight + maptoolsHeight - 3,
			'height': mapEventHeight
		});
		$('.afms-sec-mapinfo .afms-wrapper').css({
			'height': mapEventHeight - 43
		});

		$('.afms-sec-mapstreet').css({
			'top': ( mapEventHeight * 2 ) + headerHeight + maptoolsHeight - 2,
			'height': mapEventHeight + 2
		});

	} else if ( windowHeight > 600 && ( windowWidth <= 800 && windowWidth > 600 ) ) {
		console.log('3) windowHeight > 600 && ( windowWidth <= 800 && windowWidth > 600 )')

		$('.afms-sec-mapevent').css({
			'top': headerHeight + maptoolsHeight - 2,
			'height': windowHeight - headerHeight - maptoolsHeight + 3
		});

		$('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - headerHeight - maptoolsHeight - 241);

	} else if ( windowHeight > 600 && (  windowWidth <= 600 ) )  {
		console.log('4) windowHeight > 600 && (  windowWidth <= 600 )')

		$('.afms-sec-mapevent').css({
			'height': windowHeight - headerHeight - maptoolsHeight + 10
		});

		$('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - 317);

	} else if ( windowHeight < 600 && (  windowWidth <= 600 ) )  {
		console.log('5) windowHeight < 600 && (  windowWidth <= 600 )')
		$('.afms-sec-mapevent').css({
			'height': windowHeight - headerHeight - maptoolsHeight + 10
		});

		$('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - 317);

	} else {
		console.log('6)')

	}

	if ( windowWidth <= 420 ) {
		$('.afms-sec-maptools').css({
			width: windowWidth
		});
	} else {
		$('.afms-sec-maptools').css({
			width: 100 + '%'
		});
	}

	if ( windowWidth > 992 ) {
		//$('.afms-content .collapse:not(#advanceFilter)').addClass('in');
		$('.afms-sec-sidebar .collapse:not(#advanceFilter)').addClass('in');
		//console.log('dddd');
	} else {
		//$('.afms-content .collapse').addClass('in');
		$('.afms-sec-sidebar .collapse').removeClass('in');
	}
}
function click_Poi() {
    $('.afms-sec-mapstreet').addClass('is-active');
    setSize();
}

function openInfo(t, equ) {
    $(".info_tab").html(t);
    var windowHeight = $(window).height();
    var windowWidth = $(window).width();
    $('.afms-sec-mapinfo').addClass('is-active');
   
    var mapEventHeight = (windowHeight - headerHeight - maptoolsHeight) / 3;
     //if (windowHeight > 600 && windowWidth > 800) {
        $('.afms-sec-mapinfo').css({
            'top': maptoolsHeight + 10,
            'height': mapEventHeight*2
        });
        $('.afms-sec-mapinfo .afms-wrapper').css({
            'height': mapEventHeight * 2 - 43
        });
        //}
        if (equ) {
            click_Station(equ);
        } else {
            $('.afms-sec-mapevent ,.afms-sec-mapsensor').removeClass('is-active');
        }
        click_Poi();
}

function syncEvent() {
    iMap.syncEvent();

}
function showEvent(evid) {
    iMap.showEvent(evid);

}
function selectPoi(a,b,c) {
    iMap.selectPoi(a,b,c);

}
function formatDD(n) {
    return n > 9 ? "" + n : "0" + n;
}

function setSFilter(t, val) {
    if (val == "1") {
        var d = new Date();
        $("#" + t + "FDt").val(formatDD(d.getDate()) + "/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543) + " " + formatDD(d.getHours() - 1) + ":" + formatDD(d.getMinutes()));
        $("#" + t + "TDt").val(formatDD(d.getDate()) + "/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543) + " " + formatDD(d.getHours()) + ":" + formatDD(d.getMinutes()));
    }
    if (val == "2") {
        var d1 = new Date();
        var d = new Date(Date.now() + 864e5);
        $("#" + t + "FDt").val(formatDD(d1.getDate()) + "/" + formatDD(d1.getMonth() + 1) + "/" + (d1.getFullYear() + 543)+" 00:00");
        $("#" + t + "TDt").val(formatDD(d.getDate()) + "/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543) + " 00:00");
  
    }
    if (val == "3") {
        var d = new Date(Date.now());
        var d1 = new Date(Date.now() - 864e5);
        $("#" + t + "FDt").val(formatDD(d1.getDate()) + "/" + formatDD(d1.getMonth() + 1) + "/" + (d1.getFullYear() + 543) + " 00:00");
        $("#" + t + "TDt").val(formatDD(d.getDate()) + "/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543) + " 00:00");

    }
    if (val == "4") {
        var d = new Date(Date.now() - 864e5);
        var d1 = new Date(Date.now() - 864e5 * 2);
        $("#" + t + "FDt").val(formatDD(d1.getDate()) + "/" + formatDD(d1.getMonth() + 1) + "/" + (d1.getFullYear() + 543) + " 00:00");
        $("#" + t + "TDt").val(formatDD(d.getDate()) + "/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543) + " 00:00");

    }
    if (val == "5") {
        var d = new Date(Date.now() - 864e5);
        var d1 = new Date(Date.now() - 864e5 * 3);
        $("#" + t + "FDt").val(formatDD(d1.getDate()) + "/" + formatDD(d1.getMonth() + 1) + "/" + (d1.getFullYear() + 543) + " 00:00");
        $("#" + t + "TDt").val(formatDD(d.getDate()) + "/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543) + " 00:00");

    }
    if (val == "6") {
        var curr = new Date();
        var d1 = new Date(curr.setDate(curr.getDate() - curr.getDay()));
        var d = new Date(Date.now());
        $("#" + t + "FDt").val(formatDD(d1.getDate()) + "/" + formatDD(d1.getMonth() + 1) + "/" + (d1.getFullYear() + 543) + " 00:00");
        $("#" + t + "TDt").val(formatDD(d.getDate()) + "/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543) + " 00:00");

    }
    if (val == "7") {
        var curr = new Date();
        var d = new Date(curr.setDate(curr.getDate() - curr.getDay()));
        var d1 = new Date(curr.setDate(curr.getDate() - curr.getDay() - 7));

        $("#" + t + "FDt").val(formatDD(d1.getDate()) + "/" + formatDD(d1.getMonth() + 1) + "/" + (d1.getFullYear() + 543) + " 00:00");
        $("#" + t + "TDt").val(formatDD(d.getDate()) + "/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543) + " 00:00");

    }
    if (val == "8") {
        var d = new Date(Date.now());
        $("#" + t + "FDt").val("01/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543) + " 00:00");
        $("#" + t + "TDt").val(formatDD(d.getDate()) + "/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543) + " 00:00");

    }
    if (val == "9") {
        var curr = new Date();
        var d = new Date(curr.getFullYear(), curr.getMonth(), 1);
        var d1 = new Date(d.setDate(d.getDate() - 1));
        d = new Date();
        $("#" + t + "FDt").val("01/" + formatDD(d1.getMonth() + 1) + "/" + (d1.getFullYear() + 543) + " 00:00");
        $("#" + t + "TDt").val("01/" + formatDD(d.getMonth() + 1) + "/" + (d.getFullYear() + 543) + " 00:00");

    }
}

///Search///

function doSchPBck() {
    $("#tabSch_result").html(loading);
    $("#tabSch_result").show();
    iMap.clearSchPOI(1);

    /*
    window.open("data/dHisSch.ashx?s=" + $("#sStation").val() +
        "&ev=" + $("#sEvent").val() +
        "&d1=" + $("#sFDt").val() +
        "&d2=" + $("#sTDt").val());
      */  
    $.ajax({
    type: 'GET',
    url: "data/dHisSch.ashx",
    data: {
        s: $("#sStation").val(),
        ev: $("#sEvent").val(),
        d1: $("#sFDt").val(),
        d2: $("#sTDt").val()
    },
    cache: false,
    dataType: 'json',
    success: function (data) {
        if (data.result == "ERR") {

        } else if (data.result == "OK") {
            displayHisResult(data.datas);
        }
    },
    error: function (XMLHttpRequest, textStatus, errorThrown) {

    }
});

}

var EventPOI_datas;
function displayHisResult(pois) {
   /*// $('#mapFrame')[0].contentWindow.EventPOI_datas = pois;
    var t = "";
    $('#mapFrame')[0].contentWindow.poiArray_SchTab = [];
    
    if (pois.length > 0) {

        t += "<table class='table'><thead><tr><th>Datetime</th><th>Station</th><th>Event</th></tr></thead><tbody>";
        for (var i = 0; i < pois.length; i++) {
            var poi = pois[i];
            t += "<tr onclick=selectPoi('sch','" + poi.Key + "',1)>";
            t += "<td>" + poi.DtAdd + " " + poi.TmAdd + "</td>";
            t += "<td>" + poi.Name + "</td>";
            t += "<td>" + poi.EvName + "</td>";
            t += "</tr>";

            $('#mapFrame')[0].contentWindow.createHisPoi(poi);
        }
        t += "</tbody></table>";
    } else {
        t += "<div style='text-align:center'>ไม่พบข้อมูล </div>";
    }
    $("#tabSch_result").html(t);
   
   */

    EventPOI_datas = pois;
    var t = "";
    if (pois.length > 0) {
        //t += " พบ " + pois.length + " รายการ ";
        t += "<table class='table'><thead><tr><th>Scanner</th><th>วันเวลาที่ตรวจพบ</th><th>ความถี่</th><th>ความแรง</th><th>ผู้ครอบครอง</th></tr></thead><tbody>";
        for (var i = 0; i < pois.length; i++) {
            var poi = pois[i];
            if (poi.rType != "") continue;
            t += "<tr onclick='showEvent_h(" + poi.EvID + ")'>";
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

    $("#tabSch_result").html(t);
}

function showEvent_h(evid) {
    if (!EventPOI_datas) return;
    for (var i = 0; i < EventPOI_datas.length; i++) {
        var poi = EventPOI_datas[i];
        if (poi.EvID == evid) {
            //showPoiDetail(poi.PoiID, "event");
          /*
            */
            iMap.openPopUp(poi,eventContent(poi));
            return;
        }
    }
}

function eventContent(poi) {
    var content = "<table width=250>";
    content += "<tr><td style='font-weight:bold'>Station:</td><td>" + poi.Station + "</td></tr>";
    content += "<tr><td style='font-weight:bold'>ความถี่:</td><td>" + poi.Freq + "MHz</td></tr>";
    content += "<tr><td style='font-weight:bold'>ความแรง:</td><td>" + poi.Signal + "dBm</td></tr>";
    content += "<tr><td style='font-weight:bold'>ผู้ครอบครอง:</td><td><a href=\"javascript:parent.gotoHost('" + poi.EvPoiID + "')\">" + poi.HostName + "</a></td></tr>";
    content += "<tr><td style='font-weight:bold'>ตำแหน่ง:</td><td>" + poi.Lat + "," + poi.Lng + "</td></tr>";
    content += "<tr><td style='font-weight:bold'>เวลา:</td><td>" + poi.DtAdd + " " + poi.TmAdd + "</td></tr>";
    content += "</table>";

    return content;

}

//Search Layer
function clearLandPOI() {
    _schParam = '';
    $("#exportPOIBtn").hide();
    iMap.clearLandPOI(0);
    $("#tabLayer_result").html("");

}
function doSch() {
    if (document.getElementById("sch_type_l") && document.getElementById("sch_type_l").checked) {
        return doSchL();
    }
    iMap.clearLandPOI(0);
    $("#tabLayer_result").html(loading);
    
    var chkLayers = [];
    var tree = $('#layerTree').jstree("get_checked", true);
    $.each(tree, function () {
        chkLayers.push(this.id.replace("li_", ""));
    });

    var map = $('#mapFrame')[0].contentWindow.map;
    var patcode = $("#sTumbon2").val();
    if (patcode == "0")
        patcode = $("#sAumphur2").val();
    if (patcode == "0")
        patcode = $("#sProv2").val();
    //window.open("data/dPoiSch.ashx?keyword=" + escape($("#sDetail").val()) + "&lat=" + map.getCenter().lat + "&lng=" + map.getCenter().lng + "&lyids=" + chkLayers.join(',')+"&code="+patcode);
    $.ajax({
        type: 'POST',
        url: "data/dPoiSch.ashx",
        data: {
            keyword: escape($("#sDetail").val()),
            lat: map.getCenter().lat,
            lng: map.getCenter().lng,
            lyids: chkLayers.join(','),
            code: patcode,
            reg: $("#sReg2").val(),
            area: $("#sArea2").val()
        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            if (data.result == "ERR") {

            } else if (data.result == "OK") {
                _schParam = "keyword=" + escape($("#sDetail").val()) + "&lat=" + map.getCenter().lat + "&lng=" + map.getCenter().lng + "&lyids=" + chkLayers.join(',') + "&code=" + patcode;
                $("#exportPOIBtn").show();
        
                $('#mapFrame')[0].contentWindow.displayLandResult(data.datas);
                //alert(data.datas.length);
             }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            var t = "<div style='text-align:center'>ข้อมูลผิดพลาด </div>";
            $("#tabLayer_result").html(t);
        }
    });

    return false;
}

function dispSchType(type) {
    if (type == 'l' && !iMap.schObject) {
        var c = iMap.map.getCenter();
        $("#Loc_l").val(iMap.degreeFormat(c.lat) + "," + iMap.degreeFormat(c.lng));
        $("#Radius_l").val("500");

    }
    if (type == 'l') {
        iMap.bCirSch_click();
    }
}



function doSchL() {
    iMap.resetTools()
    var err = "";
    if (document.getElementById("Loc_l").value == "")
        err += '* โปรดกรอกตำแหน่ง\n';

    var latlngs = document.getElementById("Loc_l").value.split(',');
    if (latlngs.length != 2)
        err += '* โปรดกรอกตำแหน่ง (Lat,Long)';
    var lat = parseFloat(latlngs[0]);
    var lng = parseFloat(latlngs[1]);
    if (lat < -90 || lat > 90 || lng < -180 || lng > 180)
        err += '* ตำแหน่งไม่ถูกต้อง';

    if (document.getElementById("Radius_l").value == "")
        err += '* โปรดกรอกรัศมี\n';

    if (isNaN(document.getElementById("Radius_l").value))
        err += '* โปรดกรอกรัศมี เป็นตัวเลข (1-50000)\n';
    var r = parseFloat(document.getElementById("Radius_l").value);
    if (r < 1 || r > 50000)
        err += '* โปรดกรอกรัศมี เป็นตัวเลข (1-50000)\n';

    //$("#error_l").html(err);
    if (err != '') {
         swal({
            title: "โปรดกรอกข้อมูล",
            text: err,
            type: 'warning',
            confirmButtonText: 'ตกลง'
        });
        return false;
    }
    iMap.clearLandPOI(0);
    var chkLayers = [];
    var tree = $('#layerTree').jstree("get_checked", true);
    $.each(tree, function () {
        chkLayers.push(this.id.replace("li_", ""));
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
                iMap.schObject = iMap.E$.circle([lat, lng], r, { color: "#0c0", weight: 3, opacity: 0.7, fillColor: "#0c0", fillOpacity: 0, clickable: false });
                iMap.schObject.addTo(iMap.map);
                iMap.displayLandResult(data.datas);
                iMap.map.fitBounds(iMap.schObject.getBounds());
                //alert(data.datas.length);
                _schParam = "lat=" + lat + "&lng=" + lng + "&r=" + r + "&lyids=" + chkLayers.join(',');
                $("#exportPOIBtn").show();
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            var t = "<div style='text-align:center'>ข้อมูลผิดพลาด </div>";
            $("#tabLayer_result").html(t);
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


///Event Info
function loadEventInfo(poiid) {
    $("#mapevent-content").html("");
    $.ajax({
        type: 'POST',
        url: "data/dEvent.ashx",
        data: {
            s: poiid,
            ev: 0
        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            if (data.result == "ERR") {

            } else if (data.result == "OK") {
                displayEventInfo(data.datas);
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });
}

function displayEventInfo(pois) {
    EventPOI_datas_i = pois;
    var t = "";
    if (pois.length > 0) {
        t += "<table class='table' style='min-width:400px'><thead><tr><th>Scanner</th><th>วันเวลาที่ตรวจพบ</th><th>ความถี่</th><th>ความแรง</th><th>ผู้ครอบครอง</th></tr></thead><tbody>";
        for (var i = 0; i < pois.length; i++) {
            var poi = pois[i];
            if (poi.rType != "") continue;
            t += "<tr onclick='showEvent_i(" + poi.EvID + ")'>";
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
    $("#mapevent-content").html(t);

}
function showEvent_i(evid) {
    if (!EventPOI_datas_i) return;
    for (var i = 0; i < EventPOI_datas_i.length; i++) {
        var poi = EventPOI_datas_i[i];
        if (poi.EvID == evid) {
            //showPoiDetail(poi.PoiID, "event");
            /*
            */
            iMap.openPopUp(poi, eventContent(poi));
            return;
        }
    }
}

function gotoHost(poiid) {
    //iMap.openPopUpLL([lat, lng], "<div style='width:150px'>"+name+"</div>");

    iMap.showEventMarker(poiid);     
}


///route
$(function(){
    $('#routeStart').keydown(function (e) {
        if ($('#routeStart').val().length < 3) {
            if($('.afms-search-route-start-autocomplete ul').html()!='')
                $('.afms-search-route-start-autocomplete').slideDown('fast');
            $('.afms-search-route-start-autocomplete ul').html('');
            return;
        }
        searchFPalce();
        $('.afms-search-route-start-autocomplete ul').html('');

    });

    $('#routeEnd').keydown(function (e) {
        if ($('#routeEnd').val().length < 3) {
            if ($('.afms-search-route-destination-autocomplete ul').html() != '')
                $('.afms-search-route-destination-autocomplete').slideDown('fast');
            $('.afms-search-route-destination-autocomplete ul').html('');
            return;
        }
        searchTPalce();
        $('.afms-search-route-destination-autocomplete ul').html('');

    });
});

var _jsonschFData,_jsonschTData,_routeSt,_routeEnd;
function searchFPalce() {
    var latlng=iMap.map.getCenter();
    $.ajax({
        type: 'GET',
        url: "https://search.longdo.com/mapsearch/json/search",
        data: {
            keyword : encodeURIComponent($('#routeStart').val()),
            lat: latlng[0],
            lng: latlng[1],
            key: "6906c0ee48f7220655e6436a20a49aab"
        },
        cache: false,
        dataType: 'jsonp',
        success: function (json) {
           _jsonschFData=json;
           //alert(data.data[0].name);
           for(var i=0;i<json.data.length;i++){
                $('.afms-search-route-start-autocomplete ul').append('<li onclick=selectFP('+i+')><i class="afms-ic_destination"></i><p>'+json.data[i].name+'</p></li>');
           }
           $('.afms-search-route-start-autocomplete').slideDown('fast');
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
           
        }
    });
}

function selectFP(i){
    _routeSt = _jsonschFData.data[i];
    $('#routeStart').val(_routeSt.name);
    $('.afms-search-route-start-autocomplete').slideUp('fast');
    iMap.map.panTo([_routeSt.lat,_routeSt.lon]);
    iMap.setRouteFrm(_routeSt.lat, _routeSt.lon);

    if (_routeSt && _routeEnd)
        iMap.getRoute(_routeSt.lat, _routeSt.lon, _routeEnd.lat, _routeEnd.lon);
}

function searchTPalce() {
    var latlng=iMap.map.getCenter();
    $.ajax({
        type: 'GET',
        url: "https://search.longdo.com/mapsearch/json/search",
        data: {
            keyword : encodeURIComponent($('#routeEnd').val()),
            lat: latlng[0],
            lng: latlng[1],
            key: "6906c0ee48f7220655e6436a20a49aab"
        },
        cache: false,
        dataType: 'jsonp',
        success: function (json) {
           _jsonschTData=json;
           //alert(data.data[0].name);
           for(var i=0;i<json.data.length;i++){
               $('.afms-search-route-destination-autocomplete ul').append('<li onclick=selectTP(' + i + ')><i class="afms-ic_destination"></i><p>' + json.data[i].name + '</p></li>');
           }
            $('.afms-search-route-destination-autocomplete').slideDown('fast');
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
           
        }
    });
}

function selectTP(i){
    _routeEnd = _jsonschTData.data[i];
    $('#routeEnd').val(_routeEnd.name);
    $('.afms-search-route-destination-autocomplete').slideUp('fast');
    iMap.map.panTo([_routeEnd.lat, _routeEnd.lon]);
    iMap.setRouteTo(_routeEnd.lat, _routeEnd.lon);

    if(_routeSt && _routeEnd)
        iMap.getRoute(_routeSt.lat, _routeSt.lon, _routeEnd.lat, _routeEnd.lon);
}

function setRouteDetail(t) {
    $(".afms-route-detail").html(t);
    $(".afms-route-detail").show();
}

function swapRoute() {
    var tmp = _routeSt;
    _routeSt = _routeEnd;
    _routeEnd = tmp;
    if (_routeSt) {
        $('#routeStart').val(_routeSt.name);
        iMap.setRouteFrm(_routeSt.lat, _routeSt.lon);
    } else {
        $('#routeStart').val("");
    }
    if (_routeEnd) {
        $('#routeEnd').val(_routeEnd.name);
        iMap.setRouteTo(_routeEnd.lat, _routeEnd.lon);
    } else {
        $('#routeEnd').val("");
    }
    if (_routeSt && _routeEnd)
        iMap.getRoute(_routeSt.lat, _routeSt.lon, _routeEnd.lat, _routeEnd.lon);
}

function clearRoute() {
    $('#routeStart').val("");
    $('#routeEnd').val("");
    $(".afms-route-detail").html("");
    $(".afms-route-detail").hide();
    iMap.clearRoute();
}

var __selEq = "STN";
function selEq(cls) {
  
    if(cls)
        __selEq = cls;
    $(".eqt").hide();
    $(".eqt_" + __selEq).show();

    if (__selEq == "STN")
        $(".eqt_STN2").show();

    $("#HEquip a").css("color", "#aaa");
    $("#a" + __selEq).css("color", "#000");

    
    $("tr.equip_pLayer").each(function () {
        var plyid = $(this).attr("rel");
        var isshow = false;

        $(".iplyid_" + plyid).each(function () {
            if ($(this).is(":visible")) {
                isshow = true;
            }

        });
        if(isshow)
            $(this).show();
        else
            $(this).hide();
    });
    
    $("tr.equip_Layer").each(function () {
        var lyid = $(this).attr("rel");
        var isshow = false;
        $("tr.ilyid_" + lyid).each(function () {
            if ($(this).is(":visible")) {
                isshow = true;
            }

        });
        
        if (isshow)
            $(this).show();
        else
            $(this).hide();
    });
}


function toggleFullScreen() {
    var elem = document.body;
    // ## The below if statement seems to work better ## if ((document.fullScreenElement && document.fullScreenElement !== null) || (document.msfullscreenElement && document.msfullscreenElement !== null) || (!document.mozFullScreen && !document.webkitIsFullScreen)) {
    if ((document.fullScreenElement !== undefined && document.fullScreenElement === null) || (document.msFullscreenElement !== undefined && document.msFullscreenElement === null) || (document.mozFullScreen !== undefined && !document.mozFullScreen) || (document.webkitIsFullScreen !== undefined && !document.webkitIsFullScreen)) {
        if (elem.requestFullScreen) {
            elem.requestFullScreen();
        } else if (elem.mozRequestFullScreen) {
            elem.mozRequestFullScreen();
        } else if (elem.webkitRequestFullScreen) {
            elem.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
        } else if (elem.msRequestFullscreen) {
            elem.msRequestFullscreen();
        }
    } else {
        if (document.cancelFullScreen) {
            document.cancelFullScreen();
        } else if (document.mozCancelFullScreen) {
            document.mozCancelFullScreen();
        } else if (document.webkitCancelFullScreen) {
            document.webkitCancelFullScreen();
        } else if (document.msExitFullscreen) {
            document.msExitFullscreen();
        }
    }
}


////
var _schParam = '';
function exportLandPOI() {
    if (_schParam == '')
        return;

    window.open("ExportPOI.aspx?"+_schParam+"&export=xls");
  

}