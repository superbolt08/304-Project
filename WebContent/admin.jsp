<!-- Find out how to log in as admin -->
<%@ page session="true" %>
<%@ page language="java" import="java.io.*, java.sql.*, java.text.NumberFormat" %>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>

<%
    // Ensure the user is logged in as an admin
    if (session.getAttribute("adminId") == null) {
        session.setAttribute("loginMessage", "You must log in as an admin to access this page.");
        try {
            response.sendRedirect("login.jsp");
        } catch (Exception e) {
            out.println("Error while redirecting: " + e.getMessage());
        }
        return; // Stop further processing after redirect
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
</head>
<body>



<h3>Total Sales Report</h3>
<%
    // Database credentials
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
    String uid = "sa";
    String pw = "304#sa#pw";
    
    try (
        // Establish database connection
        Connection con = DriverManager.getConnection(url, uid, pw);
        
        // Prepare the SQL statement
        PreparedStatement stmt = con.prepareStatement(
            "SELECT CAST(orderDate AS DATE) AS SaleDate, SUM(totalAmount) AS TotalSales " +
            "FROM orderSummary " +
            "GROUP BY CAST(orderDate AS DATE) " +
            "ORDER BY SaleDate"
        )
    ) {
        ResultSet rs = stmt.executeQuery();

        // Display the results
%>
        <table border="1">
            <tr>
                <th>Date</th>
                <th>Total Sales</th>
            </tr>
<%
        while (rs.next()) {
            String date = rs.getString("SaleDate");
            double totalSales = rs.getDouble("TotalSales");
%>
            <tr>
                <td><%= date %></td>
                <td><%= NumberFormat.getCurrencyInstance().format(totalSales) %></td>
            </tr>
<%
        }
        rs.close();
        stmt.close();
        closeConnection();
    } catch (Exception e) {
        e.printStackTrace(); // Print error to JSP output for debugging
%>
        <p>Error retrieving sales report. Please try again later.</p>
<%
    }
%>

</table>

</body>
</html>
