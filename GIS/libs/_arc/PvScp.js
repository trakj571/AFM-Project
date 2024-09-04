function setProv(id,s,d){
	var c=document.getElementById(id);
	var aP = eval("PV.split(',')");
	var j = 0;
	c.options[0]= new Option('..ทุกจังหวัด..','0');
	if(s=='0') c.options[0].selected=true;
	for (i=0; i < (aP.length/2); i++) {
		c.options[i+1]= new Option(aP[j+1],aP[j]);
		if(aP[j]==s) c.options[i+1].selected=true;
		j += 2;
	}	
	if(d)
	    c.disabled=true;
}

function setAumphur(id,pv,s,d){
	var c=document.getElementById(id);
	while (c.options.length > 0) {
		 c.options[(c.options.length - 1)] = null;	
	}
	c.options[0]=new Option('..ทุกอำเภอ..','0');
	if(s=='0') {c.options[0].selected=true;setTumbon('sTumbon','0','0');}
	if(pv!='0'){
	    var aP = eval("AM['"+ pv +"'].split(',')");
	    var j = 0;
		if(aP != null){
		for (var i=0; i < aP.length/2; i++) {
				c.options[i+1]= new Option(aP[j+1],aP[j]);
				if(aP[j]==s) c.options[i+1].selected=true;
				j += 2;				
			}
		}
		c.disabled=false;
	}
	else
	{
		c.options[0].selected=true;
		c.disabled=true;
	}
	if(d)
	    c.disabled=true;
}
function setTumbon(id,am,s,d){
	var c=document.getElementById(id);
	while (c.options.length > 0) {
		 c.options[(c.options.length - 1)] = null;	
	}
	c.options[0]=new Option('..ทุกตำบล..','0');
	if(s=='0') {c.options[0].selected=true;setVilllage('sVilllage','0','0');}
	if(am!='0'){
	    var aP = eval("TB['"+ am +"'].split(',')");
	    var j = 0;
		if(aP != null){
		for (var i=0; i < aP.length/2; i++) {
				c.options[i+1]= new Option(aP[j+1],aP[j]);
				if(aP[j]==s) c.options[i+1].selected=true;
				j += 2;				
			}
		}
		c.disabled=false;
	}
	else
	{
		c.options[0].selected=true;
		c.disabled=true;
	}
	if(d)
	    c.disabled=true;
}
function setVilllage(id, tb, s, d) {
    
	var c=document.getElementById(id);
	if(!c) return;
	while (c.options.length > 0) {
		 c.options[(c.options.length - 1)] = null;	
	}
	c.options[0]=new Option('..ทุกหมู่บ้าน..','0');
	if(s=='0') c.options[0].selected=true;
	if(tb!='0'){
	    var aP = eval("VL['"+ tb +"'].split(',')");
	    var j = 0;
		if(aP != null){
		for (var i=0; i < aP.length/2; i++) {
				c.options[i+1]= new Option(aP[j+1],aP[j]);
				if(aP[j]==s) c.options[i+1].selected=true;
				j += 2;				
			}
		}
		c.disabled=false;
	}
	else
	{
		c.options[0].selected=true;
		c.disabled=true;
	}
	if(d)
	    c.disabled=true;
}