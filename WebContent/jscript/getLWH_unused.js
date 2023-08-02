/*
取得工件的長寬高
 */
function printLWH ()
{
	alert ("printLWH");
  if (pfcIsMozilla())
    netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
  
/*--------------------------------------------------------------------*\ 
  Get the session. If no model in present abort the operation. 
\*--------------------------------------------------------------------*/  
  var session = pfcGetProESession ();
  var solid = session.CurrentModel;
  
  if (solid == void null || (solid.Type != pfcCreate ("pfcModelType").MDL_PART &&
			     solid.Type != pfcCreate ("pfcModelType").MDL_ASSEMBLY))
    throw new Error (0, "Current model is not a part or assembly.");
  
/*--------------------------------------------------------------------*\ 
  Calculate the properties.
\*--------------------------------------------------------------------*/  
  var param_num = solid.ListParams().Count;
  var param_value;
  var ENGLISHDESC,ENGLISHDESC_VALUE;
  
  properties = solid.GeomOutline;
  point0 = properties.Item(0);
  point1 = properties.Item(1);
  
 
  var L = Math.abs(point0.Item(0) - point1.Item(0)).toFixed(1);
  var W = Math.abs(point0.Item(1) - point1.Item(1)).toFixed(1);
  var H = Math.abs(point0.Item(2) - point1.Item(2)).toFixed(1);
 
  var solidSurface = solid.ListItems(pfcCreate("pfcModelItemType").ITEM_SURFACE);
  var IsCYLINDER =0;
  
  //讀材質參數
  for(var i=0;i<param_num;i++){
	 if(solid.ListParams().Item(i).Name == "MATERIAL"){ 
		 param_value = solid.ListParams().Item(i).GetScaledValue().StringValue;		 
	 }
  }
	
   //找圓柱曲面
  for(var i=0;i<solidSurface.Count;i++){
	  if(solidSurface.Item(i).GetSurfaceType() ==  pfcCreate("pfcSurfaceType").SURFACE_CYLINDER && L==H){
		ENGLISHDESC = param_value + " " + "Ø" + L.toString() + "*" + W.toString();
		IsCYLINDER = 1;
		WriteParam();
		break;
      }

  }	
        if(IsCYLINDER ==0){
          ENGLISHDESC = param_value + " " + L.toString() + "*" + W.toString() + "*" + H.toString();
	      WriteParam();
		}
	
/*--------------------------------------------------------------------*\ 
  Display selected results.
\*--------------------------------------------------------------------*/  
  function WriteParam(){
	  try{
			ENGLISHDESC_VALUE =  pfcCreate("MpfcModelItem").CreateStringParamValue(ENGLISHDESC);
			
			solid.GetParam("ENGLISHDESC").SetScaledValue(ENGLISHDESC_VALUE,null);
		}
	catch(ex){
			alert ("Exception occurred: "+pfcGetExceptionType (ex));
		}
  }
  
  /*
  var newWin = window.open ('', "_MP", "scrollbars");
  if (pfcIsWindows())
    {
      newWin.resizeTo (300, screen.height/2.0);
      newWin.moveTo (screen.width-300, 0);
    }
 // newWin.document.writeln ("<html><head></head><body>");
  
  //newWin.document.writeln ("<p>The outline1 is: " + x0 + "," + y0 + "," + z0);
  //newWin.document.writeln ("<p>The outline2 is: " + x1 + "," + y1 + "," + z1);
  newWin.document.writeln ("<p>" + "長" + " X " + "寬" + " X " + "高");
  
  newWin.document.writeln ("<p>" + L + " X " + W + " X " + H);
  
 // newWin.document.writeln ("<br/>");
  newWin.document.writeln("<p>" + "param_num = " + param_num);
 
  newWin.document.writeln("<p>" + "MATERIAL_VALUE = " + param_value);

  newWin.document.writeln("<p>" + "ENGLISHDESC_VALUE = " + ENGLISHDESC);
  
 // newWin.document.writeln ("<html><head></head><body>");
  */
}
function getLWH ()
{
	alert ("getLWH");
}