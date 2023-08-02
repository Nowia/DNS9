<%@ page contentType="text/html" pageEncoding="UTF-8"%>
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
PLMAuthenticator dnsLogger  = (PLMAuthenticator) session.getAttribute("dnsLogger");

//get user input
request.setCharacterEncoding("UTF-8");
String moldNO = request.getParameter("moldNO");
String errMsg = null;
//initial
String MOLD_NO = "NA";
String M_PART_NAME = "NA";
String M_PART_NO = "NA";
String M_CUSTOMER_NAME = "NA";
String M_MOLD_NAME = "NA";
String M_ORGANIZATION = "NA";
String M_FINISH_TIME = "NA";
String Form_No_Piece = "NA";
String creator = "NA";
String creatorID = "NA";
//check null
if (!(moldNO==null || "".equals(moldNO) || userID==null ||"".equals(userID))) 
{
	//Authentication with HttpUrlConnection
	String plmResponse = dnsLogger.readContentFromPost("http://sdiplm.sdi.com.tw/Windchill/netmarkets/jsp/dns/queryMoldNum.jsp?moldNO="+moldNO+"&userID="+userID);
	if (plmResponse==null || "".equals(plmResponse) || plmResponse.length()==0 || plmResponse.indexOf("{")==-1){
		errMsg = "無回應";
	} else {
	//使用Authenticator 一次登入 整個session有效; 
		if (plmResponse.equalsIgnoreCase("fail")){
			errMsg = "讀取有誤";
		} else {
			JSONObject obj = new JSONObject(plmResponse);
			if (!(obj.getString("M_PART_NO")==null || "".equals(obj.getString("M_PART_NO")))){
				MOLD_NO = obj.getString("MOLD_NO");
				M_PART_NAME = obj.getString("M_PART_NAME");
				M_PART_NO = obj.getString("M_PART_NO");
				M_CUSTOMER_NAME = obj.getString("M_CUSTOMER_NAME");
				M_MOLD_NAME = obj.getString("M_MOLD_NAME");
				M_ORGANIZATION = obj.getString("M_ORGANIZATION");
				//M_FINISH_TIME = obj.getString("M_FINISH_TIME");
				String[] TimeArr = obj.getString("M_FINISH_TIME").split("\\s+"); //2022/04/12 00:00:00
				M_FINISH_TIME = TimeArr[0];
				Form_No_Piece = obj.getString("Form_No_Piece");
				creator = obj.getString("creator");
				creatorID = obj.getString("creatorID");
				errMsg = "YES";
			} else {
				errMsg = "缺乏產編";
			}
		}
	}
} else {
	errMsg = "請輸入模具編號";
}
%>

<div>

<table>

<tr>
	<td>
	<H1>專案啟動</H1>
	<form name="formTakeNumber" id="formTakeNumber" method="post" action="./StartProject0.jsp" >
	模具編號<input name="moldNO" type="text" id="moldNO" style="width:128px;" value=""/><br>
	<input name="userID" type="hidden" id="userID" style="width:128px;" value="<%= userID %>"/><br>
	<input name="creatorID" type="hidden" id="creatorID" style="width:128px;" value="<%= creatorID %>"/>
	<button id="takeNumber">輸入</button>
	</form>
	</td>
	<td>
	<% if (errMsg.equals("YES")){ %>
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
		<% if (role.equalsIgnoreCase("admin") || userName.equalsIgnoreCase(creator)) { %>
		<input type=button value="啟動專案" id="button1" name="button1" onclick="saveAsPLT()">
		<% } %>
	<% } else { %>
		<%= errMsg %>
	<% } %>
	</td>
</tr>

</table>


</div>

<script>
function saveAsPLT (){
	var userID = document.getElementById("userID").value;
	var creatorID = document.getElementById("creatorID").value;
	var table = document.getElementById("moldTable");
	
	var MOLD_NO = table.rows[0].cells[1].innerHTML;
	var M_PART_NAME = table.rows[1].cells[1].innerHTML;
	var M_PART_NO = table.rows[2].cells[1].innerHTML;
	var M_CUSTOMER_NAME = table.rows[3].cells[1].innerHTML;
	var M_MOLD_NAME = table.rows[4].cells[1].innerHTML;
	var M_ORGANIZATION = table.rows[5].cells[1].innerHTML;
	var M_FINISH_TIME = table.rows[6].cells[1].innerHTML;
	var Form_No_Piece = table.rows[7].cells[1].innerHTML;
	var creator = table.rows[8].cells[1].innerHTML;
	
	var url = "StartProject1.jsp?M_PART_NAME="+M_PART_NAME+"&M_PART_NO="+M_PART_NO+"&M_CUSTOMER_NAME="+M_CUSTOMER_NAME+"&M_MOLD_NAME="+M_MOLD_NAME
	+"&M_ORGANIZATION="+M_ORGANIZATION+"&M_FINISH_TIME="+M_FINISH_TIME+"&Form_No_Piece="+Form_No_Piece+"&creator="+creator+"&creatorID="+creatorID+"&MOLD_NO="+MOLD_NO;
	
	//alert(url);
	
	window.location.href = url;
}

</script>
</body>
</html>