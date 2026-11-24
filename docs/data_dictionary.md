# Data Dictionary

## customers.csv
- customer_id: unique customer key (C0001 format)
- customer_name: synthetic display name
- segment: Consumer, Corporate, or Small Business
- region: broad sales region
- city: customer city

## products.csv
- product_id: unique product key
- product_name: product label
- category: Technology, Furniture, or Office Supplies
- unit_cost: synthetic per-unit cost
- list_price: reference selling price before discount

## orders.csv
- order_id: unique order key
- order_date: order creation date (2024-01-01 to 2025-12-31)
- customer_id: customer foreign key
- sales_channel: Online, Retail Store, or Partner
- order_status: Completed, Returned, or Cancelled

## order_items.csv
- order_id: order foreign key
- line_number: line sequence within an order
- product_id: product foreign key
- quantity: units in the line
- unit_price: selling price per unit after discount
- discount_pct: discount fraction (e.g. 0.10 = 10%)
- gross_sales: quantity multiplied by list price
- sales_amount: quantity multiplied by discounted unit price
- shipping_cost: allocated line-level shipping cost
- total_cost: quantity multiplied by unit cost plus shipping cost
- profit: sales_amount minus total_cost
