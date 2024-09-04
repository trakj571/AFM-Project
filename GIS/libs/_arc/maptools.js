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

var mapToolMode = ToolMode.pan;
var infoPopup = null;
var toolObject = null;
var toolDotArray = [];
var isEndMeasure = false;
var timePosition = null;
function mapDispPosition(e) {
    if (timePosition) {
        clearTimeout(timePosition);
    } timePosition = setTimeout(function () {
        if (e)
            $("#posbar").html("LAT " + degreeFormat(e.latlng.lat) + "  &nbsp; LONG " + degreeFormat(e.latlng.lng)+" &nbsp; ");
        else
            $("#posbar").html("");
    }, 300);
}
function createMLine(latlngs) {
    return E$.polyline(latlngs, { color: "#00f", weight: 3, opacity: 0.7, clickable: false });
}
function createMPolygon(latlngs) {
    return E$.polygon(latlngs, { color: "#00f", weight: 3, opacity: 0.7, fillColor: "#00f", fillOpacity: 0.2, clickable: false });
}
function createMCir(latlng) {
    return E$.circle(latlng,0, { color: "#00f", weight: 3, opacity: 0.7, fillColor: "#00f", fillOpacity: 0.2, clickable: false });
}

function addPOIDone(poiid, lyid, tab) {
    if (tab == "sch") {
        if (poiid > 0) {
            selectPoi(tab, poiid, false);
        } else {
            if (schPOI_datas) {
                for (var i = schPOI_datas.length-1; i >=0; i--) {
                    var poi = schPOI_datas[i];
                    if (poi.PoiID == -poiid) {
                        schPOI_datas.splice(i, 1);
                    }
                }
                clearSchPOI();
                displaySchResult(schPOI_datas);
                $("#info_content").html("");
            }
        }
    }
    else {
        if (!poiid) {
            $("#info_content").html("");
        } else {
            selectPoiID_afterload = poiid;
        }
        if (lyid) {
            if (!$('#layerTree').jstree("is_checked", "#li_node_id" + lyid))
                $('#layerTree').jstree("check_node", "#li_node_id" + lyid);
            else
                loadPoifromLayers();
        }
        else {
            loadPoifromLayers();
        }
    }
    closeInfoPopup();
}
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
        content = formatDist(calDist(toolObject.getLatLngs()));
    }
    else if(mapToolMode == ToolMode.marea) {
        content = formatArea(calArea(toolObject.getLatLngs()));
    }
    else if (mapToolMode == ToolMode.mcir) {
        popCenter = toolObject.getLatLng();
        var r = toolObject.getRadius();
        content = "radius : " + formatDist(r) + "<br />area : " + formatArea(Math.PI * r * r);
    }
    else if (mapToolMode == ToolMode.pin) {
        content = "<iframe id=addPOIFrame width=300 height=300 frameborder=0 src='data/addpoi.aspx?poitype=1&poiid=0&typeid=" + _selected_TypeID + "&lyid=" + _selected_LyID + "' />";
        offset = -32;
    }
    else if (mapToolMode == ToolMode.line || mapToolMode == ToolMode.shape || mapToolMode == ToolMode.cir) {
        var ptype=2;
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
    if (mapToolMode == ToolMode.cir) {
        
        popCenter = toolObject.getLatLng();
    }
    mapToolMode = ToolMode.pan;
    resetCursor();
    $("#bToolPan").addClass("selected");
    //
    //if (mapToolMode == ToolMode.mdist || mapToolMode == ToolMode.marea || mapToolMode == ToolMode.mcir) {
        setTimeout(function () {
            infoPopup = E$.popup({ offset: [0, offset],autoPanPadding:[10,80],closeOnClick:false });
            infoPopup.setLatLng(popCenter);
            infoPopup.setContent(content);
            infoPopup.on("close", function (e) {
                resetMeasure();
            });
            infoPopup.openOn(map);
        }, 200);
    //}
}

function resetMeasure() {
    if (toolObject) {
        for (var i = 0; i < toolDotArray.length; i++) {
            map.removeLayer(toolDotArray[i]);
        }
        map.removeLayer(toolObject);
    }
    
    toolDotArray = [];
    toolObject = null;
    
}

function mapOnclick(e) {
    if (mapToolMode == ToolMode.mdist || mapToolMode == ToolMode.marea || mapToolMode == ToolMode.line || mapToolMode == ToolMode.shape) {
        for (var i = 0; i < toolDotArray.length; i++) {
            toolDotArray[i].off("mousedown");
            //toolDotArray[i].off("dblclick");
        }
        var dot = E$.marker(e.latlng, { icon: E$.divIcon({ className: 'dot-icon' }) }).addTo(map);
        dot.on('mousedown', function (e) {
            endMeasure(e);
        });
        dot.on('dblclick', function (e) {
            endMeasure(e);
        });
        toolDotArray.push(dot);
        var latlngs = [];
        for (var i = 0; i < toolDotArray.length; i++) {
            latlngs.push(toolDotArray[i].getLatLng());
        }
        if (latlngs.length > 1) {
            if (!toolObject) {
                if (mapToolMode == ToolMode.mdist || mapToolMode == ToolMode.line) {
                    toolObject = createMLine(latlngs);
                } else {
                    toolObject = createMPolygon(latlngs);
                }
                toolObject.addTo(map)
            }
            else {
                toolObject.setLatLngs(latlngs);
            }
        }
    }
    if (mapToolMode == ToolMode.mcir || mapToolMode == ToolMode.cir) {
        if (!toolObject) {
            toolObject = createMCir(e.latlng);
            toolObject.addTo(map);
            var dot = E$.marker(e.latlng, { icon: E$.divIcon({ className: 'dot-icon'}) }).addTo(map);
            toolDotArray.push(dot);
            dot.addTo(map);

        } else {
            var r = e.latlng.distanceTo(toolObject.getLatLng());
            toolObject.setRadius(r);
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
}
function mapOnMousemove(e) {
    if (mapToolMode == ToolMode.mdist || mapToolMode == ToolMode.marea || mapToolMode == ToolMode.line || mapToolMode == ToolMode.shape) {
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
                if (mapToolMode == ToolMode.mdist || mapToolMode == ToolMode.line)
                    toolObject = createMLine(latlngs);
                else
                    toolObject = createMPolygon(latlngs);

                toolObject.addTo(map)
            } else {
                toolObject.setLatLngs(latlngs);
            }
            infoPopup.setLatLng(e.latlng);
            if (mapToolMode == ToolMode.mdist || mapToolMode == ToolMode.line) {
                infoPopup.setContent(formatDist(calDist(latlngs)));
            } else if (latlngs.length > 2) {
                infoPopup.setContent(formatArea(calArea(latlngs)));
            } else {
                return;
            }
            infoPopup.openOn(map);
        }
    }
    if (mapToolMode == ToolMode.mcir || mapToolMode == ToolMode.cir) {
        if (toolObject) {
            var r = e.latlng.distanceTo(toolObject.getLatLng());
            toolObject.setRadius(r);
            if (!infoPopup) {
                infoPopup = E$.popup({ offset: new E$.Point(0, -4),closeOnClick:false });
            }
            infoPopup.setLatLng(toolObject.getLatLng());
            infoPopup.setContent("radius : " + formatDist(r) + "<br />area : " + formatArea(Math.PI*r*r));
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
}


function addMapToolsControl() {
    map.on('mouseup', function (e) {
        mapOnclick(e);
    });
    /*map.on('click', function (e) {
        mapOnclick(e);
    });*/
    map.on('mouseout', function (e) {
        mapDispPosition();
    });
    map.on('mousemove', function (e) {
        mapOnMousemove(e);
        mapDispPosition(e);
    });
   
    var MyControl = E$.Control.extend({
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
    map.addControl(new MyControl());
    $("#bToolPan").addClass("selected");
    $("#bToolPan").bind("click", function () {
        resetCursor();
        $(this).addClass("selected");
        mapToolMode = ToolMode.pan;
    });
    $("#bToolZoom").bind("click", function () {
        resetCursor();
        $("#map").addClass("defaultCursor");
        $(this).addClass("selected");
        mapToolMode = ToolMode.zoom;
    });
    $("#bToolmDist").bind("click", function () {
        prepareMeasure();
        $(this).addClass("selected");
        $("#map").addClass("crossCursor");
        mapToolMode = ToolMode.mdist;
    });
    $("#bToolmArea").bind("click", function () {
        prepareMeasure();
        $(this).addClass("selected");
        $("#map").addClass("crossCursor");

        mapToolMode = ToolMode.marea;
    });
    $("#bToolmCir").bind("click", function () {
        prepareMeasure();
        $(this).addClass("selected");
        $("#map").addClass("crossCursor");

        mapToolMode = ToolMode.mcir;
    });
    $("#bToolClr").bind("click", function () {
        prepareMeasure();
        $("#bToolPan").addClass("selected");
        mapToolMode = ToolMode.pan;
    });
    $("#bToolDim").bind("click", function () {
        if (curOpacity == 1)
            curOpacity = 0.3;
        else
            curOpacity = 1;
        curTile.setOpacity(curOpacity);
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
}

function addToolClick(mode) {
    var id = "#1";
    if (mode == ToolMode.pin) {
        id = "#bToolPin";
    }if (mode == ToolMode.line) {
        id = "#bToolLine";
    }if (mode == ToolMode.shape) {
        id = "#bToolShape";
    }if (mode == ToolMode.cir) {
        id = "#bToolCir";
    }
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
        
}
function resetCursor() {
    $("#bToolPan").removeClass("selected");
    $("#bToolZoom").removeClass("selected");
    $("#bToolmDist").removeClass("selected");
    $("#bToolmArea").removeClass("selected");
    $("#bToolmCir").removeClass("selected");
    $("#bToolPin").removeClass("selected");
    $("#bToolLine").removeClass("selected");
    $("#bToolShape").removeClass("selected");
    $("#bToolCir").removeClass("selected");
    $("#bToolInfo").removeClass("selected");
    $("#bToolLoc").removeClass("selected");

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
                setMapTypeToMap($("#maptype_src").html(), "m");
                
            });
            $("#maptype_sat").bind("click", function () {
                $(this).css("border", "2px solid #ff9900");
                $("#maptype_map").css("border", "2px solid #ccc");
                $("#maptype_hyb").css("border", "2px solid #ccc");
                setMapTypeToMap($("#maptype_src").html(), "s");
                
            });
            $("#maptype_hyb").bind("click", function () {
                $(this).css("border", "2px solid #ff9900");
                $("#maptype_sat").css("border", "2px solid #ccc");
                $("#maptype_map").css("border", "2px solid #ccc");
                setMapTypeToMap($("#maptype_src").html(), "y");
                
            });
            var controlDiv = E$.DomUtil.get("maptypectl");
            E$.DomEvent
            .addListener(controlDiv, 'click', L.DomEvent.stopPropagation)
            .addListener(controlDiv, 'click', L.DomEvent.preventDefault);

            return controlDiv;
        }
    });

    map.addControl(new MyControl());
    //$('#jsddm > li').bind('click', jsddm_open);
    //$('#jsddm > li').bind('mouseout', jsddm_timer);
    document.onclick = jsddm_close;
   // $('#maptype_src').bind('click', jsddm_open);
}


/*MapTypeControl*/
var curTile = null;
var curMiniTile = null;
var curMapType="m";
var miniMap = null;
var curOpacity = 1;
function setMapTypeToMap(src, mtype) {
    jsddm_close();
    if (!mtype) mtype = curMapType;
    if(curTile && map.hasLayer(curTile)){
        map.removeLayer(curTile);
    }    
    var url ="";
    curMapType = mtype;
    $("#maptype_src").html(src);
    if (src == "Google") {
        if (mtype == "s") mtype = "s";
        else if (mtype == "y") mtype = "y";
        else mtype = "m";

        url = "http://mt{s}.google.com/vt/lyrs=" + mtype + "&x={x}&y={y}&z={z}";
        curTile = E$.tileLayer(url, { maxZoom: 19, subdomains: '0123' });
        curMiniTile = E$.tileLayer(url, { maxZoom: 13, subdomains: '0123' });
    }
    else if (src == "Yahoo") {
        if (mtype == "s") {
            url = "http://us.maps3.yimg.com/aerial.maps.yimg.com/tile?v=1.7&t=a&x={x}&y={y}&z={z}";
        }
       else if (mtype == "y") {
            url = "http://us.maps3.yimg.com/aerial.maps.yimg.com/png?v=2.2&t=h&x={x}&y={y}&z={z}";
        } else {
            url = "http://us.maps2.yimg.com/us.png.maps.yimg.com/png?v=3.52&t=m&x={x}&y={y}&z={z}";
        }
        curTile = E$.yahooLayer(url, { maxZoom: 19 });
        curMiniTile = E$.yahooLayer(url, { maxZoom: 13 });
    }
    else if (src == "Bing") {
        if (mtype == "s") mtype = "a";
        else if (mtype == "y") mtype = "h";
        else  mtype = "r";
        url = "http://" + mtype + "{subdomain}.ortho.tiles.virtualearth.net/tiles/" + mtype + "{quadkey}.png?g=159&shading=hill";
        curTile = E$.bingLayer(url, { maxZoom: 19, subdomains: [0, 1, 2, 3] });
        curMiniTile = E$.bingLayer(url, { maxZoom: 13, subdomains: [0, 1, 2, 3] });
    }

    else if (src == "EBMS") {
        url = "http://ebmsapp.com/Service/Tiles/?layers=SMP&z={z}&x={x}&y={y}";
        curTile = E$.tileLayer(url, { maxZoom: 19 });
        curMiniTile = E$.tileLayer(url, { maxZoom: 13 });
    }
    else if (src == "SMPK") {
        url = "WMS/tiles.aspx?layers=SMP&z={z}&x={x}&y={y}&f=GM";
        curTile = E$.tileLayer(url, { maxZoom: 19 });
        curMiniTile = E$.tileLayer(url, { maxZoom: 13 });
    }
    if(!curTile) return;

    map.addLayer(curTile);
    curTile.bringToBack();
    if(miniMap){
        miniMap.setLayer(curMiniTile);
    }else{
        //miniMap = new L.Control.MiniMap(curMiniTile).addTo(map);
    }
}

function jsddm_open() {
   $("#jsddm ul").css('visibility', 'visible');
}

function jsddm_close() {
    $("#jsddm ul").css('visibility', 'hidden');
}






