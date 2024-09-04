var admMode = AdmMode.Adm;
$(window).resize(function () {
    setWindowSize();
});

function initialPanelWin() {
    setWindowSize();

    setPanelWin("info", "Infomation");
    //setPanelWin("overview", "Overview map");
    //setPanelWin("layer", "Layers");
    setPanelWin("input", "Input Form");
    setPanelWin("los-disp", "Line of sight", true);


}

function setWindowSize() {
    var scrwd = 1000 - 5;
  
    var losh = $('#los-disp').is(':visible') ? 160 : 0;
    var bd = 0;
    var l = 291;
    var r = 0;
    var h = $(window).height();
    var w = scrwd?scrwd:$(window).width();
    var divlist = [];
    //divlist.push("info");
    //divlist.push("overview");
    divlist.push("layer");
    //divlist.push("input");

    $("#map_container").css("width", w + "px");
    $("#map_container").css("height", h + "px");

    if (isexpland_map) {
        l = 0;
        $("#left").hide();
    } else {
        $("#left").show();
    }
    $("#map").css("width", (w - l - r) + "px");
    $("#map").css("height", (h - bd - 25 - losh) + "px");
    $("#left").css("width", (l + bd * 2) + "px");
    $("#left").css("height", (h) + "px");

    $("#los-disp").css("width", $("#map").width() + "px");
    $("#los-disp").css("height", (losh) + "px");

    //$("#right").css("width", (r) + "px");
    //$("#right").css("height", (h) + "px");

    $("#info").css("top", (75 +30+ 30) + "px");
    $("#info").css("width", (380) + "px");
    $("#info").css("left", (w - $("#info").width() - 20) + "px");
    $("#info").css("height", (h - bd - 25 - 120) + "px");

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

    //$("#overview").css("width", r + "px");
    //$("#overview").css("height", (h / 3 - bd * 2) + "px");

    $("#layer").css("width", (l) + "px");
    $("#layer").css("height", (h - bd * 2) + "px");
    //$("#input").css("width", (l) + "px");
    //$("#input").css("height", (h / 5 * 2 - bd * 2) + "px");


    for (var i = 0; i < divlist.length; i++) {
        $("#" + divlist[i] + " .pcontent").css("width", $("#" + divlist[i]).width() + "px");
        $("#" + divlist[i] + " .pcontent").css("height", ($("#" + divlist[i]).height()) + "px");
    }
    $("#info_content").css("width", ($("#info").width() - 10) + "px");
    $("#info_content").css("height", ($("#info").height() - 28) + "px");
    
    //$("#input_content").css("width", ($("#input").width() - 20) + "px");
    //$("#input_content").css("height", ($("#input").height() - 38) + "px");
    $(".pscroll").css("height", ($("#layer_content").height() - 32) + "px");
    $(".pscroll2").css("height", ($("#info_content").height() - 28 - 5) + "px");

    $("#los-disp_content").css("height", (losh - 28 - 5) + "px");

    $("#clearBnd").css("width", ($(".pscroll").width() - 25) + "px");
    if (map)
        map.invalidateSize();
}

function setPanelWin(div, title, maxmin) {
    var orgt = $("#" + div).html();
    var t = "";
    t += "<div id='" + div + "_title'>";
    if (maxmin) {
        $("#" + div).attr("rel", "min");
        t += "<img style='cursor:pointer' class='pclose' onclick=\"minPanel('" + div + "')\" src='images/arrow-UU.png' />";
    } else {
        t += "<img style='cursor:pointer' class='pclose' onclick=\"closePanel('" + div + "')\" src='images/close.png' />";
    }
    t += "<div class='ptitle'>" + title + "</div></div>";
    t += "<div id='" + div + "_content' class='pcontent'><div>";
    $("#" + div).html(t);
    $("#" + div + "_content").html(orgt);
    $("#" + div + " .pcontent").css("width", $("#" + div).width() + "px");
    $("#" + div + " .pcontent").css("height", ($("#" + div).height() - 18) + "px");



}

function closePanel(div) {
    $("#" + div).hide();
    if (div == "info" && isEditPoiPos) {
        cancelEditPos(true);
    }
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
        $("#img_arr_l").attr("src", "images/arrow-LL.png");
    } else {
        isexpland_map = true;
        $("#img_arr_l").attr("src", "images/arrow-RR.png");
    }
    setWindowSize();
}