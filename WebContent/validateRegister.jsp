<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>

<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		authenticatedUser = validateRegister(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("index.jsp");		// Successful registration
	else
		response.sendRedirect("register.jsp");		// Failed registration - redirect back to registration page with a message 
%>

<%!
	String validateRegister(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String email = request.getParameter("email");
        String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;

		if(email == null || username == null || password == null)
				return null;
		if((email.length() == 0) || (username.length() == 0) || (password.length() == 0))
				return null;

		try 
		{
			getConnection();
			Statement stmt = con.createStatement(); 
			stmt.execute("USE orders");

            // check if this account exists (ie. an account with the inputed email and username)
            // exists -> update password
            // not exist -> create a new entry (new account) in customer table with the email, username, and password (everything else null)
			String doesAccountExist = "SELECT email, userid FROM Customer WHERE email = ? and userid = ?";
			PreparedStatement pstmt = con.prepareStatement(doesEmailExist);			
			pstmt.setString(1, email);
            pstmt.setString(2, username);
			ResultSet rst = pstmt.executeQuery();	
			if (rst.next()) { // acount exists
                String updatePw = "UPDATE Customer SET password = ? WHERE email = ? and userid = ?";
			    PreparedStatement pstmt2 = con.prepareStatement(updatePw);			
			    pstmt.setString(1, password);
                pstmt.setString(2, email);
                pstmt.setString(3, username);
			    ResultSet rst2 = pstmt.executeUpdate();

                retStr = username;
            }
            else { // acount does not exist
                Statement stmt2 = con.createStatement(); 
			    ResultSet rst2 = stmt2.execute("SELECT COUNT(*) as rows FROM Customer"); // get number of rows (number of accounts) in Customer
                if (rst2.next()) {
                    int cid = rst2.getInt(rows)+1; // customer id for the new account = number of existing accounts + 1 (i am assuming that accounts cannot be deleted, so this should this shoudl give a unique id)
                    String newAccount = "INSERT INTO Customer (customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password)"
                                     + " VALUES (?, null, null, ?, null, null, null, null, null, null, ?, ?)";
                    PreparedStatement pstmt2 = con.prepareStatement(updatePw);			
                    pstmt2.setInt(1, cid);
                    pstmt2.setString(2, email);
                    pstmt2.setString(3, username);
                    pstmt2.setString(4, password);
                    rst2 = pstmt2.executeUpdate();

                    retStr = username;
                }
            }
						
		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		
		if(retStr != null)
		{	session.removeAttribute("registerMessage");
			session.setAttribute("authenticatedUser",username);
            out.println("<script> function rmRegisSessionAttr(){sessionStorage.removeItem('fromRegister');} rmRegisSessionAttr();)()</script>");
		}
		else
			session.setAttribute("registerMessage","Could not register the account. Please try again.");

		return retStr;
	}
%>