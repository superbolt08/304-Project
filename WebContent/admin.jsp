<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.sql.*, java.text.NumberFormat" %>
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

// Insert product into database
String insertSQL = "INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES (?, ?, ?, ?)";
    // Check if the form has been submitted
    if (request.getParameter("add-submit") != null) {
        String productName = request.getParameter("productName");
        String categoryId = request.getParameter("categoryId");
        String productDesc = request.getParameter("productDesc");
        String productPrice = request.getParameter("productPrice");
		 try {
            // Establish database connection
            getConnection();
			Statement stmt = con.createStatement();
			stmt.execute("USE orders"); // select the database

            PreparedStatement pstmt = con.prepareStatement(insertSQL);
			

            // Set parameters
            pstmt.setString(1, productName);
            pstmt.setInt(2, Integer.parseInt(categoryId));
            pstmt.setString(3, productDesc);
            pstmt.setDouble(4, Double.parseDouble(productPrice));

            // Execute the insert query
            int rowsInserted = pstmt.executeUpdate();
            if (rowsInserted > 0) {
                out.println("<p>Product added successfully!</p>");
            }
        } catch (SQLException ex) {
            out.println("<p>Error inserting product: " + ex.getMessage() + "</p>");
        } finally {
            closeConnection();
        }
	}

// Update product into database
String updateSQL = "UPDATE product SET productName = ?, categoryId = ?, productDesc = ?, productPrice = ? WHERE productName = ?";
    // Check if the form has been submitted
    if (request.getParameter("update-submit") != null) {
        String productName = request.getParameter("productName");
        String categoryId = request.getParameter("categoryId");
        String productDesc = request.getParameter("productDesc");
        String productPrice = request.getParameter("productPrice");
		String existingProductName = request.getParameter("existingProductName"); // Old product name

		 try {
            // Establish database connection
            getConnection();
			Statement stmt = con.createStatement();
			stmt.execute("USE orders"); // select the database

            PreparedStatement pstmt = con.prepareStatement(updateSQL);
			

            // Set parameters
            pstmt.setString(1, productName);
            pstmt.setInt(2, Integer.parseInt(categoryId));
            pstmt.setString(3, productDesc);
            pstmt.setDouble(4, Double.parseDouble(productPrice));
      		pstmt.setString(5, existingProductName); // WHERE clause

            // Execute the insert query
            int rowsInserted = pstmt.executeUpdate();
            if (rowsInserted > 0) {
                out.println("<p>Product updated successfully!</p>");
            }
        } catch (SQLException ex) {
            out.println("<p>Error updating product: " + ex.getMessage() + "</p>");
        } finally {
            closeConnection();
        }
	}
%>

<form method="post" name = "add-submit">
    <h3>Enter New Product</h3>
    <table>
        <tr>
            <td>Product Name:</td>
            <td><input type="text" name="productName" required></td>
        </tr>
        <tr>
            <td>Category ID:</td>
            <td><input type="number" name="categoryId" required></td>
        </tr>
        <tr>
            <td>Product Description:</td>
            <td><textarea name="productDesc" required></textarea></td>
        </tr>
        <tr>
            <td>Product Price:</td>
            <td><input type="number" step="0.01" name="productPrice" required></td>
        </tr>
    </table>
    <input type="submit" name="add-submit" value="Add Product">
</form>

<form method="post" name = "update-submit">
    <h3>Update Product</h3>
    <table>
		<tr>
            <td>Existing Product Name:</td>
            <td><input type="text" name="existingProductName" required></td>
        </tr>
        <tr>
            <td>Product Name:</td>
            <td><input type="text" name="productName" required></td>
        </tr>
        <tr>
            <td>Category ID:</td>
            <td><input type="number" name="categoryId" required></td>
        </tr>
        <tr>
            <td>Product Description:</td>
            <td><textarea name="productDesc" required></textarea></td>
        </tr>
        <tr>
            <td>Product Price:</td>
            <td><input type="number" step="0.01" name="productPrice" required></td>
        </tr>
    </table>
    <input type="submit" name="update-submit" value="Update Product">
</form>

<form method="post" name = "delete-submit">
    <h3>Delete Product</h3>
    <table>
		<tr>
            <td>Delete Product by Name:</td>
            <td><input type="text" name="existingProductName" required></td>
        </tr>
    </table>
    <input type="submit" name="delete-submit" value="Delete Product">
</form>

</body>
</html>

