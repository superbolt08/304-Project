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

// Declare variables outside the if block to make them accessible beyond the block
int customerId = 0;
String firstName = null;
String lastName = null;
String email = null;
String phoneNum = null;
String address = null;
String city = null;
String state = null;
String postalCode = null;
String country = null;
String userId = null;
String password = null;
java.util.Date utilDate = new java.util.Date();
java.sql.Date orderDate = new java.sql.Date(utilDate.getTime());

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
	
	// If either are not true, display an error message
    if (!custIdExists) {
        out.println("<p>Invalid Customer ID. Please try again.</p>");
        return;
    }

    if (!prodListNotEmpty) {
        out.println("<p>Your shopping cart is empty. Please add products before checkout.</p>");
        return;
    }

	//now that we now customer exists, save customer information

	String customerInformation = "SELECT * FROM customer WHERE customerId = ?"; 
    try (PreparedStatement pstmt = con.prepareStatement(customerInformation)) {
        pstmt.setInt(1, Integer.parseInt(custId));
        ResultSet rst = pstmt.executeQuery();
        if (rst.next()) {
			customerId = rst.getInt("customerId");  // Get the customer ID
			firstName = rst.getString("firstName");  // Get the first name
			lastName = rst.getString("lastName");  // Get the last name
			email = rst.getString("email");  // Get the email address
			phoneNum = rst.getString("phonenum");  // Get the phone number
			address = rst.getString("address");  // Get the address
			city = rst.getString("city");  // Get the city
			state = rst.getString("state");  // Get the state
			postalCode = rst.getString("postalCode");  // Get the postal code
			country = rst.getString("country");  // Get the country
			userId = rst.getString("userid");  // Get the user ID
			password = rst.getString("password");  // Get the password
        }
    }

	 // Step 3: Save Order Information to the Database
	 String sql = "INSERT INTO ordersummary (orderDate, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry, customerId) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    try (PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        // Set the prepared statement parameters
        pstmt.setDate(1, new java.sql.Date(orderDate.getTime()));  // Assuming orderDate is a java.util.Date object
        pstmt.setDouble(2, totalAmount);

        // Setting shipping fields
        pstmt.setString(3, address);  // shiptoAddress
        pstmt.setString(4, city);  // shiptoCity
        pstmt.setString(5, state);  // shiptoState
        pstmt.setString(6, postalCode);  // shiptoPostalCode
        pstmt.setString(7, country);  // shiptoCountry

        pstmt.setInt(8, customerId);  // customerId

        // Execute the insert and retrieve the generated orderId
        int rowsInserted = pstmt.executeUpdate();

        // Retrieve the generated orderId after the insert
        if (rowsInserted > 0) {
            ResultSet rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                int generatedOrderId = rs.getInt(1);  // Get the first generated key (orderId)
                System.out.println("Generated orderId: " + generatedOrderId);
            }
        }
    }
	

	

/*
		// Use retrieval of auto-generated keys.
		PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
		ResultSet keys = pstmt.getGeneratedKeys();
		keys.next();
		int orderId = keys.getInt(1);
		*/
	// PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
	// ResultSet keys = pstmt.getGeneratedKeys();
	// keys.next();
	// int orderId = keys.getInt(1);

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

	out.println("<h1> Your Order Summary </h1>");
	out.println("<table><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th>");
		if (productList != null) {
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
			while (iterator.hasNext())
			{ 
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				String productId = (String) product.get(0);
				String price = (String) product.get(2);
				double pr = Double.parseDouble(price);
				int qty = ( (Integer)product.get(3)).intValue();
				
				// Insert each item into OrderProduct table using OrderId from previous INSERT
				String sql2_InsertIntoOrderProduct = "INSERT INTO OrderProduct (orderId, productId, quantity, price)"
												+ " VALUES (?, ?, ?, ?)";
				try (PreparedStatement pstmt2 = con.prepareStatement(sql2_InsertIntoOrderProduct)) {
					pstmt2.setInt(2, productId);
					pstmt2.setInt(3, qty);
					pstmt2.setDouble(4, pr);

					// Execute the insert
					int rowsInserted = pstmt2.executeUpdate();
					if (rowsInserted > 0) {
						ResultSet rs = pstmt.getGeneratedKeys();
						if (rs.next()) {
							orderId = rs.getInt(1);  // Assign the generated orderId
							System.out.println("Generated orderId: " + orderId);
						}
						System.out.println("Inserted productId: " + productId + " with quantity: " + qty);
					}

				}catch(SQLException e){
					System.err.println("SQLException: " + e);
				}
	}
		// Update total amount for order record
		String sql3_UpdateTotalAmount = "UPDATE orderSummary SET totalAmount = totalAmount + ?"
									 + " WHERE orderId = ?";
		try(PreparedStatement pstmt3 = con.prepareStatement(sql3_UpdateTotalAmount)){
			pstmt3.setDouble(1, pr);
			pstmt3.setInt(2, orderId);

			//execute the update
			int rowsUpdated = pstmt3.executeUpdate();

		}catch(SQLException e){
			System.err.println("SQLException: " + e);
		}

		// Print out order summary
		out.println("<h2>Order Summary</h2>");
		out.println("<table border='1'><tr><th>Product ID</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");

		double grandTotal = 0.0;  // Initialize grand total for all products

		if (productList != null) {
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
			while (iterator.hasNext()) {
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = entry.getValue();

				String productId = (String) product.get(0);
				String productName = (String) product.get(1);
				double price = Double.parseDouble((String) product.get(2));
				int quantity = ((Integer) product.get(3)).intValue();
				double subtotal = price * quantity;

				// Print each product's details in the order summary
				out.println("<tr>");
				out.println("<td>" + productId + "</td>");
				out.println("<td>" + productName + "</td>");
				out.println("<td>" + quantity + "</td>");
				out.println("<td>" + NumberFormat.getCurrencyInstance().format(price) + "</td>");
				out.println("<td>" + NumberFormat.getCurrencyInstance().format(subtotal) + "</td>");
				out.println("</tr>");

				// Accumulate the subtotal to the grand total
				grandTotal += subtotal;
			}
		}

		// Display the grand total
		out.println("<tr><td colspan='4'><strong>Grand Total:</strong></td>");
		out.println("<td><strong>" + NumberFormat.getCurrencyInstance().format(grandTotal) + "</strong></td></tr>");
		out.println("</table>");

		// Clear cart if order placed successfully
		out.println("<tr><td colspan='4'><strong>Grand Total:</strong></td>");
		out.println("<td><strong>" + NumberFormat.getCurrencyInstance().format(grandTotal) + "</strong></td></tr>");
		out.println("</table>");

		// Step 5: Clear the cart if the order was placed successfully
		if (orderId > 0) {
			session.removeAttribute("productList");
			out.println("<p>Thank you for your order! Your cart has been cleared.</p>");
		} else {
			out.println("<p>There was an issue placing your order. Please try again.</p>");
		}
	}

	out.println("</table>"); // close ordersummary table
}
catch (SQLException e) {
	e.printStackTrace();  // Add proper error handling
}

// Make connection


%>
</BODY>
</HTML>

