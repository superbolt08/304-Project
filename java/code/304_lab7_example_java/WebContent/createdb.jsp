<%@ page import="java.sql.*" %>
<%@ page import="java.util.Scanner" %>
<%@ page import="java.io.File" %>
<%@ page import="javax.servlet.jsp.*" %>

<html>
<head>
<title>Creates SQL Server and MySQL Database</title>
</head>
<body>

<h3>Creating Microsoft SQL Server Database</h3>
<%
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

out.print("<h3>Connecting to database.</h3>");
try (Connection con = DriverManager.getConnection(url, uid, pw);  )
{    
    Statement stmt = con.createStatement();
    stmt.execute("CREATE DATABASE workson");
    out.print("<h3>Successful database creation.</h3>");
}
catch (Exception e)
{
    out.print(e);    
}  
%>

<h3>Creating MySQL Database</h3>
<%
url = "jdbc:mysql://cosc304_mysql";
uid = "root";
pw = "304rootpw";

try 
{	// Load driver class
	Class.forName("com.mysql.cj.jdbc.Driver");
}
catch (java.lang.ClassNotFoundException e) {
	System.err.println("ClassNotFoundException: " +e);	
}

try ( Connection con = DriverManager.getConnection(url, uid, pw);
      Statement stmt = con.createStatement();) 
{		
    stmt.execute("CREATE DATABASE IF NOT EXISTS workson");	
    stmt.execute("GRANT ALL PRIVILEGES ON workson.* TO testuser");	
}
catch (SQLException ex) 
{ 	out.println(ex); 
}
%>

</body>
</html> 
