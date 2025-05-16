
WITH fact_sales AS(
    SELECT        
        sls.order_number,
        prd.product_key,        
        cust.customer_key,
        od.date_key AS key_order_date,
        sd.date_key AS key_ship_date,
        dd.date_key AS key_due_date,
        sls.sales_amount,
        sls.quantity,
        sls.unit_price

    FROM {{ref('crm_sales_details')}} AS sls    
    LEFT JOIN {{ref('dim_customers')}} AS cust   
        ON sls.customer_id = cust.customer_id
    LEFT JOIN {{ref('dim_products')}} AS prd   
        ON sls.product_key = prd.product_number    
    LEFT JOIN {{ref('dim_dates')}} AS od
        ON sls.order_date = od.date_value 
    LEFT JOIN {{ref('dim_dates')}} AS sd
        ON sls.ship_date = sd.date_value 
    LEFT JOIN {{ref('dim_dates')}} AS dd
        ON sls.due_date = dd.date_value 
)

SELECT * FROM fact_sales