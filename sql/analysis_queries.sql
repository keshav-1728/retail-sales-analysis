-- ============================================================
-- RETAIL SALES ANALYSIS - SQL QUERIES
-- Dataset: Sample Superstore
-- Tool: MYSQL
-- ============================================================


-- QUERY 1: Revenue Pareto Analysis by Sub-Category
-- Goal: Find which sub-categories drive 80% of revenue
-- ============================================================
SELECT
  Sub_Category,
  ROUND(SUM(Sales), 0) AS total_sales,
  ROUND(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER (), 3) AS sales_pct,
  ROUND(SUM(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER ())
    OVER (ORDER BY SUM(Sales) DESC), 3) AS cumulative_pct
FROM orders
GROUP BY Sub_Category
ORDER BY total_sales DESC;


-- QUERY 2: Regional Discount vs Profit Margin
-- Goal: Understand how discounting behaviour varies by region
--       and what it does to profitability
-- ============================================================
SELECT
  Region,
  ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct,
  ROUND(SUM(Profit), 0) AS total_profit,
  ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS profit_margin_pct
FROM orders
GROUP BY Region
ORDER BY profit_margin_pct DESC;


-- QUERY 3: Discount Threshold vs Profitability
-- Goal: Find the exact discount level where profit turns negative
-- ============================================================
SELECT
  ROUND(Discount, 1) AS discount_level,
  COUNT(*) AS num_orders,
  ROUND(AVG(Profit), 2) AS avg_profit
FROM orders
GROUP BY ROUND(Discount, 1)
ORDER BY discount_level ASC;


-- QUERY 4: Sub-Category Profit with Loss Isolation
-- Goal: Surface which product lines are losing money
-- ============================================================
SELECT
  Sub_Category,
  ROUND(SUM(Sales), 0) AS total_sales,
  ROUND(SUM(Profit), 0) AS total_profit,
  ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS profit_margin_pct,
  ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct
FROM orders
GROUP BY Sub_Category
ORDER BY total_profit ASC;


-- QUERY 5: Monthly Profit Trend
-- Goal: Identify seasonal patterns and weak periods
-- ============================================================
SELECT
  strftime('%m', Order_Date) AS month,
  ROUND(SUM(Sales), 0) AS total_sales,
  ROUND(SUM(Profit), 0) AS total_profit,
  ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS profit_margin_pct
FROM orders
GROUP BY month
ORDER BY month ASC;


-- QUERY 6: Customer Segment Profitability
-- Goal: Which segment (Consumer, Corporate, Home Office)
--       is most profitable vs most revenue
-- ============================================================
SELECT
  Segment,
  ROUND(SUM(Sales), 0) AS total_sales,
  ROUND(SUM(Profit), 0) AS total_profit,
  ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS profit_margin_pct,
  COUNT(DISTINCT Order_ID) AS total_orders
FROM orders
GROUP BY Segment
ORDER BY profit_margin_pct DESC;
