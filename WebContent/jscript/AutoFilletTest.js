  //var MdlSurface = part.ListItems(pfcCreate("pfcModelItemType").ITEM_SURFACE);  
  //pfcSurface.ListContours()
  //pfcContour.ListElements()
  //CreateModelItemSelection
  //pfcBaseSession.RunMacro()
  
  //找到位移曲面
  //刪掉該曲面底下的R角
  //辨識邊向量 找到平行的邊
  //靠邊選鄰面 做R角  
  
//initialize------------------------------------------
var CS0_ZMAX = 10000; //max Z axis

//get all edges directly
function listEdges()
{
  if (pfcIsMozilla())
    netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");

  var session = pfcGetProESession ();
  var part = session.CurrentModel; 
  
  if (part == void null || part.Type != pfcCreate("pfcModelType").MDL_PART){
	alert("Current model is not an part.");
  }

  var edgeArray = part.ListItems(pfcCreate("pfcModelItemType").ITEM_EDGE);
  
  alert(edgeArray.Count);
  
   for(var i=0;i<edgeArray.Count;i++){
	   //alert(i + ":" + edgeArray.Item(i).GetName());
	   alert(i + ":" + edgeArray.Item(i).EvalLength());
   }
}

//geometry data-------------------------------------------------------------------------------
function contourData(session)
{
  if (pfcIsMozilla())
    netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");

  var part = session.CurrentModel;
  
  if (part == void null || part.Type != pfcCreate("pfcModelType").MDL_PART){
	alert("Current model is not an part.");
  }
  
  var surfaceArray = part.ListItems(pfcCreate("pfcModelItemType").ITEM_SURFACE);
  var contourDataArray = new Array ();
  
  alert("surface number = " + surfaceArray.Count);
  
  for(var i=0;i<surfaceArray.Count;i++){
	  //alert("surface" + i + "=" + surfaceArray.Item(i).id);
	  var contourArray = surfaceArray.Item(i).ListContours();
	  for(var k=0;k<contourArray.Count;k++){
		  //alert("contour" + i + "_" + k);
		  var edgeArray = contourArray.Item(k).ListElements();
		  var contourData = "contour" + i + "_" + k + "=";
		  for(var m=0;m<edgeArray.Count;m++){
			  //alert("edge" + i + "_" + k+ "_" + m + "=" + edgeArray.Item(m).EvalLength());
			  var contourData = contourData + "_" + edgeArray.Item(m).EvalLength();
		  }		  
		  //alert(contourData);
		  contourDataArray.push (contourData);
	  }
  }
  
  return contourDataArray;
}

function surfaceData(session)
{
  if (pfcIsMozilla())
    netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");

  var part = session.CurrentModel;
  
  if (part == void null || part.Type != pfcCreate("pfcModelType").MDL_PART){
	alert("Current model is not an part.");
  }
  
  var surfaceArray = part.ListItems(pfcCreate("pfcModelItemType").ITEM_SURFACE);
  alert("surface number = " + surfaceArray.Count);
  
  for(var i=0;i<surfaceArray.Count;i++){
	  var sType = surfaceArray.Item(i).GetSurfaceType();
	  if (sType == pfcCreate("pfcSurfaceType").SURFACE_PLANE){ alert("Plane get"); }
	  var sSurfaces = surfaceArray.Item(i).ListSameSurfaces();
	  alert("sSurfaces number ="+sSurfaces.Count);
	  var sArea = surfaceArray.Item(i).EvalArea();
	  alert("sArea ="+sArea);
  }
}

function edgeData(session)
{
  if (pfcIsMozilla())
    netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
  
  var part = session.CurrentModel; 
  
  if (part == void null || part.Type != pfcCreate("pfcModelType").MDL_PART){
	alert("Current model is not an part.");
  }
  
  var surfaceArray = part.ListItems(pfcCreate("pfcModelItemType").ITEM_SURFACE);
  
  alert("surface number = " + surfaceArray.Count);
  
  for(var i=0;i<surfaceArray.Count;i++){
	  var contourArray = surfaceArray.Item(i).ListContours();
	  for(var k=0;k<contourArray.Count;k++){
		  var edgeArray = contourArray.Item(k).ListElements();
	  }
  }
  
  return edgeArray;
}


//用contourData找符合條件的底面
//pfcSurface.ListSameSurfaces取鄰近面
//用面做round

//punch data-------------------------------------------------------------------------------
function getPunchCutSurface(session)
{
  if (pfcIsMozilla())
    netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");

  var part = session.CurrentModel;
  
  if (part == void null || part.Type != pfcCreate("pfcModelType").MDL_PART){
	alert("Current model is not an part.");
  }

  var punchCutFeat = part.GetItemByName(pfcCreate("pfcModelItemType").ITEM_FEATURE,"CUT_IN_ASM__CUT_SHP_TO_SH_SRF"); //沖剪刃部 CUT_IN_ASM__CUT_GAP_TO_SH_SRF
  alert("got " + punchCutFeat.Id);

  //var edgeArray = punchCutFeat.ListSubItems(pfcCreate("pfcModelItemType").ITEM_EDGE);  //ListSubItems NOT ListItems
  //alert("edgeArray number = " + edgeArray.Count);
  
  var surfaceArray = punchCutFeat.ListSubItems(pfcCreate("pfcModelItemType").ITEM_SURFACE);  //ListSubItems NOT ListItems
  alert("surface number = " + surfaceArray.Count);
  
  /*for(var i=0;i<edgeArray.Count;i++){
	  alert("Id ="+edgeArray.Item(i).Id);
	  doHighLight(edgeArray.Item(i));
  }*/
  
  
  var zLevel = CS0_ZMAX; //initialize
  var sId = "NA"; //initialize
  for(var i=0;i<surfaceArray.Count;i++){  //位移曲面的後面一半才是真的曲面 surfaceArray.Count/2
	  var szLevel = getSurfaceZaxis(surfaceArray.Item(i));
	  var sOri = surfaceArray.Item(i).GetOrientation();
	  alert("NO"+i+"Id ="+surfaceArray.Item(i).Id+" sOri:"+sOri);
	  //if(sOri==2){doHighLight(surfaceArray.Item(i));}
	  doHighLight(surfaceArray.Item(i));
	  if (szLevel<=zLevel && sOri==1){  //get the bottom surface
		  zLevel = szLevel;
		  sId = surfaceArray.Item(i).Id;
		  //doHighLight(surfaceArray.Item(i));
		  //alert("zLevel change to "+zLevel);
	  }
  }
  
  alert("sId ="+sId);
  alert("zLevel ="+zLevel);
  
  var bottomSurface = part.GetItemById(pfcCreate("pfcModelItemType").ITEM_SURFACE,sId);
  doHighLight(bottomSurface);
  //var punchData = getPunchData(bottomSurface); //也許不一定要用到 靠父子關係也可以辨認沖頭
  
  //依據底面取得邊
  var contourArray = bottomSurface.ListContours();
  for(var k=0;k<contourArray.Count;k++){
	  var edgeArray = contourArray.Item(k).ListElements();
		for(var m=0;m<edgeArray.Count;m++){
		  alert("edge" + m );
		  doHighLight(edgeArray.Item(m));
		}
  }
    
  return sSurface;
  
}

//get Z axis number when surface is normal to Z
//預設座標DEFAULT_CSYS的Z軸朝screen 所以CS0座標中Y/Z交換
function getSurfaceZaxis (surfaceItem /* ITEM_FEATURE */){
	var properties = surfaceItem.GetXYZExtents();
	
	var point0 = properties.Item(0);
	var point1 = properties.Item(1);
	
	//alert("point0=" + point0.Item(0).toFixed(1)+","+point0.Item(1).toFixed(1)+","+point0.Item(2).toFixed(1));
	//alert("point1=" + point1.Item(0).toFixed(1)+","+point1.Item(1).toFixed(1)+","+point1.Item(2).toFixed(1));

	var DEF_X = Math.abs(point0.Item(0) - point1.Item(0)).toFixed(1);
	var DEF_Y = Math.abs(point0.Item(1) - point1.Item(1)).toFixed(1);
	var DEF_Z = Math.abs(point0.Item(2) - point1.Item(2)).toFixed(1);

	var level = CS0_ZMAX;
	if (DEF_X!=0 && DEF_Z!=0 && DEF_Y==0) {
		level = point0.Item(1).toFixed(4);
		//alert("got level=" + level);
	} //DEF_Y = CS0_Z
	
	return level;
}

//get surface Orientation: X Y Z or NA
function surfaceOrient (surfaceItem /* ITEM_FEATURE */){
	var properties = surfaceItem.GetXYZExtents();
	
	var point0 = properties.Item(0);
	var point1 = properties.Item(1);
	
	var DEF_X = Math.abs(point0.Item(0) - point1.Item(0)).toFixed(1);
	var DEF_Y = Math.abs(point0.Item(1) - point1.Item(1)).toFixed(1);
	var DEF_Z = Math.abs(point0.Item(2) - point1.Item(2)).toFixed(1);
	
	var or = "NA";
	if (DEF_X == 0) {or = "DEF_X";}
	if (DEF_Y == 0) {or = "DEF_Y";}
	if (DEF_Z == 0) {or = "DEF_Z";}
	
	return or;
}

//get data to recognize punch
function getPunchData (surfaceItem /* ITEM_FEATURE */){
	alert("surfaceItem=" + surfaceItem.Id);
	//initialize contourData
	var contourData = surfaceItem.EvalArea().toFixed(4);
	alert("contourData=" + contourData);
	//write contourData
	var contourArray = surfaceItem.ListContours();
	alert("contourArray number=" + contourArray.Count);
	for(var k=0;k<contourArray.Count;k++){
		var edgeArray = contourArray.Item(k).ListElements();
		alert("edgeArray number=" + edgeArray.Count);
		for(var m=0;m<edgeArray.Count;m++){
			contourData = contourData + "_" + edgeArray.Item(m).EvalLength().toFixed(4);
		}
	}
	alert("getPunchData=" + contourData);
	
	return contourData;
}

//test
function getPunchData2 (surfaceItem /* ITEM_FEATURE */){
	alert("getPunchData2 get" + surfaceItem.Id);
	//initialize contourData	
	var edgeArray = surfaceItem.ListItems(pfcCreate("pfcModelItemType").ITEM_EDGE);
	alert("edge number = " + edgeArray.Count);
}

//macro---------------------------------------------------------------------------------------------------------------------------------
function doOffset (sFeature /* ITEM_FEATURE */,session){
	var cmpPath = void null;  //for input,neccessary
	alert("Offset");
	alert("got " + sFeature.Id);
	//select item
	var sSelection = pfcCreate ("MpfcSelect").CreateModelItemSelection ( sFeature, cmpPath );

	//add to Selection Buffer
	var cBuffer = session.CurrentSelectionBuffer;
	cBuffer.Clear();
	cBuffer.AddSelection(sSelection);
	
	//run macro
	session.RunMacro ("~ Trail `UI Desktop` `UI Desktop` `UIT_TRANSLUCENT` `NEED_TO_CLOSE`;~ Command `ProCmdFtOffset` ;~ Update `main_dlg_cur` `maindashInst0.mru_option_menu` `0.02`;~ Activate `main_dlg_cur` `maindashInst0.mru_option_menu`;~ FocusOut `main_dlg_cur` `maindashInst0.mru_option_menu`;~ Activate `main_dlg_cur` `maindashInst0.Off_Side_Push_Wdg`;~ Activate `main_dlg_cur` `dashInst0.Done`");
	cBuffer.Clear();
}

function doRound (edgeItem /* ITEM_EDGE */,session){
	alert(edgeItem.EvalLength());
	
	var cmpPath = void null;  //for input,neccessary
	
	//select item
	var edgeSelection = pfcCreate ("MpfcSelect").CreateModelItemSelection ( edgeItem, cmpPath );

	//add to Selection Buffer
	var cBuffer = session.CurrentSelectionBuffer;
	cBuffer.Clear();
	cBuffer.AddSelection(edgeSelection);
	
	//run macro
	session.RunMacro ("~ Trail `UI Desktop` `UI Desktop` `UIT_TRANSLUCENT` `NEED_TO_CLOSE`;~ Command `ProCmdRound` ;~ Input `main_dlg_cur` `maindashInst0.cir_rad_list` `0`;~ Input `main_dlg_cur` `maindashInst0.cir_rad_list` `0.`;~ Input `main_dlg_cur` `maindashInst0.cir_rad_list` `0.2`;~ Update `main_dlg_cur` `maindashInst0.cir_rad_list` `0.2`;~ Activate `main_dlg_cur` `maindashInst0.cir_rad_list`; ~ FocusOut `main_dlg_cur` `maindashInst0.cir_rad_list`;~ Activate `main_dlg_cur` `dashInst0.Done`");
	cBuffer.Clear();
}

//HighLight
function doHighLight (sItem /* ITEM_EDGE */,session){
	var cmpPath = void null;  //for input,neccessary
	
	//select item
	var itemSelection = pfcCreate ("MpfcSelect").CreateModelItemSelection ( sItem, cmpPath );
	
	itemSelection.Highlight(pfcCreate ("pfcStdColor").COLOR_DRAWING);
}