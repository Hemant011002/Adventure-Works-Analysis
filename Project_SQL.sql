-- Create Sales2 Table from Union
CREATE TABLE Sales2 AS
SELECT * FROM factinternetsales
UNION ALL
SELECT * FROM fact_internet_sales_new;

-- ProductName from the Product table to sales

SELECT 
	    s.ProductKey,
		s.UnitPrice,
        s.OrderQuantity,
	(s.OrderQuantity*s.UnitPrice) AS TotalPrice
FROM 
    fact_internet_sales_new s
JOIN 
    dimproduct p
ON 
    s.ProductKey = p.ProductKey ;

-- Add Customer Full Name & Unit Price

ALTER TABLE Sales2 ADD COLUMN CustomerFullName VARCHAR(255);

UPDATE Sales2 s
LEFT JOIN dimcustomer c ON s.CustomerKey = c.CustomerKey
LEFT JOIN dimproduct p ON s.ProductKey = p.ProductKey
SET 
    s.CustomerFullName = CONCAT_WS(' ', c.FirstName, c.MiddleName, c.LastName),
    s.UnitPrice2 = p.UnitPrice;
    
                            -- or --

SELECT CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS FullName
from dimcustomer ;


						    -- or --
SELECT 
    f.*,
    CONCAT_WS(' ', c.FirstName, c.MiddleName, c.LastName) AS CustomerFullName
FROM sales2 f
JOIN DimCustomer c ON f.CustomerKey = c.CustomerKey;

-- Year

ALTER TABLE sales2
ADD COLUMN date DATE;

SELECT 
    YEAR(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS Year
FROM sales2;

-- MonthNo

SELECT MONTH(OrderDateKey) AS Month_No FROM sales2;


-- Full Month Name
SELECT 
    MONTHNAME(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS MonthFullName
FROM sales2;

-- Quarter

SELECT 
    CONCAT('Q', QUARTER(STR_TO_DATE(OrderDateKey, '%Y%m%d'))) AS Quarter
FROM sales2;

-- YearMonth 
SELECT 
    DATE_FORMAT(STR_TO_DATE(OrderDateKey, '%Y%m%d'), '%Y-%b') AS YearMonth
FROM sales2;

-- weekdayNO
SELECT 
    DAYOFWEEK(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS WeekdayNo
FROM sales2;

-- weekdayName
SELECT 
    DAYNAME(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS WeekdayName
FROM sales2;

-- Finanical Month

SELECT 
    CASE
        WHEN MONTH(OrderDateKey) IN (4, 5, 6) THEN 'April-June'
        WHEN MONTH(OrderDateKey) IN (7, 8, 9) THEN 'July-September'
        WHEN MONTH(OrderDateKey) IN (10, 11, 12) THEN 'October-December'
        WHEN MONTH(OrderDateKey) IN (1, 2, 3) THEN 'January-March'
    END AS FinancialMonth
FROM sales2;

-- finanical Quarter

SELECT
    CASE
        WHEN MONTH(OrderDateKey) IN (4, 5, 6) THEN 'Q1'
        WHEN MONTH(OrderDateKey) IN (7, 8, 9) THEN 'Q2'
        WHEN MONTH(OrderDateKey) IN (10, 11, 12) THEN 'Q3'
        WHEN MONTH(OrderDateKey) IN (1, 2, 3) THEN 'Q4'
    END AS FinancialQuarter
FROM sales2;


-- Sales amount

SELECT 
    (unitprice * orderquantity) * (1 - UnitPriceDiscountPct) AS sales_amount
FROM 
    sales2;

--  Productioncost

SELECT 
    ProductStandardCost * orderquantity AS production_cost
FROM 
    sales2;

-- Calculate Profit:

SELECT 
    (SalesAmount - TotalProductCost) AS Profit
FROM sales2;

--  Filter Data for a Specific Year

SELECT *
FROM sales2
WHERE Year = 2011;

-- Group by Month Name and Sum Sales

SELECT 
    `Month Name`,
    SUM(SalesAmount) AS TotalSales
FROM sales2
GROUP BY `Month Name`;

-- Sales Data by Quarter Number

SELECT 
    `Quarter Number`,
    SUM(SalesAmount) AS TotalSales,
    SUM(SalesAmount - TotalProductCost) AS TotalProfit
FROM sales2
GROUP BY `Quarter Number`;

-- Top 5 Customers by Sales Amount

SELECT 
    `Customer Full Name`,
    SUM(SalesAmount) AS TotalSales
FROM sales2
GROUP BY `Customer Full Name`
ORDER BY TotalSales DESC
LIMIT 5;


