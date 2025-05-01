from airflow.decorators import dag, task
from airflow.sensors.filesystem import FileSensor
from airflow.operators.python import BranchPythonOperator
from dotenv import load_dotenv
from datetime import datetime, timedelta
import pandas as pd
import os


def ingest_data():


default_parameters={
    'owner': "Mohamed Nasr",
    'retries': 0,
    "depends on past": False,
}

crm_path = "/opt/airflow/Source/source_crm"
erp_path = "/opt/airflow/Source/source_erp"

with DAG(
    dag_id = "etl_pipeline",
    description = "This is a demo dag practicing the fundementals of Apache Airflow with youtube channel coder2j",
    default_args=default_parameters,
    start_date=datetime(2025, 4, 25),
    schedule_interval='@daily',
) as dag:
    load_data = PythonOperator(
        callable_function = ingest_data
    )