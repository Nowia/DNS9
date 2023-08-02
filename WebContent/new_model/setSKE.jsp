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
function openMdl (){ //setMdlName
	try {
		var session = pfcGetProESession();
		
		//var mdlDescr = pfcCreate ("pfcModelDescriptor").CreateFromFileName (setMdlName);
		//var setMdl = session.RetrieveModel(mdlDescr);
		
		//setMdl.Display();
		//var newMdlWin = session.GetModelWindow(setMdl);
		//newMdlWin.Activate();
		//alert ("openMdl done");
		
		//var dirName = session.GetCurrentDirectory();
		//session.ChangeDirectory("D:/creo_work/18_toolkit/6525/");
		//alert ("ChangeDirectory");
		//執行DLL
		
		var hDll = session.LoadProToolkitDll("SDI_main3","D:/PTC/5220_CREO_STD/18_toolkit/6525/SDI_main3.dll","D:/PTC/5220_CREO_STD/18_toolkit/6525", false);
		var SArguments = pfcCreate ("pfcArguments");
		var result = hDll.ExecuteFunction("DllParamPltPlnSkeSet",SArguments);
		
		//var SDI_main3 = session.LoadProToolkitDll("SDI_main3", "./SDI_main3.dll", "./", true);
		//var InputArguments = new ActiveXObject("pfc.pfcArguments");
		//var DllParamDataSet = SDI_main3.ExecuteFunction("DllParamDataSet", InputArguments);
		//SDI_main3.Unload();
		
		alert ("FunctionReturn="+result.FunctionReturn);
		//hDll.Unload();
		//session.ChangeDirectory(dirName);
	}
	catch(err){	alert ("Exception occurred: "+pfcGetExceptionType(err)); }
}

</script>
<body link=blue vlink=purple style='tab-interval:.5in'>

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
	<input type=button value="設定骨架參數" id="set" name="set" onclick="openMdl()">
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