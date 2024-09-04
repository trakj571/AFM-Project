function setProv2(id,s,d){
	var c=document.getElementById(id);
	var aP = eval("PV2.split(',')");
	var j = 0;
	c.options[0] = new Option('=== เลือก ===', '0');
	if(s=='0'||s=='00') c.options[0].selected=true;
	for (i=0; i < (aP.length/2); i++) {
		c.options[i+1]= new Option(aP[j+1],aP[j]);
		if(aP[j]==s) c.options[i+1].selected=true;
		j += 2;
	}	
	if(d)
	    c.disabled = true;

	$('#'+id).selectpicker('refresh');
}

function setAumphur2(id,pv,s,d){
	var c=document.getElementById(id);
	while (c.options.length > 0) {
		 c.options[(c.options.length - 1)] = null;	
	}

	c.options[0] = new Option('=== เลือก ===', '0');
	
	if (s == '0' || s == '00') { c.options[0].selected = true; if (d) setTumbon2(d, '0', '0'); }
	
	if(pv!='0' && pv!='00'){
	    var aP = eval("AM2['"+ pv +"'].split(',')");
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
	    c.disabled = true;
	$('#' + id).selectpicker('refresh');
}
function setTumbon2(id,am,s,d){
	var c=document.getElementById(id);
	while (c.options.length > 0) {
		 c.options[(c.options.length - 1)] = null;	
	}

    c.options[0] = new Option('=== เลือก ===', '0');
    if (s == '0' || s == '00') { c.options[0].selected = true; setVilllage2('sVilllage2', '0', '0'); }
   
	if (am != '0' && am != '0000') {
	    var aP = eval("TB2['"+ am +"'].split(',')");
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
	    c.disabled = true;

	$('#' + id).selectpicker('refresh');
}
function setVilllage2(id, tb, s, d) {
    return;
	var c=document.getElementById(id);
	if(!c) return;
	while (c.options.length > 0) {
		 c.options[(c.options.length - 1)] = null;	
	}

c.options[0] = new Option('=== เลือก ===', '0');
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

function setTypeId(id, s, d) {
    var c = document.getElementById(id);
    var aP = eval("CTY.split(',')");
    var j = 0;
    c.options[0] = new Option('..ทั้งหมด..', '0');
    if (s == '0') c.options[0].selected = true;
    for (i = 0; i < (aP.length / 2); i++) {
        c.options[i + 1] = new Option(aP[j + 1], aP[j]);
        if (aP[j] == s) c.options[i + 1].selected = true;
        j += 2;
    }
    if (d)
        c.disabled = true;
}