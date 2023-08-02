<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*,java.text.*" %>
<%@page import="DBUtil.MySQLConnection"%>
<%@page import="org.json.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>newSTASetMySQL</title>

</head>
<body>
<%
request.setCharacterEncoding("UTF-8");
String moldName = request.getParameter("moldName");
String plateSeq = request.getParameter("plateSeq");
String allSeqs = request.getParameter("allSeqs");
String allSTANames = request.getParameter("allSTANames");

//from MySQL
MySQLConnection moldQuery = new MySQLConnection();
moldQuery.ConnectDNS();
JSONObject projectData = moldQuery.queryOneResult("SELECT * FROM dns.project WHERE name='"+ moldName +"';");
out.println(projectData+"<br>");
String project_id = projectData.getString("id");
String plt_qty = projectData.getString("plt_qty");

//to MySQL
List<String> nameList = new ArrayList<String>();
//1st
nameList.add("模板組件"+plateSeq);

String[] STANameArr = allSTANames.split("~");
String[] STASeqArr = allSeqs.split("~");

for( int m=0 ; m < STANameArr.length ;m++){
	STANameArr[m] = STANameArr[m].replace("組件", "站序");
	nameList.add(STANameArr[m]+STASeqArr[m]);
	//get extra
	
}

if (allSTANames.indexOf("沖剪")!=-1){
	nameList.add("建立消屑-模板組件"+plateSeq);
}

nameList.add("建立導沖與頂料塊-模板組件"+plateSeq);
nameList.add("建立導位板-模板組件"+plateSeq);
nameList.add("建立檢知機構-模板組件"+plateSeq);

if (plateSeq.equals(plt_qty)){
	nameList.add("建立分隔塊-模板組件"+plateSeq);
}

nameList.add("建立等距棒-模板組件"+plateSeq);

if (allSTANames.indexOf("大頂料塊")!=-1){
	nameList.add("建立強壓塊-模板組件"+plateSeq);
}

if (allSTANames.indexOf("成形")!=-1){
	nameList.add("建立強壓塊-模板組件"+plateSeq);
}

nameList.add("實體化除料曲面-模板組件"+plateSeq);
nameList.add("整理零件-模板組件"+plateSeq);
nameList.add("整理模板-模板組件"+plateSeq);
nameList.add("繪製2D工程圖-模板組件"+plateSeq);

if (plateSeq.equals(plt_qty)){
	nameList.add("整理模座");
	nameList.add("繪製2D工程圖-整理模座");
	nameList.add("整理總組件工程圖");
	nameList.add("檢核圖面");
	nameList.add("出圖作業");
}

//delete data?

//insert data
int parent_id = 1; //not defined
int level = 3;
int order = 0;
//check for previous plate

JSONObject orderData = moldQuery.queryOneResult("SELECT `order` FROM dns.project_step where project_id='"+project_id+"' AND parent_id='"+parent_id+
			"' AND level='"+level+"' Order by `order` DESC;");
if (moldQuery.getStatus().equalsIgnoreCase("done")){
	order = Integer.parseInt(orderData.getString("order"));
} else {
	order = 0;
}

out.println(order+"<br>");

//update
for (int n = 0; n < nameList.size(); n++) {
	order = order + 1;
	moldQuery.update("INSERT INTO dns.project_step (`project_id`,`parent_id`,`level`,`order`,`name`) VALUES ('"+project_id+"','"+
			parent_id+"','"+level+"','"+order+"','"+nameList.get(n)+"');");
}
moldQuery.finish();

//test
for (int n = 0; n < nameList.size(); n++) {
	out.println(nameList.get(n)+"<br>");
}
%>

</body>
</html>