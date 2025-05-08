{{
    config(
        materialized='table',
        unique_key='id',
        indexes=[{"columns": ['id'], "unique": true}]
    )
}}


SELECT
    id,
    cat,
    subcat,
    maintenance
FROM {{ source('raw_data', 'erp_px_cat_g1v2') }}