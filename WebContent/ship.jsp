<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>YOUR NAME Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	// DONE: Get order id
    String orderId = request.getParameter("orderId");

	// Make connection
	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
	String uid = "sa";
	String pw = "304#sa#pw";

	// DONE: Check if valid order id in database
	try (Connection con= DriverManager.getConnection(url, uid, pw);) {
		boolean orderIdExists = false;
		String getOrderId = "SELECT orderId FROM OrderProduct WHERE orderId = ?";
		try (PreparedStatement pstmt = con.PreparedStatement(getOrderId)) {
			pstmt.setInt(1, Integer.parseInt(orderId));
			ResultSet rst = pstmt.executeQuery();
			if (rst.next()) {
				orderIdExists = true;
			}
		} catch (SQLException e) {
			System.err.println("SQLException while validating order ID: " + e);
		}

		// if orderId not exist, display an error message
		if (!orderIdExists) {
			out.println("<p>Order ID doesnt exist. Please try again.</p>");
			return;
		}
	
		// DONE: Start a transaction (turn-off auto-commit)
		con.setAutoCommit(false);
		
		// DONE: Retrieve all items in order with given id
		ArrayList<Integer> itemList = new ArrayList<Integer>();	// arraylist to store all retrived items

		String getItems = "SELECT * FROM OrderProduct WHERE orderId = ?";
		try (PreparedStatement pstmt = con.PreparedStatement(getItems)) {
			pstmt.setInt(1, Integer.parseInt(orderId));
			ResultSet rst = pstmt.executeQuery();

			while (rst.next()) {
				int productId = rst.getInt("productId");
				int quantity = rst.getInt("quantity");
				int price = rst.getInt("price");

				itemList.add({productId, quantity, price});
			}
			
		} catch (SQLException e) {
			System.err.println("SQLException while retrieving items using this order ID: " + e);
		}

		// DONE: Create a new shipment record.
		int warehouseId = 1;
		ArrayList<Integer> failedShipmentProductIds = new ArrayList<Integer>(); // arraylist to store productIds of all "insuffi-stock" items
		
		// iterate through itemList and for each item, add to shipment
		for (int i = 0; i < itemList.size(); i++) {
			int pid = itemList.get(i)[0];
			int qty = itemList.get(i)[1];

			String newShipment = "INSERT INTO Shipment (shipmentId, shipmentDate, shipmentDesc, warehouseId)"
						+ " VALUES(?, ?, ?, ?)";
			try (PreparedStatement pstmt = con.PreparedStatement(newShipment)) {
				pstmt.setInt(1, orderId);
				pstmt.setDate(2, new java.sql.Date(orderDate.getTime()));
				pstmt.setString(3, "Product: "+pid+", Qty: "+qty);
				pstmt.setInt(4, warehouseId);

				pstmt.executeUpdate(); // insert into Shipment transaction pending
			} catch (SQLException e) {
				System.err.println("SQLException while insert into Shipment: " + e);
			}

			// DONE: For each item verify sufficient quantity available in warehouse 1.
			String checkProductQty = "SELECT quantity FROM ProductInventory WHERE productId = ? AND warehouseId = ?";
			try (PreparedStatement pstmt = con.PreparedStatement(checkProductQty)) {
				pstmt.setInt(1, pid);
				pstmt.setInt(2, warehouseId);

				ResultSet rst = pstmt.executeQuery();

				if (rst.next()) {
					// DONE: If any item does not have sufficient inventory, cancel transaction and rollback. 
					//       Otherwise, update inventory for each item.
					int productQty = rst.getInt("quantity");

					if (productQty < qty) { // insufficient inventory, so rollback insert into Shipment transaction
						con.rollback();
						failedShipmentProductIds.add(pid); 
					}
					else {	
						con.commit();	// sufficient inventory, so commit insert into Shipment transaction

						// update product inventory
						int newProductQty = productQty - qty;
						String updateInventory = "UPDATE ProductInventory SET quantity = ? WHERE productId = ? AND warehouseId = ?";
						try (PreparedStatement pstmt2 = con.PreparedStatement(checkProductQty)) {
							pstmt2.setInt(1, newProductQty);
							pstmt2.setInt(2, pid);
							pstmt2.setInt(3, warehouseId);
							pstmt2.executeUpdate();

							con.commit();	// commit the update to product inventory

							out.println("<p>Ordered product: "+pid+" Qty: "+qty+" Previous inventory: "+productQty+" New Inventory: "+newProductQty+"</p>");
						} catch (SQLException e) {
							System.err.println("SQLException while updating ProductInventory: " + e);
						}
					}
				}
				else {
					System.out.println("product Id and/or warehouse Id does not exist");
				}
			} catch (SQLException e) {
				System.err.println("SQLException while verifying inventory of product: " + e);
			}
			
		}

		// print success or fail message regarding the shipment processing
		if (failedShipmentProductIds.size() == 0) {
			out.println("<h2>Shipment successfully processed.</h2>");
		}
		else {
			failedShipmentProductIds.forEach (
				(n) -> out.println("<h2>Shipment not done. Insufficient inventory for product id: "+n+"</h2>");
			);
		}
			
		// DONE: Auto-commit should be turned back on
		con.setAutoCommit(true);

	} catch (SQLException e) {
		System.err.println("SQLException while connecting to DB: " + e);
	}
%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
