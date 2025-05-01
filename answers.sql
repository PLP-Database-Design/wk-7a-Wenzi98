Question 1
USE salesdb;
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(255),
    Products VARCHAR(255)
);

INSERT INTO ProductDetail (OrderID, CustomerName, Products)
VALUES
    (101, 'Thanos', 'Laptop, Mouse'),
    (102, 'Wenzi Molomo', 'Tablet, Keyboard, Mouse'),
    (103, 'Cash Cobain', 'Phone');

   USE salesdb; 

    INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT 
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1)) AS Product
FROM 
    ProductDetail
JOIN 
    (SELECT 1 AS n UNION ALL 
     SELECT 2 UNION ALL 
     SELECT 3 UNION ALL 
     SELECT 4) numbers  
ON 
    LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) >= n - 1
ORDER BY 
    OrderID, Product;

    SELECT * FROM ProductDetail_1NF;



    Question 2
    USE salesdb;
    CREATE TABLE OrderProducts (
    OrderNumber INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderNumber, Product), 
    FOREIGN KEY (OrderNumber) REFERENCES Orders(OrderNumber) 
);

    INSERT INTO Orders (OrderNumber)
    SELECT DISTINCT 
    OrderNumber
    FROM OrderDetails;


    INSERT INTO OrderProducts (OrderNumber, Product, Quantity)
    SELECT 
    OrderNumber, 
    Product, 
    Quantity 
    FROM OrderDetails;