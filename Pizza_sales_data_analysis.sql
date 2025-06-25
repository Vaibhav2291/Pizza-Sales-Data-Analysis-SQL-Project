-- Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;

-- Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(OD.quantity * PZ.price), 2) AS total_sales
FROM
    order_details OD
        JOIN
    pizzas PZ ON OD.pizza_id = PZ.pizza_id;

-- Identify the highest-priced pizza.

SELECT 
    PT.`name`, PZ.price
FROM
    pizza_types PT
        JOIN
    pizzas PZ ON PT.pizza_type_id = PZ.pizza_type_id
ORDER BY PZ.price DESC
LIMIT 1;

-- Identify the most common pizza size ordered.

SELECT 
    pz.size, COUNT(od.order_details_id) order_count
FROM
    Pizzas pz
        JOIN
    order_details od ON pz.pizza_id = od.pizza_id
GROUP BY pz.size
ORDER BY order_count DESC
LIMIT 1;

-- List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pt.name, SUM(od.quantity) quantity_ordered
FROM
    pizza_types pt
        JOIN
    pizzas pz ON pt.pizza_type_id = pz.pizza_type_id
        JOIN
    order_details od ON pz.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY quantity_ordered DESC
LIMIT 5;

-- Intermediate:
-- Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pt.category, SUM(od.quantity) ordered_quantity
FROM
    pizza_types pt
        JOIN
    pizzas pz ON pt.pizza_type_id = pz.pizza_type_id
        JOIN
    order_details od ON pz.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY 2 DESC; 

-- Determine the distribution of orders by hour of the day.

Select hour(order_time) as `hour`, count(order_id) as order_count
fROM orders
group by hour(order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.
 
Select category, count(name)
From pizza_types
group by category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.

Select round(avg(sum_quantity), 0) avg_pizza_quantity from 
(
Select ord.order_date 'date', sum(od.quantity) sum_quantity
From orders ord
Join order_details od
on ord.order_id = od.order_id
Group by ord.order_date
) order_quantity
;

-- Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pt.name, ROUND(SUM(od.quantity * pz.price), 2) revenue
FROM
    order_details od
        JOIN
    pizzas pz ON od.pizza_id = pz.pizza_id
        JOIN
    pizza_types pt ON pz.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY 2 DESC
LIMIT 3;

-- Advanced:
-- Calculate the percentage contribution of each pizza type to total revenue.

Select pt.category, 
round(sum(pz.price*od.quantity)
/
(select round(sum(pz1.price*od1.quantity),2)
from pizzas pz1
join order_details od1
on od1.pizza_id=pz1.pizza_id
 ) 
* 100,2) revenue
From pizza_types pt
Join pizzas pz
on pt.pizza_type_id=pz.pizza_type_id
Join order_details od
on od.pizza_id=pz.pizza_id
Group by pt.category;

-- Analyze the cumulative revenue generated over time.

Select order_date, sales, round(sum(sales) over(order by order_date),2) cumulative_sales
from (select ods.order_date, round(sum(od.quantity*pz.price),2) sales
from orders ods
Join order_details od
on ods.order_id=od.order_id
join pizzas pz
on pz.pizza_id=od.pizza_id
group by ods.order_date) daily_revenue;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

Select name, revenue
from (Select category, name, revenue, rank() over(partition by category order by revenue desc) as rn 
from (SELECT pt.category, pt.name, ROUND(SUM(od.quantity * pz.price), 2) revenue
FROM order_details od
JOIN pizzas pz ON od.pizza_id = pz.pizza_id
JOIN pizza_types pt ON pz.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category,pt.name) as a) as b
where rn<=3;