<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="DBUtil.MySQLConnection"%>
<%@page import="org.json.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>Index</title>
<style>
body {font-family: Arial;}

/* Style the tab */
.tab {
  overflow: hidden;
  border: 1px solid #ccc;
  background-color: #666;
  text-align: right;
}

/* Style the buttons inside the tab */
.tab button {
  float: left;
  border: 1px solid #666;
  padding: 14px 16px;
  transition: 0.3s;
  font-size: 17px;
  color: #000000;
}

/* Style the tab content */
.tabcontent {
  display: none;
  padding: 6px 12px;
  border: 1px solid #ccc;
  border-top: none;
}

.button {
  display: inline-block;
  padding: 5px 5px;
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

String role = userData.getString("role");
session.setAttribute("role", role);
%>

<div><img src="../images/head.png" alt="SDI Corp."></div>
<div style="width:1900px" class="tab">
  <button class="tablinks button" onclick="openFrame(event, 'homepage','homepageFrame')"><font face="微軟正黑體"><b>首頁</b></font></button>
  <button class="tablinks button" onclick="openFrame(event, 'Systemmanagement','SystemmanagementFrame')"><font face="微軟正黑體"><b>系統管理</b></font></button>
  <button class="tablinks button" onclick="openFrame(event, 'Mold','MoldFrame')"><font face="微軟正黑體"><b>模具</b></font></button>
  <h2 style="color:white"><font face="微軟正黑體"><b>目前使用者:<%= userID %>/<%= userName %>&nbsp;&nbsp;</b></font></h2>
</div>

<div style="width:1876px;height:660px" id="homepage" class="tabcontent">
	<iframe src="./homepage.jsp" id="homepageFrame" width="100%" height="660px" style="border:none;">
	</iframe>
</div>

<div style="width:1876px;height:660px" id="Systemmanagement" class="tabcontent">
	<iframe src="./Systemmanagement.html" id="SystemmanagementFrame" width="100%" height="660px" style="border:none;">
	</iframe>
</div>

<div style="width:1876px;height:660px" id="Mold" class="tabcontent">
	<iframe src="./Mold.jsp" id="MoldFrame" width="100%" height="660px" style="border:none;">
	</iframe>
</div>

<div><img src="../images/Bottom.png" alt="SDI Corp."></div>

<script>
function openFrame(evt, divName, frameName) {
  var i, tabcontent, tablinks;
  tabcontent = document.getElementsByClassName("tabcontent");
  for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
  }
  tablinks = document.getElementsByClassName("tablinks");
  for (i = 0; i < tablinks.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(" active", "");
  }
  document.getElementById(divName).style.display = "block";
  evt.currentTarget.className += " active";
}
</script>
   
</body>

</html>