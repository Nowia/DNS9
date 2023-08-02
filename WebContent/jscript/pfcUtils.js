/*
   HISTORY

14-NOV-02   J-03-38   $$1   JCN      Submitted.
07-MAR-03   K-01-03   $$2   JCN      UNIX support
01-MAY-07   L-01-31   $$3   JCN      New exception messaging.
19-Feb-14   P-20-48   $$4 gshmelev   used pfcIsMozilla
20-Nov-14   P-20-63   $$5 rkumbhare  Updated for chromium browser function.
29-Oct-20   P-20-63   $$6 nowia      Updated for IE browser function.
 */

function isProEEmbeddedBrowser ()
{
  if (top.external && top.external.ptc)
    return true;
  else
    return false;
}

function pfcIsMozilla ()
{
    if(pfcIsWindows())
		return false;	
    if(pfcIsChrome())
		return false; 
	
    return true;
}
 
function pfcIsChrome ()
{
  var ua = navigator.userAgent.toString().toLowerCase();
  var val = ua.indexOf("chrome/"); // Chrome
  if (val > -1)
  {
    return true;
  }
  else
    return false;
}

function pfcIsWindows ()
{
var browser = get_browser_info();

if (browser.name.indexOf ("IE") != -1)
 return true;
else
 return false;
}

//IE瀏覽器的判斷
//if ( navigator.appName.indexOf ("Microsoft")!=-1 || ((navigator.appName == 'Netscape') && (new RegExp("Trident/.*rv:([0-9]{1,}[\.0-9]{0,})").exec(navigator.userAgent) != null)))

function get_browser_info()
{
    var ua=navigator.userAgent,tem,M=ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || []; 
    if(/trident/i.test(M[1])){
        tem=/\brv[ :]+(\d+)/g.exec(ua) || []; 
        return {name:'IE',version:(tem[1]||'')};
        }   
    if(M[1]==='Chrome'){
        tem=ua.match(/\bOPR\/(\d+)/)
        if(tem!=null)   {return {name:'Opera', version:tem[1]};}
        }   
    M=M[2]? [M[1], M[2]]: [navigator.appName, navigator.appVersion, '-?'];
    if((tem=ua.match(/version\/(\d+)/i))!=null) {M.splice(1,1,tem[1]);}
    return {
      name: M[0],
      version: M[1]
    };
}

function pfcCreate (className)
{
  if (pfcIsWindows()){
    return new ActiveXObject ("pfc."+className);
  }else if (pfcIsChrome()) {
    return pfcCefCreate (className);
  }else if (pfcIsMozilla())
  {
    netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
    ret = Components.classes ["@ptc.com/pfc/" + className + ";1"].createInstance();
    return ret;
  } else {
	return new ActiveXObject ("pfc."+className);
  }
}

function pfcGetProESession ()
{
  if (!isProEEmbeddedBrowser ())
    {
      throw new Error ("Not in embedded browser.  Aborting...");
    }
  
  // Security code
  if (pfcIsMozilla())
    netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
  
  var glob = pfcCreate ("MpfcCOMGlobal");
  return glob.GetProESession();
}

function pfcGetScript ()
{  
  if (!isProEEmbeddedBrowser ())
    {
      throw new Error ("Not in embedded browser.  Aborting...");
    }
  
  // Security code
  if (pfcIsMozilla())
    netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
  
  var glob = pfcCreate ("MpfcCOMGlobal");
  return glob.GetScript();
}


function pfcGetExceptionDescription (err)
{
 if (pfcIsWindows())
    errString = err.description;
 else if (pfcIsChrome())
    errString = window.pfcCefGetLastException().message;
 else if (pfcIsMozilla())
    errString = err.message;
 return errString;
}

function pfcGetExceptionType (err)
{
  errString = pfcGetExceptionDescription (err);

  // This should remove the XPCOM prefix ("XPCR_C")
  if (errString.search ("XPCR_C") < 0)
  {
	errString = errString.replace ("Exceptions::", "");
	semicolonIndex = errString.search (";");
	if (semicolonIndex > 0)
		errString = errString.substring (0, semicolonIndex);
	return (errString);
  }
  else
      return (errString.replace("XPCR_C", ""));
}