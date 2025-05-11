
WITH customer_info AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY crm_cust.ID) AS customer_number,
        crm_cust.ID as customer_id,
        crm_cust.customer_key,
        crm_cust.firstname AS first_name,
        crm_cust.lastname AS last_name,
        CASE WHEN crm_cust.gender != 'N/A' THEN crm_cust.gender
            ELSE COALESCE(erp_cust.gender, 'N/A')
        END AS gender,
        crm_cust.marital_status,
        erp_cust.bdate AS birth_date,        
        erp_loc.cntry AS country
    FROM {{source('ready_data', 'crm_cust_info')}} AS crm_cust
    LEFT JOIN {{source('ready_data', 'erp_customer_info')}} AS erp_cust
    ON crm_cust.customer_key = erp_cust.cid
    LEFT JOIN {{source('ready_data', 'erp_customer_locations')}} AS erp_loc
    ON crm_cust.customer_key = erp_loc.cid
)

SELECT *
FROM customer_info