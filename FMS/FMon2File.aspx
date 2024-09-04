<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FMon2File.aspx.cs" Inherits="AFMProj.FMS.FMon2File" %>

<!DOCTYPE html>
<html>
<head>
    <!--#include file="../_inc/Title.asp"-->
   
    <script language="javascript">
        var poiid = '<%=Request["PoiID"] %>';


    </script>
    <style>
.sortup {background :url(../img/sort_up.png) top center no-repeat}
.sortdown {background :url(../img/sort_down.png) top center no-repeat}

</style>
     <script src="../_inc/js/jquery.fileDownload.js"></script>
    <script>
        var chked = [];
        var download_key = "";
        var download_file = "";

        $(document).ready(function () {
            chk_process();

            $("#checkedAll").change(function () {
                if (this.checked) {
                    $(".checkSingle").each(function () {
                        this.checked = true;
                    });
                } else {
                    $(".checkSingle").each(function () {
                        this.checked = false;
                    });
                }
               
            });

            $(".checkSingle").click(function () {
                if ($(this).is(":checked")) {
                    var isAllChecked = 0;

                    $(".checkSingle").each(function () {
                        if (!this.checked)
                            isAllChecked = 1;
                    });

                    if (isAllChecked == 0) {
                        $("#checkedAll").prop("checked", true);
                    }
                }
                else {
                    $("#checkedAll").prop("checked", false);
                }

               
            });
        });

        function checkSelected() {
            var chked = [];
            $(".checkSingle").each(function () {
                if ($(this).prop("checked")) {
                    chked.push($(this).val());
                }
            });

            return chked;
        }
        function do_deletes() {
            $(".td_stat").html("");
            chked = checkSelected();
            if (chked.length == 0) {
                swal({
                    title: '',
                    text: "Please select file(s).",
                    type: 'warning',
                    confirmButtonText: 'ตกลง',
                    confirmButtonClass: 'nbtc-btn nbtc-btn-primary'
                });
                return;
            }
            swal({
                title: '',
                text: "Delete " + chked.length + " selected files?",
                type: 'question',
                showCancelButton: true,
                confirmButtonText: 'OK',
                cancelButtonText: 'Cancel',
                confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                cancelButtonClass: 'nbtc-btn nbtc-btn-secondary',
            }).then(function () {
                $(".f-button button").prop("disabled", true);
                $(".f-button button").css("opacity", "0.4");
                do_delete(chked[0].split(',')[0], chked[0].split(',')[1]);
            }, function (dismiss) { });

        }

        function do_delete(i, file) {
            $("#stat_" + i).html("Delete..");
            $.ajax({
                type: 'GET',
                url: "../plugin/delete.ashx?poiid=<%=Request["poiid"]%>&token=<%=EBMSMap30.cUsr.Token%>&file=" + file + "&i=" + i,
                cache: false,
                dataType: 'json',
                success: function (data) {
                    $("#stat_" + i).html("Done.");
                    chked.splice(0, 1);
                    if (chked.length > 0)
                        do_delete(chked[0].split(',')[0], chked[0].split(',')[1]);
                    else
                        location = location.href;
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                }

            });
        }

        function do_uploads() {
            $(".td_stat").html("");
            chked = checkSelected();
            if (chked.length == 0) {
                swal({
                    title: '',
                    text: "Please select file(s).",
                    type: 'warning',
                    confirmButtonText: 'ตกลง',
                    confirmButtonClass: 'nbtc-btn nbtc-btn-primary'
                });
                return;
            }
            swal({
                title: '',
                text: "Upload " + chked.length + " selected files?",
                type: 'question',
                showCancelButton: true,
                confirmButtonText: 'OK',
                cancelButtonText: 'Cancel',
                confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                cancelButtonClass: 'nbtc-btn nbtc-btn-secondary',
            }).then(function () {
                $(".f-button button").prop("disabled", true);
                $(".f-button button").css("opacity", "0.4");
                do_upload(chked[0].split(',')[0], chked[0].split(',')[1]);
            }, function (dismiss) { });

        }
        function do_upload(i, file) {
            c_pc = 0; 
            $("#stat_" + i).html("Upload..");
            download_key = "fileUpload_<%=Request["poiid"]%>_" + i;
            download_file = file;
            chk_process_i();
            $.ajax({
                type: 'GET',
                url: "../plugin/upload.ashx?poiid=<%=Request["poiid"]%>&token=<%=EBMSMap30.cUsr.Token%>&file=" + file + "&i=" + i+"&tmpkey=<%=TmpKey%>",
                cache: false,
                dataType: 'json',
                success: function (data) {
                    $("#stat_" +i).html("Done.");
                    chked.splice(0, 1);
                    if (chked.length > 0)
                        do_upload(chked[0].split(',')[0], chked[0].split(',')[1]);
                    else
                        finish();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    
                }

            });
        }


        ////
       
        function do_downloads() {
            $(".td_stat").html("");
            chked = checkSelected();
            if (chked.length == 0) {
                swal({
                    title: '',
                    text: "Please select file(s).",
                    type: 'warning',
                    confirmButtonText: 'ตกลง',
                    confirmButtonClass: 'nbtc-btn nbtc-btn-primary'
                });
                return;
            }
            swal({
                title: '',
                text: "Download " + chked.length+" selected files?",
                type: 'question',
                showCancelButton: true,
                confirmButtonText: 'OK',
                cancelButtonText: 'Cancel',
                confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                cancelButtonClass: 'nbtc-btn nbtc-btn-secondary',
            }).then(function () {
                $(".f-button button").prop("disabled", true);
                $(".f-button button").css("opacity", "0.4");
                do_download(chked[0].split(',')[0], chked[0].split(',')[1]);
            }, function (dismiss) { });

        }
       
        function do_download(i, file) {
            $("#stat_" + i).html("Download..");
            c_pc = 0;
            var url = "../plugin/download.ashx?poiid=<%=Request["poiid"]%>&token=<%=EBMSMap30.cUsr.Token%>&file=" + file + "&i=" + i + "&tmpkey=<%=TmpKey%>";
            $.fileDownload(url);
            download_key = "fileDownload_<%=Request["poiid"]%>_" + i;
            download_file = file;
            chk_process_i();
        }

        var c_pc = 0;
        function chk_process_i() {
            var key = download_key;
            if (key == "")
                return;

           if (key.split('_')[0] == "fileDownload" && getCookie(key) == "true") {
                $("#stat_" + key.split('_')[2]).html("Done.");
                setCookie(key, "", 1);
                chked.splice(0, 1);
                if (chked.length > 0)
                    do_download(chked[0].split(',')[0], chked[0].split(',')[1]);
                else
                    finish();

           } else {
               var proc = key.split('_')[0] == "fileDownload"?"Download":"Upload";
                //$("#stat_" + key.split('_')[2]).html(proc+"..");
                $.ajax({
                    type: 'GET',
                    url: "../plugin/FtpStat.ashx?cname=<%=TmpKey%>_" + download_file,
                    cache: false,
                    dataType: 'json',
                    success: function (data) {
                        if (parseInt(data.pc) > c_pc) {
                            $("#stat_" + key.split('_')[2]).html(proc + " " + data.pc + "%");
                            c_pc = parseInt(data.pc);
                        }
                     },
                     error: function (XMLHttpRequest, textStatus, errorThrown) {

                     }

                });

                
            }
        }

        function chk_process() {

            chk_process_i();

            setTimeout(function () {
                chk_process();
            }, 2 * 1000);
        }

        function setCookie(cname, cvalue, exdays) {
            var d = new Date();
            d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
            var expires = "expires=" + d.toUTCString();
            document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
        }

        function getCookie(cname) {
            var name = cname + "=";
            var ca = document.cookie.split(';');
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0) == ' ') {
                    c = c.substring(1);
                }
                if (c.indexOf(name) == 0) {
                    return c.substring(name.length, c.length);
                }
            }
            return "";
        }

        function finish() {
            download_key = "";
            download_file = "";
            $(".f-button button").prop("disabled", false);
            $(".f-button button").css("opacity", "1");
        }

        function do_import() {
            location = "AImp.aspx?poiid=" + poiid;
        }

        function do_import1() {
            var chked = checkSelected();
            if (chked.length != 1) {
                swal({
                    title: '',
                    text: "Import only 1 selected files?",
                    type: 'error',
                    confirmButtonText: 'OK',
                    confirmButtonClass: 'nbtc-btn nbtc-btn-primary',
                    cancelButtonClass: 'nbtc-btn nbtc-btn-secondary',
                });
                return;
            }

            window.open("AImp.aspx?poiid=" + poiid+"&file=<%=FTPPath%>/"+ chked[0].split(',')[1]);
        }

        function refresh() {
            location = location.href;
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
                <li>File Manager</li>
            </ul>
        </div>

        <div class="row afms-sec-content">
            <!--#include file="../FMS/Menu.asp"-->

            <%
                if (Request["poiid"] == null)
                {
                    if (tbSTN.Rows.Count == 0)
                        Response.Redirect("FSch.aspx");

                    Response.Redirect("FMon.aspx?poiid=" + tbSTN.Rows[tbSTN.Rows.Count - 1]["PoiID"]);

                }
                else
                {
                    for (int i = 0; i < tbSTN.Rows.Count; i++)
                    {
                        if (tbSTN.Rows[i]["PoiID"].ToString() == Request["poiid"])
                            drSTN = tbSTN.Rows[i];
                    }
                    if (drSTN == null)
                        Response.Redirect("../DashB");
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
                    <div class="text-right">

                        <a href="FMon2.aspx?poiid=<%=drSTN["PoiID"] %>" class="afms-btn afms-btn-secondary"><i class="afms-ic_file"></i>Frequency Monitoring</a>
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
                                            <div class="panel panel-default afms-station-status panel-power" style="height: 205px; display: none">
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
                                                        <div class="col-md-6 col-sm-6" style="display: none">
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
                    <a href="javascript:refresh()"><img src="../img/refresh_64x64.png" width="32" /></a>
                    <div class="afms-sec-table">
                        <table class="table table-condensed text-center afms-table-responsive">
                            <thead>
                                <tr>
                                    <th>

                                        <div class="afms-field afms-field_checkbox">
                                            <label style="margin-top:0px!important">
                                                <input name="checkedAll" type="checkbox" id="checkedAll" value="1" />
                                                <div class="box"></div>
                                                <div class="check afms-ic_check"></div>

                                            </label>
                                        </div>
                                    </th>
                                    <th <%=ThSort("Name")%>><a href='<%=SchSort("Name") %>'>File Name</a></th>
                                    <th <%=ThSort("Type")%>><a href='<%=SchSort("Type") %>'>Type</a></th>
                                    <th <%=ThSort("Size")%>><a href='<%=SchSort("Size") %>'>Size</a></th>
                                    <th <%=ThSort("Date")%>><a href='<%=SchSort("Date") %>'>Date Modified</a></th>
                                
                                    <!--th>Download</!--th-->
                                    <th style="width:200px">Process</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%if(files!=null){ %>
                                <%for (int i = 0; i < files.Length; i++)
                                    {
                                        var file = (Dictionary<string,object>)files[i];
                                        %>
                                <tr>
                                    <td>
                                         <div class="afms-field afms-field_checkbox">
                                            <label style="margin-top:0px!important">
                                                <input type="checkbox" id="checked<%=i %>" value="<%=i+","+file["Name"].ToString().Replace("'","*") %>" class="checkSingle" />
                                                <div class="box"></div>
                                                <div class="check afms-ic_check"></div>

                                            </label>
                                        </div>
                                    </td>
                                    <td style="text-align: left"><%=file["Name"] %></td>
                                    <td><%=file["Type"] %></td>
                                    <td class="text-right"><%=file["Size"] %></td>
                                    <td class="text-right"><%=file["Date"] %></td>
                                    <!--td><a href="javascript:do_download('<%=i %>','<%=file["Name"].ToString().Replace("'","*") %>')">Download</a></!--td-->
                                    <td class="td_stat" id="stat_<%=i%>"></td>
                                </tr>
                                <%} %>
                                <%} %>
                            </tbody>
                        </table>
                        <%
                           

                            int nPage = (int)Math.Ceiling((double)nTotal/pgSize);
                            if(nPage>1){

                                Response.Write("<div class=\"afms-pagination no-print-page\">");
                                if(cPage>1){
                                    Response.Write("<a href='"+GetPageUrl(1)+"' class=\"afms-ic_firstpage\">&laquo;</a>");
                                    Response.Write("<a href='"+GetPageUrl(cPage-1)+"' class=\"afms-ic_prev\"></a>");
                                }
                                for(int i=1;i<=nPage;i++){
                                    Response.Write("<a href='"+GetPageUrl(i)+"' "+(i==cPage?"class=\"is-active\"":"")+">"+i+"</a> ");
                                }
                                if(cPage<nPage && nPage>1){
                                    Response.Write("<a href='"+GetPageUrl(cPage+1)+"' class=\"afms-ic_next\"></a>");
                                    Response.Write("<a href='"+GetPageUrl(nPage)+"' class=\"afms-ic_lastpage\">&raquo;</a>");
                                }
                                Response.Write("</div><br />");
                            }

                            %>
                       
                    </div>

                      <div class="text-center f-button" style="margin-top:30px;">
                       <table style="width:100%"><tr><td class="text-left">
                           <%if (drSTN["EquType"].ToString() != "STN")
                               { %> 
                           <button type="button" onclick="do_import()" class="afms-btn afms-btn-primary">Import</button></td>
                           <%} %>
                           <td class="text-center" style="padding-right:150px">
                                <%if (drSTN["EquType"].ToString() == "STN")
                               { %> 
                           <button id="import1" type="button" onclick="do_import1()" class="afms-btn afms-btn-primary">Import</button> &nbsp;
                           <%} %>
                <button type="button" onclick="do_uploads()" class="afms-btn afms-btn-primary">Upload</button> &nbsp;
                          <button type="button" onclick="do_downloads()" class="afms-btn afms-btn-primary">Download</button> &nbsp;
                <button type="button"onclick="do_deletes()" class="afms-btn afms-btn-secondary">Delete</button>
                           </td></tr></table> 
            </div>


                    <br />

                </div>
            </div>
        </div>

        <div class="afms-push"></div>
    </div>

    <!--#include file="../_inc/Ft.asp"-->
</body>

</html>
