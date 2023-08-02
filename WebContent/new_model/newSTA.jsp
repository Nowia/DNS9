<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>�ոˤu�{��</title>
<link href="../css/mm_restaurant1.css" media="screen" rel="stylesheet" type="text/css" />
<link href="../css/form.css" media="screen" rel="stylesheet" type="text/css" />
</head>
<script src="../js/jquery-3.6.0.min.js"></script>
<script src="../jscript/pfcUtils.js">
</script>
<script language="JavaScript">
//�����ܼƥi�QNewModel.js�I�s
var oldNameArr = new Array ();
var newNameArr = new Array ();
var newNameHistoryArr = new Array (); //�����s�W���Ҧ��ɦW �P�_�Ĭ��
var commonNameArr = new Array ();
var drwOldNameArr = new Array (); //�ƶq�MoldNameArr���P
var drwNewNameArr = new Array ();
var drwCommonNameArr = new Array ();
var urlArr = new Array ();
var actionArr = new Array ();
var parentArr = new Array (); //parent of component
var chArr = ["�@�릨�Τu�{���ե�", "�R�Ťu�{���ե�", "�j���ƶ��u�{���ե�", "�����R�Ťu�{���ե�CYNG", "�����R�Ťu�{���ե�CYYG","�ɥ��u�{���ե�"];
var enArr = ["EXXXXSTA1_1-FK.ASM", "EXXXXSTA1_1.ASM", "EXXXXSTA1_1-BFT-YG.ASM", "EXXXXSTA1_1-CYNG.ASM", "EXXXXSTA1_1-CYYG.ASM","EXXXXSTA1_1-CR-XXX.ASM"];
var chUnicodeArr = ["\u4e00\u822c\u6210\u5f62\u5de5\u7a0b\u7ad9\u7d44\u4ef6",
					"\u6c96\u526a\u5de5\u7a0b\u7ad9\u7d44\u4ef6",
					"\u5927\u9802\u6599\u584a\u5de5\u7a0b\u7ad9\u7d44\u4ef6",
					"\u9593\u6b47\u6c96\u526a\u5de5\u7a0b\u7ad9\u7d44\u4ef6",
					"\u9593\u6b47\u6c96\u526a\u5de5\u7a0b\u7ad9\u7d44\u4ef6",
					"\u88dc\u6b63\u5de5\u7a0b\u7ad9\u7d44\u4ef6"]; //not used
var chURLArr = ["%E4%B8%80%E8%88%AC%E6%88%90%E5%BD%A2%E5%B7%A5%E7%A8%8B%E7%AB%99%E7%B5%84%E4%BB%B6",
					"%E6%B2%96%E5%89%AA%E5%B7%A5%E7%A8%8B%E7%AB%99%E7%B5%84%E4%BB%B6",
					"%E5%A4%A7%E9%A0%82%E6%96%99%E5%A1%8A%E5%B7%A5%E7%A8%8B%E7%AB%99%E7%B5%84%E4%BB%B6",
					"%E9%96%93%E6%AD%87%E6%B2%96%E5%89%AA%E5%B7%A5%E7%A8%8B%E7%AB%99%E7%B5%84%E4%BB%B6",
					"%E9%96%93%E6%AD%87%E6%B2%96%E5%89%AA%E5%B7%A5%E7%A8%8B%E7%AB%99%E7%B5%84%E4%BB%B6",
					"%E8%A3%9C%E6%AD%A3%E5%B7%A5%E7%A8%8B%E7%AB%99%E7%B5%84%E4%BB%B6"];
					
var tableIndex;

function step1(setMdlName){
	//alert("�}��"+setMdlName);
	openMdl(setMdlName);
	//openMdl("e8793plt1.asm");

	var session = pfcGetProESession();
	var pltAsm = session.CurrentModel;
	//alert("�}��pltAsm");
	
	
	document.getElementById("inputParamTable").style.display="";
	var table = document.getElementById("inputParamTable");
	
	var c0 = null;
	var c1 = null;
	var c2 = null;
	var c3 = null;
	var c4 = null;
	
	var index = 0;
	//var FEATURE_DESCRIPTION = "NA";
	var STA_SAMPLE = "NA";
	var SAT_TEMPLATE = "NA";
	var SAT_NUM = "NA";

	for (y = 0; y < 15; y++){ //dont use n, used in GetSta
		index = index+1;
		var csysFeat = pltAsm.GetItemByName(pfcCreate("pfcModelItemType").ITEM_FEATURE,"ALL_SET__STA_CSY"+index);
		
		//alert("y="+y);
		if (csysFeat!=null){
			//FEATURE_DESCRIPTION = csysFeat.GetParam("FEATURE_DESCRIPTION").Value.StringValue;
			STA_SAMPLE = csysFeat.GetParam("STA_SAMPLE").Value.StringValue;
			//alert("STA_SAMPLE="+STA_SAMPLE);
			SAT_TEMPLATE = GetStaEN(STA_SAMPLE);
			//alert("SAT_TEMPLATE="+SAT_TEMPLATE);
			SAT_NUM = csysFeat.GetParam("STA_NUM").Value.StringValue;
		} else {
			STA_SAMPLE = "NA";
			SAT_TEMPLATE = "NA";
			SAT_NUM = "NA";
		}
		
		//set table
		var row = table.insertRow(y);

		c0 = row.insertCell(0);
		c1 = row.insertCell(1);
		c2 = row.insertCell(2);
		c3 = row.insertCell(3);
		c4 = row.insertCell(4);

		//set style
		c0.className = 'member_new_style11';
		c1.className = 'member_new_style10';
		c2.className = 'member_new_style10';
		c3.className = 'member_new_style10';
		c4.className = 'member_new_style10';

		// Add text to the new cells:
		c0.innerHTML = "ALL_SET__STA_CSY"+index;
		c1.innerHTML = "<input type='text' id='SAT_NUM"+index+"' size='10' value='"+SAT_NUM+"'/>";
		c2.innerHTML = STA_SAMPLE;
		c3.innerHTML = "<input type='text' id='ALL_SET__STA_CSY"+index+"' size='50' value='"+SAT_TEMPLATE+"'/>";
		c4.innerHTML = "<input type='checkbox' id='SET__STA"+index+"' checked='true'>";
		
		tableIndex = index; //for step2
	}
}

function step2(){
	//alert ("step2");
	var session = pfcGetProESession();
	var part = session.CurrentModel;
	var pltName = part.FileName;
	//alert ("pltName="+pltName);
	var index = 0;
	var inputField;
	var inputField2;
	var staName;
	var checkField;
	var isSetSTA; //�ϥΪ̿�ܬO�_�n�ո�
	//var lastStaName="��������STA_ASM��������";
	var lastStaName="\u2550\u2550\u2550\u2550STA_ASM\u2550\u2550\u2550\u2550"; //Unicode convert
	var moldNo = pltName.slice(0,5);
	//alert ("moldNo="+moldNo);
	
	var pltNames = pltName.split("plt"); //e1599plt1.asm
	var seq = parseInt(pltNames[1].slice(0,1));
	//alert ("seq="+seq);
	
	//test to MYSQL
	var allSeqs;
	var allSTANames;
	var staMadeCount=0

	//alert ("tableIndex="+tableIndex);
	
	for (w = 0; w < tableIndex; w++){ //dont use n s t
		//alert ("w="+w);
		index = index+1;
		inputField = "ALL_SET__STA_CSY"+index;
		staName = document.getElementById(inputField).value.toLowerCase();
		newNameHistoryArr.push ("ArrStart"); //initial
		//alert ("staName="+staName);
		checkField = "SET__STA"+index;
		//alert ("checkField="+checkField);
		isSetSTA = document.getElementById(checkField).checked;
		//alert ("isSetSTA="+isSetSTA);
		inputField2 = "SAT_NUM"+index;

		if (staName=="na" || isSetSTA==false){
			//alert ("na");
			//do nothing
		} else {
			staMadeCount = staMadeCount + 1; //�Ĥ@�Ӱ������@�windex=1
			if (staMadeCount==1){
				allSTANames =GetStaCH(staName.toUpperCase());
				allSeqs = document.getElementById(inputField2).value;
			} else {
				allSTANames = allSTANames + "~" + GetStaCH(staName.toUpperCase());
				allSeqs = allSeqs + "~" + document.getElementById(inputField2).value;
			}

			
			alert ("getTemplate("+moldNo+","+seq+","+staName+")");
			getTemplate(moldNo,seq,staName,"prtTempNumber");
			alert ("generate");
			generate();
			//store array
			newNameHistoryArr = newNameHistoryArr.concat(newNameArr); //�P�_�Ĭ��
			
			//�ո�
			var hDll = session.LoadProToolkitDll("AssemblyByCSYS-callee","D:/PTC/5220_CREO_STD/18_toolkit/4946/AssemblyByCSYS-callee.dll","D:/PTC/5220_CREO_STD/18_toolkit/4946", true);
		
			var SArgValue1 = pfcCreate ("MpfcArgument").CreateStringArgValue(inputField);
			var SArgument1 = pfcCreate ("pfcArgument").Create ("PLT_CSY",SArgValue1);
		
			var SArgValue2 = pfcCreate ("MpfcArgument").CreateStringArgValue(newNameArr[0]);
			var SArgument2 = pfcCreate ("pfcArgument").Create ("STA_MDL",SArgValue2);
			
			var StaCsy = GetStaCsy(staName);
			
			var SArgValue3 = pfcCreate ("MpfcArgument").CreateStringArgValue(StaCsy);
			var SArgument3 = pfcCreate ("pfcArgument").Create ("STA_CSY",SArgValue3);
			
			var SArgValue4 = pfcCreate ("MpfcArgument").CreateStringArgValue(lastStaName);
			var SArgument4 = pfcCreate ("pfcArgument").Create ("LAST_STA_MDL",SArgValue4);
			
			var SArguments = pfcCreate ("pfcArguments");
			
			SArguments.Append (SArgument1);
			SArguments.Append (SArgument2);
			SArguments.Append (SArgument3);
			SArguments.Append (SArgument4);
			alert ("�ո�:"+inputField+","+newNameArr[0]+","+StaCsy+","+lastStaName);
			var result = hDll.ExecuteFunction("AssemblyByCSYS",SArguments);
			alert ("FunctionReturn="+result.FunctionReturn);
			hDll.Unload();
			
			lastStaName = newNameArr[0].toUpperCase();
			//clear the array
			oldNameArr.length = 0;
			newNameArr.length = 0;
			commonNameArr.length = 0;
			drwOldNameArr.length = 0;
			drwNewNameArr.length = 0;
			drwCommonNameArr.length = 0;
			urlArr.length = 0;
			actionArr.length = 0;
			parentArr.length = 0;
		}
	}
	document.getElementById("plateSeq").value = seq;
	document.getElementById("allSeqs").value = allSeqs;
	document.getElementById("allSTANames").value = allSTANames;
	alert ("step2����");
	document.getElementById("idButton3").style.display="";
}

function step3(){
	var session = pfcGetProESession();
	
	var hDll = session.LoadProToolkitDll("SDI","D:/PTC/5220_CREO_STD/18_toolkit/6908/SDI.dll","D:/PTC/5220_CREO_STD/18_toolkit/6908", true);
	var SArguments = pfcCreate ("pfcArguments");
	var result = hDll.ExecuteFunction("DllReplaceMoldID",SArguments);
	alert ("FunctionReturn="+result.FunctionReturn);
	
	hDll.Unload();

	//document.getElementById("idButton4").style.display="";
	//document.getElementById("h3step4").style.display="";
}

function step4(){
	var session = pfcGetProESession();
	var part = session.CurrentModel;
	var pltName = part.FileName;
	var moldNo = pltName.slice(0,5);
	//alert ("moldNo"+moldNo);
	
	var allMdls = session.ListModels();
	
	document.getElementById("setParamMdlTable").style.display="";
	var table = document.getElementById("setParamMdlTable");
	var index = 0;
	var c0 = null;
	
	//alert ("allMdls Count: "+allMdls.Count);
	var YN_PRG_CHG_ID;
	
	for (m = 0; m < allMdls.Count; m++){
		var mdlName = allMdls.Item(m).FileName;
		//alert ("mdlName"+mdlName);
		if (mdlName.indexOf(moldNo)==0){
			//alert ("same moldNo");
			if (allMdls.Item(m).GetParam("YN_PRG_CHG_ID")!=null){
				//alert ("got YN_PRG_CHG_ID");
				YN_PRG_CHG_ID = allMdls.Item(m).GetParam("YN_PRG_CHG_ID").Value.StringValue;
				
				if (YN_PRG_CHG_ID=="Y"){
					//alert ("YN_PRG_CHG_ID=Y");
					var row = table.insertRow(index);

					c0 = row.insertCell(0);

					//set style
					c0.className = 'member_new_style10';

					// Add text to the new cells:
					c0.innerHTML = "<input type=button value='"+mdlName+"' id=button4 name=button4 onclick='openMdl(this.value)'>";
					index = index + 1;
				}
			}
		}
	}
}
//NewModel---------------------------------------------
//���o�d���Ψ��T
function getTemplate (moldNo,seq,tempNumber,tempType){
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
		//var tempNumber = document.getElementById(tempType).value.toLowerCase();
		//alert( "tempNumber="+tempNumber);
		var mdlDescr = pfcCreate ("pfcModelDescriptor").CreateFromFileName (tempNumber);
		var topMdl = session.RetrieveModel(mdlDescr);
		//alert( "topMdl got 20210421");
		//user input
		//var moldNo = document.getElementById("moldNo").value.toLowerCase(); //PLM�ɦW
		//var seq = document.getElementById("seq").value;
		
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
		
		//�C�X�è��o�u�{�� "�O�d"�����|���u�{��
		listDrws(session);
		//alert ("drwOldNameArr="+drwOldNameArr);
		//���s�R�W
		renameComponents(moldNo,seq,tempNumber,tempType);
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
		//alert ("urlArr="+urlArr);
		//�ˬd���eSTA�s�դW�ǽĬ� ListFiles
		//alert ("check");
		for (s = 0; s < newNameArr.length; s++){
			if (actionArr[s]=="�s��"){
				var nameThis = newNameArr[s];
				for (t = 0; t < newNameHistoryArr.length; t++){
					if (nameThis==newNameHistoryArr[t]){
						nameThis = addComponentSeq(nameThis);
					}
				}
				newNameArr[s] = nameThis;
			}
		}
		//alert ("newNameArr="+newNameArr);
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
		//alert ("newNameArr="+newNameArr);
		//��ܲM��  ���s�R�W�u�{��
		//alert ("displayModelTable");
		for (m = 0; m < oldNameArr.length; m++){
			var searchName = oldNameArr[m].replace(".prt", '');
			searchName = searchName.replace(".asm", '');
			var drwNewName = "NA"; //�S���u�{�Ϫ��|���NA
			var drwCommonName = "NA";
			var drwIndex=-1;
			for (f = 0; f < drwOldNameArr.length; f++){
				if (drwOldNameArr[f].indexOf(searchName)==0){
					drwNewNameArr[f] = newNameArr[m].replace(".prt", ".drw");
					drwNewNameArr[f] = drwNewNameArr[f].replace(".asm", ".drw");
					drwCommonNameArr[f] = commonNameArr[m]+"�u�{��";
					drwNewName = drwNewNameArr[f];
					drwCommonName = drwCommonNameArr[f];
					drwIndex = f;
					break;
				}
			}
		
			//displayModelTable(oldNameArr[m],actionArr[m],newNameArr[m],commonNameArr[m],drwNewName,drwCommonName,urlArr[m],m,drwIndex);
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
		if (oldNameArr[s].indexOf("_")==-1 && actionArr[s].indexOf("�O�d")==-1){ //�ư��ɦW��_�� "�O�d"��
			var oldName = oldNameArr[s].replace(".prt", ".drw");
			var oldName = oldName.replace(".asm", ".drw");
			//alert ("listDrws to get:"+oldName);
			try {
				var mdlDescr = pfcCreate ("pfcModelDescriptor").CreateFromFileName (oldName);
				drwMdl = session.RetrieveModel(mdlDescr);
				//alert ("drwOldNameArr="+drwMdl.FileName);
				drwOldNameArr.push (drwMdl.FileName); //1st item
				drwNewNameArr.push ("NA"); //initial
				drwCommonNameArr.push ("NA"); //initial
			} catch(err){ //asm�ɦp�G�䤣��۹�����drw�N���L
				/*
				if (pfcGetExceptionType(err).indexOf("PRO_TK_E_NOT_FOUND")==0 || pfcGetExceptionType(err).indexOf("pfcXToolkitNotFound")==0) {
					alert ("�䤣���ɮ�: "+oldName);
				} else {
					alert ("listDrws Exception occurred: "+pfcGetExceptionType(err));
				}
				*/
				continue;
			}
		}
	}
	
}

function renameComponents (moldNo,seq,tempNumber,tempType){
		for (n = 0; n < oldNameArr.length; n++){ //MODEL
			//alert ("oldNameArr="+oldNameArr[n]);
			var newName = oldNameArr[n].replace("exxxx", moldNo);
			if (tempType=="asmTempNumber" || tempType=="prtTempNumber"){
				if (oldNameArr[n].indexOf("sta")>0){
					newName = newName.replace("sta1", "sta"+seq);
				} else {
					newName = newName.replace("10", seq+"0");
					newName = newName.replace("20", seq+"0");
				}
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
			actionArr.push (actionTemp);
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
			if (gotGNames.length>2){
				for (h = 2; h < gotGNames.length; h++){
					gotFName1 = gotFName1 + "-" + gotGNames[h];
				}
			}
		}
		
		if (Number.isInteger(seq)){
			seq = seq + 1;
		} else {
			seq = seq; //seqStr?
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
}

function displayModelPic(templateNumber){
	//alert ("displayPic:"+templateNumber);
	//�`�N ��������
	window.top.frames["modelFrame"].location.href = "http://sdiplm11.sdi.com.tw/Windchill/netmarkets/jsp/dns/viewCreoTemplate.jsp?templateNumber="+templateNumber;
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
		var actServ = session.GetActiveServer();
		
		//reloadNames(); //���o�ϥΪ̳̫�input���W��
		//alert ("reloadNames oldNameArr="+oldNameArr);

		for (m = 0; m < oldNameArr.length; m++){
			//alert ("now on:"+oldNameArr[m]);
			var tempMdl = null;
			if (actionArr[m]=="�s��" && newNameArr[m]!=oldNameArr[m]){
				if (oldNameArr[m].indexOf("asm")>0){
					tempMdl = session.GetModel(oldNameArr[m],pfcCreate ("pfcModelType").MDL_ASSEMBLY);
				}
				if (oldNameArr[m].indexOf("prt")>0){
					tempMdl = session.GetModel(oldNameArr[m],pfcCreate ("pfcModelType").MDL_PART);
				}
				tempMdl.Rename(newNameArr[m],true);
			}
			//�O�d do nothing
			if (actionArr[m]=="�R��"){
				deleteModel(m); //rename�e�R��
			}
		}

		//Save
		alert ("�ǳ��x�s"+newNameArr[0]);
		var newMdl = session.GetModel(newNameArr[0],pfcCreate ("pfcModelType").MDL_ASSEMBLY);
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
	}
	catch(err){
		if (pfcGetExceptionType(err).indexOf("PRO_TK_CHECKOUT_CONFLICT")==0 || pfcGetExceptionType(err).indexOf("pfcXToolkitCheckoutConflict")==0){
			alert ("�ɦW�Ĭ�: "+newNameArr[0]);
		} else {
			alert ("Exception occurred: "+pfcGetExceptionType(err));
		}
	}

		//Rename DRW
		for (n = 0; n < drwOldNameArr.length; n++){
			//alert ("now on:"+drwOldNameArr[n]);
			try {
			var tempMdl = null;
			if (drwNewNameArr[n]=="NA"){
				//do nothing
			} else {
				tempMdl = session.GetModel(drwOldNameArr[n],pfcCreate ("pfcModelType").MDL_DRAWING);
				tempMdl.Rename(drwNewNameArr[n],true);
				if (tempMdl.IsCommonNameModifiable()){
					tempMdl.CommonName = drwCommonNameArr[n];
				}
				tempMdl.Save();
				actServ.UploadObjects(tempMdl);
			}
			
			} catch (err) {
				if (pfcGetExceptionType(err).indexOf("PRO_TK_CHECKOUT_CONFLICT")==0 || pfcGetExceptionType(err).indexOf("pfcXToolkitCheckoutConflict")==0){
					alert ("�ɦW�Ĭ�: "+drwNewNameArr[n]);
				} else if (pfcGetExceptionType(err).indexOf("PRO_TK_E_NOT_FOUND")==0 || pfcGetExceptionType(err).indexOf("pfcXToolkitNotFound")==0) {
					alert ("�䤣���ɮ�: "+drwOldNameArr[n]);
				} else {
					alert ("Exception occurred: "+pfcGetExceptionType(err));
				}
				continue;
			}
		}

		alert ("�w�W��");

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
	for (m = 0; m < newNameArr.length; m++){
		var newNameInputField = "newNumber"+m;
		newNameArr[m] = document.getElementById(newNameInputField).value.toLowerCase();
		//alert (newNameInputField+"="+document.getElementById(newNameInputField).value.toLowerCase());
	}
	
	for (n = 0; n < drwNewNameArr.length; n++){
		var newDrwNameInputField = "drwNewNumber"+n;
		drwNewNameArr[n] = document.getElementById(newDrwNameInputField).value.toLowerCase();
		
		var newDrwComNameInputField = "drwCommonName"+n;
		drwCommonNameArr[n] = document.getElementById(newDrwComNameInputField).value;
	}
}

//�}���ɮצܵ���
function openMdl (setMdlName){
	try {
		var session = pfcGetProESession();
		
		var mdlDescr = pfcCreate ("pfcModelDescriptor").CreateFromFileName (setMdlName);
		var setMdl = session.RetrieveModel(mdlDescr);
		
		setMdl.Display();
		var newMdlWin = session.GetModelWindow(setMdl);
		newMdlWin.Activate();
		//alert ("openMdl done");
		var hDll = session.LoadProToolkitDll("SDI_main3","D:/PTC/5220_CREO_STD/18_toolkit/6525/SDI_main3.dll","D:/PTC/5220_CREO_STD/18_toolkit/6525", false);
		var SArguments = pfcCreate ("pfcArguments");
		var result = hDll.ExecuteFunction("DllParamGeneralSet",SArguments);
		
		alert ("FunctionReturn="+result.FunctionReturn);
	}
	catch(err){	alert ("Exception occurred: "+pfcGetExceptionType(err)); }
}

function cancel (){
	window.location.href = "NewModel.html";
}

function newSTA (){
	window.location.href = "NewSTA.html";
}

function GetStaCsy(tempName)
{
var asms = ["exxxxsta1_1-fk", "exxxxsta1_1-bft-yg", "exxxxsta1_1", "exxxxsta1_1-cyyg", "exxxxsta1_1-cyng"];
var csys = ["CS0_STA-FK_ASM", "CS0_BFT_YG", "CS0_STA_ASM", "CS0_CYYG_ASM", "CS0_CYNG_ASM"];

tempName = tempName.replace(".asm", "");
var cName = "NA";

for (n = 0; n < asms.length; n++){
	//alert (tempName+"-VS-"+asms[n]);
	if (tempName==asms[n]){
		cName = csys[n];
	}
}

return cName;
}

function GetStaEN(chName)
{
var enName = "NA";

for (n = 0; n < chArr.length; n++){
	if (chName==chArr[n]){
		enName = enArr[n];
	}
}

return enName;
}

function GetStaCH(enName)
{
var chName = "NA";

for (g = 0; g < enArr.length; g++){
	if (enName==enArr[g]){
		chName = chURLArr[g];
	}
}

return chName;
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
String setMdlName = request.getParameter("moldName");
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
    <h3>Step 1 Ū��<%= setMdlName %>�y�Шt�Ѽ�
	</h3>
	</td>
	<td>
    <h3>
	<input type=button value="Ū��" id="button1" name="button1" onclick="step1('<%= setMdlName %>')">
	</h3>
	</td>
</tr>
<tr>
  <td>
	<h3>Step 2 �հt�u�{����PLT
	</h3>
  </td>
  <td>
	<table id="inputParamTable" border=1 cellspacing=0 cellpadding=0 width="100%" style='width:100.0%;
		border-collapse:collapse;border:none;mso-border-alt:solid windowtext .5pt;
		mso-padding-alt:0in 5.4pt 0in 5.4pt; display: none'>
		 <tr>
			<td colspan="2">
			<input type=button value="START" id="button2" name="button2" style="width:150px;height:30px;" onclick="step2()">
			<input type="hidden" name="plateSeq" id="plateSeq" value="NA"/>
			<input type="hidden" name="allSeqs" id="allSeqs" value="NA"/>
			<input type="hidden" name="allSTANames" id="allSTANames" value="NA"/>
			</td>
		 </tr>
	</table>
  </td>
</tr>
<tr>
  <td>
    <h3>Step 3 ID����
	</h3>
  </td>
  <td>
    <h3>
	<p id="idButton3" style="display: none">
	<input type=button value="START" id="button3" name="button3" onclick="step3()">
	</p>
	</h3>
  </td>
</tr>
<tr>
  <td>
    <h3 id="h3step4" style="display: none">Step 4 �Ѽƿ�J
	</h3>
  </td>
  <td>
	<h3>
	<p id="idButton4" style="display: none">
	<input type=button value="START" id="button4" name="button4" onclick="step4()">
	</p>
	</h3>
  	<table id="setParamMdlTable" border=1 cellspacing=0 cellpadding=0 width="100%" style='width:100.0%;
		border-collapse:collapse;border:none;mso-border-alt:solid windowtext .5pt;
		mso-padding-alt:0in 5.4pt 0in 5.4pt; display: none'>
	</table>
  </td>
</tr>

</table>
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