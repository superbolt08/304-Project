<!DOCTYPE html>
<html>
<head>
        <title>Baby Goat Sweater's Grocery Main Page</title>
        <link rel="stylesheet" type="text/css" href="./styles/styles.css">
</head>
<body>
<%@ include file="header.jsp"%>

<h2 align="center"><a href="login.jsp">Login</a></h2>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>

<h2 align="center"><a href="logout.jsp">Log out</a></h2>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
	if (userName != null)
		out.println("<h3 align=\"center\">Signed in as: "+userName+"</h3>");
%>

<h4 align="center"><a href="ship.jsp?orderId=1">Test Ship orderId=1</a></h4>

<h4 align="center"><a href="ship.jsp?orderId=3">Test Ship orderId=3</a></h4>


<%-- <%
    String currentUser = (String) session.getAttribute("username");
    if (currentUser != null) {
%>
        <p>Welcome, <%= currentUser %>!</p>
<%
    } else {
%>
        <p>Welcome, Guest!</p>
<%
    }
%> --%>

</body>
</head>


