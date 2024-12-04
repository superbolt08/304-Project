<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%

// Print out total order amount by day
String sql = "select year(orderDate), month(orderDate), day(orderDate), SUM(totalAmount) FROM OrderSummary GROUP BY year(orderDate), month(orderDate), day(orderDate)";

NumberFormat currFormat = NumberFormat.getCurrencyInstance();
//admin sales report
try 
{	
	out.println("<h3>Administrator Sales Report by Day</h3>");
	
	getConnection();
	Statement stmt = con.createStatement(); 
	stmt.execute("USE orders");

	ResultSet rst = con.createStatement().executeQuery(sql);		
	out.println("<table class=\"table\" border=\"1\">");
	out.println("<tr><th>Order Date</th><th>Total Order Amount</th>");	

	while (rst.next())
	{
		out.println("<tr><td>"+rst.getString(1)+"-"+rst.getString(2)+"-"+rst.getString(3)+"</td><td>"+currFormat.format(rst.getDouble(4))+"</td></tr>");
	}
	out.println("</table>");		
}
catch (SQLException ex) 
{ 	out.println(ex); 
}
finally
{	
	closeConnection();	
}

// list all customers
String sql2 = "SELECT * FROM customer";
try{
	getConnection();
	out.println("<h3>All customers</h3>");

	Statement stmt = con.createStatement();
	stmt.execute("USE orders"); // select the database

	ResultSet rst = con.createStatement().executeQuery(sql2); // execute query

	out.println("<table class=\"table\" border=\"1\">");
	out.println("<tr><th>Order Date</th><th>Total Order Amount</th>");	
	out.println("<tr><th>First Name</th><th>Last Name</th><th>Email</th><th>Phone Number</th><th>Address</th><th>City</th><th>State</th><th>Postal Code</th><th>Country</th><th>User ID</th><th>Password</th></tr>");

	while(rst.next()){ // output to table
		out.println("<tr><td>" 
    + rst.getString("firstName") + "</td><td>" 
    + rst.getString("lastName") + "</td><td>" 
    + rst.getString("email") + "</td><td>" 
    + rst.getString("phonenum") + "</td><td>" 
    + rst.getString("address") + "</td><td>" 
    + rst.getString("city") + "</td><td>" 
    + rst.getString("state") + "</td><td>" 
    + rst.getString("postalCode") + "</td><td>" 
    + rst.getString("country") + "</td><td>" 
    + rst.getString("userid") + "</td><td>" 
    + rst.getString("password") + "</td></tr>");
	}
	out.println("</table>");
}
catch (SQLException ex) 
{ 	out.println(ex); 
}
finally
{	
	closeConnection();	
}
%>

</body>
</html>

