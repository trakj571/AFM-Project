$(window).resize(function () {
    setWindowSize();
});

function initialPanelWin() {
    setWindowSize();

    setPanelWin("info", "Infomation");
    //setPanelWin("overview", "Overview map");
    //setPanelWin("layer", "Layers");
    //setPanelWin("input", "Input Form");

}

function setWindowSize() {
    var scrwd = 1000 - 5;
    if(window.screen.width>1000)
        scrwd=window.screen.width - 5;
    
    var bd = 0;
    var l = 341;
    var r = 0;
    var h = $(window).height() - 110;
    var w = scrwd?scrwd:$(window).width();
    var divlist = [];
    //divlist.push("info");
    //divlist.push("overview");
    divlist.push("layer");
    //divlist.push("input");

    $("#map_container").css("width", w + "px");
    $("#map_container").css("height", h + "px");

    $("#map").css("width", (w - l - r) + "px");
    $("#map").css("height", (h - bd - 25) + "px");
    $("#left").css("width", (l + bd * 2) + "px");
    $("#left").css("height", (h) + "px");
    //$("#right").css("width", (r) + "px");
    //$("#right").css("height", (h) + "px");

    $("#info").css("top", (115 +30+ 30) + "px");
    $("#info").css("left", (w-320) + "px");
    $("#info").css("width", (300) + "px");
    $("#info").css("height", (h - bd - 25 - 60) + "px");

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
    $(".pscroll2").css("height", ($("#info_content").height() - 28 -5) + "px");
}

function setPanelWin(div, title) {
    var orgt = $("#" + div).html();
    var t = "";
    t += "<img class='pclose' onclick=\"closePanel('" + div + "')\" src='images/close.png'><div class='ptitle'>" + title + "</div>";
    t += "<div id='" + div + "_content' class='pcontent'><div>";
    $("#" + div).html(t);
    $("#" + div + "_content").html(orgt);
    $("#" + div + " .pcontent").css("width", $("#" + div).width() + "px");
    $("#" + div + " .pcontent").css("height", ($("#" + div).height() - 18) + "px");

   
}

function closePanel(div) {
    $("#" + div).hide();
}
