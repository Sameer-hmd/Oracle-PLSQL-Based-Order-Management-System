-- ==========================================================================
-- E-Commerce Order Management System: Table Creation with Performance Tuning
-- ==========================================================================

-- USERS
CREATE TABLE Users (
    UserID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Email VARCHAR2(100),
    Role VARCHAR2(20) CHECK (Role IN ('Admin', 'Seller', 'Customer'))
);

-- PRODUCTS
CREATE TABLE Products (
    ProductID NUMBER PRIMARY KEY,
    SellerID NUMBER,
    ProductName VARCHAR2(100),
    Price NUMBER(10, 2),
    StockQty NUMBER,
    Status VARCHAR2(20) CHECK (Status IN ('Active', 'Inactive')),
    FOREIGN KEY (SellerID) REFERENCES Users(UserID)
);

-- ORDERS
CREATE TABLE Orders (
    OrderID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    OrderDate DATE,
    TotalAmount NUMBER(10, 2),
    Status VARCHAR2(20) CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')),
    FOREIGN KEY (CustomerID) REFERENCES Users(UserID)
);

-- ORDER ITEMS
CREATE TABLE OrderItems (
    OrderItemID NUMBER PRIMARY KEY,
    OrderID NUMBER,
    ProductID NUMBER,
    Quantity NUMBER,
    UnitPrice NUMBER(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- PAYMENTS
CREATE TABLE Payments (
    PaymentID NUMBER PRIMARY KEY,
    OrderID NUMBER,
    PaymentDate DATE,
    Amount NUMBER(10,2),
    PaymentMethod VARCHAR2(20),
    Status VARCHAR2(20) CHECK (Status IN ('Paid', 'Failed', 'Refunded')),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- RETURNS
CREATE TABLE Returns (
    ReturnID NUMBER PRIMARY KEY,
    OrderItemID NUMBER,
    Reason VARCHAR2(200),
    Status VARCHAR2(20) CHECK (Status IN ('Pending', 'Approved', 'Rejected')),
    FOREIGN KEY (OrderItemID) REFERENCES OrderItems(OrderItemID)
);

-- REFUNDS
CREATE TABLE Refunds (
    RefundID NUMBER PRIMARY KEY,
    ReturnID NUMBER,
    Amount NUMBER(10,2),
    RefundDate DATE,
    Status VARCHAR2(20) CHECK (Status IN ('Processed', 'Failed')),
    FOREIGN KEY (ReturnID) REFERENCES Returns(ReturnID)
);

-- Indexes
CREATE INDEX idx_order_status ON Orders(Status);
CREATE INDEX idx_product_status ON Products(Status);
CREATE INDEX idx_orderitem_order_product ON OrderItems(OrderID, ProductID);
CREATE INDEX idx_user_email ON Users(Email);

-- View Tables
SELECT * FROM USERS;
SELECT * FROM ORDERS;
SELECT * FROM PRODUCTS;
SELECT * FROM ORDERITEMS;
SELECT * FROM PAYMENTS;
SELECT * FROM RETURNS;
SELECT * FROM REFUNDS;