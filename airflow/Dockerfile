FROM apache/airflow:2.10.4

USER airflow

RUN pip install --no-cache-dir \
    pandas \
    dbt-core \
    dbt-postgres \
    airflow-dbt-python \
    psycopg2-binary \ 
    flake8    

USER root
RUN apt-get update && apt-get install -y git