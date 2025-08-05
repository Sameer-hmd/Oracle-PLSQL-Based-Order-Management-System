-- ========================================================
-- Stored Procedures for E-Commerce Order Management System
-- ========================================================

-- PROCEDURE: Place Order
CREATE OR REPLACE PROCEDURE Place_Order (
    p_OrderID        IN NUMBER,
    p_CustomerID     IN NUMBER,
    p_ProductID      IN NUMBER,
    p_Quantity       IN NUMBER
)
AS
    v_UnitPrice      NUMBER;
    v_TotalAmount    NUMBER;
    v_StockQty       NUMBER;
BEGIN
    -- Get current stock and unit price
    SELECT Price, StockQty INTO v_UnitPrice, v_StockQty
    FROM Products
    WHERE ProductID = p_ProductID;

    IF v_StockQty < p_Quantity THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient stock.');
    END IF;

    -- Insert into Orders
    INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status)
    VALUES (p_OrderID, p_CustomerID, SYSDATE, v_UnitPrice * p_Quantity, 'Pending');

    -- Insert into OrderItems
    INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice)
    VALUES (p_OrderID + 100, p_OrderID, p_ProductID, p_Quantity, v_UnitPrice);

    -- Update stock
    UPDATE Products
    SET StockQty = StockQty - p_Quantity
    WHERE ProductID = p_ProductID;

    COMMIT;
END;
/

-- PROCEDURE: Cancel Order
CREATE OR REPLACE PROCEDURE Cancel_Order (
    p_OrderID IN NUMBER
)
AS
BEGIN
    -- Update Order status
    UPDATE Orders
    SET Status = 'Cancelled'
    WHERE OrderID = p_OrderID;

    -- Restore stock for each item
    FOR rec IN (
        SELECT ProductID, Quantity
        FROM OrderItems
        WHERE OrderID = p_OrderID
    ) LOOP
        UPDATE Products
        SET StockQty = StockQty + rec.Quantity
        WHERE ProductID = rec.ProductID;
    END LOOP;

    COMMIT;
END;
/

-- PROCEDURE: Process Refund
CREATE OR REPLACE PROCEDURE Process_Refund (
    p_ReturnID IN NUMBER
)
AS
    v_Amount NUMBER;
    v_OrderItemID NUMBER;
BEGIN
    SELECT o.UnitPrice * o.Quantity, r.OrderItemID
    INTO v_Amount, v_OrderItemID
    FROM Returns r
    JOIN OrderItems o ON r.OrderItemID = o.OrderItemID
    WHERE r.ReturnID = p_ReturnID;

    -- Insert into Refunds
    INSERT INTO Refunds (RefundID, ReturnID, Amount, RefundDate, Status)
    VALUES (p_ReturnID + 100, p_ReturnID, v_Amount, SYSDATE, 'Processed');

    -- Update return status
    UPDATE Returns
    SET Status = 'Approved'
    WHERE ReturnID = p_ReturnID;

    COMMIT;
END;
/

-- PROCEDURE: Update a product's stock quantity
CREATE OR REPLACE PROCEDURE update_product_stock (
    p_product_id    IN NUMBER,
    p_quantity      IN NUMBER
) 
AS
BEGIN
    UPDATE Products
    SET StockQty = StockQty + p_quantity
    WHERE ProductID = p_product_id;
        
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Stock for Product ' || p_product_id || ' updated.');
END;
/