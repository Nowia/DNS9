<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*,java.text.*" %>
<%@page import="user.PLMAuthenticator"%>
<%@page import="org.json.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>成品圖校對</title>
<link href="../css/member_new.css" media="screen" rel="stylesheet" type="text/css" />

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
.center {
  margin-left: auto;
  margin-right: auto;
}

a { text-decoration:none }

</style>
</head>

<body>
<div id='header2'>成品圖校對</div>
<div id='outer2'>

<%
   ServletContext context = pageContext.getServletContext();
   String productNo = request.getParameter("productNo");//產編
   String specFilePath = request.getParameter("specFilePath");
   String allCsvFound = request.getParameter("allCsvFound");
   String table_name = request.getParameter("table_name");
   String datafile = "";
   String[] datafileArr = allCsvFound.split("~");
   
   ArrayList<String> seq = new ArrayList<String>();
   ArrayList<String> size = new ArrayList<String>();
   ArrayList<String> grade = new ArrayList<String>();
   ArrayList<String> tol = new ArrayList<String>();
   ArrayList<String> base1 = new ArrayList<String>();
   ArrayList<String> base2 = new ArrayList<String>();
   ArrayList<String> base3 = new ArrayList<String>();
   ArrayList<String> note = new ArrayList<String>();
   ArrayList<String> srcFile = new ArrayList<String>();
   
   Map<String,String> seqMap = new HashMap();
   Map<String,String> sizeMap = new HashMap();
   
   //for next page   
   out.println("<html>");
   out.println("<head>");
   out.println("<title>File upload</title>");
   out.println("</head>");
   out.println("<body>");

   List FileData = new ArrayList();
   
   for( int m=0 ; m < datafileArr.length ;m++){
   datafile = specFilePath+"/"+datafileArr[m];
 //讀取csv
   Scanner fscanner = new Scanner(new File(datafile));
   
   while (fscanner.hasNextLine()) {
  	 List rowData = new ArrayList();
       Scanner lscanner = new Scanner(fscanner.nextLine());
       lscanner.useDelimiter(",");
   boolean b;
   while (b = lscanner.hasNext()) {
       String s = lscanner.next();             
       rowData.add(s);
       //out.println(s+"|");
   }
   if (rowData.size()>0){FileData.add(rowData);} //prevent blank line
   if (rowData.size()==8){
	   String title = (String) rowData.get(0);
	   if (title.indexOf("號碼球")==-1){
	   	seq.add((String) rowData.get(0));
	   	size.add((String) rowData.get(1));
	   	grade.add((String) rowData.get(2));
	   	tol.add((String) rowData.get(3));
	   	base1.add((String) rowData.get(4));
	   	base2.add((String) rowData.get(5));
	   	base3.add((String) rowData.get(6));
	   	note.add((String) rowData.get(7));
	   	srcFile.add(datafileArr[m]);
	   }
   }
   lscanner.close();
   }
   fscanner.close();
   } //for
   
   //print for test
   //out.println(datafileArr);
/*
   for (int k = 0; k < FileData.size(); k++) {
  	 out.println("<br />");
  	 List list = (List) FileData.get(k);        	 
  	 for (int j = 0; j < list.size(); j++) {
  		 out.println(list.get(j)+",");
       }
   }
*/
//相同號碼球
	for (int k = 0; k < seq.size(); k++) {
		String key = seq.get(k);
		if (seqMap.containsKey(key)){
			String seqIndex = seqMap.get(key)+"~"+k;
			seqMap.put(key, seqIndex);
		} else {
			seqMap.put(key, String.valueOf(k));
		}
	}

ArrayList<String> seq1 = new ArrayList<String>();
ArrayList<String> size1 = new ArrayList<String>();
ArrayList<String> grade1 = new ArrayList<String>();
ArrayList<String> tol1 = new ArrayList<String>();
ArrayList<String> base11 = new ArrayList<String>();
ArrayList<String> base21 = new ArrayList<String>();
ArrayList<String> base31 = new ArrayList<String>();
ArrayList<String> note1 = new ArrayList<String>();
ArrayList<String> srcFile1 = new ArrayList<String>();
for (Object key : seqMap.keySet()) {
	String tempValue = seqMap.get(key);
	String[] tempValueArr = tempValue.split("~");
	if (tempValueArr.length>1){ //at last 2 are the same
		for( int i=0 ; i < tempValueArr.length ;i++){
			int x = Integer.parseInt(tempValueArr[i]);
			seq1.add(seq.get(x));
			size1.add(size.get(x));
			grade1.add(grade.get(x));
			tol1.add(tol.get(x));
			base11.add(base1.get(x));
			base21.add(base2.get(x));
			base31.add(base3.get(x));
			note1.add(note.get(x));
			srcFile1.add(srcFile.get(x));
		}
	}
}
%>
<span class="member_new_style8">相同號碼球</span>
<table class="center">
	<tr>
	<td class="member_new_style11">號碼球</td>
	<td class="member_new_style11">尺寸值</td>
	<td class="member_new_style11">級別</td>
	<td class="member_new_style11">公差</td>
	<td class="member_new_style11">基準1</td>
	<td class="member_new_style11">基準2</td>
	<td class="member_new_style11">基準3</td>
	<td class="member_new_style11">備註</td>
	<td class="member_new_style11">來源</td>
	</tr>
	<% for (int k = 0; k < seq1.size(); k++) { %>
	<tr>
	<td class="member_new_style10"><%= seq1.get(k) %></td>
	<td class="member_new_style10"><%= size1.get(k) %></td>
	<td class="member_new_style10"><%= grade1.get(k) %></td>
	<td class="member_new_style10"><%= tol1.get(k) %></td>
	<td class="member_new_style10"><%= base11.get(k) %></td>
	<td class="member_new_style10"><%= base21.get(k) %></td>
	<td class="member_new_style10"><%= base31.get(k) %></td>
	<td class="member_new_style10"><%= note1.get(k) %></td>
	<td class="member_new_style10"><%= srcFile1.get(k) %></td>
	</tr>
	<% } %>
</table>
<%
//相同尺寸
	for (int k = 0; k < size.size(); k++) {
		String key = size.get(k);
		if (sizeMap.containsKey(key)){
			String sizeIndex = sizeMap.get(key)+"~"+k;
			sizeMap.put(key, sizeIndex);
		} else {
			sizeMap.put(key, String.valueOf(k));
		}
	}

ArrayList<String> seq2 = new ArrayList<String>();
ArrayList<String> size2 = new ArrayList<String>();
ArrayList<String> grade2 = new ArrayList<String>();
ArrayList<String> tol2 = new ArrayList<String>();
ArrayList<String> base12 = new ArrayList<String>();
ArrayList<String> base22 = new ArrayList<String>();
ArrayList<String> base32 = new ArrayList<String>();
ArrayList<String> note2 = new ArrayList<String>();
ArrayList<String> srcFile2 = new ArrayList<String>();
for (Object key : sizeMap.keySet()) {
	String tempValue = sizeMap.get(key);
	String[] tempValueArr = tempValue.split("~");
	if (tempValueArr.length>1){ //at last 2 are the same
		for( int i=0 ; i < tempValueArr.length ;i++){
			int x = Integer.parseInt(tempValueArr[i]);
			seq2.add(seq.get(x));
			size2.add(size.get(x));
			grade2.add(grade.get(x));
			tol2.add(tol.get(x));
			base12.add(base1.get(x));
			base22.add(base2.get(x));
			base32.add(base3.get(x));
			note2.add(note.get(x));
			srcFile2.add(srcFile.get(x));
		}
	}
}
%>
<span class="member_new_style8">相同尺寸</span>
<table class="center">
	<tr>
	<td class="member_new_style11">號碼球</td>
	<td class="member_new_style11">尺寸值</td>
	<td class="member_new_style11">級別</td>
	<td class="member_new_style11">公差</td>
	<td class="member_new_style11">基準1</td>
	<td class="member_new_style11">基準2</td>
	<td class="member_new_style11">基準3</td>
	<td class="member_new_style11">備註</td>
	<td class="member_new_style11">來源</td>
	</tr>
	<% for (int k = 0; k < seq2.size(); k++) { %>
	<tr>
	<td class="member_new_style10"><%= seq2.get(k) %></td>
	<td class="member_new_style10"><%= size2.get(k) %></td>
	<td class="member_new_style10"><%= grade2.get(k) %></td>
	<td class="member_new_style10"><%= tol2.get(k) %></td>
	<td class="member_new_style10"><%= base12.get(k) %></td>
	<td class="member_new_style10"><%= base22.get(k) %></td>
	<td class="member_new_style10"><%= base32.get(k) %></td>
	<td class="member_new_style10"><%= note2.get(k) %></td>
	<td class="member_new_style10"><%= srcFile2.get(k) %></td>
	</tr>
	<% } %>
</table>
<%
//未標示號碼球
ArrayList<String> seq3 = new ArrayList<String>();
ArrayList<String> size3 = new ArrayList<String>();
ArrayList<String> grade3 = new ArrayList<String>();
ArrayList<String> tol3 = new ArrayList<String>();
ArrayList<String> base13 = new ArrayList<String>();
ArrayList<String> base23 = new ArrayList<String>();
ArrayList<String> base33 = new ArrayList<String>();
ArrayList<String> note3 = new ArrayList<String>();
ArrayList<String> srcFile3 = new ArrayList<String>();
for (int k = 0; k < seq.size(); k++) {
	if (seq.get(k).length()==0 || seq.get(k)==null || "".equals(seq.get(k))){
		seq3.add(seq.get(k));
		size3.add(size.get(k));
		grade3.add(grade.get(k));
		tol3.add(tol.get(k));
		base13.add(base1.get(k));
		base23.add(base2.get(k));
		base33.add(base3.get(k));
		note3.add(note.get(k));
		srcFile3.add(srcFile.get(k));
	}
}
%>
<span class="member_new_style8">未標示號碼球</span>
<table class="center">
	<tr>
	<td class="member_new_style11">號碼球</td>
	<td class="member_new_style11">尺寸值</td>
	<td class="member_new_style11">級別</td>
	<td class="member_new_style11">公差</td>
	<td class="member_new_style11">基準1</td>
	<td class="member_new_style11">基準2</td>
	<td class="member_new_style11">基準3</td>
	<td class="member_new_style11">備註</td>
	<td class="member_new_style11">來源</td>
	</tr>
	<% for (int k = 0; k < seq3.size(); k++) { %>
	<tr>
	<td class="member_new_style10"><%= seq3.get(k) %></td>
	<td class="member_new_style10"><%= size3.get(k) %></td>
	<td class="member_new_style10"><%= grade3.get(k) %></td>
	<td class="member_new_style10"><%= tol3.get(k) %></td>
	<td class="member_new_style10"><%= base13.get(k) %></td>
	<td class="member_new_style10"><%= base23.get(k) %></td>
	<td class="member_new_style10"><%= base33.get(k) %></td>
	<td class="member_new_style10"><%= note3.get(k) %></td>
	<td class="member_new_style10"><%= srcFile3.get(k) %></td>
	</tr>
	<% } %>
</table>
<span class="member_new_style8">全部尺寸</span>
<table class="center">
	<tr>
	<td class="member_new_style11">號碼球</td>
	<td class="member_new_style11">尺寸值</td>
	<td class="member_new_style11">級別</td>
	<td class="member_new_style11">公差</td>
	<td class="member_new_style11">基準1</td>
	<td class="member_new_style11">基準2</td>
	<td class="member_new_style11">基準3</td>
	<td class="member_new_style11">備註</td>
	<td class="member_new_style11">來源</td>
	</tr>
	<% for (int k = 0; k < seq.size(); k++) { %>
	<tr>
	<td class="member_new_style10"><%= seq.get(k) %></td>
	<td class="member_new_style10"><%= size.get(k) %></td>
	<td class="member_new_style10"><%= grade.get(k) %></td>
	<td class="member_new_style10"><%= tol.get(k) %></td>
	<td class="member_new_style10"><%= base1.get(k) %></td>
	<td class="member_new_style10"><%= base2.get(k) %></td>
	<td class="member_new_style10"><%= base3.get(k) %></td>
	<td class="member_new_style10"><%= note.get(k) %></td>
	<td class="member_new_style10"><%= srcFile.get(k) %></td>
	</tr>
	<% } %>
</table>
</div>
</body>
</html>