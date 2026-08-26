UPDATE adidas_clean 
SET total_sales = REPLACE(REPLACE(total_sales, '$', ''), ',', ''),
    operating_profit = REPLACE(REPLACE(operating_profit, '$', ''), ',', '');

-- 2. CONVERT DATA TYPE TO DECIMAL
ALTER TABLE adidas_clean 
MODIFY COLUMN total_sales DECIMAL(15,2),
MODIFY COLUMN operating_profit DECIMAL(15,2);
   
SELECT 
    retailer,
    year,
    month,
    COUNT(DISTINCT invoice_date) AS transaction_days,
    SUM(total_sales) AS total_revenue,
    SUM(operating_profit) AS total_profit,
    ROUND((SUM(operating_profit) / SUM(total_sales)) * 100, 2) AS weighted_margin_pct,
    ROUND(SUM(total_sales) / (SELECT SUM(total_sales) FROM adidas_clean) * 100, 2) AS revenue_contribution_pct
FROM adidas_clean
GROUP BY retailer, year, month
ORDER BY year DESC, month DESC, total_profit DESC;

SELECT
	 region,
	 retailer,
	 YEAR,
	 MONTH,
	 SUM(total_sales) AS regional_sales,
	 ROUND(
	 	  SUM(total_sales) / SUM(SUM(total_sales)) OVER (PARTITION BY region) * 100, 2
	 ) AS share_within_region_pct
FROM adidas_clean
GROUP BY region, retailer, year, month
ORDER BY year DESC, month DESC, region, regional_sales DESC;

SELECT
	 region,
	 state,
	 year,
    month,
	 COUNT(DISTINCT retailer) AS active_retailers_count,
	 SUM(units_sold) AS total_units_sold,
	 SUM(total_sales) AS total_revenue,
	 SUM(operating_profit) AS total_profit,
	 ROUND(AVG(operating_margin), 2) AS avg_operating_margin_pct
FROM adidas_clean
GROUP BY region, state, year, month
ORDER BY year DESC, month DESC, total_profit DESC;

SELECT 
	 retailer,
	 sales_method,
	 year,
    month,
	 SUM(total_sales) AS total_revenue,
	 SUM(operating_profit) AS total_profit,
	 ROUND((SUM(operating_profit) / SUM(total_sales)) * 100, 2) AS margin_pct
FROM adidas_clean
GROUP BY retailer, sales_method, year, month
ORDER BY year DESC, month DESC, retailer, total_profit DESC;