<div class="nbtc-header">
			<div class="nbtc-admin-header">
				<img src="../img/logo.png">
				<div class="nbtc-header_content">
					<p class="nbtc-header_content-en"><span>NBTC</span> AUTOMATIC FREQUENCY MONITORING SYSTEM</p>
					<p class="nbtc-header_content-th">สำนักงานคณะกรรมการกิจการกระจายเสียง กิจการโทรทัศน์ และกิจการโทรคมนาคมแห่งชาติ</p>
				</div>
			</div>

			<div class="clear"></div>

			<div class="nbtc-menu nbtc-menu-desktop">
				<ul>
					<li><a href='../DashB'>Application</a></li>
					<li><a >Admin Tools <i class="nbtc-ic_dropdown"></i></a>
						<ul class="nbtc-menu-dropdown dropdown-lv1">
							<li><a>Account <i class="nbtc-ic_next"></i></a>
								<ul class="nbtc-menu-dropdown dropdown-lv2">
									<li><a href="../Admin/Usr.aspx">User</a></li>
									<li><a href="../Admin/UGrp.aspx">Group Policy</a></li>
									<li><a href="../Admin/Org.aspx">ORG</a></li>
									<li><a href="../Admin/OrgVer.aspx">ORG-Version</a></li>
								</ul>
							</li>
                            <li><a>Layer <i class="nbtc-ic_next"></i></a>
								<ul class="nbtc-menu-dropdown dropdown-lv2">
									<li><a href="../Admin/Layer.aspx">Layer</a></li>
									<li><a href="../Admin/GISLayer.aspx">GISLayer</a></li>
								</ul>
							</li>
                             <li><a>Content <i class="nbtc-ic_next"></i></a>
								<ul class="nbtc-menu-dropdown dropdown-lv2">
									<li><a href="../Admin/CGrp.aspx">Group</a></li>
									<li><a href="../Admin/CType.aspx">Type</a></li>
                                    <li><a href="../Admin/CTmpl.aspx">Template</a></li>
								</ul>
							</li>
                            <li><a href="../Admin/Equip.aspx">Equipment</a></li>
							<li><a href="../Admin/Domain.aspx">Domain</a></li>
							<li><a href="../Admin/Download.aspx">Download</a></li>
							<li><a href="../Admin/History.aspx">History</a></li>
						</ul>
					</li>
					 <li><a>System Configuration <i class="nbtc-ic_dropdown"></i></a>
						<!--ul class="nbtc-menu-dropdown dropdown-lv1">
                    
									<li><a href="../Admin/BData.aspx">RBW</a></li>
								</ul-->

                            </li>

                    
				</ul>
			</div>

			<div class="nbtc-menu-mobile">
				<div class="nbtc-btn-menu" role="button" data-toggle="collapse" href="#collapseMenu" aria-expanded="false" aria-controls="collapseMenu">
					<span></span>
					<span></span>
					<span></span>
					<span></span>
					<span></span>
					<span></span>
				</div>
				<div class="collapse" id="collapseMenu">
					<ul>
						
						<li>
							<a class="has-submenu" role="button" data-toggle="collapse" href="#collapseAdminTools" aria-expanded="false" aria-controls="collapseAdminTools">Admin Tools</a>
							<ul class="collapse level-2" id="collapseAdminTools">
								<li><a class="nbtc-submenu has-submenu" role="button" data-toggle="collapse" href="#collapseAdminTools_1" aria-expanded="false" aria-controls="collapseAdminTools_1">Account</a>
									<div class="collapse level-3" id="collapseAdminTools_1">
										<a href="../Admin/Usr.aspx" class="nbtc-submenu">User</a>
										<a href="../Admin/UGrp.aspx" class="nbtc-submenu">Group Policy</a>
										<a href="../Admin/Org.aspx" class="nbtc-submenu">ORG</a>
									</div>
								</li>
                                <li><a class="nbtc-submenu has-submenu" role="button" data-toggle="collapse" href="#collapseAdminTools_2" aria-expanded="false" aria-controls="collapseAdminTools_1">Layer</a>
									<div class="collapse level-3" id="collapseAdminTools_2">
										<a href="../Admin/Layer.aspx" class="nbtc-submenu">Layer</a>
										<a href="../Admin/GISLayer.aspx" class="nbtc-submenu">GISLayer</a>
									</div>
								</li>
                                    <li><a class="nbtc-submenu has-submenu" role="button" data-toggle="collapse" href="#collapseAdminTools_3" aria-expanded="false" aria-controls="collapseAdminTools_1">Layer</a>
									<div class="collapse level-3" id="collapseAdminTools_3">
										<a href="../Admin/CGrp.aspx" class="nbtc-submenu">Group</a>
										<a href="../Admin/CType.aspx" class="nbtc-submenu">Type</a>
                                        <a href="../Admin/CTmpl.aspx" class="nbtc-submenu">Template</a>
									</div>
								</li>

                                <li><a href="../Admin/Equip.aspx" class="nbtc-submenu">Equipment</a></li>
								<li><a href="../Admin/Download.aspx" class="nbtc-submenu">Download</a></li>
								<li><a href="../Admin/History.aspx" class="nbtc-submenu">History</a></li>
							</ul>
						</li>
						<!--li>
							<a class="has-submenu" role="button" data-toggle="collapse" href="#collapseSystemConfig" aria-expanded="false" aria-controls="collapseSystemConfig">System Configuration</a>
							<div class="collapse level-2" id="collapseSystemConfig">
                                <a href="../Admin/BData.aspx" class="nbtc-submenu">RBW</a>
						    </div>
                            </li-->
                            

                        <li>
							<a class="has-submenu usermenu" role="button" data-toggle="collapse" href="#collapseUser" aria-expanded="false" aria-controls="collapseUser">
								<div class="nbtc-usermenu-profile"><img src="../img/user.png"></div><span><%=EBMSMap30.cUsr.FullName %></span></a>
							<div class="collapse level-2" id="collapseUser">
								<a href="" class="nbtc-submenu">Profile</a>
								<a href="../UR/Logout.aspx" class="nbtc-submenu">Log Off</a>
							</div>
						</li>
					</ul>
				</div>
			</div>
		</div>