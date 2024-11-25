<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>YOUR NAME Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	boolean orderIdExists = false;

	// TODO: Get order id
    String orderId = request.getParameter("orderId");

	// Make connection
	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
	String uid = "sa";
	String pw = "304#sa#pw";

	// DONE: Check if valid order id in database
	try (Connection con= DriverManager.getConnection(url, uid, pw);) {
		String getOrderId = "SELECT orderId FROM OrderProduct WHERE orderId = ?";
		try (PreparedStatement pstmt = con.PreparedStatement(getOrderId)) {
			pstmt.setInt(1, Integer.parseInt(orderId));
			ResultSet rst = pstmt.executeQuery();
			if (rst.next()) {
				orderIdExists = true;
			}
		}

		// if orderId not exist, display an error message
		if (!orderIdExists) {
			out.println("<p>Order ID doesnt exist. Please try again.</p>");
			return;
		}
	
		// TODO: Start a transaction (turn-off auto-commit)
		con.setAutoCommit(false);
		
		// TODO: Retrieve all items in order with given id
		// TODO: Create a new shipment record.
		// TODO: For each item verify sufficient quantity available in warehouse 1.
		// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
		
		// TODO: Auto-commit should be turned back on
	} catch (SQLException e) {
		System.err.println("SQLException while connecting to DB: " + e);
	}
%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
