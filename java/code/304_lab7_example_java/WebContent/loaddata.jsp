<%@ page import="java.sql.*" %>
<%@ page import="java.util.Scanner" %>
<%@ page import="java.io.File" %>
<%@ page import="javax.servlet.jsp.*" %>

<html>
<head>
<title>Sample Data Loader</title>
</head>
<body>
<%!
void loadDataSS(String fileName, Connection con, JspWriter out) throws Exception
{    
    try
    {
        // Create statement
        Statement stmt = con.createStatement();    
    
        Scanner scanner = new Scanner(new File(fileName));        
        StringBuilder commands = new StringBuilder();
        while (scanner.hasNext())
        {
            String command = scanner.nextLine();
            if (!command.trim().equals("go"))
                commands.append(command+"\n");

            if (command.trim().equals(""))
                continue;

            // out.print(command+"<br>");        // Uncomment if want to see commands executed            
            try
            {
                if (command.trim().equals("go"))
                {
                    stmt.execute(commands.toString());
                    commands = new StringBuilder();
                }
            }
            catch (Exception e)
            {	// Keep running on exception.  This is mostly for DROP TABLE if table does not exist.
                out.print(e);
            }
        }	 
        scanner.close();                
        try
        {
            stmt.execute(commands.toString());
        }
        catch (Exception e)
        {	// Keep running on exception.  This is mostly for DROP TABLE if table does not exist.
            out.print(e);
        }
    }
    catch (Exception e)
    {
        out.print(e);
    }  
}

void loadData(String fileName, Connection con, JspWriter out) throws Exception
{
    try
    {
        // Create statement
        Statement stmt = con.createStatement();
        
        Scanner scanner = new Scanner(new File(fileName));
        // Read commands separated by ;
        scanner.useDelimiter(";");
        while (scanner.hasNext())
        {
            String command = scanner.next();
            if (command.trim().equals(""))
                continue;
            // out.print(command);        // Uncomment if want to see commands executed
            try
            {
                stmt.execute(command);
            }
            catch (Exception e)
            {	// Keep running on exception.  This is mostly for DROP TABLE if table does not exist.
                out.print(e);
            }
        }	 
        scanner.close();        
        // out.print("<br><br><h1>Database loaded.</h1>");
    }
    catch (Exception e)
    {
        out.print(e);
    }  
}
%>

<h3>Loading data into Microsoft SQL Server</h3>
<%
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=workson;TrustServerCertificate=True";
String uid = "SA";
String pw = "304#sa#pw";

out.print("<h3>Connecting to database.</h3>");
try (Connection con = DriverManager.getConnection(url, uid, pw);  )
{
    out.print("<h4>Loading workson database.</h4>");
    loadDataSS("/usr/local/tomcat/webapps/shop/ddl/SQLServer_WorksOn.ddl", con, out);
    loadDataSS("/usr/local/tomcat/webapps/shop/ddl/provstates.sql", con, out);
    out.print("<h3>Successful SQL Server data load.</h3>");
}
catch (Exception e)
{
    out.print(e);
}  
%>

<h3>Loading data into MySQL</h3>
<%
url = "jdbc:mysql://cosc304_mysql/workson";
uid = "testuser";
pw = "304testpw";

out.print("<h3>Connecting to database.</h3>");
try (Connection con = DriverManager.getConnection(url, uid, pw);  )
{
    out.print("<h4>Loading workson database.</h4>");
    loadData("/usr/local/tomcat/webapps/shop/ddl/workson_mysql.sql", con, out);
    loadData("/usr/local/tomcat/webapps/shop/ddl/provstates.sql", con, out);
    out.print("<h3>Successful MySQL data load.</h3>");
}
catch (Exception e)
{
    out.print(e);
}  
%>
</body>
</html> 
