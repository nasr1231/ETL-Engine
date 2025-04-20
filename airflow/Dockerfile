FROM apache/airflow:2.10.4

USER root
RUN apt-get update && apt-get install -y git

RUN pip install --upgrade pip && \
    pip install \
        apache-airflow-providers-postgres \              
        dbt-airflow \
        dbt-core \
        dbt-postgres

USER airflow