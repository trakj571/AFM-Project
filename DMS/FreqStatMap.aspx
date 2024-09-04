<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FreqStatMap.aspx.cs" Inherits="AFMProj.DMS.FreqStatMap" %>

<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
    <script src="../_Inc/js/highstock.js"></script>
    <script language=javascript>

        $(function () {
            $("a[rel=FreqStat]").addClass("is-active");
       });


    </script>
  
</head>
<body>
	<div class="afms-sec-container">
		<!--#include file="../_inc/Hd.asp"-->

		<div class="afms-sec-breadcrumb">
			<ul>
				<li><a href="" class="afms-ic_home"></a> <span class="afms-ic_next"></span></li>
				<li><a href="">DMS</a> <span class="afms-ic_next"></span></li>
				<li>การวิเคราะห์การครอบครองความถี่ <span class="afms-ic_next"></span></li>
                <li>สถิติการครอบครองความถี่</li>
			</ul>
		</div>

		<div class="row afms-sec-content">
        <!--#include file="../DMS/Menu.asp"-->
			 <form id=FormSch runat=server>

			<div class="col-md-12">
				<div class="afms-content">
					<div class="afms-page-title">
						สถิติการครอบครองความถี่
					</div>

                     <input type=hidden id=Lat runat=server value="" />
                       <input type=hidden id=Lng runat=server value="" />
                       <input type=hidden id=Tools runat=server value="1" />
                       <input type=hidden id=LyIDs runat=server value="" />
                       <!--#include file="../GIS/EMapRep.asp"-->

					</div>

                    </div>
                    
            </form>
		</div>
        
		<div class="afms-push"></div>
	</div>

	<!--#include file="../_inc/Ft.asp"-->
</body>

</html>
