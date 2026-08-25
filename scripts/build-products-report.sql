/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category,
       subcategory, and cost.
    2. Segments products based on revenue performance.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue
       - average monthly revenue
===============================================================================
*/


-- =============================================================================
-- Create Product Report
-- =============================================================================

DROP VIEW IF EXISTS DataWarehouseAnalytics.report_products;


CREATE VIEW DataWarehouseAnalytics.report_products AS

WITH base_query AS
(
    /*
    ---------------------------------------------------------------------------
    1) Base Query
    ---------------------------------------------------------------------------
    */

    SELECT
        f.order_number,
        f.order_date,
        f.sales_amount,
        f.quantity,
        f.customer_key,
        f.product_key,

        p.product_name,
        p.category,
        p.subcategory,
        p.cost

    FROM DataWarehouseAnalytics.facts_sales AS f

    LEFT JOIN DataWarehouseAnalytics.dm_products AS p
        ON p.product_key = f.product_key

    WHERE f.order_date IS NOT NULL
),

product_aggregation AS
(
    /*
    ---------------------------------------------------------------------------
    2) Product Aggregation
    ---------------------------------------------------------------------------
    */

    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,

        -- Total number of orders
        COUNT(DISTINCT order_number) AS total_orders,

        -- Total sales / revenue
        SUM(sales_amount) AS total_sales,

        -- Total quantity sold
        SUM(quantity) AS total_quantity,

        -- Total unique customers
        COUNT(DISTINCT customer_key) AS total_customers,

        -- Last sale date
        MAX(order_date) AS last_sale_date,

        -- Product lifespan in months
        TIMESTAMPDIFF(
            MONTH,
            MIN(order_date),
            MAX(order_date)
        ) AS lifespan

    FROM base_query

    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

SELECT

    product_key,
    product_name,
    category,
    subcategory,
    cost,

    /*
    ---------------------------------------------------------------------------
    Product Performance Segment
    ---------------------------------------------------------------------------
    */

    CASE
        WHEN total_sales > 5000
            THEN 'High-Performer'

        WHEN total_sales > 1000
            THEN 'Mid-Range'

        ELSE 'Low-Performer'
    END AS product_segment,

    /*
    ---------------------------------------------------------------------------
    Recency
    ---------------------------------------------------------------------------
    */

    last_sale_date,

    TIMESTAMPDIFF(
        MONTH,
        last_sale_date,
        CURDATE()
    ) AS recency,

    /*
    ---------------------------------------------------------------------------
    Product Metrics
    ---------------------------------------------------------------------------
    */

    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    lifespan,

    /*
    ---------------------------------------------------------------------------
    Average Order Revenue
    ---------------------------------------------------------------------------
    */

    COALESCE(
        total_sales / NULLIF(total_orders, 0),
        0
    ) AS avg_order_revenue,

    /*
    ---------------------------------------------------------------------------
    Average Monthly Revenue
    ---------------------------------------------------------------------------
    */

    COALESCE(
        total_sales / NULLIF(lifespan, 0),
        total_sales
    ) AS avg_monthly_revenue

FROM product_aggregation;
