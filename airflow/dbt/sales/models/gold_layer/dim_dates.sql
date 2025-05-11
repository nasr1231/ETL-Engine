

WITH dates AS (
    SELECT order_date AS ord_date_value FROM{{source('ready_data', 'crm_sales_details')}}
    UNION 
    SELECT ship_date FROM {{source('ready_data', 'crm_sales_details')}}
    UNION 
    SELECT due_date FROM{{source('ready_data', 'crm_sales_details')}}
),
date_dim_cte AS (
    SELECT  
        DISTINCT ord_date_value AS date_value,
        MD5(CAST(ord_date_value AS TEXT)) AS date_key,
        EXTRACT(YEAR FROM ord_date_value) AS year,
        EXTRACT(MONTH FROM ord_date_value) AS month,
        EXTRACT(DAY FROM ord_date_value) AS day,
        EXTRACT(QUARTER FROM ord_date_value) AS quarter,
        TO_CHAR(ord_date_value, 'FMDay') AS day_name,
        TO_CHAR(ord_date_value, 'FMMonth') AS month_name
    FROM dates    
)

SELECT
    * 
FROM date_dim_cte
WHERE date_value IS NOT NULL OR date_key IS NOT NULL