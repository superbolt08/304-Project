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

// Update user in the database
String updateUserSQL = "UPDATE customer SET firstName = ?, lastName = ?, phonenum = ?, address = ?, city = ?, state = ?, postalCode = ?, country = ? WHERE userid = ? AND email = ? AND password = ?";

// Check if the form has been submitted
if (request.getParameter("update-submit") != null) {
    String email = request.getParameter("email");
    String username = request.getParameter("existing-username");
    String password = request.getParameter("password");
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String phonenum = request.getParameter("phonenum");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country = request.getParameter("country");
    out.println("Email: " + email);
    out.println("Username: " + username);

    try {
        // Establish database connection
        getConnection();
        Statement stmt = con.createStatement();
        stmt.execute("USE orders"); // Select the database

        PreparedStatement pstmt = con.prepareStatement(updateUserSQL);

        // Set parameters
        pstmt.setString(1, firstName);
        pstmt.setString(2, lastName);
        pstmt.setString(3, phonenum);
        pstmt.setString(4, address);
        pstmt.setString(5, city);
        pstmt.setString(6, state);
        pstmt.setString(7, postalCode);
        pstmt.setString(8, country);
        pstmt.setString(9, username); // Use username, email, password to identify the record
        pstmt.setString(10, email);  
        pstmt.setString(11, password);

        // Execute the update query
        int rowsUpdated = pstmt.executeUpdate();
        if (rowsUpdated > 0) {
            out.println("<p>User information updated successfully!</p>");
        } else {
            out.println("<p>No matching user found to update.</p>");
        }
    } catch (SQLException ex) {
        out.println("<p>Error updating user: " + ex.getMessage() + "</p>");
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

<!-- Update User -->
<form method="post" name="update-form">
    <h3>Update User Information</h3>
    <table>
        <tr>
            <td>Existing Username:</td>
            <td><input type="text" name="existing-username" maxlength="10" required></td>
        </tr>
        <tr>
            <td>Existing Email:</td>
            <td><input type="email" name="email" required></td>
        </tr>
        <tr>
            <td>Password:</td>
            <td><input type="password" name="password" required></td>
        </tr>
        <td>Fields to change are below</td>
        <tr>
            <td>First Name:</td>
            <td><input type="text" name="firstName" required></td>
        </tr>
        <tr>
            <td>Last Name:</td>
            <td><input type="text" name="lastName" required></td>
        </tr>
        <tr>
            <td>Phone Number:</td>
            <td><input type="tel" name="phonenum" required></td>
        </tr>
        <tr>
            <td>Address:</td>
            <td><input type="text" name="address" required></td>
        </tr>
        <tr>
            <td>City:</td>
            <td><input type="text" name="city" required></td>
        </tr>
        <tr>
            <td>State:</td>
            <td><input type="text" name="state" required></td>
        </tr>
        <tr>
            <td>Postal Code:</td>
            <td><input type="text" name="postalCode" required></td>
        </tr>
        <tr>
            <td>Country:</td>
            <td><input type="text" name="country" required></td>
        </tr>
    </table>
    <input type="submit" name="update-submit" value="Update User">
</form>

</body>
</html>
