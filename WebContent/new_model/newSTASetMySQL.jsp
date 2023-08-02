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
nameList.add("�ҪO�ե�"+plateSeq);

String[] STANameArr = allSTANames.split("~");
String[] STASeqArr = allSeqs.split("~");

for( int m=0 ; m < STANameArr.length ;m++){
	STANameArr[m] = STANameArr[m].replace("�ե�", "����");
	nameList.add(STANameArr[m]+STASeqArr[m]);
	//get extra
	
}

if (allSTANames.indexOf("�R��")!=-1){
	nameList.add("�إ߮��h-�ҪO�ե�"+plateSeq);
}

nameList.add("�إ߾ɨR�P���ƶ�-�ҪO�ե�"+plateSeq);
nameList.add("�إ߾ɦ�O-�ҪO�ե�"+plateSeq);
nameList.add("�إ��˪����c-�ҪO�ե�"+plateSeq);

if (plateSeq.equals(plt_qty)){
	nameList.add("�إߤ��j��-�ҪO�ե�"+plateSeq);
}

nameList.add("�إߵ��Z��-�ҪO�ե�"+plateSeq);

if (allSTANames.indexOf("�j���ƶ�")!=-1){
	nameList.add("�إ߱j����-�ҪO�ե�"+plateSeq);
}

if (allSTANames.indexOf("����")!=-1){
	nameList.add("�إ߱j����-�ҪO�ե�"+plateSeq);
}

nameList.add("����ư��Ʀ���-�ҪO�ե�"+plateSeq);
nameList.add("��z�s��-�ҪO�ե�"+plateSeq);
nameList.add("��z�ҪO-�ҪO�ե�"+plateSeq);
nameList.add("ø�s2D�u�{��-�ҪO�ե�"+plateSeq);

if (plateSeq.equals(plt_qty)){
	nameList.add("��z�Үy");
	nameList.add("ø�s2D�u�{��-��z�Үy");
	nameList.add("��z�`�ե�u�{��");
	nameList.add("�ˮֹϭ�");
	nameList.add("�X�ϧ@�~");
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