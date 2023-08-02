<%@page import="user.PLMAuthenticator"%>
<%@page import="org.json.*"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<HEAD>

<title>Login</title>

<link type="text/css" href="../css/jquery-ui.css" 			rel="stylesheet" />
<LINK type="text/css" href="../css/style.css" 				rel="stylesheet" />
<style type='text/css'>
.center {
display: flex;
justify-content: center;
}
</style>
<script type="text/javascript" src="../js/jquery-1.12.4/jquery.js" ></script>
<script type="text/javascript" src="../js/jquery-ui-1.12.1/jquery-ui.js" ></script>

<script type="text/javascript">
function trim(str)
{
	return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}

function formSubmit()
{
	if( trim(formLogin.userID.value).length==0 )
	{
		alert("Please input User Name");
		formLogin.userID.focus();
		return false;
	}
	if ( trim(formLogin.psword.value).length==0 )
	{
		alert("Please input Password");
		formLogin.psword.focus();
		return false;
	}
	document.formLogin.submit();
	
	return true;
}

function initialize()
{
	//alert("initialize()");

	$(".grd1 tr:odd").addClass("odd");
	$(".grd1 tr:even").addClass("even");
	
	$("input[type='text']").change( function() {
		document.getElementById("errMsg").innerText=" ";
	});

	formLogin.userID.focus();
	
	if ( !(document.getElementById("errMsg").innerText!="" || document.getElementById("errMsg").innerText!=" ") )
		alert("'"+document.getElementById("errMsg").innerText+"'");
}
</script>
</HEAD>
<body onLoad="initialize()" style="font: 62.5% 'Trebuchet MS', sans-serif; margin: 0px; text-align:center">
<%
String errMsg = null;
//String userID = "NA";

//get user input
String userID = request.getParameter("userID");
String psword = request.getParameter("psword");

if (userID==null || "".equals(userID) || psword==null ||"".equals(psword)){
	userID = (String) session.getAttribute("userID");
	psword = (String) session.getAttribute("psword");
}

//check null
if (!(userID==null || "".equals(userID) || psword==null ||"".equals(psword)))
{
	//Authentication with HttpUrlConnection
	PLMAuthenticator dnsLogger = new PLMAuthenticator(userID,psword);
	String plmResponse = dnsLogger.readContentFromPost("http://sdiplm.sdi.com.tw/Windchill/netmarkets/jsp/dns/wtuserinfo.jsp");
	//使用Authenticator 一次登入 整個session有效; 
	if (plmResponse.equalsIgnoreCase("fail")){
		errMsg = "帳號密碼有誤";
	} else {
		JSONObject obj = new JSONObject(plmResponse);
		if (!(obj.getString("id")==null || "".equals(obj.getString("id")))){
			session.setAttribute("userID", obj.getString("id"));
			session.setAttribute("userName", obj.getString("name"));
			session.setAttribute("userEmail", obj.getString("email"));
			session.setAttribute("userTel", obj.getString("tel"));
			session.setAttribute("psword", psword);
			session.setAttribute("dnsLogger", dnsLogger);
			request.getRequestDispatcher("Index.jsp").forward(request, response);
			//userID = obj.getString("id");
			//response.sendRedirect("Index.jsp?userID="+userID+userName+psword+"&session=new");
			//errMsg = "test"+userName+":"+psword+":"+obj.getString("id")+":"+obj.getString("name");
		} else {
			errMsg = "無此帳號密碼";
		}
	}
} else {
	errMsg = "請輸入帳號密碼";
}


%>
<form name="formLogin" id="formLogin" method="post" action="./Login.jsp" >
<table cellSpacing="0" cellPadding="0" style="BACKGROUND-COLOR: #ffffff;width:100%; border-spacing:0px;">
	<tr>
		<td>
			<table style="width: 100%">
				<tr>

					<td style="width: 10%;">&nbsp;</td>

					<td style="text-align:center;">
						<img src="../images/Bottom.png" alt="SDI Corp.">
					</td>
						
					<td style="width: 10%;">&nbsp;</td>

				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td>
			<br>
			<div class="center">
			<table id="Table1" class="grd1" style="width: 50%;" cellSpacing="0" cellPadding="0" border="0">
				<tr style="height: 36px; text-align: center;">
					<th style="width: 100%;">
						<font size="+2">登入系統 請使用PLM帳號密碼</font>
					</th>
				</tr>
				<tr style="height: 32px; text-align: center;">
					<td style="text-align: center;">
						帳號 &nbsp;&nbsp;<input name="userID" type="text" id="userID" style="width:128px;" value=""/>
					</td>
				</tr>
				<tr style="height: 32px; text-align: center;">
					<td style="text-align: center;">
						密碼 &nbsp;&nbsp;<input name="psword" type="password" id="psword" style="width:128px;" value=""/>
					</td>
				</tr>
				<tr style="height: 32px; text-align: center;">
					<td>
						<a onClick="return formSubmit();" style="cursor: hand;" >
						<img src="../images/button/Login.png" border="0" /> <br>
						登入</a>
					</td>
				</tr>
				<tr style="height: 32px; text-align: center;">
					<td id="errMsg"><%= errMsg %></td>
				</tr>
			</table>
			</div>
		<br>
		</td>
	</tr>
	<tr>
		<td>
			<table style="width: 100%;">
				<tr>

					<td style="width: 10%;">&nbsp;</td>

					<td style="text-align:center">
						<img src="../images/Bottom.png" alt="SDI Corp.">
					</td>

					<td style="width: 10%;">&nbsp;</td>

				</tr>
			</table>
		</td>
	</tr>
</table>
</form>

</body>
</html>