{{
    config(
        materialized='table'
    )
}}

with sales_cte as (
    SELECT 
        sls_ord_num AS order_number,
        sls_prd_key AS product_key,
        sls_cust_id AS customer_id,
        CASE 
            WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt::TEXT) != 8 THEN NULL
            ELSE TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')
        END AS order_date,

        CASE 
            WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt::TEXT) != 8 THEN NULL
            ELSE TO_DATE(sls_ship_dt::TEXT, 'YYYYMMDD')
        END AS ship_date,

        CASE 
            WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt::TEXT) != 8 THEN NULL
            ELSE TO_DATE(sls_due_dt::TEXT, 'YYYYMMDD')
        END AS due_date,

        CASE 
            WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales
        END AS sales_amount,
        sls_quantity AS quantity,
        CASE 
            WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
            ELSE sls_price
        END AS unit_price
    FROM {{ source('raw_data', 'crm_sales_details') }}
)

SELECT * FROM sales_cte