# Oracle-PLSQL-Based-Order-Management-System
# E-Commerce Order Management System (Oracle SQL/PLSQL)

This repository contains the SQL and PL/SQL scripts for an E-Commerce Order Management System database. It includes table creation, sample data insertion, stored procedures, functions, packages, triggers, and reporting views designed to manage and analyze e-commerce operations.

## Table of Contents

* [Project Overview](#project-overview)

* [Database Schema](#database-schema)

* [Setup and Installation](#setup-and-installation)

* [Key Features](#key-features)

  * [Stored Procedures](#stored-procedures)

  * [Functions](#functions)

  * [Packages](#packages)

  * [Triggers](#triggers)

  * [Reporting Views](#reporting-views)

* [Usage](#usage)

* [Contributing](#contributing)

* [License](#license)

## Project Overview

This project provides a foundational database system for managing an e-commerce platform. It covers core functionalities such as user management, product inventory, order processing, payments, returns, and refunds. The system is built using Oracle SQL and PL/SQL, leveraging features like stored procedures, functions, packages, and triggers for robust data management and business logic enforcement.

## Database Schema

The database consists of the following tables:

* **`Users`**: Stores information about administrators, sellers, and customers.

  * `UserID` (PK), `Name`, `Email`, `Role` (`Admin`, `Seller`, `Customer`)

* **`Products`**: Contains details about products sold, including stock and status.

  * `ProductID` (PK), `SellerID` (FK), `ProductName`, `Price`, `StockQty`, `Status` (`Active`, `Inactive`)

* **`Orders`**: Records customer orders.

  * `OrderID` (PK), `CustomerID` (FK), `OrderDate`, `TotalAmount`, `Status` (`Pending`, `Shipped`, `Delivered`, `Cancelled`)

* **`OrderItems`**: Details individual items within an order.

  * `OrderItemID` (PK), `OrderID` (FK), `ProductID` (FK), `Quantity`, `UnitPrice`

* **`Payments`**: Manages payment transactions for orders.

  * `PaymentID` (PK), `OrderID` (FK), `PaymentDate`, `Amount`, `PaymentMethod`, `Status` (`Paid`, `Failed`, `Refunded`)

* **`Returns`**: Tracks product returns.

  * `ReturnID` (PK), `OrderItemID` (FK), `Reason`, `Status` (`Pending`, `Approved`, `Rejected`)

* **`Refunds`**: Records refund transactions for returns.

  * `RefundID` (PK), `ReturnID` (FK), `Amount`, `RefundDate`, `Status` (`Processed`, `Failed`)

**Indexes:**
Several indexes are created to improve query performance:

* `idx_order_status` on `Orders(Status)`

* `idx_product_status` on `Products(Status)`

* `idx_orderitem_order_product` on `OrderItems(OrderID, ProductID)`

* `idx_user_email` on `Users(Email)`

## Setup and Installation

To set up this database on your Oracle environment:

1. **Clone the repository:**
2. **Connect to your Oracle database** using a SQL client (e.g., SQL Developer, SQL\*Plus, DBeaver).

3. **Execute the scripts in the following order:**

* `create_tables.sql`: Creates all the necessary tables and indexes.

* `insert_sample_data.sql`: Populates the tables with initial sample data.

* `procedures.sql`: Creates standalone stored procedures.

* `functions.sql`: Creates standalone functions.

* `package.sql`: Creates the PL/SQL packages (`Order_Processing_Pkg` and `SALES_PKG`).

* `triggers.sql`: Creates database triggers.

* `reportings.sql`: Creates reporting views and the `Reporting_Pkg` package.

*Example execution in SQL*Plus:
@create_tables.sql
@insert_sample_data.sql
@procedures.sql
@functions.sql
@package.sql
@triggers.sql
@reportings.sql

## Key Features

### Stored Procedures

* **`Place_Order(p_OrderID, p_CustomerID, p_ProductID, p_Quantity)`**: Handles the creation of a new order, inserting into `Orders` and `OrderItems`, and updating product stock.

* **`Cancel_Order(p_OrderID)`**: Changes an order's status to 'Cancelled' and restores product stock.

* **`Process_Refund(p_ReturnID)`**: Processes a return by inserting into `Refunds` and updating the return status.

* **`update_product_stock(p_product_id, p_quantity)`**: Updates the stock quantity for a given product.

### Functions

* **`Calculate_Discount(p_TotalAmount)`**: Calculates a discount based on the total order amount.

* **`get_total_customer_spending(p_customer_id)`**: Returns the total amount a customer has spent on non-cancelled orders.

### Packages

* **`Order_Processing_Pkg`**: Encapsulates core order management procedures and functions:

* `Place_Order`

* `Cancel_Order`

* `Process_Refund`

* `Calculate_Discount`

* **`SALES_PKG`**: Provides sales-related utilities:

* `update_product_stock`

* `get_total_customer_spending`

### Triggers

* **`check_stock_before_order`**: Ensures sufficient stock before an `OrderItem` is inserted.

* **`trg_update_stock_after_order`**: Automatically updates product stock after an `OrderItem` is inserted.

* **`trg_log_cancelled_order`**: Logs details of cancelled orders into the `Order_Cancellation_Log` table.

### Reporting Views

* **`V_Customer_Order_Summary`**: Summarizes each customer's total orders and spending.

* **`V_Product_Sales_Info`**: Provides sales performance details for each product, linked to the seller.

* **`V_Order_Details`**: Offers a detailed view of each order, joining information from customers, products, and order items.

* **`V_Return_Refund_Details`**: Links returns to their corresponding refunds and product information.

## Usage

After setting up the database, you can interact with it using SQL queries and PL/SQL blocks.
