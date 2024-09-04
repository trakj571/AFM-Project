var documentHeight = $('.nbtc-container').height();
var contentHeight =$('.nbtc-sec-center').outerHeight()
console.log(contentHeight);

console.log($('.nbtc-sec-center').outerHeight());

if( documentHeight > $(window).height() ) {
    $('.nbtc-sec-left .nbtc-search-list').css({
        'max-height' : contentHeight-115,
        'height' : contentHeight-115
    });
} else {
    $('.nbtc-sec-left .nbtc-search-list').css({
        'max-height' : documentHeight-390,
        'height' : documentHeight-390
    });
}

$('.nbtc-search-list li').click(function(){
    $('.nbtc-search-list li').removeClass('is-active');
    $(this).addClass('is-active');
});

$('.has-submenu').click(function(){
  $(this).toggleClass('is-active');
});


$('.nbtc-btn-delete').click(function(){
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
      swal({
        title: 'ลบข้อมูลสำเร็จ',
        text: "ข้อมูลถูกลบแล้ว",
        type: 'success',
      confirmButtonText: 'ตกลง',
        confirmButtonClass: 'nbtc-btn nbtc-btn-primary'
      })
    });
});

$('.nbtc-etesting-answer .nbtc-answer').click(function(){
    $('.nbtc-etesting-answer .nbtc-answer').removeClass('is-active');
    $(this).addClass('is-active');
});

$('.nbtc-btn-nextquestion').click(function(){
    swal({
      title: 'คุณยังไม่ได้ตอบคำถาม',
      text: "คุณไม่สามารถไปยังคำถามถัดไปได้ กรุณาตอบคำถาม",
      type: 'warning',
      confirmButtonText: 'ตกลง',
      confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
    });
});

$('.nbtc-btn-prevquestion').click(function(){
    swal({
      title: 'ต้องการกลับไปคำถามก่อนหน้า',
      text: "",
      type: 'warning',
      confirmButtonText: 'ตกลง',
      confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
    });
});


$('.nbtc-btn-chooselocation').click(function(){
    $('.nbtc-btn-chooselocation , .nbtc-announcer tr').removeClass('is-active');
    $(this).addClass('is-active');
    $(this).parent().parent().addClass('is-active');
});

$('.nbtc-btn-announce').click(function(){
    swal({
      title: 'ต้องการประกาศผลการสอบ',
      text: "หากประกาศแล้วจะไม่สามารถกลับมาแก้ไขผลสอบได้อีก",
      type: 'warning',
      showCancelButton: true,
      confirmButtonText: 'ใช่ ประกาศเลย',
      cancelButtonText: 'ยกลิก',
      confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
      cancelButtonClass: 'nbtc-btn nbtc-btn-secondary',
    }).then(function () {
      swal({
        title: 'ประกาศผลสอบแล้ว',
        text: "",
        type: 'success',
        confirmButtonText: 'ตกลง',
        confirmButtonClass: 'nbtc-btn nbtc-btn-primary'
      })
    });
});

