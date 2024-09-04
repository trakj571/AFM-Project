<%
int nTotal=Convert.ToInt32(tbH.Rows[0]["nTotal"]);
int pgSize=Convert.ToInt32(tbH.Rows[0]["pageSize"]);
int cPage=Convert.ToInt32(tbH.Rows[0]["page"]);

if(pageUrl.IndexOf("?")>-1)
    pageUrl+="&page=";
else
    pageUrl+="?page=";


int nPage = 1+(int)Math.Ceiling((double)nTotal/pgSize);
if(nPage>2){
	Response.Write("<table style='font-family:tahoma'>");
	Response.Write("<tr><td width=750><font style='font-size:12px'>Page</font> ");
	
	if(cPage>1){
			Response.Write("<a style='font-size:12px;background:#f5f5f5;width:18px;height:18px;text-align:center;line-height:18px' href='"+pageUrl+(cPage-1)+"'>&lt;</a>&nbsp;");
	}
	for(int i=1;i<nPage;i++){
		if(i==cPage)
			Response.Write("<b style='font-size:12px;background:#f5f5f5;width:18px;height:18px;text-align:center;line-height:18px'>"+i+"</b>&nbsp;");
		else
			Response.Write("<a style='font-size:12px;background:#f5f5f5;width:18px;height:18px;text-align:center;line-height:18px' href='"+pageUrl+i+"'>"+(i)+"</a>&nbsp;");
	}
	if(cPage<nPage-1){
		Response.Write("<a style='font-size:12px;background:#f5f5f5;width:18px;height:18px;text-align:center;line-height:18px' href='"+pageUrl+(cPage+1)+"'>&gt;</a>&nbsp;");
	}
	Response.Write("</td></tr></table>");
}
%>