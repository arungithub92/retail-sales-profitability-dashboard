# Power Query M — Import and transformation guide

The easiest way to use this project is to import each CSV with **Get Data → Text/CSV** and then apply the steps below in Power Query. The M snippets assume the CSV files are in the repository's `data` folder. Replace the folder path with your local path.

## Customers query

```powerquery
let
    Source = Csv.Document(
        File.Contents("C:\PATH\Retail_Sales_Profitability_Dashboard\data\customers.csv"),
        [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]
    ),
    Headers = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    Types = Table.TransformColumnTypes(Headers,{
        {"customer_id", type text},
        {"customer_name", type text},
        {"segment", type text},
        {"region", type text},
        {"city", type text}
    }),
    Trimmed = Table.TransformColumns(Types,{
        {"customer_name", Text.Trim, type text},
        {"segment", Text.Trim, type text},
        {"region", Text.Trim, type text},
        {"city", Text.Trim, type text}
    }),
    Deduplicated = Table.Distinct(Trimmed, {"customer_id"})
in
    Deduplicated
```

## Products query

```powerquery
let
    Source = Csv.Document(
        File.Contents("C:\PATH\Retail_Sales_Profitability_Dashboard\data\products.csv"),
        [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]
    ),
    Headers = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    Types = Table.TransformColumnTypes(Headers,{
        {"product_id", type text},
        {"product_name", type text},
        {"category", type text},
        {"unit_cost", Currency.Type},
        {"list_price", Currency.Type}
    }),
    Deduplicated = Table.Distinct(Types, {"product_id"})
in
    Deduplicated
```

## Orders query

```powerquery
let
    Source = Csv.Document(
        File.Contents("C:\PATH\Retail_Sales_Profitability_Dashboard\data\orders.csv"),
        [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]
    ),
    Headers = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    Types = Table.TransformColumnTypes(Headers,{
        {"order_id", type text},
        {"order_date", type date},
        {"customer_id", type text},
        {"sales_channel", type text},
        {"order_status", type text}
    }),
    Deduplicated = Table.Distinct(Types, {"order_id"})
in
    Deduplicated
```

## Order Items query

```powerquery
let
    Source = Csv.Document(
        File.Contents("C:\PATH\Retail_Sales_Profitability_Dashboard\data\order_items.csv"),
        [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]
    ),
    Headers = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    Types = Table.TransformColumnTypes(Headers,{
        {"order_id", type text},
        {"line_number", Int64.Type},
        {"product_id", type text},
        {"quantity", Int64.Type},
        {"unit_price", Currency.Type},
        {"discount_pct", Percentage.Type},
        {"gross_sales", Currency.Type},
        {"sales_amount", Currency.Type},
        {"shipping_cost", Currency.Type},
        {"total_cost", Currency.Type},
        {"profit", Currency.Type}
    }),
    ValidQuantity = Table.SelectRows(Types, each [quantity] > 0),
    Deduplicated = Table.Distinct(ValidQuantity, {"order_id", "line_number"})
in
    Deduplicated
```

## Transformation and quality checks to explain

- Promote headers and assign explicit data types.
- Trim text fields to prevent join mismatches.
- Remove duplicate dimension keys.
- Validate positive quantities.
- Keep the order status field so report measures can explicitly filter Completed orders.
- Do not silently delete cancelled or returned orders; retain them for status analysis.
