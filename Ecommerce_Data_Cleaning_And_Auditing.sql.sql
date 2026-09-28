USE E_Commerce;

-- Explore the raw dataset
SELECT * FROM Sales_ECommerce;

-- Calculate overall business metrics: Total Revenue, Total Items Sold, Total Orders, and Total Unique Customers
SELECT  CAST(SUM(Quantity * unitprice) AS INT) AS Total_Revenue,
		SUM(Quantity) AS Total_Items_Sold,
		COUNT(DISTINCT InvoiceNo) AS Total_Orders,
		COUNT(DISTINCT CustomerID) AS Total_Customers
FROM Sales_ECommerce
WHERE 
	Quantity > 0
	AND UnitPrice > 0
	AND CustomerID IS NOT NULL;

-- Identify the top 5 best-selling products by total revenue
SELECT TOP 5 
			LOWER(Description) AS Description,
			CAST(SUM(Quantity * UnitPrice) AS INT) AS Total_Revenue
FROM Sales_ECommerce
WHERE 
	Quantity > 0
	AND UnitPrice > 0
	AND CustomerID IS NOT NULL
GROUP BY Description
ORDER BY Total_Revenue DESC;

-- Analyze total revenue generation by country
SELECT Country,
		CAST(SUM(Quantity * UnitPrice) AS INT) AS Total_Revenue
FROM Sales_ECommerce
WHERE 
	Quantity > 0
	AND UnitPrice > 0
	AND CustomerID IS NOT NULL
GROUP BY Country
ORDER BY Total_Revenue DESC;

-- Analyze sales performance and order volume by year and month
SELECT FORMAT(CAST(InvoiceDate AS DATETIME),'yyyy,MM') AS Year_Month,
       CAST(SUM(Quantity * UnitPrice) AS INT) AS Total_revenue,
	   COUNT(DISTINCT InvoiceNo) AS Total_Orders
FROM Sales_ECommerce
WHERE 
	Quantity > 0
	AND UnitPrice > 0
	AND CustomerID IS NOT NULL
GROUP BY FORMAT(CAST(InvoiceDate AS DATETIME),'yyyy,MM')
ORDER BY Total_revenue DESC;

-- Identify VIP customers generating the highest revenue
SELECT TOP 5 CustomerID ,
	   CAST(SUM(Quantity * UnitPrice) AS INT) AS Total_Revenue
FROM Sales_ECommerce
WHERE 
	Quantity > 0
	AND UnitPrice > 0
	AND CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY Total_Revenue DESC;

-- Calculate the average order value (AOV) per customer
WITH Order_Totals AS (
SELECT CustomerID,InvoiceNo,
	   CAST(SUM(Quantity * UnitPrice) AS INT) AS Order_Amount
FROM Sales_ECommerce
WHERE 
	Quantity > 0
	AND UnitPrice > 0
	AND CustomerID IS NOT NULL
GROUP BY CustomerID,InvoiceNo
)
SELECT CustomerID,
		COUNT(InvoiceNo) AS Total_Orders,
	   CAST(AVG(Order_Amount) AS INT) AS Avg_Order_Cost
FROM Order_Totals
GROUP BY CustomerID
ORDER BY Avg_Order_Cost DESC;

-- Analyze customer engagement and order frequency to track active shoppers
SELECT CustomerID,
	   COUNT(DISTINCT InvoiceNo) AS Total_Orders		
FROM Sales_ECommerce
WHERE 
	Quantity > 0
	AND UnitPrice > 0
	AND CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY Total_Orders DESC;

-- Rank top 10 products by total revenue and stock code
SELECT LOWER(Description) AS Description,
	   StockCode,
	   CAST(SUM(Quantity * UnitPrice) AS INT) AS Total_Revenue
FROM Sales_ECommerce
WHERE 
	 Quantity > 0
	AND UnitPrice > 0
	AND CustomerID IS NOT NULL
GROUP BY Description,StockCode
ORDER BY Total_Revenue DESC;

-- Identify top products demanded by total quantity sold
SELECT LOWER(Description) AS Description,SUM(Quantity) AS Total_Quantity
FROM Sales_ECommerce
WHERE 
	 Quantity > 0
  AND UnitPrice > 0
  AND CustomerID IS NOT NULL
GROUP BY Description
ORDER BY Total_Quantity DESC;

-- Analyze seasonal peak times and revenue trends by year and month
SELECT YEAR(InvoiceDate) AS Year_Num,MONTH(InvoiceDate) AS Month_Name,
	   CAST(SUM(Quantity * UnitPrice) AS INT) AS Total_Revenue
FROM Sales_ECommerce
WHERE 
	Quantity > 0
    AND UnitPrice > 0
	AND CustomerID IS NOT NULL
GROUP BY MONTH(InvoiceDate),YEAR(InvoiceDate)
ORDER BY Total_Revenue DESC;

-- Identify top 5 revenue-generating countries
SELECT TOP 5 Country,
	   CAST(SUM(Quantity * UnitPrice) AS INT) AS Total_Revenue
FROM Sales_ECommerce
WHERE
	Quantity > 0
	AND UnitPrice > 0
	AND CustomerID IS NOT NULL
GROUP BY Country
ORDER BY Total_Revenue DESC;

-- Calculate total returns and financial losses ('C' prefix denotes cancellations/returns)
SELECT COUNT(InvoiceNo) AS Count_CancellationsAudit,
		CAST(SUM(Quantity * UnitPrice) AS INT) AS Total_Loses
FROM Sales_ECommerce
WHERE 
	Quantity < 0
	AND UnitPrice > 0
	AND CustomerID IS NOT NULL
	AND InvoiceNo LIKE 'C%';

-- Rank all customers based on their total spending power
SELECT CustomerID,
	   CAST(SUM(Quantity * UnitPrice) AS INT) AS Total_Spent,
	   RANK() OVER (ORDER BY SUM(Quantity * UnitPrice) DESC) AS Rank_Num
FROM Sales_ECommerce
WHERE 
	Quantity > 0
	AND UnitPrice > 0
	AND CustomerID IS NOT NULL
GROUP BY CustomerID;


-- Investigate NULL CustomerID records for data quality audit
SELECT 
    COUNT(*) AS Null_Rows_Count,
    SUM(CASE WHEN Quantity < 0 THEN 1 ELSE 0 END) AS Negative_Quantity_Rows,
    SUM(CASE WHEN Quantity > 0 THEN 1 ELSE 0 END) AS Positive_Quantity_Rows
FROM Sales_ECommerce
WHERE CustomerID IS NULL;

-- Detailed breakdown of NULL CustomerID rows into returns and sales
SELECT 
    COUNT(InvoiceNo) AS Total_Null_Rows,
    SUM(CASE WHEN Quantity < 0 THEN 1 ELSE 0 END) AS Null_Returns_Count,
    SUM(CASE WHEN Quantity > 0 THEN 1 ELSE 0 END) AS Null_Sales_Count
FROM Sales_ECommerce
WHERE CustomerID IS NULL;

-- Calculate potential revenue associated with unassigned guest transactions
SELECT 
    COUNT(*) AS Null_Customer_Rows,
    CAST(SUM(Quantity * UnitPrice) AS INT) AS Lost_Revenue_Potential
FROM Sales_ECommerce
WHERE CustomerID IS NULL;

-- Categorize unassigned transactions (Guest sales, returns, and inventory adjustments)
SELECT 
    CASE 
        WHEN Quantity > 0 THEN 'Regular Sale (Guest/Cash)'
        WHEN Quantity < 0 THEN 'Return / Cancellation (No Customer)'
        ELSE 'Zero Quantity / Adjustment'
    END AS Transaction_Type,
    COUNT(*) AS Row_Count,
    CAST(SUM(Quantity * UnitPrice) AS INT) AS Total_Value
FROM Sales_ECommerce
WHERE CustomerID IS NULL
GROUP BY 
    CASE 
        WHEN Quantity > 0 THEN 'Regular Sale (Guest/Cash)'
        WHEN Quantity < 0 THEN 'Return / Cancellation (No Customer)'
        ELSE 'Zero Quantity / Adjustment'
    END;

-- Round UnitPrice to 2 decimal places to ensure financial accuracy and clean data presentation
UPDATE Sales_ECommerce
SET UnitPrice = ROUND(UnitPrice,2);