// Dopln� zprava tvrd� mezery pro form�tov�n�
function TmZa(dta,pm)  //dta -> data od Gerta z funkce getFld; pm -> po�et mezer na konec
  {
   var i=1,s="";
   if (pm==null) pm=1;
   for (; i<=pm; i++,s+="&nbsp;") ;
   return dta+s;
  }

// Dopln� zleva tvrd� mezery pro form�tov�n�
function TmPred(dta,pm)  //dta -> data od Gerta z funkce getFld; pm -> po�et mezer na za��tek
  {
   var i=1,s="";
   if (pm==null) pm=3;
   for (; i<=pm; i++,s+="&nbsp;") ;
   return s+dta;
  }

// Zjist� verzi prohl�e�e
function getIEVer() 
  {
   var ua=window.navigator.userAgent; 
   var msie=ua.indexOf("MSIE");
   if (msie<=0 || window.navigator.platform!="Win32") return 0;
   return parseInt(ua.substring(msie+5,ua.indexOf(".", msie)));
  }

// Zjist�, jestli to je MSIE 5.5
function isVer55(){
  var ua=window.navigator.userAgent; 
  var msie=ua.indexOf("MSIE");
  var vs=ua.substring(msie+5,ua.indexOf(".", msie)+2);
  return vs=="5.5"? true: false;
}

// Hl�en� ve stavov�m ��dku okna
function StatOn() {status="P�ipravuji sestavu. Vy�kejte, pros�m.";} 

// Uvede property status do p�vodn�ho stavu
function StatOff(dta) {if (zmena) status="Hotovo. V tomto formul��i m��ete n�kter� �daje zm�nit."; else status=""; return dta;} 

function windowInit(){
  // Schov� tla��tko Vytisknout... p�ed tiskem
  function window.onbeforeprint() {Tisk.style.display="none";}
  function document.body.onload() {Tisk.style.display="";}

  // Odkryje tla��tko Vytisknout... po tisku
  function window.onafterprint() {Tisk.style.display="";}
}

// P�id� na za��tek sestavy tla��tko Vytisknout tuto str�nku
function ButtonTisk(){
  windowInit();
  with (document){
    write("<div id='Tisk' style='display: none' onClick='window.print()'>");
    write("<form>");
    write("<input type='button' value='Tisk: "+document.title+"'><br>");
    write("</form>");
    write("</div>");
  }
}
