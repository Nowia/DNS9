<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*,java.text.*" %>
<%@page import="org.json.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.sql.Statement"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>newSTASetMySQL</title>
<%
final class MySQLConnection {
	//connection to Mysql
	String JDBC_DRIVER = "com.mysql.jdbc.Driver";  
	String DB_URL = "jdbc:mysql://192.168.150.99:3306/dns";  //?serverTimezone=UTC driver需配合MYSQL版本
	Connection conn = null;
	Statement statement = null;
	ResultSet result = null;
	JSONObject resultJSON = new JSONObject();
	SQLException ex = null;
	String status = "";
	
	
	public void newConnection(){

	    String dbuser = "dns_admin";
	    String dbpwd = "0531nwa";

	    try {
	    	//註冊JDBC Driver
		    Class.forName(JDBC_DRIVER);
			//建立資料庫連線
		    conn= DriverManager.getConnection(DB_URL,dbuser,dbpwd);
		    statement = conn.createStatement();
		    status = "Connected!";
		    System.out.println("Connected!");
	    } catch (SQLException e) {
	    	e.printStackTrace();
	    	status = e.toString();
	    } catch (ClassNotFoundException e) {
	        e.printStackTrace();
	        status = e.toString();
	    }

	}
	
	//general use
	@SuppressWarnings("finally")
	public JSONObject queryOneResult(String queryString){
		try {
			List<String> nameList = new ArrayList<String>();
	        //query data
            result = statement.executeQuery(queryString);
            

			ResultSetMetaData rsmd = result.getMetaData();
			resultJSON.clear();
			//get column names
			for (int i = 1; i <= rsmd.getColumnCount(); i++) { //starting at 1
				nameList.add( rsmd.getColumnName(i));
			}
				//get value
			if (result.next()) {	
				for (int m = 1; m <= nameList.size(); m++) {
					//valueList.add(result.getString(nameList.get(m)));
					resultJSON.put(nameList.get(m), result.getString(nameList.get(m)));
				}
			}

		} catch (SQLException e) {
	        ex = e;
	    } finally {
	    	return resultJSON;
	    }
	}
	
	//user only
	public void queryUser(String id){
		try {
	        //query data
            result = statement.executeQuery("SELECT * FROM dns.user WHERE id='"+ id +"';");
            
            String job_number = null;
            String name = null;
            String role = null;
            String email = null;
            String statusUser = null;
            String job = null;
            
            while (result.next()) {
            	job_number = result.getString("job_number");
            	name = result.getString("name");
            	role = result.getString("role");
            	email = result.getString("email");
            	statusUser = result.getString("status");
            	job = result.getString("job");
            }
            
            resultJSON.clear();
            resultJSON.put("job_number", job_number);
            resultJSON.put("name", name);
            resultJSON.put("role", role);
            resultJSON.put("email", email);
            resultJSON.put("status", statusUser);
            resultJSON.put("job", job);
            
            status = id+"-"+name;

	    } catch (SQLException e) {
	        ex = e;
	    }
	}
	
	public void finish(){
		if (statement != null) {
            try {
                statement.close();
            }
            catch(SQLException e) {
                if(ex == null) {
                    ex = e;
                }
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                if(ex == null) {
                    ex = e;
                }
            }
        }
        if(ex != null) {
            throw new RuntimeException(ex);
        }
	}
}
%>
</head>
<body>
<%
request.setCharacterEncoding("UTF-8");
String moldName = request.getParameter("moldName");
String plateSeq = request.getParameter("plateSeq");
String allSTANames = request.getParameter("allSTANames");

//from MySQL
MySQLConnection moldQuery = new MySQLConnection();
moldQuery.newConnection();
JSONObject projectData = moldQuery.queryOneResult("SELECT * FROM dns.project WHERE name='"+ moldName +"';");


out.println(projectData+"<br>");

//moldQuery.queryUser("Vincentchen");
//out.println(moldQuery.resultJSON);

moldQuery.finish();
%>

</body>
</html>