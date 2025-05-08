{{
    config(
        materialized='table',
        unique_key='cid',
        indexes=[{"columns": ['cid'], "unique": true}]    
    )
}}

WITH erp_locations_cte AS (
    SELECT
        REPLACE(cid, '-', '') AS cid,
        CASE 
            WHEN trim(cntry) = 'DE' THEN 'Germany'
            WHEN trim(cntry) IN ('US', 'USA') THEN 'United States'
            WHEN trim(cntry) = '' OR cntry IS NULL THEN 'n/a'
            ELSE cntry
        END AS cntry
    FROM {{ source('raw_data', 'erp_loc_a101') }}
)

SELECT *
FROM erp_locations_cte