
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
    var losh = $('#los-disp').is(':visible') ? 165 : 0;
    var bd = 0;
   
    var r = 0;
    var h = $(window).height() - ($('#map_header').is(':visible') ? 40 : 0);
    var w = $(window).width();
    var l = w-5;
    h -= 36;
    var divlist = [];
    divlist.push("info");
    divlist.push("videostream");
   
    //divlist.push("overview");
    divlist.push("layer");
    //divlist.push("input");



    if (mMode == "menu") {
        $("#map").hide();
        $("#left").show();
        $(".mMap").hide();
    } else {
        $("#map").show();
        $("#left").hide();
        $(".mMap").show();
    }

    $("#map_container").css("width", w + "px");
    $("#map_container").css("height", h + "px");

    /*if (isexpland_map) {
        l = 0;
        $("#left").hide();
    } else {
        $("#left").show();
    }*/
    $("#map").css("width", (w - 5) + "px");
    $("#map").css("height", (h - bd - losh) + "px");
    $("#left").css("width", (l + bd * 2) + "px");
    $("#left").css("height", (h) + "px");

    $("#los-disp").css("width", $("#map").width() + "px");
    $("#los-disp").css("height", (losh) + "px");
    
    $("#info-min").css("left", (w - 60) + "px");
    if ($("#info").attr("rel") == "min") {
        
     } 

    if ($("#info").attr("rel") == "max") {
        $("#info").css("top", 85 + "px");
        $("#info").css("width", $("#map").width() - 10 + "px");
        $("#info").css("height", $("#map").height() - 85 + "px");
    } else {
        $("#info").css("top", 85 + "px");
        $("#info").css("width", $("#map").width()-10 + "px");
        $("#info").css("height", $("#map").height()-85 + "px");
    }
    $("#info").css("left", 10 + "px");

    $("#videostream").css("width", (380) + "px");
    $("#videostream").css("left", (w - $("#videostream").width() - 20) + "px");

    var ah = h - 100;
    if ($('#videostream').is(':visible')) {
        $("#info").css("height", ((ah / 2) - (bd * 1)) + "px");
        $("#videostream").css("top", ((45 + 30 + 30 + 3) + $("#info").height()) + "px");
        $("#videostream").css("height", ((ah / 2) - (bd * 2)) + "px");

    } else {
        $("#info").css("height", ((ah / 3 * 2) - (bd * 1)) + "px");

    }


    if ($("#input").attr("rel") == "min") {
        $("#layer").css("width", (l) + "px");
        $("#layer").css("height", (h - bd * 2 - 20) + "px");

        $("#input").css("width", (l) + "px");
        $("#input").css("height", (20) + "px");
        $("#input_content").hide();
    } else {
        $("#layer").css("width", (l) + "px");
        $("#layer").css("height", (h / 5 * 3 - bd * 2) + "px");

        $("#input").css("width", (l) + "px");
        $("#input").css("height", (h / 5 * 2 - bd * 2) + "px");
        $("#input_content").show();
    }

    for (var i = 0; i < divlist.length; i++) {
        $("#" + divlist[i] + " .pcontent").css("width", $("#" + divlist[i]).width() + "px");
        $("#" + divlist[i] + " .pcontent").css("height", ($("#" + divlist[i]).height()) + "px");
    }
    $("#info_content").css("width", ($("#info").width() - 10) + "px");
    $("#info_content").css("height", ($("#info").height() - 28) + "px");

    $("#info_content").css("width", ($("#info").width() - 10) + "px");
    $("#info_content").css("height", ($("#info").height() - 28) + "px");
    $("#info_content2").css("width", ($("#info").width() - 15) + "px");
    $("#info_content2").css("height", ($("#info").height() - 70) + "px");
    $("#info_position").css("width", ($("#info").width() - 15) + "px");
    $("#info_position").css("height", ($("#info").height() - 68 - 60) + "px");

    $("#videostream_content").css("width", ($("#videostream").width()) + "px");
    $("#videostream_content").css("height", ($("#videostream").height() - 20) + "px");
    $("#videostream_title").css("width", ($("#videostream").width()) + "px");

    $("#input_content").css("width", ($("#input").width() - 20) + "px");
    $("#input_content").css("height", ($("#input").height() - 38) + "px");

    $(".pscroll").css("height", ($("#layer_content").height() - 32) + "px");
    $(".pscroll2").css("height", ($("#info_content").height() - 28 - 5) + "px");
    $(".pscroll3").css("height", (losh - 28) + "px");

    $("#los-disp_content").css("height", (losh - 28 - 5) + "px");
    $("#clearBnd").css("width", ($(".pscroll").width() - 25) + "px");
    if (map)
        map.invalidateSize();

    $("#input").hide();
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