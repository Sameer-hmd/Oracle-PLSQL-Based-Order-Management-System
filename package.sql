-- ==============================================
-- Package for E-Commerce Order Management System
-- ==============================================

-- PACKAGE SPEC
CREATE OR REPLACE PACKAGE Order_Processing_Pkg AS
    PROCEDURE Place_Order (
        p_OrderID    IN NUMBER,
        p_CustomerID IN NUMBER,
        p_ProductID  IN NUMBER,
        p_Quantity   IN NUMBER
    );

    PROCEDURE Cancel_Order (
        p_OrderID IN NUMBER
    );

    PROCEDURE Process_Refund (
        p_ReturnID IN NUMBER
    );

    FUNCTION Calculate_Discount (
        p_TotalAmount IN NUMBER
    ) RETURN NUMBER;
END Order_Processing_Pkg;
/

-- PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY Order_Processing_Pkg AS

    PROCEDURE Place_Order (
        p_OrderID    IN NUMBER,
        p_CustomerID IN NUMBER,
        p_ProductID  IN NUMBER,
        p_Quantity   IN NUMBER
    ) IS
        v_UnitPrice NUMBER;
        v_StockQty  NUMBER;
    BEGIN
        SELECT Price, StockQty INTO v_UnitPrice, v_StockQty
        FROM Products
        WHERE ProductID = p_ProductID;

        IF v_StockQty < p_Quantity THEN
            RAISE_APPLICATION_ERROR(-20001, 'Insufficient stock.');
        END IF;

        INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status)
        VALUES (p_OrderID, p_CustomerID, SYSDATE, v_UnitPrice * p_Quantity, 'Pending');

        INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice)
        VALUES (p_OrderID + 100, p_OrderID, p_ProductID, p_Quantity, v_UnitPrice);

        UPDATE Products
        SET StockQty = StockQty - p_Quantity
        WHERE ProductID = p_ProductID;

        COMMIT;
    END;

    PROCEDURE Cancel_Order (
        p_OrderID IN NUMBER
    ) IS
    BEGIN
        UPDATE Orders
        SET Status = 'Cancelled'
        WHERE OrderID = p_OrderID;

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

    PROCEDURE Process_Refund (
        p_ReturnID IN NUMBER
    ) IS
        v_Amount NUMBER;
        v_OrderItemID NUMBER;
    BEGIN
        SELECT o.UnitPrice * o.Quantity, r.OrderItemID
        INTO v_Amount, v_OrderItemID
        FROM Returns r
        JOIN OrderItems o ON r.OrderItemID = o.OrderItemID
        WHERE r.ReturnID = p_ReturnID;

        INSERT INTO Refunds (RefundID, ReturnID, Amount, RefundDate, Status)
        VALUES (p_ReturnID + 100, p_ReturnID, v_Amount, SYSDATE, 'Processed');

        UPDATE Returns
        SET Status = 'Approved'
        WHERE ReturnID = p_ReturnID;

        COMMIT;
    END;

    FUNCTION Calculate_Discount (
        p_TotalAmount IN NUMBER
    ) RETURN NUMBER IS
        v_Discount NUMBER := 0;
    BEGIN
        IF p_TotalAmount >= 5000 THEN
            v_Discount := p_TotalAmount * 0.10;
        ELSIF p_TotalAmount >= 2000 THEN
            v_Discount := p_TotalAmount * 0.05;
        END IF;

        RETURN v_Discount;
    END;

END Order_Processing_Pkg;
/

------------------------------------------------------------------------------------------------

-- Package Specification (Header)
CREATE OR REPLACE PACKAGE SALES_PKG AS
    -- Procedure to update a product's stock quantity
    PROCEDURE update_product_stock (
        p_product_id    IN NUMBER,
        p_quantity      IN NUMBER
    );
    
    -- Function to calculate total spending (same as above, but now in a package)
    FUNCTION get_total_customer_spending (
        p_customer_id IN NUMBER
    ) RETURN NUMBER;
END SALES_PKG;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY SALES_PKG AS

    -- Implementation of the update_product_stock procedure
    PROCEDURE update_product_stock (
        p_product_id    IN NUMBER,
        p_quantity      IN NUMBER
    ) AS
    BEGIN
        UPDATE Products
        SET StockQty = StockQty + p_quantity
        WHERE ProductID = p_product_id;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Stock for Product ' || p_product_id || ' updated.');
    END update_product_stock;

    -- Implementation of the get_total_customer_spending function
    FUNCTION get_total_customer_spending (
        p_customer_id IN NUMBER
    ) RETURN NUMBER AS
        v_total_spending NUMBER(10, 2);
    BEGIN
        SELECT SUM(TotalAmount)
        INTO v_total_spending
        FROM Orders
        WHERE CustomerID = p_customer_id
          AND Status <> 'Cancelled';
          
        RETURN NVL(v_total_spending, 0);
    END get_total_customer_spending;

END SALES_PKG;
/

-- Example of how to call the package's components
BEGIN
    -- Update stock
    SALES_PKG.update_product_stock(p_product_id => 101, p_quantity => -1); -- Deduct one item
    
    -- Get total spending
    DBMS_OUTPUT.PUT_LINE('Customer 10 has spent: ' || SALES_PKG.get_total_customer_spending(10));
END;
/