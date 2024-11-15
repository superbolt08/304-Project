<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Baby Goat Sweaters Shop</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}


// Question starts here !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

// connection details
String url = "jdbc:sqlserver://localhost;databaseName=WorksOn;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";
	
//prepare connect
try (Connection con = DriverManager.getConnection(url, uid, pw);
     PreparedStatement stmt = con.prepareStatement("SELECT productName FROM product");
     ResultSet rst = stmt.executeQuery()) {	
	
	// Print header
	out.println("<h2>Products</h2>");
	
	// Process the result set and print it out
	while (rst.next()) {
		// Print product names from the result set
		String productName = rst.getString("productName");
		out.println("<p>" + productName + "</p>");
	}
}
catch (SQLException ex) {
	System.err.println("SQLException: " + ex);
}


//TODO: 

// For each product create a link of the form
// addcart.jsp?id=productId&name=productName&price=productPrice
// Close connection

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00
%>

</body>
</html>