<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<title>Baby Goat Sweaters Shop</title>
	<link rel="stylesheet" type="text/css" href="./styles/styles.css">
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
		


// Question starts here !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

// connection details


	
//prepare connect
String query = "SELECT productId, productName, productPrice FROM product";
if (name != null && !name.trim().isEmpty()) {
    query += " WHERE productName LIKE ?";
}

// Set the query parameter to search for product names containing the input text
try {
	getConnection();
	PreparedStatement stmt = con.prepareStatement(query);
	
    if (name != null && !name.trim().isEmpty()) {
        stmt.setString(1, "%" + name + "%");
    }
    ResultSet rst = stmt.executeQuery();


	// Print header
    out.println("<h2>Products</h2>");
    out.println("<table border='1'><tr><th>Product ID</th><th>Product Name</th><th>Price</th></tr>");

	NumberFormat currFormat = NumberFormat.getCurrencyInstance(); // Format currency
	
	// Process the result set and print it out
	while (rst.next()) {
		// Print product names from the result set
		int productId = rst.getInt("productId");
		String productName = rst.getString("productName");
		double productPrice = rst.getDouble("productPrice");

		// CHANGES MADE HERE - [Added a link to open `product.jsp` with the specific product ID passed as a parameter]
		String productLink = "product.jsp?id=" + productId; 

		// Format the price
		String formattedPrice = currFormat.format(productPrice);

		String link = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice;
		
		out.println("<tr>");
        out.println("<td>" + productId + "</td>");
        out.println("<td><a href=\"" + productLink + "\">" + productName + "</a></td>");
        out.println("<td>" + formattedPrice + "</td>");
        out.println("</tr>");

	}
	out.println("</table>");
}
catch (SQLException ex) {
	System.err.println("SQLException: " + ex);
}


//TODO: All done

%>

</body>
</html>