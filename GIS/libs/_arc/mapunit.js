function formatDist(dist) {
    if (dist < 1000) {
        return parseInt(dist) + " m";
    } else {
        return numberWithCommas(dist / 1000) + " km";
    }
}
function formatArea(area) {
    if (area < 100000) {
        return parseInt(area) + " sq.m";
    } else {
        return numberWithCommas(area / 1000000) + " sq.km";
    }
}

function numberWithCommas(x) {
    
    var parts = x.toFixed(3).split(".");
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return parts.join(".");
}

function degreeFormat(x) {
    return parseFloat(x).toFixed(6);

}

function calDist(latlngs) {
    var dist = 0;
    for (var i = 1; i < latlngs.length; i++) {
        dist += latlngs[i].distanceTo(latlngs[i - 1]);
    }
    return dist;
}

function calArea(latlngs) {
    if (latlngs.length < 3) return;
    var utm = new $UTM();
    var xys = [];
    var zone = Math.floor((latlngs[0].lng + 180.0) / 6) + 1;
    for (var i = 0; i < latlngs.length; i++) {
        var xy = new Array();
        utm.LatLonToUTMXY(latlngs[i].lat, latlngs[i].lng, zone, xy);
        xys.push(xy);
    }
    var i, j, k;
    var xy0 = xys[0];
    var xy1 = xys[1];
    var xyn = xys[xys.length - 1];
    var area = xy0[0] * (xy1[1] - xyn[1]);
    for (i = 1, j = 2, k = 0; i <= xys.length - 2; i++, j++, k++) {
        var xyi = xys[i];
        var xyj = xys[j];
        var xyk = xys[k];
        area += xyi[0] * (xyj[1] - xyk[1]);
    }
    var xyn2 = xys[xys.length - 2];
    area += (xyn[0] * (xy0[1] - xyn2[1]));
    return Math.abs(area / 2);
}