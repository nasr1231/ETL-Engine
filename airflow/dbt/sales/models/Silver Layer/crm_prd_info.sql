{{
    config(
        unique_key='prd_id',
        indexes=[{"columns": ['prd_id'], "unique": true}],
        target_schema = 'silver'
    )
}}

with products_info as(
    SELECT 
        prd_id,
        prd_key,
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cateogry_id,
        SUBSTRING(prd_key, 7, LEN(SUBSTRING(prd_key, 1, 5))) AS product_id,
        prd_nm, 
        ISNULL(prd_cost, 0), 
        CASE UPPER(prd_line)
            WHEN 'M' THEN  'Mountain'
            WHEN 'R' THEN  'Road'
            WHEN 'T' THEN  'Touring'
            WHEN 'S' THEN  'Other Salse'
            ELSE  'N/A'
        END AS prd_line,
        CAST(p.prd_start_dt AS DATE) AS start_date,
        CAST(LEAD(p.prd_start_dt) OVER (PARTITION BY p.prd_key ORDER BY p.prd_start_dt) - INTERVAL '1 DAY' AS DATE) AS end_date
    FROM bronze.crm_prd_info
)