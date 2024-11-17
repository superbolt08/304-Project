<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order Processing</title>
</head>
<body>

<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Make connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";

try ( Connection con = DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement();) 
{
	// Determine if valid customer id was entered
	String getCid = "SELECT customerId AS cid FROM customer";	//get all customer id from db
	ResultSet rst = stmt.executeQuery(getCid);

	boolean custIdExists = false;
	boolean prodListNotEmpty = false;

	//iterate through customer ids and see if any match the user input
	while (rst.next()) {
		String cid = String.valueOf(rst.getInt(1));
		if(cid.equals(custId)){
			custIdExists = true;
			break;
		}
	}
	if (productList != null) {	// Determine if there are products in the shopping cart
		prodListNotEmpty = true;
	}

	// remove later, just for trouble shooting
	if (custIdExists && prodListNotEmpty) {
		out.println("<p>both exist</p>");
	}
	else if(custIdExists){
		out.println("<p>custId exist but cart empty?</p>");
	}
	else if(prodListNotEmpty){
		out.println("<p>cart not empty but cust id not valid?</p>");
	}
	else {
		out.println("<p>this aint good. We're cooked</p>");
	}
}
catch (SQLException e1)
{
	System.err.println("SQLException: " + e1);
}

// If either are not true, display an error message

// Make connection

// Save order information to database


	/*
	// Use retrieval of auto-generated keys.
	PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
	ResultSet keys = pstmt.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);
	*/

// Insert each item into OrderProduct table using OrderId from previous INSERT

// Update total amount for order record

// Here is the code to traverse through a HashMap
// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price

/*
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
        String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
            ...
	}
*/

// Print out order summary

// Clear cart if order placed successfully
%>
</BODY>
</HTML>

