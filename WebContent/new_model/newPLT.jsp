<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<link href="../css/mm_restaurant1.css" media="screen" rel="stylesheet" type="text/css" />
<link href="../css/form.css" media="screen" rel="stylesheet" type="text/css" />
<title>�إ߼ҪO�ե�</title>
</head>

<script src="../jscript/pfcUtils.js">
</script>
<script language="JavaScript">
//�����ܼƥi�QNewModel.js�I�s
var PLT_QTY;
var removeMdlNames;

function saveAsPLT(setMdlName){
	//alert("setMdlName="+setMdlName);
	//openMdl(setMdlName);
	step1();
	if (PLT_QTY<4){
		step2();
	}
}

function step1(){
      if (pfcIsMozilla())
        netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");

	try {
		var session = pfcGetProESession();
		var part = session.CurrentModel;
		
		var PLT_QTY_str = part.GetParam("PLT_QTY").Value.StringValue;
		PLT_QTY = parseInt(PLT_QTY_str, 10);
		alert ("PLT_QTY: "+PLT_QTY);
	}
	catch(err){	alert ("Exception occurred: "+pfcGetExceptionType(err)); }
}

function step2(){
	var session = pfcGetProESession();
	var actServ = session.GetActiveServer();
	
	var topMdl = session.CurrentModel;
	var asmName = topMdl.FileName;
	
	var pltName;
	var moldNo = asmName.slice(0,5);
	var delFeatName;
	var delMdlName;
	
	removeMdlNames = pfcCreate ("stringseq");
	
	alert ("�ܧ�պA");
	//�ܧ�պA �~�����
	session.SetConfigOption("save_objects","changed_and_specified");
	
	for (y = PLT_QTY+1; y <= 4; y++){
		//alert ("y="+y);
		//delFeatName=moldNo.toUpperCase()+"PLT"+y+".ASM";
		delMdlName=moldNo.toLowerCase()+"plt"+y+".asm";

		var delResult = deleteFeat(topMdl,delMdlName);
		//alert ("delResult="+delResult);
		if (delResult=="Done"){
			//alert ("Append start");
			removeMdlNames.Append(delMdlName); //����R���u�@���ɮ�
			alert ("�[�J�R���M��"+delMdlName);
			var mdlDescr = pfcCreate ("pfcModelDescriptor").CreateFromFileName (delMdlName);
			var delMdl = session.RetrieveModel(mdlDescr);
			addDelComponents(session,delMdl);
		}
	}
	alert ("�x�s"+asmName);
	topMdl.Save(); //���s�ɤ~��q�u�@�Ϥ��R��
	alert ("�W��"+asmName);
	actServ.UploadObjects(topMdl); //���W���~��q�u�@�Ϥ��R��
	
	
	//�u�{�϶}�� �A�� �x�s�W��
	//e1780asm.drw
	var drwName = moldNo.toLowerCase()+"asm.drw";
	openMdl(drwName);
	session.RunMacro ("~ Command `ProCmdRegenPart` ;~ Command `ProCmdViewRepaint`;");
	var drwMdl = session.CurrentModel;
	drwMdl.Save(); //���s�ɤ~��q�u�@�Ϥ��R��
	actServ.UploadObjects(drwMdl);
	
	//e1780_pre_trans_ske.drw
	drwName = moldNo.toLowerCase()+"_pre_trans_ske.drw";
	openMdl(drwName);
	session.RunMacro ("~ Command `ProCmdRegenPart` ;~ Command `ProCmdViewRepaint`;");
	drwMdl = session.CurrentModel;
	drwMdl.Save(); //���s�ɤ~��q�u�@�Ϥ��R��
	actServ.UploadObjects(drwMdl);
	
	//�q�u�@�Ϥ��R��
	alert ("�q�u�@�Ϥ��R��, �ƶq:"+removeMdlNames.Count);
	if (removeMdlNames.Count>0){
		actServ.RemoveObjects(removeMdlNames);
		alert ("�u�@�Ϥw�R��, �ƶq:"+removeMdlNames.Count);
	}
	
	//��_�w�]�պA
	alert ("��_�պA");
	session.SetConfigOption("save_objects","changed_and_updated");
}

function deleteFeat (parentMdl,deleteItem){
	var result = null;
	try {
	    var session = pfcGetProESession();
		//�L�k��EraseWithDependencies()�R�� �u��q�W�h�ե�R���S�x
		
		var components = parentMdl.ListFeaturesByType (true,pfcCreate ("pfcFeatureType").FEATTYPE_COMPONENT);
		//alert ("components.Count:"+components.Count);
		//�M��n�R�����ե�S�x
		var deleteComp = "NA";
		for (k = 0; k < components.Count; k++){
			var component = components.Item(k);
			var desc = component.ModelDescr;
			var cmdl = session.RetrieveModel(desc);
			//alert (cmdl.FileName+" vs "+deleteItem);
			if (cmdl.FileName==deleteItem){
				deleteComp = component;
				alert ("Got:"+deleteComp);
			}
		}

		//����R��
		if (deleteComp=="NA"){
			alert ("Invalid Target");
			result = "Invalid Target";
		} else {
			var delOp = deleteComp.CreateDeleteOp(); //delOp.Clip �w�]���R�������S�x
			var FeatOps = pfcCreate ("pfcFeatureOperations");
			FeatOps.Append(delOp);
			session.SetConfigOption("regen_failure_handling","resolve_mode");
			parentMdl.ExecuteFeatureOps(FeatOps,null);
			parentMdl.Regenerate(null);
			session.SetConfigOption("regen_failure_handling","no_resolve_mode");
			result = "Done";
			alert (result);
		}
	}
	catch(err){
		alert ("Exception occurred: "+pfcGetExceptionType(err));
		result = "Error";
	}
	finally {
		return result;
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
	}
	catch(err){	alert ("Exception occurred: "+pfcGetExceptionType(err)); }
}

function cancel (){
	window.location.href = "NewModel.html";
}

//���o�ե�U������
function addDelComponents (session,mdl){
	try {
	var components = mdl.ListFeaturesByType (true,pfcCreate ("pfcFeatureType").FEATTYPE_COMPONENT);
	//alert ("components.Count="+components.Count);
	for (k = 0; k < components.Count; k++){
		var component = components.Item(k);
		var desc = component.ModelDescr;
		var cmdl = session.RetrieveModel(desc);
		removeMdlNames.Append(cmdl.FileName);
		alert ("�[�J�R���M��"+cmdl.FileName);
		if (cmdl.FileName.indexOf("prt")!=-1){
			if (cmdl.FileName.indexOf("ske")==-1){
				var drwName = cmdl.FileName.replace(".prt", '.drw');
				removeMdlNames.Append(drwName);
				alert ("�[�J�R���M��"+drwName);
			}
		}
		if (cmdl.FileName.indexOf("asm")!=-1){
			var k_temp = k; //k�|�Qrecursive�{���ﱼ �n�p��
			var count = addDelComponents(session,cmdl); //recursive
			k = k_temp; //restore
		}
		//alert (cmdl.FileName+"Done"+k);
	}
	}
	catch(err){	alert ("Exception occurred: "+pfcGetExceptionType(err)); }
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
String moldNO =  request.getParameter("moldNO");
String setMdlName = moldNO + ".asm";
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
    <h3>&nbsp;
	</h3>
	</td>
	<td>
    <h3>
	<input type=button value="�t�s�ҪO�ե�" id=button1 name=button1 onclick="saveAsPLT('<%= setMdlName %>')">
	</h3>
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

	<tr>
	<td>&nbsp;</td>
	<td height="1" colspan="3" id="navigation" class="navText" align="right">Copyright &copy; SDI Corporation<br>
	Last Updated 2022/3/4 14:54</td>
	</tr>
</table>
</div>

</body>
</html>