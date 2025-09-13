/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across categories.
    - To evaluate contribution to the overall total (part-to-whole).
    - Useful for A/B testing or regional comparisons.
Grain:
    - 1 row = product category
SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
Notes:
    - Percentage is returned as a string with '%' for simplicity.
      (In BI/reporting layers, it's recommended to keep it numeric.)
===============================================================================
*/

-- Which categories contribute the most to overall sales?
WITH category_sales AS (
    SELECT 
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON f.product_key = p.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    CONCAT(
        ROUND(
            (CAST(total_sales AS float) / SUM(total_sales) OVER ()) * 100, 
            2
        ), '%'
    ) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;
