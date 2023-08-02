<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>newSTA Frame</title>
</head>
<script src="../js/jquery-3.6.0.min.js"></script>
<body>
<%
request.setCharacterEncoding("UTF-8");
String moldNO =  request.getParameter("moldNO"); //製程
String setMdlName1 = moldNO + "plt1.asm";
String setMdlName2 = moldNO + "plt2.asm";
String setMdlName3 = moldNO + "plt3.asm";
String setMdlName4 = moldNO + "plt4.asm";
%>
<div><iframe width="1200px" height="300px" src="newSTA.jsp?moldName=<%= setMdlName1 %>" name="f1" id="f1"></iframe></div>
<div><iframe width="1200px" height="300px" src="newSTA.jsp?moldName=<%= setMdlName2 %>" name="f2" id="f2"></iframe></div>
<div><iframe width="1200px" height="300px" src="newSTA.jsp?moldName=<%= setMdlName3 %>" name="f3" id="f3"></iframe></div>
<div><iframe width="1200px" height="300px" src="newSTA.jsp?moldName=<%= setMdlName4 %>" name="f4" id="f4"></iframe></div>
<input type="hidden" name="moldNO" id="moldNO" value="<%= moldNO %>"/>
<button onclick="setMySQL()">寫入資料庫</button>
<div id="divLoad1"></div>
<div id="divLoad2"></div>
<div id="divLoad3"></div>
<div id="divLoad4"></div>
<script>
var moldName = document.getElementById("moldNO").value;

function setMySQL() {
	var urlf1 = getURL("f1","1");
	//alert ("urlf1="+urlf1);
	//window.frames["f1"].location = urlf1;
	//$("#divLoad1").load(urlf1);
	$.ajax({
		async: false,
		type: "GET",
		url: urlf1,
		dataType: "text"
	});
	
	var urlf2 = getURL("f2","2");
	//alert ("urlf2="+urlf2);
	//window.frames["f2"].location = urlf2;
	//$("#divLoad2").load(urlf2);
	$.ajax({
		async: false,
		type: "GET",
		url: urlf2,
		dataType: "text"
	});
	
	var urlf3 = getURL("f3","3");
	//alert ("urlf3="+urlf3);
	//window.frames["f3"].location = urlf3;
	//$("#divLoad3").load(urlf3);
	$.ajax({
		async: false,
		type: "GET",
		url: urlf3,
		dataType: "text"
	});
	
	var urlf4 = getURL("f4","4");
	//alert ("urlf4="+urlf4);
	//window.frames["f4"].location = urlf4;
	//$("#divLoad4").load(urlf4);
	$.ajax({
		async: false,
		type: "GET",
		url: urlf4,
		dataType: "text"
	});
	
	alert ("完成");
}


function getURL(frameid,frameSeq) {
	//alert ("getURL frameid="+frameid);
  var iframe = document.getElementById(frameid);
  var plateSeq = iframe.contentWindow.document.getElementById("plateSeq").value;
  var allSeqs = iframe.contentWindow.document.getElementById("allSeqs").value;
  var allSTANames = iframe.contentWindow.document.getElementById("allSTANames").value;
  //alert ("plateSeq="+plateSeq);
  var mySQLUrl = "";
  if (plateSeq==frameSeq){
	  //alert ("plateSeq==frameSeq");
	  mySQLUrl = "http://192.168.150.99:8080/DNSTEST/new_model/newSTASetMySQL.jsp?moldName="+moldName+"&plateSeq=" + plateSeq +
		"&allSeqs=" + allSeqs + "&allSTANames=" + allSTANames;
  } else {
	  //alert ("plateSeq!=frameSeq");
	  mySQLUrl = "http://192.168.150.99:8080/DNSTEST/login/Empty.html";
  }
  
  //alert ("mySQLUrl="+mySQLUrl);

  return mySQLUrl;
}
</script>
</body>
</html>