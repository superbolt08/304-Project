<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order List</title>
<style>
	table, th, td {
  		border:1px solid black;
	}
</style>
</head>
<body>

<h1>Order List</h1>

<%
out.println("<table width: 100%;><th>Order Id</th><th>Order Date</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th>");

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
// out.println(currFormat.format(5.0));  // Prints $5.00

// Make connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";

NumberFormat currFormat = NumberFormat.getCurrencyInstance();

// auto-closes connection with try-catch-with-resource
try ( Connection con = DriverManager.getConnection(url, uid, pw);
		Statement stmt = con.createStatement();) 
{	

	// Write query to retrieve all order summary records
	String query = "SELECT orderId, orderDate, c.customerId, (c.firstName + ' ' + c.lastName) AS fullName, totalAmount"
				+ " FROM ordersummary o JOIN customer c ON c.customerId = o.customerId";
	ResultSet rst = stmt.executeQuery(query);

	while (rst.next()) {
		int orderId = rst.getInt(1);
		Date orderDate = rst.getDate(2);
		int cid = rst.getInt(3);
		String fullName = rst.getString(4);
		double totalAmount = rst.getDouble(5);
		
		out.println("<tr><td>"+orderId+"</td><td>"+orderDate+"</td><td>"+cid+"</td><td>"+fullName+"</td><td>"+currFormat.format(totalAmount)+"</td></tr>");	
		
		// sub table
		out.println("<tr align='right'><td colspan='4'>");
		out.println("<table><th>Product Id</th><th>Quantity</th><th>Price</th>");
		
		String query2 = "SELECT productId, quantity, price FROM orderProduct WHERE orderId = ?";
		try(PreparedStatement pstmt = con.prepareStatement(query2))
		{
			pstmt.setInt(1, orderId);
			ResultSet rst2 = pstmt.executeQuery();

			while (rst2.next()) {
				int pid = rst2.getInt(1);
				int quantity = rst2.getInt(2);
				double price = rst2.getDouble(3);

				out.println("<tr><td>"+pid+"</td><td>"+quantity+"</td><td>"+currFormat.format(price)+"</td></tr>");
			}
		}
		catch(SQLException e2)
		{
			System.err.println("SQLException: " + e2);
		}
		out.println("</table>");
		out.println("</td></tr>");
	}
}
catch (SQLException e1)
{
	System.err.println("SQLException: " + e1);
	//out.println("<p>SQLException: " + e1.getMessage() + "</p>");
}

// Write query to retrieve all order summary records

// For each order in the ResultSet

	// Print out the order summary information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
		// Write out product information 

// Close connection

out.println("</table>");
%>

</body>
</html>

