import csv
import random
from datetime import date, timedelta
from pathlib import Path

random.seed(42)
OUT = Path(__file__).resolve().parents[1] / "data"
OUT.mkdir(exist_ok=True)

categories = {
    "Technology": ["Laptop", "Smartphone", "Monitor", "Keyboard", "Headphones"],
    "Furniture": ["Office Chair", "Desk", "Bookshelf", "Table", "Storage Cabinet"],
    "Office Supplies": ["Notebook", "Printer Paper", "Pen Set", "Stapler", "Desk Organizer"]
}
products = []
for i, (category, names) in enumerate(categories.items()):
    for name in names:
        cost = round(random.uniform(8, 450), 2)
        products.append({
            "product_id": "P%03d" % (len(products) + 1),
            "product_name": name,
            "category": category,
            "unit_cost": cost,
            "list_price": round(cost * random.uniform(1.18, 1.75), 2)
        })

regions = [("North", "Delhi"), ("South", "Bengaluru"), ("South", "Chennai"),
           ("West", "Mumbai"), ("West", "Pune"), ("East", "Kolkata"),
           ("Central", "Bhopal"), ("North", "Jaipur")]
customers = []
for i in range(1, 601):
    region, city = random.choice(regions)
    customers.append({
        "customer_id": "C%04d" % i,
        "customer_name": "Customer %04d" % i,
        "segment": random.choice(["Consumer", "Corporate", "Small Business"]),
        "region": region,
        "city": city
    })

orders, items = [], []
start, end = date(2024, 1, 1), date(2025, 12, 31)
for i in range(1, 6001):
    order_date = start + timedelta(days=random.randint(0, (end-start).days))
    customer = random.choice(customers)
    order_id = "O%06d" % i
    orders.append({
        "order_id": order_id, "order_date": order_date.isoformat(),
        "customer_id": customer["customer_id"],
        "sales_channel": random.choice(["Online", "Retail Store", "Partner"]),
        "order_status": random.choices(["Completed", "Returned", "Cancelled"], [86, 9, 5])[0]
    })
    for line, product in enumerate(random.sample(products, random.randint(1, 4)), 1):
        quantity = random.randint(1, 5)
        discount = random.choice([0, .05, .10, .15, .20])
        unit_price = round(product["list_price"] * (1-discount), 2)
        sales = round(quantity * unit_price, 2)
        shipping = round(random.uniform(2, 18), 2)
        cost = round(quantity * product["unit_cost"] + shipping, 2)
        items.append({
            "order_id": order_id, "line_number": line, "product_id": product["product_id"],
            "quantity": quantity, "unit_price": unit_price, "discount_pct": discount,
            "gross_sales": round(quantity * product["list_price"], 2),
            "sales_amount": sales, "shipping_cost": shipping,
            "total_cost": cost, "profit": round(sales-cost, 2)
        })

def write(name, rows):
    with (OUT / name).open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)

write("customers.csv", customers)
write("products.csv", products)
write("orders.csv", orders)
write("order_items.csv", items)
print("Generated 600 customers, 15 products, 6,000 orders, and %s order lines." % len(items))
