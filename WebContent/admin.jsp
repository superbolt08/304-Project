<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>

<%
// TODO: Include files auth.jsp and jdbc.jsp (done)

<%@ include file="auth.jsp" %>
<%
    if (session.getAttribute("adminId") == null) {
        session.setAttribute("loginMessage", "You must log in as an admin to access this page.");
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%@ include file="jdbc.jsp" %>

%>
<%

// TODO: Write SQL query that prints out total order amount by day (done)

<%
    try {
        // Open database connection
        getConnection();

        // SQL query to calculate total sales per day
        String sql = "SELECT CAST(order_date AS DATE) AS SaleDate, SUM(total_amount) AS TotalSales " +
                     "FROM orders " +
                     "GROUP BY CAST(order_date AS DATE) " +
                     "ORDER BY SaleDate";

        PreparedStatement stmt = con.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();

        // Display the results
%>
        <h3>Total Sales Report</h3>
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
%>
        </table>
<%
        rs.close();
        stmt.close();
        closeConnection();
    } catch (Exception e) {
        e.printStackTrace();
%>
        <p>Error retrieving sales report. Please try again later.</p>
<%
    }
%>


%>

</body>
</html>

