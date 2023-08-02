//計算沖頭總共有幾個邊 應該是3的倍數
function getAllPrt(session)
{
  var asm = session.CurrentModel;

  var prtArray = session.ListModelsByType(pfcCreate("pfcModelType").MDL_PART);
  //可檢查目前ASM檔和Session內的PRT檔名前四個字是否一樣做為對應

  //test
  for(var i=0;i<prtArray.Count;i++){
	  var pName = prtArray.Item(i).FileName;
	  alert(i+"="+pName);
  }
  
  doSaveAsStp(prtArray.Item(0),session);
  
  return prtArray;
}

//Utils---------------------------------------------------------------------------------------------------------------------------------
function doSaveAsStp (){
	alert("SaveAsStp");
	//alert("got " + sPart.Id);

	//run macro
	session.RunMacro ("~ Close `main_dlg_cur` `appl_casc`;~ Command `ProCmdModelSaveAs` ;~ Open `file_saveas` `type_option`;~ Close `file_saveas` `type_option`;~ Select `file_saveas` `type_option` 1 `db_539`;Activate `file_saveas` `Current Dir`;~ Activate `file_saveas` `OK`;~ Activate `UI Message Dialog` `ok`;");
}