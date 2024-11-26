<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>Baby Goat Sweater's Grocery - Product Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<%
    // Database credentials
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
    String uid = "sa";
    String pw = "304#sa#pw";

    // Get product ID from request parameters
    String productId = request.getParameter("id");

    // Debug: Check if productId is received
   // out.println("<p>Debug: Product ID = " + productId + "</p>");

    if (productId != null) {
        try (
            // Establish database connection
            Connection con = DriverManager.getConnection(url, uid, pw);
            // Prepare the SQL statement
            PreparedStatement stmt = con.prepareStatement("SELECT * FROM product WHERE productId = ?")
        ) {
            // Debug: Check if connection exists
            // if (con == null) {
            //     out.println("<p>Error: No database connection found.</p>");
            //     return;
            // }

            // Set the product ID in the query
            stmt.setInt(1, Integer.parseInt(productId));

            // Execute the query
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String name = rs.getString("productName");
                String description = rs.getString("productDesc");
                double price = rs.getDouble("productPrice");
                String productImageURL = rs.getString("productImageURL");
                out.println("<p>"+productImageURL+"</p>");
                // Display product details
%>
                <div class="container">
                    <h2><%= name %></h2>
                    <p><%= description %></p>
                    <p>Price: <%= NumberFormat.getCurrencyInstance().format(price) %></p>

                    <!-- I dont know how to get the images to show -->

                    <!-- If there is a productImageURL, display using IMG tag -->
                    <% if (productImageURL != null && !productImageURL.isEmpty()) { %>
                        <img src="<%= productImageURL %>" alt="<%= name %>" style="max-width:300px;">
                    <% } %>

                    <!-- Display binary image -->
                    <img src="displayImage.jsp?id=<%= productId %>" alt="Product Image" style="max-width:300px;">

                    <!-- Links to add to cart and continue shopping -->
                    <a href="showcart.jsp" class="btn btn-primary">Add to Cart</a>
                    <a href="listprod.jsp" class="btn btn-secondary">Continue Shopping</a>
                </div>
<%
            } else {
                // Product not found
                out.println("<p>Error: No product found for ID: " + productId + "</p>");
            }
        } catch (NumberFormatException e) {
            out.println("<p>Error: Invalid product ID format.</p>");
            e.printStackTrace();
        } catch (Exception e) {
            out.println("<p>Error occurred: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    } else {
        // No product ID provided
        out.println("<p>Error: No product ID provided in the request.</p>");
    }
%>

</body>
</html>
