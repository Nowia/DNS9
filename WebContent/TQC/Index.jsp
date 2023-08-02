<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*,java.text.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TQC資料查詢 </title>
<link href=".././css/member_new.css" media="screen" rel="stylesheet" type="text/css" />

<style type='text/css'>
#header2  {width:100%;
           height:30px;
           text-align:center;
           background:rgb(225,225,200);
           margin:0 auto;
          }
#outer2   {width:100%;
           text-align:center;
           margin:0px auto;
           background:white;
          }


a { text-decoration:none }

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
%>
<div id='header2'>TQC資料查詢 登入者<%= userName %></div>
<div id='outer2'>
   <table class="member_new_style1" align="left">
   <tr><td class="member_new_style2">    TQC與成品尺寸智慧校對      </td></tr>
   <tr>
    <td>
    <table class="member_new_style4">
       <tr>
            <td class="member_new_style16">
            <table>
			   
			   <tr>
			   	<td class="member_new_style11">產品編號4碼 SDI<input type="text" name="productNo" id="productNo"/></td>
               </tr>
               
               <tr>
			   	<td class="member_new_style11">電子產品資料表號碼 NPD-<input type="text" name="npdNo" id="npdNo"/></td>
               </tr>

                <tr>
                <td class="member_new_style11">
                	<button type="button" onclick="GetSpec()">成品圖校對</button>
					<button type="button" onclick="GetTQC()">三次元程式校對</button>
      			</td>
                </tr>
            </table>
            </td>
       </tr>
    </table>
    </td>
   </tr>
  </table>
</div>
<script type="text/javascript">

function GetSpec()
{
	var productNo = document.getElementById("productNo").value;
	var npdNo = document.getElementById("npdNo").value;
	var foldername = "NA";
	
	if (productNo.length != 0){
		foldername = "SDI"+productNo.toUpperCase();
	} else if (npdNo.length != 0) {
		foldername = "NPD-"+npdNo.toUpperCase();
	}
	
	var url="QuerySpec0.jsp?foldername="+foldername;
	
	//window.open(url);
	window.location.href = url;
}

function GetTQC()
{
	var productNo = document.getElementById("productNo").value;
	
	var url="QueryTQC0.jsp?&productNo="+productNo;
	
	//window.open(url);
	window.location.href = url;
}
</script>
</body>
</html>