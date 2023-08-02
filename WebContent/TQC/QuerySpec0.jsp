<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*,java.text.*" %>
<%@page import="user.PLMAuthenticator"%>
<%@page import="org.json.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>成品圖校對</title>
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

<script language="JavaScript">

function GetNPD(){
	var productNo = document.getElementById("productNo").value.toUpperCase();
	$("#GetNPDDiv").load("http://sdiplm.sdi.com.tw/Windchill/netmarkets/jsp/pns/QuerySpecGetNPD.jsp?productNo="+productNo);
}
</script>
<body>
<div id='header2'>成品圖校對</div>
<div id='outer2'>

<%
request.setCharacterEncoding("UTF-8");
String foldername = request.getParameter("foldername");

//get NPD
if(session.isNew()) {
    response.sendRedirect("Login.jsp");
}
String sId = session.getId();
String userID = (String) session.getAttribute("userID");
String userName = (String) session.getAttribute("userName");
String userEmail = (String) session.getAttribute("userEmail");
String userTel = (String) session.getAttribute("userTel");

PLMAuthenticator dnsLogger  = (PLMAuthenticator) session.getAttribute("dnsLogger");
String errMsg = null;
//initial
List<String> partNOlist = new ArrayList<String>();
List<String> partNamelist = new ArrayList<String>();
List<String> partVersionlist = new ArrayList<String>(); //版本

//check null
if (!(foldername==null || "".equals(foldername) || userID==null ||"".equals(userID))) 
{
	//Authentication with HttpUrlConnection
	String plmResponse = dnsLogger.readContentFromPost("http://sdiplm.sdi.com.tw/Windchill/netmarkets/jsp/pns/QuerySpecGetNPD.jsp?foldername="+foldername);
	if (plmResponse==null || "".equals(plmResponse) || plmResponse.length()==0 || plmResponse.indexOf("{")==-1){
		errMsg = "無回應";
	} else {
	//使用Authenticator 一次登入 整個session有效; 
		if (plmResponse.equalsIgnoreCase("fail")){
			errMsg = "讀取有誤";
		} else {
			JSONObject obj = new JSONObject(plmResponse);
			JSONArray dataArr = obj.getJSONArray("data");
			if (dataArr.length()>0){
				for(int i=0; i<dataArr.length(); i++){
					JSONObject jObj = dataArr.getJSONObject(i);
					partNOlist.add(jObj.getString("partNO"));
					partNamelist.add(jObj.getString("partName"));
					partVersionlist.add(jObj.getString("partVersion"));
				}
				errMsg = "obj="+obj.toString();
			} else {
				errMsg = "缺乏產編";
			}
		}
	}
} else {
	errMsg = "找不到編號";
}

//local folder
ArrayList<String> dirFound = new ArrayList<String>();
//ArrayList<String> csvFound = new ArrayList<String>();
ArrayList<String> searchCondition = new ArrayList<String>();
ArrayList<String> dirCsvFound = new ArrayList<String>();
ArrayList<String> allPath = new ArrayList<String>();
ArrayList<String> allDirName = new ArrayList<String>();
String baseFolder = "D:/TQC_5500/";
String specFilePath = null;  // E:/tqc_data/5500/
//String csvCondition = null;
String allCsvFound = "";

//not used
//list subdirectories
/*
File file = new File(baseFolder);
String[] directories = file.list(new FilenameFilter() {
  @Override
  public boolean accept(File current, String name) {
    return new File(current, name).isDirectory();
  }
});
*/

for (int k = 0; k < partNOlist.size(); k++) {
	specFilePath = baseFolder + partNOlist.get(k);
	allPath.add(specFilePath);
	allCsvFound=""; //reset

	//find spec
	File fileDir2 = new File(specFilePath);
	
	if (fileDir2.exists()){
		File[] filesList2 = fileDir2.listFiles();

		if (filesList2!=null){
			for(File f2 : filesList2){
    			if(f2.isFile()){
    				if (f2.getName().indexOf(foldername)!=-1){
    					if (f2.getName().indexOf(".csv")!=-1){
    						//csvFound.add(f2.getName());
    						allCsvFound = allCsvFound+f2.getName()+"~";
    					}
    				}
    			}
			} //for files
			dirCsvFound.add(allCsvFound);
			searchCondition.add(partNOlist.get(k)+"搜尋完成");
		} else {
			searchCondition.add(partNOlist.get(k)+"內無檔案");
			dirCsvFound.add("NA");
		}
	} else {
		searchCondition.add(partNOlist.get(k)+"找不到上傳資料夾");
		dirCsvFound.add("NA");
	}
} //for dirs

%>

<table border="1" style="text-align:center;width: 60%;margin:auto">
<%
for( int n=0 ; n < partNOlist.size() ;n++){%>
		<tr>
		<td>產品編號</td><td><%= partNOlist.get(n) %></td>
		<td>圖號</td><td><%= partNamelist.get(n) %></td>
		<td>最新版次</td><td><%= partVersionlist.get(n) %></td>
		<td>
		<% if (dirCsvFound.get(n).equalsIgnoreCase("NA")){ %>
			&nbsp;
		<% } else { %>
			<input name="productNo" type="hidden" id="productNo<%=n%>" value="<%= foldername %>"/>
			<input name="specFilePath" type="hidden" id="specFilePath<%=n%>" value="<%= allPath.get(n) %>"/>
			<input name="allCsvFound" type="hidden" id="allCsvFound<%=n%>" value="<%= dirCsvFound.get(n) %>"/>
			<button type="button" onclick="GetSpec('<%=n%>')">校對</button>
		<% } %>
		</td>
		</tr>
<% } %>
</table>
<br>
<br>
<table border="1" style="text-align:center;width: 30%;margin:auto">
<tr><td bgcolor="yellow">查詢<%= foldername %>已上傳檔案</td></tr>
<%
for( int n=0 ; n < partNOlist.size() ;n++){
	String[] csvArr = dirCsvFound.get(n).split("~");
%>
<tr><td bgcolor="yellow"><%= searchCondition.get(n) %></td></tr>
<%
if (!dirCsvFound.get(n).equalsIgnoreCase("NA")){
for( int m=0 ; m < csvArr.length ;m++){
%>
<tr><td><%= csvArr[m] %></td></tr>
<%} //for
} //if
}%>
</table>
</div>
<script type="text/javascript">

function GetSpec(index)
{
	var productNo = document.getElementById("productNo"+index).value;
	var specFilePath = document.getElementById("specFilePath"+index).value;
	var allCsvFound = document.getElementById("allCsvFound"+index).value;
	
	var url="QuerySpec1.jsp?&productNo="+productNo+"&specFilePath="+specFilePath+"&allCsvFound="+allCsvFound;
	
	//window.open(url);
	window.location.href = url;
}
</script>
</body>
</html>