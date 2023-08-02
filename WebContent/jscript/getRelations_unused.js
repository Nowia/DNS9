/*
刪除關係式中含有指定的字串的行
 */
function delRelations (delString)
{
  if (pfcIsMozilla())
    netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
  
/*--------------------------------------------------------------------*\ 
  Get the session. If no model in present abort the operation. 
\*--------------------------------------------------------------------*/  
  var session = pfcGetProESession ();
  var solid = session.CurrentModel;

  if (solid == void null || (solid.Type != pfcCreate ("pfcModelType").MDL_PART)){
    throw new Error (0, "Current model is not a part.");
  }
  
  var relations = solid.Relations;
  var result = "";
    
  for (j = 0; j < relations.Count; j++){
	  if (relations.Item(j).indexOf(delString)>=0){
		  relations.Set(j,"");
		  result = "已刪除關係式中有"+delString+"的部分";
	  }
  }
  
  solid.Relations = relations; //assign relation back
  
  solid.RegenerateRelations;  //not necessary
  
  return result;
}

function getLWH ()
{
	alert ("getLWH");
}