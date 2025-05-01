from Scripts.postgres_conn import *
from Scripts.ingestion_data import *
from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.python_operator import PythonOperator
from airflow.utils.task_group import TaskGroup
from airflow.operators.bash import BashOperator
from dotenv import load_dotenv
from datetime import datetime, timedelta
import pandas as pd
import os


load_dotenv("secrets.env")

crm_path = "/opt/Datasets/source_crm"
erp_path = "/opt/Datasets/source_erp"

def postgres_credentials():
    return {
        'host': os.getenv("POSTGRES_HOST"),
        'db_name': os.getenv("POSTGRES_DB"),
        'user': os.getenv("POSTGRES_USER"),
        'password': os.getenv("POSTGRES_PASSWORD"),
    }
    
def test_postgres_connection():
    postgres_cred = postgres_credentials()
    conn, engine = postgres_connection(**postgres_cred)
    if conn is None or engine is None:
        logging.error("PostgreSQL connection has failed!")
        raise Exception("PostgreSQL connection could not be established.")
    
    logging.info("PostgreSQL connection has successfully established!")
    close_connection(conn, engine)

def ingest_data_crm():
    
    # database connection init
    postgres_cred = postgres_credentials()
    Post_conn, Post_engine = postgres_connection(**postgres_cred)
    
    logging.info("CRM data ingestion into PostgreSQL!")
    
    crm_data = os.path.join(crm_path, "cust_info.csv")
    ingest_data(crm_data, "crm_cust_info", Post_conn, Post_engine)

    crm_products = os.path.join(crm_path, "prd_info.csv")
    ingest_data(crm_products, "crm_prd_info", Post_conn, Post_engine)

    crm_sales = os.path.join(crm_path, "sales_details.csv")
    ingest_data(crm_sales, "crm_sales_details", Post_conn, Post_engine)

    close_connection(Post_conn, Post_engine)

def ingest_data_erp():

    postgres_cred = postgres_credentials()
    Post_conn, Post_engine = postgres_connection(**postgres_cred)
    
    logging.info("ERP data ingestion into PostgreSQL!")

    erp_cus = os.path.join(erp_path, "CUST_AZ12.csv")
    ingest_data(erp_cus, "erp_cust_az12", Post_conn, Post_engine)

    erp_loc = os.path.join(erp_path, "LOC_A101.csv")
    ingest_data(erp_cus, "erp_loc_a101", Post_conn, Post_engine)

    erp_px = os.path.join(erp_path, "PX_CAT_G1V2.csv")
    ingest_data(erp_cus, "erp_px_cat_g1v2", Post_conn, Post_engine)

    close_connection(Post_conn, Post_engine)


default_parameters={
    'owner': "Mohamed Nasr",
    'retries': 0,
    "depends on past": False,
}

with DAG(
    dag_id = "sales_pipeline",
    description = "ETL Engine",
    default_args=default_parameters,
    start_date= days_ago(1),
    schedule_interval='*/15 * * * *',
    catchup=False
) as dag:
    test_connection_task = PythonOperator(
        task_id='test_postgres_conn',
        python_callable = test_postgres_connection
    )
    
    crm_ingest_data = PythonOperator(
        task_id="crm_ingest",
        python_callable = ingest_data_crm
    )
    
    erp_ingest_data = PythonOperator(
        task_id="erp_ingest",
        python_callable = ingest_data_erp
    )
    
test_connection_task >> [crm_ingest_data, erp_ingest_data]