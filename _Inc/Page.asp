<script language="c#" runat="server">
private string GetNo(int i){
    int pgSize=Convert.ToInt32(tbH.Rows[0]["pageSize"]);
    int cPage=Convert.ToInt32(tbH.Rows[0]["page"]);
    return (pgSize * (cPage - 1) + (i + 1)).ToString();
}
private string GetPageUrl(int page){
       var nameValues = HttpUtility.ParseQueryString(Request.QueryString.ToString());
       //nameValues.Set("page", page.ToString());
       nameValues.Set("page", page.ToString());
       nameValues.Remove("del");
       string pageUrl = Request.Url.AbsolutePath;
       pageUrl = pageUrl+"?" + nameValues.ToString();
 
       return pageUrl;
   }

  private string ThSort(string sort){
      string csort = Request.QueryString["sort"];
      if(csort==sort){
           return "class='sortlink sortup'";
      }
      else if(csort=="-"+sort){
           return "class='sortlink sortdown'";
      }
      return "class='sortlink'";
   }

   private string SchSort(string sort){
      var nameValues = HttpUtility.ParseQueryString(Request.QueryString.ToString());
        
       
       string csort = Request.QueryString["sort"];
          if(csort==sort){
              nameValues.Set("sort", "-"+sort);
          }
            else{
                nameValues.Set("sort", sort);
          }

        string pageUrl = Request.Url.AbsolutePath;
        pageUrl = pageUrl+"?" + nameValues.ToString();

        return pageUrl;

      
   }
</script>
<style>
.sortup {background :url(../img/sort_up.png) top center no-repeat}
.sortdown {background :url(../img/sort_down.png) top center no-repeat}

</style>

<%
int nTotal=Convert.ToInt32(tbH.Rows[0]["nTotal"]);
int pgSize=Convert.ToInt32(tbH.Rows[0]["pageSize"]);
int cPage=Convert.ToInt32(tbH.Rows[0]["page"]);



int nPage = (int)Math.Ceiling((double)nTotal/pgSize);
if(nPage>1){

    Response.Write("<div class=\"afms-pagination no-print-page\">");
    if(cPage>1){
        Response.Write("<a href='"+GetPageUrl(1)+"' class=\"afms-ic_firstpage\">&laquo;</a>");
        Response.Write("<a href='"+GetPageUrl(cPage-1)+"' class=\"afms-ic_prev\"></a>");
    }
    for(int i=1;i<=nPage;i++){
        Response.Write("<a href='"+GetPageUrl(i)+"' "+(i==cPage?"class=\"is-active\"":"")+">"+i+"</a> ");
    }
    if(cPage<nPage && nPage>1){
        Response.Write("<a href='"+GetPageUrl(cPage+1)+"' class=\"afms-ic_next\"></a>");
        Response.Write("<a href='"+GetPageUrl(nPage)+"' class=\"afms-ic_lastpage\">&raquo;</a>");
    }
    Response.Write("</div><br />");
}

%>