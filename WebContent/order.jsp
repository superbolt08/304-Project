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

boolean custIdExists = false;
boolean prodListNotEmpty = (productList != null && !productList.isEmpty());
int orderId = 0;
double totalAmount = 0.0;

try (Connection con = DriverManager.getConnection(url, uid, pw)) {
    // Step 1: Validate Customer ID
    String getCid = "SELECT customerId FROM customer WHERE customerId = ?"; //usesa parmeter instead of a search
    try (PreparedStatement pstmt = con.prepareStatement(getCid)) {
        pstmt.setInt(1, Integer.parseInt(custId));
        ResultSet rst = pstmt.executeQuery();
        if (rst.next()) {
            custIdExists = true;
        }
    }

    if (!custIdExists) {
        out.println("<p>Invalid Customer ID. Please try again.</p>");
        return;
    }

    if (!prodListNotEmpty) {
        out.println("<p>Your shopping cart is empty. Please add products before checkout.</p>");
        return;
    }

	// Save order information to database
	String sql = "SELECT orderId FROM ...";
		/*
		// Use retrieval of auto-generated keys.
		PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
		ResultSet keys = pstmt.getGeneratedKeys();
		keys.next();
		int orderId = keys.getInt(1);
		*/
	PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
	ResultSet keys = pstmt.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);

	// Insert each item into OrderProduct table using OrderId from previous INSERT
	String query = "INSERT INTO OrderProduct VALUES ("+orderId+", "+productId+", "+quantity+", "+price+")";
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

}
catch (SQLException e1)
{
	System.err.println("SQLException: " + e1);
}

// If either are not true, display an error message

// Make connection


%>
</BODY>
</HTML>

