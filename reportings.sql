-- ========================================================
-- Reporting for E-Commerce Order Management System
-- ========================================================

CREATE OR REPLACE PACKAGE Reporting_Pkg AS
-- Procedure to display the top N selling products by quantity
PROCEDURE Get_Top_Selling_Products (
    p_top_n IN NUMBER
);
    
-- Function to get the total number of orders for a specific customer
FUNCTION Get_Customer_Order_Count (
    p_customer_id IN NUMBER
) RETURN NUMBER;
    
-- Function to calculate total revenue within a date range
FUNCTION Get_Total_Revenue_By_Date (
    p_start_date IN DATE,
    p_end_date   IN DATE
) RETURN NUMBER;
END Reporting_Pkg;
/

CREATE OR REPLACE PACKAGE BODY Reporting_Pkg AS

PROCEDURE Get_Top_Selling_Products (
    p_top_n IN NUMBER
) 
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Top ' || p_top_n || ' Selling Products by Quantity ---');
    DBMS_OUTPUT.PUT_LINE('Product Name' || CHR(9) || 'Total Quantity Sold');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------');

    FOR rec IN (
        SELECT
            p.ProductName,
            SUM(oi.Quantity) AS TotalQuantitySold
            FROM
                OrderItems oi
            JOIN
                Products p ON oi.ProductID = p.ProductID
            GROUP BY
                p.ProductName
            ORDER BY
                TotalQuantitySold DESC
            FETCH FIRST p_top_n ROWS ONLY
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(rec.ProductName, 25) || rec.TotalQuantitySold);
    END LOOP;
END Get_Top_Selling_Products;

FUNCTION Get_Customer_Order_Count (
    p_customer_id IN NUMBER
) RETURN NUMBER 
IS
    v_order_count NUMBER;
BEGIN
    SELECT COUNT(OrderID)
    INTO v_order_count
    FROM Orders
    WHERE CustomerID = p_customer_id;

    RETURN v_order_count;
END Get_Customer_Order_Count;
    
FUNCTION Get_Total_Revenue_By_Date (
    p_start_date IN DATE,
    p_end_date   IN DATE
) RETURN NUMBER 
IS
    v_total_revenue NUMBER;
BEGIN
    SELECT NVL(SUM(Amount), 0)
    INTO v_total_revenue
    FROM Payments
    WHERE Status = 'Paid'
    AND PaymentDate >= p_start_date
    AND PaymentDate <= p_end_date;

    RETURN v_total_revenue;
END Get_Total_Revenue_By_Date;

END Reporting_Pkg;
/


-- View: Summary of each customer's purchasing activity,including their total orders and spending.
CREATE OR REPLACE VIEW V_Customer_Order_Summary AS
SELECT
    u.UserID,
    u.Name AS CustomerName,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(o.TotalAmount) AS TotalSpent
FROM
    Users u
JOIN
    Orders o ON u.UserID = o.CustomerID
WHERE
    u.Role = 'Customer'
GROUP BY
    u.UserID, u.Name;

-- View: Comprehensive look at each product's sales performance, linking it back to the seller.
CREATE OR REPLACE VIEW V_Product_Sales_Info AS
SELECT
    p.ProductID,
    p.ProductName,
    p.Price,
    u.Name AS SellerName,
    p.Status,
    NVL(SUM(oi.Quantity), 0) AS TotalQuantitySold,
    NVL(SUM(oi.Quantity * oi.UnitPrice), 0) AS TotalProductRevenue
FROM
    Products p
JOIN
    Users u ON p.SellerID = u.UserID
LEFT JOIN
    OrderItems oi ON p.ProductID = oi.ProductID
GROUP BY
    p.ProductID, p.ProductName, p.Price, u.Name, p.Status;

-- View: Detailed order analysis, joining all relevant tables to provide a complete picture of each transaction.
CREATE OR REPLACE VIEW V_Order_Details AS
SELECT
    o.OrderID,
    o.OrderDate,
    o.TotalAmount,
    o.Status AS OrderStatus,
    u.Name AS CustomerName,
    oi.OrderItemID,
    p.ProductName,
    oi.Quantity,
    oi.UnitPrice,
    (oi.Quantity * oi.UnitPrice) AS LineItemTotal
FROM
    Orders o
JOIN
    Users u ON o.CustomerID = u.UserID
JOIN
    OrderItems oi ON o.OrderID = oi.OrderID
JOIN
    Products p ON oi.ProductID = p.ProductID;

-- View: Tracking returns and their corresponding refunds
CREATE OR REPLACE VIEW V_Return_Refund_Details AS
SELECT
    r.ReturnID,
    r.Reason AS ReturnReason,
    r.Status AS ReturnStatus,
    r.OrderItemID,
    p.ProductName,
    f.RefundID,
    f.Amount AS RefundAmount,
    f.RefundDate,
    f.Status AS RefundStatus
FROM
    Returns r
JOIN
    OrderItems oi ON r.OrderItemID = oi.OrderItemID
JOIN
    Products p ON oi.ProductID = p.ProductID
LEFT JOIN
    Refunds f ON r.ReturnID = f.ReturnID;

