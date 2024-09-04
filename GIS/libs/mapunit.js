var PosFormat = new Object();
PosFormat.Dec = 1;
PosFormat.Deg = 2;
PosFormat.UTM = 3;
var MeaFormat = new Object();
MeaFormat.Met = 1;
MeaFormat.Ft = 2;

var AreaFormat = new Object();
AreaFormat.Met = 1;
AreaFormat.Ft = 2;
AreaFormat.Rai = 3;

var posFormat = PosFormat.Dec;
var meaFormat = MeaFormat.Met;
var areaFormat = AreaFormat.Met;

function formatDist(dist, fixed) {
    if (!fixed)
        fixed = 0;
   if(meaFormat==MeaFormat.Met){
       if (dist < 1000) {
            return parseFloat(dist).toFixed(fixed) + "&nbsp;m";
        } else {
            return numberWithCommas(dist / 1000,3) + "&nbsp;km";
        }
   } else if(meaFormat==MeaFormat.Ft){
        var ft = dist*3.28084;
        if(ft<5280)
            return parseFloat(ft).toFixed(fixed) + "&nbsp;ft";
        else
            return numberWithCommas(ft / 5280, 3) + "&nbsp;miles";
   }
}
function formatArea(area) {
    if (areaFormat == AreaFormat.Met) {
        if (area < 100000) {
            return parseInt(area) + "&nbsp;sq.m";
        } else {
            return numberWithCommas(area / 1000000, 3) + "&nbsp;sq.km";
        }
    } else if (areaFormat == MeaFormat.Ft) {
        var sqft = area * 10.764;
        if (sqft < 27878400)
            return parseInt(sqft) + "&nbsp;sq.ft";
        else
            return numberWithCommas(sqft / 27878400, 3) + "&nbsp;sq.miles";
    }
    else if (areaFormat == AreaFormat.Rai) {
        var rai_d= area / 1600;
        var rai = Math.floor(rai_d);
        var ngan = Math.floor((rai_d - rai) * 4)
        var wa = Math.round((((rai_d - rai) * 4) - ngan) * 100);

        return rai + "-" + ngan + "-" + wa + "<br />ไร่-งาน-ตรว.";
    }
}

function numberWithCommas(x,fixed) {
    var parts = x.toFixed(fixed).split(".");
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

function calCirPoint(latlng,r) {
    var utm = new $UTM();
    var Latitud = utm.DegToRad(latlng.lat);
    var Longitud = utm.DegToRad(latlng.lng);
    var rll = [];
    rll.push(latlng);
    var d_rad = (r / 6378137);

    for (var j = 0; j <= 360; j+=90){
        var radial = (Math.PI*j) / 180;
        var lat_rad = Math.asin((Math.sin(Latitud) * Math.cos(d_rad)) + (Math.cos(Latitud) * Math.sin(d_rad) * Math.cos(radial)));
        var dlon_rad = Math.atan2(Math.sin(radial) * Math.sin(d_rad) * Math.cos(Latitud), Math.cos(d_rad) - Math.sin(Latitud) * Math.sin(lat_rad));
        var lon_rad = ((Longitud + dlon_rad + Math.PI) %( 2 * Math.PI)) - Math.PI;
        rll.push([utm.RadToDeg(lat_rad),utm.RadToDeg(lon_rad)]);
     }
     return rll;
 }

 function getScale() {
     var dpi = $("#dpi-test").width();
     var r = 6378137;
     var z = map.getZoom();
     var lat = map.getCenter().lat;
     var mapWidth = 256 * Math.pow(2, z);

     var s = dpi * Math.cos(lat * Math.PI / 180) * 2 * Math.PI * r / mapWidth / 0.0254;

     if (s > 1000000)
         s = (s / 1000000).toFixed(0) + "M";
     else
         s = numberWithCommas(parseInt(s),0);
     return "SCALE 1:" + s;
 }
 function convertDDToDMS(dd) {
     var deg = dd | 0; // truncate dd to get degrees
     var frac = Math.abs(dd - deg); // get fractional part
     var min = (frac * 60) | 0; // multiply fraction by 60 and truncate
     var sec = frac * 3600 - min * 60;
     return deg + "&deg; " + min + "' " + sec.toFixed(4) + "\"";

 }