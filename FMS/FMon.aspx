<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FMon.aspx.cs" Inherits="AFMProj.FMS.FMon" %>

<!DOCTYPE html>
<html>
<head>
    <!--#include file="../_inc/Title.asp"-->
    <script src="../_Inc/js/highstock.js"></script>
    <script type="text/javascript" src="../gis/libs/flowplayer/flowplayer-3.2.13.min.js"></script>
    <script type="text/javascript" src="../gis/libs/flowplayer/flowplayer.ipad-3.2.13.min.js"></script>
    <style>
        #searchSection {
            display: none
        }

        #schd-button, #schd-button-M {
            display: none
        }
    </style>
    <script language="javascript">
        var poiid = '<%=Request["PoiID"] %>';
        var stream = "";
        $(function () {

            loadScanTable();


            $('#ScanType_N').click(function (e) {
                $('#scan-button').show();
                $('#scan-button-M').show();
                $('#schd-button').hide();
                $('#schd-button-M').hide();
            });

            $('#ScanType_S').click(function (e) {
                $('#scan-button').hide();
                $('#scan-button-M').hide();
                $('#schd-button').show();
                $('#schd-button-M').show();
            });

            $(".afm-reset-voice").click(function () {
                $(".afm-reset-voice").prop("disabled", true);
                $.ajax({
                    type: 'GET',
                    url: "data/cReset.ashx?index=0&poiid=<%=Request["PoiID"]%>",
                    cache: false,
                    dataType: 'text',
                    success: function (data) {
                        swal({
                            title: "AFM",
                            text: data,
                            type: 'info',
                            confirmButtonText: 'ตกลง',
                            confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                        });
                        $(".afm-reset-voice").prop("disabled", false);
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        $(".afm-reset-voice").prop("disabled", false);
                    }

                });
            });

            $(".afm-reset-scanner").click(function () {
                $(".afm-reset-scanner").prop("disabled", true);
                $.ajax({
                    type: 'GET',
                    url: "data/cReset.ashx?index=1&poiid=<%=Request["PoiID"]%>",
                   cache: false,
                   dataType: 'json',
                   success: function (data) {
                       swal({
                           title: "AFM",
                           text: data.status,
                           type: 'info',
                           confirmButtonText: 'ตกลง',
                           confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                       });
                       $(".afm-reset-scanner").prop("disabled", false);
                   },
                   error: function (XMLHttpRequest, textStatus, errorThrown) {
                       $(".afm-reset-scanner").prop("disabled", false);
                   }

               });
            });

            getInfo();
        });
        function getInfo() {
            $.ajax({
                type: 'POST',
                url: "data/dInfo.ashx",
                data: {
                    PoiID: poiid
                },
                cache: false,
                dataType: 'json',
                success: function (data) {
                    for (var i = 0; i < data.length; i++) {
                        if (data[i].name == "Stream") {
                            stream = data[i].value;
                        }
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }

            });
        }

        ///
        function chkExistsScan() {
            $.ajax({
                type: 'POST',
                url: "data/dscanexists.ashx",
                data: {
                    PoiID: poiid
                },
                cache: false,
                dataType: 'json',
                success: function (data) {
                    if (data.length == 0) {
                        $('#ScanType_N').prop("disabled", false);
                    } else {
                        $('#ScanType_N').prop("disabled", true);
                        $('#ScanType_S').prop("checked", true);
                        $('#scan-button').hide();
                        $('#schd-button').show();
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }
            });

        }

        function cancelScan(scanid) {
            swal({
                title: 'ต้องการยกเลิก',
                text: "",
                type: 'warning',
                showCancelButton: true,
                confirmButtonText: 'ยืนยัน',
                cancelButtonText: 'ปิด',
                confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                cancelButtonClass: 'nbtc-btn nbtc-btn-secondary',
            }).then(function () {
                $.ajax({
                    type: 'POST',
                    url: "data/dscancancel.ashx",
                    data: {
                        scanid: scanid,
                    },
                    cache: false,
                    dataType: 'json',
                    success: function (data) {
                        updateScanTable();
                        location = location.href;
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {

                    }

                });
            });

        }
        ///

        function chkDDC() {
            var ddc1 = $("#DDC1 option:selected").text();
            var ddc2 = $("#DDC2 option:selected").text();
            var dfbw = $("#DFBw").val();
            var ddc1s = ddc1.split(' ');
            var ddc2s = ddc2.split(' ');
            var ddc1i = 0, ddc2i = 0,dfbwi=0;
            if (ddc1s[1] == "kHz") ddc1i = parseFloat(ddc1s[0]) * 1000;
            if (ddc1s[1] == "MHz") ddc1i = parseFloat(ddc1s[0]) * 1000000;

            if (ddc2s[1] == "kHz") ddc2i = parseFloat(ddc2s[0]) * 1000;
            if (ddc2s[1] == "MHz") ddc2i = parseFloat(ddc2s[0]) * 1000000;

            if (dfbw != "" && !isNaN(dfbw))
                dfbwi = parseFloat(dfbw);

           // alert(dfbw + " " + ddc1i + " " + ddc2i);

            if (dfbw > ddc1i || dfbw > ddc2i) {
                swal({
                    title: "AFM",
                    text: "Demodulator Filter Bandwidth must less than (or equal to) DDC1 and DDC2",
                    type: 'warning',
                    confirmButtonText: 'ตกลง',
                    confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                });
                return false;
            }
            return true;
        }

        function doSchd() {

            if (!chkDDC())
                return;

            if (isNaN($("#fFreq").val()) ||
                isNaN($("#tFreq").val()) ||
                isNaN($("#nSec").val())) {
                return;
            }

            var f1 = parseFloat($("#fFreq").val());
            var f2 = parseFloat($("#tFreq").val());
            if (f1 > f2) {
                var tmp = f1;
                f1 = f2;
                f2 = tmp;
            }
            if (f1 < 25 || f1 > 3000 || f2 < 25 || f2 > 3000) {
                swal({
                    title: "AFM",
                    text: "ช่วงความถิ่ต้องอยู่ระหว่าง 25-3000MHz",
                    type: 'warning',
                    confirmButtonText: 'ตกลง',
                    confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                });
                return;
            }
            var if1 = f1 * 1000000;
            var if2 = f2 * 1000000;


            if ($("#DtStart").val() == "") {
                swal({
                    title: "AFM",
                    text: "โปรดระบุ Schedule Start time",
                    type: 'warning',
                    confirmButtonText: 'ตกลง',
                    confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                });
                return;
            }

            var rbw = 0;
            if ($("#ChSp").val() == "12500")
                rbw = 2;
            else if ($("#ChSp").val() == "25000")
                rbw = 1;

            $.ajax({
                type: 'POST',
                url: "data/dscanSchd.ashx",
                data: {
                    PoiID: poiid,
                    DtStart: $("#DtStart").val(),
                    Mode: "A",
                    fFreq: if1,
                    tFreq: if2,
                    RBW: rbw,
                    Threshold: $("#Threshold").val(),
                    nHr: parseInt($("#nHr").val()),
                    nMin: parseInt($("#nMin").val()),
                    nSec: parseInt($("#nSec").val()),
                    ChSp: parseInt($("#ChSp").val()),
                    RadMode: $("#RadMode").val(),
                    DDC1: $("#DDC1").val(),
                    DDC2: $("#DDC2").val(),
                    DFBw: $("#DFBw").val()
                },
                cache: false,
                dataType: 'json',
                success: function (data) {
                    //window.open("data/dScanTable.ashx?poiid="+poiid);
                    //alert(data.retID)
                    if (data.retID == -2) {
                        swal({
                            title: "AFM",
                            text: "ไม่สามารถตั้ง Scan Schedule ได้ โปรดยกเลิก On Process Scan ก่อนหน้าก่อน",
                            type: 'warning',
                            confirmButtonText: 'ตกลง',
                            confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                        });
                    }
                    else if (data.retID == -3) {
                        swal({
                            title: "AFM",
                            text: "ไม่สามารถตั้ง Scan Schedule ได้ โปรดยกเลิก Scan Schedule ก่อนหน้าก่อน",
                            type: 'warning',
                            confirmButtonText: 'ตกลง',
                            confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                        });
                    } else {
                        msgbox_save(data.retID);

                    }

                    updateScanTable();

                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }

            });
        }

        //
        var scanID = 0;

        function doScan() {
            if (!chkDDC())
                return;
            scanID = 0;
            if (isNaN($("#fFreq").val()) ||
                isNaN($("#tFreq").val()) ||
                isNaN($("#nSec").val())) {
                return;
            }

            var f1 = parseFloat($("#fFreq").val());
            var f2 = parseFloat($("#tFreq").val());
            if (f1 > f2) {
                var tmp = f1;
                f1 = f2;
                f2 = tmp;
            }
            if (f1 < 25 || f1 > 3000 || f2 < 25 || f2 > 3000) {
                swal({
                    title: "AFM",
                    text: "ช่วงความถิ่ต้องอยู่ระหว่าง 25-3000MHz",
                    type: 'warning',
                    confirmButtonText: 'ตกลง',
                    confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                });
                return;
            }
            var if1 = f1 * 1000000;
            var if2 = f2 * 1000000;

            $("#prog-content").show();
            $("#result-content").hide();
            $("#scan-button").hide();
            $("#ScanProg").html("Scanning...");


            // return;
            // window.open("data/dscanbegin.ashx?fFreq=" + if1 + "&tFreq=" + if2 + "&RBW=" + $("#RBW").val() + "&nSec=" + parseInt($("#nSec").val()));

            var rbw = 0;
            if ($("#ChSp").val() == "12500")
                rbw = 2;
            else if ($("#ChSp").val() == "25000")
                rbw = 1;

            $.ajax({
                type: 'POST',
                url: "data/dscanbegin.ashx",
                data: {
                    PoiID: poiid,
                    fFreq: if1,
                    tFreq: if2,
                    RBW: rbw,
                    Threshold: $("#Threshold").val(),
                    nHr: parseInt($("#nHr").val()),
                    nMin: parseInt($("#nMin").val()),
                    nSec: parseInt($("#nSec").val()),
                    ChSp: parseInt($("#ChSp").val()),
                    RadMode: $("#RadMode").val(),
                    DDC1: $("#DDC1").val(),
                    DDC2: $("#DDC2").val(),
                    DFBw: $("#DFBw").val()
                },
                cache: false,
                dataType: 'json',
                success: function (data) {
                    //loadScanTable();
                    if (data.result == "OK") {
                        setTimeout(function () {
                            checkProScan();
                            iTmCnt = 0;
                            startCounter();
                        }, 3000);
                    } else if (data.result == "EXT") {
                        swal({
                            title: "AFM",
                            text: "ไม่สามารถ Scan ได้ โปรดยกเลิก On Process Scan ก่อนหน้าก่อน",
                            type: 'warning',
                            confirmButtonText: 'ตกลง',
                            confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                        });
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }

            });
        }
        var scanTimeout = null;
        function checkProScan() {
            $.ajax({
                type: 'POST',
                url: "data/dscancheck.ashx",
                data: {
                    PoiID: poiid,
                    scanID: scanID
                },
                cache: false,
                dataType: 'json',
                success: function (data) {
                    if (data.length == 0)
                        return;
                    scanID = data[0].ScanID;
                    //alert(scanID + " " + data[0].Status);
                    if (data[0].Status == "E") {
                        if (scanTimeout)
                            clearTimeout(scanTimeout);

                        $("#aEvent").html("EVENT(" + data[0].nEvent + ")");
                        $("#aEvent").prop("href", "AnEvent.aspx?scanid=" + scanID);
                        $("#aFStr").prop("href", "AnFStr.aspx?scanid=" + scanID);
                        $("#aOcc").prop("href", "AnOcc.aspx?scanid=" + scanID);
                        dispChartM(scanID, 'fre-container');

                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }

            });
            scanTimeout = setTimeout(function () {
                checkProScan();
            }, 5 * 1000);
        }



        function setManual(f) {
            $('.radio-mode_manual').click();
            $("#MFreq").val((parseFloat(f) / 1000000).toFixed(2));

            doTunning();
        }

        function doTunning() {
            if (!chkDDC())
                return;

              <%if (IsMobile())
        { %>
            location = "rtmp://lmtr.nbtc.go.th/flvplayback/" + stream;
                    //$("#iAudio").show();
                    //$("#iAudio iframe").prop("src", "Audio.aspx?stream="+stream);
              <%}
        else
        { %>
            $("#iAudio").show();
            if (!$("#iAudio iframe").prop("src"))
                $("#iAudio iframe").prop("src", "Audio.aspx?stream=" + stream);
             <%} %>
            var f = parseFloat($("#MFreq").val()) * 1000000;
            setTimeout(function () {
                setAudioF(f);
            }, 500);
        }
        function setAudioF(f) {

            $.ajax({
                type: 'POST',
                url: "data/dAudioF.ashx",
                data: {
                    PoiID: poiid,
                    Freq: f,
                    nHr: parseInt($("#MnHr").val()),
                    nMin: parseInt($("#MnMin").val()),
                    nSec: parseInt($("#MnSec").val()),
                    RadMode: $("#RadMode").val(),
                    DDC1: $("#DDC1").val(),
                    DDC2: $("#DDC2").val(),
                    DFBw: $("#DFBw").val()
                },
                cache: false,
                dataType: 'json',
                success: function (data) {
                    setData(data);
                    updateScanTable();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }

            });
        }


        function doSchdM() {
            if (!chkDDC())
                return;

            if (isNaN($("#MFreq").val()) ||
                isNaN($("#MnSec").val())) {
                return;
            }

            var f = parseFloat($("#MFreq").val()) * 1000000;


            if ($("#DtStart").val() == "") {
                swal({
                    title: "AFM",
                    text: "โปรดระบุ Schedule Start time",
                    type: 'warning',
                    confirmButtonText: 'ตกลง',
                    confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                });
                return;
            }


            $.ajax({
                type: 'POST',
                url: "data/dscanSchd.ashx",
                data: {
                    PoiID: poiid,
                    Mode: "M",
                    DtStart: $("#DtStart").val(),
                    fFreq: f,
                    tFreq: 0,
                    RBW: 0,
                    Threshold: 0,
                    nHr: parseInt($("#MnHr").val()),
                    nMin: parseInt($("#MnMin").val()),
                    nSec: parseInt($("#MnSec").val()),
                    ChSp: 0,
                    RadMode: $("#RadMode").val(),
                    DDC1: $("#DDC1").val(),
                    DDC2: $("#DDC2").val(),
                    DFBw: $("#DFBw").val()
                },
                cache: false,
                dataType: 'json',
                success: function (data) {
                    //window.open("data/dScanTable.ashx?poiid="+poiid);
                    //alert(data.retID)
                    msgbox_save(data.retID);
                    updateScanTable();

                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }

            });
        }

        ///

        var iTmCnt = 0;
        function startCounter() {
            var nsec = parseInt($("#nHr").val()) * 3600 + parseInt($("#nMin").val()) * 60 + parseInt($("#nSec").val());
            setTimeout(function () {
                iTmCnt++;
                if (iTmCnt > nsec) {
                    $("#ScanProg").html("Processing...");
                } else {
                    var dur = "";

                    if (Math.floor(iTmCnt / 3600) > 0) dur += Math.floor(iTmCnt / 3600) + " hr ";
                    if (Math.floor(iTmCnt / 60) % 60 > 0) dur += (Math.floor(iTmCnt / 60) % 60) + " min ";
                    if (iTmCnt % 60 > 0) dur += (iTmCnt % 60) + " sec(s)";

                    $("#ScanProg").html("Scanning..." + dur + "");
                    startCounter();
                }

            }, 1000);
        }

        function updateScanTable() {
            $("#ScanTable").load("data/dScanTable.ashx?poiid=" + poiid + "&r=" + rid());

        }
        function loadScanTable() {
            // window.open("data/dScanTable.ashx?poiid="+poiid);
            updateScanTable();
            chkExistsScan();
            setTimeout(function () {
                loadScanTable();
            }, 3 * 1000);

        }
        ////

        function dispChartM(scanID, div) {
            $.ajax({
                type: 'POST',
                url: "../fms/data/dscandata.ashx",
                data: {
                    scanID: scanID
                },
                cache: false,
                dataType: 'json',
                success: function (data) {
                    $("#prog-content").hide();
                    $("#result-content").show();
                    $("#scan-button").show();
                    // $("#fre-container").html("dsfdsf");
                    // return;

                    Highcharts.stockChart(div, {
                        credits: { enabled: false },
                        chart: {
                            backgroundColor: "#eeeeee"
                        },
                        navigator: {
                            xAxis: { labels: { formatter: function () { return (this.value / 1000000.0).toFixed(4); } } }
                        },

                        rangeSelector: {
                            selected: 1,
                            enabled: false

                        },
                        yAxis: { title: { text: "Signal (dBm)" } },
                        xAxis: { title: { text: "Frequency (MHz)" }, labels: { formatter: function () { return (this.value / 1000000.0).toFixed(4); } } },
                        tooltip: {
                            formatter: function () {
                                var s = '<b>' + (this.x / 1000000.0).toFixed(4) + 'MHz</b>';

                                $.each(this.points, function (i, point) {
                                    s += '<br/>' + point.series.name + ': ' +
                                        point.y + 'dBm';
                                });

                                return s;
                            }
                        },
                        title: {
                            text: ''
                        },

                        series: [{
                            name: 'Signal',
                            data: data,
                            tooltip: {
                                valueDecimals: 2
                            },
                            point: {
                                events: {
                                    click: function () {
                                        // this.category
                                        setManual(this.category);
                                    }
                                }
                            }


                        }]
                    });
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }

            });
        }
    </script>
</head>
<body>
    <div class="afms-sec-container">
        <!--#include file="../_inc/Hd.asp"-->

        <div class="afms-sec-breadcrumb">
            <ul>
                <li><a href="" class="afms-ic_home"></a><span class="afms-ic_next"></span></li>
                <li><a href="">FMS</a> <span class="afms-ic_next"></span></li>
                <li>Frequency Monitoring</li>
            </ul>
        </div>

        <div class="row afms-sec-content">
            <!--#include file="../FMS/Menu.asp"-->

            <%
                if (Request["poiid"] == null)
                {
                    if (tbSTN.Rows.Count == 0)
                        Response.Redirect("FSch.aspx");

                    //Response.Redirect("FMon.aspx?poiid=" + tbSTN.Rows[tbSTN.Rows.Count - 1]["PoiID"]);
                    Response.Redirect("FMon0.aspx");

                }
                else
                {
                    for (int i = 0; i < tbSTN.Rows.Count; i++)
                    {
                        if (tbSTN.Rows[i]["PoiID"].ToString() == Request["poiid"])
                            drSTN = tbSTN.Rows[i];
                    }
                    if (drSTN == null)
                        Response.Redirect("../FMon0.aspx");

                    if (drSTN["EquType"].ToString() == "STN2")
                        Response.Redirect("FMon2.aspx?poiid=" + Request["poiid"]);

                } %>
            <div class="col-md-12">
                <div id="audio"></div>
                <div class="afms-content" id="station<%=drSTN["PoiID"] %>">
                    <div class="afms-page-title">
                        <i class="afms-ic_record"></i><%=drSTN["Name"] %>
                        <div class="pull-right">Time to operate: <span class="OprTime">-</span> <i class="is-lock"></i></div>
                    </div>
                    <div class="afms-station-shortstatus" data-toggle="modal" data-target="#fullStatus">
                        Sensor Monitor : <span class="text-com">Communication : <span class="3G"></span></span>| <span class="text-ups">UPS : <span class="UPSPc"></span>% [<span class="UPSTime"></span> Min Left]</span> | <span class="text-scan">Scanner : <span class="SCN"></span></span>| <span class="text-power">Power : Plug</span> | <span class="text-sensor">Environment : <span class='TempStat'></span></span>
                    </div>

                    <div class="modal fade" id="fullStatus" tabindex="-1" role="dialog" aria-labelledby="fullStatusLabel">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close afms-ic_close" data-dismiss="modal" aria-label="Close"></button>
                                    <h4 class="modal-title" id="fullStatusLabel">Sensor Monitor</h4>
                                </div>
                                <div class="modal-body">
                                    <div class="row">
                                        <div class="col-md-6 col-sm-6">
                                            <div class="panel panel-default afms-station-status panel-power" style="height: 205px">
                                                <div class="panel-heading">Power meter : Plug</div>
                                                <div class="panel-body">
                                                    <p><b>Voltage :</b> <span class='Voltage'>-</span> Volt</p>
                                                    <p><b>Current :</b> <span class='Current'>-</span> Amp</p>
                                                    <p><b>Frequency :</b> <span class='Frequency'>-</span> Hz</p>
                                                    <p><b>Positive Active Energy :</b> <span class='PAE'>-</span></p>
                                                </div>
                                            </div>

                                            <div class="panel panel-default afms-station-status panel-com">
                                                <div class="panel-heading">Communication</div>
                                                <div class="panel-body">
                                                    <div class="row">
                                                        <div class="col-md-6 col-sm-6">
                                                            <p><b>3G :</b> <span class='3G'>-</span></p>
                                                            <p><b>LAN :</b> <span class='LAN'>-</span></p>
                                                            <p><b>WAN :</b> <span class='WAN'>-</span></p>
                                                        </div>
                                                        <div class="col-md-6 col-sm-6">
                                                            <p><b>GPS :</b> <span class='GPS'>-</span></p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6 col-sm-6">
                                            <div class="panel panel-default afms-station-status panel-ups">
                                                <div class="panel-heading">UPS : <span class='UPSPc'>-</span>%</div>
                                                <div class="panel-body">
                                                    <p><b>Time to operate :</b> <span class='UPSTime'>-</span> Minutes</p>
                                                </div>
                                            </div>

                                            <div class="panel panel-default afms-station-status panel-scaner">
                                                <div class="panel-heading">Scanner : <span class='AtennaStat'></span></div>
                                                <div class="panel-body">
                                                    <p><b>Antenna :</b> <span class='Atenna'></span></p>
                                                </div>
                                            </div>

                                            <div class="panel panel-default afms-station-status panel-sensor">
                                                <div class="panel-heading">Environment : <span class='TempStat'></span></div>
                                                <div class="panel-body">
                                                    <p><b>Humidity :</b> <span class='Humidity'>-</span>%</p>
                                                    <p><b>Temp :</b> <span class='Temp'>-</span> Celcius</p>
                                                    <p><b>Security :</b> <span class='Security'>Door Close</span></p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="collapse in" id="searchSection">

                        <div class="row">
                            <div class="col-md-12">
                                <div class="afms-field afms-field_radio radio-toggle">
                                    Scan Mode
									<label class="radio-inline radio-mode_now">
                                        <input type="radio" id="ScanType_N" name="ScanType" value="option1" checked>
                                        <div class="box"></div>
                                        <div class="check"></div>
                                        Scan Now
                                    </label>

                                    <label class="radio-inline radio-mode_schd">
                                        <input type="radio" id="ScanType_S" name="ScanType" value="option2">
                                        <div class="box"></div>
                                        <div class="check"></div>
                                        Scan Schedule
                                    </label>


                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="afms-field afms-field_datetimepicker">
                                    <label>Schedule Start Time</label>
                                    <input id="DtStart" runat="server" type="text" placeholder="DD/MM/YYYY HH:mm">
                                    <span class="bar"></span>
                                    <i class="afms-ic_date"></i>
                                </div>
                            </div>

                            <div class="col-md-12">
                                Scanning Time Table
                            <div id="ScanTable" class="afms-sec-table"></div>
                                <br />
                                <br />
                            </div>

                        </div>



                        <div class="row">
                            <div class="col-md-4">
                                <div class="afms-field afms-field_radio radio-toggle">
                                    Mode
									<label class="radio-inline radio-mode_auto">
                                        <input type="radio" id="mode_auto" name="mode" value="option1" checked>
                                        <div class="box"></div>
                                        <div class="check"></div>
                                        Scanning
                                    </label>

                                    <label class="radio-inline radio-mode_manual">
                                        <input type="radio" id="mode_manual" name="mode" value="option2">
                                        <div class="box"></div>
                                        <div class="check"></div>
                                        Listening
                                    </label>
                                </div>
                                <button class="afms-btn afms-btn-hidescanning" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">ซ่อน</button>
                            </div>

                            <div class="col-md-8">
                                <div class="afms-field afms-field_radio radio-toggle text-right">

                                    <button class="afms-btn afm-reset-voice">Reset Voice</button>

                                    &nbsp; 
                                    <button class="afms-btn  afm-reset-scanner">Reset Scanner</button>
                                </div>
                            </div>

                            <div class="col-md-3 col-sm-6">
                                <div class="afms-field afms-field_select">
                                    <label for="">Redio Mode</label>
                                    <select id="RadMode" runat="server">
                                        <option value="0">AM</option>
                                        <option value="1">AMS</option>
                                        <option value="7">FM</option>
                                        <option value="8" selected>FMW</option>
                                    </select>
                                    <span class="bar"></span>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="afms-field afms-field_select">
                                    <label for="">DDC1</label>
                                    <select id="DDC1" runat="server">
                                        <option value="0">20 kHz</option>
                                        <option value="1">24 kHz</option>
                                        <option value="2">32 kHz</option>
                                        <option value="3">40 kHz</option>
                                        <option value="4">50 kHz</option>
                                        <option value="5">64 kHz</option>
                                        <option value="6">80 kHz</option>
                                        <option value="7">100 kHz</option>
                                        <option value="8">125 kHz</option>
                                        <option value="9">160 kHz</option>
                                        <option value="10">200 kHz</option>
                                        <option value="11" selected>250 kHz</option>
                                        <option value="12">320 kHz</option>
                                        <option value="13">400 kHz</option>
                                        <option value="14">500 kHz</option>
                                        <option value="15">640 kHz</option>
                                        <option value="16">800 kHz</option>
                                        <option value="17">1 MHz</option>
                                        <option value="18">1.25 MHz</option>
                                        <option value="19">1.6 MHz</option>
                                        <option value="20">2 MHz</option>
                                        <option value="21">2.5 MHz</option>
                                        <option value="22">3.2 MHz</option>
                                        <option value="23">4 MHz</option>
                                    </select>
                                    <span class="bar"></span>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <div class="afms-field afms-field_select">
                                    <label for="">DDC2</label>
                                    <select id="DDC2" runat="server">
                                        <option value="0">20 kHz</option>
                                        <option value="1">24 kHz</option>
                                        <option value="2">32 kHz</option>
                                        <option value="3">40 kHz</option>
                                        <option value="4">50 kHz</option>
                                        <option value="5">64 kHz</option>
                                        <option value="6">80 kHz</option>
                                        <option value="7">100 kHz</option>
                                        <option value="8">125 kHz</option>
                                        <option value="9">160 kHz</option>
                                        <option value="10">200 kHz</option>
                                        <option value="11" selected>250 kHz</option>
                                        <option value="12">320 kHz</option>
                                    </select>
                                    <span class="bar"></span>
                                </div>
                            </div>
                             <div class="col-md-3 col-sm-6">
                                    <div class="afms-field afms-field_input">
                                        <label for="">Demodulator Filter Bandwidth</label>
                                        <input type="text" id="DFBw" value="250000" />
                                        <span class="bar"></span>
                                    </div>
                                </div>


                            <div class="afma-mode_auto">
                                <div class="col-md-3 col-sm-6">
                                    <div class="afms-field afms-field_spinner">
                                        <label for="">Start Frequency (MHz)</label>
                                        <input type="text" id="fFreq" value="88.00">
                                        <span class="bar"></span>
                                    </div>
                                </div>
                                <div class="col-md-3 col-sm-6">
                                    <div class="afms-field afms-field_spinner">
                                        <label for="">Stop Frequency (MHz)</label>
                                        <input type="text" id="tFreq" value="108.00">
                                        <span class="bar"></span>
                                    </div>
                                </div>
                                <div class="col-md-3 col-sm-6" style='display: none'>
                                    <div class="afms-field afms-field_select">
                                        <label for="">RBW</label>
                                        <select id="RBW">
                                            <option value="0">48.8 kHz</option>
                                            <option value="1">24.4 kHz</option>
                                            <option value="2">12.2 kHz</option>
                                            <option value="3">6.1 kHz</option>
                                            <option value="4">3.1 kHz</option>
                                            <option value="5">1.5 kHz</option>
                                        </select>
                                        <span class="bar"></span>
                                    </div>
                                </div>


                                <div class="col-md-3 col-sm-6">
                                    <div class="afms-field afms-field_select">
                                        <label for="">Channel Spacing</label>
                                        <select id="ChSp" runat="server">
                                            <option value="12500">12.5 kHz</option>
                                            <option value="25000" selected>25.0 kHz</option>
                                            <option value="200000">200.0 kHz</option>
                                            <option value="250000">250.0 kHz</option>
                                            <option value="1000000">1.0 MHz</option>
                                            <option value="7000000">7.0 MHz</option>
                                            <option value="8000000">8.0 MHz</option>
                                        </select>
                                        <span class="bar"></span>
                                    </div>
                                </div>

                                <div class="col-md-3 col-sm-6">
                                    <div class="afms-field afms-field_spinner">
                                        <label for="">Threshold (-dBm)</label>
                                        <input type="text" id="Threshold" value="70.00" />
                                        <span class="bar"></span>
                                    </div>
                                </div>
                                <div class="col-md-1 col-sm-6  content-readonly">
                                    <div class="afms-field afms-field_select">
                                        <label for="">Duration</label>

                                    </div>
                                </div>

                                <div class="col-md-1 col-sm-6">
                                    <div class="afms-field afms-field_select">
                                        <label for="">Hr</label>
                                        <select id="nHr" runat="server">
                                        </select>
                                        <span class="bar"></span>
                                    </div>
                                </div>
                                <div class="col-md-1 col-sm-6">
                                    <div class="afms-field afms-field_select">
                                        <label for="">: Min</label>
                                        <select id="nMin" runat="server">
                                        </select>
                                        <span class="bar"></span>
                                    </div>
                                </div>
                                <div class="col-md-1 col-sm-6">
                                    <div class="afms-field afms-field_select">
                                        <label for="">: Sec</label>
                                        <select id="nSec" runat="server">
                                        </select>
                                        <span class="bar"></span>
                                    </div>
                                </div>


                                <div class="col-md-3 col-sm-6" style='display: none'>
                                    <div class="afms-field afms-field_select">
                                        <label for="">Value</label>
                                        <select id="Value" runat="server">
                                            <option value="Avg">Average</option>
                                            <option value="Min">Mininum</option>
                                            <option value="Max">Maximum</option>
                                        </select>
                                        <span class="bar"></span>
                                    </div>
                                </div>
                                <div class="col-md-12 text-center">
                                    <div style='display: none'>
                                        <button class="afms-btn afms-btn-sec afms-btn-advfilter" type="button" data-toggle="collapse" data-target="#advanceFilter" aria-expanded="false" aria-controls="advanceFilter">
                                            <i class="afms-ic_filter"></i>Advance Filter
                                        </button>
                                    </div>

                                    <button id="scan-button" class="afms-btn afms-btn-primary" onclick="doScan()">
                                        <i class="afms-ic_radar"></i>Scanning
                                    </button>

                                    <button id="schd-button" class="afms-btn afms-btn-primary" onclick="doSchd()">
                                        <i class="afms-ic_radar"></i>Add Schedule
                                    </button>

                                    <div style='display: none'>

                                        <div class="collapse" id="advanceFilter">
                                            <div class="row">
                                                <div class="col-md-3 col-sm-6">
                                                    <div class="afms-field afms-field_spinner">
                                                        <label for="">Start Frequency (MHz)</label>
                                                        <input type="text" name="startFrequency" value="100.00">
                                                        <span class="bar"></span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>

                            <div class="afma-mode_manual" style="display: none;">
                                <div class="col-md-3">
                                    <div class="afms-field afms-field_spinner">
                                        <label for="">Set Frequency (MHz)</label>
                                        <input type="text" id="MFreq" value="100.00">
                                        <span class="bar"></span>
                                    </div>
                                </div>
                                <div class="col-md-1 col-sm-6  content-readonly">
                                    <div class="afms-field afms-field_select">
                                        <label for="">Duration</label>

                                    </div>
                                </div>

                                <div class="col-md-1 col-sm-6">
                                    <div class="afms-field afms-field_select">
                                        <label for="">Hr</label>
                                        <select id="MnHr" runat="server">
                                        </select>
                                        <span class="bar"></span>
                                    </div>
                                </div>
                                <div class="col-md-1 col-sm-6">
                                    <div class="afms-field afms-field_select">
                                        <label for="">: Min</label>
                                        <select id="MnMin" runat="server">
                                        </select>
                                        <span class="bar"></span>
                                    </div>
                                </div>
                                <div class="col-md-1 col-sm-6">
                                    <div class="afms-field afms-field_select">
                                        <label for="">: Sec</label>
                                        <select id="MnSec" runat="server">
                                        </select>
                                        <span class="bar"></span>
                                    </div>
                                </div>
                                <div id="iAudio" class="col-md-3" style='display: none'>
                                    <iframe width="150" height="40" frameborder="0"></iframe>
                                </div>
                                <div class="col-md-12 text-center">
                                    <button id='scan-button-M' class="afms-btn afms-btn-primary" onclick="doTunning()">
                                        <i class="afms-ic_tune"></i>Tunning
                                    </button>

                                    <button id="schd-button-M" class="afms-btn afms-btn-primary" onclick="doSchdM()">
                                        <i class="afms-ic_tune"></i></i>Add Schedule
                                    </button>

                                    <button class="afms-btn afms-btn-secondary afms-btn-record is-active" style="width: auto; display: none">
                                        <i class="afms-ic_record"></i>REC
                                    </button>

                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="text-center">
                        <button class="afms-btn afms-btn-primary afms-btn-editscanning" role="button" data-toggle="collapse" href="#searchSection" aria-expanded="true" aria-controls="searchSection">แก้ไขการสแกน</button>
                    </div>
                </div>

                <div id="prog-content" class="afms-content" style="margin-top: 20px; display: none">
                    <div class="row">
                        <div class="afms-frequency-no" style='text-align: center'>
                            <img src='../_inc/css/throbber.gif' width="50" />
                            <span id="ScanProg">Scanning...</span>
                        </div>
                    </div>
                </div>
                <div id="result-content" class="afms-content" style="margin-top: 20px; display: none">

                    <div class="row">
                        <div class="col-md-12">
                            <div class="row">
                                <div style='display: none'>
                                    <div class="afma-mode_auto">
                                        <h3 class="col-md-12">Record Station</h3>
                                        <div class="col-md-3">
                                            <div class="afms-field afms-field_spinner">
                                                <label for="">DDC1 (KHz)</label>
                                                <input type="text" name="startFrequency" value="100.00">
                                                <span class="bar"></span>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="afms-field afms-field_spinner">
                                                <label for=""></label>
                                                <input type="text" name="startFrequency" value="100.00">
                                                <span class="bar"></span>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="afms-field afms-field_spinner">
                                                <label for="">AVG (s)</label>
                                                <input type="text" name="startFrequency" value="100.00">
                                                <span class="bar"></span>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <button class="afms-btn afms-btn-secondary afms-btn-record is-active" style="margin-top: 13px"><i class="afms-ic_record"></i>REC</button>
                                        </div>
                                    </div>

                                    <div class="col-md-12 text-center afms-frequency-no">
                                        <button class="afms-btn afms-btn-primary afms-btn-play afms-ic_play"></button>
                                        222.25 MHz <span>(Scanning...)</span>
                                    </div>

                                    <div class="col-md-6 afms-frequency-monitor" style='display: none'>
                                        <div class="afms-frequency"></div>
                                    </div>

                                    <div class="col-md-6 afms-frequency-monitor" style='display: none'>
                                        <div class="afms-frequency"></div>
                                    </div>
                                </div>
                                <div class="col-md-12 afms-frequency-monitor">
                                    <div id="fre-container" style="height: 400px; min-width: 310px"></div>
                                </div>

                                <div class="col-md-12 afms-group-btn text-center">
                                    <a id="aEvent" href="" class="afms-btn afms-btn-secondary" target="_blank">EVENT</a>
                                    <a id="aOcc" href="" class="afms-btn afms-btn-secondary" target="_blank">Occupancy vs Channel</a>
                                    <a id="aFStr" href="" class="afms-btn afms-btn-secondary" target="_blank">Field Strangth vs Channel</a>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <div class="afms-push"></div>
    </div>

    <!--#include file="../_inc/Ft.asp"-->
</body>

</html>
