<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Download.aspx.cs" Inherits="AFMProj.DashB.Download" %>
<!DOCTYPE html>
<html>
<head>
	<!--#include file="../_inc/Title.asp"-->
   
        
</head>
<body>
	<div class="afms-sec-container afms-page-dashboard">
		<!--#include file="../_inc/Hd.asp"-->

		
        <div class="afms-sec-breadcrumb">
			<a href="Download.aspx" style="color:white">Download</a> &nbsp;  | &nbsp; 
            <a href="Download.aspx?type=video" style="color:white">Video</a>   

		</div>

		<div class="row afms-sec-content">
			<div class="col-md-2"></div>
            <div class="col-md-8">
             <div class="afms-sec-table">
                    <%if (tbB != null){
                            Response.Write("<table class='table table-condensed text-center afms-table-responsive'>");
                            Response.Write("<thead><tr>");
                            Response.Write("<th width=50>ลำดับ</th>");
                            Response.Write("<th width=200>ระบบงาน</th>");
                            Response.Write("<th width=200>ประเภทเอกสาร</th>");
                            Response.Write("<th width=100>เอกสาร</th>");
                            Response.Write("</tr></thead><tbody>");
                            int cnt = 0;
                            for (int i = 0; i < tbB.Rows.Count; i++)
                            {
                                if (Request.QueryString["type"] == "video" && tbB.Rows[i]["FileExt"].ToString().ToLower() != "mp4")
                                    continue;
                                if (Request.QueryString["type"] != "video" && tbB.Rows[i]["FileExt"].ToString().ToLower() == "mp4")
                                    continue;
                                cnt++;
                                Response.Write("<tr>");
                                Response.Write("<td data-th='ลำดับ'>" + (cnt) + "</td>");
                                Response.Write("<td data-th='ระบบงาน' style='text-align:left'>" + tbB.Rows[i]["Name"] + " </td>");
                                Response.Write("<td data-th='ประเภทเอกสาร' class=left>" + tbB.Rows[i]["DocType"] + "</td>");
                                if(tbB.Rows[i]["FileExt"].ToString()!=""){

                                    Response.Write("<td data-th='เอกสาร'><a href='../Files/Download/Doc" + tbB.Rows[i]["DlID"] + "." + tbB.Rows[i]["FileExt"] + "' target=_blank>แสดง</a></td>");
                                }else{
                                    Response.Write("<td  data-th='เอกสาร'></td>");
                                }
                                Response.Write("</tr>");


                            }
                            Response.Write("</tbody></table>");
                        }
                 %>
				</div>
			</div>
            <div class="col-md-2"></div>
		</div>
		

		
		<div class="afms-push"></div>
	</div>

	<!--#include file="../_inc/Ft.asp"-->
</body>

</html>

