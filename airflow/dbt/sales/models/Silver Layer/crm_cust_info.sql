{{ 
    config(        
        unique_key='ID',
        indexes=[{"columns": ['ID'], "unique": true}],
        target_schema = 'silver',
    ) 
}}


with customer_info as (
    SELECT 
        *, 
        row_number() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS last_update
    FROM {{ source('raw_data', 'crm_cust_info') }}
)

SELECT 
    cst_id AS ID,
    cst_key AS Customer_key,
    TRIM(cst_firstname) as Firstname,
    TRIM(cst_lastname) as Lastname,
    CASE 
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single' 
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married' 
        ELSE  'N/A'
    END AS Marital_status,

    CASE 
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female' 
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male' 
        ELSE  'N/A'
    END AS Gendr,
    cst_create_date
FROM customer_info
WHERE last_update = 1 and cst_id is not null