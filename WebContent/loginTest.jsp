<%@page import="user.PLMAuthenticator"%>
<%@page import="org.json.*"%>
<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>loginTest</title>
</head>
<body>
<%
PLMAuthenticator dnsLogger = new PLMAuthenticator("Vincentchen","123"); //Vincentchen
//int testCode = dnsLogger.sendRquestWithAuthenticator("http://sdiplm11.sdi.com.tw/Windchill/netmarkets/jsp/dns/wtuserinfo.jsp");
String plmResponse = dnsLogger.readContentFromPost("http://sdiplm11.sdi.com.tw/Windchill/netmarkets/jsp/dns/wtuserinfo.jsp");
JSONObject obj = new JSONObject(plmResponse);
String id = obj.getString("id");
String name = obj.getString("name");
String email = obj.getString("email");
String tel = obj.getString("tel");
%>
id:<%=id %><br>
name:<%=name %><br>
email:<%=email %><br>
tel:<%=tel %>
</body>
</html>