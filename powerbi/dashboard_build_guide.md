# Power BI dashboard build guide

## 1. Import tables
Import `customers.csv`, `products.csv`, `orders.csv`, and `order_items.csv`. Apply the transformation steps in `power_query_m.md`.

## 2. Create relationships
Use Model view and create:
- customers[customer_id] 1:* orders[customer_id]
- orders[order_id] 1:* order_items[order_id]
- products[product_id] 1:* order_items[product_id]
- Date[Date] 1:* orders[order_date]

Set relationships to active, single-direction filtering. Mark the Date table as a date table.

## 3. Create DAX
Copy the measures from `dax_measures.dax`. Format sales/profit/AOV as currency, margin/growth/discount as percentages, and order/units as whole numbers.

## 4. Page 1 — Executive Overview
Top row: Total Sales, Total Profit, Profit Margin %, Total Orders, Average Order Value.
Middle: line chart for monthly sales and profit; clustered bar chart for sales by category.
Bottom: bar chart for profit by region; donut chart for sales by channel.
Slicers: Date, Region, Category, Sales Channel.

## 5. Page 2 — Product & Category
- Bar chart: sales by product, sorted descending.
- Column chart: profit by category.
- Scatter chart: discount rate vs profit by product (use product-level aggregation).
- Matrix: category → product with sales, profit, margin, units.
- Top N filter for products.

## 6. Page 3 — Customer & Regional
- Sales by customer segment.
- Top 10 customers by sales.
- Sales by city and region.
- Monthly trend by channel.
- Drill-through page for customer detail.

## 7. Polish
- Use a consistent theme and aligned visual grid.
- Add meaningful titles and dynamic report titles where useful.
- Configure tooltip pages for product and region.
- Add a Reset Filters bookmark.
- Use conditional formatting for negative profit and low margin.
- Check accessibility: contrast, alt text, readable labels.

## 8. Reconciliation
Run the SQL KPI query in `sql/02_analysis_queries.sql`. Compare its output with the Power BI KPI cards while the same Completed status filter is applied. Explain any difference before publishing.
