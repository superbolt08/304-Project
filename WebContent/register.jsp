<!DOCTYPE html>
<html>
<head>
    <title>Register Page</title>
</head>
<body>
<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>


<% 
//Register User
String insertUserSQL = "INSERT INTO customer (email, userid, address, password) VALUES (?, ?, ?, ?)";
if (request.getParameter("register-submit") != null) {
    String email = request.getParameter("email");
    String username = request.getParameter("username");
    String address = request.getParameter("address");
    String password = request.getParameter("password");

    try {
        // Establish database connection
        getConnection();
        Statement stmt = con.createStatement();
        stmt.execute("USE orders"); // Select the database

        PreparedStatement pstmt = con.prepareStatement(insertUserSQL);

        // Set parameters
        pstmt.setString(1, email);
        pstmt.setString(2, username);
        pstmt.setString(3, address);
        pstmt.setString(4, password);

        // Execute the insert query
        int rowsInserted = pstmt.executeUpdate();
        if (rowsInserted > 0) {
            out.println("<p>User registered successfully!</p>");
        }
    } catch (SQLException ex) {
        out.println("<p>Error registering user: " + ex.getMessage() + "</p>");
    } finally {
        closeConnection();
    }
}
%>

<h1>Register User / Forgot password/ Update User info</h1>

<!-- Register User -->
<form method="post" name="register-form">
    <h3>Register New User</h3>
    <table>
        <tr>
            <td>Email:</td>
            <td><input type="email" name="email" required></td>
        </tr>
        <tr>
            <td>Username:</td>
            <td><input type="text" name="username" maxlength="10" required></td>
        </tr>
        <tr>
            <td>Address:</td>
            <td><input type="text" name="address" maxlength="20" required></td>
        </tr>
        <tr>
            <td>Password:</td>
            <td><input type="password" name="password" maxlength="10" required></td>
        </tr>
    </table>
    <input type="submit" name="register-submit" value="Register">
</form>


</body>
</html>
