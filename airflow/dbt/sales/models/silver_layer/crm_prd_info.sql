{{
    config(
        materialized='table',
        unique_key='product_id',
        indexes=[{"columns": ['product_id'], "unique": true}]
    )
}}

with products_info as (
    SELECT 
        *, 
        row_number() OVER (PARTITION BY prd_id ORDER BY prd_start_dt DESC) AS last_update        
    FROM {{ source('raw_data', 'crm_prd_info') }}
)

SELECT 
    prd_id AS product_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS category_id,
    SUBSTRING(prd_key, 7, LENGTH(SUBSTRING(prd_key, 1, 5))) AS prd_key_id,
    prd_nm AS product_name, 
    COALESCE(prd_cost, 0) AS product_cost, 
    CASE 
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN  'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN  'Road'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN  'Touring'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN  'Other Sales'
        ELSE  'N/A'
    END AS product_line,
    CAST(prd_start_dt AS DATE) AS start_date,
    CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL '1 DAY' AS DATE) AS end_date
FROM products_info
WHERE last_update = 1 and prd_id is not null