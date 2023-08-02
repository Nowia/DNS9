<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>另存模板總組件範本</title>
</head>

<body link=blue vlink=purple style='tab-interval:.5in'>
<%
request.setCharacterEncoding("UTF-8");
String moldNO =  request.getParameter("moldNO"); //製程
%>

<div class=Section1>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
	<tr bgcolor="#FFFFFF">
	<td>&nbsp;</td>
	<td height="60"><!-- #BeginLibraryItem "/Library/header_login.lbi" --><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="134"><h1>模具編號</h1><input type='text' id="moldNO" size='10' value="<%= moldNO %>"/><br><br></td>
  </tr>
    </table><!-- #EndLibraryItem --></td>
	<td>&nbsp;</td>
	</tr>

	<tr bgcolor="#cc0000">
	<td>&nbsp;</td>
	<td height="1" colspan="3" id="navigation" class="navText"></td>
	</tr>

<tr><td colspan="3">
<table style="border:3px #cccccc solid;" cellpadding="10" border='1' width="100%">
 <tr>
  <td colspan="2">
  	<table id="ModelTable">
	</table>
	<input type=button value="下兩板_脫夾板" id="btn1" name="btn1" onclick="newMainASM('two','clip')">
	<input type=button value="下兩板_脫兩板" id="btn2" name="btn2" onclick="newMainASM('two','two')">
	<input type=button value="下夾板_脫夾板" id="btn3" name="btn3" onclick="newMainASM('clip','clip')">
	<input type=button value="下夾板_脫兩板" id="btn4" name="btn4" onclick="newMainASM('clip','two')">
  </td>
</tr>
</table>
</td></tr>


	<tr bgcolor="#cc0000">
	<td>&nbsp;</td>
	<td height="1" colspan="3" id="navigation" class="navText"></td>
	</tr>

</table>
</div>
<script>
function newMainASM(bottom,strip)
{
	var url = "../login/Blank.html";
	if (bottom=='two' && strip=='clip'){
		url = "newMainASM_two_clip.jsp";
	}

	var moldNO = document.getElementById("moldNO").value;
	url=url+"?moldNO="+moldNO;
	window.location.href = url;
}
</script>
</body>
</html>