<!-- COMPLETED -->
<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("index.jsp");		// Successful login
	else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;

		if(username == null || password == null)
				return null;
		if((username.length() == 0) || (password.length() == 0))
				return null;

		try 
		{
			// TODO (done): Check if userId and password match some customer account. If so, set retStr to be the username.
			getConnection();

            // SQL query to verify username and password
            String sql = "SELECT username, role FROM users WHERE username = ? AND password = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                retStr = rs.getString("username");
                String role = rs.getString("role");

                // Set session attributes based on role
                session.removeAttribute("loginMessage");
                session.setAttribute("authenticatedUser", username);
                if ("admin".equalsIgnoreCase(role)) {
                    session.setAttribute("adminId", username); // Set admin ID
                } else {
                    session.setAttribute("customerId", username); // Set customer ID
                }
            } else {
                session.setAttribute("loginMessage", "Invalid username or password.");
            }

            rs.close();
            stmt.close();

		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		
		if(retStr != null)
		{	session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
		}
		else
			session.setAttribute("loginMessage","Could not connect to the system using that username/password.");

		return retStr;
	}
%>

