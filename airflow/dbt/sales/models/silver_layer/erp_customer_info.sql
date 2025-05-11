{{
    config(
        materialized='table',
        unique_key='cid',
        indexes=[{"columns": ['cid'], "unique": true}]
    )
}}

with erp_customers_cte as(
    SELECT
        CASE 
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4)
            ELSE cid
        END AS cid,
        CASE 
            WHEN bdate > CURRENT_DATE THEN NULL
            WHEN bdate < '1924-12-31' THEN NULL
            ELSE bdate
        END AS bdate,        
        
        CASE 
            WHEN UPPER(TRIM(gen)) = 'FEMALE' THEN 'Female' 
            WHEN UPPER(TRIM(gen)) = 'F' THEN 'Female' 
            WHEN UPPER(TRIM(gen)) = 'MALE' THEN 'Male' 
            WHEN UPPER(TRIM(gen)) = 'M' THEN 'Male'
            ELSE 'N/A'
        END AS gender    
    FROM {{ source('raw_data', 'erp_cust_az12') }}
)

SELECT * FROM erp_customers_cte