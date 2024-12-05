<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>

<%
// Insert user into the database
String insertUserSQL = "INSERT INTO customer (email, userid, address, password) VALUES (?, ?, ?, ?)";

// Check if the form has been submitted
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

    // String email = request.getParameter("email");
    // String username = request.getParameter("username");
	// String address = request.getParameter("address");
    // String password = request.getParameter("password");

    // String registerMessage = null;

    // if (email == null || username == null || address == null || password == null || 
    //     email.isEmpty() || username.isEmpty() || address.isEmpty() || password.isEmpty()) {
    //     registerMessage = "All fields are required.";
    //     session.setAttribute("registerMessage", registerMessage);
    //     response.sendRedirect("register.jsp");
    //     return;
    // }

	// try{
	// 	getConnection();

	// 	String checkUserExists = "SELECT * FROM customer WHERE email = ? AND userid = ?";
	// 	PreparedStatement checkStmt = con.prepareStatement(checkUserExists);
    //     checkStmt.setString(1, email);
	// 	checkStmt.setString(2, username);
    //     ResultSet rs = checkStmt.executeQuery();

	// 	if (rs.next()) {
	// 		 out.println("User exists, updating information...");
    //         // Update the existing password and address
    //         String updatePasswordQuery = "UPDATE customer SET password = ?, address = ? WHERE email = ? AND userid = ?";
    //         PreparedStatement updateStmt = con.prepareStatement(updatePasswordQuery);
    //         updateStmt.setString(1, password);
    //         updateStmt.setString(2, email);
	// 		updateStmt.setString(3, address);
    //         updateStmt.setString(4, username);
    //         updateStmt.executeUpdate();

    //         registerMessage = "Password updated successfully.";
    //     } else {
	// 		out.println("User does not exist, creating new user...");
    //         // Insert new account
    //         String insertAccountQuery = "INSERT INTO customer (email, userid, address, password) VALUES (?, ?, ?, ?)";
    //         PreparedStatement insertStmt = con.prepareStatement(insertAccountQuery);
	// 		insertStmt.setString(1, email);
	// 		insertStmt.setString(2, username);
	// 		insertStmt.setString(3, address);
	// 		insertStmt.setString(4, password);
    //         insertStmt.executeUpdate();

    //         registerMessage = "Registration successful!";
    //     }
	// 	session.setAttribute("registerMessage", registerMessage);
    //     session.setAttribute("authenticatedUser", username);
    //     response.sendRedirect("index.jsp");

    // } catch (SQLException e) {
    //     registerMessage = "Error: " + e.getMessage();
    //     session.setAttribute("registerMessage", registerMessage);
    //     response.sendRedirect("register.jsp");
    // } finally {
    //     closeConnection();
	// }
%>