package DBUtil;

import java.sql.*;

public class DB2Connection {
	//private String url = "jdbc:db2://192.168.21.110:61010/MESDBP1";
	//private String user = "sdiemfg";
	//private String password = "sdiemfg220208";
	private String url = "jdbc:db2://192.168.21.115:62010/HISDBP11";
	private String user = "sdiemfg1";
	private String password = "sdiemfg220208";
	private Connection con;
	private Statement stmt;
	private ResultSet rs;
    private String status = "";
    private int rsCount = 0;
	
	public DB2Connection(){
		try 
	    {                                                                        
	      // Load the driver
	      Class.forName("com.ibm.db2.jcc.DB2Driver"); 

	      // Create the connection using the IBM Data Server Driver for JDBC and SQLJ
	      con = DriverManager.getConnection (url, user, password);
	      // Commit changes manually
	      con.setAutoCommit(false);

	      // Create the Statement
	      stmt = con.createStatement();
	    }
	    
	    catch (ClassNotFoundException e)
	    {
	      System.err.println("Could not load JDBC driver");
	      System.out.println("Exception: " + e);
	      e.printStackTrace();
	    }

	    catch(SQLException ex)
	    {
	      System.err.println("SQLException information");
	      while(ex!=null) {
	        System.err.println ("Error msg: " + ex.getMessage());
	        System.err.println ("SQLSTATE: " + ex.getSQLState());
	        System.err.println ("Error code: " + ex.getErrorCode());
	        ex.printStackTrace();
	        ex = ex.getNextException(); // For drivers that support chained exceptions
	      }
	    }
		
	}
	
	public ResultSet QueryData(String queryString){
		try 
	    {  
			//Execute a query and generate a ResultSet instance
			rs = stmt.executeQuery(queryString);
	      
			// Close the ResultSet
			//rs.close();
	    }
	    catch(SQLException ex)
	    {
	      System.err.println("SQLException information");
	      while(ex!=null) {
	        System.err.println ("Error msg: " + ex.getMessage());
	        System.err.println ("SQLSTATE: " + ex.getSQLState());
	        System.err.println ("Error code: " + ex.getErrorCode());
	        ex.printStackTrace();
	        ex = ex.getNextException(); // For drivers that support chained exceptions
	      }
	    }
		return rs;
	}
	
	public void CloseQueryData(){
		try 
	    {
			// Close the ResultSet
			rs.close();
	    }
	    catch(SQLException ex)
	    {
	      System.err.println("SQLException information");
	      while(ex!=null) {
	        System.err.println ("Error msg: " + ex.getMessage());
	        System.err.println ("SQLSTATE: " + ex.getSQLState());
	        System.err.println ("Error code: " + ex.getErrorCode());
	        ex.printStackTrace();
	        ex = ex.getNextException(); // For drivers that support chained exceptions
	      }
	    }
	}
	
	public String getStatus(){
		return status;
	}
	
	public int getRsCount(){
		return rsCount;
	}
	
	public void finish(){
		try 
	    { 
		// Close the Statement
	      stmt.close();

	      // Connection must be on a unit-of-work boundary to allow close
	      con.commit();
	      System.out.println ( "**** Transaction committed" );
	      
	      // Close the connection
	      con.close(); 
	      System.out.println("**** Disconnected from data source");
	    }
	    catch(SQLException ex)
	    {
	      System.err.println("SQLException information");
	      while(ex!=null) {
	        System.err.println ("Error msg: " + ex.getMessage());
	        System.err.println ("SQLSTATE: " + ex.getSQLState());
	        System.err.println ("Error code: " + ex.getErrorCode());
	        ex.printStackTrace();
	        ex = ex.getNextException(); // For drivers that support chained exceptions
	      }
	    }
	}

}
