<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Ray's Grocery - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<%
// Get product name to search for

<a href="product.jsp?id=<%= product.getId() %>"><%= product.getName() %></a>

// TODO: Retrieve and display info for the product
 String productId = request.getParameter("id");
 if (productId != null) {
        try {
            String sql = "SELECT * FROM products WHERE id = ?";
            java.sql.Connection connection = (java.sql.Connection) application.getAttribute("connection");
            java.sql.PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, Integer.parseInt(productId));
            java.sql.ResultSet rs = preparedStatement.executeQuery();

            if (rs.next()) {
                String name = rs.getString("productName");
                String description = rs.getString("productDesc");
                double price = rs.getDouble("productPrice");
                String productImageURL = rs.getString("productImageURL");

                <h2><%= name %></h2>
                <p><%= description %></p>
                <p>Price: <%= NumberFormat.getCurrencyInstance().format(price) %></p>

                if (productImageURL != null && !productImageURL.isEmpty()) {
%>
                <img src="<%= productImageURL %>" alt="<%= name %>" style="max-width:300px;">
<%

%>
                <img src="displayImage.jsp?id=<%= productId %>" alt="Product Image" style="max-width:300px;">
                <a href="showcart.jsp" class="btn btn-primary">Add to Cart</a>
                <a href="listprod.jsp" class="btn btn-secondary">Continue Shopping</a>
<%
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    
        
    }


// TODO: If there is a productImageURL, display using IMG tag
		
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
		
// TODO: Add links to Add to Cart and Continue Shopping
%>

</body>
</html>

