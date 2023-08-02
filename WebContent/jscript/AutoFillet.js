//initialize------------------------------------------
var CS0_ZMAX = 10000; //max Z axis
var CS0_ZMIN = -10000; //min Z axis

//計算沖頭總共有幾個邊 應該是3的倍數
function countEdges(session)
{
  var part = session.CurrentModel;

  if (part == void null || part.Type != pfcCreate("pfcModelType").MDL_PART){
	alert("Current model is not an part.");
  }

  var punchCutFeat = part.GetItemByName(pfcCreate("pfcModelItemType").ITEM_FEATURE,"沖剪刃部"); //沖剪刃部 CUT_IN_ASM__CUT_SHP_NO_GAP

  var edgeArray = punchCutFeat.ListSubItems(pfcCreate("pfcModelItemType").ITEM_EDGE);  //ListSubItems NOT ListItems
  
  return edgeArray.Count;
}
//選擇沖頭底面的邊 依使用者順序排列
function selectPUBottomEdges(firstEdgeId /* edge.Id */,session,bottomSurface)
{
	alert("selectPUBottomEdges START2");
  var part = session.CurrentModel;

  if (part == void null || part.Type != pfcCreate("pfcModelType").MDL_PART){
	alert("Current model is not an part.");
  }

  var punchCutFeat = part.GetItemByName(pfcCreate("pfcModelItemType").ITEM_FEATURE,"沖剪刃部");

  var surfaceArray = punchCutFeat.ListSubItems(pfcCreate("pfcModelItemType").ITEM_SURFACE);  //ListSubItems NOT ListItems
  //alert("surface number = " + surfaceArray.Count);

  //找到底面 也許是要找頂面
  var zLevel = CS0_ZMAX; //initialize
  var sId = "NA"; //initialize
  for(var i=0;i<surfaceArray.Count;i++){
	  var szLevel = getSurfaceZaxis(surfaceArray.Item(i));
	  if (szLevel<zLevel){  //get the bottom surface
		  zLevel = szLevel;
		  sId = surfaceArray.Item(i).Id;
	  }
  }
  alert("sId="+sId);
  bottomSurface = part.GetItemById(pfcCreate("pfcModelItemType").ITEM_SURFACE,sId);
  alert("bottomSurface="+bottomSurface.Id);
  doHighLight(bottomSurface);
  
  //依據底面取得邊
  var contourArray = bottomSurface.ListContours();
  for(var k=0;k<contourArray.Count;k++){
	  var edgeArray = contourArray.Item(k).ListElements();
  }
  
  //重新排序
  var reEdgeArray = new Array ();
  var reIndex = -1;
  //find first edge
  for(var i=0;i<edgeArray.Count;i++){
	  if (edgeArray.Item(i).Id==firstEdgeId){
		  //alert("first edge Found");
		  reIndex = i;
	  }
  }
  //reArrange Array
  if (reIndex>=0){
	  for(var i=reIndex;i<edgeArray.Count;i++){
		  reEdgeArray.push (edgeArray.Item(i));
	  }
	  for(var i=0;i<reIndex;i++){
		  reEdgeArray.push (edgeArray.Item(i));
	  }
  } else {
	  alert("你所選的邊沒有在底面上，請重跑程式");
  }
  //test results
  /*
  for(var m=0;m<reEdgeArray.length;m++){
	  alert("reEdgeArray:"+m);
	  doHighLight(reEdgeArray[m]);
  }*/

  //return 3 values
  return {
        reIndex: reIndex,
        reEdgeArray: reEdgeArray
  };
}
//判斷內外R
function defCorner(Edge1 /* ITEM_EDGE */,Edge2 /* ITEM_EDGE */)
{
	  var v1,v2,u1,u2;
	  var cType;
	  //get start and end point
	  var e1SPoint = Edge1.Eval3DData(0).Point;
	  var e1EPoint = Edge1.Eval3DData(1).Point;
	  var e2SPoint = Edge2.Eval3DData(0).Point;
	  var e2EPoint = Edge2.Eval3DData(1).Point;
	  
	  //vector 1
	  v1 = e1SPoint.Item(0) - e1EPoint.Item(0); //CS0_X = DEF_X
	  v2 = -1*(e1SPoint.Item(2) - e1EPoint.Item(2)); //CS0_Y = -DEF_Z
	  //vector 2
	  u1 = e2SPoint.Item(0) - e2EPoint.Item(0); //CS0_X = DEF_X
	  u2 = -1*(e2SPoint.Item(2) - e2EPoint.Item(2)); //CS0_Y = -DEF_Z
	  
	  //外積 取Z方向的向量
	  var s3 = u1*v2-u2*v1;
	  if(s3>0){
		  cType = "內R";
	  } else if(s3<0){
		  cType = "外R";
	  } else {
		  cType = "無轉角";
	  }
	  
	  return cType;
}
//選擇脫襯曲面底面的邊 依使用者順序排列
function selectSHBottomEdges(reIndex,session)
{
  var part = session.CurrentModel;

  if (part == void null || part.Type != pfcCreate("pfcModelType").MDL_PART){
	alert("Current model is not an part.");
  }

  var punchCutFeat = part.GetItemByName(pfcCreate("pfcModelItemType").ITEM_FEATURE,"CUT_IN_PRT__PU_TO_SH_SRF__GAP");

  var surfaceArray = punchCutFeat.ListSubItems(pfcCreate("pfcModelItemType").ITEM_SURFACE);  //ListSubItems NOT ListItems
  //alert("surface number = " + surfaceArray.Count);

  //找到底面 也許是要找頂面
  var zLevel = CS0_ZMAX; //initialize
  var sId = "NA"; //initialize
  for(var i=0;i<surfaceArray.Count;i++){  //位移曲面的後面一半才是真的曲面 修改草繪後 位移曲面的順序不會照著排
	  var sOri = surfaceArray.Item(i).GetOrientation(); //SURFACEORIENT_OUTWARD中 平行於草繪截面的面都是真實面
	  var szLevel = getSurfaceZaxis(surfaceArray.Item(i));
	  if (szLevel<zLevel && sOri==1){  //get the bottom surface
		  zLevel = szLevel;
		  sId = surfaceArray.Item(i).Id;
	  }
	  
  }
  
  //alert("sId ="+sId);
  //alert("zLevel ="+zLevel);
  var bottomSurface = part.GetItemById(pfcCreate("pfcModelItemType").ITEM_SURFACE,sId);
  //doHighLight(bottomSurface);
  
  //依據底面取得邊
  var contourArray = bottomSurface.ListContours();
  for(var k=0;k<contourArray.Count;k++){
	  var edgeArray = contourArray.Item(k).ListElements();
  }
  
  var reEdgeArray = new Array ();
  //invert array and reArrange
  if (reIndex!=0){
	  reIndex = edgeArray.Count - reIndex; //invert index
  }
  //alert("reIndex ="+reIndex);
  if (reIndex>=0){
	  for(var i=reIndex;i>=0;i--){
		  //alert("i ="+i);
		  reEdgeArray.push (edgeArray.Item(i));
	  }
	  for(var i=edgeArray.Count-1;i>reIndex;i--){
		  reEdgeArray.push (edgeArray.Item(i));
	  }
  } else {
	  alert("R角順序異常");
  }

  //test results
  /*
  for(var m=0;m<reEdgeArray.length;m++){
	  alert("reEdgeArray:"+m);
	  doHighLight(reEdgeArray[m]);
  }*/
  
  return reEdgeArray;
}
//取得脫襯曲面的位移量
function getShOffset(session)
{
	var part = session.CurrentModel;
	if (part == void null || part.Type != pfcCreate("pfcModelType").MDL_PART){
		alert("Current model is not an part.");
	}
	
	var punchCutFeat = part.GetItemByName(pfcCreate("pfcModelItemType").ITEM_FEATURE,"CUT_IN_PRT__PU_TO_SH_SRF__GAP");
	var dimensionArray = punchCutFeat.ListSubItems(pfcCreate("pfcModelItemType").ITEM_DIMENSION);
	
	var offset = 0;
	for(var i=0;i<dimensionArray.Count;i++){
		if (dimensionArray.Item(i).GetName()=="PU_GAPIN_SH"){
			offset = dimensionArray.Item(i).DimValue;
		}
	}
	return offset;
}
//取得下襯曲面的位移量
function getDIOffset(session)
{
	var part = session.CurrentModel;
	if (part == void null || part.Type != pfcCreate("pfcModelType").MDL_PART){
		alert("Current model is not an part.");
	}
	
	var punchCutFeat = part.GetItemByName(pfcCreate("pfcModelItemType").ITEM_FEATURE,"CUT_IN_PRT__PU_TO_DI_SRF__GAP");
	var dimensionArray = punchCutFeat.ListSubItems(pfcCreate("pfcModelItemType").ITEM_DIMENSION);
	
	var offset = 0;
	for(var i=0;i<dimensionArray.Count;i++){
		if (dimensionArray.Item(i).GetName()=="PU_GAPIN_DI"){
			offset = dimensionArray.Item(i).DimValue;
		}
	}
	return offset;
}
//選擇下襯曲面底面的邊 依使用者順序排列
function selectDIBottomEdges(reIndex,session)
{
  var part = session.CurrentModel;

  if (part == void null || part.Type != pfcCreate("pfcModelType").MDL_PART){
	alert("Current model is not an part.");
  }

  var punchCutFeat = part.GetItemByName(pfcCreate("pfcModelItemType").ITEM_FEATURE,"CUT_IN_PRT__PU_TO_DI_SRF__GAP");

  var surfaceArray = punchCutFeat.ListSubItems(pfcCreate("pfcModelItemType").ITEM_SURFACE);  //ListSubItems NOT ListItems

  //找到底面 也許是要找頂面
  var zLevel = CS0_ZMAX; //initialize
  var sId = "NA"; //initialize
  for(var i=0;i<surfaceArray.Count;i++){  //位移曲面的後面一半才是真的曲面 修改草繪後 位移曲面的順序不會照著排
	  //var sOri = surfaceArray.Item(i).GetOrientation(); //SURFACEORIENT_OUTWARD中 平行於草繪截面的面都是真實面
	  var szLevel = getSurfaceZaxis(surfaceArray.Item(i));
	  //alert("sId="+surfaceArray.Item(i).Id + ";sOri="+sOri+";szLevel="+szLevel);
	  //doHighLight(surfaceArray.Item(i));
	  if (szLevel<zLevel){  //get the bottom surface
		  zLevel = szLevel;
		  sId = surfaceArray.Item(i).Id;
	  }
  }
  
  //alert("sId ="+sId);
  //alert("zLevel ="+zLevel);
  var bottomSurface = part.GetItemById(pfcCreate("pfcModelItemType").ITEM_SURFACE,sId);
  //doHighLight(bottomSurface);
  
  //依據底面取得邊
  
  var contourArray = bottomSurface.ListContours();
  for(var k=0;k<contourArray.Count;k++){
	  var edgeArray = contourArray.Item(k).ListElements();
  }

  var reEdgeArray = new Array ();
  //reArrange Array
  if (reIndex>=0){
	  for(var i=reIndex;i<edgeArray.Count;i++){
		  reEdgeArray.push (edgeArray.Item(i));
	  }
	  for(var i=0;i<reIndex;i++){
		  reEdgeArray.push (edgeArray.Item(i));
	  }
  } else {
	  alert("你所選的邊沒有在底面上，請重跑程式");
  }

  //test results
  /*
  for(var m=0;m<edgeArray.Count;m++){
	  alert("edgeArray:"+m);
	  doHighLight(edgeArray.Item(m));
  }
  for(var m=0;m<reEdgeArray.length;m++){
	  alert("reEdgeArray:"+m);
	  doHighLight(reEdgeArray[m]);
  }*/
  
  return reEdgeArray;
}
//取得沖剪刃部的R角狀況 不一定要第一邊 沖剪曲面能對得起來即可 unused
function getRoundInfo(rounName,offset,shBotEdgeArray,session)
{
  var part = session.CurrentModel;

  if (part == void null || part.Type != pfcCreate("pfcModelType").MDL_PART){
	alert("Current model is not an part.");
  }
  alert("getRoundInfo");
  var roundFeat = part.GetItemByName(pfcCreate("pfcModelItemType").ITEM_FEATURE,rounName);
  
  var edgeArray = roundFeat.ListSubItems(pfcCreate("pfcModelItemType").ITEM_EDGE);  //ListSubItems NOT ListItems
  alert("edge number = " + edgeArray.Count);
  for(var i=0;i<edgeArray.Count;i++){
	  alert("edge id="+edgeArray.Item(i).Id);
	  doHighLight(edgeArray.Item(i));
	  var sPoint = edgeArray.Item(i).Eval3DData(0).Point;
	  var ePoint = edgeArray.Item(i).Eval3DData(1).Point;
	  var der = edgeArray.Item(i).Eval3DData(0.5).Derivative1;
	  //alert("sPoint:"+sPoint.Item(0)+","+sPoint.Item(1)+","+sPoint.Item(2));
	  //alert("ePoint:"+ePoint.Item(0)+","+ePoint.Item(1)+","+ePoint.Item(2));
	  alert("Derivative1:"+der.Item(0)+","+der.Item(1)+","+der.Item(2));
  }
}
//Utils---------------------------------------------------------------------------------------------------------------------------------
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

function doRoundByEdge (edgeItem /* ITEM_EDGE */,radius /* round radius */,session){
	//alert(edgeItem.Id);
	
	var cmpPath = void null;  //for input,neccessary
	
	//select item
	var edgeSelection = pfcCreate ("MpfcSelect").CreateModelItemSelection ( edgeItem, cmpPath );

	//add to Selection Buffer
	var cBuffer = session.CurrentSelectionBuffer;
	cBuffer.Clear();
	cBuffer.AddSelection(edgeSelection);
	
	//run macro
	session.RunMacro ("~ Trail `UI Desktop` `UI Desktop` `UIT_TRANSLUCENT` `NEED_TO_CLOSE`;~ Command `ProCmdRound` ;~ Input `main_dlg_cur` `maindashInst0.cir_rad_list` `0`;~ Input `main_dlg_cur` `maindashInst0.cir_rad_list` `0.`;~ Input `main_dlg_cur` `maindashInst0.cir_rad_list` `"+ radius +"`;~ Update `main_dlg_cur` `maindashInst0.cir_rad_list` `"+ radius +"`;~ Activate `main_dlg_cur` `maindashInst0.cir_rad_list`; ~ FocusOut `main_dlg_cur` `maindashInst0.cir_rad_list`;~ Activate `main_dlg_cur` `dashInst0.Done`");
	cBuffer.Clear();
}

function doRoundBySurface (surfaceItemA /* ITEM_SURFACE */,surfaceItemB /* ITEM_SURFACE */,radius /* round radius */,featName /* rename */,session){
	var cmpPath = void null;  //for input,neccessary
	
	//select item
	var selectionA = pfcCreate ("MpfcSelect").CreateModelItemSelection ( surfaceItemA, cmpPath );
	var selectionB = pfcCreate ("MpfcSelect").CreateModelItemSelection ( surfaceItemB, cmpPath );

	//add to Selection Buffer
	var cBuffer = session.CurrentSelectionBuffer;
	cBuffer.Clear();
	cBuffer.AddSelection(selectionA);
	cBuffer.AddSelection(selectionB);

	//run macro
	session.RunMacro ("~ Trail `UI Desktop` `UI Desktop` `UIT_TRANSLUCENT` `NEED_TO_CLOSE`;~ Command `ProCmdRound` ;~ Input `main_dlg_cur` `maindashInst0.cir_rad_list` `0`;~ Input `main_dlg_cur` `maindashInst0.cir_rad_list` `0.`;~ Input `main_dlg_cur` `maindashInst0.cir_rad_list` `"+ radius +"`;~ Update `main_dlg_cur` `maindashInst0.cir_rad_list` `"+ radius +"`;~ Activate `main_dlg_cur` `maindashInst0.cir_rad_list`; ~ FocusOut `main_dlg_cur` `maindashInst0.cir_rad_list`;~ Input `rndch_properties.0.0` `PH.rndch_feat_name` `"+featName+"`;~ Update `rndch_properties.0.0` `PH.rndch_feat_name` `"+featName+"`;~ Activate `rndch_properties.0.0` `PH.rndch_feat_name`;~ FocusOut `rndch_properties.0.0` `PH.rndch_feat_name`;~ Activate `main_dlg_cur` `dashInst0.Done`");
	cBuffer.Clear();
}

//HighLight
function doHighLight (sItem /* ITEM_EDGE */,session){
	var cmpPath = void null;  //for input,neccessary
	
	//repaint
	//var window = session.CurrentWindow;
	//window.Repaint();
	
	//select item
	var itemSelection = pfcCreate ("MpfcSelect").CreateModelItemSelection ( sItem, cmpPath );
	
	itemSelection.Highlight(pfcCreate ("pfcStdColor").COLOR_DRAWING);  //COLOR_HIGHLIGHT
}

//get CS0_Z axis number when surface is normal to CS0_Z
//預設座標DEFAULT_CSYS的Z軸朝screen 所以CS0座標中Y/Z交換
function getSurfaceZaxis (surfaceItem /* ITEM_FEATURE */){
	var properties = surfaceItem.GetXYZExtents();
	
	var point0 = properties.Item(0);
	var point1 = properties.Item(1);

	var DEF_X = Math.abs(point0.Item(0) - point1.Item(0)).toFixed(1);
	var DEF_Y = Math.abs(point0.Item(1) - point1.Item(1)).toFixed(1);
	var DEF_Z = Math.abs(point0.Item(2) - point1.Item(2)).toFixed(1);

	var level = CS0_ZMAX;
	if (DEF_X!=0 && DEF_Z!=0 && DEF_Y==0) { level = point0.Item(1).toFixed(4); } //DEF_Y = CS0_Z

	return level;
}
