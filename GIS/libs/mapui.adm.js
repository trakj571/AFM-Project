﻿
var admMode = AdmMode.Adm;
$(window).resize(function () {
    setWindowSize();
});

function initialPanelWin() {
    setWindowSize();

    setPanelWin("info", "Information", false, true);
    //setPanelWin("overview", "Overview map");
    //setPanelWin("layer", "Layers");
    setPanelWin("videostream", "Video Streaming");
   
    setPanelWin("input", "Input Form", true);
    setPanelWin("los-disp", '<ul class="css-tabs3"><li><a id="los-t-1" href="#taba1">กราฟ</a></li><li><a id="los-t-2" href="#taba2">ข้อความ</a></li><li><a id="los-t-3" href="#taba3">Line of sight</a></li></ul>'); //Line of sight
   
  
}

function setWindowSize() {
   
    scrwd = window.screen.width - 5;

    var losh = $('#los-disp').is(':visible') ? 165 : 0;
    var bd = 0;
    var l = 341;
    var r = 0;
    var h = $(window).height() - ($('#map_header').is(':visible') ? 40 : 0);
    var w = $(window).width();
    h -= 0;
    
    $("#map_container").css("width", w + "px");
    $("#map_container").css("height", h + "px");
    l = 0;
    
    $("#map").css("width", (w - l - r - 5) + "px");
    $("#map").css("height", (h - bd - losh) + "px");

    $("#los-disp").css("width", $("#map").width() + "px");
    $("#los-disp").css("height", (losh) + "px");
    if (map)
        map.invalidateSize();
}

function setPanelWin(div, title, min, max) {
    var orgt = $("#" + div).html();
    var t = "";
    t += "<div id='" + div + "_title'>";

    if (min) {
        $("#" + div).attr("rel", "min");
        t += "<img style='cursor:pointer' class='pclose' onclick=\"minPanel('" + div + "')\" src='images/arrow-UU.png' />";
    } else {
        t += "<img style='cursor:pointer;" + (div == "los-disp"?"margin-top:5px":"") + "' class='pclose' onclick=\"closePanel('" + div + "')\" src='images/close.png' />";
        if (max) {
            //$("#" + div).attr("rel", "max");
            t += "<img style='cursor:pointer' class='pclose' onclick=\"maxPanel('" + div + "')\" src='images/max.png' />";
            if(div=="info")
                t += "<img style='cursor:pointer' class='pclose' onclick=\"minInfo('" + div + "')\" src='images/min.png' />";
           
        }
    }
    if(div=="los-disp")
        t += "<div>" + title + "</div>";
    else
        t += "<div class='ptitle'>" + title + "</div>";

    t += "</div><div id='" + div + "_content' class='pcontent'><div>";
    $("#" + div).html(t);
    $("#" + div + "_content").html(orgt);
    $("#" + div + " .pcontent").css("width", $("#" + div).width() + "px");
    $("#" + div + " .pcontent").css("height", ($("#" + div).height() - 18) + "px");
    
    if (div == "los-disp") {
        $("#los-disp_title").tabs("#los-disp_panel > div");
        //$("#los-t-1").click();
        $("#los-t-1").hide();
        $("#los-t-2").hide();
        $("#los-t-3").hide();
    }
}

function closePanel(div) {
    $("#" + div).hide();
    if (div == "info" && isEditPoiPos) {
        cancelEditPos(true);
    }
    else if (div == "info") {
        selectPoi("", -1);
    }
    else if (div == "videostream") {
        $f().stop();
        $("#" + div + "_content").html("");
        $("#" + div).hide();
    }
    setWindowSize();
}
function maxPanel(div) {
    if ($("#" + div).attr("rel") == "max") {
        $("#" + div).attr("rel", "");

    } else {
        $("#" + div).attr("rel", "max");

    }
    setWindowSize();
}
function minInfo(div) {
    $("#info").hide();
    $("#info-min").show();
    setWindowSize();
}
function showInfo() {
    $("#info").show();
    $("#info-min").hide();
    setWindowSize();
}
function minPanel(div) {
    if ($("#" + div).attr("rel") == "min") {
        $("#" + div).attr("rel", "");
        $("#" + div + " .pclose").attr("src", "images/arrow-DD.png");
    } else {
        $("#" + div).attr("rel", "min");
        $("#" + div + " .pclose").attr("src", "images/arrow-UU.png");
    }
    setWindowSize();
}


var isexpland_map = false;
function explandMap() {
    if (isexpland_map) {
        isexpland_map = false;
        //$("#img_arr_l").attr("src", "images/arrow-LL.png");
    } else {
        isexpland_map = true;
        //$("#img_arr_l").attr("src", "images/arrow-RR.png");
    }
    setWindowSize();
}