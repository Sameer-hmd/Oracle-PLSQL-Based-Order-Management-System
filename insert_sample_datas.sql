-- ========================================
-- Sample Data for E-Commerce Order Management System
-- ========================================

-- USERS: Admin, Sellers, Customers
INSERT INTO Users (UserID, Name, Email, Role) VALUES (1, 'Alice Admin', 'alice@admin.com', 'Admin');
INSERT INTO Users (UserID, Name, Email, Role) VALUES (2, 'Bob Seller', 'bob@seller.com', 'Seller');
INSERT INTO Users (UserID, Name, Email, Role) VALUES (3, 'Carol Customer', 'carol@buyer.com', 'Customer');
INSERT INTO Users (UserID, Name, Email, Role) VALUES (4, 'Dave Customer', 'dave@buyer.com', 'Customer');
INSERT INTO Users (UserID, Name, Email, Role) VALUES (5, 'Eve Seller', 'eve@seller.com', 'Seller');
INSERT INTO Users (UserID, Name, Email, Role) VALUES (6, 'Frank Customer', 'frank@buyer.com', 'Customer');
INSERT INTO Users (UserID, Name, Email, Role) VALUES (7, 'Grace Customer', 'grace@buyer.com', 'Customer');
INSERT INTO Users (UserID, Name, Email, Role) VALUES (8, 'Greg Admin', 'greg@admin.com', 'Admin');
INSERT INTO Users (UserID, Name, Email, Role) VALUES (9, 'Heidi Seller', 'heidi@seller.com', 'Seller');
INSERT INTO Users (UserID, Name, Email, Role) VALUES (10, 'Irene Customer', 'irene@buyer.com', 'Customer');
INSERT INTO Users (UserID, Name, Email, Role) VALUES (11, 'Jack Customer', 'jack@buyer.com', 'Customer');
INSERT INTO Users (UserID, Name, Email, Role) VALUES (12, 'Kelly Customer', 'kelly@buyer.com', 'Customer');

-- PRODUCTS by Seller
INSERT INTO Products (ProductID, SellerID, ProductName, Price, StockQty, Status)
VALUES (101, 2, 'Wireless Mouse', 799.00, 50, 'Active');
INSERT INTO Products (ProductID, SellerID, ProductName, Price, StockQty, Status)
VALUES (102, 2, 'Keyboard', 1299.00, 30, 'Active');
INSERT INTO Products (ProductID, SellerID, ProductName, Price, StockQty, Status)
VALUES (103, 2, 'USB-C Hub', 1599.00, 20, 'Active');
INSERT INTO Products (ProductID, SellerID, ProductName, Price, StockQty, Status)
VALUES (104, 5, 'Webcam 1080p', 2500.00, 15, 'Active');
INSERT INTO Products (ProductID, SellerID, ProductName, Price, StockQty, Status)
VALUES (105, 5, 'Gaming Headset', 3500.00, 25, 'Active');
INSERT INTO Products (ProductID, SellerID, ProductName, Price, StockQty, Status)
VALUES (106, 2, 'Ergonomic Chair', 15000.00, 10, 'Active');
INSERT INTO Products (ProductID, SellerID, ProductName, Price, StockQty, Status)
VALUES (107, 9, 'Wireless Charger', 2000.00, 40, 'Active');
INSERT INTO Products (ProductID, SellerID, ProductName, Price, StockQty, Status)
VALUES (108, 9, 'Smart Watch', 8500.00, 15, 'Active');
INSERT INTO Products (ProductID, SellerID, ProductName, Price, StockQty, Status)
VALUES (109, 2, 'Monitor Stand', 800.00, 60, 'Active');
INSERT INTO Products (ProductID, SellerID, ProductName, Price, StockQty, Status)
VALUES (110, 5, 'Noise Cancelling Headphones', 12000.00, 20, 'Active');
INSERT INTO Products (ProductID, SellerID, ProductName, Price, StockQty, Status)
VALUES (111, 2, 'Mechanical Keyboard', 2500.00, 0, 'Inactive');

-- ORDERS by Customers
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status)
VALUES (1001, 3, TO_DATE('2025-06-01', 'YYYY-MM-DD'), 2098.00, 'Pending');
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status)
VALUES (1002, 4, TO_DATE('2025-06-10', 'YYYY-MM-DD'), 1599.00, 'Shipped');
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status)
VALUES (1003, 6, TO_DATE('2025-07-05', 'YYYY-MM-DD'), 6000.00, 'Pending');
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status)
VALUES (1004, 7, TO_DATE('2025-07-15', 'YYYY-MM-DD'), 15000.00, 'Shipped');
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status)
VALUES (1005, 10, TO_DATE('2025-07-20', 'YYYY-MM-DD'), 2800.00, 'Shipped');
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status)
VALUES (1006, 11, TO_DATE('2025-07-22', 'YYYY-MM-DD'), 8500.00, 'Delivered');
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status)
VALUES (1007, 12, TO_DATE('2025-07-25', 'YYYY-MM-DD'), 12000.00, 'Pending');

-- ORDER ITEMS
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice)
VALUES (201, 1001, 101, 1, 799.00);
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice)
VALUES (202, 1001, 102, 1, 1299.00);
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice)
VALUES (203, 1002, 103, 1, 1599.00);
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice)
VALUES (204, 1003, 104, 1, 2500.00);
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice)
VALUES (205, 1003, 105, 1, 3500.00);
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice)
VALUES (206, 1004, 106, 1, 15000.00);
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice)
VALUES (207, 1005, 107, 1, 2000.00);
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice)
VALUES (208, 1005, 109, 1, 800.00);
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice)
VALUES (209, 1006, 108, 1, 8500.00);
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice)
VALUES (210, 1007, 110, 1, 12000.00);

-- PAYMENTS
INSERT INTO Payments (PaymentID, OrderID, PaymentDate, Amount, PaymentMethod, Status)
VALUES (301, 1001, TO_DATE('2025-06-01', 'YYYY-MM-DD'), 2098.00, 'Card', 'Paid');
INSERT INTO Payments (PaymentID, OrderID, PaymentDate, Amount, PaymentMethod, Status)
VALUES (302, 1002, TO_DATE('2025-06-10', 'YYYY-MM-DD'), 1599.00, 'UPI', 'Paid');
INSERT INTO Payments (PaymentID, OrderID, PaymentDate, Amount, PaymentMethod, Status)
VALUES (303, 1003, TO_DATE('2025-07-05', 'YYYY-MM-DD'), 6000.00, 'Credit Card', 'Paid');
INSERT INTO Payments (PaymentID, OrderID, PaymentDate, Amount, PaymentMethod, Status)
VALUES (304, 1004, TO_DATE('2025-07-15', 'YYYY-MM-DD'), 15000.00, 'Debit Card', 'Paid');
INSERT INTO Payments (PaymentID, OrderID, PaymentDate, Amount, PaymentMethod, Status)
VALUES (305, 1005, TO_DATE('2025-07-20', 'YYYY-MM-DD'), 2800.00, 'UPI', 'Paid');
INSERT INTO Payments (PaymentID, OrderID, PaymentDate, Amount, PaymentMethod, Status)
VALUES (306, 1006, TO_DATE('2025-07-22', 'YYYY-MM-DD'), 8500.00, 'Credit Card', 'Paid');
INSERT INTO Payments (PaymentID, OrderID, PaymentDate, Amount, PaymentMethod, Status)
VALUES (307, 1007, TO_DATE('2025-07-25', 'YYYY-MM-DD'), 12000.00, 'Card', 'Paid');

-- RETURNS
INSERT INTO Returns (ReturnID, OrderItemID, Reason, Status)
VALUES (401, 202, 'Wrong item delivered', 'Pending');
INSERT INTO Returns (ReturnID, OrderItemID, Reason, Status)
VALUES (402, 204, 'Item defective', 'Pending');

-- REFUNDS
INSERT INTO Refunds (RefundID, ReturnID, Amount, RefundDate, Status)
VALUES (501, 401, 1299.00, TO_DATE('2025-06-12', 'YYYY-MM-DD'), 'Processed');
INSERT INTO Refunds (RefundID, ReturnID, Amount, RefundDate, Status)
VALUES (502, 402, 2500.00, TO_DATE('2025-07-08', 'YYYY-MM-DD'), 'Processed');

-- View Tables
SELECT * FROM USERS;
SELECT * FROM ORDERS;
SELECT * FROM PRODUCTS;
SELECT * FROM ORDERITEMS;
SELECT * FROM PAYMENTS;
SELECT * FROM RETURNS;
SELECT * FROM REFUNDS;