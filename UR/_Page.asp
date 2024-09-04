<script language=c# runat=server>
    private string GetPageUrl(int page){
        var nameValues = HttpUtility.ParseQueryString(Request.QueryString.ToString());
        nameValues.Set("pg", page.ToString());
        nameValues.Set("pg", page.ToString());
        nameValues.Remove("del");
        string pageUrl = Request.Url.AbsolutePath;
        pageUrl = pageUrl+"?" + nameValues.ToString();

        return pageUrl;
    }
    private void WritePageLink(){
        int nTotal=Convert.ToInt32(tbH.Rows[0]["nTotal"]);
        int pgSize=Convert.ToInt32(tbH.Rows[0]["pageSize"]);
        int cPage=Convert.ToInt32(tbH.Rows[0]["page"]);

        int nPage = 1+(int)Math.Ceiling((double)nTotal/pgSize);
        if(nPage>1){
	        Response.Write("<div class=pageDlg>");
	        if(cPage>1){
			        Response.Write("<a href='"+GetPageUrl(cPage-1)+"'>&lt;</a> ");
	        }else{
                Response.Write("<span>&lt;</span> ");
            }
	        for(int i=1;i<nPage;i++){
		        if(i==cPage){
			        Response.Write("<em>"+i+"</em> ");
		        }else if(Math.Abs(i-cPage)>3){
					if(i==1)
                        Response.Write("<a href='"+GetPageUrl(i)+"'>" + i + "..</a>  ");
					else if(i==nPage-1)
                        Response.Write("<a href='"+GetPageUrl(i)+"'>.." + i + "</a>  ");
					continue;

                    
				}else{
                    Response.Write("<a href='"+GetPageUrl(i)+"'>"+(i)+"</a> ");
                }
                
	        }
	        if(cPage<nPage-1){
		        Response.Write("<a href='"+GetPageUrl(cPage+1)+"'>&gt;</a>");
	        }
            else{
                Response.Write("<span>&gt;</span> ");
            }
	        Response.Write("</div>");
        }
   }
</script>