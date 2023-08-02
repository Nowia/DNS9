<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>�s�ؼҫ�</title>
<link href="../css/mm_restaurant1.css" media="screen" rel="stylesheet" type="text/css" />
<link href="../css/form.css" media="screen" rel="stylesheet" type="text/css" />
</head>
<script src="../jscript/pfcUtils.js">
</script>
<script language="JavaScript">

var oldNameArr = new Array ();
var newNameArr = new Array ();
var commonNameArr = new Array ();
var drwOldNameArr = new Array (); //�ƶq�MoldNameArr�ۦP
var drwNewNameArr = new Array ();
var drwCommonNameArr = new Array ();
var urlArr = new Array ();
var actionArr = new Array ();
var parentArr = new Array (); //parent of component
var deleteItems = "NA";
var mdlNameforDel = "NA";
var pltDelArr = new Array ();

//���o�d���Ψ��T
function getTemplate (tempType){
	try {
	    var session = pfcGetProESession();
		var actServ = session.GetActiveServer();
		
		//alert( "ActiveWorkspace=" + actServ.ActiveWorkspace);
		//alert( "Alias=" + actServ.Alias);
		//alert( "Context=" + actServ.Context);

		if (actServ.Alias.indexOf("PLM")==-1){
			alert ("���ˬd�O�_���s��PLM");
		}

		//���o�d��
		var tempNumber = document.getElementById(tempType).value.toLowerCase();
		var mdlDescr = pfcCreate ("pfcModelDescriptor").CreateFromFileName (tempNumber);
		var topMdl = session.RetrieveModel(mdlDescr);
		
		//user input
		var moldNO = document.getElementById("moldNO").value.toLowerCase(); //PLM�ɦW
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
		parentArr.push(topMdl); //�x�s�W�h�ե�Ѥ���R���� �̤W�h�ե��x�s�ۤv �q�`���|�Ψ�

		//�C�X��T
		if (topMdl.FileName.indexOf("asm")>0){
			listComponents(session,topMdl);
		}
		//alert ("oldNameArr="+oldNameArr);

		//�ʧ@�P�_
		getActions(tempType);
		//alert("setActions");
		//setActions();
		
		//�C�X�è��o�u�{�� "�O�d"�����|���u�{��
		listDrws(session);

		//���s�R�W
		renameComponents(moldNO,tempNumber,tempType);
		//alert ("newNameArr="+newNameArr);
		//alert ("parentArr="+parentArr);


		//�ˬd����w�ɮ׽Ĭ�
		for (n = 0; n < newNameArr.length; n++){
			if (newNameArr[n]==oldNameArr[n]){
				urlArr.push ("OK");
			} else {
				var nameCheck = newNameArr[n];
				var result = checkSameName(actServ,nameCheck);

				//���s�R�WMODEL
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
		
		//�ˬd�����W�Ǥ����Ĭ�
		//alert ("check");
		for (p = 1; p < newNameArr.length; p++){
			if (actionArr[p]=="�s��"){
				var nameThis = newNameArr[p];
				for (q = 1; q < p; q++){
					if (nameThis==newNameArr[q]){
						nameThis = addComponentSeq(nameThis);
					}
				}
				newNameArr[p] = nameThis;
			}
		}
		
		//��ܲM��  ���s�R�W�u�{��
		//alert ("displayModelTable");
		for (m = 0; m < oldNameArr.length; m++){
			var searchName = oldNameArr[m].replace(".prt", '');
			searchName = searchName.replace(".asm", '');
			var drwNewName = "NA"; //�S���u�{�Ϫ��|���NA
			var drwCommonName = "NA";
			var drwIndex=m;
			for (f = 0; f < drwOldNameArr.length; f++){
				var ret = drwOldNameArr[f].replace('.drw','');
				//if (drwOldNameArr[f].indexOf(searchName)==0){ �ݥ������r�@��
				if (ret==searchName){
					drwNewNameArr[f] = newNameArr[m].replace(".prt", ".drw");
					drwNewNameArr[f] = drwNewNameArr[f].replace(".asm", ".drw");
					drwCommonNameArr[f] = commonNameArr[m]+"�u�{��";
					drwNewName = drwNewNameArr[f];
					drwCommonName = drwCommonNameArr[f];
					drwIndex = f;
					break;
				}
			}
			//alert ("searchName="+searchName+"drwOldNameArr="+drwOldNameArr[f]+"drwNewName="+drwNewName);
			displayModelTable(oldNameArr[m],actionArr[m],newNameArr[m],commonNameArr[m],drwNewName,drwCommonName,urlArr[m],m,drwIndex);
		}
		
		
		//����Y��
		//displayModelPic(tempNumber);
	}
	catch(err){	alert ("Exception occurred: "+pfcGetExceptionType(err)); }
}

//���o�ե�U������
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
		parentArr.push(mdl); //�x�s�W�h�ե�Ѥ���R����
		//alert ("push "+cmdl.FileName);
		if (cmdl.FileName.indexOf("asm")!=-1){
			var k_temp = k; //k�|�Qrecursive�{���ﱼ �n�p��
			var count = listComponents(session,cmdl); //recursive
			k = k_temp; //restore
		}
		//alert (cmdl.FileName+"Done"+k);
	}
	}
	catch(err){	alert ("Exception occurred: "+pfcGetExceptionType(err)); }
}

//�C�X�è��o�u�{��
function listDrws (session){
	
	for (s = 0; s < oldNameArr.length; s++){
		if (actionArr[s].indexOf("�O�d")==-1){ //�ư�"�O�d"�� oldNameArr[s].indexOf("_")==-1 && 
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
			} catch(err){ //asm�ɦp�G�䤣��۹�����drw�N��NA
				/*
				if (pfcGetExceptionType(err).indexOf("PRO_TK_E_NOT_FOUND")==0 || pfcGetExceptionType(err).indexOf("pfcXToolkitNotFound")==0) {
					alert ("�䤣���ɮ�: "+oldName);
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
				
				//���ǽd���|�H2 3 �}�l
				newName = newName.replace("2.prt", "1.prt");
				newName = newName.replace("3.prt", "1.prt");
				newName = newName.replace("4.prt", "1.prt");
				newName = newName.replace("5.prt", "1.prt");
				newName = newName.replace("6.prt", "1.prt");
				newName = newName.replace("7.prt", "1.prt");
				newName = newName.replace("8.prt", "1.prt");
				newName = newName.replace("9.prt", "1.prt");
				newName = newName.replace("10.prt", "1.prt"); //�O�_���ҥ~?
			}
			
			//�B�z�}�C�S�x
			if (oldNameArr[n]===oldNameArr[n-1]){
				newName = newNameArr[n-1]; //getActions���]�w�O�d �D���n
			}
			
			newNameArr.push (newName);
		}
}

function getActions (tempType){
		for (n = 0; n < oldNameArr.length; n++){ //MODEL
			//alert ("oldNameArr="+oldNameArr[n]);
			var actionTemp;
			if (tempType=="stdPartNumber"){
				actionTemp = "�O�d";
			} else {
				actionTemp = "�s��";
			}
			//�ҥ~����
			if (oldNameArr[n].indexOf("exxxx")==0){
				actionTemp = "�s��";
			}
			//�B�z�}�C�S�x
			if (oldNameArr[n]===oldNameArr[n-1]){
				actionTemp = "�O�d";
			}
			
			actionArr.push (actionTemp);
		}
}

function setActions (){
		var actionTemp = "�s��";
		for (n = 0; n < oldNameArr.length; n++){
			//alert("n="+n);
			//alert(parentArr[n].FileName);
			if (parentArr[n].FileName.indexOf("asm.asm")>=0){
				actionTemp = "�s��"; //reset
			}
			
			for (b = 0; b < pltDelArr.length; b++){
				if (oldNameArr[n].indexOf(pltDelArr[b])>=0){
					actionTemp = "�R��";
				}
			}
			actionArr[n] = actionTemp;
		}
}

//�ˬd����w�ɮ׽Ĭ�
function checkSameName (actServ,mdlName){
	//alert ("Check:"+mdlName);
	var result = null;
	try {
		var url = actServ.GetAliasedUrl(mdlName);
		result = url+"exists";
	}
	catch (err)
	{
		if (pfcGetExceptionType(err).indexOf("pfcXToolkitNotFound")==0){ //�`�N �DpfcXToolkitNotFound
			result = "OK";
		} else {
			alert ("Exception occurred: "+pfcGetExceptionType (err));
		}
	}
	finally {
		return result;
	}
}

//�W�[�y����
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
		var seqStr = gotNames[0].slice(-2); //���o�ɦW���̫��Ӧr
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

//��ܸ�T
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
		c0.innerHTML = "���ɮצW��";
		c1.innerHTML = "�ʧ@";
		c2.innerHTML = "�s�ɮצW��";
		c3.innerHTML = "�s�󤤤�ϦW";
		c4.innerHTML = "�u�{���ɮצW��";
		c5.innerHTML = "�u�{�Ϥ���ϦW";
		c6.innerHTML = "���A";
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
	
	//��Ѧr��
	// Add text to the new cells:
	c0.innerHTML = templateNumber;
	c1.innerHTML = "<button type='submit' onclick='changAction("+rowNum+")'>"+action+"</button>"; //action�L�k�����ѼƶǤJ
	c2.innerHTML = "<input type='text' name='newNumber"+mdlIndex+"' id='newNumber"+mdlIndex+"' value='"+ newNumber +"' />";
	c3.innerHTML = commonName;
	c4.innerHTML = "<input type='text' name='drwNewNumber"+drwIndex+"' id='drwNewNumber"+drwIndex+"' value='"+ drwNewNumber +"' />";
	c5.innerHTML = "<input type='text' name='drwCommonName"+drwIndex+"' id='drwCommonName"+drwIndex+"' value='"+ drwCommonName +"' />";
	c6.innerHTML = nameUrl;
	//alert ("drwNewNumber:"+drwIndex+";value="+drwNewNumber);
}

function displayModelPic(templateNumber){
	//alert ("displayPic:"+templateNumber);
	//�`�N ��������
	window.top.frames["modelFrame"].location.href = "http://sdiplm.sdi.com.tw/Windchill/netmarkets/jsp/dns/viewCreoTemplate.jsp?templateNumber="+templateNumber;
}

function changAction (thisRowNum){
	var thisAct = actionArr[thisRowNum-1];
	//alert ("thisAct:"+thisAct);
	//alert ("thisRowNum:"+thisRowNum);
	var table = document.getElementById("ModelTable");
	var cell1 = table.rows[thisRowNum].cells[1];
	var nextAct;
	if (thisAct=="�s��"){
		nextAct = "�O�d";
	}
	if (thisAct=="�O�d"){
		nextAct = "�R��";
	}
	if (thisAct=="�R��"){
		nextAct = "�s��";
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
		reloadNames(); //���o�ϥΪ̳̫�input���W��
		//alert ("reloadNames oldNameArr="+oldNameArr);
		var removeMdlNames = pfcCreate ("stringseq");
		//alert ("newNameArr="+newNameArr[0]);
		mdlNameforDel = newNameArr[0]; //���U�Ӻ�����
		
		for (m = 0; m < oldNameArr.length; m++){
			//alert ("now on:"+oldNameArr[m]);
			removeMdlNames.Append(oldNameArr[m]); //����R���u�@���ɮ�
			//alert ("removeMdlNames:"+oldNameArr[m]);
			var tempMdl = null;
			if (actionArr[m]=="�s��" && newNameArr[m]!=oldNameArr[m]){
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
			//�O�d do nothing
			if (actionArr[m]=="�R��"){
				//alert ("deleteModel");
				//deleteModel(m); //rename�e�R�� �q�W�h�ե󪺯S�x���R��
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
				deleteItems = deleteItems+"~"+newNameArr[m]; //���U�Ӻ�����
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
		alert ("�x�s"+newNameArr[0]);
		newMdl.Save();
		//alert ("���");
		//newMdl.Display();
		//alert ("���owindow");
		//var newMdlWin = session.GetModelWindow(newMdl);
		//alert ("�ҥ�window"+newMdlWin.GetId());
		//newMdlWin.Activate();
		
		

		alert ("�W��"+newNameArr[0]);
		actServ.UploadObjects(newMdl);
		//actServ.UploadObjectsWithOptions
		
		
		
		var removeDrwNames = pfcCreate ("stringseq");
		//Rename DRW
		for (n = 0; n < drwOldNameArr.length; n++){
			//alert ("now on:"+drwOldNameArr[n]+">>"+drwNewNameArr[n]);
			
			var tempMdl = null;
			if (drwNewNameArr[n]=="na" || actionArr[n]=="�R��" || drwOldNameArr[n]=="NA"){ //reloadNames���N�ܦ��p�g
				//do nothing
				//alert ("do nothing");
			} else {
				//removeDrwNames.Append(drwOldNameArr[n]); //����R���u�@���ɮ�
				tempMdl = session.GetModel(drwOldNameArr[n],pfcCreate ("pfcModelType").MDL_DRAWING);
				tempMdl.Rename(drwNewNameArr[n],true);
				if (tempMdl.IsCommonNameModifiable()){
					tempMdl.CommonName = drwCommonNameArr[n];
				}
				tempMdl.Save();
				actServ.UploadObjects(tempMdl);
			}
			
			if (drwNewNameArr[n]!="na" && drwOldNameArr[n]!="NA"){
				removeDrwNames.Append(drwOldNameArr[n]); //����R���u�@���ɮ�
			}
		}
		
		//�R���u�@�Ϫ��d��
		if (removeMdlNames.Count>0){
			actServ.RemoveObjects(removeMdlNames);
			alert ("�w�M���u�@�ϼҫ��d��:"+removeMdlNames.Count);
		}
		//�R���u�@�Ϫ��d��
		if (removeDrwNames.Count>0){
			actServ.RemoveObjects(removeDrwNames);
			alert ("�w�M���u�@�Ϥu�{�Ͻd��:"+removeDrwNames.Count);
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
	alert ("�w�إ�");
}

function deleteModel (index){
	try {
	    var session = pfcGetProESession();
		//�L�k��EraseWithDependencies()�R�� �u��q�W�h�ե�R���S�x
		var parentMdl = parentArr[index];
		
		var components = parentMdl.ListFeaturesByType (true,pfcCreate ("pfcFeatureType").FEATTYPE_COMPONENT);
		
		//�M��n�R�����ե�S�x
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

		//����R��
		if (deleteComp=="NA"){
			alert ("Invalid Target");
		} else {
			var delOp = deleteComp.CreateDeleteOp(); //delOp.Clip �w�]���R�������S�x
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
		if (actionArr[m]=="�s��"){
			var newNameInputField = "newNumber"+m;
			newNameArr[m] = document.getElementById(newNameInputField).value.toLowerCase();
			//alert (newNameInputField+"="+document.getElementById(newNameInputField).value.toLowerCase());
		}
	}
	//alert ("drwNewNameArr start");
	for (n = 0; n < drwNewNameArr.length; n++){
		if (actionArr[n]=="�s��"){
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
String moldNO =  request.getParameter("moldNO"); //�s�{
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
    <h3>�Ҩ�s��
	</h3>
	</td>
	<td>
    <h3>
	<input type='text' id="moldNO" size='10' value="<%= moldNO %>"/>
	�ҪO��<input type='text' id="plateCount" size='10' value="4"/>
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
	<input type=button value="�M�μҫ�" id="getTemplate" name="getTemplate" onclick="getTemplate('asmTempNumber')">
	<input type=button value="�إ߼ҫ�" id="generate" name="generate" onclick="generate()">
	<input type=button value="����" id="cancel" name="cancel" onclick="cancel()">
	<input type=button value="�R������Ƶ{��" id="deleteItem" name="deleteItem" onclick="deleteItem()">
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