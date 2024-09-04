<script language=c# runat=server>
    public DataTable tbSTN;
    public DataRow drSTN;  
              
    private void GetStations(){
        SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings[cUtils.GetDBName(cUsr.Token)]);
        SqlDataAdapter SqlCmd = new SqlDataAdapter("[spEquip_Gets]", SqlConn);
        SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

        SqlCmd.SelectCommand.Parameters.Add("@UID", SqlDbType.Int);
        SqlCmd.SelectCommand.Parameters["@UID"].Value = cUsr.UID;

        SqlCmd.SelectCommand.Parameters.Add("@Token", SqlDbType.VarChar, 50);
        SqlCmd.SelectCommand.Parameters["@Token"].Value = cUtils.GetToken(cUsr.Token);

        SqlCmd.SelectCommand.Parameters.Add("@IPAdr", SqlDbType.VarChar, 16);
        SqlCmd.SelectCommand.Parameters["@IPAdr"].Value = HttpContext.Current.Request.UserHostAddress;

        SqlCmd.SelectCommand.Parameters.Add("@EquType", SqlDbType.VarChar, 50);
        SqlCmd.SelectCommand.Parameters["@EquType"].Value = "STN+STN2";

        DataSet DS = new DataSet();
        SqlCmd.Fill(DS);
        SqlConn.Close();

        tbSTN = DS.Tables[0];
    }

</script>
<script language=javascript>
    $(function () {
        // $("#sidebarFreqMoni").addClass("in"); // collapse(); 

        $("#KeySch").keyup(function () {
            var t = $("#KeySch").val();
            if (t != "") {
                $(".li-station").each(function () {
                    if ($(this).find("a").attr("title").toLocaleLowerCase().indexOf(t.toLocaleLowerCase()) > -1)
                        $(this).show();
                    else
                        $(this).hide();
                });
            }
            else {
                $(".li-station").show();
            }
        });
    });
</script>
<style>
     #KeySch{
        background:#eee;padding:7px 10px 7px 10px;border-radius:6px;
        background-image:url(../img/ic_sch.png);
        background-position:right;
        background-repeat:no-repeat;
    }

    body>.afms-sec-container {/*min-height:750px*/}
    .afms-sec-content {min-height:600px}
    .afms-status.is-online { color: #26c281; }
</style>
<%GetStations(); %>
<div class="afms-sec-sidebarbox">
				<div class="collapse in" id="sidebarSection">
					<div class="afms-sec-sidebar">
						<div class="IsFMSFMon afms-sidebar-title hidden-lg hidden-md" role="button" data-toggle="collapse" href="#sidebarFreqMoni" aria-expanded="false" aria-controls="sidebarFreqMoni">Frequency Monitoring</div>
						<div class="IsFMSFMon afms-sidebar-title hidden-sm hidden-xs" role="button" data-toggle="collapse" href="#sidebarFreqMoni" aria-expanded="false" aria-controls="sidebarFreqMoni">Frequency Monitoring</div>
						<div class="IsFMSFMon collapse" id="sidebarFreqMoni">
							<ul>
                                <li><input id="KeySch" type="text" placeholder="ค้นหา.." />
                        
                    </li>
								<%for(int i=0;i<tbSTN.Rows.Count;i++){ %>
                                <li class="li-station"><a id="menu_station<%=tbSTN.Rows[i]["PoiID"] %>" href="FMon<%=tbSTN.Rows[i]["EquType"].ToString()=="STN-X"?"1":"2" %>.aspx?poiid=<%=tbSTN.Rows[i]["PoiID"] %>" class="afms-ic_lock" title="<%=tbSTN.Rows[i]["Name"] +" "+tbSTN.Rows[i]["LayerName"] %>"><i class="afms-ic_record afms-status"></i> <%=tbSTN.Rows[i]["Name"] %></a>
                                <div style='color:#aaa;font-size:13px;text-align:right'><%=tbSTN.Rows[i]["LayerName"] %></div>
                                    </li>
								<%} %>
                                	<!--li><a href="" class="afms-ic_lock" class="afms-ic_lock">Station 1</a></li-->
							
							</ul>
						</div>

						<div class="afms-sidebar-title hidden-lg hidden-md" role="button" data-toggle="collapse" href="#sidebarFreqDb" aria-expanded="false" aria-controls="sidebarFreqDb">Frequency Database</div>
						<div class="afms-sidebar-title hidden-sm hidden-xs" role="button" data-toggle="collapse" href="#sidebarFreqDb" aria-expanded="false" aria-controls="sidebarFreqDb">Frequency Database</div>
						<div class="collapse" id="sidebarFreqDb">
							<ul>
								<li><a class="text-bold hidden-lg hidden-md" role="button" data-toggle="collapse" href="#sidebarFreqDb-1" aria-expanded="false" aria-controls="sidebarFreqDb-1">ฐานข้อมูลการจัดสรรคลื่นความถี่</a>
									<a class="text-bold hidden-sm hidden-xs" role="button" data-toggle="collapse" href="#sidebarFreqDb-1" aria-expanded="false" aria-controls="sidebarFreqDb-1">ฐานข้อมูลการจัดสรรคลื่นความถี่</a>
									<ul class="collapse" id="sidebarFreqDb-1">
										<li class="IsFMSEdit IsFMSViewOnly"><a href="../FMS/FSch.aspx" rel="FSch">ค้นหาข้อมูล</a></li>
										<!--li class="IsFMSEdit"><a href="../FMS/FAdd.aspx" rel="FAdd">เพิ่มข้อมูล</a></!--li-->
									</ul>
								</li>
								<li><a class="text-bold hidden-lg hidden-md" role="button" data-toggle="collapse" href="#sidebarFreqDb-2" aria-expanded="false" aria-controls="sidebarFreqDb-2">ฐานข้อมูลผู้ได้รับการจัดสรรคลื่นความถี่</a>
									<a class="text-bold hidden-sm hidden-xs" role="button" data-toggle="collapse" href="#sidebarFreqDb-2" aria-expanded="false" aria-controls="sidebarFreqDb-2">ฐานข้อมูลผู้ได้รับการจัดสรรคลื่นฯ</a>
									<ul class="collapse" id="sidebarFreqDb-2">
										<li class="IsFMSEdit IsFMSViewOnly"><a href="HSch.aspx" rel="HSch">ค้นหาข้อมูล</a></li>
										<!--li class="IsFMSEdit"><a href="HAdd.aspx" rel="HAdd">เพิ่มข้อมูล</a></!--li-->
									</ul>
								</li>
								<li><a class="text-bold hidden-lg hidden-md" role="button" data-toggle="collapse" href="#sidebarFreqDb-3" aria-expanded="false" aria-controls="sidebarFreqDb-3">การวิเคราะห์ข้อมูล</a>
									<a class="text-bold hidden-sm hidden-xs" role="button" data-toggle="collapse" href="#sidebarFreqDb-3" aria-expanded="false" aria-controls="sidebarFreqDb-3">การวิเคราะห์ข้อมูล</a>
									<ul class="collapse" id="sidebarFreqDb-3">
										<li class="IsFMSEdit IsFMSViewOnly"><a href="AnChk.aspx" rel="AnChk">การตรวจสอบการใช้ความถี่</a></li>
										<li class="IsFMSEdit IsFMSViewOnly"><a href="AnSMon.aspx" rel="AnSMon">Sensor Monitor</a></li>
									</ul>
								</li>
							</ul>
						</div>
					
						<button class="afms-btn afms-btn-hide afms-ic_prev hidden-sm hidden-xs"></button>
					</div>
				</div>
				<button class="afms-btn afms-btn-hide hidden-md hidden-lg" role="button" data-toggle="collapse" href="#sidebarSection" aria-expanded="false" aria-controls="sidebarSection"></button>
			</div>

          <script language=javascript>
              $(function () {
                  readSensor();
              });
              function readSensor() {
                 
                  $.ajax({
                      type: 'POST',
                      url: "../DashB/data/dsensor.ashx",
                      data: {
                          //PoiID: typeof (poiid) != "undefined"?poiid:"0"
                      },
                      cache: false,
                      dataType: 'json',
                      success: function (data) {
                          setData(data);
                      },
                      error: function (XMLHttpRequest, textStatus, errorThrown) {

                      }

                  });

                  setTimeout(function () {
                      readSensor();
                  }, 15 * 1000);
              }

              function setData(data) {
                  for (var i = 0; i < data.length; i++) {
                      var d = data[i];
                      $("#station" + d.PoiID + " .panel-power").addClass("panel-success");
                      $("#station" + d.PoiID + " .panel-com").addClass("panel-success");

                      $("#station" + d.PoiID + " .Voltage").html(d.Voltage);
                      $("#station" + d.PoiID + " .Current").html(d.Current);
                      $("#station" + d.PoiID + " .Frequency").html(d.Frequency);
                      $("#station" + d.PoiID + " .PAE").html(d.PAE);

                      $("#station" + d.PoiID + " .UPSPc").html(d.UPSPc);
                      $("#station" + d.PoiID + " .UPSTime").html(d.UPSTime);

                      $("#station" + d.PoiID + " .Temp").html(d.Temp);
                      $("#station" + d.PoiID + " .Humidity").html(d.Humidity);
                      $("#station" + d.PoiID + " .TempStat").html(d.TempStat);
                      if (d.TempStat == "Warning" || d.TempStat == "Critical" || d.InPut == 1) {
                          $("#station" + d.PoiID + " .panel-sensor").addClass("panel-danger");
                          $("#station" + d.PoiID + " .text-sensor").addClass("text-danger");
                      } else {
                          $("#station" + d.PoiID + " .panel-sensor").addClass("panel-success");
                          $("#station" + d.PoiID + " .text-sensor").addClass("text-success");
                      }
                      var led = d.StatusLED;
                      if (d.UPSPc > 25) {
                          $("#station" + d.PoiID + " .panel-ups").addClass("panel-success");
                          $("#station" + d.PoiID + " .text-ups").addClass("text-success");
                      } else {
                          $("#station" + d.PoiID + " .panel-ups").addClass("panel-danger");
                          $("#station" + d.PoiID + " .text-ups").addClass("text-danger");
                      }
                      if (d.SCN == "OK") {
                          $("#station" + d.PoiID + " .panel-scaner").addClass("panel-success");
                          $("#station" + d.PoiID + " .text-scaner").addClass("text-success");
                      } else {
                          $("#station" + d.PoiID + " .panel-scaner").removeClass("panel-success");
                          $("#station" + d.PoiID + " .text-scaner").removeClass("text-success");
                      }
                      $("#station" + d.PoiID + " .SCN").html(d.SCN);

                      $("#station" + d.PoiID + " .GPS").html(d.GPS);
                      $("#station" + d.PoiID + " .3G").html(d.f3G);
                      $("#station" + d.PoiID + " .WAN").html(d.WAN);
                      $("#station" + d.PoiID + " .LAN").html(d.LAN);
                      $("#station" + d.PoiID + " .Atenna").html(d.ATTN);
                      if (d.ATTN != "-") {
                          $("#station" + d.PoiID + " .AtennaStat").html("Online");
                      } else {
                          $("#station" + d.PoiID + " .AtennaStat").html("Offline");
                      }
                      $("#station" + d.PoiID + " .Security").html(d.Security);

                      $("#station" + d.PoiID + " .OprTime").html(d.OprTime);
                      $("#station" + d.PoiID + " .OprName").html(d.OprName);
                      $("#station" + d.PoiID).addClass("is-online");
                      if (d.IsLock == "Unlock") {
                          $("#menu_station" + d.PoiID).removeClass("afms-ic_lock");
                          $("#menu_station" + d.PoiID).addClass("afms-ic_unlock");
                      } else {
                          $("#menu_station" + d.PoiID).removeClass("afms-ic_unlock");
                          $("#menu_station" + d.PoiID).addClass("afms-ic_lock");
                      }
                      if (d.IsOnline == "Online") {
                          $("#menu_station" + d.PoiID + " i").addClass("is-online");
                          $("#station" + d.PoiID + " .afms-page-title").addClass("is-online");
                          $("#station" + d.PoiID + " .NET").html("OK");
                      } else {
                          $("#menu_station" + d.PoiID + " i").removeClass("is-online");
                          $("#station" + d.PoiID + " .afms-page-title").removeClass("is-online");
                      }

                      if (d.IsLock == "Unlock" && d.IsOnline == "Online") {
                          if (typeof (poiid) != "undefined" ? poiid : "0" == d.PoiID) {
                              $("#station" + d.PoiID + " #searchSection").show();
                          }
                          $("#station" + d.PoiID + " .is-lock").removeClass("afms-ic_lock");
                          $("#station" + d.PoiID + " .is-lock").addClass("afms-ic_unlock");
                      } else {
                          if (typeof (poiid) != "undefined" ? poiid : "0" == d.PoiID) {
                              $("#station" + d.PoiID + " #searchSection").hide();
                          }
                          $("#station" + d.PoiID + " .is-lock").removeClass("afms-ic_unlock");
                          $("#station" + d.PoiID + " .is-lock").addClass("afms-ic_lock");
                      }
                  }
              }
          </script>