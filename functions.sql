-- ================================================
-- Functions for E-Commerce Order Management System
-- ================================================

-- FUNCTION: Calculate Discount
CREATE OR REPLACE FUNCTION Calculate_Discount (
    p_TotalAmount IN NUMBER
) RETURN NUMBER
IS
    v_Discount NUMBER := 0;
BEGIN
    IF p_TotalAmount >= 5000 THEN
        v_Discount := p_TotalAmount * 0.10; -- 10%
    ELSIF p_TotalAmount >= 2000 THEN
        v_Discount := p_TotalAmount * 0.05; -- 5%
    END IF;

    RETURN v_Discount;
END;
/

-- FUNCTION: Calculate total spending
CREATE OR REPLACE FUNCTION get_total_customer_spending (
    p_customer_id IN NUMBER
) RETURN NUMBER 
IS
    v_total_spending NUMBER(10, 2);
BEGIN
    SELECT SUM(TotalAmount)
    INTO v_total_spending
    FROM Orders
    WHERE CustomerID = p_customer_id
    AND Status <> 'Cancelled';
          
    RETURN NVL(v_total_spending, 0);
END;
/
