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
     PreparedStatement stmt = con.prepareStatement("SELECT productId, productName, productPrice FROM product");
     ResultSet rst = stmt.executeQuery()) {	
	
	// Print header
	out.println("<h2>Products</h2>");

	NumberFormat currFormat = NumberFormat.getCurrencyInstance(); // Format currency
	
	// Process the result set and print it out
	while (rst.next()) {
		// Print product names from the result set
		int productId = rst.getInt("productId");
		String productName = rst.getString("productName");
		double productPrice = rst.getDouble("productPrice");

		// Format the price
		String formattedPrice = currFormat.format(productPrice);

		String link = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice;
		out.println("<p><a href=\"" + link + "\">" + productName + " - " + formattedPrice + "</a></p>");

	}
}
catch (SQLException ex) {
	System.err.println("SQLException: " + ex);
}


//TODO: All done

%>

</body>
</html>