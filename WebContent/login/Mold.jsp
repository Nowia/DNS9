<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<%@page import="DBUtil.MySQLConnection"%>
<%@page import="org.json.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>Insert title here</title>
<style>
* {
margin:0;padding:0;
-webkit-box-sizing: border-box;
-moz-box-sizing: border-box;
box-sizing: border-box;
list-style:none;
}
a{
  text-decoration: none;line-height:2em;font-size:1rem;
}
a.open{background:#6F6;}
ol {}
ol li{
  text-align:center;
  position:relative;
  float:left;
  font-size:1rem;line-height:2em;
  margin-left:1px;
}

.open li{background:#C6FFAA;}

.button {
  display: inline-block;
  padding: 5px 5px;
  font-size: 1rem;
  cursor: pointer;
  text-align: center;
  text-decoration: none;
  outline: none;
  color: #000000;
  background-color: #C0C0C0;
  border: none;
  border-radius: 5px;
  box-shadow: 0 9px #999;
  white-space:nowrap;
  overflow:hidden;
  text-overflow:ellipsis;
}

.button:hover {background-color: #00FF00}

.button:active {
  background-color: #00FF00;
  box-shadow: 0 5px #666;
  transform: translateY(4px);
}

.disabled {
  opacity: 0.6;
}
</style>
</head>
<body>

<div class="menu">
  <ol>
    <li><button class="button" id="MoldSchedule" onclick="changeFrame('MoldSchedule','Blank.html')">模具排程資訊</li>
    <li><button class="button" id="Designate" onclick="changeFrame('Designate','Blank.html')">指派設計分工</a></li>
	<li><button class="button" id="DesignProcess" onclick="changeFrame('DesignProcess','DesignProcess.jsp')">設計流程看板</a></li>
	<li><button class="button" id="DesignGuide" onclick="changeFrame('DesignGuide','Blank.html')">設計全檢導引</a></li>
	<li><button class="button" id="PersonalWork" onclick="changeFrame('PersonalWork','Blank.html')">個人工作狀態查詢</a></li>
	<li><button class="button" id="MoldStatus" onclick="changeFrame('MoldStatus','Blank.html')">模具燈況</a></li>
	<li><button class="button" id="MoldHistory" onclick="changeFrame('MoldHistory','Blank.html')">歷史模具查詢</a></li>
	<li><button class="button" id="DesignStatus" onclick="changeFrame('DesignStatus','Blank.html')">模具設計狀況統計</a></li>
	<li><button class="button" id="BOM" onclick="changeFrame('BOM','Blank.html')">顯示物料件清單</a></li>
    <li><button class="button" id="EC" onclick="changeFrame('EC','Blank.html')">設變狀態</a></li>
  </ol>
</div>

<div style="width:1800px;height:600px">
	<iframe src="" name="iframeMain" id="iframeMain" width="100%" height="600px" style="border:none;">
	</iframe>
</div>

<script src="../js/jquery-1.12.4/jquery.js"></script>

<script>
function changeFrame(btnId,frameurl)
{
document.getElementById("iframeMain").src=frameurl;
var buttons = document.getElementsByTagName("button");
for (i = 0; i < buttons.length; i++) {
    buttons[i].className = "button disabled";
}
document.getElementById(btnId).className = "button";
}
</script>
</body>
</html>