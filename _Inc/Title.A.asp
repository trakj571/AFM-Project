<%@Import NameSpace="EBMSMap30" %>
<meta charset="utf-8">
	<title>NBTC AUTOMATIC FREQUENCY MONITORING SYSTEM</title>
    <link rel="shortcut icon" href="../img/favicon.ico" />
	
	<meta name="description" content="">
	<meta name="HandheldFriendly" content="True">
	<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<meta http-equiv="cleartype" content="on">

  	<link rel="stylesheet" href="../_inc.a/font/style.css">
  	<link rel="stylesheet" href="../_inc.a/css/bootstrap.min.css">
	<link rel="stylesheet" href="../_inc.a/icon/style.css">
	<link rel="stylesheet" href="../_inc.a/css/reset.css">
	<link rel="stylesheet" href="../_inc.a/css/bootstrap-select.css">
	<link rel="stylesheet" href="../_inc.a/css/bootstrap-datepicker.css">
	<link rel="stylesheet" href="../_inc.a/css/jstree.css">

	<link rel="stylesheet" href="../_inc.a/css/sweetalert2.css">
	<link rel="stylesheet" href="../_inc.a/css/lightgallery.css">
	<link rel="stylesheet" href="../_inc.a/css/style.css">
	<link rel="stylesheet" href="../_inc.a/css/responsive.css">
    
    <script type="text/javascript" src="../_inc.a/js/jquery-3.2.0.min.js"></script>
    <script type="text/javascript" src="../_inc.a/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../_inc.a/js/bootstrap-select.js"></script>
    <script type="text/javascript" src="../_inc.a/js/bootstrap-datepicker.js"></script>
    <script type="text/javascript" src="../_inc.a/js/jstree.min.js"></script>
    <script type="text/javascript" src="../_inc.a/js/autosize.js"></script>

    <script type="text/javascript" src="../_inc.a/js/core.js"></script>
    <script type="text/javascript" src="../_inc.a/js/sweetalert2.js"></script>

    <script type="text/javascript" src="../_inc.a/js/function.js"></script>

    <script src="../_inc.a/js/lightgallery.js"></script>
    



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
                          if (isparent) {
                              reloadPage(true);
                          }
                          else if (reload) {
                              reloadPage(false);
                          }
                         else{
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
                    height: '470px',
                    dynamic: true,
                    mode: 'lg-fade',
                    addClass: 'fixed-size',
                    counter: false,
                    download: false,
                    startClass: '',
                    enableSwipe: false,
                    enableDrag: false,

                    dynamicEl: [{
                        "iframe":true,
                        "src": src,
                     }]
                });
       
       setTimeout(function(){
           // alert($("iframe").attr("id"));
       },3000);         
    }
    function closeDialog(){
        parent.$(".lg-icon").click();
    }

    function reloadPage(isparent){
        if(isparent)
            parent.reloadPage(false);
        else{
            var page_y = $( document ).scrollTop();
            window.location.href = replaceQueryParam("page_y",page_y,window.location.href);
        }
    }
    function replaceQueryParam(param, newval, search) {
        var regex = new RegExp("([?;&])" + param + "[^&;]*[;&]?");
        var query = search.replace(regex, "$1").replace(/&$/, '');

        return (query.length > 2 ? query + "&" : "?") + (newval ? param + "=" + newval : '');
        }
        function exportXls(kw) {
            var url = location.href;
            if (url.indexOf("?") > -1)
                window.open(url + "&export=xls&kw=" + kw);
            else
                window.open(url + "?export=xls&kw=" + kw);
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

    
    </script>