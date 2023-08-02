<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="DBUtil.MySQLConnection"%>
<%@page import="user.PLMAuthenticator"%>
<%@page import="org.json.*"%>
<!DOCTYPE html>
<html>
<head>
<title>專案起始</title>
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
String role = (String) session.getAttribute("role");

//get input
request.setCharacterEncoding("UTF-8");
String M_PART_NAME = request.getParameter("M_PART_NAME");
String M_PART_NO = request.getParameter("M_PART_NO");
String M_CUSTOMER_NAME = request.getParameter("M_CUSTOMER_NAME");
String M_MOLD_NAME = request.getParameter("M_MOLD_NAME");
String M_ORGANIZATION = request.getParameter("M_ORGANIZATION");
String M_FINISH_TIME = request.getParameter("M_FINISH_TIME");
String Form_No_Piece = request.getParameter("Form_No_Piece");
String creator = request.getParameter("creator");
String creatorID = request.getParameter("creatorID");
String MOLD_NO = request.getParameter("MOLD_NO").toLowerCase();

//MySQL
MySQLConnection moldQuery = new MySQLConnection();
moldQuery.ConnectDNS();
//update project
moldQuery.update("INSERT INTO dns.project (`name`,`template_id`,`created_user`,`status`,`M_PART_NAME`,`M_PART_NO`,`M_CUSTOMER_NAME`,`M_MOLD_NAME`,`M_ORGANIZATION`,`M_FINISH_TIME`,`Form_No_Piece`) VALUES ('"
+MOLD_NO+"','1','"+creatorID+"','active','"+M_PART_NAME+"','"+M_PART_NO+"','"+M_CUSTOMER_NAME+"','"+M_MOLD_NAME+"','"+M_ORGANIZATION+"','"+M_FINISH_TIME+"','"+Form_No_Piece+"');");
//update user
moldQuery.update("update dns.user set job = concat(job,'~"+MOLD_NO+"') where id='"+creatorID+"';");
moldQuery.finish();
%>

<div>

<table>

<tr>
	<td>
	<H1>專案啟動</H1>
	<form name="formTakeNumber" id="formTakeNumber" method="post" action="./StartProject0.jsp" >
	模具編號<input name="moldNO" type="text" id="moldNO" style="width:128px;" value="<%= MOLD_NO %>"/><br>
	<input name="userID" type="hidden" id="userID" style="width:128px;" value="<%= userID %>"/><br>
	</form>
	</td>
	<td>
	
	<table id="moldTable" class="display" border="1" style="text-align:center;">
		<tr><td>模具編號</td><td><%= MOLD_NO %></td></tr>
		<tr><td>產品名稱</td><td><%= M_PART_NAME %></td></tr>
		<tr><td>產品編號</td><td><%= M_PART_NO %></td></tr>
		<tr><td>客戶名稱</td><td><%= M_CUSTOMER_NAME %></td></tr>
		<tr><td>模具類別名稱</td><td><%= M_MOLD_NAME %></td></tr>
		<tr><td>組織別</td><td><%= M_ORGANIZATION %></td></tr>
		<tr><td>預計完成日期</td><td><%= M_FINISH_TIME %></td></tr>
		<tr><td>單側沖壓枚數</td><td><%= Form_No_Piece %></td></tr>
		<tr><td>建立者</td><td><%= creator %></td></tr>
	</table>
	已寫入
	</td>
</tr>

</table>


</div>

<script>
</script>
</body>
</html>