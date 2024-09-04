<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FileManager.aspx.cs" Inherits="AFMProj.PlugIn.FileManager" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>File Manager</title>
    <style>
        body, div, table {
            font-family: Tahoma;
            font-size: 12px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            border: 1px solid #ccc;
            text-align: center;
            padding: 2px;
        }

        th {
            background: #eee;
        }

        .center {
            text-align: center !important;
        }

        .left {
            text-align: left !important;
        }

        .right {
            text-align: right !important;
        }

        button {
            padding: 2px 20px 2px 20px;
            margin: 20px 5px 20px 5px;
        }

        .footer {
            position: fixed;
            left: 0;
            bottom: 0;
            width: 100%;
            background-color: #eee;
            text-align: center;
        }
    </style>
    
    <script type="text/javascript" src="../_inc/js/jquery-3.2.0.min.js"></script>
    <script src="jquery.fileDownload.js"></script>
    <script>
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

        function do_delete(){
            if (confirm("Delete selected files?")) {


            }
        }

        function do_upload() {
            if (confirm("Upload selected files?")) {


            }
        }

        var downloads = [];
        function do_download(i,file) {
            var url = "download.ashx?poiid=<%=Request["poiid"]%>&token=<%=Request["token"]%>&file=" + file+"&i="+i;
            $.fileDownload(url);
            var download_key = "fileDownload_<%=Request["poiid"]%>_"+i;
            downloads.push(download_key);
            chk_process_i();
        }

        function chk_process_i() {
            for (var i = downloads.length - 1; i >= 0; i--) {
                var key = downloads[i];
                console.log(key + " " + getCookie(key));
                if (getCookie(key) == "true") {
                    $("#stat_" + key.split('_')[2]).html("");
                    setCookie(key, "", 1);
                    downloads.splice(i, 1);
                } else {
                    $("#stat_" + key.split('_')[2]).html("Download..");
                }
            }
        }

        function chk_process() {
            
            chk_process_i();

            setTimeout(function () {
                chk_process();
            }, 3 * 1000);
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
       
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table>
                <tr>
                    <th>
                        <input type="checkbox" id="checkedAll" /></th>
                    <th>Name</th>
                    <th>Type</th>
                    <th>Size</th>
                    <th>Date Modified</th>
                    <th>Download</th>
                    <th>Process</th>
                </tr>
                <%for (int i = 0; i < files.Count; i++)
                    { %>
                <tr>
                    <td>
                        <input type="checkbox" class="checkSingle" /></td>
                    <td class="left"><%=files[i].Name %></td>
                    <td><%=files[i].Type %></td>
                    <td class="right"><%=files[i].Size %></td>
                    <td class="right"><%=files[i].Date %></td>
                    <td><a href="javascript:do_download('<%=i %>','<%=files[i].Name.Replace("'","$") %>')">Download</a></td>
                    <td id="stat_<%=i%>"></td>
                </tr>

                <%} %>
            </table>
            
            <div class="center footer">
                <button type="button" onclick="do_upload()">Upload</button>
                <button type="button"onclick="do_delete()">Delete</button>
            </div>
        </div>
    </form>
    <div style="display:none">
    <div id="downloader"></div>
        </div>
</body>
</html>
