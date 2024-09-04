
function initRoute() {
  
    //getRoute(13.909939, 100.755245, 13.75, 100.54061);
    parent.$('#DirFrm').blur(function () {
        //$('#DirFrm').removeClass("focus");
    })
      .focus(function () {
          parent.$(this).addClass("focus");
          parent.$('#DirTo').removeClass("focus");
      });
      parent.$('#DirTo').blur(function () {
        //$('#DirFrm').removeClass("focus");
    })
      .focus(function () {
          parent.$(this).addClass("focus");
          parent.$('#DirFrm').removeClass("focus");
      });

    map.on('click', function (e) {
        if (parent.$('#DirFrm').hasClass('focus')) {
            parent.$("#DirFrm").val(e.latlng.lat.toFixed(6) + ',' + e.latlng.lng.toFixed(6));
            parent.$('#DirFrm').removeClass("focus");
            setRouteFrm(e.latlng.lat, e.latlng.lng)
        }
        if (parent.$('#DirTo').hasClass('focus')) {
            parent.$("#DirTo").val(e.latlng.lat.toFixed(6) + ',' + e.latlng.lng.toFixed(6));
            parent.$('#DirTo').removeClass("focus");
            setRouteTo(e.latlng.lat, e.latlng.lng)
        }
    });
    parent.$("#DirSch").on("click", function () {
        if (routeflat && routeflng && routetlat && routetlng)
            getRoute(routeflat, routeflng, routetlat, routetlng);
    });
    parent.$("#DirClr").on("click", function () {
        parent.$('#DirTo').val('');
        parent.$('#DirFrm').val('');
        parent.setRouteDetail("");
        if (markerDirA)
            map.removeLayer(markerDirA);
        if (markerDirB)
            map.removeLayer(markerDirB);
        if (routeLayer)
            map.removeLayer(routeLayer);
    });

}
function setRouteFrm(lat, lng) {
    routeflat = lat;
    routeflng = lng;
    if (markerDirA)
        map.removeLayer(markerDirA);
    markerDirA = E$.marker(new E$.LatLng(lat, lng), { icon: E$.icon({ iconUrl: "images/icons/markerA.png", className: 'poiIcon', iconAnchor: [16, 32] }), title: "" });
    markerDirA.addTo(map);

    if (routeLayer)
        map.removeLayer(routeLayer);
}
function setRouteTo(lat, lng) {
    routetlat = lat;
    routetlng = lng;
    if (markerDirB)
        map.removeLayer(markerDirB);
    markerDirB = E$.marker(new E$.LatLng(lat, lng), { icon: E$.icon({ iconUrl: "images/icons/markerB.png", className: 'poiIcon', iconAnchor: [16, 32] }), title: "" });
    markerDirB.addTo(map);
    if (routeLayer)
        map.removeLayer(routeLayer);
}
var routeflat, routeflng, routetlat, routetlng;
var routeData = null;
var routeLayer = null;
var markerDirA, markerDirB;
function getRoute(flat, flon, tlat, tlon) {
    parent.setRouteDetail(loading);
    //window.open("data/dRoute.ashx?flat=" + flat + "&flon=" + flon + "&tlat=" + tlat + "&tlon=" + tlon);
    $.ajax({
        type: 'POST',
        //url: "data/dRoute.ashx",
        url: "https://mmmap15.longdo.com/mmroute/geojson/route",
         data: {
            flat: flat,
            flon: flon,
            tlat: tlat,
            tlon: tlon,
            key: "6906c0ee48f7220655e6436a20a49aab"
        },
        cache: false,
        dataType: 'jsonp',
        success: function (data) {
            dispRote(data);
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });
}

function dispRote(data) {
    if (routeLayer)
        map.removeLayer(routeLayer);

    routeData = data;
    var myStyle = {
        "color": "#0000cc",
        "weight": 5,
        "opacity": 0.5
    };

    //var geoJson = routeData.features[0];
    var geojsonFeature = {
        "type": "Feature",
        "properties": {
            "name": "",
            "amenity": "",
            "popupContent": ""
        },
        "geometry": {
            "type": "MultiLineString",
            "coordinates": []
        }
    };
    for(var i=0;i<routeData.features.length;i++){
        geojsonFeature.geometry.coordinates.push(routeData.features[i].geometry.coordinates);
    }

routeLayer = L.geoJson(geojsonFeature).addTo(map);
    routeLayer.setStyle(myStyle);
    
    var dist = 0;
    var intv = 0;
    var t = "";

    for (var i = 0; i < data.features.length; i++) {
        var ft = data.features[i];
        t += "<div style='min-height:30px;border-bottom:1px solid #ccc;'>";
        t += "<table width=100% height=100%><tr><td width=80%>";
        t += "<img src='images/turn/turn" + ft.properties.turn + ".png' /> " + (i + 1) + ". " + getturn(ft.properties.turn) + " ";
        t += "<a href='javascript:iMap.panToDir(" + i + ")'>" + ft.properties.name + "</a>";
        t += "</td><td align=right style='color:#999'>";
        if (parseFloat(ft.properties.distance) > 1000)
            t += (ft.properties.distance / 1000).toFixed(2) + " กม.";
        else
            t += ft.properties.distance + " ม.";

        t += "</td></tr></table></div>";

        dist += ft.properties.distance;
        intv += ft.properties.interval / 60;
    }

    t = "<div style='background:#777;color:#fff'><table width=100%><tr><td>&nbsp;" + (dist > 1000 ? (dist / 1000).toFixed(2) + " กม." : dist + " ม.") + "</td><td align=right>" + (intv > 60 ? parseInt(intv / 60) + " ชม. " + parseInt(intv % 60) + " นาที" : parseInt(intv) + " นาที") + "&nbsp;</td></tr></table></div>" + t;
    parent.setRouteDetail(t);
    //$("#DirResult").html(t);
    map.fitBounds(routeLayer.getBounds());
}
function panToDir(i) {
    if (!routeData) return;
    var ll = routeData.features[i].geometry.coordinates[0];
    map.setView({ lon: ll[0], lat: ll[1] }, 15);
}
function getturn(turn) {
    switch (turn) {
        case 0: return "เลี้ยวซ้ายสู่";
        case 1: return "เลี้ยวขวาสู่";
        case 2: return "เบี่ยงซ้ายสู่";
        case 3: return "เบี่ยงขวาสู่";
        case 4: return "";
        case 5: return "ตรงไปตาม";
        case 6: return "ใช้ทาง";
        case 7: return "ใช้รถไฟ";
        case 8: return "ใช้เรือ";
        case 9: return "ออกจาก";
        case 10: return "เข้าสู่";

    }
}


function swapRoute() {
    if (routeflat && routeflng && routetlat && routetlng) {
        var tmp = routeflat;
        routeflat = routetlat;
        routetlat = tmp;

        tmp = routeflng;
        routeflng = routetlng;
        routetlng = tmp;

        tmp = parent.$("#DirFrm").val();
        parent.$("#DirFrm").val(parent.$("#DirTo").val());
        parent.$("#DirTo").val(tmp);
        getRoute(routeflat, routeflng, routetlat, routetlng);
    }
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