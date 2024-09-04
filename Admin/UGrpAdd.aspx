<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UGrpAdd.aspx.cs" Inherits="EBMSMap.Web.Admin.UGrpAdd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <!--#include file="../_inc/title.A.asp"-->
    <script language="javascript">
        $(function () {
            $("#UGrpList").jstree({
                'core': { 'data': <%=EBMSMap.Web.JSData.GetUGrps(Request["UGID"]) %> },
                "plugins": ["search"],
                "search": { show_only_matches: true }
            }).bind("select_node.jstree", function (e, data) {
                location = "UGrp.aspx?ugid=" + data.node.id;
            });

            $("#CapList").jstree({
                "checkbox": {
                    "keep_selected_style": false,
                    "tie_selection": false
                },
                "plugins": ["checkbox", "search"],
                "search": { show_only_matches: true }

            }).bind("select_node.jstree", function (e, data) {
                //$("#pOrgID").val(data.node.id);
            }).bind("ready.jstree", function (e, data) {
                $("#CapList").jstree("open_all");
                $('#CapList li').each(function () {
                    if ($("#hiddenDiv #" + this.id.replace("li_", "")).val() == "Y")
                        $("#CapList").jstree().check_node(this.id);
                });

                $("#CapList").on("check_node.jstree", function (e, data) {
                    updateCap();
                }).on("uncheck_node.jstree", function (e, data) {
                    updateCap();
                })
            });


        });

        function updateCap() {
            $("#hiddenDiv input").val("N");
            var tree = $('#CapList').jstree("get_checked", true);
            $.each(tree, function () {
                $("#hiddenDiv #" + this.id.replace("li_", "")).val("Y");
            });
            //alert($("#hiddenDiv #IsViewOnly").val());
        }

    </script>


</head>
<body class="nbtc-admin">
    <div class="nbtc-container">
        <!--#include file="../_inc/hd.A.asp"-->

        <div class="nbtc-sec-breadcrumb">
            <ul>
                <li><a href="#"><i class="nbtc-ic_home"></i></a><i class="nbtc-ic_next"></i></li>
                <li><a href="#">Admin Tools</a> <i class="nbtc-ic_next"></i></li>
                <li><a href="#">Account</a> <i class="nbtc-ic_next"></i></li>
                <li>Group Policy</li>
            </ul>
            <!--#include file="../_inc/Usr.asp"-->
        </div>

        <div class="nbtc-col nbtc-group-col3">
            <div class="nbtc-sec-left nbtc-col1">
                <div class="nbtc-sec-search">
                    <div class="nbtc-field nbtc-field_input has-right-icon">
                        <input type="text" onkeyup="search(this.value,'UGrpList')" />
                        <span class="bar"></span>
                        <label>ค้นหา</label>
                        <i class="nbtc-ic_search"></i>
                    </div>

                    <div class="nbtc-search-listx" style='background: #eee; padding: 10px;'>
                        <div id="UGrpList" style="height: 100%; background: Transparent"></div>
                    </div>
                </div>
            </div>
            <form id="Form1" runat="server">
                <div id="hiddenDiv">
                    <input type="hidden" id="IsDataMng" runat="server" />
                     <input type="hidden" id="IsRVI" runat="server" />
                     <input type="hidden" id="IsRMB" runat="server" />
                      <input type="hidden" id="IsVSS" runat="server" />
                    <input type="hidden" id="IsGPS" runat="server" />
                    <input type="hidden" id="IsCopEquipment" runat="server" />
                    <input type="hidden" id="IsCopViewOnly" runat="server" />
                    <input type="hidden" id="IsCopEdit" runat="server" />

                    <input type="hidden" id="IsFmsFMon" runat="server" />
                    <input type="hidden" id="IsFmsViewOnly" runat="server" />
                    <input type="hidden" id="IsFmsEdit" runat="server" />

                    <input type="hidden" id="IsDmsImp" runat="server" />
                    <input type="hidden" id="IsDmsViewOnly" runat="server" />

                    <input type="hidden" id="IsFmrControl" runat="server" />
                    <input type="hidden" id="IsFmrLive" runat="server" />
                    <input type="hidden" id="IsFmrPlayBack" runat="server" />
                    <input type="hidden" id="IsFmrMapViewOnly" runat="server" />
                    <input type="hidden" id="IsFmrMapEdit" runat="server" />
                    <input type="hidden" id="IsCopInfo" runat="server" />

                    <input type="hidden" id="IsISO05SvyView" runat="server" />
                    <input type="hidden" id="IsISO05SvyEdit" runat="server" />
                    <input type="hidden" id="IsISO05CompView" runat="server" />
                    <input type="hidden" id="IsISO05CompEdit" runat="server" />
                    <input type="hidden" id="IsISO09PlanView" runat="server" />
                    <input type="hidden" id="IsISO09PlanEdit" runat="server" />
                    <input type="hidden" id="IsISO09ChkView" runat="server" />
                    <input type="hidden" id="IsISO09ChkEdit" runat="server" />
                    <input type="hidden" id="IsISO26ChkView" runat="server" />
                    <input type="hidden" id="IsISO26ChkEdit" runat="server" />
                    <input type="hidden" id="IsISO10FreqView" runat="server" />
                    <input type="hidden" id="IsISO10FreqEdit" runat="server" />
                    <input type="hidden" id="IsISO11ChkView" runat="server" />
                    <input type="hidden" id="IsISO11ChkEdit" runat="server" />
                    <input type="hidden" id="IsISO12ChkView" runat="server" />
                    <input type="hidden" id="IsISO12ChkEdit" runat="server" />
                    <input type="hidden" id="IsISO13ChkView" runat="server" />
                    <input type="hidden" id="IsISO13ChkEdit" runat="server" />
                    <input type="hidden" id="IsISO14RaidView" runat="server" />
                    <input type="hidden" id="IsISO14RaidEdit" runat="server" />
                    <input type="hidden" id="IsISO14CaseView" runat="server" />
                    <input type="hidden" id="IsISO14CaseEdit" runat="server" />
                    <input type="hidden" id="IsISO15RecView" runat="server" />
                    <input type="hidden" id="IsISO15RecEdit" runat="server" />
                    <input type="hidden" id="IsISO15ChkView" runat="server" />
                    <input type="hidden" id="IsISO15ChkEdit" runat="server" />
                    <input type="hidden" id="IsISO16ShopView" runat="server" />
                    <input type="hidden" id="IsISO16ShopEdit" runat="server" />
                    <input type="hidden" id="IsISO16PlanView" runat="server" />
                    <input type="hidden" id="IsISO16PlanEdit" runat="server" />
                    <input type="hidden" id="IsISO16ChkView" runat="server" />
                    <input type="hidden" id="IsISO16ChkEdit" runat="server" />
                    <input type="hidden" id="IsISO17StnView" runat="server" />
                    <input type="hidden" id="IsISO17StnEdit" runat="server" />
                    <input type="hidden" id="IsISO17RadView" runat="server" />
                    <input type="hidden" id="IsISO17RadEdit" runat="server" />
                    <input type="hidden" id="IsISO18RepView" runat="server" />
                    <input type="hidden" id="IsISO18RepEdit" runat="server" />
                     <input type="hidden" id="IsISO28ChkView" runat="server" />
                    <input type="hidden" id="IsISO28ChkEdit" runat="server" />
                    <input type="hidden" id="IsISO29ChkView" runat="server" />
                    <input type="hidden" id="IsISO29ChkEdit" runat="server" />
                    <input type="hidden" id="IsISOPPEquipView" runat="server" />
                    <input type="hidden" id="IsISOPPEquipEdit" runat="server" />

                       <input type="hidden" id="IsCCTVMode" runat="server" />
                    <input type="hidden" id="IsCCTVMatch" runat="server" />
                    <input type="hidden" id="IsCCTVSource" runat="server" />
                    <input type="hidden" id="IsCCTVRep" runat="server" />

                </div>
                <div class="nbtc-sec-center nbtc-col2">
                    <div class="nbtc-sec-content">
                        <h2>Add Group Policy</h2>


                        <div class="nbtc-row">
                            <div class="nbtc-col1">
                                <div class="nbtc-field nbtc-field_input">
                                    <input type="text" id="Name" runat="server">
                                    <span class="bar"></span>
                                    <label>Group Name</label>
                                </div>
                                <asp:RequiredFieldValidator ID="rName" ControlToValidate="Name" runat="server" ErrorMessage="*<br /><br />" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>

                            </div>

                            <div class="clear"></div>
                        </div>



                        <div class="nbtc-row">
                            <div class="nbtc-col1">
                                <div class="nbtc-field nbtc-field_textarea">
                                    <textarea data-autoresize id="Detail" runat="server"></textarea>
                                    <span class="bar"></span>
                                    <label>Group Detail</label>
                                </div>
                            </div>

                            <div class="clear"></div>
                        </div>



                        <div class="nbtc-group-btn">
                            <input type="submit" id="bSave" value='บันทึก' runat="server" onserverclick="bSave_ServerClick" class="nbtc-btn nbtc-btn-primary" />
                            <input type="reset" id="bReset" value='ล้าง' runat="server" class="nbtc-btn nbtc-btn-secondary" />
                        </div>
                    </div>
                </div>
            </form>

            <div class="nbtc-sec-right nbtc-col1">

                <div class="nbtc-sec-grouppolicy">
                    <h2>Capability</h2>
                    <div class="nbtc-sec-search">
                        <div class="nbtc-field nbtc-field_input has-right-icon">
                            <input type="text" onkeyup="search(this.value,'CapList')" />
                            <span class="bar"></span>
                            <i class="nbtc-ic_search"></i>
                        </div>

                        <div class="nbtc-content" id="CapList">
                            <ul>
                                <li id="li_IsDataMng">Admin</li>
                                 <li id="li_IsRVI">R-Visualization</li>
                                <li id="li_IsRMB">R-Oper Mobile</li>
                                 <li id="li_IsVSS">Video Streaming</li>
                                  <li id="li_IsGPS">GPS Fleet Tracking</li>
                                <li id="li_IsAFM">AFM
                                 <ul>
                                     <li id="li_IsCop">COP
                                         <ul>
                                             <li id="li_IsCopEquipment">Equipment</li>
                                             <li id="li_IsCopViewOnly">View Only</li>
                                             <li id="li_IsCopEdit">Edit Data</li>
                                         </ul>
                                     </li>

                                     <li id="li_IsFms">FMS<ul>
                                         <li id="li_IsFmsFMon">Frequency Monitoring</li>
                                         <li id="li_IsFmsViewOnly">View Only</li>
                                         <li id="li_IsFmsEdit">Edit Data</li>
                                     </ul>
                                     </li>
                                 </ul>
                                </li>

                                <li id="li_IsDms">DMS<ul>
                                    <li id="li_IsDmsImp">Data Monitoring System  </li>
                                    <li id="li_IsDmsViewOnly">View Only</li>
                                </ul>
                                </li>

                                <li id="li_IsFmr">FMR
                                 <ul>
                                     <li id="li_IsFmrRadFnc">Radio Function
                                         <ul>
                                             <li id="li_IsFmrControl">Control</li>
                                             <li id="li_IsFmrLive">Live</li>
                                             <li id="li_IsFmrPlayBack">Playback</li>
                                         </ul>
                                     </li>

                                     <li id="li_IsFmrMapFnc">Map Function<ul>
                                         <li id="li_IsFmrMapViewOnly">View Only</li>
                                         <li id="li_IsFmrMapEdit">Edit Data</li>
                                     </ul>
                                     </li>
                                 </ul>
                                </li>
                                <li id="li_IsCopInfo">Cop Info</li>
                                  <li id="li_IsCCTV">CCTV
                                 <ul>
                                             <li id="li_IsCCTVMode">Mode</li>
                                             <li id="li_IsCCTVMatch">Matching</li>
                                             <li id="li_IsCCTVSource">Source</li>
                                                <li id="li_IsCCTVRep">Report</li>
                                         </ul>
                                </li>
                                <li id="li_IsISO">ISO
                                <ul>
                                    <li id="li_IsISO05">05 การสำรวจความพึงพอใจ
                                      <ul>
                                          <li id="li_IsISO05Svy">การสำรวจความพึงพอใจ
                                            <ul>
                                                <li id="li_IsISO05SvyView">View Only</li>
                                                <li id="li_IsISO05SvyEdit">Edit Data</li>
                                            </ul>
                                          </li>
                                          <li id="li_IsISO05Comp">การรับเรื่องร้องเรียน
                                            <ul>
                                                <li id="li_IsISO05CompView">View Only</li>
                                                <li id="li_IsISO05CompEdit">Edit Data</li>
                                            </ul>
                                          </li>
                                      </ul>
                                    </li>

                                    <li id="li_IsISO09">09 การวางแผนตรวจสอบคลื่น
                                      <ul>
                                          <li id="li_IsISO09Plan">บันทึกแผนการปฏิบัติงานตรวจสอบนอกสถานที่
                                            <ul>
                                                <li id="li_IsISO09PlanView">View Only</li>
                                                <li id="li_IsISO09PlanEdit">Edit Data</li>
                                            </ul>
                                          </li>
                                          <li id="li_IsISO09Chk">บันทึกทะเบียนคุมการตรวจสอบนอกแผน

                                            <ul>
                                                <li id="li_IsISO09ChkView">View Only</li>
                                                <li id="li_IsISO09ChkEdit">Edit Data</li>
                                            </ul>
                                          </li>
                                      </ul>
                                    </li>


                                    <li id="li_IsISO10Freq">10 บันทึกการตรวจสอบครอบครองความถี่
                                            <ul>
                                                <li id="li_IsISO10FreqView">View Only</li>
                                                <li id="li_IsISO10FreqEdit">Edit Data</li>
                                            </ul>
                                          </li>

                                    <li id="li_IsISO11Chk">11 การตรวจสอบมาตรฐานการแพร่
                                             <ul>
                                                 <li id="li_IsISO11ChkView">View Only</li>
                                                 <li id="li_IsISO11ChkEdit">Edit Data</li>
                                             </ul>
                                    </li>

                                    <li id="li_IsISO12Chk">12 การตรวจสอบแก้ไขการรบกวน
                                             <ul>
                                                 <li id="li_IsISO12ChkView">View Only</li>
                                                 <li id="li_IsISO12ChkEdit">Edit Data</li>
                                             </ul>
                                    </li>

                                    <li id="li_IsISO13Chk">13 การตรวจสอบความถี่ที่ไม่ได้รับอนุญาต
                                             <ul>
                                                 <li id="li_IsISO13ChkView">View Only</li>
                                                 <li id="li_IsISO13ChkEdit">Edit Data</li>
                                             </ul>
                                    </li>

                                    <li id="li_IsISO14">14 การตรวจค้นและจับกุมตามกฎหมาย
                                      <ul>
                                          <li id="li_IsISO14Raid">บันทึกการดำเนินการตรวจค้นจับกุม
                                            <ul>
                                                <li id="li_IsISO14RaidView">View Only</li>
                                                <li id="li_IsISO14RaidEdit">Edit Data</li>
                                            </ul>
                                          </li>
                                          <li id="li_IsISO14Case">บันทึกการติดตามผลคดี
                                            <ul>
                                                <li id="li_IsISO14CaseView">View Only</li>
                                                <li id="li_IsISO14CaseEdit">Edit Data</li>
                                            </ul>
                                          </li>
                                      </ul>
                                    </li>

                                    <li id="li_IsISO15">15 การตรวจพิสูจน์และการเก็บรักษาของกลาง
                                      <ul>
                                          <li id="li_IsISO15Rec">บันทึกการรับเครื่องวิทยุคมนาคมและอุปกรณ์ของกลาง
                                            <ul>
                                                <li id="li_IsISO15RecView">View Only</li>
                                                <li id="li_IsISO15RecEdit">Edit Data</li>
                                            </ul>
                                          </li>
                                          <li id="li_IsISO15Chk">บันทึกผลการตรวจสอบเครื่องวิทยุคมของกลางฯ
                                            <ul>
                                                <li id="li_IsISO15ChkView">View Only</li>
                                                <li id="li_IsISO15ChkEdit">Edit Data</li>
                                            </ul>
                                          </li>
                                      </ul>
                                    </li>


                                    <li id="li_IsISO16">16 การตรวจสำรองจำหน่ายเครื่อง
                                      <ul>
                                          <li id="li_IsISO16Shop">ข้อมูลผู้ประกอบการ/ร้านค้า/สถานี
                                            <ul>
                                                <li id="li_IsISO16ShopView">View Only</li>
                                                <li id="li_IsISO16ShopEdit">Edit Data</li>
                                            </ul>
                                          </li>
                                          <li id="li_IsISO16Plan">แผนการตรวจสำรองจำหน่าย
                                            <ul>
                                                <li id="li_IsISO16PlanView">View Only</li>
                                                <li id="li_IsISO16PlanEdit">Edit Data</li>
                                            </ul>
                                          </li>
                                          <li id="li_IsISO16Chk">การตรวจเครื่องวิทยุคมนาคมส่วนใดๆ
                                            <ul>
                                                <li id="li_IsISO16ChkView">View Only</li>
                                                <li id="li_IsISO16ChkEdit">Edit Data</li>
                                            </ul>
                                          </li>
                                      </ul>
                                    </li>

                                    <li id="li_IsISO17">17 การตรวจสอบเครื่องวิทยุคมนาคม
                                      <ul>
                                          <li id="li_IsISO17Stn">สถานีวิทยุคมนาคม
                                            <ul>
                                                <li id="li_IsISO17StnView">View Only</li>
                                                <li id="li_IsISO17StnEdit">Edit Data</li>
                                            </ul>
                                          </li>
                                          <li id="li_IsISO17Rad">เครื่องวิทยุคมนาคม
                                            <ul>
                                                <li id="li_IsISO17RadView">View Only</li>
                                                <li id="li_IsISO17RadEdit">Edit Data</li>
                                            </ul>
                                          </li>
                                      </ul>
                                    </li>


                                    <li id="li_IsISO18">18 การกำกับดูแลความปลอดภัยต่อสุขภาพ
                                             <ul>
                                                 <li id="li_IsISO18RepView">View Only</li>
                                                 <li id="li_IsISO18RepEdit">Edit Data</li>
                                             </ul>
                                    </li>

                                     <li id="li_IsISO26Chk">26 บันทึกการตรวจสอบความพร้อมของรถตรวจสอบฯ
                                            <ul>
                                                <li id="li_IsISO26ChkView">View Only</li>
                                                <li id="li_IsISO26ChkEdit">Edit Data</li>
                                            </ul>
                                          </li>

                                    <li id="li_IsISO28Chk">28 รายงานการตรวจสอบเนื้อหารายการและโฆษณาของวิทยุกระจายเสียง
                                             <ul>
                                                 <li id="li_IsISO28ChkView">View Only</li>
                                                 <li id="li_IsISO28ChkEdit">Edit Data</li>
                                             </ul>
                                    </li>

                                    <li id="li_IsISO29Chk">29 รายงานการตรวจสอบเนื้อหารายการและโฆษณาของโทรทัศน์แบบบอกรับสมาชิก
                                             <ul>
                                                 <li id="li_IsISO29ChkView">View Only</li>
                                                 <li id="li_IsISO29ChkEdit">Edit Data</li>
                                             </ul>
                                    </li>


                                    <li id="li_IsISOPP">การบริหารจัดการอุปกรณ์และเครื่องมือ
                                      <ul>
                                          <li id="li_IsISOPPEquip">ฐานข้อมูลอุปกรณ์
                                            <ul>
                                                <li id="li_IsISOPPEquipView">View Only</li>
                                                <li id="li_IsISOPPEquipEdit">Edit Data</li>
                                            </ul>
                                          </li>

                                      </ul>
                                    </li>



                                </ul>
                                </li>

                            </ul>
                        </div>
                    </div>
                </div>




            </div>
        </div>
        <div class="push"></div>
    </div>

    <!--#include file="../_Inc/Ft.A.asp"-->


    <script language="javascript">
        msgbox_save(<%=retID %>,"UGrp.aspx?ugid=<%=retID %>");

    </script>
</body>
</html>
