<div class="afms-sec-header">
     <a style="color:#000;" href="https://fmr.nbtc.go.th/NBTCROS">
			<img src="../img/logo_s.png" srcset="../img/logo@2x.png 2x">
			<div class="afms-header-text" style="padding-top:7px">
				<h1><span>NBTC AUTOMATIC FREQUENCY</span> MONITORING SYSTEM</h1>
				<h2>สำนักงานคณะกรรมการกิจการกระจายเสียง กิจการโทรทัศน์ และกิจการโทรคมนาคมแห่งชาติ</h2>
			</div>
         </a>
			<ul class="afms-sec-menu hidden-sm hidden-xs">
				<li><a id="DashB" href="../DASHB">DASHBOARD</a></li>
				<li><a id="Cop" href="../GIS/Cop.aspx">COP</a></li>
				<li><a id="FMS" href="../FMS">FMS</a></li>
                <li><a id="DMS" href="../DMS">DMS</a></li>
                 <li><a id="DL" href="../DASHB/Download.aspx">Download</a></li>
				<li class="afms-menu-user">
				<img src="../img/user.png" alt="" class="img-circle">
				<%=EBMSMap30.cUsr.FullName%>
				<a href="../UR/Logout.aspx" class="afms-ic_exit"></a></li>
			</ul>

			<button class="afms-btn afms-btn-menu afms-btn-secondary afms-ic_menu hidden-md hidden-lg"></button>
		</div>


        <script language=javascript>
            $(function () {
                $('.afms-field_select select').selectpicker();
                $('.afms-field_datepicker input').datepicker({
                    orientation: "bottom left",
                    format: "dd/mm/yyyy",
                    autoclose: true
                });

                $('.afms-field_datetimepicker input').datetimepicker({
                    orientation: "bottom left",
                    format: "dd/mm/yyyy hh:ii",
                    autoclose: true
                });


                $('.afms-field_spinner input').TouchSpin({
                    min: 0,
                    max: 3000,
                    step: 0.01,
                    decimals: 2,
                    boostat: 5,
                    buttondown_class: "afms-btn afms-btn-minus afms-ic_minus",
                    buttonup_class: "afms-btn afms-btn-plus afms-ic_plus"
                });


                var url = (location + "").toLowerCase();
                if (url.indexOf("/fms/") > -1) {
                    $("#FMS").addClass("is-active");
                    $("#FMSB").addClass("is-active");
                }
                else if (url.indexOf("/dms/") > -1) {
                    $("#DMS").addClass("is-active");
                    $("#DMSB").addClass("is-active");
                }
                else if (url.indexOf("/dashb/download") > -1) {
                    $("#DL").addClass("is-active");
                    $("#DLM").addClass("is-active");
                   
                }
                else if (url.indexOf("/dashb/") > -1) {
                   $("#DashB").addClass("is-active");
                    $("#DashBM").addClass("is-active");
                }
            });
        
        
        </script>