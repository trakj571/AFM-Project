$(function () {

    if ('ontouchstart' in document.documentElement) { // or whatever "is this a touch device?" test we want to use
        $('body').css('cursor', 'pointer');
    }

    var windowHeight = $(window).height();
    var windowWidth = $(window).width();

    var headerHeight = 74;
    var maptoolsHeight = $('.afms-sec-maptools').outerHeight() + 1;
    var slidebarWidth = $('.afms-page-cop .afms-sec-sidebar').outerWidth();
    var mapeventWidth = $('.afms-sec-mapevent').outerWidth();

    $('.afms-sec-map').css('padding-top', maptoolsHeight - 10);

    if ($(document).height() > windowHeight) {
        $('.afms-sec-container').css('margin-bottom', '-34px');
    }

    var mapHeight = $('.afms-page-cop .afms-sec-map').outerHeight();
    $('body').height(window.innerHeight);

    $('.afms-sec-mapsensor').width(windowWidth - slidebarWidth - mapeventWidth - 10);


    var elementHeights = $('.afms-mapsensor-box .panel-body').map(function () {
        return $(this).height();
    }).get();
    var maxHeight = Math.max.apply(null, elementHeights);
    $('.afms-mapsensor-box .panel-body').height(maxHeight);


    var mapsensorHeight = $('.afms-sec-mapsensor').outerHeight();
    $('.afms-sec-mapsensor').css('bottom', -mapsensorHeight);

    $('.afms-page-cop .afms-btn-display').click(function (e) {
        $('.afms-sec-mapevent , .afms-sec-mapinfo , .afms-sec-mapstreet , .afms-sec-mapsensor').addClass('is-active');

        //console.log('display')

        var mapEventHeight = (windowHeight - headerHeight - maptoolsHeight) / 3;

        if (windowHeight < 600 && windowWidth > 800) {
            $('.afms-sec-mapevent').css({
                'top': maptoolsHeight - 2,
                'height': windowHeight - headerHeight - maptoolsHeight + 10
            });

            $('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - 320);

            //console.log('เคส')
        } else if (windowHeight > 600 && windowWidth > 800) {
            $('.afms-sec-mapevent').css({
                'top': maptoolsHeight - 2,
                'height': mapEventHeight
            });
            $('.afms-sec-mapevent .afms-wrapper').css({
                'height': mapEventHeight - 43
            });

            $('.afms-sec-mapinfo').css({
                'top': mapEventHeight + maptoolsHeight - 2,
                'height': mapEventHeight
            });
            $('.afms-sec-mapinfo .afms-wrapper').css({
                'height': mapEventHeight - 43
            });

            $('.afms-sec-mapstreet').css({
                'top': (mapEventHeight * 2) + maptoolsHeight - 2,
                'height': mapEventHeight + 2
            });

            //console.log('เคส1')
        } else if (windowHeight > 600 && (windowWidth <= 800 && windowWidth > 600)) {
            $('.afms-sec-mapevent').css({
                'top': maptoolsHeight - 2,
                'height': windowHeight - headerHeight - maptoolsHeight + 10
            });

            $('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - 420);

            //console.log('เคส2')
        } else if (windowHeight > 600 && (windowWidth <= 600)) {
            $('.afms-sec-mapevent').css({
                'height': windowHeight - headerHeight - maptoolsHeight + 10
            });

            $('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - 317);

            //console.log('เคส3')
        } else if (windowHeight < 600 && (windowWidth <= 600)) {
            $('.afms-sec-mapevent').css({
                'height': windowHeight - headerHeight - maptoolsHeight + 10
            });

            $('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - 317);

            //console.log('เคส4')
        }

        $(this).tooltip('hide');
    });


    if (windowWidth <= 420) {
        $('.afms-sec-maptools').css({
            width: windowWidth
        });
    }

    if (windowWidth > 992) {
        $('.afms-content .collapse:not(#advanceFilter)').addClass('in');
        $('.afms-sec-sidebar .collapse:not(#advanceFilter)').addClass('in');
    } else {
        $('.afms-content .collapse').addClass('in');
        $('.afms-sec-sidebar .collapse').removeClass('in');
    }

    $('.afms-sec-mapevent .afms-btn-close').click(function (e) {
        $('.afms-sec-mapevent').removeClass('is-active');
    });

    $('.afms-sec-mapinfo .afms-btn-close').click(function (e) {
        $('.afms-sec-mapinfo').removeClass('is-active');
    });

    $('.afms-sec-mapstreet .afms-btn-close').click(function (e) {
        $('.afms-sec-mapstreet').removeClass('is-active');
    });

    $('.afms-sec-mapsensor .afms-btn-close').click(function (e) {
        $('.afms-sec-mapsensor').removeClass('is-active');
    });

    var slidebarHeight = $('.afms-page-cop .afms-sec-sidebar').outerHeight() - 42;

    $('.afms-page-cop .afms-sec-sidebar > .tab-content').height(slidebarHeight - 75);

    $('.radio-searchtype_detail').click(function (e) {
        $('.afms-searchtype_detail').show();
        $('.afms-searchtype_direction').hide();
    });

    $('.radio-searchtype_direction').click(function (e) {
        $('.afms-searchtype_direction').show();
        $('.afms-searchtype_detail').hide();
    });

    $('.afms-sec-container:not(.afms-page-cop) .afms-sec-sidebar .afms-btn-hide').click(function (e) {
        $('.afms-sec-sidebar').toggleClass('is-hide');
        $('.afms-sec-content').toggleClass('is-hide');
    });

    $('.afms-page-cop .afms-sec-sidebar .afms-btn-hide').click(function (e) {
        $('.afms-page-cop .afms-sec-sidebar').toggleClass('is-hide');
        $('.afms-page-cop .afms-sec-content').toggleClass('is-active');



        if ($('.afms-page-cop .afms-sec-sidebar').hasClass('is-hide')) {
            $('.afms-page-cop .afms-sec-mapsensor').width(windowWidth - mapeventWidth - 10);
        } else {
            $('.afms-page-cop .afms-sec-mapsensor').width(windowWidth - slidebarWidth - mapeventWidth - 10);
        }

        setTimeout(function () {
            var maptoolsHeight = $('.afms-page-cop .afms-sec-maptools').outerHeight() + 1;
            //console.log(maptoolsHeight);      

            $('.afms-page-cop .afms-sec-mapevent').height(mapHeight - maptoolsHeight + 4);
            $('.afms-page-cop .afms-sec-mapevent .afms-wrapper').height(mapHeight - maptoolsHeight - 339);

            $('.afms-sec-map').css('padding-top', maptoolsHeight - 10);
        }, 300);
    });


    $(window).resize(function (e) {
        var windowHeight = $(window).height();
        var windowWidth = $(window).width();

        var headerHeight = $('.afms-page-cop .afms-sec-header').outerHeight() + 1;
        var maptoolsHeight = $('.afms-sec-maptools').outerHeight() + 1;
        var slidebarWidth = $('.afms-page-cop .afms-sec-sidebar').outerWidth();
        var mapeventWidth = $('.afms-sec-mapevent').outerWidth();

        $('.afms-sec-map').css('padding-top', maptoolsHeight - 10);

        $('.afms-page-cop .afms-sec-sidebar').height(windowHeight - headerHeight);
        $('.afms-page-cop .afms-sec-map').height(windowHeight - headerHeight);

        var mapHeight = $('.afms-page-cop .afms-sec-map').outerHeight();

        $('body').height(window.innerHeight);

        var slidebarHeight = $('.afms-page-cop .afms-sec-sidebar').outerHeight() - 42;
        $('.afms-page-cop .afms-sec-sidebar > .tab-content').height(slidebarHeight - 75);

        $('.afms-sec-mapsensor').width(windowWidth - slidebarWidth - mapeventWidth - 10);

        var mapEventHeight = (windowHeight - headerHeight - maptoolsHeight) / 3;

        if (windowHeight < 600 && windowWidth > 800) {
            $('.afms-sec-mapevent').css({
                'top': maptoolsHeight - 2,
                'height': windowHeight - headerHeight - maptoolsHeight + 10
            });

            $('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - 320);

            //console.log('เคส')
        } else if (windowHeight > 600 && windowWidth > 800) {
            $('.afms-sec-mapevent').css({
                'top': maptoolsHeight - 2,
                'height': mapEventHeight
            });
            $('.afms-sec-mapevent .afms-wrapper').css({
                'height': mapEventHeight - 43
            });

            $('.afms-sec-mapinfo').css({
                'top': mapEventHeight + maptoolsHeight - 2,
                'height': mapEventHeight
            });
            $('.afms-sec-mapinfo .afms-wrapper').css({
                'height': mapEventHeight - 43
            });

            $('.afms-sec-mapstreet').css({
                'top': (mapEventHeight * 2) + maptoolsHeight - 2,
                'height': mapEventHeight + 2
            });

            //console.log('เคส1')
        } else if (windowHeight > 600 && (windowWidth <= 800 && windowWidth > 600)) {
            $('.afms-sec-mapevent').css({
                'top': maptoolsHeight - 2,
                'height': windowHeight - headerHeight - maptoolsHeight + 10
            });

            $('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - 420);

            //console.log('เคส2')
        } else if (windowHeight > 600 && (windowWidth <= 600)) {
            $('.afms-sec-mapevent').css({
                'height': windowHeight - headerHeight - maptoolsHeight + 10
            });

            $('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - 317);

            //console.log('เคส3')
        } else if (windowHeight < 600 && (windowWidth <= 600)) {
            $('.afms-sec-mapevent').css({
                'height': windowHeight - headerHeight - maptoolsHeight + 10
            });

            $('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - 317);

            //console.log('เคส4')
        }

        if (windowWidth <= 420) {
            $('.afms-sec-maptools').css({
                width: windowWidth
            });
        } else {
            $('.afms-sec-maptools').css({
                width: 100 + '%'
            });
        }

        if (windowWidth > 992) {
            //$('.afms-content .collapse:not(#advanceFilter)').addClass('in');
            $('.afms-sec-sidebar .collapse:not(#advanceFilter)').addClass('in');
            //console.log('dddd');
        } else {
            //$('.afms-content .collapse').addClass('in');
            $('.afms-sec-sidebar .collapse').removeClass('in');
        }
    });


    $('.afms-btn-menu').click(function (e) {
        $('.afms-sec-container').toggleClass('is-wrap');
        $('body').toggleClass('is-hidden');
    });

    $('.afms-btn-search , .afms-btn-add , .afms-btn-scanning').click(function (e) {
        $('.afms-btn-editscanning').show();
        $('.afms-btn-editsearch').show();
        $('.afms-btn-hidesearch').hide();
    });
    $('.afms-btn-editsearch').click(function (e) {
        $(this).hide();
        $('.afms-btn-hidesearch').show();
    });
    $('.afms-btn-hidesearch').click(function (e) {
        $(this).hide();
        $('.afms-btn-editsearch').show();
    });
    $('.afms-btn-editscanning').click(function (e) {
        $(this).hide();
        $('.afms-btn-hidescanning').show();
    });
    $('.afms-btn-hidescanning').click(function (e) {
        $(this).hide();
        $('.afms-btn-editscanning').show();
    });

    $('.afms-sidebar-title , .afms-sec-sidebar #sidebarFreqDb > ul > li > a').click(function (e) {
        $(this).toggleClass('is-collapse');
    });

    $('.radio-mode_auto').click(function (e) {
        $('.afma-mode_auto').show();
        $('.afma-mode_manual').hide();
    });

    $('.radio-mode_manual').click(function (e) {
        $('.afma-mode_manual').show();
        $('.afma-mode_auto').hide();
    });

    $('.afms-btn-delete').click(function (e) {
        swal({
            title: 'ต้องการลบข้อมูล',
            text: "หากลบข้อมูลแล้ว จะไม่สามารถกู้คืนได้",
            type: 'warning',
            width: 440,
            showCancelButton: true,
            cancelButtonText: 'ยกเลิก',
            confirmButtonText: 'ใช่ ! ลบข้อมูลเลย'
        }).then(function () {
            swal({
                title: 'ลบข้อมูล!',
                text: 'ข้อมูลถูกลบเรียบร้อยแล้ว',
                width: 300,
                type: 'success',
                showConfirmButton: false,
                timer: 3000
            }).then(
				function () { },
				function (dismiss) {
				}
			)
        });
    });
    //////
});