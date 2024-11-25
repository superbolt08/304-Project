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
    try {
        // Open database connection
        getConnection();

        // Get customer id
        String cid = request.getParameter("customerId");

        // get customer info from database
        String getCustomerInfo = "SELECT * FROM Customer WHERE customerId = ?";
        try (PreparedStatement pstmt = con.PreparedStatement(getCustomerInfo)) {
            pstmt.setInt(1, Integer.parseInt(cid));
            ResultSet rst = pstmt.executeQuery();
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

                // print customer info
                out.println("<table>
                                <tr><th>Id</th><td>"+cid+"</td></tr>
                                <tr><th>First Name</th><td>"+firstName+"</td></tr>
                                <tr><th>Last Name</th><td>"+lastName+"</td></tr>
                                <tr><th>Email</th><td>"+email+"</td></tr>
                                <tr><th>Phone</th><td>"+phonenum+"</td></tr>
                                <tr><th>Address</th><td>"+address+"</td></tr>
                                <tr><th>City</th><td>"+city+"</td></tr>
                                <tr><th>State</th><td>"+state+"</td></tr>
                                <tr><th>Postal Code</th><td>"+postalCode+"</td></tr>
                                <tr><th>Country</th><td>"+country+"</td></tr>
                                <tr><th>User Id</th><td>"+userid+"</td></tr>
                            </table>");
            }
            else {
                out.println("<p>Error: Could not find any info</p>");
            }
        } catch (SQLException e) {
            System.err.println("SQLException while retrieving customer info from DB: " + e);
        }
    } catch (Exception e) {
        e.printStackTrace(); // Print error to JSP output for debugging
		out.println("<p>Error while retrieving customer info</p>");
    }
%>

</body>
</html>