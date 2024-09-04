<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="mFDBStn.aspx.cs" Inherits="AFMProj.FMS.mFDBStn" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <!--#include file="../_inc/Title.asp"-->
    <style>
        .valid {
            color: red;
        }

        .Dec, .UTM, .Deg {
            display: none;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            parent.msgbox_save(<%=retID %>, "close");
            parent.loadItemStn();
            setPATZ();
            $("#CoorType").change(function () {
                var val = $(this).val();
                $(".UTM,.Deg,.Dec").hide();
                $("." + val).show();
            });

            $("." + $("#CoorType").val()).show();
            $("#Lat,#Lng").change(function () {
                var iframe = document.getElementById("iMap");
                var lat = $("#Lat").val();
                var lng = $("#Lng").val();
                iframe.contentWindow.iMap.map.setView([parseFloat(lat), parseFloat(lng)], 16);
            });
            $("#LatD,#LatM,#LatS,#LngD,#LngM,#LngS").change(function () {
                var lat, lng;
                var iframe = document.getElementById("iMap");
                var t_lat1 = $("#LatD").val();
                var t_lat2 = $("#LatM").val();
                var t_lat3 = $("#LatS").val();
                var t_lng1 = $("#LngD").val();
                var t_lng2 = $("#LngM").val();
                var t_lng3 = $("#LngS").val();

                if (t_lat1 == '' || isNaN(t_lat1) || t_lat2 == '' || isNaN(t_lat2) || t_lat3 == '' || isNaN(t_lat3)) {
                    return;
                } else {
                    lat = parseFloat(t_lat1) + parseFloat(t_lat2) / 60 + parseFloat(t_lat3) / 3600;
                    if (lat < -90 || lat > 90) {
                        err += "Invalid Latitude";
                    }
                }

                if (t_lng1 == '' || isNaN(t_lng1) || t_lng2 == '' || isNaN(t_lng2) || t_lng3 == '' || isNaN(t_lng3)) {
                    return;

                } else {
                    lng = parseFloat(t_lng1) + parseFloat(t_lng2) / 60 + parseFloat(t_lng3) / 3600;
                    if (lng < -180 || lng > 180) {
                        return;
                    }
                }

                iframe.contentWindow.iMap.map.setView([lat, lng], 16);
            });

            $("#UTMX,#UTMY,#UTMZ").change(function () {
                var lat, lng;
                var iframe = document.getElementById("iMap");
                var t_x = $("#UTMX").val();
                var t_y = $("#UTMY").val();
                var t_zone = $("#UTMZ").val();
                var zone = 47;
                if (t_x == '' || isNaN(t_x)) {
                    return;
                }
                if (t_y == '' || isNaN(t_y)) {
                    return;
                }
                if (t_zone == '' || isNaN(t_zone)) {
                    return;

                } else {
                    zone = parseInt(t_zone);
                    if (zone < 1 || zone > 60)
                        return;
                }
                var utm = new $UTM();
                var latlngs = [];
                utm.UTMXYToLatLon(parseFloat(t_x), parseFloat(t_y), zone, false, latlngs);
                lat = utm.RadToDeg(latlngs[0]);
                lng = utm.RadToDeg(latlngs[1]);
                iframe.contentWindow.iMap.map.setView([lat, lng], 16);
            });
            setTimeout(function () {
                setPageFno();
            }, 10);
            if (isNaN($("#Lat").val()) || isNaN($("#Lng").val()))
                return;
            setLatLng(parseFloat($("#Lat").val()), parseFloat($("#Lng").val()));
        });



        function setLatLng(lat, lng) {
            $("#Lat").val(lat.toFixed(8));
            $("#Lng").val(lng.toFixed(8));

            var latds = convertDDToDMS(lat);
            var lngds = convertDDToDMS(lng);

            $("#LatD").val(latds[0]);
            $("#LatM").val(latds[1]);
            $("#LatS").val(latds[2]);
            $("#LngD").val(lngds[0]);
            $("#LngM").val(lngds[1]);
            $("#LngS").val(lngds[2]);

            var utm = new $UTM();
            var xy = [];
            var zone = Math.floor((lng + 180.0) / 6) + 1;
            utm.LatLonToUTMXY(lat, lng, zone, xy);
            $("#UTMX").val(xy[0].toFixed(0));
            $("#UTMY").val(xy[1].toFixed(0));
            $("#UTMZ").val(zone);

        }

        function setPATZ() {
            setProv2('sProv2', '<%=PATCode.Substring(0,2) %>');
            setAumphur2('sAumphur2', '<%=PATCode.Substring(0,2) %>', '<%=PATCode.Substring(0,4) %>');
            setTumbon2('sTumbon2', '<%=PATCode.Substring(0,4) %>', '<%=PATCode.Substring(0,6) %>');

        }
        //
        function convertDDToDMS(dd) {
            var deg = dd | 0; // truncate dd to get degrees
            var frac = Math.abs(dd - deg); // get fractional part
            var min = (frac * 60) | 0; // multiply fraction by 60 and truncate
            var sec = frac * 3600 - min * 60;
            return [deg, min, sec.toFixed(4)];

        }

        var _fno = '<%=Request["fno"]%>';
        function setPageFno() {
            if (_fno != "add" && _fno != "edit") {
                $(".x-det").show();
                $(".x-add").hide();
                //$(".mrta-title span").html("");
                $(".form-group").each(function () {
                    var f = $(this);
                    var t = "";
                    //if(f.find("select").prop("id")) alert(f.html());

                    if (f.find("textarea").prop("id")) { t = f.find("textarea").val(); f.find("textarea").hide(); }
                    else if (f.find("input").prop("id") && f.find("input").prop("type") == "text") { t = f.find("input").val(); f.find("input").hide(); }
                    else if (f.find("select").prop("id")) {
                        t = f.find("select option:selected").text();
                        f.find(".bootstrap-select").hide();
                        f.find("select").removeClass("selectpicker");
                        f.find("select").hide();
                    }

                    if (t == "(กรุณาเลือก)") t = "";
                    if (t == "กรุณาเลือก") t = "";
                    t = t.replace("กรุณาเลือก", "");
                    t = t.replace("=== เลือก ===", "");
                    f.append('<p>' + t + '&nbsp;</p>');


                });
                $("input[type=checkbox]").attr("onclick", "return false");
                $("input[type=radio]").attr("onclick", "return false");
                $(".bootstrap-select").hide();
                $(".afms-content").addClass("content-readonly");
                $("#sProvText").html($("#sProv2 option:selected").text().replace("=== เลือก ===", "&nbsp;"));
                $("#sAumphurText").html($("#sAumphur2 option:selected").text().replace("=== เลือก ===", "&nbsp;"));
                $("#sTumbonText").html($("#sTumbon2 option:selected").text().replace("=== เลือก ===", "&nbsp;"));

            } else {
                $(".x-add").show();
                $(".x-det").hide();
                // $(".mrta-title span").html(_fno == "edit"?"แก้ไขข้อมูล":"เพิ่มข้อมูล");
            }
            //setIsAdd();
        }

    </script>
    <style>
        .f-table th, .f-table td {
            border: 1px solid #ccc;
            padding: 5px;
            text-align: center;
        }

        .f-table th {
            background: #eee;
        }
    </style>
    <script src="../_inc/js/dpv2.js"></script>
    <script src="../_inc/js/pvscp2.js?d=1"></script>
    <script src="../GIS/libs/utm.js"></script>
</head>
<body class="body-no-bg">
    <div class="container afms-sec-content">
        <form id="Modal" runat="server">
            <asp:ValidationSummary ID="ValidSum" runat="server" />
            <div class="afms-content">
                <div class="row">
                    <div class="col-12 col-md-6 col-lg-4">
                        <div class="form-group afms-field afms-field_input">
                            <label>ชื่อสถานี</label>
                            <input id="StName" runat="server" type="text" />

                        </div>
                        <div class="valid">
                            <asp:RequiredFieldValidator ID="rStName" ControlToValidate="StName" InitialValue="" runat="server" Display="Dynamic">* กรุณาระบุ</asp:RequiredFieldValidator>
                        </div>
                    </div>


                    <div class="col-12 col-md-6 col-lg-4">
                        <div class="form-group afms-field afms-field_input">
                            <label>ที่อยู่</label>
                            <input id="AdrNo" runat="server" type="text" />

                        </div>
                    </div>
                   
                    <div class="col-md-4">
								<div class="afms-field afms-field_select">
									<label>จังหวัด</label>
                                    
									<select id=sProv2  runat=server onchange="setAumphur2('sAumphur2',this.value,'0')" data-live-search="true">
                                        <option value="0">=== เลือก ===</option>
                                    </select>
                                    <div id="sProvText"></div>
								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_select">
									<label>อำเภอ</label>
									<select id=sAumphur2 runat=server  disabled=disabled onchange="setTumbon2('sTumbon2',this.value,'0')" data-live-search="true">
                                        <option value="0">=== เลือก ===</option>
                                    </select>
                                     <div id="sAumphurText"></div>
								</div>
							</div>
							<div class="col-md-4">
								<div class="afms-field afms-field_select">
									<label>ตำบล</label>

									<select id=sTumbon2 runat=server disabled=disabled data-live-search="true">
                                        <option value="0">=== เลือก ===</option>
                                    </select>
                                    <div id="sTumbonText"></div>
									
								</div>
							</div>
                    <div class="col-12 col-md-3 col-lg-3">
                        <div class="form-group afms-field afms-field_input">
                            <label>กำลังส่ง</label>
                            <input id="PW" runat="server" type="text"  />
                           
                        </div>
                         <div class="valid">
                                <asp:RangeValidator ID="rngPW" ControlToValidate="PW" Type="Double" MinimumValue="0" MaximumValue="100000" runat="server" Display="Dynamic">* กรุณาระบุเป็นตัวเลข</asp:RangeValidator>
                            </div>
                    </div>
                    <div class="col-12 col-md-3 col-lg-3">
                        <div class="form-group afms-field afms-field_select">
                            <label>หน่วย</label>
                            <select id="PWUnit" runat="server" class="selectpicker">
                                <option value="mW">mW</option>
                                <option value="W">W</option>
                                <option value="kW">kW</option>
                            </select>

                        </div>
                    </div>
                    <div class="col-12 col-md-3 col-lg-3">
                        <div class="form-group afms-field afms-field_input">
                            <label>ความสูงของเสา (ม.)</label>
                            <input id="H" runat="server" type="text" />
                           
                        </div>
                         <div class="valid">
                                <asp:RangeValidator ID="rngH" ControlToValidate="H" Type="Double" MinimumValue="0" MaximumValue="100000" runat="server" Display="Dynamic">* กรุณาระบุเป็นตัวเลข</asp:RangeValidator>
                            </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12 col-md-3 col-lg-3">
                        <div class="form-group  afms-field afms-field_select">
                            <label>พิกัด</label>
                            <select id="CoorType" runat="server" class="selectpicker">
                                <option value="Dec">Decimal</option>
                                <option value="Deg">Degrees</option>
                                <option value="UTM">UTM</option>
                            </select>

                        </div>
                    </div>
                    <div class="col-12 col-md-3 col-lg-3 Dec">
                        <div class="form-group afms-field afms-field_input">
                            <label>Latitude</label>
                            <input id="Lat" runat="server" type="text" />
                        </div>
                    </div>
                    <div class="col-12 col-md-3 col-lg-3 Dec">
                        <div class="form-group afms-field afms-field_input">
                            <label>Longitude</label>
                            <input id="Lng" runat="server" type="text" />

                        </div>
                    </div>

                    <div class="col-12 col-md-4 col-lg-4 Deg">
                        <div class="form-group afms-field afms-field_input">
                            <label>Latitude</label>
                            <div class="form-group">
                                <table>
                                    <tr>
                                        <td>
                                            <input id="LatD" runat="server" type="text" /></td>
                                        <td style="width:50px">&deg;</td>
                                        <td>
                                            <input id="LatM" runat="server" type="text" /></td>
                                        <td style="width:50px">'</td>
                                        <td>
                                            <input id="LatS" runat="server" type="text" /></td>
                                        <td style="width:50px">"</td>
                                    </tr>
                                </table>

                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4 col-lg-4 Deg">
                        <div class="form-group afms-field afms-field_input">
                            <label>Longitude</label>
                            <div class="form-group">
                                <table>
                                    <tr>
                                        <td>
                                            <input id="LngD" runat="server" type="text" /></td>
                                        <td style="width:50px">&deg;</td>
                                        <td>
                                            <input id="LngM" runat="server" type="text" /></td>
                                        <td style="width:50px">'</td>
                                        <td>
                                            <input id="LngS" runat="server" type="text" /></td>
                                        <td style="width:50px">"</td>
                                    </tr>
                                </table>

                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-2 col-lg-2 UTM">
                        <div class="form-group afms-field afms-field_input">
                            <label>Zone</label>
                            <input id="UTMZ" runat="server" type="text" />
                        </div>
                    </div>
                    <div class="col-12 col-md-3 col-lg-3 UTM">
                        <div class="form-group afms-field afms-field_input">
                            <label>X</label>
                            <input id="UTMX" runat="server" type="text" />

                        </div>
                    </div>
                    <div class="col-12 col-md-3 col-lg-3 UTM">
                        <div class="form-group afms-field afms-field_input">
                            <label>Y</label>
                            <input id="UTMY" runat="server" type="text"  />

                        </div>
                    </div>
                </div>
                <div class="col-12 col-md-12 col-lg-12">
                    <input id="Tools" runat="server" type="hidden" value="1" />
                    <%if (Request["fno"] == null)
                        { %>
                    <!--#include file="../GIS/EMapView.asp"-->

                    <%}
                    else
                    { %>
                    <!--#include file="../GIS/EMapEdit.asp"-->
                    <%} %>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="afms-btn afms-btn-secondary" data-dismiss="modal" onclick="parent.closeDialog()"><i class="afms-ic_x"></i>ปิด</button>
                <button type="button" class="afms-btn afms-btn-primary IsFMSEdit x-add" onserverclick="bSave_ServerClick" runat="server"><i class="afms-ic_save"></i> บันทึก</button>
                <button type="button" class="afms-btn afms-btn-primary IsFMSEdit x-det" onclick="location='mFDBStn.aspx?FuID=<%=Request["FuID"] %>&TmpKey=&StnID=<%=Request["StnID"] %>&fno=edit'"><i class="afms-ic_edit"></i> แก้ไข</button>
            </div>
        </form>
        <div class="afms-push"></div>
    </div>
</body>
</html>
