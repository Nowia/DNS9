<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>Entrance</title>
</head>
<body>
<%
if(session.isNew()) {
    response.sendRedirect("Login.jsp");
}
String sId = session.getId();
String userId = (String) session.getAttribute("userId");
String userName = (String) session.getAttribute("userName");
String userEmail = (String) session.getAttribute("userEmail");
String userTel = (String) session.getAttribute("userTel");
%>

登入資訊<%= userId %>:<%= userName %>:<%= userEmail %>:<%= userTel %>
</body>
</html>