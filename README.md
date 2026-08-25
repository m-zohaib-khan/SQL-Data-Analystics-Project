<div align="center">

# 📊 SQL Business Analytics

### End-to-End MySQL Analytics Project

[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![SQL](https://img.shields.io/badge/SQL-Advanced-orange?style=for-the-badge&logo=databricks&logoColor=white)](https://github.com/m-zohaib-khan)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=for-the-badge)]()

<br/>

> **Transforming raw transactional data into decision-ready business intelligence**  
> using structured SQL analytics, window functions, and customer/product segmentation.

<br/>

```
Explore → Analyze → Segment → Measure → Report → Decide
```

</div>

---

## 📌 Overview

**SQL Business Analytics** is a production-quality, end-to-end data analytics project built entirely in MySQL. It demonstrates how structured SQL workflows transform raw customer, product, and sales data into actionable business insights — from systematic exploratory analysis through to executive-level reporting.

The project mirrors real-world **Data Analyst** workflows: rigorous data exploration, advanced analytical techniques, customer and product segmentation, and reusable report generation.

---

## 🗺️ Analytics Pipeline

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        DATA ANALYTICS PIPELINE                          │
├────────────────────────────────┬────────────────────────────────────────┤
│    EXPLORATORY DATA ANALYSIS   │         ADVANCED ANALYTICS             │
├────────────────────────────────┼────────────────────────────────────────┤
│  01. Database Exploration      │  07. Change-Over-Time Analysis         │
│  02. Dimensions Exploration    │  08. Cumulative Analysis               │
│  03. Date Exploration          │  09. Performance Analysis              │
│  04. Measures Exploration      │  10. Part-to-Whole Analysis            │
│  05. Magnitude Analysis        │  11. Data Segmentation                 │
│  06. Ranking Analysis          │  12. Business Reporting                │
└────────────────────────────────┴────────────────────────────────────────┘
```

---

## 🎯 Business Problem

Businesses generate enormous volumes of transactional data, yet raw records alone yield no insight. This project answers the strategic questions that stakeholders actually ask:

| Business Question | Analytical Technique |
|:---|:---|
| What is total revenue, and how is it trending? | Change-over-time analysis |
| Which products and categories drive the most value? | Ranking + part-to-whole analysis |
| Who are our highest-value customers? | Customer segmentation |
| How are sales changing month-over-month? | Cumulative + performance analysis |
| What percentage of revenue comes from each category? | Part-to-whole (contribution %) |
| Which products are underperforming? | Ranking + product segmentation |

---

## 🔍 Exploratory Data Analysis

### `01` Database Exploration
Audit available tables, record counts, schema structure, and primary/foreign key relationships to establish a complete understanding of the data model.

### `02` Dimensions Exploration
Profile categorical attributes — customers, products, categories, countries — to understand cardinality, completeness, and distribution across the dataset.

### `03` Date Exploration
Identify the full temporal range: earliest/latest dates, sales periods, customer acquisition windows, product lifecycles, and monthly/yearly coverage.

### `04` Measures Exploration
Characterize key numeric metrics — sales volume, quantity, price, revenue, and customer spend — including ranges, averages, and outliers.

### `05` Magnitude Analysis
Quantify the scale of the business: total revenue, units sold, average price, number of active customers, and revenue breakdown by category.

### `06` Ranking Analysis
Surface top and bottom performers across products, customers, and categories to prioritize analytical focus areas.

---

## 🚀 Advanced Analytics

### `07` Change-Over-Time Analysis
Track how key metrics evolve across time periods — monthly revenue trends, year-over-year growth, customer acquisition rate, and product sales trajectory.

### `08` Cumulative Analysis
Build running totals and cumulative metrics using `SUM() OVER()` window functions — cumulative revenue, rolling sales totals, and customer growth curves.

### `09` Performance Analysis
Benchmark current performance against historical baselines and category averages — year-over-year comparisons, product vs. category average, customer spend vs. overall average.

### `10` Part-to-Whole Analysis
Calculate each segment's percentage contribution to total revenue. Identifies which categories and products carry disproportionate business weight.

### `11` Customer Segmentation

Customers are classified into strategic tiers based on lifetime revenue and purchasing behavior:

| Segment | Description | Criteria |
|:---:|:---|:---|
| 🏆 **VIP** | Highest-value customers | High lifetime revenue, frequent orders |
| ⭐ **Regular** | Consistent purchasers | Mid-tier value, stable engagement |
| 🆕 **New** | Recently acquired | Early lifecycle, high growth potential |

### `12` Product Segmentation
Products are classified by sales velocity and revenue contribution to support inventory, pricing, and marketing decisions — segmented as High / Mid / Low performers.

---

## 📑 Business Reports

### 👥 Customer Report &nbsp;`reports/customer_report.sql`

A comprehensive customer intelligence view covering:

| Metric | Description |
|:---|:---|
| Customer profile | Name, location, acquisition date |
| Customer lifespan | Days since first order |
| Order summary | Total orders, quantity, revenue |
| Spend metrics | Average order value, avg. monthly spend |
| Segmentation | VIP / Regular / New classification |
| Recency | Days since last order |

### 📦 Product Report &nbsp;`reports/product_report.sql`

A complete product performance summary covering:

| Metric | Description |
|:---|:---|
| Product profile | Name, category, launch date |
| Product lifespan | Active duration on platform |
| Sales summary | Orders, quantity sold, revenue |
| Pricing | Average selling price |
| Contribution | Revenue % of total |
| Performance tier | High / Mid / Low classification |

---

## 🧠 SQL Concepts Demonstrated

**Foundations**

```sql
SELECT  WHERE  GROUP BY  ORDER BY  HAVING  DISTINCT  CASE WHEN
```

**Aggregations**

```sql
SUM()  COUNT()  AVG()  MIN()  MAX()
```

**Joins**

```sql
INNER JOIN  LEFT JOIN  -- multi-table joins
```

**Advanced SQL**

```sql
-- Common Table Expressions
WITH cte AS ( ... )

-- Subqueries
SELECT * FROM ( SELECT ... ) sub

-- Window Functions
ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)
RANK()        OVER (...)
DENSE_RANK()  OVER (...)
LAG()         OVER (ORDER BY ...)
LEAD()        OVER (ORDER BY ...)
SUM()         OVER (ORDER BY ... ROWS UNBOUNDED PRECEDING)
AVG()         OVER (PARTITION BY ...)
```

---

## 💡 Key Business Insights Enabled

| Insight | Business Value |
|:---|:---|
| 💰 Revenue-driving products | Guides pricing and promotional strategy |
| 🏆 High-value customer identification | Supports retention and loyalty investment |
| 📈 Sales growth and decline trends | Informs demand forecasting and planning |
| 📦 Best and worst-performing products | Drives inventory and assortment decisions |
| 👥 Customer segment breakdown | Enables targeted marketing campaigns |
| 🥧 Category revenue contribution | Clarifies portfolio prioritization |
| 📅 Time-based and seasonal patterns | Supports resource and budget allocation |

---

## 🛠️ Tech Stack

| Technology | Purpose |
|:---|:---|
| ![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white) | Core database engine and analytics platform |
| ![MySQL Workbench](https://img.shields.io/badge/MySQL_Workbench-4479A1?style=flat-square&logo=mysql&logoColor=white) | Query development and execution environment |
| ![Git](https://img.shields.io/badge/Git-F05032?style=flat-square&logo=git&logoColor=white) | Version control |
| ![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white) | Project repository and documentation |

---

## 📂 Project Structure

```
sql-business-analytics/
│
├── 📁 datasets/
│   └── raw business datasets (customers, products, sales)
│
├── 📁 scripts/
│   ├── 01_database_exploration.sql
│   ├── 02_dimensions_exploration.sql
│   ├── 03_date_exploration.sql
│   ├── 04_measures_exploration.sql
│   ├── 05_magnitude_analysis.sql
│   ├── 06_ranking_analysis.sql
│   ├── 07_change_over_time.sql
│   ├── 08_cumulative_analysis.sql
│   ├── 09_performance_analysis.sql
│   ├── 10_part_to_whole_analysis.sql
│   ├── 11_customer_segmentation.sql
│   └── 12_product_analysis.sql
│
├── 📁 reports/
│   ├── customer_report.sql
│   └── product_report.sql
│
├── 📁 screenshots/
│   └── analytics-roadmap.png
│
└── README.md
```

---

## 🎯 Project Objectives

1. Perform structured Exploratory Data Analysis on real-world business data
2. Apply advanced SQL techniques including window functions and CTEs
3. Analyze customer behavior, lifecycle, and value segmentation
4. Evaluate product performance across time, category, and revenue contribution
5. Identify actionable business trends, anomalies, and patterns
6. Deliver reusable, stakeholder-ready SQL analytical reports
7. Demonstrate SQL as a complete business intelligence tool — not just a query language

---

## 👨‍💻 Author

<div align="center">

*Specializing in Data Analytics · Machine Learning · Business Intelligence*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/muhammadzohaib-khan-426296366)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/m-zohaib-khan)

</div>

---

<div align="center">

*If this project was useful, consider giving it a ⭐ on GitHub*

</div>
