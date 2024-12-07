<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<html>
<head>
<title>Ray's Grocery - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body align='center'>

<%@ include file="header.jsp" %>

<%
// check if user is signed in (option to leave review appears if signed in (and havent reviewed before) )
String userName = (String) session.getAttribute("authenticatedUser");

// Get product name to search for
String productId = request.getParameter("id");

String getProduct = "SELECT productId, productName, productPrice, productImageURL, productImage FROM Product P  WHERE productId = ?";

NumberFormat currFormat = NumberFormat.getCurrencyInstance();

try 
{
	getConnection();
	Statement stmt = con.createStatement(); 			
	stmt.execute("USE orders");
	
	PreparedStatement pstmtGetProd = con.prepareStatement(getProduct);
	pstmtGetProd.setInt(1, Integer.parseInt(productId));			
	
	ResultSet rst = pstmtGetProd.executeQuery();
			
	if (!rst.next())
	{
		out.println("Invalid product");
	}
	else
	{		
		out.println("<h2>"+rst.getString(2)+"</h2>");
		
		int prodId = rst.getInt(1);
		out.println("<table border='1' style='width:60%; margin:auto;'><tr>");
		out.println("<th>Id</th><td>" + prodId + "</td></tr>"				
				+ "<tr><th>Price</th><td>" + currFormat.format(rst.getDouble(3)) + "</td></tr>");
		
		//  Retrieve any image with a URL
		String imageLoc = rst.getString(4);
		if (imageLoc != null)
			out.println("<img src=\""+imageLoc+"\">");
		
		// Retrieve any image stored directly in database
		String imageBinary = rst.getString(5);
		if (imageBinary != null)
			out.println("<img src=\"displayImage.jsp?id="+prodId+"\">");	
		out.println("</table>");
		

		out.println("<h3><a href=\"addcart.jsp?id="+prodId+ "&name=" + rst.getString(2)
								+ "&price=" + rst.getDouble(3)+"\">Add to Cart</a></h3>");		
		
		out.println("<h3><a href=\"listprod.jsp\">Continue Shopping</a>");
	// review system
	// 	// check if user is signed in, if not signed in, dont show form and instead, show message saying need to sign in to review product
	// 	if (session.getAttribute("authenticatedUser") == null) {
	// 		out.println("<div style='width:60%; margin:auto; position:relative;'>"+
	// 						"<div style='filter:blur(3px); padding:5px;'>"+
	// 							"<h3 align='left' style='margin-top:0;'>Review Product</h3>"+
	// 							"<div align='left' style='display: flex;'>"+
	// 								"<span>Rating (from 1 to 5): </span>"+
	// 								"<div style='width:30px; height:18px;  border: solid 1px; margin-left: 10px;'></div>"+
	// 							"</div>"+
	// 							"<br>"+
	// 							"<div style='width:100%; height:70px; border: solid 1px;'></div>"+
	// 							"<button>Submit</button><button>Clear</button>"+
	// 						"</div>"+
	// 						"<div style='position:absolute; top:0; width:100%; height:100%; background-color: rgba(0, 0, 0, 0.015);'>"+
	// 							"<h2 style='position:absolute; margin:0; left:0; right:0; top:40%;'>Sign in to leave a review!</h2>"+
	// 						"</div>"+
	// 					"</div>"+
	// 					"<br>");
	// 	}
	// 	else { // if signed in, then...
	// 		// get the customer id
	// 		String getCid = "SELECT customerId FROM Customer WHERE userid = ?";
	// 		PreparedStatement ptmtGetCid = con.prepareStatement(getCid);
	// 		ptmtGetCid.setString(1, userName);
	// 		ResultSet rst2 = ptmtGetCid.executeQuery();
	// 		if (rst2.next()) { // if successfully got the customer id, then...
	// 			int cid = rst2.getInt(1); // save the id in variable cid

	// 			// check if the user has already reviewed the item before (only 1 review per user per product)
	// 			String checkIfReviewed = "SELECT * FROM Review WHERE customerId = ? and productId = ?";
	// 			PreparedStatement ptmtCheckIfRvw = con.prepareStatement(checkIfReviewed);
	// 			ptmtCheckIfRvw.setInt(1, cid);
	// 			ptmtCheckIfRvw.setInt(2, Integer.parseInt(productId));
	// 			ResultSet rst3 = ptmtCheckIfRvw.executeQuery();

	// 			// if they have, then show thank you message instead of showing the form for leaving review
	// 			if (rst3.next()) {
	// 				out.println("<h2 style='width:60%; margin:auto; padding: 20px 0px; background-color: rgba(0, 0, 0, 0.03);'>You've reviewed this product already! We appreciate you feedback!</h2>");
	// 			}
	// 			else { // otherwise, check if they have purchased this item before
	// 				String checkIfPurchased = "SELECT * FROM OrderSummary os JOIN OrderProduct op ON os.orderId = op.orderId "
	// 										+ "WHERE customerId = ? and productId = ?";
	// 				PreparedStatement ptmtCheckIfPrchsd = con.prepareStatement(checkIfPurchased);
	// 				ptmtCheckIfPrchsd.setInt(1, cid);
	// 				ptmtCheckIfPrchsd.setInt(2, Integer.parseInt(productId));
	// 				ResultSet rst4 = ptmtCheckIfPrchsd.executeQuery();
	// 				if (!rst4.next()) {	// if they havent, then show message saying need to purchase before review
	// 					out.println("<div style='width:60%; margin:auto; position:relative;'>"+
	// 									"<div style='filter:blur(3px); padding:5px;'>"+
	// 										"<h3 align='left' style='margin-top:0;'>Review Product</h3>"+
	// 										"<div align='left' style='display: flex;'>"+
	// 											"<span>Rating (from 1 to 5): </span>"+
	// 											"<div style='width:30px; height:18px;  border: solid 1px; margin-left: 10px;'></div>"+
	// 										"</div>"+
	// 										"<br>"+
	// 										"<div style='width:100%; height:70px; border: solid 1px;'></div>"+
	// 										"<button>Submit</button><button>Clear</button>"+
	// 									"</div>"+
	// 									"<div style='position:absolute; top:0; width:100%; height:100%; background-color: rgba(0, 0, 0, 0.015);'>"+
	// 										"<h2 style='position:absolute; margin:0; left:0; right:0; top:40%;'>Purchase item to leave a review!</h2>"+
	// 									"</div>"+
	// 								"</div>"+
	// 								"<br>");
	// 				}
	// 				else { // if they have, then show the form for leaving review
	// 					out.println("<form method='post' name='prod-review' style='width:60%; margin:auto;'>"+
	// 									"<h3 align='left'>Review Product</h3>"+
	// 									"<div align='left'>"+
	// 										"<label for='rating'>Rating (from 1 to 5): </label>"+
	// 										"<input type='number' name='rating' min='1' max='5' value='1'>"+
	// 									"</div>"+
	// 									"<br>"+
	// 									"<textarea type='text' name='review' rows='5' style='resize:none; width:100%;' placeholder='Leave a comment' maxlength='1000'></textarea>"+
	// 									"<input type='submit' name='prodreview-submit' value='Submit'><input type='reset' value='Clear'>"+
	// 								"</form>"+
	// 								"<br>");

	// 					// sql query for insert new review
	// 					String insertReview = "INSERT INTO Review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, ?, ?, ?, ?)";

	// 					if (request.getParameter("prodreview-submit") != null && cid != null) {
	// 						PreparedStatement pstmtInsertRvw = con.prepareStatement(insertReview);

	// 						// Set parameters
	// 						pstmtInsertRvw.setInt(1, Integer.parseInt(request.getParameter("rating"))); // review rating
	// 						pstmtInsertRvw.setTimestamp(2, new java.sql.Timestamp(new Date().getTime())); // review date
	// 						pstmtInsertRvw.setInt(3, cid);					// customer id
	// 						pstmtInsertRvw.setInt(4, Integer.parseInt(productId));		// product id
	// 						pstmtInsertRvw.setString(5, request.getParameter("review")); // review comment

	// 						// Execute the insert query
	// 						pstmtInsertRvw.executeUpdate();
	// 					}	
	// 				}				
	// 			}
	// 		}
	// 		else {
	// 			out.println("<p>Error while retrieving customer id</p>")
	// 		}

	// 	}
		
	// 	// show existing reviews in a table
	// 	out.println("<table class='table' border='1' style='width:60%; margin:auto; text-align:left; word-break:break-word;'>"
    // 				+"	<tr><th colspan='2' align='center' style='font-size: large;'>Customer Reviews</th></tr>");

	// 	String getReviews = "SELECT reviewRating, reviewDate, reviewComment, userid "
	// 					  + "FROM Review r JOIN Customer c ON r.customerId = c.customerId WHERE productId = ?"
	// 					  + "ORDER BY reviewDate ASC";
	// 	PreparedStatement pstmtGetRvws = con.prepareStatement(getReviews);
	// 	pstmtGetRvws.setInt(1, Integer.parseInt(productId));

	// 	ResultSet rst2 = pstmtGetRvws.executeQuery();

	// 	while (rst2.next()) {
	// 		int rating = rst2.getInt(1);
	// 		Date date = rst2.getDate(2);
	// 		String comment = rst2.getString(3);
	// 		String userid = rst2.getString(4);
	// 		out.println("<tr><td style='padding: 2px;'>");
	// 		out.println("<div style='padding: 3px;'>"+
	// 						"<p style='margin-top:3px;'>Rating: "+rating+"</p>"+
	// 						"<p style='margin:0; margin-bottom:3px;'>"+date+"</p>"+
	// 					"</div>"+
	// 					"<div style='background-color: rgba(0, 0, 0, 0.05); padding: 3px;'>"+
	// 						"<p style='margin:3px 0px;'>Reviewed on <span style='color: blue;'>"+comment+"</span> by </p>"+
	// 						"<p style='white-space:nowrap; text-overflow:ellipsis; overflow:hidden;margin:0; color: green;'>"+userid+"</p>"+
	// 					"</div>");
	// 		out.println("</td></tr>");
	// 	}
	// 	out.println("</table>");
	 }
} 
catch (SQLException ex) {
	out.println(ex);
}
finally
{
	closeConnection();
}
%>

</body>
</html>

