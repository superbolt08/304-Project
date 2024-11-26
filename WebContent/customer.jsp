<%@ page session="true" %>
<%@ page language="java" import="java.io.*, java.sql.*, java.text.NumberFormat" %>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>

<%
    // Ensure the user is logged in as a customer
    if (session.getAttribute("customerId") == null) {
        session.setAttribute("loginMessage", "You must log in as a customer to access this page.");
        try {
            response.sendRedirect("login.jsp");
        } catch (Exception e) {
            out.println("Error while redirecting: " + e.getMessage());
        }
        return; // Stop further processing after redirect
    }
%>

<html>
<head>
<title>Customer Info Page</title>
<style>
	table, th, td {
  		border:1px solid black;
	}
</style>
</head>
<body>

<%
    // Database credentials
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
    String uid = "sa";
    String pw = "304#sa#pw";
    
    try (
        // Establish database connection
        Connection con = DriverManager.getConnection(url, uid, pw);
        
        // Prepare the SQL statement
        PreparedStatement stmt = con.prepareStatement("SELECT * FROM customer WHERE userid = ?")
    ) {
        // Get customer id
        String cid = request.getParameter("userid");
        out.println("userid: " + request.getParameter("userid"));

        // Check if the customer ID is null or empty
        if (cid == null || cid.isEmpty()) {
            out.println("<p>Error: No customerId provided</p>");
            return;
        }

        // Get customer info from database
        stmt.setInt(1, Integer.parseInt(cid));
        ResultSet rst = stmt.executeQuery();
        
        if (rst.next()) {
            String firstName = rst.getString("firstName");
            String lastName = rst.getString("lastName");
            String email = rst.getString("email");
            String phonenum = rst.getString("phonenum");
            String address = rst.getString("address");
            String city = rst.getString("city");
            String state = rst.getString("state");
            String postalCode = rst.getString("postalCode");
            String country = rst.getString("country");
            String userid = rst.getString("userid");

            // Print customer info in a table
            out.println("<table>" +
                "<tr><th>Id</th><td>" + cid + "</td></tr>" +
                "<tr><th>First Name</th><td>" + firstName + "</td></tr>" +
                "<tr><th>Last Name</th><td>" + lastName + "</td></tr>" +
                "<tr><th>Email</th><td>" + email + "</td></tr>" +
                "<tr><th>Phone</th><td>" + phonenum + "</td></tr>" +
                "<tr><th>Address</th><td>" + address + "</td></tr>" +
                "<tr><th>City</th><td>" + city + "</td></tr>" +
                "<tr><th>State</th><td>" + state + "</td></tr>" +
                "<tr><th>Postal Code</th><td>" + postalCode + "</td></tr>" +
                "<tr><th>Country</th><td>" + country + "</td></tr>" +
                "<tr><th>User Id</th><td>" + userid + "</td></tr>" +
            "</table>");
        } else {
            out.println("<p>Error: No customer found with ID: " + cid + "</p>");
        }
    } catch (SQLException e) {
        // Catch and print SQL exceptions for debugging
        out.println("<p>Error while retrieving customer info from DB: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } catch (Exception e) {
        // Catch any other exceptions and display error message
        out.println("<p>Error while retrieving customer info: " + e.getMessage() + "</p>");
        e.printStackTrace(); // Print the full stack trace for debugging
    }
%>

</body>
</html>
