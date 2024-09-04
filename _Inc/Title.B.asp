<%@ Import NameSpace="System.Web"%>
<%@ Import NameSpace="System.Data"%>
<%@ Import NameSpace="System.Data.SqlClient"%>
<%@ Import NameSpace="System.Configuration"%>
<%@ Import NameSpace="System.IO"%>
<%@ Import NameSpace="System.Drawing"%>
<%@ Import NameSpace="System.Net"%>
<%@ Import NameSpace="System.Web.Script.Serialization"%>
<%@ Import NameSpace="EBMSMap30"%>

<title>NBTC AUTOMATIC FREQUENCY MONITORING SYSTEM</title>
    <link rel="shortcut icon" href="../img/favicon.ico" />
	
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="format-detection" content="telephone=no">
	<link href="https://fonts.googleapis.com/css?family=Kanit:300,400,500,600&amp;subset=thai" rel="stylesheet">
    <link rel="stylesheet" href="../_inc/icon/style.css?v1">
	<link rel="stylesheet" href="../_inc/css/normalize.css">
	<link rel="stylesheet" href="../_inc/css/reset.css">
	<link rel="stylesheet" href="../_inc/css/bootstrap.css">
	<link rel="stylesheet" href="../_inc/css/style.css?v2">
    <link rel="stylesheet" href="../_inc/css/jstree.css">
	<link rel="stylesheet" href="../_inc/css/responsive.css">
    <link rel="stylesheet" href="../_inc/css/bootstrap-touchspin.css">
	<link rel="stylesheet" href="../_inc/css/bootstrap-select.css">
    <link rel="stylesheet" href="../_inc/css/sweetalert2.css">
    <link rel="stylesheet" href="../_inc/css/lightgallery.css">
    	<link rel="stylesheet" href="../_inc/css/bootstrap-datetimepicker.css">
    <link rel="stylesheet" href="../_inc/css/fm-style.css">

   
    <script type="text/javascript" src="../_inc/js/jquery-3.2.0.min.js"></script>
    <script type="text/javascript" src="../_inc/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../_inc/js/bootstrap-select.js"></script>
    <script type="text/javascript" src="../_inc/js/bootstrap-datepicker.js"></script>
     <script type="text/javascript" src="../_inc/js/bootstrap-datetimepicker.js"></script>
    
    <script type="text/javascript" src="../_inc/js/core.js"></script>
    <script type="text/javascript" src="../_inc/js/sweetalert2.js"></script>

    <script type="text/javascript" src="../_inc/js/function.js"></script>
    <script src="../_inc/js/bootstrap-touchspin.js"></script>
    <script src="../_inc/js/lightgallery.js"></script>
    

    <script language=c# runat=server>
        public string getBackURL(string Q)
        {
            var nameValues = HttpUtility.ParseQueryString(Request.QueryString.ToString());
            nameValues.Remove(Q.ToLower());
            string pageUrl = nameValues.ToString();

            return pageUrl == "" ? "" : "?"+pageUrl;
        }
         public string getDetURL(string Q)
        {
            var nameValues = HttpUtility.ParseQueryString(Request.QueryString.ToString());
            nameValues.Remove(Q.ToLower());
            string pageUrl = nameValues.ToString();
            if(pageUrl=="")
                return "?"+Q;

            return "?"+pageUrl+"&"+Q;
        }
    </script>

    <style>
        .valid{color:Red;margin-bottom:20px}
        .content-readonly > h2 { padding-right: 80px; }
        .content-readonly .afms-field {  border-bottom: 0; margin: 0; margin-bottom: 10px; }
        .content-readonly .afms-field .afms-field-title { color: #922d35; font-weight: 500; margin-bottom: 5px; }
        .content-readonly .afms-field .afms-ic_calendar { bottom: 2px; }
        .content-readonly .afms-field_datepicker p:not(.nbtc-field-title) { padding-left: 24px; }


        .afms-pagination { margin-top: 20px; text-align: center; }
        .afms-pagination a { transition: all 0.2s; cursor: pointer; color: #000000; vertical-align: top; display: inline-block; padding: 4px; border: 1px solid #ffffff; width: 30px; height: 30px; margin: 0-3px; }
        .afms-pagination .is-active { border: 1px solid #922d35; background-color: #922d35; color: #ffffff !important; }
        .afms-pagination a:hover { color: #922d35; border: 1px solid #922d35; }
        .afms-pagination .afms-ic_firstpage,
        .afms-pagination .afms-ic_lastpage { font-size: 14px; padding-top: 8px;color:#000 }
        .afms-pagination .afms-ic_prev,
        .afms-pagination .afms-ic_next { font-size: 13px; padding-top: 8px;color:#000 }

        .lg-toolbar .lg-close:after { content: '\e90f'; font-family: 'afms'; }
         
    </style>


    <script language=javascript>
        function msgbox_save(rid, url, t) {
            if (rid > 0)
                swal({
                  title: t ? t : "บันทึกข้อมูลเรียบร้อย",
                  text: "",
                  type: 'success',
                  confirmButtonText: 'ตกลง',
                  confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                }).then(function () {
                    if (!url) return;
                        if (url == 'reload'){
                            reloadPage(false);
                            return;
                        }
                        if (url == 'reload-parent'){
                            reloadPage(true)
                            return;
                        }
                        location.href = url;
                });

            else if (rid == -1)
                swal({
                  title: "Invalid Schedule Start Time",
                  text: "",
                  type: 'warning',
                  confirmButtonText: 'ตกลง',
                  confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                });
             else if (rid == -2)
                swal({
                  title: t ? t : "ข้อมูลซ้ำกับในระบบ",
                  text: "",
                  type: 'warning',
                  confirmButtonText: 'ตกลง',
                  confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                });
                
        }
		function delItem(fn,id,val,reload,isparent){
            swal({
              title: 'ต้องการลบข้อมูลนี้',
              text: "หากลบแล้วจะไม่สามารถกู้คืนได้",
              type: 'warning',
              showCancelButton: true,
              confirmButtonText: 'ลบ',
              cancelButtonText: 'ยกลิก',
              confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
              cancelButtonClass: 'nbtc-btn nbtc-btn-secondary',
            }).then(function () {
              $.ajax({
               type: 'POST',
               url: "data/delItem.ashx",
               data: { sp:fn,id:id,val:val },
               cache: false,
               dataType: 'json',
               success: function (data) {
                   if(data.result=="OK"){
                       swal({
                        title: 'ลบข้อมูลสำเร็จ',
                        text: "ข้อมูลถูกลบแล้ว",
                        type: 'success',
                        confirmButtonText: 'ตกลง',
                        confirmButtonClass: 'nbtc-btn nbtc-btn-primary'
                      }).then(function () {
                        if(isparent){
                            reloadPage(true);
                        }
                        else if(reload){
                            reloadPage(false);
                        }else{
                            location.href = location.href.split('/').pop().split('#')[0].split('?')[0];
                        }
                    });
                  }else{
                      swal({
                        title: 'ลบข้อมูลไม่สำเร็จ',
                        type: 'error',
                        confirmButtonText: 'ตกลง',
                        confirmButtonClass: 'nbtc-btn nbtc-btn-primary'
                      });
                  }
               },
               error: function (XMLHttpRequest, textStatus, errorThrown) {

               }
           });
              
            });
    }				

    var lg;
    function openDialog(src){
        lg = $(this).lightGallery({
                    width: '700px',
                    height: '500px',
                    dynamic: true,
                    mode: 'lg-fade',
                    addClass: 'fixed-size',
                    counter: false,
                    download: false,
                    startClass: '',
                    enableSwipe: false,
                    enableDrag: false,
                    closable: false,
                    dynamicEl: [{
                        "iframe":true,
                        "src": src,
                     }]
                });
       
              
    }
    function openDialog2(src){
        lg = $(this).lightGallery({
                    width: '1000px',
                    height: '600px',
                    dynamic: true,
                    mode: 'lg-fade',
                    addClass: 'fixed-size',
                    counter: false,
                    download: false,
                    startClass: '',
                    enableSwipe: false,
                    enableDrag: false,
                     closable: false,
                    dynamicEl: [{
                        "iframe":true,
                        "src": src,
                     }]
                });
       
              
    }
    function closeDialog(){
        parent.$(".lg-icon").click();
    }

    function reloadPage(isparent){
        if(isparent)
            parent.reloadPage(false);
        else{
            var page_y = $( document ).scrollTop();
            window.location.href = window.location.href;
        }
    }
    function replaceQueryParam(param, newval, search) {
        var regex = new RegExp("([?;&])" + param + "[^&;]*[;&]?");
        var query = search.replace(regex, "$1").replace(/&$/, '');

        return (query.length > 2 ? query + "&" : "?") + (newval ? param + "=" + newval : '');
    }

    <%if(Request["page_y"]!=null){ %>
    $(function(){
        if ( window.location.href.indexOf( 'page_y' ) != -1 ) {
            //gets the number from end of url
            var page_y = '<%=Request["page_y"] %>';

            //sets the page offset 
            $( 'html, body' ).scrollTop( parseInt(page_y) );
        }
    });
    <%} %>



    function printPage() {
        window.open("../Print/PrintPage.aspx");
    }
        function printAll() {
            window.open("../Print/PrintPageAll.aspx");
        }
        function exportXls() {
            var url = location.href;
            if(url.indexOf("?")>-1)
                window.open(url + "&export=xls");
            else
                window.open(url + "?export=xls");
        }
        
        function exportPrint() {
            var url = location.href;
            if(url.indexOf("?")>-1)
                window.open(url + "&export=print");
            else
                window.open(url + "?export=print");
        }



        function dispChart(scanID,div) {
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
                            xAxis: { labels: { formatter: function () { return(this.value / 1000000.0).toFixed(4); } } }
                        },

                        rangeSelector: {
                            selected: 1,
                            enabled: false

                        },
                        yAxis: { title: { text: "Signal (dBm)"} },
                        xAxis: { title: { text: "Frequency (MHz)" }, labels: { formatter: function () { return (this.value / 1000000.0).toFixed(4); } } },
                        tooltip: { formatter: function () {
                            var s = '<b>' + (this.x/1000000.0).toFixed(4) + 'MHz</b>';

                            $.each(this.points, function (i, point) {
                                s += '<br/>' + point.series.name + ': ' +
                                                 (point.y).toFixed(2) + 'dBm';
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
                                        //setManual(this.category);
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



        function dispChartD(scanID,div) {
            $.ajax({
                type: 'POST',
                url: "../dms/data/dscandata.ashx",
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
                            xAxis: { labels: { formatter: function () { return(this.value / 1000000.0).toFixed(2); } } }
                        },

                        rangeSelector: {
                            selected: 1,
                            enabled: false

                        },
                        yAxis: { title: { text: "Signal (dBm)"} },
                        xAxis: { title: { text: "Frequency (MHz)" }, labels: { formatter: function () { return (this.value / 1000000.0).toFixed(2); } } },
                        tooltip: { formatter: function () {
                            var s = '<b>' + (this.x/1000000.0).toFixed(2) + 'MHz</b>';

                            $.each(this.points, function (i, point) {
                                s += '<br/>' + point.series.name + ': ' +
                                                 (point.y).toFixed(2) + 'dBm';
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
                                        //setManual(this.category);
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


        function dispChartM(scanID,div) {
            $.ajax({
                type: 'POST',
                url: "../dms/data/dscandata.ashx?equtype=MOB",
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
                            xAxis: { labels: { formatter: function () { return(this.value).toFixed(0); } } }
                        },

                        rangeSelector: {
                            selected: 1,
                            enabled: false

                        },
                        yAxis: { title: { text: "Signal (dBm)"} },
                        xAxis: { title: { text: "Bearing (Deg)" }, labels: { formatter: function () { return (this.value).toFixed(0); } } },
                        tooltip: { formatter: function () {
                            var s = '<b>' + (this.x).toFixed(0) + 'Deg</b>';

                            $.each(this.points, function (i, point) {
                                s += '<br/>' + point.series.name + ': ' +
                                                 (point.y).toFixed(2) + (point.series.name=="Signal"?"dBm":"");
                            });

                            return s;
                        }
                        },
                        title: {
                            text: ''
                        },

                        series: [{
                            name: 'Signal',
                            data: data.data,
                            tooltip: {
                                valueDecimals: 4
                            },
                            point: {
                                events: {
                                    click: function () {
                                        // this.category
                                        //setManual(this.category);
                                    }
                                }
                            }


                        },
                        {
                            name: 'Quality',
                            data: data.data2,
                            tooltip: {
                                valueDecimals: 2
                            },
                            point: {
                                events: {
                                    click: function () {
                                        // this.category
                                        //setManual(this.category);
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


        function dispChartDO(scanID,div,ndata) {
            $.ajax({
                type: 'POST',
                url: "../dms/data/dscandata.ashx?datatype=O&ndata="+ndata,
                data: {
                    scanID: scanID
                },
                cache: false,
                dataType: 'json',
                success: function (data) {
                    var dataSeries = [];
                    dataSeries.push({
                            name: 'Occupancy Avg',
                            data: data.data,
                            tooltip: {
                                valueDecimals: 2
                            }
                        });
                    if(ndata==12)
                     dataSeries.push({
                            name: 'Occupancy Max',
                            data: data.data2,
                            tooltip: {
                                valueDecimals: 2
                            }
                        });


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
                            xAxis: { labels: { formatter: function () { return(this.value / 1000000.0).toFixed(4); } } }
                        },

                        rangeSelector: {
                            selected: 1,
                            enabled: false

                        },
                        yAxis: { title: { text: "Occupancy (%)"} },
                        xAxis: { title: { text: "Frequency (MHz)" }, labels: { formatter: function () { return (this.value / 1000000.0).toFixed(4); } } },
                        tooltip: { formatter: function () {
                            var s = '<b>' + (this.x/1000000.0).toFixed(4) + 'MHz</b>';

                            $.each(this.points, function (i, point) {
                                s += '<br/>' + point.series.name + ': ' +
                                                 (point.y).toFixed(2) + '%';
                            });

                            return s;
                        }
                        },
                        title: {
                            text: ''
                        },

                        series: dataSeries
                    });
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }

            });
        }
         function rid() {
            var text = "";
            var possible = "0123456789";

            for (var i = 0; i < 8; i++)
                text += possible.charAt(Math.floor(Math.random() * possible.length));

            return text;
        }
    </script>

