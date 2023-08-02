/*
   HISTORY
   
14-NOV-02   J-03-38   $$1   JCN      Adapted from J-Link examples.
07-MAR-03   K-01-03   $$2   JCN      UNIX support
19-Feb-14   P-20-48   $$3 gshmelev   used pfcIsMozilla
*/
 
/*
  This example code demonstrates how to invoke an interactive selection. 
*/
function selectItems (options /* string[] */, max /* integer */)
{
  if (pfcIsMozilla())
    netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
  
/*--------------------------------------------------------------------*\ 
  Get the session. If no model in present abort the operation. 
\*--------------------------------------------------------------------*/  
  var session = pfcGetProESession ();
  var model = session.CurrentModel;
  
  if (model == void null)
    throw new Error (0, "No current model.");
  
/*--------------------------------------------------------------------*\ 
  Collect the options array into a comma delimited list
\*--------------------------------------------------------------------*/  
  var optString = "";
  for (var i = 0; i < options.length; i++)
    {
      optString += options [i];
      if (i != options.length -1)
	optString += ",";
    }
  
/*--------------------------------------------------------------------*\ 
  Prompt for selection.
\*--------------------------------------------------------------------*/  
  selOptions = pfcCreate ("pfcSelectionOptions").Create (optString);
  
  if (max != "UNLIMITED")
    {
      selOptions.MaxNumSels = parseInt (max);
    }
  
  session.CurrentWindow.SetBrowserSize (0.0);
  
  var selections = void null;
  try {
    selections = session.Select (selOptions, void null);
  }
  catch (err) {
/*--------------------------------------------------------------------*\ 
  Handle the situation where the  user didn't make selections, but picked 
  elsewhere instead.
  \*--------------------------------------------------------------------*/  
    if (pfcGetExceptionType (err) == "pfcXToolkitUserAbort" || 
	pfcGetExceptionType (err) == "pfcXToolkitPickAbove")
      return (void null);
    else
      throw err;
  }
  if (selections.Count == 0)
    return (void null);
  
  return (selections);
}


