<%@page import="DBUtil.MySQLConnection"%>
<%@page import="user.ShowUser"%>
<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>DNS9</title>
</head>
<body>
<%= user.ShowUser.Name() %><br>
<%
MySQLConnection mainUpdate = new MySQLConnection();

mainUpdate.newConnection();
//mainUpdate.queryUser();
%>
資料取得
<%= mainUpdate.getStatus() %>
<%
mainUpdate.finish();
%>
</body>
</html>