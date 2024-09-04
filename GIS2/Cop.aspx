<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Cop.aspx.cs" Inherits="EBMSMap30.GIS2.Cop" %>

<!doctype html>
<html lang="en">

<head>
    <title>Title</title>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="css/jquery-ui.css">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="css/bootstrap-select.min.css">
    <!-- <link rel="stylesheet" href="css/jstree-theme.css" /> -->
    <!-- <link rel="stylesheet"
        href="http://www.orangehilldev.com/jstree-bootstrap-theme/demo/assets/dist/themes/proton/style.css" />
    <link rel="stylesheet" href="css/jstree.min.css" /> -->

    <link rel="stylesheet" href="http://www.orangehilldev.com/jstree-bootstrap-theme/demo/assets/dist/themes/proton/style.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.0.9/themes/default/style.min.css" />
    <!-- <link rel="stylesheet" href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css"> -->
    <!-- <link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.1.6/css/fixedHeader.dataTables.min.css"> -->
    <link rel="stylesheet" href="css/bootstrap-colorpicker.css">
    <link rel="stylesheet" href="css/bootstrap-datepicker.css">
    <link rel="stylesheet" href="css/bootstrap-datepicker3.css">
    <link rel="stylesheet" href="css/bootstrap-timepicker.css">
    <link rel="stylesheet" href="icon/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/lightgallery@1.7.2/dist/css/lightgallery.min.css">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/responsive.css">
    
</head>

<body>

    <div class="nbtcm-page-wrapper">

        <!-- <div class="nbtcm-backdrop is-active d-md-none"></div> -->

        <div class="nbtcm-sidebar">
            <div class="nbtcm-sidebar-header">
                <img src="img/logo_s.png" alt="">
                <div>
                    <div class="nbtcm-brand-name"><span class="color-primary">NBTC AUTOMATIC FREQUENCY</span> MONITORING SYSTEM
                    </div>
                    <div>สำนักงานคณะกรรมการกิจการกระจายเสียง กิจการโทรทัศน์ และกิจการโทรคมนาคมแห่งชาติ</div>
                </div>
                <button class="btn btn-secondary btn-sm nbtcm-btn-menu"><span class="afms-ic_menu"></span></button>
            </div>
            <div class="nbtcm-sidebar-content">
                <nav class="nbtcm-sidebar-main-tabs">
                    <div class="nav nav-tabs" role="tablist">
                        <a class="nav-item nav-link active" data-toggle="tab" href="#sb-equip" role="tab" aria-selected="true">Equip</a>
                        <a class="nav-item nav-link" data-toggle="tab" href="#sb-event" role="tab" aria-selected="false">Event</a>
                        <a class="nav-item nav-link" data-toggle="tab" href="#sb-layer" role="tab" aria-selected="false">Layer</a>
                        <a class="nav-item nav-link" data-toggle="tab" href="#sb-history" role="tab" aria-selected="false">History</a>
                        <a class="nav-item nav-link" data-toggle="tab" href="#sb-route" role="tab" aria-selected="false">Route</a>
                    </div>
                </nav>
                <div class="tab-content">
                    <div class="tab-pane fade show active" id="sb-equip" role="tabpanel">
                        <div class="d-flex justify-content-center mb-2">
                            <div class="btn-group btn-group-sm nav nav-tabs" role="tablist">
                                <a class="nav-item nav-link btn btn-outline-secondary active" data-toggle="tab" href="#sb-equip-afm" role="tab" aria-selected="true">AFM</a>
                                <a class="nav-item nav-link btn btn-outline-secondary" data-toggle="tab" href="#sb-equip-remote" role="tab" aria-selected="false">Remote</a>
                                <a class="nav-item nav-link btn btn-outline-secondary" data-toggle="tab" href="#sb-equip-mobile" role="tab" aria-selected="false">Mobile</a>
                                <a class="nav-item nav-link btn btn-outline-secondary" data-toggle="tab" href="#sb-equip-handheld" role="tab" aria-selected="false">Handheld</a>
                                <a class="nav-item nav-link btn btn-outline-secondary" data-toggle="tab" href="#sb-equip-gps" role="tab" aria-selected="false">GPS</a>
                            </div>
                        </div>
                        <div class="tab-content">
                            <div class="tab-pane fade show active" id="sb-equip-afm" role="tabpanel">
                                <ul>
                                    <li>
                                        <div data-toggle="collapse" href="#sb-equip-afm-1" role="button"><span class="afms-ic_next"></span><b>Equipment</b></div>
                                        <ul class="collapse show lv-2" id="sb-equip-afm-1">
                                            <li>
                                                <div data-toggle="collapse" href="#sb-equip-afm-1-1" role="button">
                                                    <span class="afms-ic_next"></span><span>ส่วนกลาง</span></div>
                                                <ul class="collapse show lv-3" id="sb-equip-afm-1-1">
                                                    <li>
                                                        <div class="d-flex align-items-center">
                                                            <span class="afms-ic_unlock mr-1"></span>
                                                            <span class="afms-ic_record mr-1"></span>
                                                            <div class="flex-grow-1 mr-1">RLX-810-Test</div>
                                                            <div class="ml-auto d-flex align-items-center nbtcm-sidebar-action">
                                                                <span class="nbtcm-btn-display afms-ic_view mr-1" data-toggle="tooltip" data-placement="top" title="Display"></span>
                                                                <span class="nbtcm-btn-focus afms-ic_focus mr-1" data-toggle="tooltip" data-placement="top" title="Focus"></span>
                                                                <a href="ddd" class="afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></a>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="d-flex align-items-center">
                                                            <span class="afms-ic_unlock mr-1"></span>
                                                            <span class="afms-ic_record mr-1"></span>
                                                            <div class="flex-grow-1 mr-1">RLX-810-Test</div>
                                                            <div class="ml-auto d-flex align-items-center nbtcm-sidebar-action">
                                                                <span class="nbtcm-btn-display afms-ic_view mr-1" data-toggle="tooltip" data-placement="top" title="Display"></span>
                                                                <span class="nbtcm-btn-focus afms-ic_focus mr-1" data-toggle="tooltip" data-placement="top" title="Focus"></span>
                                                                <a href="ddd" class="afms-ic_control" data-toggle="tooltip" data-placement="top" title="Control"></a>
                                                            </div>
                                                        </div>
                                                    </li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </div>
                            <div class="tab-pane fade" id="sb-equip-remote" role="tabpanel">
                                <ul>
                                    <li>
                                        <div data-toggle="collapse" href="#sb-equip-afm-1" role="button"><span class="afms-ic_next"></span><b>Equipment</b></div>
                                        <ul class="collapse show lv-2" id="sb-equip-afm-1">
                                            <li>
                                                <div data-toggle="collapse" href="#sb-equip-afm-1-1" role="button">
                                                    <span class="afms-ic_next"></span><span>ส่วนกลาง</span></div>
                                                <ul class="collapse show lv-3" id="sb-equip-afm-1-1">
                                                    <li>
                                                        <div class="d-flex align-items-center">
                                                            <span class="afms-ic_unlock mr-1"></span>
                                                            <span class="afms-ic_record mr-1"></span>
                                                            <div class="flex-grow-1 mr-1">RLX-810-Test</div>
                                                            <div class="ml-auto d-flex align-items-center nbtcm-sidebar-action">
                                                                <span class="afms-ic_view mr-1" data-toggle="tooltip" data-placement="top" title="Display"></span>
                                                                <span class="afms-ic_focus mr-1" data-toggle="tooltip" data-placement="top" title="Focus"></span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="d-flex align-items-center">
                                                            <span class="afms-ic_unlock mr-1"></span>
                                                            <span class="afms-ic_record mr-1"></span>
                                                            <div class="flex-grow-1 mr-1">RLX-810-Test</div>
                                                            <div class="ml-auto d-flex align-items-center nbtcm-sidebar-action">
                                                                <span class="afms-ic_view mr-1" data-toggle="tooltip" data-placement="top" title="Display"></span>
                                                                <span class="afms-ic_focus mr-1" data-toggle="tooltip" data-placement="top" title="Focus"></span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <div data-toggle="collapse" href="#sb-equip-afm-1" role="button"><span class="afms-ic_next"></span><b>Equipment</b></div>
                                        <ul class="collapse show lv-2" id="sb-equip-afm-1">
                                            <li>
                                                <div data-toggle="collapse" href="#sb-equip-afm-1-1" role="button">
                                                    <span class="afms-ic_next"></span><span>ส่วนกลาง</span></div>
                                                <ul class="collapse show lv-3" id="sb-equip-afm-1-1">
                                                    <li>
                                                        <div class="d-flex align-items-center">
                                                            <span class="afms-ic_unlock mr-1"></span>
                                                            <span class="afms-ic_record mr-1"></span>
                                                            <div class="flex-grow-1 mr-1">RLX-810-Test</div>
                                                            <div class="ml-auto d-flex align-items-center nbtcm-sidebar-action">
                                                                <span class="afms-ic_view mr-1" data-toggle="tooltip" data-placement="top" title="Display"></span>
                                                                <span class="afms-ic_focus mr-1" data-toggle="tooltip" data-placement="top" title="Focus"></span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="d-flex align-items-center">
                                                            <span class="afms-ic_unlock mr-1"></span>
                                                            <span class="afms-ic_record mr-1"></span>
                                                            <div class="flex-grow-1 mr-1">RLX-810-Test</div>
                                                            <div class="ml-auto d-flex align-items-center nbtcm-sidebar-action">
                                                                <span class="afms-ic_view mr-1" data-toggle="tooltip" data-placement="top" title="Display"></span>
                                                                <span class="afms-ic_focus mr-1" data-toggle="tooltip" data-placement="top" title="Focus"></span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </div>
                            <div class="tab-pane fade" id="sb-equip-mobile" role="tabpanel">
                                <ul>
                                    <li>
                                        <div data-toggle="collapse" href="#sb-equip-afm-1" role="button"><span class="afms-ic_next"></span><b>Equipment</b></div>
                                        <ul class="collapse show lv-2" id="sb-equip-afm-1">
                                            <li>
                                                <div data-toggle="collapse" href="#sb-equip-afm-1-1" role="button">
                                                    <span class="afms-ic_next"></span><span>ส่วนกลาง</span></div>
                                                <ul class="collapse show lv-3" id="sb-equip-afm-1-1">
                                                    <li>
                                                        <div class="d-flex align-items-center">
                                                            <span class="afms-ic_unlock mr-1"></span>
                                                            <span class="afms-ic_record mr-1"></span>
                                                            <div class="flex-grow-1 mr-1">RLX-810-Test</div>
                                                            <div class="ml-auto d-flex align-items-center nbtcm-sidebar-action">
                                                                <span class="afms-ic_view mr-1" data-toggle="tooltip" data-placement="top" title="Display"></span>
                                                                <span class="afms-ic_focus mr-1" data-toggle="tooltip" data-placement="top" title="Focus"></span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="d-flex align-items-center">
                                                            <span class="afms-ic_unlock mr-1"></span>
                                                            <span class="afms-ic_record mr-1"></span>
                                                            <div class="flex-grow-1 mr-1">RLX-810-Test</div>
                                                            <div class="ml-auto d-flex align-items-center nbtcm-sidebar-action">
                                                                <span class="afms-ic_view mr-1" data-toggle="tooltip" data-placement="top" title="Display"></span>
                                                                <span class="afms-ic_focus mr-1" data-toggle="tooltip" data-placement="top" title="Focus"></span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <div data-toggle="collapse" href="#sb-equip-afm-1" role="button"><span class="afms-ic_next"></span><b>Equipment</b></div>
                                        <ul class="collapse show lv-2" id="sb-equip-afm-1">
                                            <li>
                                                <div data-toggle="collapse" href="#sb-equip-afm-1-1" role="button">
                                                    <span class="afms-ic_next"></span><span>ส่วนกลาง</span></div>
                                                <ul class="collapse show lv-3" id="sb-equip-afm-1-1">
                                                    <li>
                                                        <div class="d-flex align-items-center">
                                                            <span class="afms-ic_unlock mr-1"></span>
                                                            <span class="afms-ic_record mr-1"></span>
                                                            <div class="flex-grow-1 mr-1">RLX-810-Test</div>
                                                            <div class="ml-auto d-flex align-items-center nbtcm-sidebar-action">
                                                                <span class="afms-ic_view mr-1" data-toggle="tooltip" data-placement="top" title="Display"></span>
                                                                <span class="afms-ic_focus mr-1" data-toggle="tooltip" data-placement="top" title="Focus"></span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="d-flex align-items-center">
                                                            <span class="afms-ic_unlock mr-1"></span>
                                                            <span class="afms-ic_record mr-1"></span>
                                                            <div class="flex-grow-1 mr-1">RLX-810-Test</div>
                                                            <div class="ml-auto d-flex align-items-center nbtcm-sidebar-action">
                                                                <span class="afms-ic_view mr-1" data-toggle="tooltip" data-placement="top" title="Display"></span>
                                                                <span class="afms-ic_focus mr-1" data-toggle="tooltip" data-placement="top" title="Focus"></span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </div>
                            <div class="tab-pane fade" id="sb-equip-handheld" role="tabpanel">
                                <ul>
                                    <li>
                                        <div data-toggle="collapse" href="#sb-equip-afm-1" role="button"><span class="afms-ic_next"></span><b>Equipment</b></div>
                                        <ul class="collapse show lv-2" id="sb-equip-afm-1">
                                            <li>
                                                <div data-toggle="collapse" href="#sb-equip-afm-1-1" role="button">
                                                    <span class="afms-ic_next"></span><span>ส่วนกลาง</span></div>
                                                <ul class="collapse show lv-3" id="sb-equip-afm-1-1">
                                                    <li>
                                                        <div class="d-flex align-items-center">
                                                            <span class="afms-ic_unlock mr-1"></span>
                                                            <span class="afms-ic_record mr-1"></span>
                                                            <div class="flex-grow-1 mr-1">RLX-810-Test</div>
                                                            <div class="ml-auto d-flex align-items-center nbtcm-sidebar-action">
                                                                <span class="afms-ic_view mr-1" data-toggle="tooltip" data-placement="top" title="Display"></span>
                                                                <span class="afms-ic_focus mr-1" data-toggle="tooltip" data-placement="top" title="Focus"></span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="d-flex align-items-center">
                                                            <span class="afms-ic_unlock mr-1"></span>
                                                            <span class="afms-ic_record mr-1"></span>
                                                            <div class="flex-grow-1 mr-1">RLX-810-Test</div>
                                                            <div class="ml-auto d-flex align-items-center nbtcm-sidebar-action">
                                                                <span class="afms-ic_view mr-1" data-toggle="tooltip" data-placement="top" title="Display"></span>
                                                                <span class="afms-ic_focus mr-1" data-toggle="tooltip" data-placement="top" title="Focus"></span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <div data-toggle="collapse" href="#sb-equip-afm-1" role="button"><span class="afms-ic_next"></span><b>Equipment</b></div>
                                        <ul class="collapse show lv-2" id="sb-equip-afm-1">
                                            <li>
                                                <div data-toggle="collapse" href="#sb-equip-afm-1-1" role="button">
                                                    <span class="afms-ic_next"></span><span>ส่วนกลาง</span></div>
                                                <ul class="collapse show lv-3" id="sb-equip-afm-1-1">
                                                    <li>
                                                        <div class="d-flex align-items-center">
                                                            <span class="afms-ic_unlock mr-1"></span>
                                                            <span class="afms-ic_record mr-1"></span>
                                                            <div class="flex-grow-1 mr-1">RLX-810-Test</div>
                                                            <div class="ml-auto d-flex align-items-center nbtcm-sidebar-action">
                                                                <span class="afms-ic_view mr-1" data-toggle="tooltip" data-placement="top" title="Display"></span>
                                                                <span class="afms-ic_focus mr-1" data-toggle="tooltip" data-placement="top" title="Focus"></span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="d-flex align-items-center">
                                                            <span class="afms-ic_unlock mr-1"></span>
                                                            <span class="afms-ic_record mr-1"></span>
                                                            <div class="flex-grow-1 mr-1">RLX-810-Test</div>
                                                            <div class="ml-auto d-flex align-items-center nbtcm-sidebar-action">
                                                                <span class="afms-ic_view mr-1" data-toggle="tooltip" data-placement="top" title="Display"></span>
                                                                <span class="afms-ic_focus mr-1" data-toggle="tooltip" data-placement="top" title="Focus"></span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </div>
                            <div class="tab-pane fade" id="sb-equip-gps" role="tabpanel">
                                <ul>
                                    <li>
                                        <div data-toggle="collapse" href="#sb-equip-afm-1" role="button"><span class="afms-ic_next"></span><b>Equipment</b></div>
                                        <ul class="collapse show lv-2" id="sb-equip-afm-1">
                                            <li>
                                                <div data-toggle="collapse" href="#sb-equip-afm-1-1" role="button">
                                                    <span class="afms-ic_next"></span><span>ส่วนกลาง</span></div>
                                                <ul class="collapse show lv-3" id="sb-equip-afm-1-1">
                                                    <li>
                                                        <div class="d-flex align-items-center">
                                                            <span class="afms-ic_unlock mr-1"></span>
                                                            <span class="afms-ic_record mr-1"></span>
                                                            <div class="flex-grow-1 mr-1">RLX-810-Test</div>
                                                            <div class="ml-auto d-flex align-items-center nbtcm-sidebar-action">
                                                                <span class="afms-ic_view mr-1" data-toggle="tooltip" data-placement="top" title="Display"></span>
                                                                <span class="afms-ic_focus mr-1" data-toggle="tooltip" data-placement="top" title="Focus"></span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="d-flex align-items-center">
                                                            <span class="afms-ic_unlock mr-1"></span>
                                                            <span class="afms-ic_record mr-1"></span>
                                                            <div class="flex-grow-1 mr-1">RLX-810-Test</div>
                                                            <div class="ml-auto d-flex align-items-center nbtcm-sidebar-action">
                                                                <span class="afms-ic_view mr-1" data-toggle="tooltip" data-placement="top" title="Display"></span>
                                                                <span class="afms-ic_focus mr-1" data-toggle="tooltip" data-placement="top" title="Focus"></span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <div data-toggle="collapse" href="#sb-equip-afm-1" role="button"><span class="afms-ic_next"></span><b>Equipment</b></div>
                                        <ul class="collapse show lv-2" id="sb-equip-afm-1">
                                            <li>
                                                <div data-toggle="collapse" href="#sb-equip-afm-1-1" role="button">
                                                    <span class="afms-ic_next"></span><span>ส่วนกลาง</span></div>
                                                <ul class="collapse show lv-3" id="sb-equip-afm-1-1">
                                                    <li>
                                                        <div class="d-flex align-items-center">
                                                            <span class="afms-ic_unlock mr-1"></span>
                                                            <span class="afms-ic_record mr-1"></span>
                                                            <div class="flex-grow-1 mr-1">RLX-810-Test</div>
                                                            <div class="ml-auto d-flex align-items-center nbtcm-sidebar-action">
                                                                <span class="afms-ic_view mr-1" data-toggle="tooltip" data-placement="top" title="Display"></span>
                                                                <span class="afms-ic_focus mr-1" data-toggle="tooltip" data-placement="top" title="Focus"></span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="d-flex align-items-center">
                                                            <span class="afms-ic_unlock mr-1"></span>
                                                            <span class="afms-ic_record mr-1"></span>
                                                            <div class="flex-grow-1 mr-1">RLX-810-Test</div>
                                                            <div class="ml-auto d-flex align-items-center nbtcm-sidebar-action">
                                                                <span class="afms-ic_view mr-1" data-toggle="tooltip" data-placement="top" title="Display"></span>
                                                                <span class="afms-ic_focus mr-1" data-toggle="tooltip" data-placement="top" title="Focus"></span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="sb-event" role="tabpanel">
                        <div class="form-row">
                            <div class="form-group col-12">
                                <label>Equipment</label>
                                <select class="selectpicker" data-style="btn-outline-secondary btn-sm" data-live-search="true">
                                    <option>ทั้งหมด</option>
                                </select>
                            </div>
                            <div class="form-group col-12">
                                <label>Event</label>
                                <select class="selectpicker" data-style="btn-outline-secondary btn-sm" data-live-search="true">
                                    <option>ทั้งหมด</option>
                                </select>
                            </div>
                            <div class="form-group mb-0 col-12">
                                <div class="mt-2 d-flex justify-content-center">
                                    <button type="button" class="btn btn-primary nbtcm-event-btn-search flex-grow-1">ค้นหา</button>
                                </div>
                            </div>
                        </div>
                        <div class="nbtcm-sidebar-event-table d-none">
                            <table class="table table-sm" id="example" style="width: 100%">
                                <thead>
                                    <tr>
                                        <th>Scanner</th>
                                        <th>วันเวลา<br>ที่ตรวจพบ</th>
                                        <th>ความถี่</th>
                                        <th>ความแรง</th>
                                        <th>ผู้ครอบครอง</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Station-4</td>
                                        <td>2561-08-23 14:50:00</td>
                                        <td>107.25</td>
                                        <td>-67.620026</td>
                                        <td>เพื่อการศึกษาและพัฒนาอาชีพ (R-Radio Network) วิทยาลัยการอาชีพไชยา</td>
                                    </tr>
                                    <tr>
                                        <td>Station-4</td>
                                        <td>2561-08-23 14:50:00</td>
                                        <td>107.25</td>
                                        <td>-67.620026</td>
                                        <td>เพื่อการศึกษาและพัฒนาอาชีพ (R-Radio Network) วิทยาลัยการอาชีพไชยา</td>
                                    </tr>
                                    <tr>
                                        <td>Station-4</td>
                                        <td>2561-08-23 14:50:00</td>
                                        <td>107.25</td>
                                        <td>-67.620026</td>
                                        <td>เพื่อการศึกษาและพัฒนาอาชีพ (R-Radio Network) วิทยาลัยการอาชีพไชยา</td>
                                    </tr>
                                    <tr>
                                        <td>Station-4</td>
                                        <td>2561-08-23 14:50:00</td>
                                        <td>107.25</td>
                                        <td>-67.620026</td>
                                        <td>เพื่อการศึกษาและพัฒนาอาชีพ (R-Radio Network) วิทยาลัยการอาชีพไชยา</td>
                                    </tr>
                                    <tr>
                                        <td>Station-4</td>
                                        <td>2561-08-23 14:50:00</td>
                                        <td>107.25</td>
                                        <td>-67.620026</td>
                                        <td>เพื่อการศึกษาและพัฒนาอาชีพ (R-Radio Network) วิทยาลัยการอาชีพไชยา</td>
                                    </tr>
                                    <tr>
                                        <td>Station-4</td>
                                        <td>2561-08-23 14:50:00</td>
                                        <td>107.25</td>
                                        <td>-67.620026</td>
                                        <td>เพื่อการศึกษาและพัฒนาอาชีพ (R-Radio Network) วิทยาลัยการอาชีพไชยา</td>
                                    </tr>
                                    <tr>
                                        <td>Station-4</td>
                                        <td>2561-08-23 14:50:00</td>
                                        <td>107.25</td>
                                        <td>-67.620026</td>
                                        <td>เพื่อการศึกษาและพัฒนาอาชีพ (R-Radio Network) วิทยาลัยการอาชีพไชยา</td>
                                    </tr>
                                    <tr>
                                        <td>Station-4</td>
                                        <td>2561-08-23 14:50:00</td>
                                        <td>107.25</td>
                                        <td>-67.620026</td>
                                        <td>เพื่อการศึกษาและพัฒนาอาชีพ (R-Radio Network) วิทยาลัยการอาชีพไชยา</td>
                                    </tr>
                                    <tr>
                                        <td>Station-4</td>
                                        <td>2561-08-23 14:50:00</td>
                                        <td>107.25</td>
                                        <td>-67.620026</td>
                                        <td>เพื่อการศึกษาและพัฒนาอาชีพ (R-Radio Network) วิทยาลัยการอาชีพไชยา</td>
                                    </tr>
                                    <tr>
                                        <td>Station-4</td>
                                        <td>2561-08-23 14:50:00</td>
                                        <td>107.25</td>
                                        <td>-67.620026</td>
                                        <td>เพื่อการศึกษาและพัฒนาอาชีพ (R-Radio Network) วิทยาลัยการอาชีพไชยา</td>
                                    </tr>
                                    <tr>
                                        <td>Station-4</td>
                                        <td>2561-08-23 14:50:00</td>
                                        <td>107.25</td>
                                        <td>-67.620026</td>
                                        <td>เพื่อการศึกษาและพัฒนาอาชีพ (R-Radio Network) วิทยาลัยการอาชีพไชยา</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="sb-layer" role="tabpanel">
                        <div class="d-flex justify-content-center mb-2">
                            <div class="btn-group btn-group-sm nav nav-tabs" role="tablist">
                                <a class="nav-item nav-link btn btn-outline-secondary active" data-toggle="tab" href="#sb-layer-1" role="tab" aria-selected="true">ค้นหาจากฐานข้อมูล</a>
                                <a class="nav-item nav-link btn btn-outline-secondary" data-toggle="tab" href="#sb-layer-2" role="tab" aria-selected="false">แสดงชั้นข้อมูล</a>
                            </div>
                        </div>
                        <div class="tab-content">
                            <div class="tab-pane fade show active" id="sb-layer-1" role="tabpanel">
                                <div class="form-row">
                                    <div class="form-group col-12 d-flex flex-row">
                                        <div class="form-check col-6">
                                            <input class="form-check-input" type="radio" name="gridRadios" id="sb-layer-1-tab-1" value="option1" checked>
                                            <label class="form-check-label" for="sb-layer-1-tab-1">
                                                ค้นหารายละเอียด
                                            </label>
                                        </div>
                                        <div class="form-check col-6">
                                            <input class="form-check-input" type="radio" name="gridRadios" id="sb-layer-1-tab-2" value="option2">
                                            <label class="form-check-label" for="sb-layer-1-tab-2">
                                                ค้นหาจากตำแหน่ง
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-content">
                                    <div class="tab-pane fade show active" id="sb-layer-1-1" role="tabpanel">
                                        <div class="form-row">
                                            <div class="form-group col-12">
                                                <label for="inputEmail4">รายละเอียด</label>
                                                <input type="text" class="form-control form-control-sm" id="inputEmail4">
                                            </div>
                                            <div class="form-group col-12">
                                                <label>จังหวัด</label>
                                                <select class="selectpicker" data-style="btn-outline-secondary btn-sm" data-live-search="true">
                                                    <option>ทั้งหมด</option>
                                                </select>
                                            </div>
                                            <div class="form-group col-12">
                                                <label>อำเภอ</label>
                                                <select class="selectpicker" data-style="btn-outline-secondary btn-sm" data-live-search="true">
                                                    <option>ทั้งหมด</option>
                                                </select>
                                            </div>
                                            <div class="form-group col-12">
                                                <label>ตำบล</label>
                                                <select class="selectpicker" data-style="btn-outline-secondary btn-sm" data-live-search="true">
                                                    <option>ทั้งหมด</option>
                                                </select>
                                            </div>
                                        </div>
                                        <b>ชั้นข้อมูล</b>
                                        <div class="nbtcm-jstree mt-2">
                                            <ul>
                                                <li class="top-menu-invisible ">
                                                    <a href="#"><i></i> <span class="menu-item-parent">Web
                                                            Development</span><b class="collapse-sign"><em
                                                                class="fa fa-plus-square-o"></em></b></a>
                                                    <ul>
                                                        <li class="top-menu-invisible ">
                                                            <a href="#"><i></i> <span class="menu-item-parent">Site
                                                                    Settings</span><b class="collapse-sign"><em
                                                                        class="fa fa-plus-square-o"></em></b></a>
                                                            <ul>
                                                                <li>
                                                                    <a title="Amend" href="/"><i></i> <span
                                                                            class="menu-item-parent">Amend</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="Refresh" href="/"><i></i> <span
                                                                            class="menu-item-parent">Refresh</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="Refresh Translations" href="/"><i></i>
                                                                        <span class="menu-item-parent">Refresh
                                                                            Translations</span></a>
                                                                </li>
                                                            </ul>
                                                        </li>
                                                        <li class="top-menu-invisible ">
                                                            <a href="#"><i></i> <span class="menu-item-parent">Site
                                                                    Frame</span><b class="collapse-sign"><em
                                                                        class="fa fa-plus-square-o"></em></b></a>
                                                            <ul>
                                                                <li>
                                                                    <a title="Location" href="/"><i></i> <span
                                                                            class="menu-item-parent">Location</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="Partial View" href="/"><i></i> <span
                                                                            class="menu-item-parent">Partial
                                                                            View</span></a>
                                                                </li>
                                                            </ul>
                                                        </li>
                                                        <li class="top-menu-invisible ">
                                                            <a href="#"><i></i> <span class="menu-item-parent">Upload
                                                                    Centre</span><b class="collapse-sign"><em
                                                                        class="fa fa-plus-square-o"></em></b></a>
                                                            <ul>
                                                                <li>
                                                                    <a title="File Size" href="/"><i></i> <span
                                                                            class="menu-item-parent">File
                                                                            Size</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="Modes" href="/"><i></i> <span
                                                                            class="menu-item-parent">Modes</span></a>
                                                                </li>
                                                            </ul>
                                                        </li>
                                                        <li class="top-menu-invisible ">
                                                            <a href="#"><i></i> <span
                                                                    class="menu-item-parent">Feeds</span><b
                                                                    class="collapse-sign"><em
                                                                        class="fa fa-plus-square-o"></em></b></a>
                                                            <ul>
                                                                <li>
                                                                    <a title="Plug-In-Fields" href="/"><i></i> <span
                                                                            class="menu-item-parent">Plug-In-Fields</span></a>
                                                                </li>
                                                            </ul>
                                                        </li>
                                                        <li class="top-menu-invisible ">
                                                            <a href="#"><i></i> <span
                                                                    class="menu-item-parent">Email</span><b
                                                                    class="collapse-sign"><em
                                                                        class="fa fa-plus-square-o"></em></b></a>
                                                            <ul>
                                                                <li>
                                                                    <a title="Domain Sending Limits" href="/"><i></i>
                                                                        <span class="menu-item-parent">Domain Sending
                                                                            Limits</span></a>
                                                                </li>
                                                            </ul>
                                                        </li>
                                                        <li class="top-menu-invisible ">
                                                            <a href="#"><i></i> <span class="menu-item-parent">Admin
                                                                    Users</span><b class="collapse-sign"><em
                                                                        class="fa fa-plus-square-o"></em></b></a>
                                                            <ul>
                                                                <li>
                                                                    <a title="Page Access" href="/"><i></i> <span
                                                                            class="menu-item-parent">Page
                                                                            Access</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="New User" href="/"><i></i> <span
                                                                            class="menu-item-parent">New User</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="User Profile" href="/"><i></i> <span
                                                                            class="menu-item-parent">User
                                                                            Profile</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="Roles" href="/"><i></i> <span
                                                                            class="menu-item-parent">Roles</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="Screen Removal" href="/"><i></i> <span
                                                                            class="menu-item-parent">Screen
                                                                            Removal</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="Password Reset" href="/"><i></i> <span
                                                                            class="menu-item-parent">Password
                                                                            Reset</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="View Locked Accounts" href="/"><i></i>
                                                                        <span class="menu-item-parent">View Locked
                                                                            Accounts</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="Unlock Accounts" href="/"><i></i> <span
                                                                            class="menu-item-parent">Unlock
                                                                            Accounts</span></a>
                                                                </li>
                                                            </ul>
                                                        </li>
                                                        <li class="top-menu-invisible ">
                                                            <a href="#"><i></i> <span class="menu-item-parent">Site
                                                                    Survey</span><b class="collapse-sign"><em
                                                                        class="fa fa-plus-square-o"></em></b></a>
                                                            <ul>
                                                                <li>
                                                                    <a title="Survey Manager" href="/"><i></i> <span
                                                                            class="menu-item-parent">Survey
                                                                            Manager</span></a>
                                                                </li>
                                                            </ul>
                                                        </li>
                                                        <li class="top-menu-invisible ">
                                                            <a href="#"><i></i> <span class="menu-item-parent">Product
                                                                    Importer</span><b class="collapse-sign"><em
                                                                        class="fa fa-plus-square-o"></em></b></a>
                                                            <ul>
                                                                <li>
                                                                    <a title="Reports" href="/"><i></i> <span
                                                                            class="menu-item-parent">Reports</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="Import All Products" href="/"><i></i>
                                                                        <span class="menu-item-parent">Import All
                                                                            Products</span></a>
                                                                </li>
                                                            </ul>
                                                        </li>
                                                    </ul>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="sb-layer-1-2" role="tabpanel">
                                        <div class="form-row">
                                            <div class="form-group col-12">
                                                <label for="inputEmail4">ตำแหน่ง</label>
                                                <input type="text" class="form-control form-control-sm" id="inputEmail4">
                                            </div>
                                            <div class="form-group col-12">
                                                <label for="inputEmail4">รัศมี</label>
                                                <input type="text" class="form-control form-control-sm" id="inputEmail4">
                                            </div>
                                        </div>
                                        <b>ชั้นข้อมูล</b>
                                        <div class="nbtcm-jstree mt-2">
                                            <ul>
                                                <li class="top-menu-invisible ">
                                                    <a href="#"><i></i> <span class="menu-item-parent">Web
                                                            Development</span><b class="collapse-sign"><em
                                                                class="fa fa-plus-square-o"></em></b></a>
                                                    <ul>
                                                        <li class="top-menu-invisible ">
                                                            <a href="#"><i></i> <span class="menu-item-parent">Site
                                                                    Settings</span><b class="collapse-sign"><em
                                                                        class="fa fa-plus-square-o"></em></b></a>
                                                            <ul>
                                                                <li>
                                                                    <a title="Amend" href="/"><i></i> <span
                                                                            class="menu-item-parent">Amend</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="Refresh" href="/"><i></i> <span
                                                                            class="menu-item-parent">Refresh</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="Refresh Translations" href="/"><i></i>
                                                                        <span class="menu-item-parent">Refresh
                                                                            Translations</span></a>
                                                                </li>
                                                            </ul>
                                                        </li>
                                                        <li class="top-menu-invisible ">
                                                            <a href="#"><i></i> <span class="menu-item-parent">Site
                                                                    Frame</span><b class="collapse-sign"><em
                                                                        class="fa fa-plus-square-o"></em></b></a>
                                                            <ul>
                                                                <li>
                                                                    <a title="Location" href="/"><i></i> <span
                                                                            class="menu-item-parent">Location</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="Partial View" href="/"><i></i> <span
                                                                            class="menu-item-parent">Partial
                                                                            View</span></a>
                                                                </li>
                                                            </ul>
                                                        </li>
                                                        <li class="top-menu-invisible ">
                                                            <a href="#"><i></i> <span class="menu-item-parent">Upload
                                                                    Centre</span><b class="collapse-sign"><em
                                                                        class="fa fa-plus-square-o"></em></b></a>
                                                            <ul>
                                                                <li>
                                                                    <a title="File Size" href="/"><i></i> <span
                                                                            class="menu-item-parent">File
                                                                            Size</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="Modes" href="/"><i></i> <span
                                                                            class="menu-item-parent">Modes</span></a>
                                                                </li>
                                                            </ul>
                                                        </li>
                                                        <li class="top-menu-invisible ">
                                                            <a href="#"><i></i> <span
                                                                    class="menu-item-parent">Feeds</span><b
                                                                    class="collapse-sign"><em
                                                                        class="fa fa-plus-square-o"></em></b></a>
                                                            <ul>
                                                                <li>
                                                                    <a title="Plug-In-Fields" href="/"><i></i> <span
                                                                            class="menu-item-parent">Plug-In-Fields</span></a>
                                                                </li>
                                                            </ul>
                                                        </li>
                                                        <li class="top-menu-invisible ">
                                                            <a href="#"><i></i> <span
                                                                    class="menu-item-parent">Email</span><b
                                                                    class="collapse-sign"><em
                                                                        class="fa fa-plus-square-o"></em></b></a>
                                                            <ul>
                                                                <li>
                                                                    <a title="Domain Sending Limits" href="/"><i></i>
                                                                        <span class="menu-item-parent">Domain Sending
                                                                            Limits</span></a>
                                                                </li>
                                                            </ul>
                                                        </li>
                                                        <li class="top-menu-invisible ">
                                                            <a href="#"><i></i> <span class="menu-item-parent">Admin
                                                                    Users</span><b class="collapse-sign"><em
                                                                        class="fa fa-plus-square-o"></em></b></a>
                                                            <ul>
                                                                <li>
                                                                    <a title="Page Access" href="/"><i></i> <span
                                                                            class="menu-item-parent">Page
                                                                            Access</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="New User" href="/"><i></i> <span
                                                                            class="menu-item-parent">New User</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="User Profile" href="/"><i></i> <span
                                                                            class="menu-item-parent">User
                                                                            Profile</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="Roles" href="/"><i></i> <span
                                                                            class="menu-item-parent">Roles</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="Screen Removal" href="/"><i></i> <span
                                                                            class="menu-item-parent">Screen
                                                                            Removal</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="Password Reset" href="/"><i></i> <span
                                                                            class="menu-item-parent">Password
                                                                            Reset</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="View Locked Accounts" href="/"><i></i>
                                                                        <span class="menu-item-parent">View Locked
                                                                            Accounts</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="Unlock Accounts" href="/"><i></i> <span
                                                                            class="menu-item-parent">Unlock
                                                                            Accounts</span></a>
                                                                </li>
                                                            </ul>
                                                        </li>
                                                        <li class="top-menu-invisible ">
                                                            <a href="#"><i></i> <span class="menu-item-parent">Site
                                                                    Survey</span><b class="collapse-sign"><em
                                                                        class="fa fa-plus-square-o"></em></b></a>
                                                            <ul>
                                                                <li>
                                                                    <a title="Survey Manager" href="/"><i></i> <span
                                                                            class="menu-item-parent">Survey
                                                                            Manager</span></a>
                                                                </li>
                                                            </ul>
                                                        </li>
                                                        <li class="top-menu-invisible ">
                                                            <a href="#"><i></i> <span class="menu-item-parent">Product
                                                                    Importer</span><b class="collapse-sign"><em
                                                                        class="fa fa-plus-square-o"></em></b></a>
                                                            <ul>
                                                                <li>
                                                                    <a title="Reports" href="/"><i></i> <span
                                                                            class="menu-item-parent">Reports</span></a>
                                                                </li>
                                                                <li>
                                                                    <a title="Import All Products" href="/"><i></i>
                                                                        <span class="menu-item-parent">Import All
                                                                            Products</span></a>
                                                                </li>
                                                            </ul>
                                                        </li>
                                                    </ul>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                                <div class="mt-2 d-flex justify-content-center">
                                    <button type="button" class="btn btn-primary nbtcm-layer-btn-search flex-grow-1 mr-1">ค้นหา</button>
                                    <button type="button" class="btn btn-outline-secondary flex-grow-1 ml-1">ล้าง</button>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="sb-layer-2" role="tabpanel">
                                <b>ชั้นข้อมูล</b>
                                <div class="nbtcm-jstree mt-2">
                                    <ul>
                                        <li class="top-menu-invisible ">
                                            <a href="#"><i></i> <span class="menu-item-parent">Web Development</span><b
                                                    class="collapse-sign"><em class="fa fa-plus-square-o"></em></b></a>
                                            <ul>
                                                <li class="top-menu-invisible ">
                                                    <a href="#"><i></i> <span class="menu-item-parent">Site
                                                            Settings</span><b class="collapse-sign"><em
                                                                class="fa fa-plus-square-o"></em></b></a>
                                                    <ul>
                                                        <li>
                                                            <a title="Amend" href="/"><i></i> <span
                                                                    class="menu-item-parent">Amend</span></a>
                                                        </li>
                                                        <li>
                                                            <a title="Refresh" href="/"><i></i> <span
                                                                    class="menu-item-parent">Refresh</span></a>
                                                        </li>
                                                        <li>
                                                            <a title="Refresh Translations" href="/"><i></i> <span
                                                                    class="menu-item-parent">Refresh
                                                                    Translations</span></a>
                                                        </li>
                                                    </ul>
                                                </li>
                                                <li class="top-menu-invisible ">
                                                    <a href="#"><i></i> <span class="menu-item-parent">Site
                                                            Frame</span><b class="collapse-sign"><em
                                                                class="fa fa-plus-square-o"></em></b></a>
                                                    <ul>
                                                        <li>
                                                            <a title="Location" href="/"><i></i> <span
                                                                    class="menu-item-parent">Location</span></a>
                                                        </li>
                                                        <li>
                                                            <a title="Partial View" href="/"><i></i> <span
                                                                    class="menu-item-parent">Partial View</span></a>
                                                        </li>
                                                    </ul>
                                                </li>
                                                <li class="top-menu-invisible ">
                                                    <a href="#"><i></i> <span class="menu-item-parent">Upload
                                                            Centre</span><b class="collapse-sign"><em
                                                                class="fa fa-plus-square-o"></em></b></a>
                                                    <ul>
                                                        <li>
                                                            <a title="File Size" href="/"><i></i> <span
                                                                    class="menu-item-parent">File Size</span></a>
                                                        </li>
                                                        <li>
                                                            <a title="Modes" href="/"><i></i> <span
                                                                    class="menu-item-parent">Modes</span></a>
                                                        </li>
                                                    </ul>
                                                </li>
                                                <li class="top-menu-invisible ">
                                                    <a href="#"><i></i> <span class="menu-item-parent">Feeds</span><b
                                                            class="collapse-sign"><em
                                                                class="fa fa-plus-square-o"></em></b></a>
                                                    <ul>
                                                        <li>
                                                            <a title="Plug-In-Fields" href="/"><i></i> <span
                                                                    class="menu-item-parent">Plug-In-Fields</span></a>
                                                        </li>
                                                    </ul>
                                                </li>
                                                <li class="top-menu-invisible ">
                                                    <a href="#"><i></i> <span class="menu-item-parent">Email</span><b
                                                            class="collapse-sign"><em
                                                                class="fa fa-plus-square-o"></em></b></a>
                                                    <ul>
                                                        <li>
                                                            <a title="Domain Sending Limits" href="/"><i></i> <span
                                                                    class="menu-item-parent">Domain Sending
                                                                    Limits</span></a>
                                                        </li>
                                                    </ul>
                                                </li>
                                                <li class="top-menu-invisible ">
                                                    <a href="#"><i></i> <span class="menu-item-parent">Admin
                                                            Users</span><b class="collapse-sign"><em
                                                                class="fa fa-plus-square-o"></em></b></a>
                                                    <ul>
                                                        <li>
                                                            <a title="Page Access" href="/"><i></i> <span
                                                                    class="menu-item-parent">Page Access</span></a>
                                                        </li>
                                                        <li>
                                                            <a title="New User" href="/"><i></i> <span
                                                                    class="menu-item-parent">New User</span></a>
                                                        </li>
                                                        <li>
                                                            <a title="User Profile" href="/"><i></i> <span
                                                                    class="menu-item-parent">User Profile</span></a>
                                                        </li>
                                                        <li>
                                                            <a title="Roles" href="/"><i></i> <span
                                                                    class="menu-item-parent">Roles</span></a>
                                                        </li>
                                                        <li>
                                                            <a title="Screen Removal" href="/"><i></i> <span
                                                                    class="menu-item-parent">Screen Removal</span></a>
                                                        </li>
                                                        <li>
                                                            <a title="Password Reset" href="/"><i></i> <span
                                                                    class="menu-item-parent">Password Reset</span></a>
                                                        </li>
                                                        <li>
                                                            <a title="View Locked Accounts" href="/"><i></i> <span
                                                                    class="menu-item-parent">View Locked
                                                                    Accounts</span></a>
                                                        </li>
                                                        <li>
                                                            <a title="Unlock Accounts" href="/"><i></i> <span
                                                                    class="menu-item-parent">Unlock Accounts</span></a>
                                                        </li>
                                                    </ul>
                                                </li>
                                                <li class="top-menu-invisible ">
                                                    <a href="#"><i></i> <span class="menu-item-parent">Site
                                                            Survey</span><b class="collapse-sign"><em
                                                                class="fa fa-plus-square-o"></em></b></a>
                                                    <ul>
                                                        <li>
                                                            <a title="Survey Manager" href="/"><i></i> <span
                                                                    class="menu-item-parent">Survey Manager</span></a>
                                                        </li>
                                                    </ul>
                                                </li>
                                                <li class="top-menu-invisible ">
                                                    <a href="#"><i></i> <span class="menu-item-parent">Product
                                                            Importer</span><b class="collapse-sign"><em
                                                                class="fa fa-plus-square-o"></em></b></a>
                                                    <ul>
                                                        <li>
                                                            <a title="Reports" href="/"><i></i> <span
                                                                    class="menu-item-parent">Reports</span></a>
                                                        </li>
                                                        <li>
                                                            <a title="Import All Products" href="/"><i></i> <span
                                                                    class="menu-item-parent">Import All
                                                                    Products</span></a>
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
                    <div class="tab-pane fade" id="sb-history" role="tabpanel">
                        <div class="form-row">
                            <div class="form-group col-12">
                                <label>Station</label>
                                <select class="selectpicker" data-style="btn-outline-secondary btn-sm" data-live-search="true">
                                    <option>ทั้งหมด</option>
                                </select>
                            </div>
                            <div class="form-group col-12">
                                <label>Event</label>
                                <select class="selectpicker" data-style="btn-outline-secondary btn-sm" data-live-search="true">
                                    <option>ทั้งหมด</option>
                                </select>
                            </div>
                            <div class="form-group col-12">
                                <label>Filter</label>
                                <select class="selectpicker" data-style="btn-outline-secondary btn-sm" data-live-search="true">
                                    <option>ทั้งหมด</option>
                                </select>
                            </div>
                            <div class="form-group col-12">
                                <label>เริ่ม</label>
                                <div class="form-group flex-row mb-0">
                                    <div class="form-datepicker">
                                        <input class="form-control form-control-sm datepicker" id="dpd1">
                                        <span class="afms-ic_date"></span>
                                    </div>
                                    <div class="form-timepicker">
                                        <input class="form-control form-control-sm timepicker">
                                        <span class="afms-ic_time"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group col-12">
                                <label>สิ้นสุด</label>
                                <div class="form-group flex-row mb-0">
                                    <div class="form-datepicker">
                                        <input class="form-control form-control-sm datepicker" id="dpd2">
                                        <span class="afms-ic_date"></span>
                                    </div>
                                    <div class="form-timepicker">
                                        <input class="form-control form-control-sm timepicker">
                                        <span class="afms-ic_time"></span>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="mt-2 d-flex justify-content-center">
                            <button type="button" class="btn btn-primary nbtcm-history-btn-search flex-grow-1">ค้นหา</button>
                            <!-- <button type="button" class="btn btn-outline-secondary flex-grow-1 ml-1">ล้าง</button> -->
                        </div>
                    </div>
                    <div class="tab-pane fade" id="sb-route" role="tabpanel">
                        <div class="form-row position-relative nbtcm-route">
                            <div class="form-group col-12 nbtcm-route-start">
                                <label>จุดเริ่มต้น</label>
                                <input class="form-control form-control-sm">
                            </div>
                            <div class="form-group col-12 nbtcm-route-end">
                                <label>จุดสิ้นสุด</label>
                                <input class="form-control form-control-sm">
                            </div>
                            <div class="nbtcm-route-icon">
                                <span class="afms-ic_start"></span>
                                <span class="afms-ic_waypoint"></span>
                                <span class="afms-ic_destination"></span>
                            </div>
                            <button class="nbtcm-btn-reverse"><span class="afms-ic_swap"></span></button>
                        </div>
                        <div class="mt-2 d-flex justify-content-center">
                            <button type="button" class="btn btn-primary flex-grow-1 mr-1">ค้นหา</button>
                            <button type="button" class="btn btn-outline-secondary flex-grow-1 ml-1">ล้าง</button>
                        </div>
                    </div>
                </div>
            </div>
            <button class="btn btn-sm btn-secondary nbtcm-sidebar-btn-toggle">
                <span class="afms-ic_prev"></span>
                <span class="afms-ic_next"></span>
            </button>
        </div>
        <div class="nbtcm-sidebar nbtcm-sidebar-searchresult">
            <div class="nbtcm-sidebar-searchresult-heading">
                <button class="mr-2 nbtcm-btn-back"><span class="afms-ic_prev"></span></button>
                <div class="flex-grow-1">ผลการค้นหา <span>(50 รายการ)</span></div>
                <button type="button" class="btn btn-primary nbtcm-searchresult-btn-export btn-sm flex-grow-0 ml-2">Export</button>
            </div>
            <div class="nbtcm-sidebar-searchresult-subheading">แสดง 1 ถึง 10 จาก 57 รายการ</div>
            <div class="nbtcm-sidebar-searchresult-content flex-grow-1">
                <div>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                    <a class="nbtcm-sidebar-searchresult-item">
                        <img src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/012.png" class="mr-2">
                        <div class="flex-grow-1">
                            <b class="d-block">บริษัททรู มูฟ เอช ยูนิเวอร์แซล คอมมิวนิเคชั่น จำกัด</b>
                            <small class="text-muted d-block">18 อาคาร ทรู ทาวเวอร์ ถนนรัชดาภิเษก แขวงห้วยขวาง
                                เขตห้วยขวาง กรุงเทพฯ 10310 ประเทศไทย</small>
                            <small class="text-muted d-block">โทรศัพท์: +66-2-859-1111</small>
                        </div>
                    </a>
                </div>

                <nav class="mt-3">
                    <ul class="pagination pagination-sm justify-content-center">
                        <li class="page-item disabled">
                            <a class="page-link" href="#" tabindex="-1">Previous</a>
                        </li>
                        <li class="page-item"><a class="page-link" href="#">1</a></li>
                        <li class="page-item active">
                            <a class="page-link" href="#">2 <span class="sr-only">(current)</span></a>
                        </li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                        <li class="page-item">
                            <a class="page-link" href="#">Next</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>

        <div class="nbtcm-sidebar nbtcm-sidebar-searchresult nbtcm-sidebar-searchresult-event">
            <div class="nbtcm-sidebar-searchresult-heading">
                <button class="mr-2 nbtcm-btn-back"><span class="afms-ic_prev"></span></button>
                <div class="flex-grow-1">ผลการค้นหา <span>(50 รายการ)</span></div>
                <!-- <button type="button"
                    class="btn btn-primary nbtcm-searchresult-btn-export btn-sm flex-grow-0 ml-2">Export</button> -->
            </div>
            <div class="nbtcm-sidebar-searchresult-subheading">แสดง 1 ถึง 10 จาก 57 รายการ</div>
            <div class="nbtcm-sidebar-searchresult-content flex-grow-1">
                <div>
                    <div class="nbtcm-list-item">
                        <div class="nbtcm-list-item-text mb-1">
                            <b>Scanner : Station-2</b>
                        </div>
                        <small class="nbtcm-list-item-text">
                            <b>วันเวลาที่ตรวจพบ</b> : 2560-12-01 21:50:00-2
                        </small>
                        <small class="nbtcm-list-item-text">
                            <b>ความถี่</b> : 104.75
                        </small>
                        <small class="nbtcm-list-item-text">
                            <b>ความแรง</b> : -62.630554
                        </small>
                        <small class="nbtcm-list-item-text">
                            <b>ผู้ครอบครอง</b> : พัฒนาและส่งเสริมชุมชน มิตรภาพเรดิโอ
                        </small>
                    </div>
                    <div class="nbtcm-list-item">
                        <div class="nbtcm-list-item-text mb-1">
                            <b>Scanner : Station-2</b>
                        </div>
                        <small class="nbtcm-list-item-text">
                            <b>วันเวลาที่ตรวจพบ</b> : 2560-12-01 21:50:00-2
                        </small>
                        <small class="nbtcm-list-item-text">
                            <b>ความถี่</b> : 104.75
                        </small>
                        <small class="nbtcm-list-item-text">
                            <b>ความแรง</b> : -62.630554
                        </small>
                        <small class="nbtcm-list-item-text">
                            <b>ผู้ครอบครอง</b> : พัฒนาและส่งเสริมชุมชน มิตรภาพเรดิโอ
                        </small>
                    </div>
                </div>

                <nav class="mt-3">
                    <ul class="pagination pagination-sm justify-content-center">
                        <li class="page-item disabled">
                            <a class="page-link" href="#" tabindex="-1">Previous</a>
                        </li>
                        <li class="page-item"><a class="page-link" href="#">1</a></li>
                        <li class="page-item active">
                            <a class="page-link" href="#">2 <span class="sr-only">(current)</span></a>
                        </li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                        <li class="page-item">
                            <a class="page-link" href="#">Next</a>
                        </li>
                    </ul>
                </nav>
            </div>
            <button class="btn btn-sm btn-secondary nbtcm-sidebar-btn-toggle">
                <span class="afms-ic_prev"></span>
                <span class="afms-ic_next"></span>
            </button>
        </div>

        <div class="nbtcm-sidebar nbtcm-sidebar-menu">
            <div class="d-flex nbtcm-sidebar-menu-user align-items-center">
                <img src="img/user.png" class="rounded-circle mr-3">
                <div>
                    <div><b><%=EBMSMap30.cUsr.FullName%></b> </div>
                    <button class="btn btn-primary btn-sm mt-2" onclick="location='../UR/Logout.aspx'" >ออกจากระบบ</button>
                </div>
            </div>
            <nav class="nav flex-column">
                <a class="nav-link" href="../DashB">DASHBOARD</a>
                <a class="nav-link active" href="Cop.aspx">COP</a>
                <a class="nav-link" href="../FMS">FMS</a>
                <a class="nav-link" href="../DMS">DMS</a>
                <a class="nav-link" href="../DASHB/Download.aspx">Download</a>
            </nav>
        </div>
        <div class="nbtcm-content-wrapper">
            <div class="nbtcm-map">
                <iframe id="mapFrame" class="nbtcm-map-iframe" src="../GIS/Map.aspx?lat=<%=Request["Lat"] %>&lng=<%=Request["Lng"] %>"></iframe>

                <div class="nbtcm-mapgrouppanel">
                    <button class="nbtcm-btn--eventviewer">
                        <img src="icon/svg/ic_eventviewer.svg">
                        <div class="d-lg-none">Event Viewer</div>
                    </button>
                    <button class="nbtcm-btn--information">
                        <img src="icon/svg/ic_information.svg">
                        <div class="d-lg-none">Infor-mation</div>
                    </button>
                    <button class="nbtcm-btn--sensormonitor">
                        <img src="icon/svg/ic_sensormonitor.svg">
                        <div class="d-lg-none">Sensor Monitor</div>
                    </button>
                    <button class="nbtcm-btn--streetview">
                        <img src="icon/svg/ic_streetview.svg">
                        <div class="d-lg-none">Street View</div>
                    </button>
                </div>

                <button class="nbtcm-maptools-btn-toggle btn btn-sm btn-secondary">
                    <span class="afms-ic_menu mr-1"></span>MAP TOOLS
                </button>
               <div class="nbtcm-map-type">
                    <select id="maptype_src" class="selectpicker" data-style="btn-outline-secondary btn-sm" onchange="$('#mapFrame')[0].contentWindow.setMapTypeToMap(this.value)">
                    </select>
                </div>
                <div id="posbar" class="nbtcm-map-info" style="display: none;"></div>
                <div class="nbtcm-maptools is-active">
                    <ul class="d-flex flex-wrap">
                        <li>
                            <button type="button" id="bToolPan" class="is-active afms-ic_move" data-toggle="tooltip" data-placement="top" title="" data-original-title="เลื่อน">
                                <img src="icon/svg/ic_move.svg" alt="">
                                <div class="d-lg-none">เลื่อน</div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bToolZoom" data-toggle="tooltip" data-placement="top" title="" data-original-title="ขยาย">
                                <img src="icon/svg/ic_zoom.svg" alt="">
                                <div class="d-lg-none">ขยาย</div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bToolmDist" data-toggle="tooltip" data-placement="top" title="" data-original-title="วัดระยะทาง">
                                <img src="icon/svg/ic_measure_distance.svg" alt="">
                                <div class="d-lg-none">ระยะทาง</div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bToolmArea" data-toggle="tooltip" data-placement="top" title="" data-original-title="วัดพื้นที่">
                                <img src="icon/svg/ic_measure_area.svg" alt="">
                                <div class="d-lg-none">พื้นที่</div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bToolmCir" data-toggle="tooltip" data-placement="top" title="" data-original-title="วัดพื้นที่วงกลม">
                                <img src="icon/svg/ic_measure_circle.svg" alt="">
                                <div class="d-lg-none">พื้นที่วงกลม</div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bToolLOS" data-toggle="tooltip" data-placement="top" title="" data-original-title="วัดระดับความสูงเชิงเส้น">
                                <img src="icon/svg/ic_linear_elevation.svg" alt="">
                                <div class="d-lg-none">ความสูงเชิงเส้น</div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bToolAOS" data-toggle="tooltip" data-placement="top" title="" data-original-title="วัดระดับความสูงรูปวงกลม">
                                <img src="icon/svg/ic_measure_circleheight.svg" alt="">
                                <div class="d-lg-none">ความสูงรูปวงกลม</div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bToolHst" data-toggle="tooltip" data-placement="top" title="" data-original-title="หาจุดที่สูงที่ดินในพื้นที่">
                                <img src="icon/svg/ic_measure_areaheight.svg" alt="">
                                <div class="d-lg-none">หาจุดที่สูงที่ดิน</div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bToolDim" data-toggle="tooltip" data-placement="top" title="" data-original-title="ลดแสงในหน้าจอ">
                                <img src="icon/svg/ic_brightness.svg" alt="">
                                <div class="d-lg-none">ลดแสงหน้าจอ</div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bToolClr" data-toggle="tooltip" data-placement="top" title="" data-original-title="ปิดเครื่องมือ">
                                <img src="icon/svg/ic_close_tools.svg" alt="">
                                <div class="d-lg-none">ปิดเครื่องมือ</div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bToolInfo" data-toggle="tooltip" data-placement="top" title="" data-original-title="ตรวจสอบตำแหน่งและความสูง">
                                <img src="icon/svg/ic_check_locationheight.svg" alt="">
                                <div class="d-lg-none">
                                    ตำแหน่ง/<br>
                                    ความสูง
                                </div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bToolLoc" data-toggle="tooltip" data-placement="top" title="" data-original-title="หาตำแหน่งของตัวเอง">
                                <img src="icon/svg/ic_location.svg" alt="">
                                <div class="d-lg-none">ตำแหน่งตัวเอง</div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bToolGoto" data-toggle="tooltip" data-placement="top" title="" data-original-title="เลื่อนไปยังตำแหน่งที่ต้องการ">
                                <img src="icon/svg/ic_gotolocation.svg" alt="">
                                <div class="d-lg-none">เลื่อนไปตำแหน่ง</div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bTool3D" data-toggle="tooltip" data-placement="top" title="" data-original-title="แสดงแผนที่แบบ 3 มิติ">
                                <img src="icon/svg/ic_3d.svg" alt="">
                                <div class="d-lg-none">แผนที่ 3 มิติ</div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bToolPrn" data-toggle="tooltip" data-placement="top" title="" data-original-title="พิมพ์">
                                <img src="icon/svg/ic_print.svg" alt="">
                                <div class="d-lg-none">พิมพ์</div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bToolSet" data-toggle="tooltip" data-placement="top" title="" data-original-title="ตั้งค่า">
                                <img src="icon/svg/ic_setting.svg" alt="">
                                <div class="d-lg-none">ตั้งค่า</div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bToolFuSc" data-toggle="tooltip" data-placement="top" title="" data-original-title="ขยายหน้าจอ">
                                <img src="icon/svg/ic_fullscreen.svg" alt="">
                                <div class="d-lg-none">ขยายหน้าจอ</div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bToolCloudRF" data-toggle="tooltip" data-placement="top" title="" data-original-title="CloudRF">
                                <img src="icon/svg/ic_CloudRF.png" alt="">
                                <div class="d-lg-none">CloudRF</div>
                            </button>
                        </li>

                        <!-- Map Control -->
                        <!--
                        <li class="mt-2">
                            <button type="button" id="bToolPin" data-toggle="tooltip" data-placement="top" title="" data-original-title="Drop Pin">
                                <img src="icon/svg/ic_tool_pin-01.svg" alt="">
                                <div class="d-lg-none">Drop Pin</div>
                            </button>
                        </li>
                        <li class="mt-2">
                            <button type="button" id="bToolLine" data-toggle="tooltip" data-placement="top" title="" data-original-title="Line">
                                <img src="icon/svg/ic_tool_line-01.svg" alt="">
                                <div class="d-lg-none">Line</div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bToolShape" data-toggle="tooltip" data-placement="top" title="" data-original-title="Shape">
                                <img src="icon/svg/ic_tool_shape-01.svg" alt="">
                                <div class="d-lg-none">Shape</div>
                            </button>
                        </li>
                        <li>
                            <button type="button" id="bToolCir" data-toggle="tooltip" data-placement="top" title="" data-original-title="Circle">
                                <img src="icon/svg/ic_tool_circle-01.svg" alt="">
                                <div class="d-lg-none">Circle</div>
                            </button>
                        </li>
                        -->
                    </ul>
                </div>
                <div class="nbtcm-mappanel nbtcm-mapevent">
                    <div class="nbtcm-mappanel-heading">
                        Event Viewer
                        <button class="nbtcm-mappanel-btn-togglesize ml-auto">
                            <span class="afms-ic_maximize"></span>
                            <span class="afms-ic_minimize"></span>
                        </button>
                        <button class="nbtcm-mappanel-btn-close ml-2"><span class="afms-ic_close"></span></button>
                    </div>
                    <div class="nbtcm-mappanel-body">
                        <div class="nbtcm-list-item">
                            <div class="nbtcm-list-item-text mb-1">
                                <b>Scanner : Station-2</b>
                            </div>
                            <small class="nbtcm-list-item-text">
                                <b>วันเวลาที่ตรวจพบ</b> : 2560-12-01 21:50:00-2
                            </small>
                            <small class="nbtcm-list-item-text">
                                <b>ความถี่</b> : 104.75
                            </small>
                            <small class="nbtcm-list-item-text">
                                <b>ความแรง</b> : -62.630554
                            </small>
                            <small class="nbtcm-list-item-text">
                                <b>ผู้ครอบครอง</b> : พัฒนาและส่งเสริมชุมชน มิตรภาพเรดิโอ
                            </small>
                        </div>
                        <div class="nbtcm-list-item">
                            <div class="nbtcm-list-item-text mb-1">
                                <b>Scanner : Station-2</b>
                            </div>
                            <small class="nbtcm-list-item-text">
                                <b>วันเวลาที่ตรวจพบ</b> : 2560-12-01 21:50:00-2
                            </small>
                            <small class="nbtcm-list-item-text">
                                <b>ความถี่</b> : 104.75
                            </small>
                            <small class="nbtcm-list-item-text">
                                <b>ความแรง</b> : -62.630554
                            </small>
                            <small class="nbtcm-list-item-text">
                                <b>ผู้ครอบครอง</b> : พัฒนาและส่งเสริมชุมชน มิตรภาพเรดิโอ
                            </small>
                        </div>
                    </div>
                </div>
                <div class="nbtcm-mappanel nbtcm-mapinfo">
                    <button class="btn btn-sm btn-secondary nbtcm-sidebar-btn-toggle">
                        <span class="afms-ic_prev"></span>
                        <span class="afms-ic_next"></span>
                    </button>
                    <div class="nbtcm-mappanel-heading">
                        Information
                        <button class="nbtcm-mappanel-btn-togglesize ml-auto">
                            <span class="afms-ic_maximize"></span>
                            <span class="afms-ic_minimize"></span>
                        </button>
                        <button class="nbtcm-mappanel-btn-close ml-2"><span class="afms-ic_close"></span></button>
                    </div>
                    <div class="nbtcm-mappanel-body">
                        <div class="form-group">
                            <b>ชื่ออุปกรณ์</b>
                            <div>Station-2</div>
                        </div>
                        <div class="form-group">
                            <b>ชื่อหน่วยงาน</b>
                            <div>Station-2</div>
                        </div>

                        <div class="nbtcm-gallery">
                            <a href="http://sachinchoolur.github.io/lightGallery/static/img/thumb-1.jpg">
                              <img src="http://sachinchoolur.github.io/lightGallery/static/img/thumb-1.jpg" class="w-100" />
                            </a>
                            <a href="http://sachinchoolur.github.io/lightGallery/static/img/thumb-1.jpg">
                              <img src="http://sachinchoolur.github.io/lightGallery/static/img/thumb-1.jpg" class="w-100" />
                            </a>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>วันที่ตรวจสอบ</th>
                                        <th>ตรวจสอบโดย</th>
                                        <th>จุดที่</th>
                                        <th>ระยะการวัด (m)</th>
                                        <th>ความหนาแน่นกำลังเทียบกับมาตรฐาน (%)</th>
                                        <th>ผลการตรวจเทียบกับค่าขีดจำกัดมาตรฐาน (%)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>12/05/2563</td>
                                        <td>สำนักงาน กสทช.เขต 31</td>
                                        <td>1</td>
                                        <td>510643.000</td>
                                        <td>0.0003464892</td>
                                        <td>ต่ำกว่า</td>
                                    </tr>
                                    <tr>
                                        <td>12/05/2563</td>
                                        <td>สำนักงาน กสทช.เขต 31</td>
                                        <td>1</td>
                                        <td>510643.000</td>
                                        <td>0.0003464892</td>
                                        <td>ต่ำกว่า</td>
                                    </tr>
                                    <tr>
                                        <td>12/05/2563</td>
                                        <td>สำนักงาน กสทช.เขต 31</td>
                                        <td>1</td>
                                        <td>510643.000</td>
                                        <td>0.0003464892</td>
                                        <td>ต่ำกว่า</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="nbtcm-mappanel nbtcm-mapstreet">
                    <button class="nbtcm-mappanel-btn-close ml-auto"><span class="afms-ic_close"></span></button>
                    <button class="btn btn-sm btn-secondary nbtcm-sidebar-btn-toggle">
                        <span class="afms-ic_prev"></span>
                        <span class="afms-ic_next"></span>
                    </button>
                    <iframe id="stViewFrame" width="100%" height="100%" frameborder="0" style="border: 0"
                            src="StView.aspx" allowfullscreen></iframe>
                </div>
                <div class="nbtcm-mappanel nbtcm-sensormonitor">
                    <div class="nbtcm-mappanel-heading">
                        Sensor Monitor
                        <button class="nbtcm-mappanel-btn-togglesize d-lg-none ml-auto">
                            <span class="afms-ic_maximize"></span>
                            <span class="afms-ic_minimize"></span>
                        </button>
                        <button class="nbtcm-mappanel-btn-close ml-1 ml-lg-auto"><span class="afms-ic_close"></span></button>
                    </div>
                    <div class="nbtcm-mappanel-body">
                        <div class="group-card">
                            <div class="card border-secondary">
                                <div class="card-header text-secondary">Communication</div>
                                <div class="card-body text-secondary">
                                    <div>
                                        <b>3G</b> : Not OK
                                    </div>
                                    <div>
                                        <b>GPS</b> : Not OK
                                    </div>
                                </div>
                            </div>
                            <div class="card border-danger">
                                <div class="card-header text-danger">UPS : 0%</div>
                                <div class="card-body text-danger">
                                    <div>
                                        0 Minute
                                    </div>
                                </div>
                            </div>
                            <div class="card border-secondary">
                                <div class="card-header text-secondary">Scanner : Online</div>
                                <div class="card-body text-secondary">
                                    <div>
                                        <b>Antenna</b> : Not OK
                                    </div>
                                </div>
                            </div>
                            <div class="card border-success">
                                <div class="card-header text-success">Environment</div>
                                <div class="card-body text-success">
                                    <div>
                                        <b>Humidity</b> : 0%
                                    </div>
                                    <div>
                                        <b>Temp</b> : 0°C
                                    </div>
                                </div>
                            </div>
                            <div class="card border-success">
                                <div class="card-header text-success">Power meter : Plug</div>
                                <div class="card-body text-success">
                                    <div>
                                        <b>Voltage</b> : 235.63V
                                    </div>
                                    <div>
                                        <b>Current</b> : 0.37A
                                    </div>
                                    <div>
                                        <b>Freq</b> : 50.04Hz
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="resizable" class="nbtcm-mappanel nbtcm-leafletpopup is-active">
                    <div class="nbtcm-mappanel-heading">
                        Content Management
                        <button class="nbtcm-mappanel-btn-close ml-auto"><span class="afms-ic_close"></span></button>
                    </div>
                    <div class="d-flex justify-content-center mb-2 mt-2 nbtcm-mappanel-tabs">
                        <div class="btn-group btn-group-sm nav nav-tabs" role="tablist">
                            <a class="nav-item nav-link btn btn-outline-secondary active" data-toggle="tab" href="#addpoiiframe-type" role="tab" aria-selected="true">Type</a>
                            <a class="nav-item nav-link btn btn-outline-secondary" data-toggle="tab" href="#addpoiiframe-layer" role="tab" aria-selected="false">Layer</a>
                            <a class="nav-item nav-link btn btn-outline-secondary" data-toggle="tab" href="#addpoiiframe-content" role="tab" aria-selected="false">Content</a>
                            <a class="nav-item nav-link btn btn-outline-secondary" data-toggle="tab" href="#addpoiiframe-style" role="tab" aria-selected="false">Style</a>
                            <a class="nav-item nav-link btn btn-outline-secondary" data-toggle="tab" href="#addpoiiframe-info" role="tab" aria-selected="false">Info</a>
                        </div>
                    </div>
                    <div class="nbtcm-mappanel-body flex-grow-1">
                        <div class="nbtcm-leaflet-popup-content">
                            <div class="tab-content">
                                <div class="tab-pane fade show active" id="addpoiiframe-type" role="tabpanel">
                                    <div class="nbtcm-jstree-nocheckbox">
                                        <ul>
                                            <li>สถานที่
                                                <ul>
                                                    <li>
                                                        <div class="d-flex nbtcm-jstree-anchor-wrapper align-items-center">
                                                            <img class="nbtcm-jstree-img mr-1" src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/007.png">
                                                            <div>
                                                                <div>Circle</div>
                                                                <small>[Circle]</small>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="d-flex nbtcm-jstree-anchor-wrapper align-items-center">
                                                            <img class="nbtcm-jstree-img mr-1" src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/007.png">
                                                            <div>
                                                                <div>Circle</div>
                                                                <small>[Circle]</small>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="d-flex nbtcm-jstree-anchor-wrapper align-items-center">
                                                            <img class="nbtcm-jstree-img mr-1" src="http://afm.nbtc.go.th/afm/Files/Symbol/000/000/007.png">
                                                            <div>
                                                                <div>Circle</div>
                                                                <small>[Circle]</small>
                                                            </div>
                                                        </div>
                                                    </li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="addpoiiframe-layer" role="tabpanel">
                                    <div class="nbtcm-jstree-nocheckbox">
                                        <ul>
                                            <li>สถานที่</li>
                                            <li>สถานีฐาน
                                                <ul>
                                                    <li>สถานีแม่ข่ายวิทยุ</li>
                                                    <li>ไมโครเวฟลิงค์</li>
                                                    <li>สถานีวิทยุกระจายเสียง</li>
                                                    <li>สถานีวิทยุโทรทัศน์</li>
                                                    <li>สถานีโทรศัพท์เคลื่อนที่</li>
                                                </ul>
                                            </li>
                                            <li>สถานีวิทยุทดลอง
                                                <ul>
                                                    <li>วิทยุชุมชน</li>
                                                    <li>วิทยุธุรกิจ</li>
                                                    <li>สถานีวิทยุสาธารณะ</li>
                                                </ul>
                                            </li>
                                            <li>วิทยุปกติ(หลัก)</li>
                                            <li>ชุมสายโทรศัพท์</li>
                                            <li>ร้านค้าเครื่องวิทยุคมนาคม</li>
                                            <li>สถานี Remote
                                                <ul>
                                                    <li>ภภ.เขต 11</li>
                                                    <li>ภภ.เขต 12</li>
                                                    <li>ภภ.เขต 14</li>
                                                    <li>ภภ.เขต 15</li>
                                                    <li>ภภ.เขต 16</li>
                                                    <li>ภภ.เขต 21</li>
                                                    <li>ภภ.เขต 22</li>
                                                    <li>ภภ.เขต 23</li>
                                                    <li>ภภ.เขต 24</li>
                                                    <li>ภภ.เขต 25</li>
                                                    <li>ภภ.เขต 31</li>
                                                    <li>ภภ.เขต 32</li>
                                                    <li>ภภ.เขต 33</li>
                                                    <li>ภภ.เขต 34</li>
                                                    <li>ภภ.เขต 35</li>
                                                    <li>ภภ.เขต 41</li>
                                                    <li>ภภ.เขต 42</li>
                                                    <li>ภภ.เขต 43</li>
                                                    <li>ภภ.เขต 45</li>
                                                </ul>
                                            </li>
                                            <li>เสาส่งสัญญาณ
                                                <ul>
                                                    <li>เสาส่งดิจิตอลทีวี</li>
                                                    <li>สถานีฐานโทรศัพท์เคลื่อนที่</li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="addpoiiframe-content" role="tabpanel">
                                    <div class="form-row">
                                        <div class="form-group col-12">
                                            <label>ชื่อ</label>
                                            <input type="text" class="form-control form-control-sm">
                                        </div>
                                        <div class="form-group col-12">
                                            <label>รายละเอียด</label>
                                            <input type="text" class="form-control form-control-sm">
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="addpoiiframe-style" role="tabpanel">
                                    <div class="form-row">
                                        <div class="form-group col-6">
                                            <label>Line Width</label>
                                            <div class="dropdown bootstrap-select">
                                                <select class="selectpicker" data-style="btn-outline-secondary btn-sm">
                                                    <option>1</option>
                                                    <option>2</option>
                                                    <option>3</option>
                                                    <option>4</option>
                                                    <option>5</option>
                                                    <option>6</option>
                                                    <option>7</option>
                                                    <option>8</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group col-6">
                                            <label>Line Color</label>
                                            <input id="colorpicker" class="form-control form-control-sm input-colorpicker" type="text" value="rgb(255, 128, 0)" />
                                        </div>
                                        <div class="form-group col-6">
                                            <label>Line Opacity</label>
                                            <div class="dropdown bootstrap-select"><select class="selectpicker" data-style="btn-outline-secondary btn-sm">
                                                    <option>10</option>
                                                    <option>20</option>
                                                    <option>30</option>
                                                    <option>40</option>
                                                    <option>50</option>
                                                    <option>60</option>
                                                    <option>70</option>
                                                    <option>80</option>
                                                    <option>90</option>
                                                    <option>100</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group col-6">
                                            <label>Fill Color</label>
                                            <input id="colorpicker" class="form-control form-control-sm input-colorpicker" type="text" value="rgb(255, 128, 0)" />
                                        </div>
                                        <div class="form-group col-6">
                                            <label>Fill Opacity</label>
                                            <div class="dropdown bootstrap-select"><select class="selectpicker" data-style="btn-outline-secondary btn-sm">
                                                    <option>10</option>
                                                    <option>20</option>
                                                    <option>30</option>
                                                    <option>40</option>
                                                    <option>50</option>
                                                    <option>60</option>
                                                    <option>70</option>
                                                    <option>80</option>
                                                    <option>90</option>
                                                    <option>100</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="addpoiiframe-info" role="tabpanel">
                                    <div class="form-row">
                                        <div class="form-group col-12">
                                            <label>Postion</label>
                                            <div>14.002034 , 100.300369</div>
                                        </div>
                                        <div class="form-group col-12">
                                            <label>Redius</label>
                                            <div>11.875 km</div>
                                        </div>
                                        <div class="form-group col-12">
                                            <label>Distance</label>
                                            <div>442.982 sq.km</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="mt-0 d-flex justify-content-center mb-2 nbtcm-mappanel-foot">
                        <button type="button" class="btn btn-sm btn-outline-secondary nbtcm-mappanel-btn-cancel flex-grow-1 mr-1">ยกเลิก</button>
                        <button type="button" class="btn btn-sm btn-primary flex-grow-1 ml-1">บันทึก</button>
                    </div>
                </div>

                <!-- <div id="resizable" class="ui-widget-content">
                    <h3 class="ui-widget-header">Resizable</h3>
                  </div> -->



                <div class="modal fade" id="map-bToolGoto" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                เลื่อนไปยังตำแหน่งที่ต้องการ
                            </div>
                            <div class="modal-body">
                                <div class="d-flex justify-content-center mb-2">
                                    <div class="btn-group btn-group-sm nav nav-tabs" role="tablist">
                                        <a class="nav-item nav-link btn btn-outline-secondary active" data-toggle="tab" href="#map-gotolocation" role="tab" aria-selected="true">Goto Location</a>
                                        <a class="nav-item nav-link btn btn-outline-secondary" data-toggle="tab" href="#map-zoomtoscale" role="tab" aria-selected="false">Zoom to
                                            Scale</a>
                                    </div>
                                </div>
                                <div class="tab-content">
                                    <div class="tab-pane fade show active" id="map-gotolocation" role="tabpanel">
                                        <div class="form-row">
                                            <div class="col-12 col-md-6">
                                                <div class="form-group">
                                                    <label>Latitude</label>
                                                    <input type="text" class="form-control">
                                                </div>
                                            </div>
                                            <div class="col-12 col-md-6">
                                                <div class="form-group">
                                                    <label>Longitude</label>
                                                    <input type="text" class="form-control">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade show" id="map-zoomtoscale" role="tabpanel">
                                        <div class="form-row">
                                            <div class="col-12">
                                                <div class="form-group">
                                                    <label>Scale 1</label>
                                                    <input type="text" class="form-control">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">ยกเลิก</button>
                                <button type="button" class="btn btn-primary">บันทึก</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="map-bToolSet" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                ตั้งค่า
                            </div>
                            <div class="modal-body">
                                <div class="form-row">
                                    <div class="col-12 form-group">
                                        <label>Postion format</label>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="bToolSet-pos" id="bToolSet-pos-1" value="option1" checked>
                                            <label class="form-check-label" for="bToolSet-pos-1">
                                                Decimal (dd.dddddd)
                                            </label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="bToolSet-pos" id="bToolSet-pos-2" value="option2">
                                            <label class="form-check-label" for="bToolSet-pos-2">
                                                Degrees (dd° mm' ss.ssss")
                                            </label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="bToolSet-pos" id="bToolSet-pos-3" value="option3">
                                            <label class="form-check-label" for="bToolSet-pos-3">
                                                UTM
                                            </label>
                                        </div>
                                    </div>
                                    <div class="col-12 form-group">
                                        <label>Measure unit</label>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="bToolSet-unit" id="bToolSet-unit-1" value="option1" checked>
                                            <label class="form-check-label" for="bToolSet-unit-1">
                                                meters/kilometers
                                            </label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="bToolSet-unit" id="bToolSet-unit-2" value="option2">
                                            <label class="form-check-label" for="bToolSet-unit-2">
                                                ft./miles
                                            </label>
                                        </div>
                                    </div>
                                    <div class="col-12 form-group">
                                        <label>Area unit</label>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="bToolSet-area" id="bToolSet-area-1" value="option1" checked>
                                            <label class="form-check-label" for="bToolSet-area-1">
                                                sq. meters/kilometers
                                            </label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="bToolSet-area" id="bToolSet-area-2" value="option2">
                                            <label class="form-check-label" for="bToolSet-area-2">
                                                sq. ft./miles
                                            </label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="bToolSet-area" id="bToolSet-area-3" value="option3">
                                            <label class="form-check-label" for="bToolSet-area-3">
                                                ไร่-งาน-ตรว.
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">ยกเลิก</button>
                                <button type="button" class="btn btn-primary">บันทึก</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="js/jquery-3.3.1.min.js"></script>
    <script src="js/jquery-ui.js"></script>
    <script src="js/popper.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="../GIS/libs/pCop.js?v=1.1"></script>
    <!-- Latest compiled and minified JavaScript -->
    <script src="js/bootstrap-select.min.js"></script>
    <!-- <script src="js/jstree.min.js"></script> -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.0.9/jstree.min.js"></script>

    <!-- <script src=" https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js"></script> -->
    <!-- <script src="https://cdn.datatables.net/fixedheader/3.1.6/js/dataTables.fixedHeader.min.js"></script> -->
    <!-- <script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js"></script> -->

    <script src="js/bootstrap-datepicker.js"></script>
    <script src="js/bootstrap-datepicker-thai.js"></script>
    <script src="js/locales/bootstrap-datepicker.th.js"></script>
    <script src="js/bootstrap-timepicker.js"></script>

    <script src="js/jasny-bootstrap.min.js"></script>

    <script src="js/jquery.inputmask.bundle.js"></script>

    <script src="js/bootstrap-colorpicker.js"></script>

    <script src="https://cdn.jsdelivr.net/combine/npm/lightgallery,npm/lg-autoplay,npm/lg-fullscreen,npm/lg-hash,npm/lg-pager,npm/lg-share,npm/lg-thumbnail,npm/lg-video,npm/lg-zoom"></script>

    <script src="js/function.js"></script>

    <script>
        var _layerArr = <%=GetLayers("0") %>;
        var _gisLayerArr = <%=GetGISLayers("0") %>;

        $(document).ready(function() {
            // $('#map-bToolSet').modal('show')

        });
    </script>
</body>

</html>