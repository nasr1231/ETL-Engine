# ETL-engine
![DWH Architecture Diagram](Reporting-Layer/Images/DWH-architecture.png)

## 📑 Table of Contents
1. [Introduction](#introduction)  
2. [Used Technologies & Tools](#used-technologies--tools)  
3. [Data Lineage](#data-lineage)  
4. [Pipeline Architecture](#pipeline-architecture)  
5. [DBT Models Transformation](#dbt-models-transformation)  
6. [Data Catalog](#data-catalog)  
7. [Data Warehouse Data Modeling Schema](#data-warehouse-data-modeling-schema)  
8. [Reporting](#reporting)  

---

## 🧩 Introduction

This project utilizes data from two different sources (**CRM** and **ERP**), which provide detailed datasets about sales transactions, including customer information, products, locations, and more.  
These datasets are transformed and stored in a **Data Warehouse** using the **Medallion architecture** to structure the data efficiently for analytics.  
I applied **DBT (Data Build Tool)** in the ETL pipeline to transform raw data into analytics-ready datasets, ensuring high-quality and optimized data models for reporting and business intelligence.

---

## 🛠️ Used Technologies & Tools

- **Docker**: To containerize and standardize the development environment.  
- **Python**: For scripting tasks and automating data processes.  
- **PostgreSQL**: Acted as the data warehouse.
- **pgAdmin**: A graphical user interface to interact with the PostgreSQL database, inspect data, validate transformations, and execute SQL queries during development and testing.
- **Airflow**: Managed and scheduled ETL workflows.  
- **DBT (Data Build Tool)**: Handled the transformation and building of data models within the warehouse.  
- **Power BI**: Delivered the final insights through interactive dashboards and visual reports.  

---

## 🏗️ Pipeline Architecture

![DWH Architecture Diagram](Reporting-Layer/Images/pipeline-architecture.png)
---

## Docker Setup 
To ensure consistency, reusability, and easy environment setup across all tools used in this project, I utilized Docker and Docker Compose to build a fully integrated ETL development environment.

### 🔧 Custom Dockerfile
A custom Docker image `engine-airflow-custom:latest` was created based on apache/airflow:2.10.4 to include all necessary libraries used in the ETL pipeline and DBT transformations:
```bash
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

```
For detailed settings and the full configuration for `volumes`, `Networks`, and the working tools, please refer to the docker-compose.yml file in the repository here: 
[docker compose file](airflow/docker-compose.yml)

---

## 🏗️ DAG Overview

The ETL pipeline is orchestrated by Apache Airflow using the TaskFlow API and Bash Operators, with a focus on modular ingestion, transformation, and testing for CRM and ERP data sources.

![ETL DAG](Reporting-Layer/Images/dag-graph.jpg)

![ETL DAG](Reporting-Layer/Images/min-dag-graph.png)

### 🔧 DAG Overview: sales_pipeline
This DAG is responsible for extracting, transforming, and loading sales-related data into a PostgreSQL database, then applying DBT models to transform the data into clean dimensional layers.
See More: [Pipeline.py](airflow/dags/pipeline.py)

## 🔄 DBT Models Transformation

The transformation layer of this ETL pipeline is implemented using **DBT (Data Build Tool)** to structure and optimize raw data for analytics and reporting purposes. The transformation process follows a layered approach using the **Medallion Architecture**, specifically focusing on the **Silver** and **Gold** layers.

### 🪙 Silver Layer (Cleaned & Structured Data)

In the **Silver layer**, raw data from the **Bronze layer** (which consists of six tables sourced from CRM and ERP systems) is cleaned, standardized, and structured.

**Bronze Layer Tables:**
- `crm_cust_info`
- `crm_prd_info`  
- `crm_sales_details`
- `erp_cust_az12`
- `erp_loc_a101`
- `erp_px_cat_g1v2`       

**Transformed into Silver Layer Tables:**
- `crm_cust_info` *(retained with cleaning and standardization)*
- `crm_prd_info` *(retained with cleaning and standardization)*
- `crm_sales_details` *(retained with cleaning and standardization)*
- `erp_customer_info` *(from `erp_cust_az12`)*
- `erp_customer_locations` *(from `erp_loc_a101`)*
- `erp_px_cat` *(from `erp_px_cat_g1v2`)*

These models act as structured, reliable datasets for dimensional modeling.

### 🥇 Gold Layer (Analytics-ready Models)

In the **Gold layer**, I built analytical models in the form of **fact** and **dimension** tables:

- `dim_products`: Product dimension derived from both CRM and ERP.
- `dim_customers`: Unified customer dimension.
- `dim_dates`: Calendar dimension for time-based analysis.
- `fact_sales`: Central fact table representing enriched sales transactions.

> This layered approach ensures clean separation of concerns, maintainability, and performance optimization in analytics workflows.

---

## 📊 Data Lineage
![Minimized ETL Pipeline Tasks](Reporting-Layer/Images/data-lineage.png)

## 📚 Data Catalog
*Coming Soon*

## 🗂️ Data Warehouse Data Modeling Schema
![Minimized ETL Pipeline Tasks](Reporting-Layer/Images/mapping.png)

## 📈 Reporting
*Coming Soon*

