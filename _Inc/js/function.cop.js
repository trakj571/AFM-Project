$(function(){

		if ('ontouchstart' in document.documentElement) { // or whatever "is this a touch device?" test we want to use
			$('body').css('cursor', 'pointer');
		}

		var windowHeight = $(window).height();
		var windowWidth = $(window).width();

		var headerHeight = 74;
		var maptoolsHeight = $('.afms-sec-maptools').outerHeight() +1;
		var slidebarWidth = $('.afms-page-cop .afms-sec-sidebar').outerWidth();
		var mapeventWidth = $('.afms-sec-mapevent').outerWidth();

		$('.afms-sec-map').css('padding-top', headerHeight );

		if( $(document).height() > windowHeight ) {
			$('.afms-sec-container').css('margin-bottom', '-34px');
		}

		var getMapHeight = $('.afms-sec-map').height()


		

		setTimeout(function(){ 
			var mapstoolsHeight = $('.afms-sec-map .afms-sec-maptools').outerHeight() +1;

			$('.afms-sec-mapapp').css({
				'height': getMapHeight - mapstoolsHeight + 10,
				'margin-top': mapstoolsHeight - 10
			})
		}, 0);

		var mapHeight = $('.afms-page-cop .afms-sec-map').outerHeight();
		$('body').height(window.innerHeight);

		$('.afms-sec-mapsensor').width( windowWidth - slidebarWidth - mapeventWidth - 10 );


		var elementHeights = $('.afms-mapsensor-box .panel-body').map(function() {
			return $(this).height();
		}).get();
		var maxHeight = Math.max.apply(null, elementHeights);
		$('.afms-mapsensor-box .panel-body').height(maxHeight);


		var mapsensorHeight = $('.afms-sec-mapsensor').outerHeight();
		$('.afms-sec-mapsensor').css('bottom', -mapsensorHeight);

		$('.afms-page-cop .afms-btn-display').click(function(e) {
			$('.afms-sec-mapevent , .afms-sec-mapinfo , .afms-sec-mapstreet , .afms-sec-mapsensor').addClass('is-active');

			var mapEventHeight = (( windowHeight - headerHeight - maptoolsHeight ) / 3) + 3;
			
			if ( windowHeight < 600 && windowWidth > 800 ) {
				console.log('1) windowHeight < 600 && windowWidth > 800')

				$('.afms-sec-mapevent').css({
					'top': headerHeight + maptoolsHeight - 10,
					'height': windowHeight - headerHeight - maptoolsHeight + 10
				});

				$('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - headerHeight - maptoolsHeight - 233);

			} else if ( windowHeight > 600 && windowWidth > 800 ) {
				console.log('2) windowHeight > 600 && windowWidth > 800')

				$('.afms-sec-mapevent').css({
					'top': headerHeight + maptoolsHeight - 10,
					'height': mapEventHeight
				});
				$('.afms-sec-mapevent .afms-wrapper').css({
					'height': mapEventHeight - 43
				});

				$('.afms-sec-mapinfo').css({
					'top': mapEventHeight + headerHeight + maptoolsHeight - 10,
					'height': mapEventHeight
				});
				$('.afms-sec-mapinfo .afms-wrapper').css({
					'height': mapEventHeight - 43
				});

				$('.afms-sec-mapstreet').css({
					'top': ( mapEventHeight * 2 ) + headerHeight + maptoolsHeight - 10,
					'height': mapEventHeight + 2
				});

			} else if ( windowHeight > 600 && (  windowWidth <= 800 && windowWidth > 600 ) ) {
				console.log('3) windowHeight > 600 && (  windowWidth <= 800 && windowWidth > 600 )')
				$('.afms-sec-mapevent').css({
					'top': headerHeight + maptoolsHeight - 10,
					'height': windowHeight - headerHeight - maptoolsHeight + 10
				});

				$('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - headerHeight - maptoolsHeight - 233);

			} else if ( windowHeight > 600 && (  windowWidth <= 600 ) )  {
				console.log('windowHeight > 600 && (  windowWidth <= 600 )')

				$('.afms-sec-mapevent').css({
					'height': windowHeight - headerHeight - maptoolsHeight + 10
				});

				$('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - 317);

			} else if ( windowHeight < 600 && (  windowWidth <= 600 ) )  {
				$('.afms-sec-mapevent').css({
					'height': windowHeight - headerHeight - maptoolsHeight + 10
				});

				$('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - 317);

			}

			$(this).tooltip('hide');
		});


		if ( windowWidth <= 420 ) {
			$('.afms-sec-maptools').css({
				width: windowWidth
			});
		}

		if ( windowWidth > 992 ) {
			$('.afms-content .collapse:not(#advanceFilter)').addClass('in');
			$('.afms-sec-sidebar .collapse:not(#advanceFilter)').addClass('in');
			$('.afms-page-cop .afms-route-detail-direction .collapse').removeClass('in');
		} else {
			$('.afms-page-cop .afms-content .collapse').addClass('in');
			$('.afms-page-cop .afms-route-detail-direction .collapse').removeClass('in');
			$('.afms-page-cop .afms-sec-sidebar .collapse').removeClass('in');
		}

		$('.afms-sec-mapevent .afms-btn-close').click(function(e) {
			$('.afms-sec-mapevent').removeClass('is-active');
		});

		$('.afms-sec-mapinfo .afms-btn-close').click(function(e) {
			$('.afms-sec-mapinfo').removeClass('is-active');
		});

		$('.afms-sec-mapstreet .afms-btn-close').click(function(e) {
			$('.afms-sec-mapstreet').removeClass('is-active');
		});

		$('.afms-sec-mapsensor .afms-btn-close').click(function(e) {
			$('.afms-sec-mapsensor').removeClass('is-active');
		});

		var slidebarHeight = $('.afms-page-cop .afms-sec-sidebar').outerHeight() - 42;

		$('.afms-page-cop .afms-sec-sidebar > .tab-content').height( slidebarHeight - 75 );

		$('.radio-searchtype_detail').click(function(e) {
			$('.afms-searchtype_detail').show();
			$('.afms-searchtype_direction').hide();
		});

		$('.radio-searchtype_direction').click(function(e) {
				$('.afms-searchtype_direction').show();
				$('.afms-searchtype_detail').hide();
		});

		$('.afms-sec-container:not(.afms-page-cop) .afms-sec-sidebar .afms-btn-hide').click(function(e) {
				$('.afms-sec-sidebar').toggleClass('is-hide');
				$('.afms-sec-content').toggleClass('is-hide');
		});

		$('.afms-page-cop .afms-sec-sidebar .afms-btn-hide').click(function(e) {
			$('.afms-page-cop .afms-sec-sidebar').toggleClass('is-hide');
			$('.afms-page-cop .afms-sec-content').toggleClass('is-active');

			if( $('.afms-page-cop .afms-sec-sidebar').hasClass('is-hide') ) {
				$('.afms-page-cop .afms-sec-mapsensor').width( windowWidth - mapeventWidth - 10 );
			} else {
				$('.afms-page-cop .afms-sec-mapsensor').width( windowWidth - slidebarWidth - mapeventWidth - 10 );
			}

			setTimeout(function(){
				var maptoolsHeight = $('.afms-page-cop .afms-sec-maptools').outerHeight() +1;
				
				$('.afms-page-cop .afms-sec-mapevent').height( mapHeight - maptoolsHeight + 4);
				$('.afms-page-cop .afms-sec-mapevent .afms-wrapper').height( mapHeight - maptoolsHeight - 339);

				$('.afms-sec-map').css('padding-top', headerHeight );

				$('.afms-sec-mapapp').css({
					'margin-top': maptoolsHeight,
					'height': getMapHeight - maptoolsHeight + 10
				});
			}, 300);

		});


		


		$('.afms-btn-menu').click(function(e) {
			$('.afms-sec-container').toggleClass('is-wrap');
			$('body').toggleClass('is-hidden');
		});

		$('.afms-btn-search , .afms-btn-add , .afms-btn-scanning').click(function(e) {
			$('.afms-btn-editscanning').show();
			$('.afms-btn-editsearch').show();
			$('.afms-btn-hidesearch').hide();
		});
		$('.afms-btn-editsearch').click(function(e) {
			$(this).hide();
			$('.afms-btn-hidesearch').show();
		});
		$('.afms-btn-hidesearch').click(function(e) {
			$(this).hide();
			$('.afms-btn-editsearch').show();
		});
		$('.afms-btn-editscanning').click(function(e) {
			$(this).hide();
			$('.afms-btn-hidescanning').show();
		});
		$('.afms-btn-hidescanning').click(function(e) {
			$(this).hide();
			$('.afms-btn-editscanning').show();
		});

		$('.afms-sidebar-title , .afms-sec-sidebar #sidebarFreqDb > ul > li > a').click(function(e) {
			$(this).toggleClass('is-collapse');
		});

		$('.radio-mode_auto').click(function(e) {
			$('.afma-mode_auto').show();
			$('.afma-mode_manual').hide();
		});

		$('.radio-mode_manual').click(function(e) {
			$('.afma-mode_manual').show();
			$('.afma-mode_auto').hide();
		});

		$('.afms-btn-delete').click(function(e) {
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
				function () {},
				function (dismiss) {
					}
			)
		})
		});

		$('.afms-list-route li a:not(.use-publictrans)').click(function(e) {
				$('.afms-route-detail:not(.use-publictrans)').show();
				$('.afms-search-route , .afms-list-route').hide();
		});

		$('.afms-list-route li a.use-publictrans').click(function(e) {
				$('.afms-route-detail.use-publictrans').show();
				$('.afms-search-route , .afms-list-route').hide();
		});

		$('.afms-route-detail .afms-route-detail-search .afms-btn-back').click(function(e) {
				$('.afms-route-detail').hide();
				$('.afms-search-route , .afms-list-route').show();
		});


	$('.afms-route-start input').keydown(function(e) {
		$('.afms-search-route-start-autocomplete').slideDown('fast')
	});

	$('.afms-search-route-start-autocomplete li').click(function(e) {
		$('.afms-search-route-start-autocomplete').slideUp('fast')
	});

	$('.afms-route-destination input').keydown(function(e) {
		$('.afms-search-route-destination-autocomplete').slideDown('fast')
	});

	$('.afms-search-route-destination-autocomplete li').click(function(e) {
		$('.afms-search-route-destination-autocomplete').slideUp('fast')
	});


	$(window).resize(function(e) {
		var windowHeight = $(window).height();
		var windowWidth = $(window).width();

		var headerHeight = $('.afms-page-cop .afms-sec-header').outerHeight() +1;
		var maptoolsHeight = $('.afms-sec-maptools').outerHeight() +1;
		var slidebarWidth = $('.afms-page-cop .afms-sec-sidebar').outerWidth();
		var mapeventWidth = $('.afms-sec-mapevent').outerWidth();

		$('.afms-sec-map').css('padding-top', headerHeight );

		if( $(document).height() > windowHeight ) {
			$('.afms-sec-container').css('margin-bottom', '-34px');
		}

		var getMapHeight = $('.afms-sec-map').height()

		setTimeout(function(){ 
			var mapstoolsHeight = $('.afms-sec-map .afms-sec-maptools').outerHeight() +1;

			$('.afms-sec-mapapp').css({
				'height': getMapHeight - mapstoolsHeight + 10,
				'margin-top': mapstoolsHeight - 10
			})
		}, 0);
		
		$('.afms-page-cop .afms-sec-sidebar').height( windowHeight - headerHeight );
		$('.afms-page-cop .afms-sec-map').height( windowHeight - headerHeight );

		 var mapHeight = $('.afms-page-cop .afms-sec-map').outerHeight();

		$('body').height(window.innerHeight);

		var slidebarHeight = $('.afms-page-cop .afms-sec-sidebar').outerHeight() - 42;
		$('.afms-page-cop .afms-sec-sidebar > .tab-content').height( slidebarHeight - 75 );

		$('.afms-sec-mapsensor').width( windowWidth - slidebarWidth - mapeventWidth - 10 );
			
		var mapEventHeight = ( windowHeight - headerHeight - maptoolsHeight ) / 3;
	
		if ( windowHeight < 600 && windowWidth > 800 ) {
			console.log('1) windowHeight < 600 && windowWidth > 800')

			$('.afms-sec-mapevent').css({
				'top': headerHeight + maptoolsHeight - 3,
				'height': windowHeight - headerHeight - maptoolsHeight + 10
			});

			$('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - headerHeight - maptoolsHeight - 240);

		} else if ( windowHeight > 600 && windowWidth > 800 ) {
			console.log('2) windowHeight > 600 && windowWidth > 800')

			$('.afms-sec-mapevent').css({
				'top': headerHeight + maptoolsHeight - 2,
				'height': mapEventHeight
			});
			$('.afms-sec-mapevent .afms-wrapper').css({
				'height': mapEventHeight - 43
			});

			$('.afms-sec-mapinfo').css({
				'top': mapEventHeight + headerHeight + maptoolsHeight - 3,
				'height': mapEventHeight
			});
			$('.afms-sec-mapinfo .afms-wrapper').css({
				'height': mapEventHeight - 43
			});

			$('.afms-sec-mapstreet').css({
				'top': ( mapEventHeight * 2 ) + headerHeight + maptoolsHeight - 2,
				'height': mapEventHeight + 2
			});

		} else if ( windowHeight > 600 && ( windowWidth <= 800 && windowWidth > 600 ) ) {
			console.log('3) windowHeight > 600 && ( windowWidth <= 800 && windowWidth > 600 )')

			$('.afms-sec-mapevent').css({
				'top': headerHeight + maptoolsHeight - 2,
				'height': windowHeight - headerHeight - maptoolsHeight + 3
			});

			$('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - headerHeight - maptoolsHeight - 241);

		} else if ( windowHeight > 600 && (  windowWidth <= 600 ) )  {
			console.log('4) windowHeight > 600 && (  windowWidth <= 600 )')

			$('.afms-sec-mapevent').css({
				'height': windowHeight - headerHeight - maptoolsHeight + 10
			});

			$('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - 317);

		} else if ( windowHeight < 600 && (  windowWidth <= 600 ) )  {
			console.log('5) windowHeight < 600 && (  windowWidth <= 600 )')
			$('.afms-sec-mapevent').css({
				'height': windowHeight - headerHeight - maptoolsHeight + 10
			});

			$('.afms-sec-mapevent .afms-wrapper').css('height', windowHeight - 317);

		} else {
			console.log('6)')

		}

		if ( windowWidth <= 420 ) {
			$('.afms-sec-maptools').css({
				width: windowWidth
			});
		} else {
			$('.afms-sec-maptools').css({
				width: 100 + '%'
			});
		}

		if ( windowWidth > 992 ) {
			//$('.afms-content .collapse:not(#advanceFilter)').addClass('in');
			$('.afms-sec-sidebar .collapse:not(#advanceFilter)').addClass('in');
			//console.log('dddd');
		} else {
			//$('.afms-content .collapse').addClass('in');
			$('.afms-sec-sidebar .collapse').removeClass('in');
		}
	});

});