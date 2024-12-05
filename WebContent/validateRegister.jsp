<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>

<%
    String email = request.getParameter("email");
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    String registerMessage = null;

    if (email == null || username == null || password == null || 
        email.isEmpty() || username.isEmpty() || password.isEmpty()) {
        registerMessage = "All fields are required.";
        session.setAttribute("registerMessage", registerMessage);
        response.sendRedirect("register.jsp");
        return;
    }

	try{
		getConnection();

		String checkUserExists = "SELECT * FROM customer WHERE email = ? AND userid = ?";
		PreparedStatement checkStmt = con.prepareStatement(checkUserExists);
        checkStmt.setString(1, username);
        ResultSet rs = checkStmt.executeQuery();

		if (rs.next()) {
            // Update the existing password
            String updatePasswordQuery = "UPDATE customer SET password = ? WHERE email = ? AND userid = ?";
            PreparedStatement updateStmt = con.prepareStatement(updatePasswordQuery);
            updateStmt.setString(1, password);
            updateStmt.setString(2, email);
            updateStmt.setString(3, username);
            updateStmt.executeUpdate();

            registerMessage = "Password updated successfully.";
        } else {
            // Insert new account
            String insertAccountQuery = "INSERT INTO customer (email, userid, password) VALUES (?, ?, ?)";
            PreparedStatement insertStmt = con.prepareStatement(insertAccountQuery);
            insertStmt.setString(1, email);
            insertStmt.setString(2, username);
            insertStmt.setString(3, password);
            insertStmt.executeUpdate();

            registerMessage = "Registration successful!";
		out.println(registerMessage);
        }
		session.setAttribute("registerMessage", registerMessage);
        session.setAttribute("authenticatedUser", username);
        response.sendRedirect("index.jsp");

    } catch (SQLException e) {
        registerMessage = "Error: " + e.getMessage();
        session.setAttribute("registerMessage", registerMessage);
        response.sendRedirect("register.jsp");
    } finally {
        closeConnection();
	}
%>