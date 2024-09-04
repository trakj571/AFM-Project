function doCheckToken() {
    $.ajax({
        type: 'POST',
        url: "../GIS/data/uToken.ashx",
        data: {

        },
        cache: false,
        dataType: 'json',
        success: function (data) {
            if (data.result == "OK") {
                var idt = data.datas;
                if (!idt.IsVerify) {

                    swal({
                        title: "Username ของคุณถูกใช้งานจากสถานที่อื่น",
                        text: "",
                        type: 'warning',
                        confirmButtonText: 'ตกลง',
                        confirmButtonClass: 'nbtc-btn nbtc-btn-primary'
                    }).then(function () {
                        location = "../UR/Logout.aspx";
                    });

                    return;
                }

            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
    });

    setTimeout(function () {
        doCheckToken();
    }, 30 * 1000);

}

$(function () {
    doCheckToken();
});