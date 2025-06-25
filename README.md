**Project Type:** Sales & Revenue Analysis  
**Tools Used:** MySQL  
**Dataset Source:** Simulated Pizza Sales Dataset  
**Role:** Data Analyst (Independent Project)

---

## Project Overview  
This project analyzes a pizza restaurant’s order and sales data using SQL. It focuses on deriving insights that can help improve product mix, timing strategies, revenue targeting, and performance tracking — all based on real-time transaction data.

The project includes foundational metrics (like total sales), performance segmentation (by pizza type, size, and category), as well as advanced queries for revenue attribution and cumulative performance.

---

## Objectives  
- Calculate order volumes and total revenue  
- Identify top-performing pizza types by quantity and revenue  
- Analyze revenue contribution by category  
- Examine order trends across time and size preferences  
- Use window functions and ranking logic to highlight segment leaders  
- Generate cumulative revenue insights for trend monitoring

---

## 1. Core Business Queries  
- Total number of orders:
```sql
SELECT COUNT(order_id) AS total_orders FROM orders;
Total revenue from pizza sales:

sql
Copy
Edit
SELECT ROUND(SUM(OD.quantity * PZ.price), 2) AS total_sales
FROM order_details OD
JOIN pizzas PZ ON OD.pizza_id = PZ.pizza_id;
Most common pizza size ordered:

sql
Copy
Edit
SELECT pz.size, COUNT(od.order_details_id) AS order_count
FROM pizzas pz
JOIN order_details od ON pz.pizza_id = od.pizza_id
GROUP BY pz.size
ORDER BY order_count DESC
LIMIT 1;
2. Intermediate & Advanced Queries
Revenue contribution by pizza category:

sql
Copy
Edit
SELECT pt.category, ROUND(SUM(pz.price * od.quantity) /
(SELECT SUM(pz1.price * od1.quantity)
 FROM pizzas pz1
 JOIN order_details od1 ON od1.pizza_id = pz1.pizza_id) * 100, 2) AS revenue
FROM pizza_types pt
JOIN pizzas pz ON pt.pizza_type_id = pz.pizza_type_id
JOIN order_details od ON od.pizza_id = pz.pizza_id
GROUP BY pt.category;
Top 3 pizzas by revenue per category using window functions:

sql
Copy
Edit
SELECT name, revenue
FROM (
  SELECT category, name, revenue,
         RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS rn
  FROM (
    SELECT pt.category, pt.name,
           ROUND(SUM(od.quantity * pz.price), 2) AS revenue
    FROM order_details od
    JOIN pizzas pz ON od.pizza_id = pz.pizza_id
    JOIN pizza_types pt ON pz.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
  ) a
) b
WHERE rn <= 3;
Cumulative daily revenue analysis:

sql
Copy
Edit
SELECT order_date, sales,
       ROUND(SUM(sales) OVER(ORDER BY order_date), 2) AS cumulative_sales
FROM (
  SELECT ods.order_date, ROUND(SUM(od.quantity * pz.price), 2) AS sales
  FROM orders ods
  JOIN order_details od ON ods.order_id = od.order_id
  JOIN pizzas pz ON pz.pizza_id = od.pizza_id
  GROUP BY ods.order_date
) daily_revenue;
Deliverables
Complete SQL script containing 15+ structured queries

Business-focused analysis across volume, revenue, and product categories

Demonstration of intermediate to advanced SQL capabilities (joins, aggregates, window functions)

Conclusion
This project simulates a real-world restaurant scenario and demonstrates the ability to extract revenue-critical insights using SQL alone. It showcases practical data skills relevant for roles in BI, product analytics, and operations analysis within F&B, retail, or e-commerce contexts.
