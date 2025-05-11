
WITH product_info AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY prd.start_date, prd.prd_key_id) AS product_key,
        prd.product_id,
        prd.prd_key_id AS product_number,
        prd.product_name, 
        prd.category_id,
        erp.cat AS category,
        erp.subcat subcategory,
        prd.product_line,
        prd.product_cost AS cost,
        prd.start_date,
        erp.maintenance
    FROM {{source('ready_data', 'crm_prd_info')}} AS prd
    LEFT JOIN {{source('ready_data', 'erp_px_cat')}} AS erp
    ON prd.category_id = erp.id
    WHERE prd.end_date IS NULL
)

SELECT * FROM product_info