package DBUtil;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.json.*;

public class MySQLConnection {
	//connection to Mysql
	private String JDBC_DRIVER = "com.mysql.jdbc.Driver";  
	private String DB_URL = "";
	private Connection conn = null;
	private Statement statement = null;
	private ResultSet result = null;
	private JSONObject resultJSON = new JSONObject();
	private SQLException ex = null;
	private String status = "";
	
	public void ConnectDNS(){
		DB_URL = "jdbc:mysql://192.168.150.99:3306/dns";  //?serverTimezone=UTC driver需配合MYSQL版本
	    String dbuser = "dns_admin";
	    String dbpwd = "0531nwa";

	    try {
	    	//註冊JDBC Driver
		    Class.forName(JDBC_DRIVER);
			//建立資料庫連線
		    conn= DriverManager.getConnection(DB_URL,dbuser,dbpwd);
		    statement = conn.createStatement();
		    status = "Connected!";
		    System.out.println("DNS Connected!");
	    } catch (SQLException e) {
	    	e.printStackTrace();
	    	status = e.toString();
	    } catch (ClassNotFoundException e) {
	        e.printStackTrace();
	        status = e.toString();
	    }

	}
	
	public String getStatus(){
		return status;
	}

	//general use-------------------------------------------------------------------------------------
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
				for (int m = 0; m < nameList.size(); m++) { //starting at 0
					//valueList.add(result.getString(nameList.get(m)));
					resultJSON.put(nameList.get(m), result.getString(nameList.get(m)));
				}
				status = "done";
			} else {
				status = "no next result";
			}
			
		} catch (SQLException e) {
	        ex = e;
	    } finally {
	    	return resultJSON;
	    }
	}

	
	public void update(String updateString){
		try {
	        //query data
            statement.executeUpdate(updateString);
	    } catch (SQLException e) {
	        ex = e;
	    }
	}
	
	//user only-------------------------------------------------------------------------------------
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
	
	public JSONObject getUserResultJSON(){
		return resultJSON;
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
