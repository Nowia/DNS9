<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>設定參數</title>
<link href="../css/mm_restaurant1.css" media="screen" rel="stylesheet" type="text/css" />
<link href="../css/form.css" media="screen" rel="stylesheet" type="text/css" />
</head>
<script src="../js/jquery-3.6.0.min.js"></script>
<script src="../jscript/pfcUtils.js">
</script>
<script language="JavaScript">
//全域變數
var allPunchNamesArr = new Array();

function step1(moldNo,plateSeq,staSeq,staName){
	alert("moldNo="+moldNo);
	//get STA
	var session = pfcGetProESession();
	var mdlDescr = pfcCreate ("pfcModelDescriptor").CreateFromFileName (staName);
	var staMdl = session.RetrieveModel(mdlDescr);
	
	//get all subitem
	var components = staMdl.ListFeaturesByType (true,pfcCreate ("pfcFeatureType").FEATTYPE_COMPONENT);
	
	var CPNameArr = new Array();
	var ACNameArr = new Array();
	var PUNameArr = new Array();
	var APNameArr = new Array();
	
	for (k = 0; k < components.Count; k++){
		var component = components.Item(k);
		var desc = component.ModelDescr;
		var cmdl = session.RetrieveModel(desc);

		if (cmdl.FileName.indexOf("CP")==5){
			var found =false; //使否找到同名的檔案
			if (CPNameArr.length>0){
				for (m = 0; m < CPNameArr.length; m++){
					if (CPNameArr[m].indexOf(cmdl.FileName)==0){
						found=true;
					}
				}
			} else {  //陣列裡沒有元素
				found =false;
			}
			
			if (found==false){
				CPNameArr.push (cmdl.FileName);
			}
		}
		
		if (cmdl.FileName.indexOf("AC")==5){
			ACNameArr.push (cmdl.FileName);
		}
		
		if (cmdl.FileName.indexOf("PU")==5){
			PUNameArr.push (cmdl.FileName);
		}
		
		if (cmdl.FileName.indexOf("AP")==5){
			APNameArr.push (cmdl.FileName);
		}
	}
	
	CPNameArr.sort();
	ACNameArr.sort();
	PUNameArr.sort();
	APNameArr.sort();
	
	//concat array
	allPunchNamesArr = CPNameArr.concat();
	allPunchNamesArr = allPunchNamesArr.concat(ACNameArr);
	allPunchNamesArr = allPunchNamesArr.concat(PUNameArr);
	allPunchNamesArr = allPunchNamesArr.concat(APNameArr);
	
	//table
	document.getElementById("inputParamTable").style.display="";
	var table = document.getElementById("inputParamTable");
	
	var c0 = null;
	var c1 = null;
	var c2 = null;
	
	var index = 0;

	for (m = 0; m < allPunchNamesArr.length; m++){
		index = m+1;
	
		//set table
		var row = table.insertRow(m);

		c0 = row.insertCell(0);
		c1 = row.insertCell(1);
		c2 = row.insertCell(2);

		//set style
		c0.className = 'member_new_style11';
		c1.className = 'member_new_style10';
		c2.className = 'member_new_style10';

		// Add text to the new cells:
		c0.innerHTML = index;
		c1.innerHTML = allPunchNamesArr[m];
		c2.innerHTML = "<input type=button value='參數' id='"+allPunchNamesArr[m]+"' name='"+allPunchNamesArr[m]+"' onclick='setParameter('"+m+"')'>";
	}
}

function setParameter(punchSeq){
	openMdl(allPunchNamesArr[punchSeq]);
	
	var session = pfcGetProESession();
	
	var hDll = session.LoadProToolkitDll("SDI","D:/PTC/5220_CREO_STD/18_toolkit/6908/SDI.dll","D:/PTC/5220_CREO_STD/18_toolkit/6908", true);
	var SArguments = pfcCreate ("pfcArguments");
	var result = hDll.ExecuteFunction("DllReplaceMoldID",SArguments);
	alert ("FunctionReturn="+result.FunctionReturn);
	
	hDll.Unload();

	document.getElementById(allPunchNamesArr[punchSeq-1]).style.display="";
	
	//組裝----------------------------------------------------------------------------
			var hDll = session.LoadProToolkitDll("AssemblyByCSYS-callee","D:/PTC/5220_CREO_STD/18_toolkit/4946/AssemblyByCSYS-callee.dll","D:/PTC/5220_CREO_STD/18_toolkit/4946", true);
		
			var SArgValue1 = pfcCreate ("MpfcArgument").CreateStringArgValue("檔名");
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

			var result = hDll.ExecuteFunction("AssemblyByCSYS",SArguments);
			alert ("FunctionReturn="+result.FunctionReturn);
			hDll.Unload();
}

//開啟檔案至視窗啟動
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


</script>

<body link=blue vlink=purple style='tab-interval:.5in'>
<%
request.setCharacterEncoding("UTF-8");
String moldNo = request.getParameter("moldNo"); //模具編號
String plateSeq = request.getParameter("plateSeq"); //模板序
String staSeq = request.getParameter("staSeq"); //工程站序
String staName = request.getParameter("staName"); //工程站檔案名稱
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
		<input type=button value="設定參數" id="button1" name="button1" onclick="step1('<%= moldNo %>','<%= plateSeq %>','<%= staSeq %>','<%= staName %>')">
	</td>
	<td>
    <h3>
	</h3>
	</td>
</tr>
<tr>
  <td>
	<h3>
	</h3>
  </td>
  <td>
	<table id="inputParamTable" border=1 cellspacing=0 cellpadding=0 width="100%" style='width:100.0%;
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