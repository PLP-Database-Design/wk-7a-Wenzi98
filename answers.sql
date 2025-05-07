Question 1

USE salesdb;
CREATE TABLE IF NOT EXISTS ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(50),
    Products VARCHAR(100)
);

-- We insert the sample data
INSERT INTO ProductDetail (OrderID, CustomerName, Products)
VALUES 
    (101, 'John Doe', 'Laptop, Mouse'),
    (102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
    (103, 'Emily Clark', 'Phone');

-- View the original table
SELECT * FROM ProductDetail;

-- Now this is where I transform the table to 1NF by creating a new table with one row per product
-- This query creates a new table that satisfies 1NF

-- Create the new 1NF-compliant table
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    PRIMARY KEY (OrderID, Product)
);

-- Insert values into the 1NF table by splitting the Products column


-- For OrderID 101: 'John Doe' with 'Laptop, Mouse'
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT 101, 'John Doe', 'Laptop' UNION ALL
SELECT 101, 'John Doe', 'Mouse';

-- For OrderID 102: 'Jane Smith' with 'Tablet, Keyboard, Mouse'
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT 102, 'Jane Smith', 'Tablet' UNION ALL
SELECT 102, 'Jane Smith', 'Keyboard' UNION ALL
SELECT 102, 'Jane Smith', 'Mouse';

-- For OrderID 103: 'Emily Clark' with 'Phone'
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT 103, 'Emily Clark', 'Phone';

-- View the 1NF-compliant table
SELECT * FROM ProductDetail_1NF;


Question 2

Use salesdb;
CREATE TABLE IF NOT EXISTS OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT,
    PRIMARY KEY (OrderID, Product)
);


INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity)
VALUES 
    (101, 'John Doe', 'Laptop', 2),
    (101, 'John Doe', 'Mouse', 1),
    (102, 'Jane Smith', 'Tablet', 3),
    (102, 'Jane Smith', 'Keyboard', 1),
    (102, 'Jane Smith', 'Mouse', 2),
    (103, 'Emily Clark', 'Phone', 1);

SELECT * FROM OrderDetails;

-- Now I transformed the table to 2NF by creating two separate tables:
-- 1. Orders table with OrderID as the primary key and CustomerName
-- 2. OrderProducts table with OrderID and Product as the composite primary key and Quantity

-- I then created the Orders table (for the part that depends only on OrderID)
CREATE TABLE Orders_2NF (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50)
);

-- From here I created the OrderProducts table (for the part that depends on the composite key)
CREATE TABLE OrderProducts_2NF (
    OrderID INT,
    Product VARCHAR(50),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders_2NF(OrderID)
);

-- This is where I insert data into the Orders table
-- We need to use DISTINCT to avoid duplicate OrderIDs
INSERT INTO Orders_2NF (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Insert data into the OrderProducts table
INSERT INTO OrderProducts_2NF (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- We then view the 2NF-compliant tables
SELECT * FROM Orders_2NF;
SELECT * FROM OrderProducts_2NF;

-- Just showing you how to join the tables to get the original data
SELECT o.OrderID, o.CustomerName, op.Product, op.Quantity
FROM Orders_2NF o
JOIN OrderProducts_2NF op ON o.OrderID = op.OrderID
ORDER BY o.OrderID, op.Product;

-- ==========================================
-- These are my verification queries
-- ==========================================

-- We then verify 1NF: Each cell contains atomic values and each row is unique
SELECT 'ProductDetail_1NF is in 1NF' AS Verification
WHERE NOT EXISTS (
    SELECT OrderID, Product, COUNT(*)
    FROM ProductDetail_1NF
    GROUP BY OrderID, Product
    HAVING COUNT(*) > 1
);