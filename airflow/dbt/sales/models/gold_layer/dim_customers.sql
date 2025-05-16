
WITH customer_info AS (
    SELECT         
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
    FROM {{ref('crm_cust_info')}} AS crm_cust
    LEFT JOIN {{ref('erp_customer_info')}} AS erp_cust
    ON crm_cust.customer_key = erp_cust.cid
    LEFT JOIN {{ref('erp_customer_locations')}} AS erp_loc
    ON crm_cust.customer_key = erp_loc.cid
)

SELECT *
FROM customer_info