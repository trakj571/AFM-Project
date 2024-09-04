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
        SqlCmd.SelectCommand.Parameters["@EquType"].Value = "DMS";

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
    body>.afms-sec-container {/*min-height:750px*/}
    .afms-sec-content {min-height:600px}
    .afms-status.is-online { color: #26c281; }
    /*.afms-sec-sidebar{min-height:550px}*/

    #KeySch{
        background:#eee;padding:7px 10px 7px 10px;border-radius:6px;
        background-image:url(../img/ic_sch.png);
        background-position:right;
        background-repeat:no-repeat;
    }
</style>
<%GetStations(); %>
<div class="afms-sec-sidebarbox">
	<div class="collapse in" id="sidebarSection">
		<div class="afms-sec-sidebar">
			
                       
			<div class="afms-sidebar-title hidden-lg hidden-md" role="button" data-toggle="collapse" href="#sidebarFreqDb" aria-expanded="false" aria-controls="sidebarFreqDb">Frequency Database</div>
			<div class="afms-sidebar-title hidden-sm hidden-xs" role="button" data-toggle="collapse" href="#sidebarFreqDb" aria-expanded="false" aria-controls="sidebarFreqDb">Frequency Database</div>
			<div class="collapse" id="sidebarFreqDb">
				<ul>
					<li><a class="text-bold hidden-lg hidden-md" role="button" data-toggle="collapse" href="#sidebarFreqDb-3" aria-expanded="false" aria-controls="sidebarFreqDb-3">การวิเคราะห์ข้อมูล</a>
						<a class="text-bold hidden-sm hidden-xs" role="button" data-toggle="collapse" href="#sidebarFreqDb-3" aria-expanded="false" aria-controls="sidebarFreqDb-3">การวิเคราะห์ข้อมูล</a>
						<ul class="collapse" id="sidebarFreqDb-3">
							<li class='IsDMSImp IsDMSViewOnly'><a href="AnChk.aspx" rel="AnChk">การตรวจสอบการใช้ความถี่</a></li>
							<!--li><a href="AnSMon.aspx" rel="AnSMon">Sensor Monitor</a></li-->
                            
                             <li class='IsDMSImp IsDMSViewOnly'><a href="AnChkFq.aspx" rel="AnChkFq">การค้นหาการครอบครองความถี่ แยกความถี่</a></li>
                            <!--li class='IsDMSImp IsDMSViewOnly'><a href="AnRep.aspx" rel="AnRep">รายงานการตรวจสอบ</a></!--li-->
							<li class='IsDMSImp IsDMSViewOnly'><a href="DImpLog.aspx" rel="DImpLog">Log การนำเข้าข้อมูล</a></li>
						</ul>
					</li>
				</ul>
                            
                <ul>
					<li><a class="text-bold hidden-lg hidden-md" role="button" data-toggle="collapse" href="#sidebarFreqDb2-3" aria-expanded="false" aria-controls="sidebarFreqDb2-3">การวิเคราะห์การครอบครองความถี่</a>
						<a class="text-bold hidden-sm hidden-xs" role="button" data-toggle="collapse" href="#sidebarFreqDb2-3" aria-expanded="false" aria-controls="sidebarFreqDb2-3">การวิเคราะห์การครอบครองความถี่</a>
						<ul class="collapse" id="sidebarFreqDb2-3">
							<li class='IsDMSImp IsDMSViewOnly'><a href="FreqTb.aspx" rel="FreqTb">ตารางการตรวจสอบคลื่นความถี่</a></li>
							<li class='IsDMSImp IsDMSViewOnly'><a href="FreqStat.aspx" rel="FreqStat">สถิติการครอบครองความถี่</a></li>
										
						</ul>
					</li>
				</ul>
                            
			</div>
					   
            <div class="IsDMSImp afms-sidebar-title hidden-lg hidden-md" role="button" data-toggle="collapse" href="#sidebarFreqMoni" aria-expanded="false" aria-controls="sidebarFreqMoni">Frequency Monitoring</div>
			<div class="IsDMSImp afms-sidebar-title hidden-sm hidden-xs" role="button" data-toggle="collapse" href="#sidebarFreqMoni" aria-expanded="false" aria-controls="sidebarFreqMoni">Data Monitoring System</div>
			<div class="collapse" id="sidebarFreqMoni">
				<ul>
                    <li><input id="KeySch" type="text" placeholder="ค้นหา.." />
                        
                    </li>
					<%for(int i=0;i<tbSTN.Rows.Count;i++){ %>
                    <li class="li-station"><a id="menu_station<%=tbSTN.Rows[i]["PoiID"] %>" href="DImp.aspx?poiid=<%=tbSTN.Rows[i]["PoiID"] %>" title="<%=tbSTN.Rows[i]["Name"] +" "+tbSTN.Rows[i]["LayerName"] %>"> <%=tbSTN.Rows[i]["Name"] %></a>
                        <div style='color:#aaa;font-size:13px;text-align:right'><%=tbSTN.Rows[i]["LayerName"] %></div>
                              
                    </li>
					<%} %>
           				
				</ul>
			</div>


			<button class="afms-btn afms-btn-hide afms-ic_prev hidden-sm hidden-xs"></button>
		</div>
	</div>
	<button class="afms-btn afms-btn-hide hidden-md hidden-lg" role="button" data-toggle="collapse" href="#sidebarSection" aria-expanded="false" aria-controls="sidebarSection"></button>
</div>

        