-- Advanced Data Analytics:

select * from datawarehouseanalytics.dm_customers;
select * from datawarehouseanalytics.dm_products;
select * from datawarehouseanalytics.facts_sales;

-- step7: change over time --> (check the sales month-over-month, year by year):

-- Analyze Sales performance over time:
select year(order_date) as order_years,
month(order_date) as order_months,
sum(sales_amount) as total_sales
from datawarehouseanalytics.facts_sales
where order_date is not null
group by year(order_date) , month(order_date)
order by year(order_date) , month(order_date);

-- order_date, years, months
SELECT
    DATE_FORMAT(order_date, '%Y-%M') AS order_month,
    SUM(sales_amount) AS total_sales
FROM datawarehouseanalytics.facts_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y-%M')
ORDER BY min(order_date);
-- order by DATE_FORMAT(order_date, '%Y-%M')

-- step8: Cumulative Analysis: (isme ham over time analysis perform karte hain):

-- Q: calculate the total sales per month and the running total of sales over time:
select order_date,
total_sales,
sum(total_sales) over(partition by order_date order by order_date) as running_total_sales,
avg(total_sales) over(order by order_date) as moving_average_prices # moving average
from
(
SELECT
    DATE_FORMAT(order_date, '%Y-%M') AS order_date,
    SUM(sales_amount) AS total_sales
FROM datawarehouseanalytics.facts_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y-%M')
ORDER BY DATE_FORMAT(order_date, '%Y-%M')
) as t1;

-- step9: Performance Analysis:

-- Q: Analyze the yearly performance of products by comparing each product's sale to both it's average sale
-- performance and the previous year's sales:

-- use of cte's:
with yearly_product_sales as
(
SELECT
    year(f.order_date) as order_year,
    p.product_name,
    sum(f.sales_amount) as current_sales
FROM datawarehouseanalytics.facts_sales AS f
LEFT JOIN 
datawarehouseanalytics.dm_products AS p
ON f.product_key=p.product_key
where f.order_date is not null
group by year(f.order_date), p.product_name
)
select order_year,product_name,
current_sales,
avg(current_sales) over(partition by product_name) as avg_sales,
(current_sales -  avg(current_sales) over(partition by product_name)) as diff_avg,
case when (current_sales -  avg(current_sales) over(partition by product_name)) > 0 then 'Above Avg'
     when (current_sales -  avg(current_sales) over(partition by product_name)) <0 then 'Below Avg'
     else 'Avg'
end avg_change,
lag(current_sales) over(partition by product_name order by order_year) as previous_year,
(current_sales - lag(current_sales) over(partition by product_name order by order_year)) as diff_change,
case when (current_sales - lag(current_sales) over(partition by product_name order by order_year)) > 0 then 'Increase'
     when (current_sales - lag(current_sales) over(partition by product_name order by order_year)) < 0 then 'Decrease'
     else 'No-change'
end py_change
from yearly_product_sales
order by product_name, order_year;


-- step10: Part-t--whole analysis:
-- which categories contribute the most to overall sales:

-- use of CTE's:
with category_sale as 
(
select category,
sum(sales_amount) as total_sales
from datawarehouseanalytics.facts_sales as f
left join datawarehouseanalytics.dm_products as p
on f.product_key=p.product_key
group by category
)
select category,
total_sales,
sum(total_sales) over() as overall_sales,
round(((total_sales / sum(total_sales) over() )  * 100),2) as percentage_total
from category_sale
order by total_sales desc;

-- the data shows that the Bikes category have most contribution or most sales than the others category:

-- Q: segment products into cost ranges and count how many products fall in each segment:

-- CTE's:
with product_segment as 
(
select product_key,
product_name, cost,
case when cost < 100 then 'below 100'
     when cost between 100 and 500 then '100-500'
     when cost between 500 and 1000 then '500-1000'
     else 'Above 1000'
end cost_range
from datawarehouseanalytics.dm_products
)
select cost_range,
count(product_key) as total_products
from product_segment
group by cost_range;

	
-- Q: Group customer's into three segments based on their spending behaviour:
-- VIP: atleast 12 months of history and spending more than $5, 0000.
-- REgular: atleast 12 months  of histroy but spending $5,000 or less.
-- New: lifespan less than 12 months.
-- and find the total number of customers by each group..

-- CTE's:
with customer_segment as
(
select c.customer_key,
sum(f.sales_amount) as total_spending,
min(f.order_date) as first_order,
max(f.order_date) as last_order,
TIMESTAMPDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS lifespan_months
from datawarehouseanalytics.facts_sales as f 
left join datawarehouseanalytics.dm_customers as c
on f.customer_key=c.customer_key
group by c.customer_key
)

select customer_range,
count(customer_key) as total_customers from
(
select customer_key, 
case when lifespan_months>=12 and total_spending > 5000 then 'VIP'
	 when lifespan_months>=12 and total_spending <=  5000 then 'Regular'
     else 'New'
end customer_range
from customer_segment
) as t1
group by customer_range
order by total_customers DESC;


-- step12: Build Reporting:

-- Q: build the customers report:


