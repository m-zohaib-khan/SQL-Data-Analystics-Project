CREATE DATABASE IF NOT EXISTS DataWarehouseAnalytics;

USE DataWarehouseAnalytics;

CREATE TABLE IF NOT EXISTS DataWarehouseAnalytics.dm_customers AS
SELECT *
FROM gold.dm_customers;

CREATE TABLE IF NOT EXISTS DataWarehouseAnalytics.dm_products AS
SELECT *
FROM gold.dm_products;

CREATE TABLE IF NOT EXISTS DataWarehouseAnalytics.facts_sales AS
SELECT *
FROM gold.facts_sales;

-- show the results:
select * from datawarehouseanalytics.dm_customers;
select * from datawarehouseanalytics.dm_products;
select * from datawarehouseanalytics.facts_sales;

-- perform the EDA(Exploratory data analysis):

-- step1: database exploration:
-- explore all the objects 	in the database:
SELECT
    TABLE_NAME,
    TABLE_TYPE,
    ENGINE,
    TABLE_ROWS,
    CREATE_TIME,
    UPDATE_TIME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'DataWarehouseAnalytics'
ORDER BY TABLE_NAME;

-- explore all columns in the database:
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_KEY,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'DataWarehouseAnalytics'
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- step2: Dimensions exploration:
-- Explore all countries our customer come from:
select distinct country from datawarehouseanalytics.dm_customers;

-- explore all categories "the major divisions":
select distinct category, subcategory, product_name from datawarehouseanalytics.dm_products;

-- step3: Date Exploration:

-- Q1: find the date of the first and last order:
-- how many sales of year are available:
select 
min(order_date) as first_order_date,
max(order_date) as last_order_date,
timestampdiff(year, min(order_date), max(order_date)) as order_range_years
from datawarehouseanalytics.facts_sales;

-- Q: find the youngest and oldest customer:
select 
min(birth_date) as oldest_birthdate,
max(birth_date) as youngest_birthdate,
timestampdiff(year, min(birth_date), CURDATE()) as oldest_customer,
timestampdiff(year, max(birth_date), CURDATE()) as youngest_customer
from datawarehouseanalytics.dm_customers;

-- step4: Measure Exploration:
-- Q: find the total sales of the business company:
select sum(sales_amount) as total_sale_company from datawarehouseanalytics.facts_sales;
-- find how many items are sold:
select count(quantity) as total_items from datawarehouseanalytics.facts_sales;
-- find the average selling price:
select avg(price) as average_selling_price from datawarehouseanalytics.facts_sales;
-- find the total number of orders:
select count(distinct order_number) as total_orders from datawarehouseanalytics.facts_sales;
-- find the total number of products:
select count(distinct product_name) as no_products from datawarehouseanalytics.dm_products;
-- find the total number of customers:
select count(distinct customer_key) as total_customer from datawarehouseanalytics.dm_customers;
-- find the total number of customer that has placed an order:
select count(distinct customer_key) as total_customer from datawarehouseanalytics.facts_sales;

-- Generate the Report that shows all key metrics of the business:
select 'Total Sales' as measure_name,sum(sales_amount) as measure_value from datawarehouseanalytics.facts_sales
union all
select 'Total items sold',count(quantity) from datawarehouseanalytics.facts_sales
union all
select 'Average price', avg(price) from datawarehouseanalytics.facts_sales
union all
select 'Total Nr.orders',count(distinct order_number) from datawarehouseanalytics.facts_sales
union all
select 'Total Nr.products',count(distinct product_name) from datawarehouseanalytics.dm_products
union all
select 'Total Nr.customers',count(distinct customer_key) from datawarehouseanalytics.dm_customers
union all
select 'Total Nr.customers that placed an order',count(distinct customer_key) from datawarehouseanalytics.facts_sales;

-- step5: Magnitude analysis: (compare the measure value by categories)
-- Q:  find the total customers by countries:
select country,
count(customer_key) as total_customers from datawarehouseanalytics.dm_customers
group by country order by total_customers DESC;

-- find the total customers by gender:
select gender,
count(customer_key) as total_customers from datawarehouseanalytics.dm_customers
group by gender order by total_customers DESC;

-- find the total products by category:
select category,
count(product_key) as total_products from datawarehouseanalytics.dm_products
group by category order by total_products desc;

-- what is the average cost in each category:
select category,
avg(cost) as average_cost_per_category
from datawarehouseanalytics.dm_products
group by category order by average_cost_per_category desc;

select * from datawarehouseanalytics.dm_products;
select * from datawarehouseanalytics.facts_sales;
select * from datawarehouseanalytics.dm_customers;

-- what is the total revenue generated for each category:
select p.category,
sum(f.sales_amount) as total_revenue_per_category
from datawarehouseanalytics.dm_products as p
left join datawarehouseanalytics.facts_sales as f
on p.product_key=f.product_key
group by p.category
order by  total_revenue_per_category desc;

-- find total revenue is generated by each customer:
select c.customer_key, c.first_name, c.last_name,
sum(f.sales_amount) as total_revenue_per_category
from datawarehouseanalytics.dm_customers as c
left join datawarehouseanalytics.facts_sales as f
on c.customer_key= f.customer_key
group by c.customer_key, c.first_name, c.last_name
order by total_revenue_per_category desc;

-- what is the distribution of sold items across countries:?
select c.country,
sum(f.quantity) as total_soldItems_country from datawarehouseanalytics.dm_customers as c 
left join datawarehouseanalytics.facts_sales as f
on c.customer_key =f.customer_key
group by c.country 
order by  total_soldItems_country desc;

-- step6: Ranking analysis:(top-N, bottom-N Analysis):

-- which 5 products generates the highest revenue:
select * from
(
select p.product_name,
sum(f.sales_amount) as revenue,
row_number() over(order by sum(f.sales_amount) desc) as rank_products
from datawarehouseanalytics.dm_products as p
left join datawarehouseanalytics.facts_sales as f
on p.product_key= f.product_key
group by p.product_name
) as t1
where rank_products <=5;


-- what are the 5 worst-performing products in terms of sale:
select p.product_name,
sum(f.sales_amount) as revenue
from datawarehouseanalytics.dm_products as p
left join datawarehouseanalytics.facts_sales as f
on p.product_key= f.product_key
group by p.product_name
order by revenue
limit 5;

-- find the top-customers who have generated the highest revennue and 3 customer with the fewest orders placed:
select 
c.customer_key,
c.first_name,
c.last_name,
sum(f.sales_amount) as total_revenue
from datawarehouseanalytics.dm_customers as c
left join datawarehouseanalytics.facts_sales as f
on c.customer_key=f.customer_key
group by c.customer_key,
c.first_name,
c.last_name
order by total_revenue desc
limit 10;

-- 3 customers with the fewest orders placed:
select 
c.customer_key,
c.first_name,
c.last_name,
count(c.customer_key) as total_orders
from datawarehouseanalytics.dm_customers as c
left join datawarehouseanalytics.facts_sales as f
on c.customer_key=f.customer_key
group by c.customer_key,
c.first_name,
c.last_name
order by total_orders ASC
limit 3;

	
