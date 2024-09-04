var distMarker1;
var distMarker2;
var distLine;
var dfMarkers = [];
var dxMarkers = [];

function copClearTools() {
    if (distMarker1)
        map.removeLayer(distMarker1);
    if (distMarker2)
        map.removeLayer(distMarker2);
    if (distLine)
        map.removeLayer(distLine);
    for (var i = 0; i < dfMarkers.length; i++) {
        if(dfMarkers[i])
            map.removeLayer(dfMarkers[i]);
    }
    dfMarkers = [];
    for (var i = 0; i < dxMarkers.length; i++) {
        if (dxMarkers[i])
            map.removeLayer(dxMarkers[i]);
    }
    dxMarkers = [];
}


function copAddTools(){
    parent.$("#bToolmDist2").bind("click", function () {
        var div = "<div style='width:300px;margin:30px'>";
        div += "<b>Measure 2 Points</b><br /><br />";
        if (posFormat == PosFormat.Dec) {
            div += "<table style='margin-left:10px'>";
            div += "<tr><td><td>Latitude</td><td>Longitude</td></tr>";
            div += "<tr><td>1.</td><td><input id=meas_Lat1 type=text style='width:120px'></td>";
            div += "<td><input id=meas_Lng1 type=text style='width:120px'></td></tr>";
            div += "<tr><td>2.</td><td><input id=meas_Lat2 type=text style='width:120px'></td>";
            div += "<td><input id=meas_Lng2 type=text style='width:120px'></td></tr>";
            div += "</table>";
        }
       
        div += "<br /><div style='text-align:right'><input type=button value=' OK ' onclick = 'dist2Point()' /> <input type=button value='Cancel' onclick=$.fancybox.close() /></div>";

        div += "</div>";


        $.fancybox(div, {
            'width': 350,
            'height': 330,
            'autoScale': false,
            'transitionIn': 'none',
            'transitionOut': 'none'
        });

        //test val
        /*
        $("#meas_Lat1").val('13.75');
        $("#meas_Lng1").val('100.5');
        $("#meas_Lat2").val('13.8');
        $("#meas_Lng2").val('100.55');
        */
    });

    parent.$("#bToolDF").bind("click", function () {
        prepareMeasure();
        $("#bToolDF").addClass("selected");
        $("#map").addClass("crossCursor");
        mapToolMode = ToolMode.df;
    });
}

function copMapClick(e) {
    if (mapToolMode == ToolMode.df) {
        $("#bToolPan").addClass("selected");
        mapToolMode = ToolMode.pan;

        var dfmarker = E$.marker(e.latlng, { icon:
                E$.icon({ iconUrl: "images/icons/markerDF.png", iconAnchor: [12, 12] }),
            clickable: true
        }).addTo(map);

        dfmarker.idx = dfMarkers.length;
        dfmarker.deg = 0;
        dfmarker.on('click', function () { popUpDF(this) });
        dfMarkers.push(dfmarker);
        
        setTimeout(function () {
            resetCursor();
            popUpDF(dfmarker);
        }, 200);
    }
}

function popUpDF(dfmarker) {
    var div = "";
    div += "<table style='margin-left:20px'>";
    //div += "<tr><td><td><td>"+(dfmarker.idx+1)+"</td></tr>";
    div += "<tr><td>Latitude: <td><td><input id=df_Lat type=text style='width:120px' value='" + dfmarker.getLatLng().lat.toFixed(6) + "'></td></tr>";
    div += "<tr><td>Longitude: <td><td><input id=df_Lng type=text style='width:120px' value='" + dfmarker.getLatLng().lng.toFixed(6) + "'></td></tr>";
    div += "<tr valign=top><td>Bearing: <br />(degree) <td><td><input id=df_Deg type=text style='width:120px' value='" + dfmarker.deg + "'></td></tr>";
    div += "</table>";
    div += "<br /><div style='text-align:right'><input type=button value=' OK ' onclick = 'dfDone(" + dfmarker.idx + ")' /> <input type=button value='Delete' onclick='dfDelete(" + dfmarker.idx + ")' /> </div>";

    infoPopup = E$.popup({ offset: [0, -16], autoPanPadding: [10, 80], closeOnClick: false });
    infoPopup.setLatLng(dfmarker.getLatLng());
    infoPopup.setContent(div);
    infoPopup.openOn(map);
}

function popUpDX(dfmarker) {
    var div = "";
    div += "<table>";
    div += "<tr><td colspan=2>Result</td></tr>";
    div += "<tr><td>Latitude<td><td>"+ dfmarker.getLatLng().lat.toFixed(6) + "</td></tr>";
    div += "<tr><td>Longitude<td><td>" + dfmarker.getLatLng().lng.toFixed(6) + "</td></tr>";
    div += "</table>";

    infoPopup = E$.popup({ offset: [0, -12], autoPanPadding: [10, 80], closeOnClick: false });
    infoPopup.setLatLng(dfmarker.getLatLng());
    infoPopup.setContent(div);
    infoPopup.openOn(map);
}


function dfDone(idx) {
    var t_lat = $("#df_Lat").val();
    var t_lng = $("#df_Lng").val();
    var t_deg = $("#df_Deg").val();
    var err = '';
    if (t_lat == '' || isNaN(t_lat)) {
        err += "Invalid Latitude";
    } else {
        lat = parseFloat(t_lat);
        if (lat < -90 || lat > 90) {
            err += "Invalid Latitude";
        }
    }

    if (t_lng == '' || isNaN(t_lng)) {
        err += "\nInvalid Longitude";

    } else {
        lng = parseFloat(t_lng);
        if (lng< -180 || lng > 180) {
            err += "\nInvalid Longitude";
        }
    }
    if (t_deg == '' || isNaN(t_deg)) {
        err += "Invalid Bearing";
    } else {
        deg = parseFloat(t_deg);
        if (deg < 0 || deg > 360) {
            err += "Invalid Bearing";
        }
    }
    if (err != '') {
        alert(err);
        return;
    }

    if (dfMarkers[idx]) {
        dfMarkers[idx].setLatLng([lat, lng]);
        dfMarkers[idx].deg = deg;
        dfMarkers[idx].setRotationAngle(deg);
    }
    closeInfoPopup();
    dfCal();
}

function dfDelete(idx) {
   closeInfoPopup();
   ///alert(idx);
    if (dfMarkers[idx])
        map.removeLayer(dfMarkers[idx]);
    
    dfMarkers.splice(idx, 1);
    for (var i = 0; i < dfMarkers.length; i++) {
        if (dfMarkers[i])
            dfMarkers[i].idx = i;
    }

    dfCal();
    // alert(dfMarkers.length);
}

function dfCal() {
    for (var i = 0; i < dxMarkers.length; i++) {
        if (dxMarkers[i])
            map.removeLayer(dxMarkers[i]);
    }
    dxMarkers = [];
    if (dfMarkers.length < 2) return;
    
    for (var i = 0; i < dfMarkers.length; i++) {
        for (var j = i + 1; j < dfMarkers.length; j++) {
            var p1 = dfMarkers[i];
            var p2 = dfMarkers[j];
            if (p1 && p2) {
                var llx = dfIntersec(p1.getLatLng(), p1.deg, p2.getLatLng(), p2.deg);
                if(!llx) continue;
                //alert(llx[0] + " " + llx[1]);

                var dxmarker = E$.marker(llx, { icon:
                    E$.icon({ iconUrl: "images/icons/markerDX.png", iconAnchor: [12, 24] }),
                    clickable: true
                }).addTo(map);
                dxmarker.on('click', function () { popUpDX(this) });
                dxMarkers.push(dxmarker);

                var line1 = E$.polyline([llx, p1.getLatLng()], { color: "#f00", weight: 2, opacity: 1, clickable: false }).addTo(map); ;
                var line2 = E$.polyline([llx, p2.getLatLng()], { color: "#f00", weight: 2, opacity: 1, clickable: false }).addTo(map); ;
                dxMarkers.push(line1);
                dxMarkers.push(line2);
            }
        }
    }
    var minlat = 90;
    var maxlat = -90;
    var minlng = 180;
    var maxlng = -180;

    for (var i = 0; i < dfMarkers.length; i++) {
        if (dfMarkers[i] && dfMarkers[i].getLatLng) {
            minlat = Math.min(minlat, dfMarkers[i].getLatLng().lat);
            maxlat = Math.max(maxlat, dfMarkers[i].getLatLng().lat);
            minlng = Math.min(minlng, dfMarkers[i].getLatLng().lng);
            maxlng = Math.max(maxlng, dfMarkers[i].getLatLng().lng);
        }
    }
    for (var i = 0; i < dxMarkers.length; i++) {
        if (dxMarkers[i] && dxMarkers[i].getLatLng) {
            minlat = Math.min(minlat, dxMarkers[i].getLatLng().lat);
            maxlat = Math.max(maxlat, dxMarkers[i].getLatLng().lat);
            minlng = Math.min(minlng, dxMarkers[i].getLatLng().lng);
            maxlng = Math.max(maxlng, dxMarkers[i].getLatLng().lng);
        }
    }

    map.fitBounds(new L.latLngBounds([minlat, minlng], [maxlat, maxlng]), { padding: [50, 50] }); 
}

Math.radians = function(degrees) {
  return degrees * Math.PI / 180;
};
 
// Converts from radians to degrees.
Math.degrees = function(radians) {
  return radians * 180 / Math.PI;
};

function dfIntersec (p1, brng1, p2, brng2) {
    lat1 = Math.radians(p1.lat), lon1= Math.radians(p1.lng)
    lat2 = Math.radians(p2.lat), lon2 = Math.radians(p2.lng)
    brng13 = Math.radians(brng1),  brng23=Math.radians(brng2)
    dLat = lat2 - lat1, dLon = lon2 - lon1;

    dist12 = 2 * Math.asin(Math.sqrt(Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1) * Math.cos(lat2) * Math.sin(dLon / 2) * Math.sin(dLon / 2)));
    if (dist12 == 0) return null;

    // initial/final bearings between points
    brngA = Math.acos((Math.sin(lat2) - Math.sin(lat1) * Math.cos(dist12)) /
    (Math.sin(dist12) * Math.cos(lat1)));
    if (isNaN(brngA)) brngA = 0;  // protect against rounding
    brngB = Math.acos((Math.sin(lat1) - Math.sin(lat2) * Math.cos(dist12)) /
    (Math.sin(dist12) * Math.cos(lat2)));

    if (Math.sin(lon2 - lon1) > 0) {
        brng12 = brngA;
        brng21 = 2 * Math.PI - brngB;
    } else {
        brng12 = 2 * Math.PI - brngA;
        brng21 = brngB;
    }

    alpha1 = (brng13 - brng12 + Math.PI) % (2 * Math.PI) - Math.PI;  // angle 2-1-3
    alpha2 = (brng21 - brng23 + Math.PI) % (2 * Math.PI) - Math.PI;  // angle 1-2-3

    if (Math.sin(alpha1) == 0 && Math.sin(alpha2) == 0) return null;  // infinite intersections
    if (Math.sin(alpha1) * Math.sin(alpha2) < 0) return null;       // ambiguous intersection

    //alpha1 = Math.abs(alpha1);
    //alpha2 = Math.abs(alpha2);
    // ... Ed Williams takes abs of alpha1/alpha2, but seems to break calculation?

    alpha3 = Math.acos(-Math.cos(alpha1) * Math.cos(alpha2) +
                       Math.sin(alpha1) * Math.sin(alpha2) * Math.cos(dist12));
    dist13 = Math.atan2(Math.sin(dist12) * Math.sin(alpha1) * Math.sin(alpha2),
                       Math.cos(alpha2) + Math.cos(alpha1) * Math.cos(alpha3))
    lat3 = Math.asin(Math.sin(lat1) * Math.cos(dist13) +
                    Math.cos(lat1) * Math.sin(dist13) * Math.cos(brng13));
    dLon13 = Math.atan2(Math.sin(brng13) * Math.sin(dist13) * Math.cos(lat1),
                       Math.cos(dist13) - Math.sin(lat1) * Math.sin(lat3));
    lon3 = lon1 + dLon13;
    lon3 = (lon3 + 3 * Math.PI) % (2 * Math.PI) - Math.PI;  // normalise to -180..+180Âº
    
    return [Math.degrees(lat3), Math.degrees(lon3)];
}

function dist2Point() {
    var t_lat1 = $("#meas_Lat1").val();
    var t_lng1 = $("#meas_Lng1").val();
    var t_lat2 = $("#meas_Lat2").val();
    var t_lng2 = $("#meas_Lng2").val();
    var err = '';
    if (t_lat1 == '' || isNaN(t_lat1)) {
        err += "Invalid Latitude 1";
    } else {
        lat1 = parseFloat(t_lat1);
        if (lat1 < -90 || lat1 > 90) {
            err += "Invalid Latitude 1";
        }
    }

    if (t_lng1 == '' || isNaN(t_lng1)) {
        err += "\nInvalid Longitude 1";

    } else {
        lng1 = parseFloat(t_lng1);
        if (lng1 < -180 || lng1 > 180) {
            err += "\nInvalid Longitude 1";
        }
    }


    if (t_lat2 == '' || isNaN(t_lat2)) {
        err += "\nInvalid Latitude 2";
    } else {
        lat2 = parseFloat(t_lat2);
        if (lat2 < -90 || lat2 > 90) {
            err += "\nInvalid Latitude 2";
        }
    }

    if (t_lng2 == '' || isNaN(t_lng2)) {
        err += "\nInvalid Longitude 2";

    } else {
        lng2 = parseFloat(t_lng2);
        if (lng2 < -180 || lng2 > 180) {
            err += "\nInvalid Longitude 2";
        }
    }

    if (err != '') {
        alert(err);
        return;
    }
    $.fancybox.close();


    if (distMarker1)
        map.removeLayer(distMarker1);
    if (distMarker2)
        map.removeLayer(distMarker2);
    if (distLine)
        map.removeLayer(distLine);

    distMarker1 = E$.marker([lat1, lng1] , { icon: E$.icon({ iconUrl: "images/icons/marker.png", iconAnchor: [16, 32]}),title:"1. "+lat1+","+lng1 });
    map.addLayer(distMarker1);

    distMarker2 = E$.marker([lat2, lng2], { icon: E$.icon({ iconUrl: "images/icons/marker.png", iconAnchor: [16, 32] }), title: "2. " + lat2 + "," + lng2 });
    map.addLayer(distMarker2);
    var latlngs=[];
    latlngs.push([lat1, lng1]);
    latlngs.push([lat2, lng2]);

    distLine = createMLine(latlngs);
    map.addLayer(distLine);

    var popCenter = [(lat1 + lat2) / 2, (lng1 + lng2) / 2];
    var content = "<div>" + formatDist(calDist(distLine.getLatLngs())) + "</div>";
    setTimeout(function () {
        infoPopup = E$.popup({ offset: [0, 0], autoPanPadding: [10, 80], closeOnClick: false });
        infoPopup.setLatLng(popCenter);
        infoPopup.setContent(content);
        infoPopup.on("close", function (e) {
            //resetMeasure();
        });
        infoPopup.openOn(map);
        //dispPopwUnit();
    }, 200);

    setTimeout(function () {
        map.fitBounds(distLine.getBounds(), { padding: [100, 100] });
    }, 200);
}