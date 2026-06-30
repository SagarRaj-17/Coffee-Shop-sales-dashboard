-- Total sales

SELECT ROUND(SUM(unit_price * transaction_qty), 1) AS Total_sales
FROM coffee_shop_sales 
WHERE MONTH(transaction_date) = 5; -- May month

-- MoM sales 
WITH monthly_sales AS ( 
SELECT  
		MONTH(transaction_date) AS month, 
		SUM(unit_price * transaction_qty) AS total_sales
		FROM coffee_shop_sales 
		WHERE MONTH(transaction_date) IN (4,5)
		GROUP BY MONTH(transaction_date)
) 

SELECT 
	month,  
    ROUND(total_sales) AS total_sales,
    ROUND(
    (total_sales - LAG(total_sales) OVER (ORDER BY month))
    / LAG(total_sales) OVER (ORDER BY month) * 100,2) AS MoM_increase_percentage
    FROM monthly_sales
    ORDER BY month;

-- Total Orders

SELECT COUNT(transaction_id) AS total_orders
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5;

-- MoM total orders

WITH monthly_orders AS ( 
SELECT  
		MONTH(transaction_date) AS month, 
		COUNT(transaction_id) AS total_orders
		FROM coffee_shop_sales 
		WHERE MONTH(transaction_date) IN (4,5)
		GROUP BY MONTH(transaction_date)
) 

SELECT 
	month,  
    total_orders,
    ROUND(
    (total_orders - LAG(total_orders) OVER (ORDER BY month))
    / LAG(total_orders) OVER (ORDER BY month) * 100,2) AS MoM_increase_percentage
    FROM monthly_orders
    ORDER BY month;
    
-- Total quantity

SELECT SUM(transaction_qty) AS total_qty_sold 
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 6;

-- MoM total quantity

WITH monthly_qty AS ( 
SELECT  
		MONTH(transaction_date) AS month, 
		SUM(transaction_qty) AS total_qty
		FROM coffee_shop_sales 
		WHERE MONTH(transaction_date) IN (4,5)
		GROUP BY MONTH(transaction_date)
) 

SELECT 
	month,  
    total_qty,
    ROUND(
    (total_qty - LAG(total_qty) OVER (ORDER BY month))
    / LAG(total_qty) OVER (ORDER BY month) * 100,2) AS MoM_increase_percentage
    FROM monthly_qty
    ORDER BY month; 	
    
    -- Total Sales, Orders, Quantity
    
    SELECT 
		ROUND(SUM(unit_price * transaction_qty),1) AS total_sales,
        SUM(transaction_qty) AS total_qty,
        COUNT(transaction_id) AS total_orders
   FROM coffee_shop_sales
   WHERE transaction_date = '2023-04-27';
   
   -- Sales for Weekdays & Weekends
   
SELECT 
	CASE WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN "Weekends" 
    ELSE "Weekdays"
    END AS day_type,
    ROUND(SUM(unit_price * transaction_qty),2) AS total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5
GROUP BY day_type;	

-- Sales as per Location

SELECT 
	store_location,
    CONCAT(ROUND(SUM(unit_price * transaction_qty) / 1000,2),'K') AS total_sales
 FROM coffee_shop_sales
 WHERE MONTH(transaction_date) = 6 
 GROUP BY store_location
 ORDER BY total_sales DESC;
 
 -- Daily Avg sales for month 
 
SELECT
    ROUND(AVG(total_sales), 2) AS average_daily_sales
FROM (
    SELECT
        SUM(unit_price * transaction_qty) AS total_sales
    FROM coffee_shop_sales
    WHERE MONTH(transaction_date) = 5
    GROUP BY transaction_date
) AS daily_sales;
    
 -- Daily sales for month
 
 SELECT 
	DAY(transaction_date) AS day_of_month,
    ROUND(SUM(unit_price * transaction_qty),1) AS total_sales
 FROM coffee_shop_sales
 WHERE MONTH(transaction_date) = 5
 GROUP BY DAY(transaction_date)
 ORDER BY day_of_month;
 
 -- Comparing daily sales with avg. sales
 
 WITH daily_sales AS(
   SELECT 	
	DAY(transaction_date) AS day_of_month,
	ROUND(SUM(unit_price * transaction_qty),2) AS total_sales
  FROM coffee_shop_sales
  WHERE MONTH(transaction_date) = 5 
  GROUP BY DAY(transaction_date)
  )
  SELECT 
	day_of_month,
    total_sales,
    CASE 
		WHEN total_sales > AVG(total_sales) OVER() THEN "Above Average" 
        WHEN total_sales < AVG(total_sales) OVER() THEN "Below Average"
        ELSE "Average"
     END AS sales_status
  FROM daily_sales
  ORDER BY day_of_month;
  
  -- Sales as per category
  
  SELECT 
	product_category,
    ROUND(SUM(unit_price * transaction_qty),1) AS total_sales
  FROM coffee_shop_sales
  WHERE MONTH(transaction_date) = 5 
  GROUP BY product_category
  ORDER BY total_sales DESC;
  
  -- Sales by product type
  
    SELECT 
	product_type,
    ROUND(SUM(unit_price * transaction_qty),1) AS total_sales
  FROM coffee_shop_sales
  WHERE MONTH(transaction_date) = 4 AND product_category IN ('Coffee' , 'Tea')
  GROUP BY product_type
  ORDER BY total_sales DESC
  LIMIT 10;
  
  -- Sales by days and hours
  
  SELECT 
	SUM(unit_price * transaction_qty) AS total_sales,
    SUM(transaction_qty) AS total_qty,
    COUNT(*) AS total_orders
  FROM coffee_shop_sales
  WHERE MONTH(transaction_date) = 5
  AND DAYOFWEEK(transaction_date) = 2
  AND HOUR(transaction_time) = 8;
  
-- Sales per week for month
  
SELECT
    DAYNAME(transaction_date) AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5
GROUP BY DAYNAME(transaction_date);

-- Sales per hour 

SELECT 
	HOUR(transaction_time) AS Hour_of_day,
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales
 FROM coffee_shop_sales
 WHERE MONTH(transaction_date) = 5
 GROUP BY HOUR(transaction_time)
 ORDER BY HOUR(transaction_time);