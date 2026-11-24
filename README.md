# Retail Sales & Profitability Dashboard

A portfolio project for analyzing sales, revenue, discounts, costs, and profitability using **Power BI, Power Query, DAX, SQL, and Excel**.

> **Dataset notice:** All records in `data/` are synthetically generated for portfolio and learning purposes. They do not represent real customers, companies, or transactions.

## Business problem

A retail business needs a consolidated view of sales performance across products, categories, customers, regions, and sales channels. The dashboard should help business users answer:

1. How much revenue, profit, and order volume are being generated?
2. Which categories and products contribute the most revenue and profit?
3. How do sales and profit change month over month and year over year?
4. Which regions and channels perform best?
5. How do discounts relate to profitability?
6. Which customers contribute the most revenue?

## Repository structure

```text
Retail_Sales_Profitability_Dashboard/
├── data/
│   ├── customers.csv
│   ├── products.csv
│   ├── orders.csv
│   └── order_items.csv
├── sql/
│   ├── 01_create_schema.sql
│   └── 02_analysis_queries.sql
├── powerbi/
│   ├── dax_measures.dax
│   ├── power_query_m.md
│   └── dashboard_build_guide.md
├── src/
│   └── generate_dataset.py
├── docs/
│   └── data_dictionary.md
├── README.md
└── requirements.txt
```

## Dataset overview

| File | Grain | Description |
|---|---|---|
| `customers.csv` | One row per customer | Segment, region, and city |
| `products.csv` | One row per product | Category, unit cost, and list price |
| `orders.csv` | One row per order | Date, customer, channel, and status |
| `order_items.csv` | One row per order line | Quantity, discount, sales, cost, and profit |

The generated dataset contains 6,000 orders and their associated order lines, 600 customers, and 15 products across three categories. The date range is January 2024 through December 2025.

## Data model

Create a star-schema-style model in Power BI:

- `customers[customer_id]` (1) → `orders[customer_id]` (*)
- `orders[order_id]` (1) → `order_items[order_id]` (*)
- `products[product_id]` (1) → `order_items[product_id]` (*)
- `Date[Date]` (1) → `orders[order_date]` (*)

Use single-direction filtering from dimensions to facts. Mark the Date table as the model's date table.

## Getting started

### 1. Clone the repository

```bash
git clone https://github.com/YOUR-USERNAME/retail-sales-profitability-dashboard.git
cd retail-sales-profitability-dashboard
```

### 2. Load the data

For Power BI:
1. Open Power BI Desktop.
2. Select **Get Data → Text/CSV**.
3. Import the four CSV files in `data/`.
4. Apply the transformations documented in `powerbi/power_query_m.md`.
5. Create relationships using the model above.
6. Add the DAX measures from `powerbi/dax_measures.dax`.

For MySQL:
1. Create a database.
2. Run `sql/01_create_schema.sql`.
3. Import each CSV into its corresponding table using MySQL Workbench, Beekeeper Studio, or `LOAD DATA LOCAL INFILE`.
4. Run the analysis queries in `sql/02_analysis_queries.sql`.

## Dashboard pages

### Page 1 — Executive Overview
- Total Sales
- Total Profit
- Profit Margin %
- Total Orders
- Average Order Value
- Monthly sales trend
- Sales by category
- Profit by region
- Sales channel split

### Page 2 — Product & Category Analysis
- Sales and profit by product
- Category contribution
- Units sold
- Discount vs. profit analysis
- Top and bottom products

### Page 3 — Customer & Regional Analysis
- Sales by customer segment
- Top customers
- City and region performance
- Channel performance
- Monthly regional trends

## Suggested interactions

- Date slicer
- Region, category, and channel slicers
- Drill-through from category to product detail
- Tooltips showing sales, profit, margin, and units
- Conditional formatting for negative profit
- A reset-filters bookmark

## Important metric definitions

- **Sales Amount:** Sum of `order_items[sales_amount]`.
- **Profit:** Sum of `order_items[profit]`.
- **Profit Margin:** Profit divided by sales amount.
- **Average Order Value:** Sales amount divided by distinct order count.
- **Discount Rate:** Total discount value divided by gross sales. Calculate discount value as `gross_sales - sales_amount`.
- **Order Count:** Distinct count of `orders[order_id]`.

This training project uses line-item sales and cost fields. Cancelled and returned orders are included in the raw data so that learners can practice status-based filtering. Decide and document the business rule used for the primary sales KPIs. The starter measures include completed orders only.

## Validation checklist

- Confirm all four CSVs load without parsing errors.
- Check that customer, product, and order keys are unique in their dimension/header tables.
- Confirm every order item maps to an order and product.
- Reconcile SQL totals with Power BI totals under the same order-status filter.
- Check that profit margin is calculated as total profit / total sales, not the average of row-level margins.
- Check date filtering across both 2024 and 2025.
- Test slicers, drill-through, and report interactions.

## Interview talking points

Be prepared to explain:
- Why a star schema was used.
- Why measures are preferred over calculated columns for aggregations.
- How Power Query transformations differ from DAX calculations.
- How you validated dashboard totals against SQL.
- Why profit margin should be calculated from aggregate profit and sales.
- How discounting can increase sales volume but reduce margin.

## Limitations and next steps

- This is a synthetic portfolio dataset, not a production retail system.
- Returns are represented at order status level in this starter dataset; a production model would normally include a separate returns fact table with return dates and quantities.
- A production deployment could add incremental refresh, row-level security, scheduled refresh, and a certified semantic model.

## License

MIT. See `LICENSE` if you add one before publishing.
