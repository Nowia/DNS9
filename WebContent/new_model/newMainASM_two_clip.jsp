<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>新建模型</title>
<link href="../css/mm_restaurant1.css" media="screen" rel="stylesheet" type="text/css" />
<link href="../css/form.css" media="screen" rel="stylesheet" type="text/css" />
</head>
<script src="../jscript/pfcUtils.js">
</script>
<script language="JavaScript">

var oldNameArr = new Array ();
var newNameArr = new Array ();
var commonNameArr = new Array ();
var drwOldNameArr = new Array (); //數量和oldNameArr相同
var drwNewNameArr = new Array ();
var drwCommonNameArr = new Array ();
var urlArr = new Array ();
var actionArr = new Array ();
var parentArr = new Array (); //parent of component
var deleteItems = "NA";
var mdlNameforDel = "NA";
var pltDelArr = new Array ();

//取得範本及其資訊
function getTemplate (tempType){
	try {
	    var session = pfcGetProESession();
		var actServ = session.GetActiveServer();
		
		//alert( "ActiveWorkspace=" + actServ.ActiveWorkspace);
		//alert( "Alias=" + actServ.Alias);
		//alert( "Context=" + actServ.Context);

		if (actServ.Alias.indexOf("PLM")==-1){
			alert ("請檢查是否有連接PLM");
		}

		//取得範本
		var tempNumber = document.getElementById(tempType).value.toLowerCase();
		var mdlDescr = pfcCreate ("pfcModelDescriptor").CreateFromFileName (tempNumber);
		var topMdl = session.RetrieveModel(mdlDescr);
		
		//user input
		var moldNO = document.getElementById("moldNO").value.toLowerCase(); //PLM檔名
		var plateCount = parseInt(document.getElementById("plateCount").value);
		//alert ("plateCount="+plateCount);
		if (plateCount<4){
			for (t = plateCount+1; t <= 4; t++){
				//alert ("t="+t);
				pltDelArr.push("plt"+t+".asm");
			}
		}
		//alert ("pltDelArr="+pltDelArr);
		
		oldNameArr.push (topMdl.FileName); //1st item
		commonNameArr.push (topMdl.CommonName); //1st item
		parentArr.push(topMdl); //儲存上層組件供之後刪除用 最上層組件儲存自己 通常不會用到

		//列出資訊
		if (topMdl.FileName.indexOf("asm")>0){
			listComponents(session,topMdl);
		}
		//alert ("oldNameArr="+oldNameArr);

		//動作判斷
		getActions(tempType);
		//alert("setActions");
		//setActions();
		
		//列出並取得工程圖 "保留"的不會有工程圖
		listDrws(session);

		//重新命名
		renameComponents(moldNO,tempNumber,tempType);
		//alert ("newNameArr="+newNameArr);
		//alert ("parentArr="+parentArr);


		//檢查物件庫檔案衝突
		for (n = 0; n < newNameArr.length; n++){
			if (newNameArr[n]==oldNameArr[n]){
				urlArr.push ("OK");
			} else {
				var nameCheck = newNameArr[n];
				var result = checkSameName(actServ,nameCheck);

				//重新命名MODEL
				var i = 0;
				while( result.indexOf("exists")!=-1 ) {
					i=i+1;
					if (i>100){
						break;
					}

					nameCheck = addComponentSeq(nameCheck);
					//alert ("nameCheck="+nameCheck);
					result = checkSameName(actServ,nameCheck);
				}
				newNameArr[n] = nameCheck; //replace
			
				urlArr.push (result);
			}
		}
		
		//檢查本次上傳內部衝突
		//alert ("check");
		for (p = 1; p < newNameArr.length; p++){
			if (actionArr[p]=="新建"){
				var nameThis = newNameArr[p];
				for (q = 1; q < p; q++){
					if (nameThis==newNameArr[q]){
						nameThis = addComponentSeq(nameThis);
					}
				}
				newNameArr[p] = nameThis;
			}
		}
		
		//顯示清單  重新命名工程圖
		//alert ("displayModelTable");
		for (m = 0; m < oldNameArr.length; m++){
			var searchName = oldNameArr[m].replace(".prt", '');
			searchName = searchName.replace(".asm", '');
			var drwNewName = "NA"; //沒有工程圖的會顯示NA
			var drwCommonName = "NA";
			var drwIndex=m;
			for (f = 0; f < drwOldNameArr.length; f++){
				var ret = drwOldNameArr[f].replace('.drw','');
				//if (drwOldNameArr[f].indexOf(searchName)==0){ 需全部的字一樣
				if (ret==searchName){
					drwNewNameArr[f] = newNameArr[m].replace(".prt", ".drw");
					drwNewNameArr[f] = drwNewNameArr[f].replace(".asm", ".drw");
					drwCommonNameArr[f] = commonNameArr[m]+"工程圖";
					drwNewName = drwNewNameArr[f];
					drwCommonName = drwCommonNameArr[f];
					drwIndex = f;
					break;
				}
			}
			//alert ("searchName="+searchName+"drwOldNameArr="+drwOldNameArr[f]+"drwNewName="+drwNewName);
			displayModelTable(oldNameArr[m],actionArr[m],newNameArr[m],commonNameArr[m],drwNewName,drwCommonName,urlArr[m],m,drwIndex);
		}
		
		
		//顯示縮圖
		//displayModelPic(tempNumber);
	}
	catch(err){	alert ("Exception occurred: "+pfcGetExceptionType(err)); }
}

//取得組件下的元件
function listComponents (session,mdl){
	try {
	var components = mdl.ListFeaturesByType (true,pfcCreate ("pfcFeatureType").FEATTYPE_COMPONENT);
	//alert ("components.Count="+components.Count);
	for (k = 0; k < components.Count; k++){
		var component = components.Item(k);
		var desc = component.ModelDescr;
		var cmdl = session.RetrieveModel(desc);
		oldNameArr.push (cmdl.FileName);
		commonNameArr.push (cmdl.CommonName);
		parentArr.push(mdl); //儲存上層組件供之後刪除用
		//alert ("push "+cmdl.FileName);
		if (cmdl.FileName.indexOf("asm")!=-1){
			var k_temp = k; //k會被recursive程式改掉 要小心
			var count = listComponents(session,cmdl); //recursive
			k = k_temp; //restore
		}
		//alert (cmdl.FileName+"Done"+k);
	}
	}
	catch(err){	alert ("Exception occurred: "+pfcGetExceptionType(err)); }
}

//列出並取得工程圖
function listDrws (session){
	
	for (s = 0; s < oldNameArr.length; s++){
		if (actionArr[s].indexOf("保留")==-1){ //排除"保留"的 oldNameArr[s].indexOf("_")==-1 && 
			var oldName = oldNameArr[s].replace(".prt", ".drw");
			var oldName = oldName.replace(".asm", ".drw");
			//alert ("listDrws to get:"+oldName);
			try {
				var mdlDescr = pfcCreate ("pfcModelDescriptor").CreateFromFileName (oldName);
				drwMdl = session.RetrieveModel(mdlDescr);
				//alert (s+"drwOldNameArr="+drwMdl.FileName);
				drwOldNameArr.push (drwMdl.FileName); //1st item
				drwNewNameArr.push ("NA"); //initial
				drwCommonNameArr.push ("NA"); //initial
			} catch(err){ //asm檔如果找不到相對應的drw就填NA
				/*
				if (pfcGetExceptionType(err).indexOf("PRO_TK_E_NOT_FOUND")==0 || pfcGetExceptionType(err).indexOf("pfcXToolkitNotFound")==0) {
					alert ("找不到檔案: "+oldName);
				} else {
					alert ("listDrws Exception occurred: "+pfcGetExceptionType(err));
				}
				*/
				//alert (s+"drwOldNameArr=NA");
				drwOldNameArr.push ("NA");
				drwNewNameArr.push ("NA");
				drwCommonNameArr.push ("NA");
				continue;
			}
		} else {
			//alert (s+"drwOldNameArr=NA");
			drwOldNameArr.push ("NA");
			drwNewNameArr.push ("NA");
			drwCommonNameArr.push ("NA");
		}
	}
	
}

function renameComponents (moldNO,tempNumber,tempType){
		for (n = 0; n < oldNameArr.length; n++){ //MODEL
			//alert ("oldNameArr="+oldNameArr[n]);
			var newName = oldNameArr[n].replace("exxxx", moldNO);
			if (tempType=="asmTempNumber" || tempType=="prtTempNumber"){
				
				//有些範本會以2 3 開始
				newName = newName.replace("2.prt", "1.prt");
				newName = newName.replace("3.prt", "1.prt");
				newName = newName.replace("4.prt", "1.prt");
				newName = newName.replace("5.prt", "1.prt");
				newName = newName.replace("6.prt", "1.prt");
				newName = newName.replace("7.prt", "1.prt");
				newName = newName.replace("8.prt", "1.prt");
				newName = newName.replace("9.prt", "1.prt");
				newName = newName.replace("10.prt", "1.prt"); //是否有例外?
			}
			
			//處理陣列特徵
			if (oldNameArr[n]===oldNameArr[n-1]){
				newName = newNameArr[n-1]; //getActions有設定保留 非必要
			}
			
			newNameArr.push (newName);
		}
}

function getActions (tempType){
		for (n = 0; n < oldNameArr.length; n++){ //MODEL
			//alert ("oldNameArr="+oldNameArr[n]);
			var actionTemp;
			if (tempType=="stdPartNumber"){
				actionTemp = "保留";
			} else {
				actionTemp = "新建";
			}
			//例外條件
			if (oldNameArr[n].indexOf("exxxx")==0){
				actionTemp = "新建";
			}
			//處理陣列特徵
			if (oldNameArr[n]===oldNameArr[n-1]){
				actionTemp = "保留";
			}
			
			actionArr.push (actionTemp);
		}
}

function setActions (){
		var actionTemp = "新建";
		for (n = 0; n < oldNameArr.length; n++){
			//alert("n="+n);
			//alert(parentArr[n].FileName);
			if (parentArr[n].FileName.indexOf("asm.asm")>=0){
				actionTemp = "新建"; //reset
			}
			
			for (b = 0; b < pltDelArr.length; b++){
				if (oldNameArr[n].indexOf(pltDelArr[b])>=0){
					actionTemp = "刪除";
				}
			}
			actionArr[n] = actionTemp;
		}
}

//檢查物件庫檔案衝突
function checkSameName (actServ,mdlName){
	//alert ("Check:"+mdlName);
	var result = null;
	try {
		var url = actServ.GetAliasedUrl(mdlName);
		result = url+"exists";
	}
	catch (err)
	{
		if (pfcGetExceptionType(err).indexOf("pfcXToolkitNotFound")==0){ //注意 非pfcXToolkitNotFound
			result = "OK";
		} else {
			alert ("Exception occurred: "+pfcGetExceptionType (err));
		}
	}
	finally {
		return result;
	}
}

//增加流水號
function addComponentSeq (gotName){
	var gotNames = gotName.split(".");
	var changeName = null;
	if (gotNames[0].indexOf("_")!=-1){
		var gotFNames = gotNames[0].split("_");
		var seq = parseInt(gotFNames[1]);
		var gotFName1 = "";
		
		if (gotFNames[1].indexOf("-")!=-1){ //EXXXXSTA1_1-FK.ASM
			var gotGNames = gotFNames[1].split("-");
			seq = parseInt(gotGNames[0]);
			gotFName1 = "-"+gotGNames[1]; //add later
		}
		
		if (Number.isInteger(seq)){
			seq = seq + 1;
		} else {
			seq = seqStr;
		}
		
		changeName = gotFNames[0]+"_"+seq;
		changeName = changeName + gotFName1;
		if (gotFNames.length>2){
			for (k = 2; k < gotFNames.length; k++){
				changeName = changeName + "_" + gotFNames[k];
			}
		}
		changeName = changeName + "." + gotNames[1];
	} else {
		var seqStr = gotNames[0].slice(-2); //取得檔名的最後兩個字
		var seq = parseInt(seqStr);
		if (Number.isInteger(seq)){
			seq = seq + 1;
		} else {
			seq = seqStr;
		}
	
		
		if (seq<10){
			changeName = gotNames[0].slice(0,-2) + "0" + seq + "." + gotNames[1];
		} else {
			changeName = gotNames[0].slice(0,-2) + seq + "." + gotNames[1];
		}
	}
	
	return changeName;
}

//顯示資訊
function displayModelTable(templateNumber,action,newNumber,commonName,drwNewNumber,drwCommonName,nameUrl,mdlIndex,drwIndex){
    var table = document.getElementById("ModelTable");
	
	var c0 = null;
	var c1 = null;
	var c2 = null;
	var c3 = null;
	var c4 = null;
	var c5 = null;
	var c6 = null;
	
	var rowNum = mdlIndex;
	//alert ("display:"+rowNum);
	
	if (rowNum==0){
		var row0 = table.insertRow(rowNum);

		c0 = row0.insertCell(0);
		c1 = row0.insertCell(1);
		c2 = row0.insertCell(2);
		c3 = row0.insertCell(3);
		c4 = row0.insertCell(4);
		c5 = row0.insertCell(5);
		c6 = row0.insertCell(6);

		//set style
		c0.className = 'member_new_style10';
		c1.className = 'member_new_style10';
		c2.className = 'member_new_style10';
		c3.className = 'member_new_style10';
		c4.className = 'member_new_style10';
		c5.className = 'member_new_style10';
		c6.className = 'member_new_style10';

		// Add text to the new cells:
		c0.innerHTML = "原檔案名稱";
		c1.innerHTML = "動作";
		c2.innerHTML = "新檔案名稱";
		c3.innerHTML = "零件中文圖名";
		c4.innerHTML = "工程圖檔案名稱";
		c5.innerHTML = "工程圖中文圖名";
		c6.innerHTML = "狀態";
	}

	rowNum = rowNum+1;
	var row = table.insertRow(rowNum);

	c0 = row.insertCell(0);
	c1 = row.insertCell(1);
	c2 = row.insertCell(2);
	c3 = row.insertCell(3);
	c4 = row.insertCell(4);
	c5 = row.insertCell(5);
	c6 = row.insertCell(6);

	//set style
	c0.className = 'member_new_style10';
	c1.className = 'member_new_style18';
	c2.className = 'member_new_style18';
	c3.className = 'member_new_style18';
	c4.className = 'member_new_style18';
	c5.className = 'member_new_style18';
	c6.className = 'member_new_style18';
	
	//拆解字串
	// Add text to the new cells:
	c0.innerHTML = templateNumber;
	c1.innerHTML = "<button type='submit' onclick='changAction("+rowNum+")'>"+action+"</button>"; //action無法做為參數傳入
	c2.innerHTML = "<input type='text' name='newNumber"+mdlIndex+"' id='newNumber"+mdlIndex+"' value='"+ newNumber +"' />";
	c3.innerHTML = commonName;
	c4.innerHTML = "<input type='text' name='drwNewNumber"+drwIndex+"' id='drwNewNumber"+drwIndex+"' value='"+ drwNewNumber +"' />";
	c5.innerHTML = "<input type='text' name='drwCommonName"+drwIndex+"' id='drwCommonName"+drwIndex+"' value='"+ drwCommonName +"' />";
	c6.innerHTML = nameUrl;
	//alert ("drwNewNumber:"+drwIndex+";value="+drwNewNumber);
}

function displayModelPic(templateNumber){
	//alert ("displayPic:"+templateNumber);
	//注意 測試環境
	window.top.frames["modelFrame"].location.href = "http://sdiplm.sdi.com.tw/Windchill/netmarkets/jsp/dns/viewCreoTemplate.jsp?templateNumber="+templateNumber;
}

function changAction (thisRowNum){
	var thisAct = actionArr[thisRowNum-1];
	//alert ("thisAct:"+thisAct);
	//alert ("thisRowNum:"+thisRowNum);
	var table = document.getElementById("ModelTable");
	var cell1 = table.rows[thisRowNum].cells[1];
	var nextAct;
	if (thisAct=="新建"){
		nextAct = "保留";
	}
	if (thisAct=="保留"){
		nextAct = "刪除";
	}
	if (thisAct=="刪除"){
		nextAct = "新建";
	}
	actionArr[thisRowNum-1] = nextAct;
	cell1.innerHTML = "<button type='submit' onclick='changAction("+thisRowNum+")'>"+nextAct+"</button>";
}

function generate (){
	//Rename MODEL
	try {
	    var session = pfcGetProESession();
		//alert ("session");
		var actServ = session.GetActiveServer();
		//alert ("actServ");
		reloadNames(); //取得使用者最後input的名稱
		//alert ("reloadNames oldNameArr="+oldNameArr);
		var removeMdlNames = pfcCreate ("stringseq");
		//alert ("newNameArr="+newNameArr[0]);
		mdlNameforDel = newNameArr[0]; //給下個網頁用
		
		for (m = 0; m < oldNameArr.length; m++){
			//alert ("now on:"+oldNameArr[m]);
			removeMdlNames.Append(oldNameArr[m]); //後續刪除工作區檔案
			//alert ("removeMdlNames:"+oldNameArr[m]);
			var tempMdl = null;
			if (actionArr[m]=="新建" && newNameArr[m]!=oldNameArr[m]){
				if (oldNameArr[m].indexOf("asm")>0){
					tempMdl = session.GetModel(oldNameArr[m],pfcCreate ("pfcModelType").MDL_ASSEMBLY);
					//alert ("tempMdl:"+oldNameArr[m]);
				}
				if (oldNameArr[m].indexOf("prt")>0){
					tempMdl = session.GetModel(oldNameArr[m],pfcCreate ("pfcModelType").MDL_PART);
					//alert ("tempMdl:"+oldNameArr[m]);
				}
				//alert ("Rename:"+newNameArr[m]);
				tempMdl.Rename(newNameArr[m],true);
				//alert ("Rename:"+oldNameArr[m]);
			}
			//保留 do nothing
			if (actionArr[m]=="刪除"){
				//alert ("deleteModel");
				//deleteModel(m); //rename前刪除 從上層組件的特徵中刪除
				if (oldNameArr[m].indexOf("asm")>0){
					tempMdl = session.GetModel(oldNameArr[m],pfcCreate ("pfcModelType").MDL_ASSEMBLY);
					//alert ("tempMdl:"+oldNameArr[m]);
				}
				if (oldNameArr[m].indexOf("prt")>0){
					tempMdl = session.GetModel(oldNameArr[m],pfcCreate ("pfcModelType").MDL_PART);
					//alert ("tempMdl:"+oldNameArr[m]);
				}
				tempMdl.Rename(newNameArr[m],true);
				//alert ("Rename:"+oldNameArr[m]);
				deleteItems = deleteItems+"~"+newNameArr[m]; //給下個網頁用
			/*
				if (oldNameArr[m].indexOf("asm")>0){
					tempMdl = session.GetModel(oldNameArr[m],pfcCreate ("pfcModelType").MDL_ASSEMBLY);
				}
				if (oldNameArr[m].indexOf("prt")>0){
					tempMdl = session.GetModel(oldNameArr[m],pfcCreate ("pfcModelType").MDL_PART);
				}
				alert ("UndoCheckout"+oldNameArr[m]);
				actServ.UndoCheckout(tempMdl);
			*/
			}
		}

		//Save
		var newMdl;
		if (newNameArr[0].indexOf("asm")>0){
			newMdl = session.GetModel(newNameArr[0],pfcCreate ("pfcModelType").MDL_ASSEMBLY);
		}
		if (newNameArr[0].indexOf("prt")>0){
			newMdl = session.GetModel(newNameArr[0],pfcCreate ("pfcModelType").MDL_PART);
		}
		alert ("儲存"+newNameArr[0]);
		newMdl.Save();
		//alert ("顯示");
		//newMdl.Display();
		//alert ("取得window");
		//var newMdlWin = session.GetModelWindow(newMdl);
		//alert ("啟用window"+newMdlWin.GetId());
		//newMdlWin.Activate();
		
		

		alert ("上載"+newNameArr[0]);
		actServ.UploadObjects(newMdl);
		//actServ.UploadObjectsWithOptions
		
		
		
		var removeDrwNames = pfcCreate ("stringseq");
		//Rename DRW
		for (n = 0; n < drwOldNameArr.length; n++){
			//alert ("now on:"+drwOldNameArr[n]+">>"+drwNewNameArr[n]);
			
			var tempMdl = null;
			if (drwNewNameArr[n]=="na" || actionArr[n]=="刪除" || drwOldNameArr[n]=="NA"){ //reloadNames取代變成小寫
				//do nothing
				//alert ("do nothing");
			} else {
				//removeDrwNames.Append(drwOldNameArr[n]); //後續刪除工作區檔案
				tempMdl = session.GetModel(drwOldNameArr[n],pfcCreate ("pfcModelType").MDL_DRAWING);
				tempMdl.Rename(drwNewNameArr[n],true);
				if (tempMdl.IsCommonNameModifiable()){
					tempMdl.CommonName = drwCommonNameArr[n];
				}
				tempMdl.Save();
				actServ.UploadObjects(tempMdl);
			}
			
			if (drwNewNameArr[n]!="na" && drwOldNameArr[n]!="NA"){
				removeDrwNames.Append(drwOldNameArr[n]); //後續刪除工作區檔案
			}
		}
		
		//刪除工作區的範本
		if (removeMdlNames.Count>0){
			actServ.RemoveObjects(removeMdlNames);
			alert ("已清除工作區模型範本:"+removeMdlNames.Count);
		}
		//刪除工作區的範本
		if (removeDrwNames.Count>0){
			actServ.RemoveObjects(removeDrwNames);
			alert ("已清除工作區工程圖範本:"+removeDrwNames.Count);
		}
	}
	catch(err){
		if (pfcGetExceptionType(err).indexOf("PRO_TK_CHECKOUT_CONFLICT")==0 || pfcGetExceptionType(err).indexOf("pfcXToolkitCheckoutConflict")==0){
			alert ("PRO_TK_CHECKOUT_CONFLICT");
		} else if (pfcGetExceptionType(err).indexOf("PRO_TK_E_NOT_FOUND")==0 || pfcGetExceptionType(err).indexOf("pfcXToolkitNotFound")==0) {
			alert ("PRO_TK_E_NOT_FOUND");
		} else {
			alert ("Exception occurred: "+pfcGetExceptionType(err));
		}
	}
		
//try {


//	} catch (err) {
//				if (pfcGetExceptionType(err).indexOf("PRO_TK_CHECKOUT_CONFLICT")==0 || pfcGetExceptionType(err).indexOf("pfcXToolkitCheckoutConflict")==0){
//					alert ("PRO_TK_CHECKOUT_CONFLICT: "+drwNewNameArr[n]);
//				} else if (pfcGetExceptionType(err).indexOf("PRO_TK_E_NOT_FOUND")==0 || pfcGetExceptionType(err).indexOf("pfcXToolkitNotFound")==0) {
//					alert ("PRO_TK_E_NOT_FOUND: "+drwOldNameArr[n]);
	//			} else {
		//			alert ("Exception occurred: "+pfcGetExceptionType(err));
			//	}
				//continue;
	//}
	alert ("已建立");
}

function deleteModel (index){
	try {
	    var session = pfcGetProESession();
		//無法用EraseWithDependencies()刪除 只能從上層組件刪除特徵
		var parentMdl = parentArr[index];
		
		var components = parentMdl.ListFeaturesByType (true,pfcCreate ("pfcFeatureType").FEATTYPE_COMPONENT);
		
		//尋找要刪除的組件特徵
		var deleteComp = "NA";
		for (k = 0; k < components.Count; k++){
			var component = components.Item(k);
			var desc = component.ModelDescr;
			var cmdl = session.RetrieveModel(desc);
			//alert (cmdl.FileName+" vs "+oldNameArr[index]);
			if (cmdl.FileName==oldNameArr[index]){
				deleteComp = component;
			}
		}

		//執行刪除
		if (deleteComp=="NA"){
			alert ("Invalid Target");
		} else {
			var delOp = deleteComp.CreateDeleteOp(); //delOp.Clip 預設不刪除相關特徵
			var FeatOps = pfcCreate ("pfcFeatureOperations");
			FeatOps.Append(delOp);
			session.SetConfigOption("regen_failure_handling","resolve_mode");
			parentMdl.ExecuteFeatureOps(FeatOps,null);
			parentMdl.Regenerate(null);
			session.SetConfigOption("regen_failure_handling","no_resolve_mode");
		}
	}
	catch(err){	alert ("Exception occurred: "+pfcGetExceptionType(err)); }
}

function reloadNames (){
	//alert ("newNameArr start");
	for (m = 0; m < newNameArr.length; m++){
		if (actionArr[m]=="新建"){
			var newNameInputField = "newNumber"+m;
			newNameArr[m] = document.getElementById(newNameInputField).value.toLowerCase();
			//alert (newNameInputField+"="+document.getElementById(newNameInputField).value.toLowerCase());
		}
	}
	//alert ("drwNewNameArr start");
	for (n = 0; n < drwNewNameArr.length; n++){
		if (actionArr[n]=="新建"){
			var newDrwNameInputField = "drwNewNumber"+n;
			drwNewNameArr[n] = document.getElementById(newDrwNameInputField).value.toLowerCase();
			//alert (newDrwNameInputField+"="+document.getElementById(newDrwNameInputField).value.toLowerCase());
		
			var newDrwComNameInputField = "drwCommonName"+n;
			drwCommonNameArr[n] = document.getElementById(newDrwComNameInputField).value;
			//alert (newDrwComNameInputField+"="+document.getElementById(newDrwComNameInputField).value.toLowerCase());
		}
	}
}

function cancel (){
	window.location.href = "NewModel.html";
}

function newSTA (){
	window.location.href = "NewSTA.html";
}

function deleteItem (){
	window.location.href = "NewModelDeleteItem.jsp?mdlName="+mdlNameforDel+"&deleteItems="+deleteItems;
}
//------------------------------------------------------------------------
Number.isInteger = Number.isInteger || function(value) {
    return typeof value === "number" && 
           isFinite(value) && 
           Math.floor(value) === value;
};

</script>
<body link=blue vlink=purple style='tab-interval:.5in'>
<%
request.setCharacterEncoding("UTF-8");
String moldNO =  request.getParameter("moldNO"); //製程
%>
<div class=Section1>
<table border=0 cellspacing=0 cellpadding=0 width="100%">

	<tr bgcolor="#cc0000">
	<td>&nbsp;</td>
	<td height="1" colspan="3" id="navigation" class="navText"></td>
	</tr>

<tr><td colspan="3">
<table style="border:3px #cccccc solid;" cellpadding="10" border='1' width="100%">
<tr>
<td>
<table>
<tr>
	<td>
    <h3>模具編號
	</h3>
	</td>
	<td>
    <h3>
	<input type='text' id="moldNO" size='10' value="<%= moldNO %>"/>
	模板數<input type='text' id="plateCount" size='10' value="4"/>
	<input type='hidden' name="type" id="type" value="E"/>
	<input type='hidden' name="asmTempNumber" id="asmTempNumber" value="EXXXXASM.ASM"/>
	</h3>
	</td>
</tr>

</table>
</td>
</tr>
<tr>
  <td>
  	<table id="ModelTable">
	</table>
	<input type=button value="套用模型" id="getTemplate" name="getTemplate" onclick="getTemplate('asmTempNumber')">
	<input type=button value="建立模型" id="generate" name="generate" onclick="generate()">
	<input type=button value="取消" id="cancel" name="cancel" onclick="cancel()">
	<input type=button value="刪除物件副程式" id="deleteItem" name="deleteItem" onclick="deleteItem()">
  </td>
</tr>
</table>
</td></tr>


	<tr bgcolor="#cc0000">
	<td>&nbsp;</td>
	<td height="1" colspan="3" id="navigation" class="navText"></td>
	</tr>

</table>
</div>

</body>
</html>