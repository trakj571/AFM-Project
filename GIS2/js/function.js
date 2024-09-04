$(document).ready(function () {

    $('.nbtcm-gallery').lightGallery({
        thumbnail:true
    }); 

    $('.nbtcm-maptools button').click(function(){
        if($(this).hasClass('is-active')) {
            $(this).removeClass('is-active');
        } else {
            $('.nbtcm-maptools button').removeClass('is-active');
            $(this).addClass('is-active');
        }
    });

    $('.nbtcm-sidebar-searchresult-heading .nbtcm-btn-back').click(function () {
        $('.nbtcm-sidebar.nbtcm-sidebar-searchresult').removeClass('is-active');
    });

    $('.nbtcm-layer-btn-search, .nbtcm-history-btn-search').click(function () {
        $('.nbtcm-sidebar.nbtcm-sidebar-searchresult:not(.nbtcm-sidebar-searchresult-event)').addClass('is-active');
    });

    $('.nbtcm-sidebar-searchresult-event .nbtcm-sidebar-searchresult-heading .nbtcm-btn-back').click(function () {
        $('.nbtcm-sidebar.nbtcm-sidebar-searchresult-event').removeClass('is-active');
    });

    $('.nbtcm-event-btn-search').click(function () {
        $('.nbtcm-sidebar.nbtcm-sidebar-searchresult-event').addClass('is-active');
    });

    $('.nbtcm-sidebar-btn-toggle').click(function () {
        // $('.nbtcm-sidebar:not(.nbtcm-sidebar-searchresult)').toggleClass('is-hide');
        $(this).parents('.nbtcm-sidebar').toggleClass('is-hide');
        $(this).parents('.nbtcm-sidebar-searchresult-event').toggleClass('is-active');
        console.log('toggle sidebar')
        // $('.nbtcm-sidebar-searchresult.is-active').toggleClass('is-hide');
        if($(window).width() < 767) {
            // $('.nbtcm-backdrop').toggleClass('is-active');
            if($('.nbtcm-backdrop').hasClass('is-active')) {
                $(this).removeClass('is-active')
            } else {
                $(this).addClass('is-active')
            }
        }
        // if($('.nbtcm-sidebar').hasClass('is-hide')) {
        //     $('.nbtcm-backdrop').toggleClass('is-active')
        // }
    });

    $('.nbtcm-btn-menu').click(function () {
        $('.nbtcm-sidebar-menu').toggleClass('is-active');
    });

    $('.nbtcm-btn-display, .nbtcm-btn-focus').click(function () {
        // $('.nbtcm-mapevent, .nbtcm-mapinfo, .nbtcm-mapstreet, .nbtcm-sensormonitor').toggleClass('is-active');
        // console.log('.nbtcm-btn-display')
        // $('.nbtcm-btn-display, .nbtcm-btn-focus').removeClass('is-active');
        // $(this).toggleClass('is-active');

        if($(window).width > 992) {
            if($(this).hasClass('is-active')) {
                console.log('has is-active');
                $(this).removeClass('is-active');
                $('.nbtcm-mapevent, .nbtcm-mapinfo, .nbtcm-mapstreet, .nbtcm-sensormonitor').removeClass('is-active');
            } else {
                console.log('has no is-active');
                $('.nbtcm-btn-display, .nbtcm-btn-focus').removeClass('is-active');
                $(this).addClass('is-active');
                $('.nbtcm-mapevent, .nbtcm-mapinfo, .nbtcm-mapstreet, .nbtcm-sensormonitor').addClass('is-active');
            }   
        } else {
            $('.nbtcm-mapgrouppanel').addClass('is-active')
        }
        if($(window).width() < 767) {
            $('.nbtcm-sidebar').addClass('is-hide');
            $('.nbtcm-backdrop').removeClass('is-active');
        }
    });

    $('.nbtcm-btn--eventviewer').click(function(){
        $('.nbtcm-mappanel.nbtcm-mapevent').addClass('is-active');
    });
    $('.nbtcm-btn--information').click(function(){
        $('.nbtcm-mappanel.nbtcm-mapinfo').addClass('is-active');
    });
    $('.nbtcm-mappanel.nbtcm-mapinfo .nbtcm-sidebar-btn-toggle').click(function(){
        $('.nbtcm-mappanel.nbtcm-mapinfo').toggleClass('is-active');
    });
    $('.nbtcm-btn--sensormonitor').click(function(){
        $('.nbtcm-mappanel.nbtcm-sensormonitor').addClass('is-active');
    });
    $('.nbtcm-btn--streetview').click(function(){
        $('.nbtcm-mappanel.nbtcm-mapstreet').addClass('is-active');
    });
    $('.nbtcm-mappanel.nbtcm-mapstreet .nbtcm-sidebar-btn-toggle').click(function(){
        $('.nbtcm-mappanel.nbtcm-mapstreet').toggleClass('is-active');
    });

    $('.nbtcm-mappanel-btn-close').click(function () {
        $(this).parents('.nbtcm-mappanel').removeClass('is-active');
        // console.log('length: ' + $('.nbtcm-mappanel.is-active').length)
        if($('.nbtcm-mappanel.is-active').length == 0) {
            $('.nbtcm-btn-display.is-active').removeClass('is-active');
        }
    });
    $('.nbtcm-mappanel-btn-cancel').click(function () {
        console.log('cancel')
        $(this).parents('.nbtcm-mappanel').removeClass('is-active');
    });

    $('.nbtcm-mappanel-btn-togglesize').click(function () {
        $(this).parents('.nbtcm-mappanel').toggleClass('is-maximize');
        console.log('togglesize')
    });

    $('.nbtcm-maptools-btn-toggle').click(function () {
        $('.nbtcm-maptools').toggleClass('is-active');
    });




    $('[data-toggle="tooltip"]').tooltip();
    $('.nbtcm-jstree').jstree({
        "core": {
            "check_callback": true,
            'themes': {
                'name': 'proton',
                // 'responsive': true
            }
        },
        'checkbox': {
            cascade: 'up',
            three_state: true
        },
        "plugins": ["checkbox", "types"],
        'types': {
            'selectable': {
                'icon': 'http://elpidio.tools4software.com/images/icon-ok-small.png'
            },
            'default': {
                'icon': 'd-none'
            }
        }
    });

    $('.nbtcm-jstree-nocheckbox').jstree({
        "core": {
            "check_callback": true,
            'themes': {
                'name': 'proton',
                // 'responsive': true
            }
        },
        // 'checkbox': {
        //     cascade: 'up',
        //     three_state: true
        // },
        "plugins": ["types"],
        'types': {
            'selectable': {
                'icon': 'http://elpidio.tools4software.com/images/icon-ok-small.png'
            },
            'default': {
                'icon': 'd-none'
            }
        }
    });

    $(".nbtcm-jstree, .nbtcm-jstree-nocheckbox").jstree('open_all');

    $('#sb-layer-1-tab-1').on('click', function (e) {
        $('#sb-layer-1-1').addClass('show active')
        $('#sb-layer-1-2').removeClass('show active')
        console.log('1')
    })
    $('#sb-layer-1-tab-2').on('click', function (e) {
        // e.preventDefault()
        $('#sb-layer-1-1').removeClass('show active')
        $('#sb-layer-1-2').addClass('show active')
        console.log('2')
    })

    $('.datepicker').datepicker({});

    $(".datepicker").inputmask({
        "mask": "99/99/9999"
    });
    $('.timepicker').timepicker({
        'defaultTime': false,
        'showMeridian': false,
        'icons': {
            'up': 'afms-ic_up',
            'down': 'afms-ic_down'
        }
    });


    $('.input-colorpicker').colorpicker();
    $('.input-colorpicker').on('change', function (e) {
        // alert('Changed!')
        $(this).css('background-color', $(this).val())
    });

    // $('.nbtcm-leafletpopup').draggable({ 
    //     draggable: '.nbtcm-mappanel-heading',
    //     containment: '.nbtcm-map',
    //     scroll: false
    // });

    $('#resizable').draggable({
        handle: '.nbtcm-mappanel-heading',
        containment: '.nbtcm-map',
        scroll: false
    });

    $("#resizable").resizable({
        // maxHeight: '100vh',
        maxWidth: 350,
        // minHeight: '33.33vh',
        minWidth: 300
    });


    // var isMouseDown, initX, initY, height = draggable.offsetHeight,
    //     width = draggable.offsetWidth;

    // draggable.addEventListener('mousedown', function (e) {
    //     isMouseDown = true;
    //     document.body.classList.add('no-select');
    //     initX = e.offsetX;
    //     initY = e.offsetY;
    // })

    // document.addEventListener('mousemove', function (e) {
    //     if (isMouseDown) {
    //         var cx = e.clientX - initX,
    //             cy = e.clientY - initY;
    //         if (cx < 0) {
    //             cx = 0;
    //         }
    //         if (cy < 0) {
    //             cy = 0;
    //         }
    //         if (window.innerWidth - e.clientX + initX < width) {
    //             cx = window.innerWidth - width;
    //         }
    //         if (e.clientY > window.innerHeight - height + initY) {
    //             cy = window.innerHeight - height;
    //         }
    //         draggable.style.left = cx + 'px';
    //         draggable.style.top = cy + 'px';
    //     }
    // })

    // draggable.addEventListener('mouseup', function () {
    //     isMouseDown = false;
    //     document.body.classList.remove('no-select');
    // })


    // var i = 0;
    // var dragging = false;
    // $('#draggable').mousedown(function (e) {
    //     e.preventDefault();

    //     dragging = true;
    //     var main = $('#main');
    //     var ghostbar = $('<div>', {
    //         id: 'ghostbar',
    //         css: {
    //             height: main.outerHeight(),
    //             top: main.offset().top,
    //             left: main.offset().left
    //         }
    //     }).appendTo('body');

    //     $(document).mousemove(function (e) {
    //         ghostbar.css("left", e.pageX + 2);
    //     });
    // });

    // $(document).mouseup(function (e) {
    //     if (dragging) {
    //         $('#draggable').css("width", e.pageX + 2);
    //         $('#main').css("left", e.pageX + 2);
    //         $('#ghostbar').remove();
    //         $(document).unbind('mousemove');
    //         dragging = false;
    //     }
    // });

});
