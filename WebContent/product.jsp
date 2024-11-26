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
    // TODO (done) Get product ID from request parameters
    String productId = request.getParameter("id");

   // Debug: Check if productId is received
    out.println("<p>Debug: Product ID = " + productId + "</p>");

    if (productId != null) {
        try {
            // Get database connection
            java.sql.Connection connection = (java.sql.Connection) application.getAttribute("connection");

            // Debug: Check if connection exists
            if (connection == null) {
                out.println("<p>Error: No database connection found.</p>");
                return;
            }
            // Query to fetch product details
            String sql = "SELECT * FROM products WHERE id = ?";
            java.sql.PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, Integer.parseInt(productId));

            java.sql.ResultSet rs = preparedStatement.executeQuery();

            if (rs.next()) {
                String name = rs.getString("productName");
                String description = rs.getString("productDesc");
                double price = rs.getDouble("productPrice");
                String productImageURL = rs.getString("productImageURL");

                // Display product details
%>
                <div class="container">
                <h2><%= name %></h2>
                <p><%= description %></p>
                <p>Price: <%= NumberFormat.getCurrencyInstance().format(price) %></p>

                //TODO(done): If there is a productImageURL, display using IMG tag
                <% if (productImageURL != null && !productImageURL.isEmpty()) { %>
                    <img src="<%= productImageURL %>" alt="<%= name %>" style="max-width:300px;">
                <% } %>

                <img src="displayImage.jsp?id=<%= productId %>" alt="Product Image" style="max-width:300px;">
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
