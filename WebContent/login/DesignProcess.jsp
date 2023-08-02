<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<%@page import="DBUtil.MySQLConnection"%>
<%@page import="org.json.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>設計流程看板</title>
</head>
<body>
<%
if(session.isNew()) {
    response.sendRedirect("Login.jsp");
}
String sId = session.getId();
String userID = (String) session.getAttribute("userID");
String userName = (String) session.getAttribute("userName");
String userEmail = (String) session.getAttribute("userEmail");
String userTel = (String) session.getAttribute("userTel");

MySQLConnection mainUpdate = new MySQLConnection();

mainUpdate.ConnectDNS();
mainUpdate.queryUser(userID);
JSONObject userData =  mainUpdate.getUserResultJSON();
mainUpdate.finish();

String job = userData.getString("job");
String[] jobs = job.split("~");
%>

<div>

<table width="100%">

<tr>
	<td>
	<table height="570px" style="border:3px #cccccc solid;" border='1'>
		<tr>
			<td colspan="2" bgcolor="#90F3AA">
				設計流程看板
			</td>
		</tr>
		<tr>
			<td>
				<select name="moldNO" id="moldNO">
        			<%
        			for(int i=0;i<jobs.length;i++) {
        			%>
        			<option value="<%=jobs[i] %>"><%=jobs[i] %></option>
        			<%} %>
    			</select>
			</td>
			<td>
				<input type="button" name="Start" value="載入資料" onclick="Checkin()" style="height:30px; width:110px"/>
			</td>
		</tr>
		<tr>
			<td>
				<input type="button" name="Start" value="全流程" onclick="Checkin()" style="height:30px; width:110px"/>
			</td>
			<td>
				<input type="button" name="Start" value="流程搜尋" onclick="Checkin()" style="height:30px; width:110px"/>
			</td>
		</tr>
		<tr>
			<td>
				<input type="button" name="Start" value="回進行中" onclick="Checkin()" style="height:30px; width:110px"/>
			</td>
			<td>
				<input type="button" name="Start" value="找暫停中" onclick="Checkin()" style="height:30px; width:110px"/>
			</td>
		</tr>
		<tr>
			<td>
				<input type="button" name="Start" value="通知修改" onclick="Checkin()" style="height:30px; width:110px"/>
			</td>
			<td>
				<input type="button" name="Start" value="修改通知清單" onclick="Checkin()" style="height:30px; width:110px"/>
			</td>
		</tr>
		<tr>
			<td colspan="2" bgcolor="#C890F3">
				模版序:	工程站序:
			</td>
		</tr>
		<tr>
			<td colspan="2" bgcolor="#90D4F3">
				流程主題:建立模板組件
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<input type="button" name="Start" value="已完成" onclick="Checkin()" style="height:30px; width:100px"/>
				<input type="button" name="Start" value="進行中" onclick="Checkin()" style="height:30px; width:100px"/>
				<input type="button" name="Start" value="暫停中" onclick="Checkin()" style="height:30px; width:100px"/>
			</td>
		</tr>
		<tr>
			<td colspan="2">
			<div style="height:250px;overflow:auto;">
			<center>
				<input type="button" name="Start" value="另存模板總組件" onclick="changeFrame('new_model','newMainASM.jsp')" style="height:30px; width:200px"/><br>
				<img src="../images/blue-arrow-down.png"  style="border-style: none"/><br>
				<input type="button" name="Start" value="組裝料條" onclick="changeFrame('new_model','assembleStrip.html')" style="height:30px; width:200px"/><br>
				<img src="../images/blue-arrow-down.png"  style="border-style: none"/><br>
				<input type="button" name="Start" value="設定PLT_PLN_SKE骨架內容" onclick="changeFrame('new_model','setSKE.jsp')" style="height:30px; width:200px"/><br>
				<img src="../images/blue-arrow-down.png"  style="border-style: none"/><br>
				<input type="button" name="Start" value="建立模板組件" onclick="changeFrame('new_model','newPLT.jsp')" style="height:30px; width:200px"/><br>
				<img src="../images/blue-arrow-down.png"  style="border-style: none"/><br>
				<!--<input type="button" name="Start" value="重合原材料寬與成品料寬" onclick="changeFrame('new_model','matchWidths.html')" style="height:30px; width:200px"/><br>
				<img src="../images/blue-arrow-down.png"  style="border-style: none"/><br>-->
				<input type="button" name="Start" value="重合組配座標" onclick="changeFrame('new_model','adaptSTACSYS.html')" style="height:30px; width:200px"/><br>
				<img src="../images/blue-arrow-down.png"  style="border-style: none"/><br>
				<input type="button" name="Start" value="組裝工程站" onclick="changeFrame('new_model','newSTAFrame.jsp')" style="height:30px; width:200px"/><br>
			</center>
			</div>
			</td>
		</tr>
	</table>
	</td>
	<td>
	<iframe width="1400px" height="570px" src="" name="f1" id="f1"></iframe>
	</td>
</tr>

</table>


</div>

<script>
function changeFrame(folder,fileName)
{
	//alert("changeFrame"+folder+","+fileName);
	var frameURL = "http://192.168.150.99:8080/DNSTEST/new_model/"+fileName;
	//alert("frameURL="+frameURL);
	var moldNO = document.getElementById("moldNO").value;
	//alert("moldNO="+moldNO);
	frameURL = frameURL+"?moldNO="+moldNO;
	//alert(frameURL);
	document.getElementById('f1').src = frameURL;
}
</script>
</body>
</html>