//套用模板夾板規格
function MatchPLTSize()
{

	var session = pfcGetProESession();

	try{
		session.RunMacro("~ Command `cmd_MatchPLTSize`");
		
	}catch(err){
		alert("MatchPLTSize() Error!");
	}

}

//編輯模板規格  
function RedefinePLTSize()
{

	var session = pfcGetProESession();

	try{
		session.RunMacro("~ Command `cmd_RedefinePLTSize`");
		
	}catch(err){
		alert("RedefinePLTSize() Error!");
	}

}

//編輯夾板規格
function RedefineSDSize()
{

	var session = pfcGetProESession();

	try{
		session.RunMacro("~ Command `cmd_RedefineSDSize`");
		
	}catch(err){
		alert("RedefineSDSize() Error!");
	}

}

//組裝料條	  
function AssembleLYT()
{

	var session = pfcGetProESession();

	try{
		session.RunMacro("~ Command `cmd_AssembleLYT`");
		
	}catch(err){
		alert("AssembleLYT() Error!");
	}

}

//重合材料寬度
function ReplaceMatWRef()
{

	var session = pfcGetProESession();

	try{
		session.RunMacro("~ Command `cmd_ReplaceMatWRef`");
		
	}catch(err){
		alert("ReplaceMatWRef() Error!");
	}

}

//修改重合位置
function RedefineMatW()
{

	var session = pfcGetProESession();

	try{
		session.RunMacro("~ Command `cmd_RedefineMatW`");
		
	}catch(err){
		alert("RedefineMatW() Error!");
	}

}

//讀取工程站曲線
function SetStripCsys()
{
	var session = pfcGetProESession();

	try{
		session.RunMacro("~ Command `cmd_SetStripCsys`");
		
	}catch(err){
		alert("SetStripCsys() Error!");
	}
}

//重合組配座標
function ReplacePLTCsysRef()
{
	var session = pfcGetProESession();

	try{
		session.RunMacro("~ Command `cmd_ReplacePLTCsysRef`");
		
	}catch(err){
		alert("ReplacePLTCsysRef() Error!");
	}
}