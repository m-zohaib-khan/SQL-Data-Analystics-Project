/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - Consolidates key customer metrics and behaviors.

Highlights:
    1. Customer information and age.
    2. Age groups and customer segments.
    3. Total orders, sales, quantity, and products.
    4. Customer lifespan in months.
    5. Recency in months.
    6. Average order value.
    7. Average monthly spend.
===============================================================================
*/


-- =============================================================================
-- Create Customer Report View
-- =============================================================================

DROP VIEW IF EXISTS datawarehouseanalytics.report_customers;


CREATE VIEW datawarehouseanalytics.report_customers AS

WITH base_query AS
(
    /*
    ---------------------------------------------------------------------------
    1) Base Query
    ---------------------------------------------------------------------------
    */

    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,

        c.customer_key,
        c.customer_number,

        CONCAT(
            c.first_name,
            ' ',
            c.last_name
        ) AS customer_name,

        TIMESTAMPDIFF(
            YEAR,
            c.birth_date,
            CURDATE()
        ) AS age

    FROM DataWarehouseAnalytics.facts_sales AS f

    LEFT JOIN DataWarehouseAnalytics.dm_customers AS c
        ON c.customer_key = f.customer_key

    WHERE f.order_date IS NOT NULL
),

customer_aggregation AS
(
    /*
    ---------------------------------------------------------------------------
    2) Customer Aggregations
    ---------------------------------------------------------------------------
    */

    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,

        -- Total number of orders
        COUNT(DISTINCT order_number) AS total_orders,

        -- Total sales/revenue
        SUM(sales_amount) AS total_sales,

        -- Total quantity purchased
        SUM(quantity) AS total_quantity,

        -- Total different products purchased
        COUNT(DISTINCT product_key) AS total_products,

        -- Last order date
        MAX(order_date) AS last_order_date,

        -- Customer lifespan in months
        TIMESTAMPDIFF(
            MONTH,
            MIN(order_date),
            MAX(order_date)
        ) AS lifespan

    FROM base_query

    GROUP BY
        customer_key,
        customer_number,
        customer_name,
        age
)

SELECT

    customer_key,
    customer_number,
    customer_name,
    age,

    /*
    ---------------------------------------------------------------------------
    Age Group
    ---------------------------------------------------------------------------
    */

    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END AS age_group,

    /*
    ---------------------------------------------------------------------------
    Customer Segment
    ---------------------------------------------------------------------------
    */

    CASE
        WHEN lifespan >= 12
             AND total_sales > 5000
            THEN 'VIP'

        WHEN lifespan >= 12
             AND total_sales <= 5000
            THEN 'Regular'

        ELSE 'New'
    END AS customer_segment,

    /*
    ---------------------------------------------------------------------------
    Last Order & Recency
    ---------------------------------------------------------------------------
    */

    last_order_date,

    TIMESTAMPDIFF(
        MONTH,
        last_order_date,
        CURDATE()
    ) AS recency,

    /*
    ---------------------------------------------------------------------------
    Customer Metrics
    ---------------------------------------------------------------------------
    */

    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,

    /*
    ---------------------------------------------------------------------------
    Average Order Value
    ---------------------------------------------------------------------------
    */

    COALESCE(
        total_sales / NULLIF(total_orders, 0),
        0
    ) AS avg_order_value,

    /*
    ---------------------------------------------------------------------------
    Average Monthly Spend
    ---------------------------------------------------------------------------
    */

    COALESCE(
        total_sales / NULLIF(lifespan, 0),
        total_sales
    ) AS avg_monthly_spend

FROM customer_aggregation;

-- show the results:
SELECT * FROM datawarehouseanalytics.report_customers;
