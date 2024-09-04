var ToolMode = new Object();
ToolMode.pan = 1;
ToolMode.zoom = 2;
ToolMode.mdist = 3;
ToolMode.marea = 4;
ToolMode.mcir = 5;
ToolMode.pin = 6;
ToolMode.line = 7;
ToolMode.shape = 8;
ToolMode.cir = 9;
ToolMode.los = 10;
ToolMode.aos = 11;
ToolMode.hst = 12;
ToolMode.info = 13;
ToolMode.schl = 14;
ToolMode.prop = 15;
ToolMode.deep = 16;
ToolMode.df = 17;

var LangMode = new Object();
LangMode.TH = 1;
LangMode.EN = 2;

var AdmMode = new Object();
AdmMode.Adm = 1;
AdmMode.Usr = 2;

var mapToolMode = ToolMode.pan;
var langMode = LangMode.TH;
var infoPopup = null;
var toolObject = null;
var toolObject2 = null;
var toolDotArray = [];
var isEndMeasure = false;
var timePosition = null;
var lastPosition = null;
var geoloc_marker=null;
var goto_marker=null;
var _losData=null;
var poiArray_Added=[];
var direction_marker=null;
var event_marker=null;

function mapDispPosition(e) {
    if (timePosition)
        clearTimeout(timePosition);
        timePosition = setTimeout(function () {
        if (e) {
            if (posFormat == PosFormat.Dec) {
                parent.$("#posbar").html("LAT " + degreeFormat(e.latlng.lat) + "  &nbsp; LONG " + degreeFormat(e.latlng.lng) + " &nbsp; " + getScale());
            } else if (posFormat == PosFormat.Deg) {
                parent.$("#posbar").html("LAT " + convertDDToDMS(e.latlng.lat) + "  &nbsp; LONG " + convertDDToDMS(e.latlng.lng) + " &nbsp; " + getScale());
            } else if (posFormat == PosFormat.UTM) {
                var utm = new $UTM();
                var xy = [];
                var zone = Math.floor((e.latlng.lng + 180.0) / 6) + 1;
                utm.LatLonToUTMXY(e.latlng.lat, e.latlng.lng, zone, xy);
                parent.$("#posbar").html("X " + xy[0].toFixed(0) + "  &nbsp; Y " + xy[1].toFixed(0) + "  &nbsp; ZONE " + zone + " &nbsp; " + getScale());
            }
            parent.$("#posbar").show();
        } else {
            parent.$("#posbar").html("");
            parent.$("#posbar").hide();
             if(parent.$(".afms-sec-maptools"))
                parent.$(".afms-mappanel").css("margin-top", parent.$(".afms-sec-maptools").height() + "px");
        }
    }, 300);
}
function createMLine(latlngs) {
    return E$.polyline(latlngs, { color: "#00f", weight: 3, opacity: 0.7, clickable: false });
}
function createLLine(latlngs) {
    return E$.polyline(latlngs, { color: "#0c0", weight: 3, opacity: 0.7, clickable: false });
}
function createACir(latlng) {
    return E$.circle(latlng, 0, { color: "#0c0", weight: 3, opacity: 0.7, fillColor: "#0c0", fillOpacity: 0.1, clickable: false });
}
function createHRect(bounds) {
    return E$.rectangle(bounds, { color: "#0c0", weight: 3, opacity: 0.7, fillColor: "#0c0", fillOpacity: 0.1, clickable: false });
}
function createMPolygon(latlngs) {
    return E$.polygon(latlngs, { color: "#00f", weight: 3, opacity: 0.7, fillColor: "#00f", fillOpacity: 0.2, clickable: false });
}
function createMCir(latlng) {
    return E$.circle(latlng,0, { color: "#00f", weight: 3, opacity: 0.7, fillColor: "#00f", fillOpacity: 0.2, clickable: false });
}
function getDistance(latlngs) {
    var dist = 0;
    for (var i = 1; i < latlngs.length; i++) {
        dist += latlngs[i].distanceTo(latlngs[i - 1]);
    }
    return dist;
}
function addPOIDone(poiid, lyid, tab,addmode) {
    /*placechkLayers.push(poiid);
    setPlaceTab();
    if (poiid > 0) {
        selectPoiID_afterload=poiid;
    }*/
    
    if (!poiid) {
             
        } else {
            if(poiid<0){
               for (var i = poiArray_Added.length-1; i >=0; i--) {
                    var poi = poiArray_Added[i];
                    
                    if (poi && poi.poiid && poi.poiid == -poiid) {
                         if(selectedPoi && selectedPoi.poiid==poi.poiid){
                            for (var j = 0; j < dotArray.length; j++) {
                                map.removeLayer(dotArray[j]);
                            }
                        }
                        map.removeLayer(poi);
                        poiArray_Added.splice(i, 1);

                    }
                }
                if(selectedPoi)
                    map.removeLayer(selectedPoi);
            }else{
                selectPoiID_afterload = poiid;
                if(addmode=="add")
                    getPOIAdded(poiid,1,0);
                else
                    selectPoi(tab, poiid,1,0);
            }
        }

    closeInfoPopup();
    
}

function getPOIAdded(poiid,pan,noinfo){
    //window.open("data/dPoiGet.ashx?poiid="+poiid);
    $.ajax({
        type: 'POST',
        url: "data/dPoiGet.ashx",
        data: {
            poiid: poiid
        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            if (data.result == "ERR") {

            } else if (data.result == "OK") {
                
                for (var i = 0; i < data.datas.length; i++) {
                    var poi = data.datas[i];
                    var marker = createMarker(poi);
                    if (!marker) continue;
                    marker.on('click', function (e) {
                        selectPoi('added', e.target.poiid);
                    });
                    marker.addTo(map);
                    poiArray_Added.push(marker);
                }
                if (selectPoiID_afterload > 0) {
                    selectPoi('added', selectPoiID_afterload,pan,noinfo);
                    selectPoiID_afterload = 0;
                }
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });
}

var _deep_dt = null;
function loadLOS(mode,dt){
    if(dt) 
        _deep_dt=dt;

     var fnm = "Los.ashx";
      /*  if(mode == ToolMode.deep){
            fnm = "Deep.ashx";
            $("#los-disp .ptitle").html("Cross section");
        }else{
            $("#los-disp .ptitle").html("Line of sight");
        }*/
    var latlngs = toolObject.getLatLngs();
        var points = "";
        for (var i = 0; i < latlngs.length; i++) {
            if (i > 0) {
                if (latlngs[i].lng == latlngs[i - 1].lng && latlngs[i].lat == latlngs[i - 1].lat)
                    continue;
            }
            if (points != "") points += ",";
            points += degreeFormat(latlngs[i].lng) + ',' + degreeFormat(latlngs[i].lat);
        }
    $("#los-t-3").show();
    $("#los-t-3").click();
    $("#los-disp_content1").html("<div style='float:right;margin:2px 212px'><div id='mov_pos' style='width:200px;position:absolute;border:1px solid #000;background:#ffc;display:none;padding:4px'></div></div>&nbsp;From : " + degreeFormat(latlngs[0].lng) + "," + degreeFormat(latlngs[0].lat) + " To : " + degreeFormat(latlngs[latlngs.length - 1].lng) + "," + degreeFormat(latlngs[latlngs.length - 1].lat)+"<span id=deepDt></span>");
    $("#los-disp_content1").append("<div id=los-loading style='text-align:center'><br /><br /><img src='images/loading.gif' /></div>");
    $("#los-disp_content1").append("<br /><img id=los-img width='" + $("#los-disp_content1").width() + " height='" + $("#los-disp_content1").height() + "' />");
    $('#los-img').attr('src', 'data/i'+fnm+'?points='+points+'&w=' + $("#los-disp_content1").width() + "&h=" + $("#los-disp_content1").height()+(_deep_dt?"&dt="+_deep_dt:""));
    $('#los-img').bind('load', function () {
        $("#los-loading").hide();

        $.ajax({
            type: 'POST',
            url: 'data/d'+fnm+'?points='+points+'&w=' + $("#los-disp_content1").width() + "&h=" + $("#los-disp_content1").height()+(_deep_dt?"&dt="+_deep_dt:""),
            cache: false,
            dataType: 'json',
            success: function (data) {
                if (data.result == "ERR") {

                } else if (data.result == "OK") {
                    _losData=data.datas;
                    if(mode==ToolMode.deep){
                        var deepCal = "<input type=text id=inp_dtDp runat=server readonly=readonly style='width:80px' onclick=\"if(self.gfPop)gfPop.fPopCalendar(document.getElementById('inp_dtDp'));return false;\" />";
                        deepCal+="<a href=\"javascript:void(0)\" onclick=\"if(self.gfPop)gfPop.fPopCalendar(document.getElementById('inp_dtDp'));return false;\" ><img class=\"PopcalTrigger\" align=\"absBottom\" src=\"libs/CalendarTH/calbtn.gif\" width=\"34\" height=\"22\" border=\"0\"></a>";
                        $("#deepDt").html("&nbsp; &nbsp; ข้อมูลวันที่ &nbsp; <select id='sel_dtDp' style='height:20px;display:none' onchange=\"loadLOS("+ToolMode.deep+",this.value)\"></select>"+deepCal);
                        for(var i=0;i<data.dates.length;i++){
                            $("#sel_dtDp").append("<option value='"+data.dates[i]+"'>"+data.dates[i]+"</option>");
                        }
                        
                         $("#sel_dtDp").val(_deep_dt);
                         $("#inp_dtDp").val(_deep_dt?_deep_dt :data.dates[0]);
                         if(self.gfPop){
                            gfPop.gsAction = null;
                            for(var i=0;i<data.dates.length;i++){
                                var dts = data.dates[i].split('/');

                                gfPop.fAddEvent(parseInt(dts[2])-543, parseInt(dts[1]), parseInt(dts[0]), "*", "", "#9999ff", "#0000cc");
                            }
                            
                          }
                    }
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {

            }
        });
        //alert(los_dists.join(','));
        $('#los-img').mouseout(function(e){
            $('#mov_pos').hide();
            map.removeLayer(toolObject2);
            toolObject2=null;
        });
        $('#los-img').mousemove(function(e){
                if(!_losData) return;
                var x = e.pageX - $("#los-img").offset().left;
                var y = e.pageY - $("#los-img").offset().top;
                var maxx= $("#los-disp_content1").width()-20;
                var minx = 50;
                if(x>minx && x<maxx){
                    var z = Math.round((x-minx)*1000.0/((maxx-minx)));
                    z = _losData[z]+" m";
                    var tx=e.pageX+10;
                    var ty=e.pageY-50;
                    if(x+100>maxx)
                        tx-=130;
                    var mdist = los_dist * (x-minx) /(maxx-minx);
                    var lat=0;
                    var lng=0;
                    for(var i=0;i<los_dists.length;i++){
                        if(los_dists[i]>mdist){
                            var dlat = (los_lls[i].lat-los_lls[i-1].lat)/(los_dists[i]-los_dists[i-1])*(mdist-los_dists[i-1]);
                            var dlng = (los_lls[i].lng-los_lls[i-1].lng)/(los_dists[i]-los_dists[i-1])*(mdist-los_dists[i-1]);
                            lat = los_lls[i-1].lat+dlat;
                            lng = los_lls[i-1].lng+dlng;
                            
                            break;
                        }
                    }
                    if(!toolObject2)
                        toolObject2 = E$.marker([lat,lng], { icon:
                        E$.icon({ iconUrl: "images/icons/x.png", iconAnchor: [6, 6] }),
                        clickable: false
                    }).addTo(map);
                    else
                        toolObject2.setLatLng([lat,lng]);
                    
                    $('#mov_pos').show();
                    var hstr = "";
                    if(mode == ToolMode.deep)
                        hstr = "Depths : "+z.replace('-','');
                    else
                        hstr = "Height : "+z;
                    $('#mov_pos').html("Lat: " + degreeFormat(lat) + " Long: " + degreeFormat(lng)+"<br />Distance: "+formatDist(mdist,1)+" "+hstr+"<br />"); 
                
                    //$("#mov_pos").offset({left:tx,top:ty});
                }else{
                    $('#mov_pos').hide();
                    map.removeLayer(toolObject2);
                    toolObject2=null;
                }
           
        });
    });
    var los_dist = calDist(toolObject.getLatLngs());
    var los_dists = [];
    var los_lls = toolObject.getLatLngs();
    los_dists.push(0);
    for(var i=1;i<los_lls.length;i++){
        var los_llsj=[];
        for(var j=0;j<=i;j++){
            los_llsj.push(los_lls[j]);
        }
        los_dists.push(calDist(los_llsj));
    }

    
}
//3//
function endMeasure(e) {
    if (isEndMeasure) return;
    isEndMeasure = true;
    var offset = -10;
    var content = "";
    var popCenter = e.latlng;
    for (var i = 0; i < toolDotArray.length; i++) {
        toolDotArray[i].off("mousedown");
        toolDotArray[i].off("dblclick");
    }
    if (mapToolMode == ToolMode.mdist) {
        content = "<div id='popDisp'></div><div id='popCfg'>dist:" + calDist(toolObject.getLatLngs()) + "</div>";
        //content = formatDist(calDist(toolObject.getLatLngs()));
    }
    else if (mapToolMode == ToolMode.marea) {
        //content = formatArea(calArea(toolObject.getLatLngs()));
        content = "<div id='popDisp'></div><div id='popCfg'>area:" + calArea(toolObject.getLatLngs()) + "</div>";
    }
    else if (mapToolMode == ToolMode.mcir) {
        popCenter = toolObject.getLatLng();
        var r = toolObject.getRadius();
        //content = "radius : " + formatDist(r) + "<br />area : " + formatArea(Math.PI * r * r);
        content = "<div id='popDisp' class=popDisp100></div><div id='popCfg'>radius:" + r + "</div>";
    }
    else if (mapToolMode == ToolMode.pin) {
        content = "<iframe id=addPOIFrame width=300 height=300 frameborder=0 src='data/addpoi.aspx?poitype=1&poiid=0&typeid=" + _selected_TypeID + "&lyid=" + _selected_LyID + "' />";
        offset = -32;
    }
    else if (mapToolMode == ToolMode.line || mapToolMode == ToolMode.shape || mapToolMode == ToolMode.cir) {
        var ptype = 2;
        if (mapToolMode == ToolMode.line) {
            ptype = 2;
            toolObject.dist = calDist(toolObject.getLatLngs());
        }
        if (mapToolMode == ToolMode.shape) {
            ptype = 3;
            toolObject.area = calArea(toolObject.getLatLngs());
        }
        if (mapToolMode == ToolMode.cir) {
            ptype = 4;
            toolObject.area = Math.PI * toolObject.getRadius() * toolObject.getRadius();
        }

        content = "<iframe id=addPOIFrame width=300 height=300 frameborder=0 src='data/addpoi.aspx?poitype=" + ptype + "&poiid=0&typeid=" + _selected_TypeID + "&lyid=" + _selected_LyID + "' />";
    }
    
    if (mapToolMode == ToolMode.cir || mapToolMode==ToolMode.aos) {
        popCenter = toolObject.getLatLng();
        if (mapToolMode == ToolMode.aos) {
            content = "<div id='popInfo'><div style='text-align:center'><img src='images/loading.gif' /></div></div>";
            var bound = toolObject.getBounds();
            map.fitBounds(bound);

            if (toolObject)
                map.removeLayer(toolObject);
            
            var imageUrl = "data/iAOS.ashx?lat=" + popCenter.lat +
                    "&lng=" + popCenter.lng+
                    "&lat1=" + bound.getSouthWest().lat +
                    "&lng1=" + bound.getSouthWest().lng +
                    "&lat2=" + bound.getNorthEast().lat +
                    "&lng2=" + bound.getNorthEast().lng +
                    "&r=" + toolObject.getRadius();

            toolObject = E$.imageOverlay(imageUrl, bound, {opacity:0.5});
            toolObject.addTo(map);

            setTimeout(function () {
                infoPopup.off("close");
                closeInfoPopup();
            }, 1000);

           /* window.open("data/iAOS.ashx?lat=" + popCenter.lat +
                    "&lng=" + popCenter.lng+
                    "&lat1=" + bound.getSouthWest().lat +
                    "&lng1=" + bound.getSouthWest().lng +
                    "&lat2=" + bound.getNorthEast().lat +
                    "&lng2=" + bound.getNorthEast().lng +
                    "&r=" + toolObject.getRadius());
            */
            
        }
    }
    if (mapToolMode == ToolMode.los || mapToolMode == ToolMode.deep) {
        var mode = mapToolMode;
        mapToolMode = ToolMode.pan;
        resetCursor();
        $("#bToolPan").addClass("selected");
        closeInfoPopup();
        setTimeout(function(){
            map.fitBounds(toolObject.getBounds(),{ padding: [100, 100] });
        },200);
        $("#los-disp").show();
        
        setWindowSize();
        loadLOS(mode);

        return;
    }
    if (mapToolMode == ToolMode.hst) {
        content = "<div id='popInfo' style='min-height:80px'><div style='text-align:center'><img src='images/loading.gif' /></div></div>";
        popCenter = toolObject.getBounds().getCenter();
        offset = 0;
        map.fitBounds(toolObject.getBounds());
        $.ajax({
            type: 'POST',
            url: "data/iHST.ashx",
            data: {
                lat1: toolObject.getBounds().getSouthWest().lat,
                lng1: toolObject.getBounds().getSouthWest().lng,
                lat2: toolObject.getBounds().getNorthEast().lat,
                lng2: toolObject.getBounds().getNorthEast().lng
            },
            cache: false,
            dataType: 'json',
            success: function (data) {
                if (data.result == "ERR") {

                } else if (data.result == "OK") {
                    setTimeout(function(){
                        if (!infoPopup) {
                            infoPopup = E$.popup({ offset: [0, 0], autoPanPadding: [10, 80], closeOnClick: false });
                            infoPopup.setLatLng(popCenter);
                            infoPopup.setContent(content);
                            infoPopup.on("close", function (e) {
                                resetMeasure();
                            });
                            infoPopup.openOn(map);
                        }
                        infoPopup.setLatLng([data.datas.Y, data.datas.X]);
                        //$("#popInfo").html("Highest Point<br /> LAT : " + degreeFormat(data.datas.Y) + "<br />" + "LONG : " + degreeFormat(data.datas.X) + "<br />" + "HEIGHT : " + data.datas.Z + " m.");
                        $("#popInfo").html("Highest Point<div id=popDisp></div><div id=popCfg>info:" + data.datas.Y + "," + data.datas.X + "," + data.datas.Z + "</div>");
                        dispPopwUnit();
                    },300);
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {

            }
        });
    }
    if (mapToolMode == ToolMode.schl) {
        mapToolMode = ToolMode.pan;
        resetCursor();
        $("#bToolPan").addClass("selected");
        closeInfoPopup();
        return;
    }
   
    //Prop
    if (mapToolMode == ToolMode.prop) {
        toolObject.area = calArea(toolObject.getLatLngs());
        mapToolMode = ToolMode.pan;
        resetCursor();
        $("#bToolPan").addClass("selected");
        closeInfoPopup();
        editPropShape();
        return;
    }

    mapToolMode = ToolMode.pan;
    resetCursor();
    $("#bToolPan").addClass("selected");



    
    
    //
    //if (mapToolMode == ToolMode.mdist || mapToolMode == ToolMode.marea || mapToolMode == ToolMode.mcir) {
    setTimeout(function () {
        infoPopup = E$.popup({ offset: [0, offset], autoPanPadding: [10, 80], closeOnClick: false });
        infoPopup.setLatLng(popCenter);
        infoPopup.setContent(content);
        infoPopup.on("close", function (e) {
            resetMeasure();
        });
        infoPopup.openOn(map);
         dispPopwUnit();
    }, 200);
    //}
}

function onSelectDate(ctl){
    
    loadLOS(ToolMode.deep,document.getElementById("inp_dtDp").value);
}

function dispPopwUnit(){
    var cfg = $("#popCfg").html();
    if (!cfg) return;
    var cfgs = cfg.split(':');
    if (cfgs[0] == "dist") {
        $("#popDisp").html(formatDist(parseFloat(cfgs[1])));
    } else if (cfgs[0] == "area") {
        $("#popDisp").html(formatArea(parseFloat(cfgs[1])));
    } else if (cfgs[0] == "radius") {
        var r = parseFloat(cfgs[1]);
        
        $("#popDisp").html("radius :" + formatDist(r) + "<br />area : " + formatArea(Math.PI * r * r));
    } else if (cfgs[0] == "info") {
        var infos = cfgs[1].split(',');
        var lat = parseFloat(infos[0]);
        var lng = parseFloat(infos[1]);
        var h = parseFloat(infos[2]);
        if (posFormat == PosFormat.Dec) {
                $("#popDisp").html("LAT : " +  degreeFormat(lat) + "<br />LONG : " + degreeFormat(lng) + "<br />HEIGHT : " + formatDist(h,2));
            } else if (posFormat == PosFormat.Deg) {
                $("#popDisp").html("LAT : " +  convertDDToDMS(lat) + "<br />LONG : " + convertDDToDMS(lng) + "<br />HEIGHT : " + formatDist(h,2));
            } else if (posFormat == PosFormat.UTM) {
                var utm = new $UTM();
                var xy = [];
                var zone = Math.floor((lng + 180.0) / 6) + 1;
                utm.LatLonToUTMXY(lat, lng, zone, xy);
                $("#popDisp").html("X : " + xy[0].toFixed(0) + "<br />Y : " + xy[1].toFixed(0) + "<br />ZONE : " + zone + "<br />HEIGHT : " + formatDist(h,2));
            }
    }
}

function resetMeasure() {
    if (toolObject) {
        map.removeLayer(toolObject);
    }
    if (toolObject2) {
        map.removeLayer(toolObject2);
    }
    if (toolDotArray && toolDotArray.length > 0) {
        for (var i = 0; i < toolDotArray.length; i++) {
            map.removeLayer(toolDotArray[i]);
        }
    }
    toolDotArray = [];
    toolObject = null;
    toolObject2 = null;
    _losData=null;
}
//1//
function mapOnclick(e) {
    if (mapToolMode == ToolMode.los || mapToolMode == ToolMode.mdist || mapToolMode == ToolMode.marea || mapToolMode == ToolMode.line || mapToolMode == ToolMode.shape || mapToolMode == ToolMode.prop || mapToolMode == ToolMode.deep) {
        for (var i = 0; i < toolDotArray.length; i++) {
            toolDotArray[i].off("mousedown");
            //toolDotArray[i].off("dblclick");
        }
        var dot = E$.marker(e.latlng, { icon: E$.divIcon({ className: 'dot-icon', iconAnchor: [4, 4] }) }).addTo(map);
        dot.on('mousedown', function (e) {
            endMeasure(e);
        });
        dot.on('dblclick', function (e) {
            endMeasure(e);
        });
        dot.idx = toolDotArray.length;
        toolDotArray.push(dot);
        var latlngs = [];
        for (var i = 0; i < toolDotArray.length; i++) {
            latlngs.push(toolDotArray[i].getLatLng());
        }
        if (latlngs.length > 1) {
            if (!toolObject) {
                if (mapToolMode == ToolMode.mdist || mapToolMode == ToolMode.line  || mapToolMode == ToolMode.deep)
                    toolObject = createMLine(latlngs);
                else if (mapToolMode == ToolMode.los)
                    toolObject = createLLine(latlngs);
                 else
                    toolObject = createMPolygon(latlngs);
               
               toolObject.addTo(map)
            }
            else {
                toolObject.setLatLngs(latlngs);
            }
        }
    }
    if (mapToolMode == ToolMode.mcir || mapToolMode == ToolMode.cir || mapToolMode == ToolMode.aos) {
        if (!toolObject) {
            if (mapToolMode == ToolMode.aos )
                toolObject = createACir(e.latlng);
            else
                toolObject = createMCir(e.latlng);
            toolObject.addTo(map)

            var dot = E$.marker(e.latlng, { icon: E$.divIcon({ className: 'dot-icon',iconAnchor:[4,4]}) }).addTo(map);
            toolDotArray.push(dot);
            dot.addTo(map);

        } else {
            endMeasure(e);
        }
    }
    if (mapToolMode == ToolMode.hst) {
        if (!toolObject) {
            toolObject = createHRect([e.latlng, e.latlng]);
            toolObject.addTo(map)
        } else {
            endMeasure(e);
        }
    }
    if (mapToolMode == ToolMode.pin) {
        if (!toolObject) {
            toolObject = E$.marker(e.latlng, { icon:
                E$.icon({ iconUrl: "images/icons/marker.png", iconAnchor: [16, 32] }),
                clickable: false
            }).addTo(map);
        } else {
            toolObject.setIcon(E$.icon({ iconUrl: "images/icons/marker.png", iconAnchor: new E$.Point(16, 32) }));
            toolObject.setLatLng(e.latlng);
        }
        endMeasure(e);
    }
    if (mapToolMode == ToolMode.info) {
        setTimeout(function () {
            if (mapToolMode != ToolMode.info) return;
            resetCursor();
            $("#bToolPan").addClass("selected");
            mapToolMode = ToolMode.pan;
            infoPopup = E$.popup({ offset: [0, 0], autoPanPadding: [10, 80], closeOnClick: false });
            infoPopup.setLatLng(e.latlng);
            infoPopup.setContent("<div id='popInfo'><div style='text-align:center'><img src='images/loading.gif' /></div></div>");
            infoPopup.on("close", function (e) {
                //resetMeasure();
            });
            infoPopup.openOn(map);

            $.ajax({
                type: 'POST',
                url: "data/iALT.ashx",
                data: {
                    lat: e.latlng.lat,
                    lng: e.latlng.lng
                },
                cache: false,
                dataType: 'json',
                success: function (data) {
                    if (data.result == "ERR") {

                    } else if (data.result == "OK") {
                        $("#popInfo").html("<div id=popDisp></div><div id=popCfg>info:" + data.datas.Y + "," + data.datas.X + "," + data.datas.Z + "</div>");
                        dispPopwUnit();
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }
            });

        }, 200);
    }

    if (mapToolMode == ToolMode.schl) {
        if (!schObject) {
            schObject = createACir(e.latlng);
            schObject.addTo(map)
         } else {
                endMeasure(e);
        }
    }

    copMapClick(e);
}

///2///
function mapOnMousemove(e) {
    if (mapToolMode == ToolMode.los || mapToolMode == ToolMode.mdist || mapToolMode == ToolMode.marea || mapToolMode == ToolMode.line || mapToolMode == ToolMode.shape|| mapToolMode == ToolMode.prop || mapToolMode == ToolMode.deep) {
        if (!infoPopup) {
            infoPopup = E$.popup({ offset: new E$.Point(0, -10), closeOnClick: false });
        }
        if (toolDotArray.length > 0) {

            var latlngs = [];
            for (var i = 0; i < toolDotArray.length; i++) {
                latlngs.push(toolDotArray[i].getLatLng());
            }
            latlngs.push(e.latlng);


            if (!toolObject) {
                if (mapToolMode == ToolMode.mdist || mapToolMode == ToolMode.line  || mapToolMode == ToolMode.deep)
                    toolObject = createMLine(latlngs);
                else if (mapToolMode == ToolMode.los)
                    toolObject = createLLine(latlngs);
                else
                    toolObject = createMPolygon(latlngs);

                toolObject.addTo(map)
            } else {
                toolObject.setLatLngs(latlngs);
            }
            infoPopup.setLatLng(e.latlng);
            if (mapToolMode == ToolMode.los || mapToolMode == ToolMode.mdist || mapToolMode == ToolMode.line || mapToolMode == ToolMode.deep) {
                infoPopup.setContent("<div class=popDisp>" + formatDist(calDist(latlngs)) + "</div>");
            } else if (latlngs.length > 2) {
                infoPopup.setContent("<div class=popDisp>" + formatArea(calArea(latlngs)) + "</div>");
            } else {
                return;
            }
            infoPopup.openOn(map);
        }
    }
    if (mapToolMode == ToolMode.mcir || mapToolMode == ToolMode.cir || mapToolMode == ToolMode.aos) {
        if (toolObject) {
            var r = e.latlng.distanceTo(toolObject.getLatLng());
            toolObject.setRadius(r);
            if (!infoPopup) {
                infoPopup = E$.popup({ offset: new E$.Point(0, -4), closeOnClick: false });
            }
            infoPopup.setLatLng(toolObject.getLatLng());
            infoPopup.setContent("<div class=popDisp100>radius : " + formatDist(r) + "<br />area : " + formatArea(Math.PI * r * r)+"</div>");
            infoPopup.openOn(map);
        }
    }
    if (mapToolMode == ToolMode.pin) {
        if (!toolObject) {
            toolObject = E$.marker(e.latlng, { icon:
                E$.icon({ iconUrl: "images/icons/marker.png", iconAnchor: new E$.Point(16, 40) }),
                clickable: false
            }).addTo(map);
        } else {
            toolObject.setLatLng(e.latlng);
        }
    }
    if (mapToolMode == ToolMode.hst) {
        if (toolObject) {
            toolObject.setBounds([toolObject.getBounds().getNorthWest(), e.latlng]);
        }
    }
    if (mapToolMode == ToolMode.schl) {
        if (schObject) {
            var r = e.latlng.distanceTo(schObject.getLatLng());
            if (r > 50000)
                r = 50000;
            schObject.setRadius(r);
            parent.$("#Loc_l").val(degreeFormat(schObject.getLatLng().lat) + "," + degreeFormat(schObject.getLatLng().lng));
            parent.$("#Radius_l").val(r.toFixed(0)+"");
            if (!infoPopup) {
                infoPopup = E$.popup({ offset: new E$.Point(0, -4), closeOnClick: false });
            }
            infoPopup.setLatLng(schObject.getLatLng());
            infoPopup.setContent("<div class=popDisp100>radius : " + formatDist(r) + "<br />area : " + formatArea(Math.PI * r * r) + "</div>");
            infoPopup.openOn(map);
        }
    }
}

function addMapToolsControl() {
    map.on('zoomend',function (e){
        parent.$("#posbar").html("");
    });
    map.on('mouseup', function (e) {
        mapOnclick(e);
    });
    map.on('mousemove', function (e) {
        mapOnMousemove(e);
        mapDispPosition(e);
    });
    map.on('mouseout', function (e) {
        mapDispPosition();
    });
    var ToolsControl = E$.Control.extend({
        options: {
            position: 'topleft'
        },

        onAdd: function (map) {
            var controlDiv = E$.DomUtil.get("maptoolctl");
            E$.DomEvent
            .addListener(controlDiv, 'click', L.DomEvent.stopPropagation)
            .addListener(controlDiv, 'click', L.DomEvent.preventDefault)
            .addListener(controlDiv, 'mousedown', L.DomEvent.stopPropagation)
            .addListener(controlDiv, 'mousedown', L.DomEvent.preventDefault)
            .addListener(controlDiv, 'mouseup', L.DomEvent.stopPropagation)
            .addListener(controlDiv, 'mouseup', L.DomEvent.preventDefault);
            return controlDiv;
        }
    });
    
    map.addControl(E$.control.zoom({ position: 'bottomleft' }));
    map.addControl(new ToolsControl());
    parent.$("#bToolPan").addClass("selected");
    parent.$("#bToolPan").bind("click", function () {
         
        //marker.addTo(map);
        //alert(marker);
        resetCursor();
        $(this).addClass("selected");
        mapToolMode = ToolMode.pan;
    });
    parent.$("#bToolZoom").bind("click", function () {
        resetCursor();
        $("#map").addClass("defaultCursor");
        $(this).addClass("selected");
        mapToolMode = ToolMode.zoom;
    });
    parent.$("#bToolmDist").bind("click", function () {
        prepareMeasure();
        $(this).addClass("selected");
        $("#map").addClass("crossCursor");
        mapToolMode = ToolMode.mdist;
    });
    parent.$("#bToolmArea").bind("click", function () {
        prepareMeasure();
        $(this).addClass("selected");
        $("#map").addClass("crossCursor");

        mapToolMode = ToolMode.marea;
    });
    parent.$("#bToolmCir").bind("click", function () {
        prepareMeasure();
        $(this).addClass("selected");
        $("#map").addClass("crossCursor");

        mapToolMode = ToolMode.mcir;
    });
    parent.$("#bToolClr").bind("click", function () {
        prepareMeasure();
        if(geoloc_marker)
            map.removeLayer(geoloc_marker);
        if(goto_marker)
            map.removeLayer(goto_marker);
        if(direction_marker)
            map.removeLayer(direction_marker);

        if(event_marker)
            map.removeLayer(event_marker);

        $("#bToolPan").addClass("selected");


         for (var i = poiArray_Added.length-1; i >=0; i--) {
            var poi = poiArray_Added[i];
            if(selectedPoi && selectedPoi.poiid==poi.poiid){
                for (var i = 0; i < dotArray.length; i++) {
                    map.removeLayer(dotArray[i]);
                }
                 closePOIInfo();
            }
            map.removeLayer(poi);
            
        }
        poiArray_Added=[];
        //$("#info_content").html("");
        //coptools
        copClearTools();
        //
        mapToolMode = ToolMode.pan;
        

    });
    parent.$("#bToolDim").bind("click", function () {
        if (curOpacity==1)
            curOpacity=0.3    
        else
           curOpacity=1;
        curTile.setOpacity(curOpacity);
    });

    parent.$("#bToolLOS").bind("click", function () {
        prepareMeasure();
        $("#bToolLOS").addClass("selected");
        $("#map").addClass("crossCursor");
        mapToolMode = ToolMode.los;
    });
    parent.$("#bToolAOS").bind("click", function () {
        prepareMeasure();
        $("#bToolAOS").addClass("selected");
        $("#map").addClass("crossCursor");
        mapToolMode = ToolMode.aos;
    });
    parent.$("#bToolHst").bind("click", function () {
        prepareMeasure();
        $("#bToolHst").addClass("selected");
        $("#map").addClass("crossCursor");
        mapToolMode = ToolMode.hst;
    });
    parent.$("#bToolInfo").bind("click", function () {
        prepareMeasure();
        $("#bToolInfo").addClass("selected");
        $("#map").addClass("crossCursor");
        mapToolMode = ToolMode.info;
    });
    parent.$("#bToolLoc").bind("click", function () {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
 		        function (position) {
                    if(geoloc_marker)
                        map.removeLayer(geoloc_marker);
 		            geoloc_marker = E$.marker([position.coords.latitude, position.coords.longitude], { icon: E$.icon({ iconUrl: "images/icons/location.png", iconAnchor: [16, 16] }) });
 		            map.addLayer(geoloc_marker);
 		            map.setView([position.coords.latitude, position.coords.longitude], map.getZoom());

 		        },
		        function (error) {

		        }
            );
        }
    });

    parent.$("#bToolDeep").bind("click", function () {
        prepareMeasure();
        $("#bToolDeep").addClass("selected");
        $("#map").addClass("crossCursor");
        mapToolMode = ToolMode.deep;
    });
    //

    $("#bToolPin").bind("click", function () {
        _selected_TypeID = '0';
        clearInputType();
        addToolClick(ToolMode.pin);
    });
    $("#bToolLine").bind("click", function () {
        _selected_TypeID = '0';
        clearInputType();
        addToolClick(ToolMode.line);
    });
    $("#bToolShape").bind("click", function () {
        _selected_TypeID = '0';
        clearInputType();
        addToolClick(ToolMode.shape);
    });
    $("#bToolCir").bind("click", function () {
        _selected_TypeID = '0';
        clearInputType();
        addToolClick(ToolMode.cir);
    });
    parent.$("#bToolPrn").bind("click", function () {
        window.open("Print_map.aspx");
    });
    parent.$("#bToolSet").bind("click", function () {
        var div = "<div style='width:300px;'>";
        div += "<b>Postion format</b><br />";
        div += "&nbsp; &nbsp;<input type=radio name=posformat id='posfDec' " + (posFormat == PosFormat.Dec ? "checked" : "") + " /><label for=posfDec>Decimal (dd.dddddd)</label><br />";
        div += "&nbsp; &nbsp;<input type=radio name=posformat id='posfDeg' " + (posFormat == PosFormat.Deg ? "checked" : "") + "/><label for=posfDeg>Degrees (dd&deg; mm' ss.ssss\")</label><br />";
        div += "&nbsp; &nbsp;<input type=radio name=posformat id='posfUTM' " + (posFormat == PosFormat.UTM ? "checked" : "") + "/><label for=posfUTM>UTM</label><br />";
        div += "</div>";

        div += "<b>Measure unit</b><br />";
        div += "&nbsp; &nbsp;<input type=radio name=meaunit id='unitMet' " + (meaFormat == MeaFormat.Met ? "checked" : "") + "/><label for=unitMet>meters/kilometers</label><br />";
        div += "&nbsp; &nbsp;<input type=radio name=meaunit id='unitFt' " + (meaFormat == MeaFormat.Ft ? "checked" : "") + "/><label for=unitFt>ft./miles</label><br />";
        div += "</div>";

        div += "<b>Area unit</b><br />";
        div += "&nbsp; &nbsp;<input type=radio name=areaunit id='areaMet' " + (areaFormat == AreaFormat.Met ? "checked" : "") + "/><label for=areaMet>sq. meters/kilometers</label><br />";
        div += "&nbsp; &nbsp;<input type=radio name=areaunit id='areaFt' " + (areaFormat == AreaFormat.Ft ? "checked" : "") + "/><label for=areaFt>sq. ft./miles</label><br />";
        div += "&nbsp; &nbsp;<input type=radio name=areaunit id='areaRai' " + (areaFormat == AreaFormat.Rai ? "checked" : "") + "/><label for=areaRai>ไร่-งาน-ตรว.</label><br />";
         div += "<br /><div style='text-align:right'><input type=button value=' OK ' onclick = 'settingConfig()' /> <input type=button value='Cancel' onclick=$.fancybox.close() /></div>";
        div += "</div>";

        $.fancybox(div, {
            'width': 300,
            'height': 300,
            'autoScale': false,
            'transitionIn': 'none',
            'transitionOut': 'none'
        });

    });

    parent.$("#bToolGoto").bind("click", function () {
        var div = "<div style='width:300px;margin:30px'>";
        div += "<b>Goto Location</b> | <a href='javascript:goto_Scale_Box()'>Zoom to Scale</a><br /><br />";
        if(posFormat==PosFormat.Dec){
            div+="<table style='margin-left:20px'>";
            div+="<tr><td>Latitude : <td><td><input id=goto_Dec_Lat type=text style='width:120px'></td></tr>";
            div+="<tr><td>Longitude : <td><td><input id=goto_Dec_Lng type=text style='width:120px'></td></tr>";
            div+="</table>";
        }
        if(posFormat==PosFormat.Deg){
            div+="<table style='margin-left:10px'>";
            div+="<tr><td>Latitude : <td><td><input id=goto_Deg_Lat1 type=text style='width:30px'>&deg;&nbsp; <input id=goto_Deg_Lat2 type=text style='width:30px'>' &nbsp;<input id=goto_Deg_Lat3 type=text style='width:30px'>\" <select id=goto_Deg_Lat_NS style='width:60px'><option value='N'>North</option><option value='S'>South</option></select></td></tr>";
            div+="<tr><td>Longitude : <td><td><input id=goto_Deg_Lng1 type=text style='width:30px'>&deg;&nbsp; <input id=goto_Deg_Lng2 type=text style='width:30px'>' &nbsp;<input id=goto_Deg_Lng3 type=text style='width:30px'>\" <select id=goto_Deg_Lng_EW style='width:60px'><option value='E'>East</option><option value='W'>West</option></select></td></tr>";
            div+="</table>";
        }
        if(posFormat==PosFormat.UTM){
            div+="<table style='margin-left:20px'>";
            div+="<tr><td>X : <td><td><input id=goto_UTM_X type=text style='width:120px'></td></tr>";
            div+="<tr><td>Y : <td><td><input id=goto_UTM_Y type=text style='width:120px'></td></tr>";
            div+="<tr><td>Zone : <td><td><input id=goto_UTM_Zone type=text style='width:120px'></td></tr>";
            div+="<tr><td>Hemisphere : <td><td><select id=goto_UTM_Hemi style='width:120px'><option value='N'>North Lat</option><option value='S'>South Lat</option></select></td></tr>";
            div+="</table>";
        }
        div += "<br /><div style='text-align:right'><input type=button value=' OK ' onclick = 'goto_Location()' /> <input type=button value='Cancel' onclick=$.fancybox.close() /></div>";
     
        div += "</div>";

       
        $.fancybox(div, {
            'width': 350,
            'height': 330,
            'autoScale': false,
            'transitionIn': 'none',
            'transitionOut': 'none'
        });
            
    });
    parent.$("#bTool3D").bind("click", function () {
        location="ebms://token/"+ebms_token;
    });
     parent.$("#bToolFuSc").bind("click", function () {
        toggleFull();
    });


    copAddTools();

    if (!navigator.geolocation) {
        $("#bToolLoc").attr("disabled", "disabled");
        $("#bToolLoc").addClass("but-disabled");
    }
}
function settingConfig() {
    if (document.getElementById('posfDec').checked)
        posFormat = PosFormat.Dec;
    else if (document.getElementById('posfDeg').checked)
        posFormat = PosFormat.Deg;
    else if (document.getElementById('posfUTM').checked)
        posFormat = PosFormat.UTM;

    if (document.getElementById('unitMet').checked)
        meaFormat = MeaFormat.Met;
    else if (document.getElementById('unitFt').checked)
        meaFormat = MeaFormat.Ft;

    if (document.getElementById('areaMet').checked)
        areaFormat = AreaFormat.Met;
    else if (document.getElementById('areaFt').checked)
        areaFormat = AreaFormat.Ft;
    else if (document.getElementById('areaRai').checked)
        areaFormat = AreaFormat.Rai;

    dispPopwUnit();
    $.fancybox.close();
}

function goto_Scale_Box(){
    var div = "<div style='width:300px;margin:30px;'>";
        div += "<a href='javascript:void(0)' onclick='parent.$(\"#bToolGoto\").click()'>Goto Location</a> | <b>Zoom to Scale</b><br /><br />";
        div+="<table style='margin-left:20px'>";
        div+="<tr><td>Scale  &nbsp; 1 : <td><td><input id=goto_Scale_t type=text style='width:120px'></td></tr>";
        div+="</table>";
        div += "<br /><div style='text-align:right'><input type=button value=' OK ' onclick = 'goto_Scale()' /> <input type=button value='Cancel' onclick=$.fancybox.close() /></div>";
     
        div += "</div>";

       
        $.fancybox(div, {
            'width': 300,
            'height': 300,
            'autoScale': false,
            'transitionIn': 'none',
            'transitionOut': 'none'
        });

}
function goto_Scale(){
     var t_scale = $("#goto_Scale_t").val().replace(/,/g, '');
     if(t_scale=='' || isNaN(t_scale)){
        var err = "Invalid Scale";
        alert(err);
        return;
    }
    var scale = parseInt(t_scale);
    for(var i=1;i<20;i++){
        var dpi = $("#dpi-test").width();
         var r = 6378137;
         var lat = map.getCenter().lat;
         var mapWidth = 256 * Math.pow(2, i);

         var s = dpi * Math.cos(lat * Math.PI / 180) * 2 * Math.PI * r / mapWidth / 0.0254;
         if(s<=scale){
            map.setZoom(i);
            $.fancybox.close();
            return;
         }

         map.setZoom(20);
         $.fancybox.close();
    }
     
}
function goto_Location(){
    var lat,lng;
    var err='';
    if(posFormat==PosFormat.Dec){
            var t_lat = $("#goto_Dec_Lat").val();
            var t_lng = $("#goto_Dec_Lng").val();
            if(t_lat=='' || isNaN(t_lat)){
                err += "Invalid Latitude";
             }else{
                 lat = parseFloat(t_lat);
                 if(lat<-90 || lat>90){
                    err += "Invalid Latitude";
                 }
             }
             
             if(t_lng=='' || isNaN(t_lng)){
                err += "\nInvalid Longitude";

             }else{
                 lng = parseFloat(t_lng);
                 if(lng<-180 || lng>180){
                    err += "\nInvalid Longitude";
                 }
             }
        }
        if(posFormat==PosFormat.Deg){
            var t_lat1 = $("#goto_Deg_Lat1").val();
            var t_lat2 = $("#goto_Deg_Lat2").val();
            var t_lat3 = $("#goto_Deg_Lat3").val();
            var t_lng1 = $("#goto_Deg_Lng1").val();
            var t_lng2 = $("#goto_Deg_Lng2").val();
            var t_lng3 = $("#goto_Deg_Lng3").val();
            var t_lat_NS = $("#goto_Deg_Lat_NS").val();
            var t_lng_EW = $("#goto_Deg_Lng_EW").val();

            if(t_lat1=='' || isNaN(t_lat1)|| t_lat2=='' || isNaN(t_lat2) || t_lat3=='' || isNaN(t_lat3)){
                err += "Invalid Latitude";
                }else{
                    lat = parseFloat(t_lat1)+parseFloat(t_lat2)/60+parseFloat(t_lat3)/3600;
                    if(lat<-90 || lat>90){
                    err += "Invalid Latitude";
                    }
                }
             
                if(t_lng1=='' || isNaN(t_lng1)|| t_lng2=='' || isNaN(t_lng2) || t_lng3=='' || isNaN(t_lng3)){
                err += "\nInvalid Longitude";

                }else{
                    lng = parseFloat(t_lng1)+parseFloat(t_lng2)/60+parseFloat(t_lng3)/3600;
                    if(lng<-180 || lng>180){
                        err += "\nInvalid Longitude";
                    }
                }

            if(t_lat_NS=="S")
                lat = -lat;

            if(t_lng_EW=="W")
                lng = -lng;


        }
        
        if(posFormat==PosFormat.UTM){
            var t_x = $("#goto_UTM_X").val();
            var t_y = $("#goto_UTM_Y").val();
            var t_zone = $("#goto_UTM_Zone").val();
            var t_hemi = $("#goto_UTM_Hemi").val();
            var zone = 47;
            if(t_x=='' || isNaN(t_x)){
                err += "Invalid X";
             }
             if(t_y=='' || isNaN(t_y)){
                err += "\nInvalid Y";
             }
             if(t_zone=='' || isNaN(t_zone)){
                err += "\nInvalid Zone";
               
             }else{
                zone = parseInt(t_zone);
                if(zone<1 || zone>60)
                    err += "\nInvalid Zone";
             }
             if(err==''){
                var utm = new $UTM();
                var latlngs = [];
                utm.UTMXYToLatLon(parseFloat(t_x), parseFloat(t_y), zone, t_hemi=="S", latlngs);
                lat = utm.RadToDeg(latlngs[0]);
                lng = utm.RadToDeg(latlngs[1]);
             }
        }
        
        if(err!=''){
                alert(err);
                return;
             }
        $.fancybox.close();

       map.setView([lat,lng],map.getZoom());

        if(goto_marker)
            map.removeLayer(goto_marker);
 		goto_marker = E$.marker([lat, lng], { icon: E$.icon({ iconUrl: "images/icons/target.png", iconAnchor: [16, 16] }) });
 		map.addLayer(goto_marker);
 		
}

function navTools(dx,dy){
    if(dx==0 && dy==0){
        map.setView([13.75,100.5],5);
    }else{
        map.panBy([dx*100,dy*100]);
    }
}

function getMapHtml() {
    return $("#map").html();
}

function addToolClick(mode) {
    var id = "#1";
    if (mode == ToolMode.pin)
        id = "#bToolPin";
    if (mode == ToolMode.line)
        id = "#bToolLine";
    if (mode == ToolMode.shape)
        id = "#bToolShape";
    if (mode == ToolMode.cir)
        id = "#bToolCir";

    prepareMeasure();
    $(id).addClass("selected");
    $("#map").addClass("crossCursor");
    mapToolMode = mode;
}
function closeInfoPopup() {
    if (infoPopup) {
        map.removeLayer(infoPopup);
        infoPopup = null;
    }
}
function prepareMeasure() {
    isEndMeasure = false;
    closeInfoPopup();
    resetCursor();
    resetMeasure();
    $("#los-disp").hide();
    setWindowSize();
}
function resetCursor() {
   parent.$("#bToolPan").removeClass("selected");
   parent.$("#bToolZoom").removeClass("selected");
   parent.$("#bToolmDist").removeClass("selected");
    parent.$("#bToolmArea").removeClass("selected");
    parent.$("#bToolmCir").removeClass("selected");
    parent.$("#bToolPin").removeClass("selected");
    parent.$("#bToolLine").removeClass("selected");
    parent.$("#bToolShape").removeClass("selected");
    parent.$("#bToolCir").removeClass("selected");
    parent.$("#bToolInfo").removeClass("selected");
    parent.$("#bToolLoc").removeClass("selected");
    parent.$("#bToolLOS").removeClass("selected");
    parent.$("#bToolAOS").removeClass("selected");
    parent.$("#bToolHst").removeClass("selected");
    parent.$("#bToolDeep").removeClass("selected");
   
    if($("#map").hasClass("handCursor"))
        $("#map").removeClass("handCursor");
    if($("#map").hasClass("defaultCursor"))
         $("#map").removeClass("defaultCursor");
    if ($("#map").hasClass("crossCursor"))
         $("#map").removeClass("crossCursor");
}
function addMapTypeControl(){
    $("#maptype_map").css("border","2px solid #ff9900");
    setMapTypeToMap($("#maptype_src").html(), "m");
    var MyControl = E$.Control.extend({
        options: {
            position: 'topright'
        },

        onAdd: function (map) {
            /*$("#maptype_src").bind("change", function () {
                setMapTypeToMap($("#maptype_src").val(), curMapType);
            });*/

            $("#maptype_map").bind("click", function () {
                $(this).css("border", "2px solid #ff9900");
                $("#maptype_sat").css("border", "2px solid #ccc");
                $("#maptype_hyb").css("border", "2px solid #ccc");
                setMapTypeToMap($("#maptype_src").html(), "m")
            });
            $("#maptype_sat").bind("click", function () {
                $(this).css("border", "2px solid #ff9900");
                $("#maptype_map").css("border", "2px solid #ccc");
                $("#maptype_hyb").css("border", "2px solid #ccc");
                setMapTypeToMap($("#maptype_src").html(), "s")
            });
            $("#maptype_hyb").bind("click", function () {
                $(this).css("border", "2px solid #ff9900");
                $("#maptype_sat").css("border", "2px solid #ccc");
                $("#maptype_map").css("border", "2px solid #ccc");
                setMapTypeToMap($("#maptype_src").html(), "y")
            });
             var controlDiv = E$.DomUtil.get("maptypectl");
            E$.DomEvent
            .addListener(controlDiv, 'click', L.DomEvent.stopPropagation)
            .addListener(controlDiv, 'click', L.DomEvent.preventDefault);

            return controlDiv;
        }
    });

    map.addControl(new MyControl());
    document.onclick = jsddm_close;

    $('#maptype_src').bind('click', jsddm_open);
}

function resetTools() {
    mapToolMode = ToolMode.pan;
    resetCursor();
    $("#bToolPan").addClass("selected");
}

function bCirSch_click() {
    isEndMeasure = false;
    closeInfoPopup();
    resetCursor();
    if (schObject) {
        map.removeLayer(schObject);
    }
    schObject = null;
    $("#map").addClass("crossCursor");
    mapToolMode = ToolMode.schl;
}
/*MapTypeControl*/
var curTile = null;
var curTile_H = null;
var curMiniTile = null;
var curMiniTile_H = null;
var curMapType = "m";
var miniMap = null;
var curOpacity = 1;
function setMapTypeToMap(src) {
    if (curTile && map.hasLayer(curTile)) {
        map.removeLayer(curTile);
        curTile = null;
    }
    if (curTile_H && map.hasLayer(curTile_H)) {
        map.removeLayer(curTile_H);
        curTile_H = null;
    }
    var url = "";
   
    $("#maptype_src").val(src);
    if (src == "Google Streets" || src == "Google Satellite"  || src == "Google Hybrid") {
        var  mtype = "m";
        if (src == "Google Satellite") mtype = "s";
        if (src == "Google Hybrid") mtype = "y";
      
        url = "http://mt{s}.google.com/vt/lyrs=" + mtype + "&x={x}&y={y}&z={z}";
        curTile = E$.tileLayer(url, { maxZoom: 20, subdomains: '0123',attribution: 'Google'});
        curMiniTile = E$.tileLayer(url, { maxZoom: 13, subdomains: '0123' });
    }
    else if (src == "Bing Road" || src == "Bing Arial"  || src == "Bing Hybrid") {
        var  mtype = "r";
        if (src == "Bing Arial") mtype = "a";
        if (src == "Bing Hybrid") mtype = "h";
        url = "http://" + mtype + "{subdomain}.ortho.tiles.virtualearth.net/tiles/" + mtype + "{quadkey}.png?g=159&shading=hill";
        curTile = E$.bingLayer(url, { maxZoom: 20, subdomains: [0, 1, 2, 3] });
        curMiniTile = E$.bingLayer(url, { maxZoom: 13, subdomains: [0, 1, 2, 3] });
    }
    else if (src == "OSM Map") {
        url = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
        curTile = E$.tileLayer(url, { maxZoom: 20, subdomains: 'a',attribution: 'OpenStreetMap'});
        curMiniTile = E$.tileLayer(url, { maxZoom: 13, subdomains: 'a' });
    }
    

    else if (src == "MRTA Streets") {
        url = "wms/tiles.aspx?layers=MRTA_Street&z={z}&x={x}&y={y}";
        curTile = E$.tileLayer(url, { maxZoom: 20 });
        curMiniTile = E$.tileLayer(url, { maxZoom: 13 });
        
    }
    else if (src == "MRTA Aerial") {
        url = "WMS/tiles.aspx?layers=MRTA_Aerial&z={z}&x={x}&y={y}&f=GM";
        curTile = E$.tileLayer(url, { maxZoom: 19 });
        curMiniTile = E$.tileLayer(url, { maxZoom: 13 });
    }
     else if (src == "MRTA Hybrid") {
        url = "WMS/tiles.aspx?layers=MRTA_Hybrid&z={z}&x={x}&y={y}";
        curTile = E$.tileLayer(url, { maxZoom: 19 });
        curMiniTile = E$.tileLayer(url, { maxZoom: 13 });

        //curTile_H = E$.tileLayer("WMS/gwc.aspx?layers=EBMS_Hybrid&z={z}&x={x}&y={y}", { maxZoom: 20 });
        //curMiniTile_H = E$.tileLayer("WMS/gwc.aspx?layers=MRTA_Hybrid&z={z}&x={x}&y={y}", { maxZoom: 13 });
    }
    

    if (!curTile) return;

    map.addLayer(curTile);
    
    if (curTile_H) {
        map.addLayer(curTile_H);
        curTile_H.bringToBack();
    }
    curTile.bringToBack()
    
    if (miniMap) {
        miniMap.setLayer(curMiniTile);
        if (curMiniTile_H) {
            map.addLayer(curMiniTile_H);
            curMiniTile_H.bringToBack();
        }
        curMiniTile.bringToBack()
    } else {
        miniMap = new L.Control.MiniMap(curMiniTile, { toggleDisplay: true });
        miniMap.addTo(map);
        
    }
}

function jsddm_open() {
    $("#jsddm ul").css('visibility', 'visible');
    $("#jsddm a").css("border","0px");
}

function jsddm_close() {
    $("#jsddm ul").css('visibility', 'hidden');
}

function lang(l){
    langMode = l;
    setMapTypeToMap($("#maptype_src").html());
    if(l==LangMode.TH){
        $("#lang_TH").css("color","black");
        $("#lang_TH").css("font-weight","bold");
        $("#lang_EN").css("color","blue");
        $("#lang_EN").css("font-weight","normal");
    }else{
        $("#lang_EN").css("color","black");
        $("#lang_EN").css("font-weight","bold");
        $("#lang_TH").css("color","blue");
        $("#lang_TH").css("font-weight","normal");
    }
}

//API

var $Api = {
    setCenter: function (lat, lng, zoom) {
        map.setView([lat,lng],zoom);
    },
    setZoom: function (zoom) {
        map.setZoom(zoom);
    },
    zoomIn: function () {
        map.zoomIn();
    },
    zoomOut: function () {
        map.zoomOut();
    },
    addMarker: function (lat,lng,iconurl,bubble_html) {
       var marker = E$.marker([lat,lng], { icon: E$.icon({ iconUrl: iconurl,iconAnchor: [16, 32]})});
       marker.bindPopup(bubble_html,{offset:[0, -32]});
       map.addLayer(marker);
    },
};

//toggle Tools
function toggleTools(){
     if($("#navMapDiv").is(":visible")==true){
        $("#navMapDiv").hide();
        $("#toolMapDiv").hide();
        $("#toolTg img").attr("src","../images/arrow-RR.png");
    }else{
        $("#navMapDiv").show();
        $("#toolMapDiv").show();
        $("#toolTg img").attr("src","../images/arrow-LL.png");
    }
}

function toggleCtl(){
   
    if($("#maptypeDiv").is(":visible")==true){
       $("#maptypeDiv").hide();
        $("#ctlTg img").attr("src","../images/arrow-LL.png");
        $("#ctlTg").css("float","right");
    }else{
        $("#maptypeDiv").show();
       $("#ctlTg img").attr("src","../images/arrow-RR.png");
       $("#ctlTg").css("float","left");
    }
}
//Prop 

function addPropShape(){
    addToolClick(ToolMode.prop);
}
function editPropShape(){
     for (var i = 0; i < toolDotArray.length; i++) {
        toolDotArray[i].dragging.enable();
        toolDotArray[i].on("drag", function (e) {
            var latlng = e.target.getLatLng();
            var latlngs = toolObject.getLatLngs();
            latlngs[e.target.idx] = latlng;
            toolObject.setLatLngs(latlngs);
        });
    }
   
}

function getPropLatLngs(){
    var latlngs = toolObject.getLatLngs();
    var t = "";
    for (var i = 0; i < latlngs.length; i++) {
        if (i > 0) {
            if (latlngs[i].lng == latlngs[i - 1].lng && latlngs[i].lat == latlngs[i - 1].lat)
                continue;
        }
        if (t != "") t += ",";
        t += degreeFormat(latlngs[i].lng) + ',' + degreeFormat(latlngs[i].lat);
    }
    t += ","+degreeFormat(latlngs[0].lng) + ',' + degreeFormat(latlngs[0].lat);

    
    return t;
}
function getPropArea(){
    if(toolObject)
        return calArea(toolObject.getLatLngs());
    return 0;
}


//Flood

var isFloodLayer = false;
var FloodWLv = 0;
function isShowFlood(chk){
    isFloodLayer=chk;
    loadGISTileLayer();
}

//chk

function doCheckToken(){
    $.ajax({
        type: 'POST',
        url: "data/uToken.ashx",
        data: {
            
        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            if(data.result=="OK"){
                var idt = data.datas;
                if(!idt.IsVerify){
                     $.msgBox({ title: "NBTC", content: $("#uFullName").text()+" ถูกใช้งานจากสถานที่อื่น", type: "alert", 
                        buttons: [{ value: "OK" }],
                        success: function (result) {
                              location="../UR/Logout.aspx";
                         }
                    }); 
                    return;
                }
                /*if(idt.WLv>0){
                    
                    if(FloodWLv==0 && idt.WLv>0){
                        FloodWLv = idt.WLv;
                        $.msgBox({ title: "PORT:GIS", content: " แจ้งเตือนน้ำท่วม ระดับน้ำสูง "+FloodWLv+" เมตร", type: "alert", 
                            buttons: [{ value: "ดูข้อมูล" },{ value: "ปิด" }],
                            success: function (result) {
                                if(result=="ดูข้อมูล"){
                                    $("#IsFlood").prop("checked",true);
                                    isShowFlood(true);
                                 }
                             }
                        }); 
                    }
                }*/
            }
         },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });

    /*
    setTimeout(function(){
       doCheckToken();
    },30*1000);
    */
}

//full screen


function toggleFull() {
    /*parent.toggleFullScreen();
    
   var isInFullScreen = !$("#map_header").is(":visible");
    if (isInFullScreen) {
        $("#map_header").show();
    } else {
        $("#map_header").hide();
    }
    setWindowSize();
    setTimeout(function(){
            setWindowSize();
        },500);
    return false;
    */
}

$(function(){
    $("#mapSpilter").attr("onmouseover", '$("#mapSpilter").css("background","#ccc")');
    $("#mapSpilter").attr("onmouseout", '$("#mapSpilter").css("background","#eee")');

});