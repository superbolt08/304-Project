<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order List</title>
</head>
<body>

<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection
String url = "jdbc:sqlserver://localhost;databaseName=WorksOn;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";
	
try ( Connection con = DriverManager.getConnection(url, uid, pw);
		Statement stmt = con.createStatement();) 
{	
	// Write query to retrieve all order summary records
	String query = "SELECT * FROM ordersummary";
	ResultSet rst = stmt.executeQuery(query);
	out.println("<h2>Order Id	Order Date	Customer Id	Customer Name	Total Amount</h2>")
	while (rst.next()) {
		out.println("")
	}
}
catch (SQLException ex)
{
	System.err.println("SQLException: " + ex);
}

// Write query to retrieve all order summary records

// For each order in the ResultSet

	// Print out the order summary information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
		// Write out product information 

// Close connection
%>

</body>
</html>

