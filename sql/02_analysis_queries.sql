-- Retail Sales & Profitability analysis queries (MySQL 8+)
USE retail_analytics;

-- 1. Executive KPIs: completed orders only
SELECT
    ROUND(SUM(oi.sales_amount), 2) AS total_sales,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(100 * SUM(oi.profit) / NULLIF(SUM(oi.sales_amount), 0), 2) AS profit_margin_pct,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.sales_amount) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS average_order_value
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed';

-- 2. Monthly sales and profit
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    ROUND(SUM(oi.sales_amount), 2) AS sales,
    ROUND(SUM(oi.profit), 2) AS profit
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;

-- 3. Category contribution
SELECT
    p.category,
    ROUND(SUM(oi.sales_amount), 2) AS sales,
    ROUND(SUM(oi.profit), 2) AS profit,
    ROUND(100 * SUM(oi.profit) / NULLIF(SUM(oi.sales_amount), 0), 2) AS margin_pct
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY sales DESC;

-- 4. Top 10 products by sales
SELECT
    p.product_id, p.product_name, p.category,
    ROUND(SUM(oi.sales_amount), 2) AS sales
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY sales DESC
LIMIT 10;

-- 5. Regional performance
SELECT
    c.region, c.city,
    ROUND(SUM(oi.sales_amount), 2) AS sales,
    ROUND(SUM(oi.profit), 2) AS profit
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.region, c.city
ORDER BY sales DESC;

-- 6. Sales by customer segment and channel
SELECT
    c.segment, o.sales_channel,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(oi.sales_amount), 2) AS sales
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.segment, o.sales_channel
ORDER BY sales DESC;

-- 7. Discount analysis
SELECT
    p.category,
    ROUND(SUM(oi.gross_sales - oi.sales_amount), 2) AS discount_value,
    ROUND(100 * SUM(oi.gross_sales - oi.sales_amount) /
          NULLIF(SUM(oi.gross_sales), 0), 2) AS discount_rate_pct,
    ROUND(SUM(oi.profit), 2) AS profit
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY discount_rate_pct DESC;

-- 8. Top 5 customers by revenue using a window function
WITH customer_sales AS (
    SELECT c.customer_id, c.customer_name,
           SUM(oi.sales_amount) AS total_sales
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN customers c ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
    FROM customer_sales
)
SELECT customer_id, customer_name, ROUND(total_sales, 2) AS total_sales, sales_rank
FROM ranked
WHERE sales_rank <= 5
ORDER BY sales_rank;

-- 9. Data quality: orphan order-item keys
SELECT oi.order_id, oi.product_id
FROM order_items oi
LEFT JOIN orders o ON o.order_id = oi.order_id
LEFT JOIN products p ON p.product_id = oi.product_id
WHERE o.order_id IS NULL OR p.product_id IS NULL;

-- 10. Reconciliation: compare order header count with line-item count
SELECT
    (SELECT COUNT(*) FROM orders) AS order_header_count,
    (SELECT COUNT(DISTINCT order_id) FROM order_items) AS orders_with_items,
    (SELECT COUNT(*) FROM order_items) AS order_line_count;
